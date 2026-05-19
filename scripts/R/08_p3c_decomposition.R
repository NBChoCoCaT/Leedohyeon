# =============================================================================
# 08_p3c_decomposition.R — P3c Phase 1: Channel 4 vs Channel 5 Empirical Decomp.
#
# Spec: quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md (APPROVED)
# Plan: quality_reports/plans/2026-05-15_p3c-phase1-implementation.md (APPROVED)
#
# Inputs (under scripts/R/_outputs/):
#   clean.rds                — panel 14,474 obs / 3,614 farms / 2018-2022
#   channels_results.rds     — ch3_exit baseline +0.1517 + ch3_area_events
#   heterogeneity_results.rds — own_bin reference (Phase 0 own_share splits)
#
# Outputs (under scripts/R/_outputs/):
#   p3c_results.rds                          — 8+ field list
#   tab_ch5_exit_definitions_{en,ko}.tex     — M1 Form A 12 cells + Form B 3 cells
#   tab_ch5_reconciliation_{en,ko}.tex       — M4 reconciliation w/ +0.1517 baseline
#   tab_ch5_area_decomposition_{en,ko}.tex   — M2 conditional vs unconditional
#   tab_ch5_attrition_profile_{en,ko}.tex    — M5 pre-policy attrition profile
#   tab_ch5_exit_heterogeneity_{en,ko}.tex   — S1 (only if scenario α)
#
# Phases:
#   0 — Load + guard
#   1 — Per-farm summary + 4 exit definitions + own_bin merge
#   2 — M1 Form A: rdrobust on cross-section (4 defs × 3 bw = 12 cells)
#   3 — M1 Form B: DiD-style pre/post stacked (3 bw = 3 cells)
#   4 — M2 Conditional area_total event-study + decomposition vs unconditional
#   5 — M3 Scenario α/β/γ classification
#   6 — M4 P3b-1 reconciliation table
#   7 — M5 Pre-policy attrition profiling embedded
#   8 — S1 own_share × exit heterogeneity (GATED on scenario α)
#   9 — Save RDS + LaTeX tables (dual-language)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(purrr)
  library(haven); library(fixest); library(rdrobust); library(broom)
  library(stringr); library(readr); library(fs); library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) {
  set.seed(PROJECT_SEED)
} else {
  set.seed(20260504L)
}

# ---------------------------------------------------------------------------- #
# Phase 0 — Load + guard
# ---------------------------------------------------------------------------- #

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
              here::here("scripts", "R", "_outputs")
stopifnot(fs::file_exists(file.path(out_dir, "clean.rds")),
          fs::file_exists(file.path(out_dir, "channels_results.rds")))

df <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))
ch <- readRDS(file.path(out_dir, "channels_results.rds"))

stopifnot(all(c("hh_id", "year", "D_treat", "rv_2018", "own_share",
                "area_total", "area_own", "area_rent") %in% names(df)))

message(sprintf("Phase 0: loaded clean.rds (%d obs) + channels_results.rds (%d fields).",
                nrow(df), length(ch)))

# ---------------------------------------------------------------------------- #
# Phase 1 — Per-farm summary + 4 exit definitions + own_bin merge
# ---------------------------------------------------------------------------- #
# Per-farm cross-sectional collapse for exit-indicator analysis. Following
# spec §6.1-6.3 verbatim. own_bin is time-invariant from 2018 baseline,
# reused from 07_heterogeneity.R Phase 1 logic.

farm <- df |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(
    n_years     = dplyr::n_distinct(year),
    first_year  = min(year),
    last_year   = max(year),
    D_treat     = dplyr::first(D_treat),
    rv_2018     = dplyr::first(rv_2018),
    own_share_0 = mean(own_share[year == 2018L], na.rm = TRUE),
    area_2018   = dplyr::first(area_2018),
    .groups     = "drop"
  )

# 4 exit definitions per spec §6.2
farm <- farm |>
  dplyr::mutate(
    exit_def1            = as.integer(n_years < 5L),                                  # baseline
    exit_def2_raw        = as.integer(n_years < 5L & last_year >= 2020L),             # raw (includes late entrants)
    exit_def2_corrected  = as.integer(n_years < 5L &                                  # HEADLINE: policy-era only
                                       last_year %in% c(2020L, 2021L)),
    exit_def3_last_year  = last_year,                                                  # dynamic for hazard (deferred)
    exit_def4_completer  = as.integer(n_years == 5L)                                   # mirror of def1
  )

# own_bin construction — reuse 07_heterogeneity.R pattern (time-invariant 2018 baseline)
farm <- farm |>
  dplyr::mutate(
    own_bin = dplyr::case_when(
      is.nan(own_share_0) | is.na(own_share_0) ~ NA_character_,
      own_share_0 == 0    ~ "1_pure_tenant",
      own_share_0 <  0.3  ~ "2_low_owner",
      own_share_0 <  0.7  ~ "3_mixed",
      own_share_0 <  1    ~ "4_high_owner",
      own_share_0 == 1    ~ "5_pure_owner",
      TRUE                ~ NA_character_
    )
  )

.elig <- exists("ELIGIBILITY_SUBSET", inherits = FALSE) && isTRUE(ELIGIBILITY_SUBSET)
stopifnot(nrow(farm) == if (.elig) 3420L else 3614L)
n_bin <- sum(!is.na(farm$own_bin))
message(sprintf("Phase 1: %d farms; own_bin assigned to %d (%.1f%%).",
                nrow(farm), n_bin, 100 * n_bin / nrow(farm)))
message(sprintf("  Def 1 (n<5)=%d | Def 2 raw=%d | Def 2' corrected=%d | Def 4 completer=%d",
                sum(farm$exit_def1), sum(farm$exit_def2_raw),
                sum(farm$exit_def2_corrected), sum(farm$exit_def4_completer)))

# ---------------------------------------------------------------------------- #
# Phase 2 — M1 Form A: rdrobust on cross-section (4 defs × 3 bw = 12 cells)
# ---------------------------------------------------------------------------- #
# Per spec §7.1 Form A. Mirror existing ch3_exit (MSE-bandwidth) by adding
# T1/T2/T3 parallel reporting per project convention.

exit_defs_form_a <- c("exit_def1", "exit_def2_raw", "exit_def2_corrected", "exit_def4_completer")
bw_grid <- c(T1 = 500L, T2 = 1000L, T3 = 3300L)

fit_form_a <- function(def, bw_id) {
  h <- bw_grid[[bw_id]]
  sub <- farm |> dplyr::filter(abs(rv_2018) <= h)
  if (nrow(sub) < 30L || length(unique(sub[[def]])) < 2L) {
    return(tibble::tibble(def = def, bw_id = bw_id, h = h,
                          est = NA_real_, se = NA_real_, p = NA_real_,
                          n_obs = nrow(sub), method = "skip_low_var"))
  }
  rd <- tryCatch(
    rdrobust::rdrobust(y = sub[[def]], x = sub$rv_2018,
                       c = 0, p = 1, h = c(h, h), masspoints = "off"),
    error = function(e) NULL
  )
  if (is.null(rd)) {
    return(tibble::tibble(def = def, bw_id = bw_id, h = h,
                          est = NA_real_, se = NA_real_, p = NA_real_,
                          n_obs = nrow(sub), method = "rdrobust_failed"))
  }
  tibble::tibble(
    def    = def,
    bw_id  = bw_id,
    h      = h,
    est    = as.numeric(rd$coef["Conventional", 1]),
    se     = as.numeric(rd$se["Conventional", 1]),
    p      = as.numeric(rd$pv["Conventional", 1]),
    n_obs  = as.integer(rd$N_h[1] + rd$N_h[2]),
    method = "rdrobust"
  )
}

form_a <- tidyr::expand_grid(def = exit_defs_form_a, bw_id = names(bw_grid)) |>
  purrr::pmap_dfr(fit_form_a)

message(sprintf("Phase 2 Form A: %d cells (4 defs × 3 bw).", nrow(form_a)))
message(sprintf("  Def 2' T2 (headline): est=%+.4f, SE=%.4f, p=%.4f, N=%d",
                form_a$est[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"],
                form_a$se[form_a$def == "exit_def2_corrected"  & form_a$bw_id == "T2"],
                form_a$p[form_a$def == "exit_def2_corrected"   & form_a$bw_id == "T2"],
                form_a$n_obs[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"]))

# ---------------------------------------------------------------------------- #
# Phase 3 — M1 Form B: DiD-style pre/post stacked on cross-section
# ---------------------------------------------------------------------------- #
# Per spec §7.1 Form B. Define pre_exit = 1[last_year < 2020 & n_years < 5]
# (pre-policy attrition baseline) and post_exit = exit_def2_corrected
# (policy-era exit). Stack each farm twice and run DiD; coefficient on
# D_treat:periodpost is the differential policy-era exit net of pre baseline.

pre_exit  <- as.integer(farm$last_year < 2020L & farm$n_years < 5L)
post_exit <- farm$exit_def2_corrected

df_did <- dplyr::bind_rows(
  farm |> dplyr::transmute(hh_id, rv_2018, D_treat, period = "pre",  exit = pre_exit),
  farm |> dplyr::transmute(hh_id, rv_2018, D_treat, period = "post", exit = post_exit)
) |>
  dplyr::mutate(period_post = as.integer(period == "post"))

fit_form_b <- function(bw_id) {
  h <- bw_grid[[bw_id]]
  sub <- df_did |> dplyr::filter(abs(rv_2018) <= h)
  fit <- tryCatch(
    fixest::feols(exit ~ D_treat * period_post + rv_2018 * period_post,
                  data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit)) {
    return(tibble::tibble(bw_id = bw_id, h = h, est = NA_real_, se = NA_real_,
                          p = NA_real_, n_obs = nrow(sub), method = "feols_failed"))
  }
  td <- broom::tidy(fit)
  did_term <- td |> dplyr::filter(term == "D_treat:period_post")
  tibble::tibble(
    bw_id = bw_id, h = h,
    est   = if (nrow(did_term)) did_term$estimate  else NA_real_,
    se    = if (nrow(did_term)) did_term$std.error else NA_real_,
    p     = if (nrow(did_term)) did_term$p.value   else NA_real_,
    n_obs = nrow(sub),
    method = "feols_did"
  )
}

form_b <- tibble::tibble(bw_id = names(bw_grid)) |>
  purrr::pmap_dfr(fit_form_b)

message(sprintf("Phase 3 Form B: %d cells (3 bw, DiD pre/post stacked).", nrow(form_b)))
message(sprintf("  Form B T2 (HEADLINE causal): est=%+.4f, SE=%.4f, p=%.4f",
                form_b$est[form_b$bw_id == "T2"],
                form_b$se[form_b$bw_id == "T2"],
                form_b$p[form_b$bw_id == "T2"]))

# ---------------------------------------------------------------------------- #
# Phase 4 — M2 Conditional area_total event-study + decomposition
# ---------------------------------------------------------------------------- #
# Restrict to completers (n_years == 5) to isolate Channel 4(iii) extensive
# margin from Channel 5 selection. Compare to unconditional ch3_area_events.

completers <- farm$hh_id[farm$exit_def4_completer == 1L]
df_cond <- df |> dplyr::filter(hh_id %in% completers)
message(sprintf("Phase 4: conditional sample = %d obs (%d completer farms).",
                nrow(df_cond), length(completers)))

area_outcomes <- c("area_total", "area_own", "area_rent")

fit_area_cond <- function(y_var, bw_id) {
  h <- bw_grid[[bw_id]]
  sub <- df_cond |> dplyr::filter(abs(rv_2018) <= h)
  fml <- as.formula(sprintf("%s ~ i(year, D_treat, ref = 2019) | hh_id + year", y_var))
  fit <- fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  broom::tidy(fit, conf.int = TRUE) |>
    dplyr::filter(grepl("year::", term)) |>
    dplyr::mutate(year     = as.integer(gsub(".*year::(\\d+).*", "\\1", term)),
                  outcome  = y_var,
                  bw_label = bw_id, h = h)
}

area_conditional <- tidyr::expand_grid(y_var = area_outcomes, bw_id = names(bw_grid)) |>
  purrr::pmap_dfr(function(y_var, bw_id) fit_area_cond(y_var, bw_id))

message(sprintf("Phase 4 conditional event-study: %d rows (3 outcomes × 3 bw × 4 yr).",
                nrow(area_conditional)))

# Decomposition: unconditional vs conditional for area_total
ch3_area_uncond <- ch$ch3_area_events
area_decomp <- ch3_area_uncond |>
  dplyr::filter(outcome == "area_total") |>
  dplyr::select(year, bw_label, estimate_uncond = estimate, se_uncond = std.error,
                p_uncond = p.value) |>
  dplyr::left_join(
    area_conditional |> dplyr::filter(outcome == "area_total") |>
      dplyr::select(year, bw_label, estimate_cond = estimate, se_cond = std.error,
                    p_cond = p.value),
    by = c("year", "bw_label")
  ) |>
  dplyr::mutate(
    selection_share = dplyr::if_else(
      abs(estimate_uncond) > 1e-6,
      1 - estimate_cond / estimate_uncond,
      NA_real_
    )
  )

headline_decomp <- area_decomp |>
  dplyr::filter(bw_label == "T3", year == 2022L)
if (nrow(headline_decomp) > 0) {
  message(sprintf("  Decomposition T3 2022: uncond=%+.0f m², cond=%+.0f m², selection share=%.3f",
                  headline_decomp$estimate_uncond, headline_decomp$estimate_cond,
                  headline_decomp$selection_share))
}

# ---------------------------------------------------------------------------- #
# Phase 5 — M3 Scenario α/β/γ classification
# ---------------------------------------------------------------------------- #
# Per spec §3.1 M3 thresholds. Headline = Form A on 4 defs × Spec A T1/T2/T3
# (12 cells) + Form B 3 bw (3 cells). Classification logic operates on cells
# where the estimate is non-NA.

scenario_cells <- dplyr::bind_rows(
  form_a |> dplyr::filter(def %in% c("exit_def1", "exit_def2_corrected",
                                       "exit_def2_raw", "exit_def4_completer"),
                           bw_id %in% c("T1", "T2", "T3")) |>
            dplyr::mutate(source = "form_a", estimator = paste0(def, "/", bw_id)),
  form_b |> dplyr::mutate(source = "form_b", estimator = paste0("form_b/", bw_id),
                            def = "form_b")
)

# Headline subset: Def 2' corrected (Form A) + Form B
headline_cells <- scenario_cells |>
  dplyr::filter(def %in% c("exit_def2_corrected", "form_b"),
                !is.na(est))

n_neg_sig <- sum(headline_cells$est < 0 & headline_cells$p < 0.10, na.rm = TRUE)
n_pos_sig <- sum(headline_cells$est > 0 & headline_cells$p < 0.10, na.rm = TRUE)
n_total   <- nrow(headline_cells)

if (n_total == n_neg_sig && n_total > 0L) {
  scenario_label <- "α (Channel 5 confirmed)"
} else if (n_total == n_pos_sig && n_total > 0L) {
  scenario_label <- "γ (Channel 5 rejected — alternative narrative required)"
} else {
  scenario_label <- "β (mixed evidence)"
}

message(sprintf("Phase 5 SCENARIO: %s", scenario_label))
message(sprintf("  Headline cells: %d total | %d neg-sig (p<0.10) | %d pos-sig (p<0.10)",
                n_total, n_neg_sig, n_pos_sig))

# ---------------------------------------------------------------------------- #
# Phase 6 — M4 P3b-1 reconciliation
# ---------------------------------------------------------------------------- #
# Build 6-row table comparing existing ch3_exit baseline + new estimators.

ch3_existing <- ch$ch3_exit
reconciliation <- tibble::tibble(
  rank          = 1:6,
  estimator     = c("Existing ch3_exit (MSE) — Def 1, no pre-trend",
                    "Def 1 baseline (T2, h=1,000)",
                    "Def 2 raw (T2; includes late entrants)",
                    "Def 2' corrected (T2) [Form A HEADLINE]",
                    "Def 2' Form B (T2) [DiD pre-trend control HEADLINE]",
                    "Def 4 completer (T2) — mirror of Def 1"),
  est = c(
    ch3_existing$est,
    form_a$est[form_a$def == "exit_def1" & form_a$bw_id == "T2"],
    form_a$est[form_a$def == "exit_def2_raw" & form_a$bw_id == "T2"],
    form_a$est[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"],
    form_b$est[form_b$bw_id == "T2"],
    form_a$est[form_a$def == "exit_def4_completer" & form_a$bw_id == "T2"]
  ),
  se = c(
    ch3_existing$se,
    form_a$se[form_a$def == "exit_def1" & form_a$bw_id == "T2"],
    form_a$se[form_a$def == "exit_def2_raw" & form_a$bw_id == "T2"],
    form_a$se[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"],
    form_b$se[form_b$bw_id == "T2"],
    form_a$se[form_a$def == "exit_def4_completer" & form_a$bw_id == "T2"]
  ),
  p = c(
    ch3_existing$p,
    form_a$p[form_a$def == "exit_def1" & form_a$bw_id == "T2"],
    form_a$p[form_a$def == "exit_def2_raw" & form_a$bw_id == "T2"],
    form_a$p[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"],
    form_b$p[form_b$bw_id == "T2"],
    form_a$p[form_a$def == "exit_def4_completer" & form_a$bw_id == "T2"]
  ),
  n_obs = c(
    ch3_existing$n_obs,
    form_a$n_obs[form_a$def == "exit_def1" & form_a$bw_id == "T2"],
    form_a$n_obs[form_a$def == "exit_def2_raw" & form_a$bw_id == "T2"],
    form_a$n_obs[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"],
    form_b$n_obs[form_b$bw_id == "T2"],
    form_a$n_obs[form_a$def == "exit_def4_completer" & form_a$bw_id == "T2"]
  )
)

# ---------------------------------------------------------------------------- #
# Phase 7 — M5 Pre-policy attrition profiling embedded
# ---------------------------------------------------------------------------- #
# Reproduce explorations/2026-05-15_p3c-precheck/findings.md §2-3 tables
# inside p3c_results.rds for replication-protocol audit.

overall_treated_rate <- mean(farm$D_treat, na.rm = TRUE)

attrition_by_year <- farm |>
  dplyr::filter(n_years < 5L) |>
  dplyr::count(last_year, D_treat) |>
  dplyr::group_by(D_treat) |>
  dplyr::mutate(share_within_group = n / sum(n)) |>
  dplyr::ungroup() |>
  dplyr::arrange(last_year, D_treat)

profile_2018only <- farm |>
  dplyr::filter(n_years == 1L & first_year == 2018L) |>
  dplyr::summarise(
    n_total        = dplyr::n(),
    n_treated      = sum(D_treat, na.rm = TRUE),
    share_treated  = mean(D_treat, na.rm = TRUE),
    mean_own_share = mean(own_share_0, na.rm = TRUE),
    mean_area_2018 = mean(area_2018, na.rm = TRUE),
    overall_treated_rate = overall_treated_rate,
    skew_pp        = mean(D_treat, na.rm = TRUE) - overall_treated_rate
  )

# Pre-policy (2018-2019) vs policy-era (2020-2021) treated skew
skew_summary <- attrition_by_year |>
  dplyr::mutate(period = dplyr::case_when(
    last_year < 2020L            ~ "pre_2020",
    last_year %in% c(2020L, 2021L) ~ "policy_era_2020_2021",
    last_year == 2022L            ~ "late_entrants_2022",
    TRUE                          ~ NA_character_
  )) |>
  dplyr::group_by(period, D_treat) |>
  dplyr::summarise(n = sum(n), .groups = "drop") |>
  tidyr::pivot_wider(names_from = D_treat, values_from = n,
                     names_prefix = "n_", values_fill = 0L) |>
  dplyr::mutate(
    total           = n_0 + n_1,
    share_treated   = n_1 / total,
    skew_pp         = share_treated - overall_treated_rate
  )

message(sprintf("Phase 7 attrition profile: overall treated rate = %.3f", overall_treated_rate))
message(sprintf("  Pre-2020 skew = %+.3fpp | policy-era 2020-2021 skew = %+.3fpp",
                skew_summary$skew_pp[skew_summary$period == "pre_2020"],
                skew_summary$skew_pp[skew_summary$period == "policy_era_2020_2021"]))

# ---------------------------------------------------------------------------- #
# Phase 8 — S1 own_share × exit heterogeneity (GATED on scenario α)
# ---------------------------------------------------------------------------- #

if (startsWith(scenario_label, "α")) {
  message("Phase 8: Scenario α → running S1 own_share × exit heterogeneity.")

  exit_het_grid <- tidyr::expand_grid(
    def   = c("exit_def1", "exit_def2_corrected"),
    bw_id = names(bw_grid)
  )

  fit_exit_het <- function(def, bw_id) {
    h <- bw_grid[[bw_id]]
    sub <- farm |> dplyr::filter(abs(rv_2018) <= h, !is.na(own_bin))
    if (nrow(sub) < 30L) {
      return(tibble::tibble(def = def, bw_id = bw_id, h = h,
                            own_bin = NA_character_, estimate = NA_real_,
                            std.error = NA_real_, p.value = NA_real_,
                            n_obs = nrow(sub)))
    }
    fml <- as.formula(sprintf(
      "%s ~ i(own_bin, D_treat, ref = '5_pure_owner') + rv_2018", def))
    fit <- tryCatch(
      fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
      error = function(e) NULL
    )
    if (is.null(fit)) {
      return(tibble::tibble(def = def, bw_id = bw_id, h = h,
                            own_bin = NA_character_, estimate = NA_real_,
                            std.error = NA_real_, p.value = NA_real_,
                            n_obs = nrow(sub)))
    }
    broom::tidy(fit) |>
      dplyr::filter(grepl("own_bin::", term)) |>
      dplyr::mutate(
        own_bin = gsub(".*own_bin::([1-9]_[a-z_]+).*", "\\1", term),
        def = def, bw_id = bw_id, h = h, n_obs = nrow(sub)
      ) |>
      dplyr::select(def, bw_id, h, own_bin, estimate, std.error, p.value, n_obs)
  }

  exit_het <- purrr::pmap_dfr(exit_het_grid, fit_exit_het)

  # Monotone gradient check on Def 2' headline T2
  het_headline <- exit_het |>
    dplyr::filter(def == "exit_def2_corrected", bw_id == "T2")
  h5_check <- list(
    pure_tenant_est = het_headline$estimate[het_headline$own_bin == "1_pure_tenant"],
    mixed_est       = het_headline$estimate[het_headline$own_bin == "3_mixed"],
    high_owner_est  = het_headline$estimate[het_headline$own_bin == "4_high_owner"],
    monotone_neg    = NA,  # filled below
    note            = "pure_owner is reference (≡ 0)"
  )
  if (length(h5_check$pure_tenant_est) && length(h5_check$mixed_est) &&
      !is.na(h5_check$pure_tenant_est) && !is.na(h5_check$mixed_est)) {
    h5_check$monotone_neg <- h5_check$pure_tenant_est < h5_check$mixed_est
  }
  message(sprintf("  Heterogeneity headline (Def 2' T2): pure_tenant=%+.4f | mixed=%+.4f | monotone_neg=%s",
                  h5_check$pure_tenant_est %||% NA_real_,
                  h5_check$mixed_est %||% NA_real_,
                  h5_check$monotone_neg %||% NA))
} else {
  exit_het  <- NULL
  h5_check  <- list(note = sprintf("Skipped — scenario is '%s' (not α).", scenario_label))
  message(sprintf("Phase 8: Scenario != α (%s); S1 skipped per spec gating.", scenario_label))
}

# ---------------------------------------------------------------------------- #
# Phase 9 — Save RDS + LaTeX tables (dual-language)
# ---------------------------------------------------------------------------- #

p3c_results <- list(
  farm_summary             = farm,
  exit_did_form_a          = form_a,
  exit_did_form_b          = form_b,
  area_conditional_events  = area_conditional,
  area_decomposition       = area_decomp,
  scenario                 = scenario_label,
  scenario_basis           = headline_cells,
  reconciliation           = reconciliation,
  attrition_by_year        = attrition_by_year,
  attrition_skew_summary   = skew_summary,
  profile_2018only         = profile_2018only,
  exit_het                 = exit_het,
  h5_check                 = h5_check,
  spec_path                = "quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md",
  notes = paste0(
    "P3c Phase 1 outputs. M1: 4-def × 3 bw exit DiD (Form A 12 cells + Form B 3 cells). ",
    "M2: survival-conditional area event-study (3 outcomes × 3 bw × 4 yr = 36 rows). ",
    "M3: scenario classification via headline cells. M4: reconciliation w/ ch3_exit +0.1517 baseline. ",
    "M5: pre-policy attrition profiling embedded. S1: gated on scenario α; ",
    "skipped when scenario is β or γ. Spec contract APPROVED 2026-05-15."
  )
)

saveRDS(p3c_results, file.path(out_dir, "p3c_results.rds"))
message(sprintf("Phase 9: p3c_results.rds saved (%d fields).", length(p3c_results)))

# ---- LaTeX table helpers ----
fmt_k <- function(x, d = 0) ifelse(is.na(x), "—",
                          formatC(x, format = "f", digits = d, big.mark = ","))
fmt_pct <- function(x, d = 1) ifelse(is.na(x), "—",
                            sprintf(paste0("%.", d, "f%%"), 100 * x))
star_p <- function(p) ifelse(is.na(p), "",
                      ifelse(p < 0.01, "***",
                      ifelse(p < 0.05, "**",
                      ifelse(p < 0.10, "*", ""))))

# ---- Table 1: tab_ch5_exit_definitions ----
write_exit_definitions_table <- function(lang, path) {
  caption <- if (lang == "en")
    "P3c M1: Multi-Definition Exit DiD — Form A (cross-section) + Form B (DiD pre-trend control)"
  else
    "P3c M1: 다중 정의 이탈 DiD — Form A (횡단면) + Form B (DiD 사전-추세 통제)"

  build_form_a_row <- function(def_label, def_key) {
    cells <- form_a |> dplyr::filter(def == def_key) |> dplyr::arrange(bw_id)
    coefs <- sprintf("%s%s", fmt_k(cells$est, 4), star_p(cells$p))
    ses   <- sprintf("(%s)", fmt_k(cells$se, 4))
    paste0(
      sprintf("%s & %s \\\\", def_label, paste(coefs, collapse = " & ")), "\n",
      sprintf("       & %s \\\\", paste(ses, collapse = " & "))
    )
  }

  fa_def1   <- build_form_a_row("Def 1 (n_years $<$ 5)",       "exit_def1")
  fa_def2r  <- build_form_a_row("Def 2 raw",                    "exit_def2_raw")
  fa_def2c  <- build_form_a_row("Def 2' corrected [HEADLINE]",  "exit_def2_corrected")
  fa_def4   <- build_form_a_row("Def 4 completer (mirror)",     "exit_def4_completer")

  fb_cells <- form_b |> dplyr::arrange(bw_id)
  fb_coefs <- sprintf("%s%s", fmt_k(fb_cells$est, 4), star_p(fb_cells$p))
  fb_ses   <- sprintf("(%s)", fmt_k(fb_cells$se, 4))
  fb_row <- paste0(
    sprintf("Form B (DiD pre/post) [HEADLINE] & %s \\\\", paste(fb_coefs, collapse = " & ")), "\n",
    sprintf("                                  & %s \\\\", paste(fb_ses, collapse = " & "))
  )

  scenario_text <- if (lang == "en")
    sprintf("Scenario classification: %s", scenario_label)
  else
    sprintf("시나리오 분류: %s", scenario_label)

  note_en <- paste0(
    "Form A: rdrobust(y=exit\\_def, x=rv\\_2018, c=0, p=1, masspoints=off), per-bandwidth h. ",
    "Form B: feols(exit $\\sim$ D\\_treat*period\\_post + rv\\_2018*period\\_post, cluster=$\\sim$hh\\_id) ",
    "on stacked pre/post farm-level data. ",
    "Def 2' (corrected, last\\_year $\\in$ \\{2020, 2021\\}) is headline — excludes late entrants ",
    "(730 farms with last\\_year=2022, n\\_years$<$5). ",
    "Existing ch3\\_exit MSE-bandwidth baseline +0.1517 reported in reconciliation table. ",
    "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  note_ko <- paste0(
    "Form A: rdrobust(y=exit\\_def, x=rv\\_2018, c=0, p=1, masspoints=off) 대역폭별. ",
    "Form B: feols(exit $\\sim$ D\\_treat*period\\_post + rv\\_2018*period\\_post, cluster=$\\sim$hh\\_id) ",
    "농가단위 사전/사후 적재 자료. ",
    "Def 2' (보정, last\\_year $\\in$ \\{2020, 2021\\})이 헤드라인 — 후기 진입자 730 농가 제외 ",
    "(last\\_year=2022 \\& n\\_years$<$5). ",
    "기존 ch3\\_exit MSE 대역폭 baseline +0.1517은 reconciliation 표 참조. ",
    "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  note <- if (lang == "en") note_en else note_ko

  tex <- sprintf(paste0(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n",
    "\\label{tab:ch5_exit_definitions_%s}\n",
    "\\textbf{Panel A: Form A — Cross-section RD via rdrobust}\\\\\n",
    "\\begin{tabular}{lrrr}\n\\toprule\n",
    "Estimator & T1 (h=500) & T2 (h=1,000) & T3 (h=3,300) \\\\\n",
    "\\midrule\n%s\n%s\n%s\n%s\n",
    "\\bottomrule\n\\end{tabular}\\\\[1ex]\n",
    "\\textbf{Panel B: Form B — DiD pre/post stacked (Def 2' only)}\\\\\n",
    "\\begin{tabular}{lrrr}\n\\toprule\n",
    "Estimator & T1 (h=500) & T2 (h=1,000) & T3 (h=3,300) \\\\\n",
    "\\midrule\n%s\n",
    "\\bottomrule\n\\end{tabular}\\\\[1ex]\n",
    "\\textbf{%s}\\\\\n",
    "\\footnotesize\\textit{%s}\n\\end{table}\n"),
    caption, lang,
    fa_def1, fa_def2r, fa_def2c, fa_def4,
    fb_row,
    scenario_text, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}
write_exit_definitions_table("en", file.path(out_dir, "tab_ch5_exit_definitions_en.tex"))
write_exit_definitions_table("ko", file.path(out_dir, "tab_ch5_exit_definitions_ko.tex"))

# ---- Table 2: tab_ch5_reconciliation ----
write_reconciliation_table <- function(lang, path) {
  caption <- if (lang == "en")
    "P3c M4: P3b-1 Reconciliation — Existing ch3\\_exit +0.1517 vs New Estimators"
  else
    "P3c M4: P3b-1 조정 — 기존 ch3\\_exit +0.1517 vs 신규 추정값"

  rows <- character()
  for (i in seq_len(nrow(reconciliation))) {
    r <- reconciliation[i, ]
    rows <- c(rows,
      sprintf("%s & %s%s & (%s) & %s \\\\",
              r$estimator, fmt_k(r$est, 4), star_p(r$p),
              fmt_k(r$se, 4), fmt_k(r$n_obs, 0))
    )
  }

  note_en <- paste0(
    "Row 1: existing ch3\\_exit (MSE-optimal bandwidth, +0.1517 p=0.039) — unfiltered cross-section. ",
    "Rows 2-6: T2 (h=1,000) for definition comparability. ",
    "Headline causal estimate = Row 5 (Def 2' Form B). ",
    "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  note_ko <- paste0(
    "행 1: 기존 ch3\\_exit (MSE 최적 대역폭, +0.1517 p=0.039) — 비여과 횡단면. ",
    "행 2-6: T2 (h=1,000) 정의 비교를 위해 통일. ",
    "헤드라인 인과 추정값 = 행 5 (Def 2' Form B). ",
    "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  note <- if (lang == "en") note_en else note_ko

  tex <- sprintf(paste0(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n",
    "\\label{tab:ch5_reconciliation_%s}\n",
    "\\begin{tabular}{p{6.5cm}rrr}\n\\toprule\n",
    "Estimator & Estimate & SE & N \\\\\n",
    "\\midrule\n%s\n",
    "\\bottomrule\n\\end{tabular}\\\\\n",
    "\\footnotesize\\textit{%s}\n\\end{table}\n"),
    caption, lang, paste(rows, collapse = "\n"), note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}
write_reconciliation_table("en", file.path(out_dir, "tab_ch5_reconciliation_en.tex"))
write_reconciliation_table("ko", file.path(out_dir, "tab_ch5_reconciliation_ko.tex"))

# ---- Table 3: tab_ch5_area_decomposition ----
write_area_decomp_table <- function(lang, path) {
  caption <- if (lang == "en")
    "P3c M2: area\\_total Decomposition — Unconditional (Ch4+Ch5) vs Conditional (Ch4 only)"
  else
    "P3c M2: area\\_total 분해 — 비조건부 (Ch4+Ch5) vs 조건부 (Ch4 단독)"

  bw_labels <- c("T1", "T2", "T3")
  years     <- c(2018L, 2020L, 2021L, 2022L)
  rows <- character()
  for (bw in bw_labels) {
    for (y in years) {
      cell <- area_decomp |> dplyr::filter(bw_label == bw, year == y)
      if (nrow(cell) == 0L) next
      rows <- c(rows, sprintf(
        "%s & %d & %s%s & %s%s & %s \\\\",
        bw, y,
        fmt_k(cell$estimate_uncond, 0), star_p(cell$p_uncond),
        fmt_k(cell$estimate_cond, 0),   star_p(cell$p_cond),
        if (is.na(cell$selection_share)) "—"
          else fmt_pct(cell$selection_share, 1)
      ))
    }
  }

  note_en <- paste0(
    "Unconditional column = ch3\\_area\\_events (06\\_channels.R Phase 2, full panel). ",
    "Conditional column = restricted to n\\_years==5 completers (N=2,217 farms). ",
    "Selection share = 1 - (cond / uncond). ",
    "Channel 4(iii) extensive margin within survivors = conditional column; ",
    "Channel 5 selection bias = unconditional minus conditional, expressed as share. ",
    "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  note_ko <- paste0(
    "비조건부 컬럼 = ch3\\_area\\_events (06\\_channels.R Phase 2, 전체 패널). ",
    "조건부 컬럼 = n\\_years==5 완전 농가만 (N=2,217). ",
    "선택 비중 = 1 - (조건부 / 비조건부). ",
    "Channel 4(iii) 잔존 농가 내 확장 마진 = 조건부; Channel 5 선택 편의 = 비조건부 - 조건부 비율. ",
    "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  note <- if (lang == "en") note_en else note_ko

  tex <- sprintf(paste0(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n",
    "\\label{tab:ch5_area_decomposition_%s}\n",
    "\\begin{tabular}{llrrr}\n\\toprule\n",
    "Bandwidth & Year & Unconditional & Conditional (n=5) & Selection share \\\\\n",
    "\\midrule\n%s\n",
    "\\bottomrule\n\\end{tabular}\\\\\n",
    "\\footnotesize\\textit{%s}\n\\end{table}\n"),
    caption, lang, paste(rows, collapse = "\n"), note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}
write_area_decomp_table("en", file.path(out_dir, "tab_ch5_area_decomposition_en.tex"))
write_area_decomp_table("ko", file.path(out_dir, "tab_ch5_area_decomposition_ko.tex"))

# ---- Table 4: tab_ch5_attrition_profile ----
write_attrition_table <- function(lang, path) {
  caption <- if (lang == "en")
    "P3c M5: Pre-Policy Attrition Profile — Treated-Control Skew by Period"
  else
    "P3c M5: 사전 정책 이탈 프로파일 — 기간별 처리-대조 편향"

  rows <- character()
  for (i in seq_len(nrow(skew_summary))) {
    r <- skew_summary[i, ]
    rows <- c(rows, sprintf(
      "%s & %d & %d & %d & %s & %s \\\\",
      r$period, r$n_0, r$n_1, r$total,
      fmt_pct(r$share_treated, 1),
      sprintf("%+.1fpp", 100 * r$skew_pp)
    ))
  }

  p2018 <- profile_2018only
  profile_row <- sprintf(
    "2018-only (n\\_years==1, first\\_year==2018) & %d & %d & %d & %s & %s \\\\",
    p2018$n_total - p2018$n_treated, p2018$n_treated, p2018$n_total,
    fmt_pct(p2018$share_treated, 1),
    sprintf("%+.1fpp", 100 * p2018$skew_pp)
  )

  note_en <- paste0(
    "Overall treated rate (farm-level): ", sprintf("%.3f", overall_treated_rate),
    ". Pre-2020 skew + policy-era skew $\\approx$ similar magnitude $\\Rightarrow$ ",
    "DiD pre-trend control (Form B) is required to net out baseline survey churn from ",
    "policy-era causal effect. Late entrants (last\\_year=2022, n\\_years$<$5) excluded from Def 2'.")
  note_ko <- paste0(
    "전체 처리율 (농가단위): ", sprintf("%.3f", overall_treated_rate),
    ". 사전-2020 편향 ≈ 정책기 편향 $\\Rightarrow$ DiD 사전 추세 통제 (Form B) ",
    "필수: 기본 설문 이탈을 정책기 인과 효과에서 분리. ",
    "후기 진입자 (last\\_year=2022, n\\_years$<$5) Def 2'에서 제외.")
  note <- if (lang == "en") note_en else note_ko

  tex <- sprintf(paste0(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n",
    "\\label{tab:ch5_attrition_profile_%s}\n",
    "\\begin{tabular}{lrrrrr}\n\\toprule\n",
    "Period & Control & Treated & Total & Treated share & Skew \\\\\n",
    "\\midrule\n%s\n\\midrule\n%s\n",
    "\\bottomrule\n\\end{tabular}\\\\\n",
    "\\footnotesize\\textit{%s}\n\\end{table}\n"),
    caption, lang, paste(rows, collapse = "\n"), profile_row, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}
write_attrition_table("en", file.path(out_dir, "tab_ch5_attrition_profile_en.tex"))
write_attrition_table("ko", file.path(out_dir, "tab_ch5_attrition_profile_ko.tex"))

# ---- Table 5: tab_ch5_exit_heterogeneity (only if scenario α) ----
if (startsWith(scenario_label, "α") && !is.null(exit_het) && nrow(exit_het) > 0) {
  write_het_table <- function(lang, path) {
    caption <- if (lang == "en")
      "P3c S1: own\\_share × exit Heterogeneity (Def 2' headline)"
    else
      "P3c S1: own\\_share × 이탈 이질성 (Def 2' 헤드라인)"
    het_h <- exit_het |> dplyr::filter(def == "exit_def2_corrected")
    rows <- character()
    for (bw in c("T1", "T2", "T3")) {
      cells <- het_h |> dplyr::filter(bw_id == bw) |>
                dplyr::arrange(own_bin)
      if (nrow(cells) == 0L) next
      coefs <- sprintf("%s%s", fmt_k(cells$estimate, 4), star_p(cells$p.value))
      ses   <- sprintf("(%s)", fmt_k(cells$std.error, 4))
      rows <- c(rows,
        sprintf("%s & %s \\\\", bw, paste(coefs, collapse = " & ")),
        sprintf("       & %s \\\\", paste(ses, collapse = " & "))
      )
    }
    note <- if (lang == "en")
      "Reference category: 5\\_pure\\_owner (coefficient = 0). Monotone gradient predicted: pure\\_tenant > low\\_owner > mixed > high\\_owner. * p$<$0.10, ** p$<$0.05, *** p$<$0.01."
    else
      "참조 범주: 5\\_pure\\_owner (계수 = 0). 단조 gradient 예측: pure\\_tenant > low\\_owner > mixed > high\\_owner. * p$<$0.10, ** p$<$0.05, *** p$<$0.01."

    tex <- sprintf(paste0(
      "\\begin{table}[t]\n\\centering\n\\caption{%s}\n",
      "\\label{tab:ch5_exit_heterogeneity_%s}\n",
      "\\begin{tabular}{lrrrr}\n\\toprule\n",
      "Bandwidth & pure\\_tenant & low\\_owner & mixed & high\\_owner \\\\\n",
      "\\midrule\n%s\n",
      "\\bottomrule\n\\end{tabular}\\\\\n",
      "\\footnotesize\\textit{%s}\n\\end{table}\n"),
      caption, lang, paste(rows, collapse = "\n"), note
    )
    writeLines(tex, path, useBytes = (lang == "ko"))
  }
  write_het_table("en", file.path(out_dir, "tab_ch5_exit_heterogeneity_en.tex"))
  write_het_table("ko", file.path(out_dir, "tab_ch5_exit_heterogeneity_ko.tex"))
  message("Phase 9: heterogeneity tables written (scenario α path).")
} else {
  message("Phase 9: heterogeneity tables skipped (scenario != α).")
}

# Final console summary
message("")
message("============================================================")
message(sprintf("P3c Phase 1 COMPLETE — Scenario: %s", scenario_label))
message(sprintf("  Form A Def 2' T2 (headline): est=%+.4f, p=%.4f",
                form_a$est[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"],
                form_a$p[form_a$def == "exit_def2_corrected" & form_a$bw_id == "T2"]))
message(sprintf("  Form B T2 (DiD pre-trend control): est=%+.4f, p=%.4f",
                form_b$est[form_b$bw_id == "T2"],
                form_b$p[form_b$bw_id == "T2"]))
if (nrow(headline_decomp) > 0) {
  message(sprintf("  T3 2022 selection share: %.3f",
                  headline_decomp$selection_share))
}
message("============================================================")
