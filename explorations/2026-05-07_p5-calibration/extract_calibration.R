# =============================================================================
# extract_calibration.R — Phase 1 of Step 4 P5 (Plan: gleaming-juggling-frost)
#
# Reads master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta and
# writes _outputs/calibration_preview.json with privacy-friendly aggregated
# statistics that the synthetic data generator will read.
#
# Privacy guards (per plan §Phase 1):
#   - KRW quantiles / means / SDs rounded to 1만원 (10,000 KRW) units
#   - Area (rv_2018, ㎡) quantiles rounded to 100 ㎡
#   - Mean/SD reported to 4 significant figures
#   - Cells with N < 10 obs suppressed
#   - No individual identifiers (hh_id, sgg_cd) ever written
# =============================================================================

suppressPackageStartupMessages({
  library(haven)
  library(dplyr)
  library(jsonlite)
  library(digest)
})

# ---- Paths -----------------------------------------------------------------
# Resolve script location via commandArgs (works under Rscript). Fallback to
# fixed sandbox path if launched in a non-Rscript context.
SANDBOX_REL <- "explorations/2026-05-07_p5-calibration"

resolve_root <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
  if (length(file_arg) > 0 && nzchar(file_arg[1])) {
    here <- dirname(normalizePath(file_arg[1], mustWork = TRUE))
    return(list(HERE = here,
                ROOT = normalizePath(file.path(here, "..", ".."), mustWork = TRUE)))
  }
  # Interactive fallback: assume CWD == project root
  root <- normalizePath(getwd(), mustWork = TRUE)
  list(HERE = file.path(root, SANDBOX_REL), ROOT = root)
}
.p   <- resolve_root()
HERE <- .p$HERE
ROOT <- .p$ROOT
DTA_PATH  <- file.path(ROOT, "master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta")
LOG_PATH  <- file.path(ROOT, "master_supporting_docs/own_drafts/stata_analysis/02_analysis.log")
OUT_DIR   <- file.path(HERE, "_outputs")
OUT_JSON  <- file.path(OUT_DIR, "calibration_preview.json")

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# Sister parser
source(file.path(HERE, "parse_stata_log.R"))

# ---- Privacy helpers -------------------------------------------------------
round_krw <- function(x, unit = 10000) {
  if (length(x) == 0) return(x)
  ifelse(is.na(x), NA_real_, round(x / unit) * unit)
}
round_m2  <- function(x, unit = 100) {
  if (length(x) == 0) return(x)
  ifelse(is.na(x), NA_real_, round(x / unit) * unit)
}
sf <- function(x, n = 4) {
  if (length(x) == 0) return(x)
  ifelse(is.na(x) | x == 0, x, signif(x, n))
}
suppress_small <- function(value, n, min_n = 10L) {
  if (is.na(n) || n < min_n) NA else value
}

# ---- Read raw .dta ---------------------------------------------------------
message("Reading ", DTA_PATH)
df <- read_dta(DTA_PATH)
message("  rows = ", nrow(df), ", cols = ", ncol(df))

# Required columns (raw FHES names per CLAUDE.md identification snapshot)
needed <- c("hhid_num", "year", "D", "rv_2018", "area_2018",
            "y_farm_income", "y_off_income", "y_consump", "y_farm_cost")
missing_vars <- setdiff(needed, names(df))
if (length(missing_vars) > 0) {
  stop("Missing columns in .dta: ", paste(missing_vars, collapse = ", "))
}

# Cast to base types (strip haven labels for downstream stats)
df <- df %>%
  mutate(across(c(rv_2018, area_2018, y_farm_income, y_off_income,
                  y_consump, y_farm_cost),
                ~ as.numeric(.))) %>%
  mutate(D    = as.integer(D),
         year = as.integer(year))

# ---- Sanity check vs CLAUDE.md identification snapshot ---------------------
n_obs        <- nrow(df)
n_households <- n_distinct(df$hhid_num)
years        <- sort(unique(df$year))
mean_D       <- mean(df$D, na.rm = TRUE)

stopifnot(n_obs        == 14474)
stopifnot(n_households == 3614)
stopifnot(identical(years, 2018:2022))
stopifnot(abs(mean_D - 0.349) < 0.01)
message("  ✓ Identification snapshot matches (N=", n_obs,
        ", farms=", n_households, ", mean D=", round(mean_D, 4), ")")

# ---- 1. Panel structure ----------------------------------------------------
obs_per_hh <- df %>%
  count(hhid_num, name = "n_years") %>%
  count(n_years, name = "n_households")

balanced_n <- obs_per_hh$n_households[obs_per_hh$n_years == length(years)]
balanced_fraction <- if (length(balanced_n) == 0) 0 else balanced_n / n_households

panel_block <- list(
  n_households                  = n_households,
  n_obs                         = n_obs,
  years                         = as.integer(years),
  balanced_fraction             = sf(balanced_fraction, 4),
  obs_per_household_distribution = setNames(
    as.list(obs_per_hh$n_households),
    paste0("y", obs_per_hh$n_years)
  )
)

# ---- 2. Running variable: rv_2018 ------------------------------------------
# Quantile grid for inverse-CDF generation in Phase 2
rv_q_probs <- c(0.01, 0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95, 0.99)
rv_q       <- quantile(df$rv_2018, probs = rv_q_probs, na.rm = TRUE)

# Cutoff density: histogram at small bins around 0 for McCrary continuity
# Uses bins of 200 ㎡ width on each side of cutoff
rv_left  <- df$rv_2018[df$rv_2018 <= 0]
rv_right <- df$rv_2018[df$rv_2018 > 0]
left_density_at_cutoff  <- mean(rv_left  >= -200, na.rm = TRUE)  # frac just below
right_density_at_cutoff <- mean(rv_right <=  200, na.rm = TRUE)  # frac just above

# Clean quantile keys: "q01", "q05", ..., "q99" (no "%", no decimals)
rv_q_keys <- paste0("q", sprintf("%02d", as.integer(round(rv_q_probs * 100))))

rv_block <- list(
  mean             = round_m2(mean(df$rv_2018, na.rm = TRUE)),
  sd               = round_m2(sd(df$rv_2018,   na.rm = TRUE)),
  min              = round_m2(min(df$rv_2018,  na.rm = TRUE)),
  max              = round_m2(max(df$rv_2018,  na.rm = TRUE)),
  quantiles        = setNames(as.list(round_m2(rv_q)), rv_q_keys),
  fraction_treated = sf(mean_D, 4),
  cutoff_density = list(
    left_window_m2          = 200,
    right_window_m2         = 200,
    left_density_in_window  = sf(left_density_at_cutoff,  4),
    right_density_in_window = sf(right_density_at_cutoff, 4),
    n_left                  = length(rv_left),
    n_right                 = length(rv_right)
  )
)

# ---- 3. Outcomes (4 vars × distributional stats) ---------------------------
outcome_vars <- c("y_farm_cost", "y_off_income", "y_consump", "y_farm_income")

extract_outcome_stats <- function(varname, df_in) {
  x <- df_in[[varname]]
  n_total <- sum(!is.na(x))
  n_zero  <- sum(x == 0, na.rm = TRUE)
  n_neg   <- sum(x <  0, na.rm = TRUE)
  n_pos   <- sum(x >  0, na.rm = TRUE)

  # By-treat × year cell stats with small-cell suppression
  cells <- df_in %>%
    select(D, year, value = all_of(varname)) %>%
    group_by(D, year) %>%
    summarise(
      n        = sum(!is.na(value)),
      mean_val = mean(value, na.rm = TRUE),
      sd_val   = sd(value,   na.rm = TRUE),
      .groups  = "drop"
    )

  by_cell <- list()
  for (i in seq_len(nrow(cells))) {
    key <- sprintf("D%d_y%d", cells$D[i], cells$year[i])
    cell_n   <- cells$n[i]
    cell_mat <- df_in[df_in$D == cells$D[i] & df_in$year == cells$year[i], varname, drop = TRUE]
    cell_neg <- cell_mat[cell_mat < 0  & !is.na(cell_mat)]
    cell_pos <- cell_mat[cell_mat >= 0 & !is.na(cell_mat)]

    cell_entry <- list(
      n    = as.integer(cell_n),
      mean = round_krw(suppress_small(sf(cells$mean_val[i], 4), cell_n)),
      sd   = round_krw(suppress_small(sf(cells$sd_val[i],   4), cell_n))
    )

    # Per-cell mixture stats (used by generator to preserve fraction_negative
    # per cell for outcomes like y_farm_income). Only attach when BOTH
    # branches have ≥ small_cell_threshold obs — otherwise small-cell
    # suppression would emit NA mean_abs/sd_abs and the generator would have
    # nothing to sample from. Cells without mixture fall back to log-normal.
    SMALL <- 10L
    if (length(cell_neg) >= SMALL && length(cell_pos) >= SMALL) {
      cell_entry$mixture <- list(
        fraction_negative = sf(length(cell_neg) / cell_n, 4),
        negative_branch = list(
          n        = length(cell_neg),
          mean_abs = round_krw(sf(mean(abs(cell_neg)), 4)),
          sd_abs   = round_krw(sf(sd(abs(cell_neg)),   4))
        ),
        positive_branch = list(
          n    = length(cell_pos),
          mean = round_krw(sf(mean(cell_pos), 4)),
          sd   = round_krw(sf(sd(cell_pos),   4))
        )
      )
    }

    by_cell[[key]] <- cell_entry
  }

  # Overall mixture (kept for reference / sanity check; generator uses per-cell)
  mixture <- if (n_neg > 0) {
    x_neg <- x[x < 0 & !is.na(x)]
    x_pos <- x[x >= 0 & !is.na(x)]
    list(
      fraction_negative = sf(n_neg / n_total, 4),
      negative_branch = list(
        n        = length(x_neg),
        mean_abs = round_krw(suppress_small(sf(mean(abs(x_neg)), 4), length(x_neg))),
        sd_abs   = round_krw(suppress_small(sf(sd(abs(x_neg)),   4), length(x_neg)))
      ),
      positive_branch = list(
        n        = length(x_pos),
        mean     = round_krw(suppress_small(sf(mean(x_pos), 4), length(x_pos))),
        sd       = round_krw(suppress_small(sf(sd(x_pos),   4), length(x_pos)))
      )
    )
  } else {
    NULL
  }

  list(
    n               = as.integer(n_total),
    fraction_zero   = sf(n_zero / n_total, 4),
    fraction_negative = sf(n_neg / n_total, 4),
    overall = list(
      mean = round_krw(sf(mean(x, na.rm = TRUE), 4)),
      sd   = round_krw(sf(sd(x,   na.rm = TRUE), 4))
    ),
    by_treat_year = by_cell,
    mixture       = mixture
  )
}

outcomes_block <- lapply(outcome_vars, extract_outcome_stats, df_in = df)
names(outcomes_block) <- outcome_vars

# Local-to-cutoff cell means (|rv_2018| ≤ LOCAL_BW) — used by generator so
# that within-bandwidth DiD-RD on synthetic recovers the local RD effect
# rather than the full-sample D-difference (which is much larger). LOCAL_BW
# = 5,000 ㎡ encompasses all 4 outcome MSE-optimal bandwidths (max = 3,929).
LOCAL_BW <- 5000
df_local <- df[abs(df$rv_2018) <= LOCAL_BW, ]
message("  Local-to-cutoff subset (|rv| ≤ ", LOCAL_BW, "): ", nrow(df_local), " obs")

outcomes_local_block <- lapply(outcome_vars, extract_outcome_stats, df_in = df_local)
names(outcomes_local_block) <- outcome_vars

# ---- 4. Known ATT from STATA log -------------------------------------------
message("Parsing STATA log: ", LOG_PATH)
est <- parse_d_post_estimates(LOG_PATH)
message("  Found ", nrow(est), " D_Post estimates")

# Keep only headline Spec A (MSE-optimal per outcome) — Spec B is robustness
spec_a <- est %>% filter(spec == "Spec A (Full)")
message("  Spec A (Full) rows: ", nrow(spec_a))

att_block <- list(
  spec_description = paste0(
    "reghdfe y D_Post rv_Post Drv_Post if abs(rv_2018)<=h, ",
    "absorb(hhid_num year) vce(cluster hhid_num)"
  ),
  source = "stata_analysis/02_analysis.log (Spec A, MSE-optimal per outcome)",
  by_outcome = setNames(
    lapply(seq_len(nrow(spec_a)), function(k) {
      list(
        bandwidth_m2 = as.integer(spec_a$bandwidth[k]),
        coef         = round_krw(sf(spec_a$coef[k], 4)),
        se           = round_krw(sf(spec_a$se[k],   4)),
        n_obs        = as.integer(spec_a$n_obs[k]),
        n_clusters   = as.integer(spec_a$n_clusters[k])
      )
    }),
    spec_a$outcome_var
  )
)

# Also record Spec B for verifier cross-reference (no-2020 robustness)
spec_b <- est %>% filter(spec == "Spec B (no-2020)")
att_block$by_outcome_spec_b_no_2020 <- setNames(
  lapply(seq_len(nrow(spec_b)), function(k) {
    list(
      bandwidth_m2 = as.integer(spec_b$bandwidth[k]),
      coef         = round_krw(sf(spec_b$coef[k], 4)),
      se           = round_krw(sf(spec_b$se[k],   4))
    )
  }),
  spec_b$outcome_var
)

# ---- 5. Provenance ---------------------------------------------------------
dta_hash <- digest(file = DTA_PATH, algo = "sha256")

calibration <- list(
  schema_version  = "1.0",
  extraction_date = format(Sys.Date(), "%Y-%m-%d"),
  source = list(
    description   = "panel_2018_2022.dta (Statistics Korea MDIS, FHES Wave 1, 2018-2022)",
    sha256        = dta_hash,
    extracted_by  = "explorations/2026-05-07_p5-calibration/extract_calibration.R",
    plan          = "quality_reports/plans/gleaming-juggling-frost.md"
  ),
  privacy = list(
    krw_unit_rounding_won = 10000L,
    area_unit_rounding_m2 = 100L,
    significant_figures   = 4L,
    small_cell_threshold  = 10L,
    individual_ids_stored = FALSE
  ),
  panel    = panel_block,
  rv_2018  = rv_block,
  outcomes = outcomes_block,
  outcomes_local_to_cutoff = list(
    bandwidth_m2 = LOCAL_BW,
    description  = paste0("Per-cell stats restricted to |rv_2018| ≤ ",
                          LOCAL_BW, " ㎡; covers all 4 outcome MSE-optimal bws."),
    by_outcome   = outcomes_local_block
  ),
  treatment_effects_known_att = att_block
)

# ---- 6. Write JSON ---------------------------------------------------------
write_json(calibration, OUT_JSON,
           pretty = TRUE, auto_unbox = TRUE, na = "null", digits = NA)

message("\n✓ Calibration preview written to: ", OUT_JSON)
message("  size: ", file.info(OUT_JSON)$size, " bytes")
message("  Review with: cat ", sub(ROOT, ".", OUT_JSON, fixed = TRUE))
