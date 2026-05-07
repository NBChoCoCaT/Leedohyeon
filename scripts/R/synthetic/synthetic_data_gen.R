# =============================================================================
# synthetic_data_gen.R — Step 4 P5 (Plan: gleaming-juggling-frost.md)
#
# AEA DCAS v1.0 4-요건 (iii): synthetic FHES generator for code-only
# verification by AEA Data Editor / referees without MDIS access to the
# restricted Farm Household Economic Survey (FHES) microdata.
#
# Hybrid strategy (per AskUserQuestion 2026-05-07):
#   - Calibration JSON (privacy-friendly aggregated stats) extracted ONCE from
#     raw .dta by explorations/2026-05-07_p5-calibration/extract_calibration.R
#   - This generator reads ONLY calibration.json (no raw access required)
#   - Outputs 14,474 synthetic farm-year observations preserving:
#       (a) panel structure  : 3,614 households × {1..5} years
#       (b) cutoff density   : continuity of rv_2018 at 0
#       (c) covariate moments: per-cell (D × year) mean / sd
#       (d) negative outcomes: y_farm_income mixture (~23.55% negative)
#       (e) imputed_payment  : deterministic formula (01_cleaning.do:420-426)
#       (f) ATT (implicit)   : encoded in cell-level mean differences
#                              → reghdfe recovers Spec A T3 ATT within MC noise
#
# Run:
#   Rscript scripts/R/synthetic/synthetic_data_gen.R [--seed 20260507]
#
# Outputs (data/synthetic/, gitignored — regenerate before use):
#   synthetic_panel.dta   (Stata 14, FHES variable names)
#   synthetic_panel.csv   (universal)
#   synthetic_panel.rds   (R-native)
#
# Cross-references:
#   - CLAUDE.md §Goal §Replication standard
#   - .claude/agents/domain-reviewer.md E-7 (referee perspective)
#   - quality_reports/specs/2026-05-07_outlier-policy.md (raw values, no transform)
# =============================================================================

suppressPackageStartupMessages({
  library(haven)
  library(dplyr)
  library(jsonlite)
})

# ---- Path resolution -------------------------------------------------------
# Generator must run from the project root. Resolve via commandArgs (Rscript).
resolve_root <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
  if (length(file_arg) > 0 && nzchar(file_arg[1])) {
    here <- dirname(normalizePath(file_arg[1], mustWork = TRUE))
    list(HERE = here,
         ROOT = normalizePath(file.path(here, "..", "..", ".."), mustWork = TRUE))
  } else {
    root <- normalizePath(getwd(), mustWork = TRUE)
    list(HERE = file.path(root, "scripts/R/synthetic"), ROOT = root)
  }
}
.p   <- resolve_root()
HERE <- .p$HERE
ROOT <- .p$ROOT

CALIB_PATH <- file.path(HERE, "calibration.json")
OUT_DIR    <- file.path(ROOT, "data/synthetic")
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# ---- Seed ------------------------------------------------------------------
SEED <- 20260507L
args <- commandArgs(trailingOnly = TRUE)
seed_arg <- grep("^--seed", args, value = TRUE)
if (length(seed_arg) > 0) SEED <- as.integer(sub("^--seed[= ]?", "", seed_arg[1]))
set.seed(SEED)
message("Seed: ", SEED)

# ---- Read calibration ------------------------------------------------------
if (!file.exists(CALIB_PATH)) {
  stop("calibration.json not found at: ", CALIB_PATH,
       "\nRun explorations/2026-05-07_p5-calibration/extract_calibration.R first.")
}
calib <- fromJSON(CALIB_PATH, simplifyVector = FALSE)
message("Calibration schema_version: ", calib$schema_version,
        " (extracted ", calib$extraction_date, ")")

# ---- 1. Household IDs + panel structure ------------------------------------
# Distribution: y1=382, y2=363, y3=327, y4=325, y5=2,217 → 3,614 farms / 14,474 obs
n_hh        <- as.integer(calib$panel$n_households)
years_avail <- unlist(calib$panel$years)
ypd         <- calib$panel$obs_per_household_distribution

# Build n_years per household (replicate counts)
y_count_vec <- c(rep(1L, ypd$y1), rep(2L, ypd$y2), rep(3L, ypd$y3),
                 rep(4L, ypd$y4), rep(5L, ypd$y5))
stopifnot(length(y_count_vec) == n_hh)

# Random assignment of n_years to each household
y_count_per_hh <- sample(y_count_vec, n_hh, replace = FALSE)

# For each household, pick the consecutive year-window of size n_years
# (preserves panel attrition pattern: some farms drop out, others enter late)
build_panel_rows <- function(hh, y_count) {
  start_year <- sample(years_avail[1]:(years_avail[length(years_avail)] - y_count + 1L), 1L)
  data.frame(
    hhid_num = hh,
    year     = seq.int(start_year, length.out = y_count),
    stringsAsFactors = FALSE
  )
}

panel <- do.call(rbind, Map(build_panel_rows,
                            hh      = seq_len(n_hh),
                            y_count = y_count_per_hh))

stopifnot(nrow(panel) == sum(y_count_per_hh))
message("  Panel: ", nrow(panel), " obs / ", n_hh, " households")

# ---- 2. Running variable rv_2018 (household-level, time-invariant) ---------
# Generated via inverse-CDF on calibration quantiles (linear interpolation).
# Boundary handling: extend to min/max with linear extrapolation past q01/q99.
quantiles  <- calib$rv_2018$quantiles
# Keys are "q01", "q05", ..., "q99" — strip "q" and divide by 100
q_probs    <- as.numeric(sub("q", "", names(quantiles))) / 100
q_values   <- as.numeric(unlist(quantiles))
stopifnot(!any(is.na(q_probs)), !any(is.na(q_values)))

# Append 0 → min, 1 → max as boundary anchors
q_full_p   <- c(0, q_probs, 1)
q_full_v   <- c(calib$rv_2018$min, q_values, calib$rv_2018$max)

# Inverse CDF function
rv_inverse_cdf <- approxfun(q_full_p, q_full_v, method = "linear",
                            yleft = calib$rv_2018$min,
                            yright = calib$rv_2018$max)

# Sample one rv_2018 per household
u           <- runif(n_hh)
rv_2018_hh  <- rv_inverse_cdf(u)

# Time-invariant treatment dummy: D = 1 if rv_2018 ≤ 0
D_hh        <- as.integer(rv_2018_hh <= 0)

# Verify fraction_treated approximately matches calibration
mean_D_synth <- mean(D_hh)
target_D     <- as.numeric(calib$rv_2018$fraction_treated)
message(sprintf("  rv_2018 sampled: mean=%.0f, sd=%.0f, fraction_treated=%.4f (target %.4f)",
                mean(rv_2018_hh), sd(rv_2018_hh), mean_D_synth, target_D))

# Broadcast household-level rv_2018 / D to panel rows
panel$rv_2018  <- rv_2018_hh[panel$hhid_num]
panel$D        <- D_hh[panel$hhid_num]
panel$area_2018 <- panel$rv_2018 + 5000  # invert centering
# area_total: deterministic from area_2018 (assumes no time variation in area)
# In real FHES, area_total can vary year-to-year; we approximate with area_2018.
panel$area_total <- panel$area_2018

# ---- 3. Outcome generation (per-cell mean/sd → distribution) ---------------
# Convert per-cell mean/sd into log-normal parameters for non-negative outcomes
# (y_farm_cost, y_off_income, y_consump). For y_farm_income (~23.55% negative),
# use Gaussian per-cell which naturally produces negatives proportional to CV.
#
# Note on ATT: cell-level means already encode the empirical treatment effect.
# A reduced-form DiD-RD on this synthetic data will recover the calibration
# ATT (Spec A T3) within Monte Carlo noise. NO explicit ATT injection needed.

lnorm_params <- function(mean_x, sd_x) {
  if (is.null(mean_x) || is.null(sd_x) ||
      length(mean_x) == 0L || length(sd_x) == 0L ||
      is.na(mean_x) || is.na(sd_x) ||
      mean_x <= 0 || sd_x <= 0) {
    return(list(meanlog = NA_real_, sdlog = NA_real_))
  }
  sigma2 <- log1p(sd_x^2 / mean_x^2)
  list(meanlog = log(mean_x) - sigma2 / 2, sdlog = sqrt(sigma2))
}

sample_cell_lnorm <- function(n, mean_x, sd_x) {
  p <- lnorm_params(mean_x, sd_x)
  if (is.na(p$meanlog)) return(rep(NA_real_, n))
  rlnorm(n, p$meanlog, p$sdlog)
}

sample_cell_gauss <- function(n, mean_x, sd_x) {
  if (is.na(mean_x) || is.na(sd_x)) return(rep(NA_real_, n))
  rnorm(n, mean_x, sd_x)
}

# Per-cell Bernoulli mixture: when a cell has both negatives and positives,
# the calibration JSON exposes mixture$ params {fraction_negative,
# negative_branch{mean_abs,sd_abs}, positive_branch{mean,sd}}. We sample
# Bernoulli(p_neg) → if 1, draw -log_normal from negative branch; else draw
# +log_normal from positive branch. This preserves both the cell mean (within
# rounding) and the cell-level fraction_negative — the key marginal property.
sample_cell_mixture <- function(n, mixture) {
  p_neg <- as.numeric(mixture$fraction_negative)
  is_neg <- runif(n) < p_neg
  out <- numeric(n)

  if (any(is_neg)) {
    nb <- mixture$negative_branch
    p  <- lnorm_params(as.numeric(nb$mean_abs), as.numeric(nb$sd_abs))
    out[is_neg] <- -rlnorm(sum(is_neg), p$meanlog, p$sdlog)
  }
  if (any(!is_neg)) {
    pb <- mixture$positive_branch
    p  <- lnorm_params(as.numeric(pb$mean), as.numeric(pb$sd))
    out[!is_neg] <- rlnorm(sum(!is_neg), p$meanlog, p$sdlog)
  }
  out
}

# Vectorized: group by cell, sample en bloc. distribution ∈ {"lnorm", "mixture"}.
# For each obs we choose between LOCAL (|rv|≤LOCAL_BW) and FULL cell stats:
# this is the key knob that lets a within-bandwidth DiD-RD on synthetic
# recover the local RD effect rather than the gross D-difference.
LOCAL_BW <- as.numeric(calib$outcomes_local_to_cutoff$bandwidth_m2)
message("  Using local-to-cutoff cell stats within |rv| ≤ ", LOCAL_BW,
        " (full-sample stats outside)")

generate_outcome_vec <- function(panel_in, outcome_name,
                                 distribution = c("lnorm", "mixture")) {
  distribution <- match.arg(distribution)
  cells_full   <- calib$outcomes[[outcome_name]]$by_treat_year
  cells_local  <- calib$outcomes_local_to_cutoff$by_outcome[[outcome_name]]$by_treat_year
  vals         <- numeric(nrow(panel_in))

  in_window   <- abs(panel_in$rv_2018) <= LOCAL_BW
  cell_keys   <- sprintf("D%d_y%d", panel_in$D, panel_in$year)

  draw_from <- function(cells_use, idx_set) {
    sub_keys <- cell_keys[idx_set]
    for (key in unique(sub_keys)) {
      cell <- cells_use[[key]]
      idx  <- idx_set[sub_keys == key]
      if (is.null(cell) || is.na(cell$mean)) {
        vals[idx] <<- NA_real_
        next
      }
      vals[idx] <<- if (distribution == "mixture" && !is.null(cell$mixture)) {
        sample_cell_mixture(length(idx), cell$mixture)
      } else {
        sample_cell_lnorm(length(idx), cell$mean, cell$sd)
      }
    }
  }

  draw_from(cells_local, which( in_window))
  draw_from(cells_full,  which(!in_window))
  vals
}

message("Generating outcomes (per-cell distributions)...")
panel$y_farm_cost   <- generate_outcome_vec(panel, "y_farm_cost",   "lnorm")
panel$y_off_income  <- generate_outcome_vec(panel, "y_off_income",  "mixture")  # 0.97% neg
panel$y_consump     <- generate_outcome_vec(panel, "y_consump",     "lnorm")
panel$y_farm_income <- generate_outcome_vec(panel, "y_farm_income", "mixture")  # 23.55% neg

# ---- 4. imputed_payment (deterministic formula, 01_cleaning.do:420-426) ----
compute_imputed_payment <- function(area_total, year) {
  ip <- rep(NA_real_, length(area_total))
  ok <- !is.na(area_total)
  ip[ok & area_total <  5000]                       <- 1200000
  ip[ok & area_total >=  5000 & area_total < 20000] <- (area_total[ok & area_total >=  5000 & area_total < 20000] / 10000) * 2050000
  ip[ok & area_total >= 20000 & area_total < 60000] <- (area_total[ok & area_total >= 20000 & area_total < 60000] / 10000) * 1970000
  ip[ok & area_total >= 60000]                      <- (area_total[ok & area_total >= 60000] / 10000) * 1890000
  ip[year <= 2019]                                  <- 0
  ip
}

panel$imputed_payment <- compute_imputed_payment(panel$area_total, panel$year)

# ---- 5. Validation ---------------------------------------------------------
message("\n--- Validation ---")
val <- list()

val$n_obs            <- nrow(panel)
val$n_obs_target     <- as.integer(calib$panel$n_obs)
val$n_obs_within_1pc <- abs(val$n_obs - val$n_obs_target) / val$n_obs_target < 0.01

val$n_households            <- length(unique(panel$hhid_num))
val$n_households_target     <- n_hh
val$n_households_match      <- val$n_households == val$n_households_target

val$mean_D       <- mean(panel$D)
val$mean_D_target <- target_D
val$mean_D_within <- abs(val$mean_D - val$mean_D_target) < 0.02

# D time-invariance per household
d_per_hh <- panel %>% group_by(hhid_num) %>% summarise(d_var = var(D), .groups = "drop")
val$D_time_invariant <- all(d_per_hh$d_var == 0 | is.na(d_per_hh$d_var))

# fraction_negative for y_farm_income
val$frac_neg_yfi        <- mean(panel$y_farm_income < 0, na.rm = TRUE)
val$frac_neg_yfi_target <- as.numeric(calib$outcomes$y_farm_income$fraction_negative)
val$frac_neg_yfi_within <- abs(val$frac_neg_yfi - val$frac_neg_yfi_target) < 0.05

# imputed_payment: zero in pre-period, non-missing in post for all
val$ip_zero_pre  <- all(panel$imputed_payment[panel$year <= 2019] == 0, na.rm = TRUE)
val$ip_nonmiss_post <- all(!is.na(panel$imputed_payment[panel$year >= 2020]))

# Print + assert
print_check <- function(label, ok, detail = "") {
  status <- if (isTRUE(ok)) "✓" else "✗"
  msg    <- sprintf("  %s %-40s %s", status, label, detail)
  message(msg)
  ok
}

ok <- TRUE
ok <- print_check("N obs within 1% of target",      val$n_obs_within_1pc,
                  sprintf("(%d vs target %d)", val$n_obs, val$n_obs_target)) && ok
ok <- print_check("N households exact match",       val$n_households_match,
                  sprintf("(%d vs %d)", val$n_households, val$n_households_target)) && ok
ok <- print_check("mean(D) within 0.02 of target",  val$mean_D_within,
                  sprintf("(%.4f vs %.4f)", val$mean_D, val$mean_D_target)) && ok
ok <- print_check("D time-invariant per household", val$D_time_invariant) && ok
ok <- print_check("y_farm_income fraction_neg ±0.05", val$frac_neg_yfi_within,
                  sprintf("(%.4f vs %.4f)", val$frac_neg_yfi, val$frac_neg_yfi_target)) && ok
ok <- print_check("imputed_payment = 0 pre-2020",   val$ip_zero_pre) && ok
ok <- print_check("imputed_payment non-missing post-2020", val$ip_nonmiss_post) && ok

if (!ok) stop("Validation failed — see ✗ entries above.")

# ---- 6. Write outputs ------------------------------------------------------
# Final column order (FHES raw names, ready for 01_clean.R rename per
# r-code-conventions §10).
out <- panel %>%
  select(hhid_num, year, D, rv_2018, area_2018, area_total,
         y_farm_cost, y_off_income, y_consump, y_farm_income,
         imputed_payment) %>%
  arrange(hhid_num, year)

# Add Stata variable labels for .dta clarity
attr(out$hhid_num,        "label") <- "Household ID (synthetic)"
attr(out$year,            "label") <- "Survey year"
attr(out$D,               "label") <- "Treatment (rv_2018 <= 0)"
attr(out$rv_2018,         "label") <- "Running variable, ㎡ centered at 5000"
attr(out$area_2018,       "label") <- "2018 baseline area, ㎡"
attr(out$area_total,      "label") <- "Total cultivated area, ㎡"
attr(out$y_farm_cost,     "label") <- "농업경영비, KRW"
attr(out$y_off_income,    "label") <- "농외소득, KRW"
attr(out$y_consump,       "label") <- "가계소비지출, KRW"
attr(out$y_farm_income,   "label") <- "농업소득, KRW"
attr(out$imputed_payment, "label") <- "Imputed 공익직불금, KRW"

dta_path <- file.path(OUT_DIR, "synthetic_panel.dta")
csv_path <- file.path(OUT_DIR, "synthetic_panel.csv")
rds_path <- file.path(OUT_DIR, "synthetic_panel.rds")

write_dta(out, dta_path, version = 14L)
write.csv(out, csv_path, row.names = FALSE)
saveRDS(out,    rds_path)

message("\n✓ Synthetic FHES written to ", OUT_DIR)
for (p in c(dta_path, csv_path, rds_path)) {
  message(sprintf("  - %-40s (%6.0f KB)", basename(p), file.info(p)$size / 1024))
}

# ---- 7. Provenance footer --------------------------------------------------
message("\nNext step: run scripts/R/synthetic/verify_recovery.R to confirm")
message("ATT recovery within tolerance vs calibration.json known_att.")
