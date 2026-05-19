# =============================================================================
# 01c_subset_clean.R — Subset construction for D_eligible_obs_2018 main promotion
#
# Wave 7 — promote `D_eligible_obs_2018` (statutorily-eligible SFFP, criteria
# 1+2+6 observable in FHES) to the MAIN treatment definition. The original
# Wave 5 D_treat baseline is preserved in `_outputs/clean.rds`; this script
# produces the parallel subset panel in `_outputs_eligibility/clean.rds` so
# that all downstream scripts (02–10) can run unchanged via OUT_DIR injection.
#
# Subset rule: drop treated-but-ineligible households (D_treat=TRUE &
# D_eligible_obs_2018=FALSE). Within the resulting subset, treatment is sharp
# at the area cutoff (D_eligible_obs_2018 == 1[rv_2018<=0]).
#
# Treatment swap:
#   - D_treat (panel name) ← D_eligible_obs_2018
#   - D_treat_area_only (preserved backup) ← original D_treat from clean.rds
#   - D_Post, Drv_Post recomputed
#
# Inputs:
#   _outputs/clean_with_eligibility.rds  (from 01b_eligibility.R)
#
# Outputs:
#   _outputs_eligibility/clean.rds       — subset panel with D_treat redefined
#
# Plan: /Users/leedo/.claude/plans/foamy-squishing-aurora.md (Phase 1A)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(fs)
  library(here)
})
set.seed(20260504L)

# Inputs
in_path <- here::here("scripts", "R", "_outputs", "clean_with_eligibility.rds")
stopifnot(fs::file_exists(in_path))
df_full <- readRDS(in_path)
stopifnot(
  nrow(df_full) == 14474L,
  "D_eligible_obs_2018" %in% names(df_full),
  "D_treat" %in% names(df_full),
  "D_Post" %in% names(df_full)
)

# Subset (drop treated-but-ineligible)
df <- df_full |>
  dplyr::filter(D_eligible_obs_2018 == TRUE | D_treat == FALSE)

# Sanity: subset sample size matches 24-cell Bypass expectation
n_obs_sub <- nrow(df)
n_hh_sub  <- dplyr::n_distinct(df$hh_id)
n_treated <- df |>
  dplyr::distinct(hh_id, .keep_all = TRUE) |>
  dplyr::pull(D_eligible_obs_2018) |>
  sum(na.rm = TRUE)

# STOP CONDITION: treated < 1,131 hh implies subset construction error
stopifnot(
  n_obs_sub == 13689L,
  n_hh_sub  == 3420L,
  n_treated >= 1131L
)

# Within subset, D_eligible_obs_2018 must equal 1[rv_2018<=0] (sharp on subset)
sub_sharp <- with(df,
                  all(D_eligible_obs_2018 == (rv_2018 <= 0)))
stopifnot(sub_sharp)

# ---------------------------------------------------------------------------- #
# Treatment swap: D_treat ← D_eligible_obs_2018; interactions recomputed
# ---------------------------------------------------------------------------- #

df <- df |>
  dplyr::mutate(
    D_treat_area_only = as.integer(D_treat),                  # backup (integer 0/1)
    D_treat           = as.integer(D_eligible_obs_2018),      # MAIN swap (integer 0/1)
    D_Post            = D_treat * Post,                       # recompute
    Drv_Post          = D_treat * rv_2018 * Post              # recompute
  )

# Verify swap (D_treat is integer 0/1 matching original clean.rds type)
stopifnot(
  is.integer(df$D_treat),
  all(df$D_treat == as.integer(df$D_eligible_obs_2018)),
  all(df$D_Post  == df$D_treat * df$Post),
  all(df$Drv_Post == df$D_treat * df$rv_2018 * df$Post)
)

# ---------------------------------------------------------------------------- #
# Save
# ---------------------------------------------------------------------------- #

out_dir <- here::here("scripts", "R", "_outputs_eligibility")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
saveRDS(df, file.path(out_dir, "clean.rds"))

# Log
log_lines <- c(
  paste0("=== 01c_subset_clean.R log -- ", as.character(Sys.time()), " ==="),
  "",
  sprintf("Input:  %s", in_path),
  sprintf("Output: %s", file.path(out_dir, "clean.rds")),
  "",
  sprintf("Subset sample: %d obs / %d hh (dropped %d obs / %d hh treated-but-ineligible)",
          n_obs_sub, n_hh_sub,
          14474L - n_obs_sub, 3614L - n_hh_sub),
  sprintf("Treated under new definition: %d hh", n_treated),
  "",
  "Sanity checks (all PASS):",
  sprintf("  [v] nrow == 13,689 (actual %d)", n_obs_sub),
  sprintf("  [v] n_hh  == 3,420 (actual %d)", n_hh_sub),
  sprintf("  [v] treated >= 1,131 (actual %d)", n_treated),
  sprintf("  [v] D_eligible_obs_2018 == 1[rv_2018<=0] on subset (sharp)"),
  sprintf("  [v] D_treat == D_eligible_obs_2018 (swap verified)"),
  sprintf("  [v] D_Post == D_treat * Post"),
  sprintf("  [v] Drv_Post == D_treat * rv_2018 * Post"),
  "",
  "Backup: original area-only D_treat preserved as `D_treat_area_only` column."
)
writeLines(log_lines, file.path(out_dir, "subset_log.txt"))

message(sprintf(
  "01c_subset_clean.R: _outputs_eligibility/clean.rds saved (%d obs / %d hh; treated=%d).",
  n_obs_sub, n_hh_sub, n_treated
))
