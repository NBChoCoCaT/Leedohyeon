# =============================================================================
# 01_clean.R — PIDPS DiD-RD data cleaning (Step 4 P1).
#
# Inputs:
#   master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta
#     (already produced by STATA 01_cleaning.do — 14,474 obs × 3,614 farms × 2018-2022)
#
# Outputs (under scripts/R/_outputs/):
#   clean.rds            — analysis-ready panel with renamed columns
#                          + pre-computed DiD-RD interactions (rv_Post, Drv_Post)
#                          + outlier-policy derived columns (16 outcome cols total:
#                            raw 4 + ihs 4 + winsor99 4 + winsor995 4)
#   var_dictionary.csv   — 3-col lookup (r_name, source_name_ko, definition_en)
#   clean_log.txt        — sample-size waterfall + sanity-check ledger
#
# Spec contracts:
#   - r-code-conventions.md §10 (rename map)
#   - quality_reports/specs/2026-05-07_outlier-policy.md v1.1 (§4 / §6)
#   - replication-protocol.md Phase 3 tolerance (verified at P2 entry)
#
# Plan: quality_reports/plans/2026-05-07_p1-clean-r.md
# =============================================================================

suppressPackageStartupMessages({
  library(haven)        # read_dta — preserves Korean labels as attributes
  library(dplyr)        # mutate, rename, across, group_by, summarise
  library(tidyr)        # (reserved for downstream)
  library(DescTools)    # Winsorize
  library(fs)
  library(here)
  library(readr)        # write_csv
  library(tibble)       # tribble
})
set.seed(20260504L)     # CLAUDE.md commands section seed

# ---------------------------------------------------------------------------- #
# Phase 1 — Load + immutable sanity assertions
# ---------------------------------------------------------------------------- #

raw_path <- here::here("master_supporting_docs", "own_drafts",
                       "rawdata", "panel_2018_2022.dta")
stopifnot(fs::file_exists(raw_path))

df_raw <- haven::read_dta(raw_path)

# Sanity per [LEARN:methods] 2026-05-06 (verified on this exact .dta).
stopifnot(
  nrow(df_raw) == 14474L,
  dplyr::n_distinct(df_raw$hhid_num) == 3614L,
  setequal(unique(df_raw$year), 2018:2022)
)

# Treatment-dummy identity: D == (rv_2018 <= 0) == (area_2018 <= 5000)
stopifnot(
  all(df_raw$D == (df_raw$rv_2018 <= 0)),
  all(df_raw$D == (df_raw$area_2018 <= 5000))
)

# D time-invariant per household (each hh has exactly one D value across years).
d_unique_per_hh <- df_raw |>
  dplyr::group_by(hhid_num) |>
  dplyr::summarise(n_unique = dplyr::n_distinct(D), .groups = "drop")
stopifnot(max(d_unique_per_hh$n_unique) == 1L)

# imputed_payment median for treated post-2020 should equal SFFP flat 1,200,000.
trt_post_imp <- df_raw |>
  dplyr::filter(D == 1, year >= 2020) |>
  dplyr::pull(imputed_payment)
stopifnot(stats::median(trt_post_imp, na.rm = TRUE) == 1200000)

# ---------------------------------------------------------------------------- #
# Phase 2 — Rename per r-code-conventions.md §10
# ---------------------------------------------------------------------------- #

df <- df_raw |>
  dplyr::rename(
    hh_id            = hhid_num,
    D_treat          = D,
    op_cost          = y_farm_cost,
    off_farm_income  = y_off_income,
    consumption      = y_consump,
    farm_income      = y_farm_income,
    op_cost_ex_rent  = y_farm_cost_ex_rent,
    rent_cost        = y_rent_cost,
    actual_subsidy   = y_ag_subsidy_proxy
    # Kept as-is: rv_2018, area_2018, area_total, year, Post, D_Post,
    #             weight_national, imputed_payment, type_fulltime, farm_type,
    #             age_code_base, sex_code, edu_code, debt_total, own_share,
    #             area_own, area_rent, ...
  )

# §10 표는 `area_t` (annual)을 명시하지만 raw `area_total`이 의미상 동일하고
# STATA scripts와 부합 → area_total로 보존, var_dictionary에 동등성 명시.

# ---------------------------------------------------------------------------- #
# Phase 3 — DiD-RD interaction columns (LN-1)
# ---------------------------------------------------------------------------- #
# D_Post는 raw에 이미 존재 (01_cleaning.do:402). rv_Post / Drv_Post는
# 02_analysis.do:152-155에서 매 spec마다 재생성 → DRY를 위해 여기서 한 번 계산.

df <- df |> dplyr::mutate(
  rv_Post  = rv_2018 * Post,
  Drv_Post = as.numeric(D_treat) * rv_2018 * Post
)

# Cross-check pre-computed D_Post.
stopifnot(all(df$D_Post == as.integer(df$D_treat) * df$Post))

# ---------------------------------------------------------------------------- #
# Phase 4 — Outlier-policy derived outcomes (spec v1.1 §4 / §6)
# ---------------------------------------------------------------------------- #

outcomes_raw <- c("op_cost", "off_farm_income", "consumption", "farm_income")

# Tier 2A — IHS (asinh) — preserves negatives. spec §6.2.
df <- df |> dplyr::mutate(
  dplyr::across(
    dplyr::all_of(outcomes_raw),
    ~ asinh(.x),
    .names = "ihs_{.col}"
  )
)

# Tier 2B — Winsor p1/p99. spec §6.3.
# DescTools 0.99.60 changed the signature: pass cap values through `val`,
# computed via stats::quantile() with na.rm=TRUE.
df <- df |> dplyr::mutate(
  dplyr::across(
    dplyr::all_of(outcomes_raw),
    ~ DescTools::Winsorize(
        .x,
        val = stats::quantile(.x, probs = c(0.01, 0.99), na.rm = TRUE)
      ),
    .names = "{.col}_w99"
  )
)

# Tier 3 (AJAE) — Winsor 0.5/99.5. spec §6.5.
df <- df |> dplyr::mutate(
  dplyr::across(
    dplyr::all_of(outcomes_raw),
    ~ DescTools::Winsorize(
        .x,
        val = stats::quantile(.x, probs = c(0.005, 0.995), na.rm = TRUE)
      ),
    .names = "{.col}_w995"
  )
)

# All 16 outcome columns must exist.
expected_outcome_cols <- c(
  outcomes_raw,
  paste0("ihs_", outcomes_raw),
  paste0(outcomes_raw, "_w99"),
  paste0(outcomes_raw, "_w995")
)
stopifnot(all(expected_outcome_cols %in% names(df)))

# Korean label round-trip check (LN-7 mitigation): one canonical label.
op_cost_label <- attr(df$op_cost, "label")
stopifnot(!is.null(op_cost_label),
          grepl("농업경영비", op_cost_label, fixed = TRUE))

# ---------------------------------------------------------------------------- #
# Phase 5 — Save outputs
# ---------------------------------------------------------------------------- #

out_dir <- here::here("scripts", "R", "_outputs")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# 1. clean.rds
saveRDS(df, file.path(out_dir, "clean.rds"))

# 2. var_dictionary.csv (3-col lookup per §10).
var_dict <- tibble::tribble(
  ~r_name, ~source_name_ko, ~definition_en,
  "hh_id",            "농가식별번호 (hhid_num)",        "Household ID; primary cluster unit",
  "year",             "조사연도",                       "Panel year (2018-2022)",
  "D_treat",          "처치 더미 (D)",                  "Treatment indicator: rv_2018 <= 0 (i.e., area_2018 <= 0.5 ha)",
  "Post",             "시점 더미",                      "Post-PIDPS indicator: year >= 2020",
  "D_Post",           "D × Post",                      "DiD interaction (primary β; pre-computed in 01_cleaning.do:402)",
  "rv_2018",          "Running variable (centered)",    "area_2018 - 5000 (㎡); 0 = cutoff",
  "rv_Post",          "rv_2018 × Post",                "RD slope component (computed in 01_clean.R per LN-1)",
  "Drv_Post",         "D × rv × Post",                 "RD slope-difference component (computed in 01_clean.R per LN-1)",
  "area_2018",        "2018 baseline 경지면적",         "Baseline cultivated area (㎡); pre-policy",
  "area_total",       "연도별 경지면적 (= area_t per §10)", "Time-varying cultivated area (㎡); NOT running variable",
  "op_cost",          "농업경영비 전체 (y_farm_cost)",  "Operating cost — primary lumpy-investment outcome",
  "off_farm_income",  "농외소득 (y_off_income)",        "Off-farm income — Sandmo precautionary labor",
  "consumption",      "가계 소비지출 (y_consump)",      "Household consumption — Blundell-Pistaferri smoothing",
  "farm_income",      "농업소득 (y_farm_income)",       "Farm income — omnibus outcome (음수 23.55%)",
  "op_cost_ex_rent",  "농업경영비 (임차료 제외)",       "Operating cost net of rent — Kirwan channel decomposition",
  "rent_cost",        "임차료 (y_rent_cost)",           "Rent cost — Kirwan channel",
  "actual_subsidy",   "실제 농업보조금 (#84)",          "Actual subsidy received — first-stage take-up (raw: y_ag_subsidy_proxy)",
  "imputed_payment",  "Imputed 공익직불금",             "Formula-derived eligible amount (KRW); 01_cleaning.do:420-426",
  "weight_national",  "전국 가중값",                    "National-rep weight (Solon-Haider-Wooldridge stage rule)",
  "ihs_<outcome>",    "asinh(outcome)",                "Tier 2 IHS robustness — outlier-spec §6.2",
  "<outcome>_w99",    "Winsorize 1/99",                "Tier 2 winsor99 robustness — outlier-spec §6.3",
  "<outcome>_w995",   "Winsorize 0.5/99.5",            "Tier 3 (AJAE) winsor995 robustness — outlier-spec §6.5"
)
readr::write_csv(var_dict, file.path(out_dir, "var_dictionary.csv"))

# 3. clean_log.txt — sample-size waterfall + sanity-check ledger.
log_path  <- file.path(out_dir, "clean_log.txt")
log_lines <- c(
  paste0("=== 01_clean.R log -- ", as.character(Sys.time()), " ==="),
  "",
  paste0("Input:  ", raw_path),
  paste0("Output: ", file.path(out_dir, "clean.rds")),
  "",
  sprintf("Dimensions: %d obs x %d columns", nrow(df), ncol(df)),
  sprintf("Households: %d", dplyr::n_distinct(df$hh_id)),
  sprintf("Years:      %d-%d", min(df$year), max(df$year)),
  "",
  "Sanity checks (all PASS):",
  "  [v] nrow == 14474",
  "  [v] n_distinct(hh_id) == 3614",
  "  [v] D_treat == (rv_2018 <= 0)         (14474/14474)",
  "  [v] D_treat == (area_2018 <= 5000)    (14474/14474)",
  "  [v] D_treat time-invariant per hh_id  (max distinct D per hh = 1)",
  "  [v] D_Post == D_treat * Post          (14474/14474)",
  "  [v] median(imputed_payment | D=1, year>=2020) == 1,200,000 KRW (SFFP flat)",
  sprintf("  [v] attr(op_cost, 'label') = '%s'", op_cost_label),
  "",
  "Derived columns (per outlier-spec v1.1):",
  paste("  ihs_*    (4):", paste(paste0("ihs_", outcomes_raw), collapse = ", ")),
  paste("  *_w99    (4):", paste(paste0(outcomes_raw, "_w99"), collapse = ", ")),
  paste("  *_w995   (4):", paste(paste0(outcomes_raw, "_w995"), collapse = ", "))
)
writeLines(log_lines, con = log_path, useBytes = FALSE)

# Final stdout signal for 00_run_all.R orchestrator.
message(sprintf("01_clean.R: clean.rds saved (%d obs × %d cols).",
                nrow(df), ncol(df)))
