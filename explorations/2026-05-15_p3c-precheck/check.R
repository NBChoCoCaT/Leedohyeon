# P3c Phase 0 — Pre-validation sanity check
#
# Plan: ../../quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md
# Spec: ../../quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md (DRAFT)
#
# Scope: construct 4 exit definitions locally, report N + treated/control balance.
# NO regression, NO SE/p-value, NO writing to clean.rds.
# Runtime ~10s. Outputs 3 CSVs to _outputs/.

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

set.seed(20260504)

# Resolve paths relative to this script's directory
script_dir <- tryCatch(
  dirname(sys.frame(1)$ofile),
  error = function(e) getwd()
)
clean_path <- file.path(script_dir, "..", "..", "scripts", "R", "_outputs", "clean.rds")
out_dir    <- file.path(script_dir, "_outputs")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

df <- readRDS(clean_path)
stopifnot(all(c("hh_id", "year", "D_treat", "own_share", "area_2018") %in% names(df)))

# ---- Per-farm summary ----
farm <- df |>
  group_by(hh_id) |>
  summarise(
    n_years     = dplyr::n(),
    first_year  = min(year),
    last_year   = max(year),
    D_treat     = dplyr::first(D_treat),
    own_share_0 = mean(own_share[year == 2018L], na.rm = TRUE),
    area_2018   = dplyr::first(area_2018),
    age_2018    = mean(age_code_base[year == 2018L], na.rm = TRUE),
    fulltime    = dplyr::first(type_fulltime),
    .groups     = "drop"
  )

# ---- 4 exit definitions ----
farm <- farm |>
  mutate(
    exit_def1_baseline   = as.integer(n_years < 5L),
    exit_def2_policy_era = as.integer(n_years < 5L & last_year >= 2020L),
    exit_def3_dynamic    = last_year,    # raw "last observed year" for hazard panel
    exit_def4_completer  = as.integer(n_years == 5L)
  )

# ---- Output #1: definition cross-tab (×2 main defs × D_treat) ----
exit_xt <- farm |>
  count(exit_def1_baseline, exit_def2_policy_era, D_treat) |>
  arrange(exit_def1_baseline, exit_def2_policy_era, D_treat)
write_csv(exit_xt, file.path(out_dir, "exit_def_distributions.csv"))

# ---- Output #2: attrition timing by treated/control ----
attr_by_year <- farm |>
  filter(n_years < 5L) |>
  count(last_year, D_treat) |>
  group_by(D_treat) |>
  mutate(share_within_group = n / sum(n)) |>
  ungroup() |>
  arrange(last_year, D_treat)
write_csv(attr_by_year, file.path(out_dir, "attrition_by_year.csv"))

# ---- Output #3: 2018-only farm profile ----
profile_2018only <- farm |>
  filter(n_years == 1L & first_year == 2018L) |>
  summarise(
    n_total        = dplyr::n(),
    n_treated      = sum(D_treat, na.rm = TRUE),
    share_treated  = mean(D_treat, na.rm = TRUE),
    mean_own_share = mean(own_share_0, na.rm = TRUE),
    mean_area_2018 = mean(area_2018, na.rm = TRUE),
    p_fulltime_1   = mean(fulltime == 1L, na.rm = TRUE)
  )
write_csv(profile_2018only, file.path(out_dir, "profile_2018only.csv"))

# ---- Overall reference: treated rate across all farms ----
overall_treated_rate <- mean(farm$D_treat, na.rm = TRUE)

# ---- Console summary ----
cat("\n== P3c Pre-validation Summary ==\n")
cat("Total farms:                       ", nrow(farm), "\n")
cat("Overall treated rate:              ", sprintf("%.3f", overall_treated_rate), "\n\n")

cat("-- Definition feasibility (treated/control counts) --\n")
cat("Def 1 (baseline n<5):       ",
    sum(farm$exit_def1_baseline == 1L),
    "  (treated=", sum(farm$exit_def1_baseline == 1L & farm$D_treat == 1L),
    ", control=", sum(farm$exit_def1_baseline == 1L & farm$D_treat == 0L), ")\n", sep = "")
cat("Def 2 (policy-era exit):    ",
    sum(farm$exit_def2_policy_era == 1L),
    "  (treated=", sum(farm$exit_def2_policy_era == 1L & farm$D_treat == 1L),
    ", control=", sum(farm$exit_def2_policy_era == 1L & farm$D_treat == 0L), ")\n", sep = "")
cat("Def 3 (dynamic last_year):  ",
    paste(sort(unique(farm$exit_def3_dynamic)), collapse = ", "), "\n", sep = "")
cat("Def 4 (completer n=5):      ",
    sum(farm$exit_def4_completer == 1L),
    "  (treated=", sum(farm$exit_def4_completer == 1L & farm$D_treat == 1L),
    ", control=", sum(farm$exit_def4_completer == 1L & farm$D_treat == 0L), ")\n", sep = "")

cat("\n-- 2018-only farm profile (pre-policy attrition signature) --\n")
print(profile_2018only)
cat("Overall treated rate for reference:", sprintf("%.3f", overall_treated_rate), "\n")
cat("Selection signal? share_treated - overall = ",
    sprintf("%+.3f", profile_2018only$share_treated - overall_treated_rate), "pp\n", sep = "")

cat("\n-- Outputs written to: ", out_dir, " --\n", sep = "")
cat("  exit_def_distributions.csv\n  attrition_by_year.csv\n  profile_2018only.csv\n")
