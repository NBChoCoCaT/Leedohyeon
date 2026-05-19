# =============================================================================
# 01b_eligibility.R — SFFP 자격 더미 (요건 1+2+6) 구성 + 기존 D와 비교
#
# Issue: SFFP는 8요건 모두 충족 시 지급 (소농직불금 1.2M flat). 현재 D_treat는
# 요건 #1 (경작면적 ≤ 0.5ha)만 체크. 데이터로 검증 가능한 요건:
#   (1) area_2018 ≤ 5000             — 이미 D_treat
#   (2) area_owned_total < 15,500    — 신규 (raw 원부_토지 재집계 필요)
#   (6) off_farm_income < 45,000,000 — y_off_income 활용
#
# Current panel의 area_own은 ownership=1 (자가소유+자작)만 포함하므로 SFFP
# 요건 #2 (총 소유면적)와 불일치 → raw 원부_토지를 재집계하여 ownership ∈ {1,3}
# (자작소유 + 임대해 준 소유) 합산이 필요.
#
# Output (non-destructive — clean.rds 미수정):
#   _outputs/clean_with_eligibility.rds   — panel + 신규 eligibility 컬럼
#   _outputs/eligibility_compare.{txt,rds} — 비교 로그 + 객체
#   _outputs/eligibility_compare_table.md — 사람 읽기용 비교 표
#
# Plan: /Users/leedo/.claude/plans/foamy-squishing-aurora.md
# =============================================================================

suppressPackageStartupMessages({
  library(haven)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(purrr)
  library(fs)
  library(here)
  library(tibble)
})
set.seed(20260504L)

# ---------------------------------------------------------------------------- #
# Phase 1 — Load canonical panel + raw 원부_토지 (5년치)
# ---------------------------------------------------------------------------- #

clean_rds <- here::here("scripts", "R", "_outputs", "clean.rds")
stopifnot(fs::file_exists(clean_rds))
df_clean <- readRDS(clean_rds)
stopifnot(
  "hhid"  %in% names(df_clean),                 # string key for raw merge
  "hh_id" %in% names(df_clean),                 # integer group ID
  nrow(df_clean) == 14474L
)

land_files <- here::here(
  "master_supporting_docs", "own_drafts", "rawdata",
  sprintf("%d_원부_토지_20260407_82677.csv", 2018:2022)
)
stopifnot(all(fs::file_exists(land_files)))

read_land_year <- function(path) {
  readr::read_csv(
    path,
    locale = readr::locale(encoding = "UTF-8"),
    col_types = readr::cols(
      `조사연도`       = readr::col_integer(),
      `행정구역시도코드` = readr::col_character(),
      `지목코드`       = readr::col_integer(),
      `소유구분코드`   = readr::col_integer(),
      `토지면적`       = readr::col_double(),
      `천원단위평가금액` = readr::col_double(),
      `집계코드`       = readr::col_character(),
      `원시자료제공키값` = readr::col_character()
    ),
    progress = FALSE
  ) |>
    dplyr::rename(
      year      = `조사연도`,
      sido_cd   = `행정구역시도코드`,
      land_type = `지목코드`,
      ownership = `소유구분코드`,
      area_raw  = `토지면적`,
      agg_code  = `집계코드`,
      hhid      = `원시자료제공키값`
    )
}

df_land_raw <- purrr::map_dfr(land_files, read_land_year)

# ---------------------------------------------------------------------------- #
# Phase 2 — Aggregate to (hhid × year) — 농지 + 자가소유 + 임대해 준 소유
# ---------------------------------------------------------------------------- #
# 필터 (STATA 01_cleaning.do:89-91 와 동일):
#   - land_type ∈ {11,12,21,22,23} : 농지 (논/밭/과수/묘포 등)
#   - agg_code ∈ {"Y","S"}         : 유효 집계 대상
# 신규: ownership=3 (소유했지만 타인에게 임대) 포함하여 총 소유면적 계산

df_land_filt <- df_land_raw |>
  dplyr::filter(
    land_type %in% c(11L, 12L, 21L, 22L, 23L),
    agg_code  %in% c("Y", "S")
  )

df_land <- df_land_filt |>
  dplyr::group_by(hhid, year) |>
  dplyr::summarise(
    area_owned_cultiv     = sum(area_raw * (ownership == 1L), na.rm = TRUE),
    area_owned_rented_out = sum(area_raw * (ownership == 3L), na.rm = TRUE),
    area_owned_total      = sum(area_raw * (ownership %in% c(1L, 3L)),
                                na.rm = TRUE),
    .groups = "drop"
  )

# ---------------------------------------------------------------------------- #
# Phase 3 — Merge into panel + baseline (first-observed) + eligibility dummies
# ---------------------------------------------------------------------------- #

df <- df_clean |>
  dplyr::left_join(df_land, by = c("hhid", "year"))

stopifnot(nrow(df) == nrow(df_clean))           # left_join row-preservation

linkage_rate <- mean(!is.na(df$area_owned_total))

# Baseline = first observed year per household (matches STATA `_first_area`
# convention in 01_cleaning.do:388; consistent with how `area_2018` itself is
# constructed in the panel).
baseline <- df |>
  dplyr::arrange(hh_id, year) |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(
    area_owned_2018 = dplyr::first(area_owned_total[!is.na(area_owned_total)]),
    off_inc_2018    = dplyr::first(off_farm_income[!is.na(off_farm_income)]),
    .groups = "drop"
  )

df <- df |>
  dplyr::left_join(baseline, by = "hh_id") |>
  dplyr::mutate(
    D_area              = as.logical(D_treat),
    D_owned_2018        = area_owned_2018 < 15500,                 # req #2
    D_offinc_2018       = off_inc_2018    < 45000000,              # req #6 baseline
    D_offinc_t          = off_farm_income < 45000000,              # req #6 annual
    D_eligible_obs_2018 = D_area & D_owned_2018 & D_offinc_2018,   # 1+2+6 baseline
    D_eligible_obs_t    = D_area & D_owned_2018 & D_offinc_t       # 1+2+6 year-vary
  )

# ---------------------------------------------------------------------------- #
# Phase 4 — Comparison statistics
# ---------------------------------------------------------------------------- #

# A. Treated-cohort sample-size waterfall (household-level + obs-level)
hh_level <- df |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(
    D_area              = dplyr::first(D_area),
    D_owned_2018        = dplyr::first(D_owned_2018),
    D_offinc_2018       = dplyr::first(D_offinc_2018),
    D_eligible_obs_2018 = dplyr::first(D_eligible_obs_2018),
    .groups = "drop"
  )

n_hh_total          <- nrow(hh_level)
n_hh_area           <- sum(hh_level$D_area, na.rm = TRUE)
n_hh_area_owned     <- sum(hh_level$D_area & hh_level$D_owned_2018, na.rm = TRUE)
n_hh_eligible_2018  <- sum(hh_level$D_eligible_obs_2018, na.rm = TRUE)

n_obs_area          <- sum(df$D_area, na.rm = TRUE)
n_obs_area_owned    <- sum(df$D_area & df$D_owned_2018, na.rm = TRUE)
n_obs_eligible_2018 <- sum(df$D_eligible_obs_2018, na.rm = TRUE)

waterfall <- tibble::tribble(
  ~stage,                                       ~n_hh,                   ~n_obs,
  "D_area = 1 (current; req 1 only)",           n_hh_area,               n_obs_area,
  "  ∩ D_owned_2018 = 1 (+req 2)",              n_hh_area_owned,         n_obs_area_owned,
  "  ∩ D_offinc_2018 = 1 (+req 6 baseline)",    n_hh_eligible_2018,      n_obs_eligible_2018
) |>
  dplyr::mutate(
    pct_of_area_hh  = round(100 * n_hh  / n_hh_area,  1),
    pct_of_area_obs = round(100 * n_obs / n_obs_area, 1)
  )

# B. 2x2 cross-tab D_treat × D_eligible_obs_2018 (obs-level)
cross_tab <- df |>
  dplyr::mutate(
    D_treat_lbl = ifelse(D_treat, "D_treat=1", "D_treat=0"),
    D_elig_lbl  = ifelse(D_eligible_obs_2018, "D_eligible=1", "D_eligible=0")
  ) |>
  dplyr::count(D_treat_lbl, D_elig_lbl) |>
  tidyr::pivot_wider(names_from = D_elig_lbl, values_from = n, values_fill = 0)

# C. Descriptive comparison (pre-period 2018-2019, treated cohort)
desc_vars <- c("area_2018", "area_owned_2018",
               "area_own", "area_rent", "own_share",
               "off_farm_income", "op_cost", "consumption", "farm_income",
               "age_code_base")

summarize_set <- function(d, label) {
  d |>
    dplyr::select(dplyr::all_of(desc_vars)) |>
    dplyr::summarise(
      dplyr::across(dplyr::everything(),
                    list(mean = ~ mean(.x, na.rm = TRUE),
                         sd   = ~ stats::sd(.x,  na.rm = TRUE),
                         n    = ~ sum(!is.na(.x))))
    ) |>
    tidyr::pivot_longer(everything(),
                        names_to = c("variable", ".value"),
                        names_pattern = "(.*)_(mean|sd|n)$") |>
    dplyr::mutate(group = label, .before = 1)
}

pre_treated_area <- df |>
  dplyr::filter(year %in% 2018:2019, D_area == TRUE)
pre_treated_elig <- df |>
  dplyr::filter(year %in% 2018:2019, D_eligible_obs_2018 == TRUE)

desc_compare <- dplyr::bind_rows(
  summarize_set(pre_treated_area, "D_treat=1 (current)"),
  summarize_set(pre_treated_elig, "D_eligible_obs_2018=1 (new)")
)

# D. Sanity checks
sanity <- list(
  nrow_preserved = nrow(df) == nrow(df_clean),
  owned_total_ge_cultiv = all(
    df$area_owned_total >= df$area_owned_cultiv - 1e-6,
    na.rm = TRUE
  ),
  cor_cultiv_area_own = stats::cor(df$area_owned_cultiv, df$area_own,
                                   use = "pairwise.complete.obs"),
  eligible_subset_of_treat = all(
    df$D_eligible_obs_2018 <= df$D_treat,
    na.rm = TRUE
  ),
  D_treat_unchanged = identical(df$D_treat, df_clean$D_treat),
  linkage_rate = linkage_rate
)

# Hard assertions (orchestrator-research.md verification gate)
stopifnot(
  sanity$nrow_preserved,
  sanity$owned_total_ge_cultiv,
  sanity$cor_cultiv_area_own > 0.95,            # STATA recomputation sanity
  sanity$eligible_subset_of_treat,
  sanity$D_treat_unchanged,
  sanity$linkage_rate > 0.95
)

# ---------------------------------------------------------------------------- #
# Phase 5 — Save outputs
# ---------------------------------------------------------------------------- #

out_dir <- here::here("scripts", "R", "_outputs")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

saveRDS(df, file.path(out_dir, "clean_with_eligibility.rds"))

compare_obj <- list(
  waterfall    = waterfall,
  cross_tab    = cross_tab,
  desc_compare = desc_compare,
  sanity       = sanity,
  hh_level     = hh_level
)
saveRDS(compare_obj, file.path(out_dir, "eligibility_compare.rds"))

# --- Plain-text log ---
fmt_int <- function(x) formatC(x, format = "d", big.mark = ",")
log_lines <- c(
  paste0("=== 01b_eligibility.R log -- ", as.character(Sys.time()), " ==="),
  "",
  "Inputs:",
  paste0("  panel:        ", clean_rds),
  paste0("  land 원부:    ", length(land_files), " files (2018-2022)"),
  "",
  sprintf("Linkage rate (panel obs with land aggregate): %.3f%% (%s / %s)",
          100 * sanity$linkage_rate,
          fmt_int(sum(!is.na(df$area_owned_total))),
          fmt_int(nrow(df))),
  "",
  "Sanity checks (all PASS):",
  sprintf("  [v] nrow preserved: %s == %s", fmt_int(nrow(df)), fmt_int(nrow(df_clean))),
  sprintf("  [v] area_owned_total >= area_owned_cultiv      (∀ obs)"),
  sprintf("  [v] cor(area_owned_cultiv, area_own) = %.4f    (> 0.95 required)",
          sanity$cor_cultiv_area_own),
  sprintf("  [v] D_eligible_obs_2018 ⊆ D_treat              (∀ obs)"),
  sprintf("  [v] D_treat unchanged from canonical clean.rds"),
  "",
  "=== A. Treated-cohort sample-size waterfall ===",
  "",
  sprintf("%-50s %10s %10s %8s %8s",
          "Stage", "N(hh)", "N(obs)", "%hh", "%obs"),
  strrep("-", 90),
  sprintf("%-50s %10s %10s %8.1f %8.1f",
          waterfall$stage[1],
          fmt_int(waterfall$n_hh[1]), fmt_int(waterfall$n_obs[1]),
          waterfall$pct_of_area_hh[1], waterfall$pct_of_area_obs[1]),
  sprintf("%-50s %10s %10s %8.1f %8.1f",
          waterfall$stage[2],
          fmt_int(waterfall$n_hh[2]), fmt_int(waterfall$n_obs[2]),
          waterfall$pct_of_area_hh[2], waterfall$pct_of_area_obs[2]),
  sprintf("%-50s %10s %10s %8.1f %8.1f",
          waterfall$stage[3],
          fmt_int(waterfall$n_hh[3]), fmt_int(waterfall$n_obs[3]),
          waterfall$pct_of_area_hh[3], waterfall$pct_of_area_obs[3]),
  "",
  "=== B. 2x2 cross-tab (obs-level) — D_treat × D_eligible_obs_2018 ===",
  "",
  capture.output(print(cross_tab)),
  "",
  "=== C. Descriptive comparison (pre-period 2018-2019, treated) ===",
  sprintf("  D_treat=1 (current):           N(obs, pre)=%s",
          fmt_int(nrow(pre_treated_area))),
  sprintf("  D_eligible_obs_2018=1 (new):   N(obs, pre)=%s",
          fmt_int(nrow(pre_treated_elig))),
  "  (See eligibility_compare_table.md for full means/SDs.)",
  ""
)
writeLines(log_lines, con = file.path(out_dir, "eligibility_compare.txt"),
           useBytes = FALSE)

# --- Markdown comparison table ---
desc_wide <- desc_compare |>
  dplyr::mutate(
    val = sprintf("%.2f (%.2f) [n=%s]", mean, sd, fmt_int(n))
  ) |>
  dplyr::select(variable, group, val) |>
  tidyr::pivot_wider(names_from = group, values_from = val)

md_lines <- c(
  "# Eligibility comparison: D_treat vs D_eligible_obs_2018",
  "",
  sprintf("_Generated by `scripts/R/01b_eligibility.R` on %s._",
          format(Sys.Date(), "%Y-%m-%d")),
  "",
  "**Definitions:**",
  "- `D_treat` (current): `area_2018 ≤ 5000` (요건 #1만)",
  "- `D_eligible_obs_2018` (new): `D_treat ∧ (area_owned_total_2018 < 15,500) ∧ (off_farm_income_2018 < 45,000,000)` (요건 1+2+6)",
  "",
  "## A. Treated-cohort waterfall",
  "",
  "| Stage | N(hh) | N(obs) | %hh | %obs |",
  "|---|---:|---:|---:|---:|",
  sprintf("| %s | %s | %s | %.1f | %.1f |",
          waterfall$stage[1],
          fmt_int(waterfall$n_hh[1]),  fmt_int(waterfall$n_obs[1]),
          waterfall$pct_of_area_hh[1], waterfall$pct_of_area_obs[1]),
  sprintf("| %s | %s | %s | %.1f | %.1f |",
          waterfall$stage[2],
          fmt_int(waterfall$n_hh[2]),  fmt_int(waterfall$n_obs[2]),
          waterfall$pct_of_area_hh[2], waterfall$pct_of_area_obs[2]),
  sprintf("| %s | %s | %s | %.1f | %.1f |",
          waterfall$stage[3],
          fmt_int(waterfall$n_hh[3]),  fmt_int(waterfall$n_obs[3]),
          waterfall$pct_of_area_hh[3], waterfall$pct_of_area_obs[3]),
  "",
  "## B. 2x2 cross-tab (obs-level)",
  "",
  paste0("| ", paste(names(cross_tab), collapse = " | "), " |"),
  paste0("| ", paste(rep("---", ncol(cross_tab)), collapse = " | "), " |"),
  apply(cross_tab, 1, function(row) {
    paste0("| ", paste(as.character(row), collapse = " | "), " |")
  }),
  "",
  "_Note: D_eligible=1 requires D_treat=1 by construction, so the (D_treat=0, D_eligible=1) cell is structurally 0._",
  "",
  "## C. Descriptive comparison (pre-period 2018-2019, treated cohort)",
  "",
  "Format: `mean (SD) [n]`",
  "",
  paste0("| variable | ", paste(setdiff(names(desc_wide), "variable"),
                                collapse = " | "), " |"),
  paste0("| --- | ", paste(rep("---", ncol(desc_wide) - 1),
                           collapse = " | "), " |"),
  apply(desc_wide, 1, function(row) {
    paste0("| ", paste(row, collapse = " | "), " |")
  }),
  "",
  "## D. Sanity",
  "",
  sprintf("- Linkage rate (panel ↔ raw land): **%.3f%%**", 100 * sanity$linkage_rate),
  sprintf("- `cor(area_owned_cultiv [re-aggregated], area_own [panel])` = **%.4f** (sanity for STATA→R equivalence)",
          sanity$cor_cultiv_area_own),
  sprintf("- `D_eligible_obs_2018 ⊆ D_treat` (subset relation): **TRUE**"),
  sprintf("- `area_owned_total >= area_owned_cultiv` ∀ obs: **TRUE**"),
  ""
)
writeLines(md_lines, con = file.path(out_dir, "eligibility_compare_table.md"),
           useBytes = FALSE)

# Final stdout signal
message(sprintf(
  "01b_eligibility.R: clean_with_eligibility.rds + compare artifacts saved (%d obs).",
  nrow(df)
))
message(sprintf("Waterfall: D_treat=%s | +D_owned=%s | +D_offinc(2018)=D_eligible=%s households",
                fmt_int(n_hh_area), fmt_int(n_hh_area_owned), fmt_int(n_hh_eligible_2018)))
