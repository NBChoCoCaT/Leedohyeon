# =============================================================================
# 01d_symmetric_clean.R — Symmetric (ii)+(vi) screening on BOTH sides of cutoff
#
# Phase 1 Blockers — Wave 9 (2026-05-20). Decision X4-A: apply observable
# eligibility screening symmetrically on both sides of the 0.5 ha cutoff.
#
# Motivation: Wave 7 dropped 194 treated-but-ineligible households (failing
# criteria ii or vi) from the treated side ONLY. This asymmetric construction
# was flagged by the 2026-05-20 /seven-pass-review (Lens 3 C2) as
# identification fail — sample selection masquerading as sharp DiD-RD.
#
# This script applies (ii)+(vi) screening on BOTH sides:
#   ii)  area_owned_total_2018 < 15,500 m^2   (D_owned_2018 == TRUE)
#   vi)  off_farm_income_2018  < 45,000,000   (D_offinc_2018 == TRUE)
#
# Within the screened panel:
#   - Treated side (D_area = TRUE) coincides with D_eligible_obs_2018 = TRUE
#     (since ii ∧ vi are guaranteed by the filter).
#   - Control side (D_area = FALSE) keeps only households who would pass
#     ii+vi if their area were ≤ 0.5 ha. Excludes large-farm landlords +
#     off-farm-income-rich households from the control side.
#
# Treatment swap:
#   - D_treat (panel name) ← D_eligible_obs_2018 (== D_area on screened subset)
#   - D_treat_area_only (backup) ← original D_treat from clean.rds
#   - D_Post, Drv_Post recomputed
#
# Inputs:
#   _outputs/clean_with_eligibility.rds  (from 01b_eligibility.R)
#
# Outputs:
#   _outputs_symmetric/clean.rds       — symmetric-screened panel
#   _outputs_symmetric/symmetric_log.txt — sample waterfall + sanity checks
#
# Plan: quality_reports/plans/2026-05-20_phase1-blockers.md (Step 2)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(fs)
  library(here)
})
set.seed(20260504L)

# Inputs ----------------------------------------------------------------------
in_path <- here::here("scripts", "R", "_outputs", "clean_with_eligibility.rds")
stopifnot(fs::file_exists(in_path))
df_full <- readRDS(in_path)
stopifnot(
  nrow(df_full) == 14474L,
  "D_eligible_obs_2018" %in% names(df_full),
  "D_owned_2018"        %in% names(df_full),
  "D_offinc_2018"       %in% names(df_full),
  "D_treat"             %in% names(df_full),
  "D_Post"              %in% names(df_full)
)

# Sample waterfall counters (pre-filter) --------------------------------------
n_obs_start <- nrow(df_full)
n_hh_start  <- dplyr::n_distinct(df_full$hh_id)
n_treated_start <- df_full |>
  dplyr::distinct(hh_id, .keep_all = TRUE) |>
  dplyr::pull(D_treat) |>
  sum(na.rm = TRUE)

# Symmetric filter: keep only ii ∧ vi (both sides screened) -------------------
df <- df_full |>
  dplyr::filter(D_owned_2018 == TRUE,
                D_offinc_2018 == TRUE)

# Post-filter counters --------------------------------------------------------
n_obs_sym <- nrow(df)
n_hh_sym  <- dplyr::n_distinct(df$hh_id)

n_treated_sym <- df |>
  dplyr::distinct(hh_id, .keep_all = TRUE) |>
  dplyr::pull(D_eligible_obs_2018) |>
  sum(na.rm = TRUE)
n_control_sym <- n_hh_sym - n_treated_sym

# Treated-side households should be unchanged from Wave 7 (still 1,131)
# because treated side already required ii ∧ vi for D_eligible = TRUE.
# Control-side households drop: those failing ii or vi are now excluded.

# Sanity checks ---------------------------------------------------------------
# (1) Within-subset sharp on the area cutoff
sym_sharp <- with(df, all(D_eligible_obs_2018 == (rv_2018 <= 0)))

# (2) D_eligible_obs_2018 == D_area within subset (since ii ∧ vi guaranteed)
sym_collapse <- with(df, all(D_eligible_obs_2018 == as.logical(D_area)))

# (3) Treated households unchanged from Wave 7 baseline (1,131 hh)
treated_unchanged <- n_treated_sym == 1131L

# (4) No NA in the load-bearing columns
no_na <- with(df, all(!is.na(D_eligible_obs_2018) & !is.na(rv_2018)))

stopifnot(sym_sharp, sym_collapse, treated_unchanged, no_na)

# Treatment swap: D_treat ← D_eligible_obs_2018; interactions recomputed -----
df <- df |>
  dplyr::mutate(
    D_treat_area_only = as.integer(D_treat),
    D_treat           = as.integer(D_eligible_obs_2018),
    D_Post            = D_treat * Post,
    Drv_Post          = D_treat * rv_2018 * Post
  )

stopifnot(
  is.integer(df$D_treat),
  all(df$D_treat == as.integer(df$D_eligible_obs_2018)),
  all(df$D_Post  == df$D_treat * df$Post),
  all(df$Drv_Post == df$D_treat * df$rv_2018 * df$Post)
)

# Save ------------------------------------------------------------------------
out_dir <- here::here("scripts", "R", "_outputs_symmetric")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
saveRDS(df, file.path(out_dir, "clean.rds"))

# Log -------------------------------------------------------------------------
log_lines <- c(
  paste0("=== 01d_symmetric_clean.R log -- ", as.character(Sys.time()), " ==="),
  "",
  sprintf("Input:  %s", in_path),
  sprintf("Output: %s", file.path(out_dir, "clean.rds")),
  "",
  "Sample waterfall (symmetric (ii)+(vi) screening on BOTH sides):",
  sprintf("  Start (full panel):       %s obs / %s hh / %s treated",
          format(n_obs_start, big.mark = ","),
          format(n_hh_start,  big.mark = ","),
          format(n_treated_start, big.mark = ",")),
  sprintf("  After ii ∧ vi filter:     %s obs / %s hh / %s treated / %s control",
          format(n_obs_sym, big.mark = ","),
          format(n_hh_sym,  big.mark = ","),
          format(n_treated_sym, big.mark = ","),
          format(n_control_sym, big.mark = ",")),
  sprintf("  Dropped:                  %s obs / %s hh (vs full panel)",
          format(n_obs_start - n_obs_sym, big.mark = ","),
          format(n_hh_start - n_hh_sym,   big.mark = ",")),
  sprintf("  Vs Wave 7 (_outputs_eligibility):"),
  sprintf("    Treated unchanged:      %d (Wave 7: 1,131)", n_treated_sym),
  sprintf("    Control delta:          %d (Wave 7: 2,289 -> Symmetric: %d)",
          2289L - n_control_sym, n_control_sym),
  sprintf("  Treated share:            %.3f (Wave 7: 0.331; Wave 5 area-only: 0.367)",
          n_treated_sym / n_hh_sym),
  "",
  "Sanity checks (all PASS):",
  sprintf("  [v] D_eligible_obs_2018 == 1[rv_2018<=0] within subset (sharp)"),
  sprintf("  [v] D_eligible_obs_2018 == D_area within subset (ii ∧ vi guaranteed)"),
  sprintf("  [v] treated == 1,131 (unchanged from Wave 7 — symmetric filter does not")
  ,
  sprintf("       affect treated side since D_eligible = TRUE already requires ii ∧ vi)"),
  sprintf("  [v] D_treat == D_eligible_obs_2018 (integer swap verified)"),
  sprintf("  [v] D_Post == D_treat * Post"),
  sprintf("  [v] Drv_Post == D_treat * rv_2018 * Post"),
  sprintf("  [v] No NA in D_eligible_obs_2018 or rv_2018"),
  "",
  "Backup: original area-only D_treat preserved as `D_treat_area_only` column."
)
writeLines(log_lines, file.path(out_dir, "symmetric_log.txt"))

message(sprintf(
  "01d_symmetric_clean.R: _outputs_symmetric/clean.rds saved (%d obs / %d hh; treated=%d / control=%d).",
  n_obs_sym, n_hh_sym, n_treated_sym, n_control_sym
))
