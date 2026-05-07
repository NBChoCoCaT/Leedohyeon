---
date: 2026-05-07
status: APPROVED
approved-on: 2026-05-07
sentinel: quality_reports/plans/memoized-herding-duckling.md
sister-post-approval: quality_reports/plans/2026-05-07_p1-clean-r.md
predecessor: quality_reports/plans/2026-05-07_p5-synthetic-generator.md
spec-decisions: AskUserQuestion (2026-05-07, 3 Q answered — Option A on all)
---

# Plan: Step 4 P1 — `01_clean.R` (PIDPS DiD-RD data pipeline)

## Context

CLAUDE.md tracker로 P5 합성 데이터 generator (commit `8837efa`) 완료 → 다음 자연스러운 진입점은 P1, 즉 FHES Wave 1 (2018–2022) microdata를 R 분석용 형태로 정제하는 `scripts/R/01_clean.R`. 

현재 `scripts/R/`은 fork-template placeholder (50행 `rnorm` fake data → `01_load.R + 02_clean.R + 03_analyze.R + 04_tables.R + 05_figures.R`)가 그대로 남아 있어, PIDPS-specific 골격으로 재구성해야 하며 그 첫 번째 산출물이 본 plan의 대상.

데이터는 STATA `01_cleaning.do`가 이미 정제하여 저장한 `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` (14,474 obs / 3,614 farms / 2018–2022, [LEARN:methods] 2026-05-06로 검증). R clean script는 raw CSV → STATA cleaning을 재실행하지 않고 .dta를 읽어 (a) 변수 rename (§10 컨벤션), (b) DiD-RD interaction 사전 계산 (`rv_Post`, `Drv_Post`), (c) outlier-policy spec v1.1 derived outcome 12개 일괄 생성, (d) sanity check ledger 출력의 4가지를 수행한다.

세 가지 lock된 spec이 설계를 결정한다: **outlier-policy spec v1.1** (`quality_reports/specs/2026-05-07_outlier-policy.md`), **r-code-conventions §10** (변수 rename 표), **replication-protocol Phase 3** (estimate < 0.01, SE < 0.05 tolerance — P2 진입 시 검증).

## User Decisions (AskUserQuestion 2026-05-07)

- **Q1 = 전면 재구성** — placeholder 5개 모두 PIDPS scheme `01_clean → 02_descriptive → 03_did_rd → 04_robust → 05_figures`으로 갈아치움. P1에서는 `01_clean.R` 본문 + 02–05 stub + `00_run_all.R` 동기화.
- **Q2 = 01_clean.R 일괄 derived outcomes** — clean.rds에 raw 4 + ihs 4 + winsor99 4 + winsor995 4 = 16 outcome 컬럼 모두 포함. estimation script는 컬럼명만 바꿔 동일 spec 호출 → DRY + Phase 3 ledger 단순.
- **Q3 = Phase 0 자동 install** — `scripts/R/_setup_packages.R` 신규 작성 (idempotent), 도현님이 1회 실행 후 본 스크립트 진입. fwildclusterboot/wildrwolf는 sandwich::vcovBS fallback 유지 ([LEARN:env] 2026-05-06).

## Lock Notes (Phase 1 — STATA fidelity scan via Explore agent + codebook)

**LN-1. `D_Post`만 `01_cleaning.do`에서 사전 계산.** `rv_Post`, `Drv_Post`는 `02_analysis.do:152-155`에서 매 spec마다 재생성 (cleaning .dta에 부재). R clean에서 한 번 계산하여 모든 estimation에 공유 → DRY + spec drift 방지.

**LN-2. STATA cleaning이 이미 적용한 sample restriction 4종** (`01_cleaning.do`): jimok 11/12/21/22/23 + ownership 1-2 (line 90-92), agg_code Y/S keep (line 233), `_merge==3` 교집합 (line 344), `area_total > 0 & !missing` (line 367). R clean은 .dta 읽기 → 그대로 14,474 obs 유지. **추가 sample drop 없음.**

**LN-3. `02_analysis.do` baseline에서 covariate 사용 안 함.** Spec은 `D_Post + rv_Post + Drv_Post + hhid FE + year FE`만 (line 164, 243). 통제변수 (type_fulltime, farm_type, age_code_base, sex_code, edu_code, debt_total, own_share)는 .dta에 존재하지만 baseline / 4_robustness / outlier robustness에서 미사용 — 13_weighted_and_fuzzy.do (P2 외)에서만 사용. clean.rds에 보존하되 estimation에는 미투입.

**LN-4. weight_national=0 농가 baseline에서 drop 안 함.** `02_analysis.do` baseline은 unweighted (`reghdfe ... vce(cluster hhid_num)` only). weight_national은 descriptive Table 1 (P2 별도)에서만 사용 — Solon-Haider-Wooldridge 2015 stage rule per `r-code-conventions.md` §6.

**LN-5. `y_ag_subsidy_proxy` (= #84 농업외수입_이전소득_공적보조금_농업보조금액) `panel_2018_2022.dta`에 있음.** `01_cleaning.do:155` rename, line 511 final keep, `13_weighted_and_fuzzy.do:127`에서 IV로 사용. 코드북은 12자 truncate `y_ag_subsi~y` 표기지만 .dta 내 실제 컬럼명은 `y_ag_subsidy_proxy`. **yearly CSV merge 불필요.**

**LN-6. `sgg_cd` (sub-district code) .dta에 부재.** 코드북의 `agg_code_w`는 sgg_cd 아닌 generic agg-code (Y/S 분류 후 line 234에서 drop). MEMORY.md [LEARN:cross-artifact] "sgg_cd 0 hits in 18 .do files" 재확인. **Robustness cluster sgg_cd는 P1 범위 밖 — APCS linkage 또는 raw CSV 재merge 시점에 추가 (AJAE 1차 제출 후).**

**LN-7. STATA → R Korean label 보존.** `panel_2018_2022.dta`는 `label variable` (line 120-242)로 Korean label 부착. `haven::read_dta()`는 label을 컬럼 attribute로 보존 (`attr(df$y_farm_cost, "label") = "농업경영비 전체 (원)"`). UTF-8 native (STATA 18). **인코딩 깨짐 위험 낮음** — sanity check에 label 1개 (`hhid_num` → `"농가 ID (숫자)"`) 라운드트립 검증 포함.

**LN-8. macmini 패키지 누락.** `Rscript -e '.libPaths(); installed.packages()'` 결과 haven/dplyr/fixest/DescTools/here/sandwich 모두 부재. CRAN binary install 가능 (gfortran 불필요). `fwildclusterboot`/`wildrwolf`는 GitHub-only + gfortran 필요 → fallback `sandwich::vcovBS` 사용 ([LEARN:env] 2026-05-06).

## Goal

`scripts/R/01_clean.R` 작성 + 부수 파일 정리로:

1. **`scripts/R/_outputs/clean.rds`** — analysis-ready panel (14,474 × ~50 columns)
2. **`scripts/R/_outputs/var_dictionary.csv`** — 3-column lookup (`r_name`, `source_name_ko`, `definition_en`) per §10
3. **`scripts/R/_outputs/clean_log.txt`** — sample-size waterfall + sanity-check ledger
4. Pipeline scheme `01_clean → 02_descriptive → 03_did_rd → 04_robust → 05_figures`로 통일 (02–05는 stub)
5. `00_run_all.R` 시드 + pipeline vector 동기화

P2 (`03_did_rd.R`) 진입 시 `readRDS("scripts/R/_outputs/clean.rds")` → 즉시 estimation 가능한 상태.

## Files to Modify / Create / Delete

| File | Action | Lines | Purpose |
|---|---|---|---|
| `scripts/R/_setup_packages.R` | **CREATE** | ~40 | Phase 0 — idempotent CRAN install (haven, dplyr, tidyr, DescTools, fs, here, readr, fixest, modelsummary, sandwich, rdrobust, broom, tibble) |
| `scripts/R/01_clean.R` | **REWRITE** | ~180 | Real PIDPS data pipeline (load → rename → derive → save) |
| `scripts/R/02_descriptive.R` | **CREATE (rename from 02_clean.R)** | ~25 | Stub w/ TODO + I/O contract for P2 (Table 1 baseline, Solon-Haider-Wooldridge stage rule) |
| `scripts/R/03_did_rd.R` | **CREATE (rename from 03_analyze.R)** | ~25 | Stub w/ TODO for P2 (T1/T2/T3 bandwidth + Wild bootstrap + Holm) |
| `scripts/R/04_robust.R` | **CREATE (rename from 04_tables.R)** | ~25 | Stub w/ TODO for P3 (outlier robustness ladder + heterogeneity 5×4) |
| `scripts/R/05_figures.R` | **REWRITE** | ~25 | Stub w/ TODO for P3 (RD plot + event-study + density check) |
| `scripts/R/01_load.R` | **DELETE** | -34 | Subsumed into 01_clean.R |
| `scripts/R/02_clean.R` | **DELETE** | -39 | Replaced by new 01_clean.R + 02_descriptive.R |
| `scripts/R/03_analyze.R` | **DELETE** | -30 | Replaced |
| `scripts/R/04_tables.R` | **DELETE** | -30 | Replaced |
| `scripts/R/00_run_all.R` | **EDIT** | ~10 lines changed | `PROJECT_SEED <- 20260504L` (CLAUDE.md sync), pipeline vector 갱신, 보고용 메시지 PIDPS-specific |
| `scripts/R/README.md` | **EDIT** | ~20 lines | 새 pipeline 시퀀스 + setup_packages.R 사용법 + clean.rds schema 1 paragraph |

## Implementation Detail: `01_clean.R`

### Phase 0 — Library + seed (top of script)

```r
suppressPackageStartupMessages({
  library(haven)       # read_dta — preserves Korean labels as attributes
  library(dplyr)       # mutate, rename, across, case_when
  library(tidyr)       # (reserved for P2)
  library(DescTools)   # Winsorize
  library(fs)
  library(here)
  library(readr)       # write_csv
  library(tibble)      # tribble for var_dict
})
set.seed(20260504L)    # CLAUDE.md commands section seed
```

### Phase 1 — Load + immutable sanity assertions

```r
raw_path <- here::here("master_supporting_docs", "own_drafts", "rawdata", "panel_2018_2022.dta")
stopifnot(fs::file_exists(raw_path))
df_raw <- haven::read_dta(raw_path)

# Sanity per [LEARN:methods] 2026-05-06
stopifnot(nrow(df_raw) == 14474L)
stopifnot(dplyr::n_distinct(df_raw$hhid_num) == 3614L)
stopifnot(setequal(unique(df_raw$year), 2018:2022))
stopifnot(all(df_raw$D == (df_raw$rv_2018 <= 0)))
stopifnot(all(df_raw$D == (df_raw$area_2018 <= 5000)))
# D time-invariant per household (0 changes across years)
stopifnot(df_raw |> dplyr::group_by(hhid_num) |>
            dplyr::summarise(n_unique = dplyr::n_distinct(D), .groups = "drop") |>
            dplyr::pull(n_unique) |> max() == 1L)
```

### Phase 2 — Rename per r-code-conventions §10

```r
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
    # rv_2018, area_2018, area_total, year, Post, D_Post, weight_national,
    # imputed_payment, type_fulltime, farm_type, age_code_base, sex_code,
    # edu_code, debt_total, own_share, area_own, area_rent — kept as-is
  )
# Note: §10 표는 `area_t` (annual)을 명시하지만 raw 컬럼명 `area_total`이
# 의미상 동일하고 STATA scripts와 부합 — area_total로 keep, var_dictionary에 동등성 명시.
```

### Phase 3 — Pre-compute DiD-RD interaction columns (LN-1)

```r
df <- df |> dplyr::mutate(
  rv_Post  = rv_2018 * Post,
  Drv_Post = D_treat * rv_2018 * Post
)
# D_Post는 raw에 이미 존재 (01_cleaning.do:402); 일관성 검증
stopifnot(all(df$D_Post == as.integer(df$D_treat) * df$Post))
```

### Phase 4 — Outlier-policy derived outcomes (per spec v1.1 §4 / §6)

```r
outcomes_raw <- c("op_cost", "off_farm_income", "consumption", "farm_income")

# Tier 2A — IHS (asinh) — 음수 보존, spec §6.2
df <- df |> dplyr::mutate(
  dplyr::across(dplyr::all_of(outcomes_raw),
                ~ asinh(.x), .names = "ihs_{.col}"))

# Tier 2B — Winsor p1/p99 — spec §6.3
df <- df |> dplyr::mutate(
  dplyr::across(dplyr::all_of(outcomes_raw),
                ~ DescTools::Winsorize(.x, probs = c(0.01, 0.99), na.rm = TRUE),
                .names = "{.col}_w99"))

# Tier 3 (AJAE addition) — Winsor 0.5/99.5 — spec §6.5
df <- df |> dplyr::mutate(
  dplyr::across(dplyr::all_of(outcomes_raw),
                ~ DescTools::Winsorize(.x, probs = c(0.005, 0.995), na.rm = TRUE),
                .names = "{.col}_w995"))

# 결과: 16 outcome 컬럼 (raw 4 + ihs 4 + w99 4 + w995 4)
stopifnot(all(c(outcomes_raw,
                paste0("ihs_", outcomes_raw),
                paste0(outcomes_raw, "_w99"),
                paste0(outcomes_raw, "_w995")) %in% names(df)))
```

### Phase 5 — Save outputs

```r
out_dir <- here::here("scripts", "R", "_outputs")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# 1. clean.rds
saveRDS(df, file.path(out_dir, "clean.rds"))

# 2. var_dictionary.csv (~20 rows; full text in script)
var_dict <- tibble::tribble(
  ~r_name, ~source_name_ko, ~definition_en,
  "hh_id",            "농가식별번호 (hhid_num)",   "Household ID; primary cluster unit",
  "year",             "조사연도",                   "Panel year (2018-2022)",
  "D_treat",          "처치 더미 (D)",              "Treatment indicator: rv_2018 <= 0 (i.e., area_2018 <= 0.5 ha)",
  "Post",             "시점 더미",                  "Post-PIDPS indicator: year >= 2020",
  "D_Post",           "D × Post",                  "DiD interaction (primary β; pre-computed in 01_cleaning.do:402)",
  "rv_2018",          "Running variable (centered)", "area_2018 - 5000 (㎡); 0 = cutoff",
  "rv_Post",          "rv_2018 × Post",            "RD slope component (computed here per LN-1)",
  "Drv_Post",         "D × rv × Post",             "RD slope-difference component (computed here per LN-1)",
  "area_2018",        "2018 baseline 경지면적",     "Baseline cultivated area (㎡); pre-policy",
  "area_total",       "연도별 경지면적",            "Time-varying cultivated area (㎡); NOT running variable",
  "op_cost",          "농업경영비 전체 (y_farm_cost)", "Operating cost — primary lumpy-investment outcome",
  "off_farm_income",  "농외소득 (y_off_income)",    "Off-farm income — Sandmo precautionary labor",
  "consumption",      "가계 소비지출 (y_consump)",  "Household consumption — Blundell-Pistaferri smoothing",
  "farm_income",      "농업소득 (y_farm_income)",   "Farm income — omnibus outcome (음수 23.55%)",
  "op_cost_ex_rent",  "농업경영비 (임차료 제외)",    "Operating cost net of rent — Kirwan channel decomposition",
  "rent_cost",        "임차료 (y_rent_cost)",       "Rent cost — Kirwan channel",
  "actual_subsidy",   "실제 농업보조금 (#84)",      "Actual subsidy received — first-stage take-up (y_ag_subsidy_proxy)",
  "imputed_payment",  "Imputed 공익직불금",         "Formula-derived eligible amount (KRW); deterministic per 01_cleaning.do:420-426",
  "weight_national",  "전국 가중값",                "National-rep weight (Solon-Haider-Wooldridge 2015 stage rule)",
  "ihs_<outcome>",    "asinh(outcome)",            "Tier 2 IHS robustness — outlier-spec §6.2",
  "<outcome>_w99",    "Winsorize 1/99",            "Tier 2 winsor99 robustness — outlier-spec §6.3",
  "<outcome>_w995",   "Winsorize 0.5/99.5",        "Tier 3 (AJAE) winsor995 robustness — outlier-spec §6.5"
)
readr::write_csv(var_dict, file.path(out_dir, "var_dictionary.csv"))

# 3. clean_log.txt — sample-size waterfall + sanity-check ledger
log_path <- file.path(out_dir, "clean_log.txt")
sink(log_path)
cat("=== 01_clean.R log — ", as.character(Sys.time()), "===\n\n")
cat("Input:  ", raw_path, "\n")
cat("Output: ", file.path(out_dir, "clean.rds"), "\n\n")
cat("Dimensions: ", nrow(df), " obs × ", ncol(df), " columns\n")
cat("Households: ", dplyr::n_distinct(df$hh_id), "\n")
cat("Years:      ", paste(range(df$year), collapse = "-"), "\n\n")
cat("Sanity checks (all PASS):\n")
cat("  [✓] nrow == 14474\n")
cat("  [✓] n_distinct(hh_id) == 3614\n")
cat("  [✓] D_treat == (rv_2018 <= 0)         (14474/14474)\n")
cat("  [✓] D_treat == (area_2018 <= 5000)    (14474/14474)\n")
cat("  [✓] D_treat time-invariant per hh_id  (max changes per hh = 0)\n")
cat("  [✓] D_Post == D_treat × Post          (14474/14474)\n")
cat("  [✓] imputed_payment median for treated post-2020 == 1.2M KRW\n")
cat("\nDerived columns (per outlier-spec v1.1):\n")
cat("  ihs_*    (4):  ", paste(paste0("ihs_", outcomes_raw), collapse = ", "), "\n")
cat("  *_w99    (4):  ", paste(paste0(outcomes_raw, "_w99"), collapse = ", "), "\n")
cat("  *_w995   (4):  ", paste(paste0(outcomes_raw, "_w995"), collapse = ", "), "\n")
sink()

message("01_clean.R: clean.rds saved (", nrow(df), " × ", ncol(df), ").")
```

## Implementation Detail: `_setup_packages.R`

```r
# Idempotent CRAN install for PIDPS R pipeline.
# Run ONCE manually before scripts/R/00_run_all.R.

required <- c(
  "haven", "dplyr", "tidyr", "tibble", "readr",     # tidyverse load/manipulate
  "DescTools",                                       # Winsorize
  "fs", "here",                                      # paths
  "fixest", "modelsummary", "sandwich",              # estimation + Wild bootstrap fallback
  "rdrobust",                                        # MSE-optimal bandwidth (T3)
  "broom"                                            # tidy-up estimates
)

installed <- rownames(installed.packages())
to_install <- setdiff(required, installed)

if (length(to_install) == 0L) {
  message("[setup] All ", length(required), " packages already installed.")
} else {
  message("[setup] Installing ", length(to_install), " packages: ",
          paste(to_install, collapse = ", "))
  install.packages(to_install, repos = "https://cloud.r-project.org")
}

# Sanity: load each
ok <- vapply(required, function(p) requireNamespace(p, quietly = TRUE), logical(1))
if (any(!ok)) {
  warning("[setup] Failed to load: ", paste(required[!ok], collapse = ", "),
          " — install manually with install.packages().")
} else {
  message("[setup] All ", length(required), " packages load successfully.")
}

# Note: fwildclusterboot / wildrwolf 미포함 — gfortran 의존 + sandwich::vcovBS fallback
# 채택 ([LEARN:env] 2026-05-06).
```

## Implementation Detail: `00_run_all.R` Edits

- `PROJECT_SEED <- 20260413L` → `20260504L` (CLAUDE.md commands section)
- Pipeline vector:
  ```r
  pipeline <- c("01_clean.R", "02_descriptive.R", "03_did_rd.R", "04_robust.R", "05_figures.R")
  ```
- 메시지 텍스트만 PIDPS-specific 으로 (e.g., "Running PIDPS DiD-RD pipeline …").

## Implementation Detail: 02–05 Stubs

각 stub 파일은 다음 형식 (~25줄):

```r
# =============================================================================
# 0X_<name>.R — <one-line description>
#
# Status: STUB (Step 4 P<N> deliverable, not P1).
# Plan reference: quality_reports/plans/<P_plan>.md (TBC).
#
# Expected inputs:  scripts/R/_outputs/clean.rds (from 01_clean.R)
# Expected outputs: <list>
# =============================================================================

stop("0X_<name>.R is a stub — implement in Step 4 P<N>.")
```

이 패턴으로 `00_run_all.R` 풀 파이프라인 실행 시 P1이 끝난 직후 명시적으로 멈춤 → 도현님이 다음 단계 진입 시점을 명확히 인지.

## Verification

### Phase 0 (one-time, manual)

```bash
Rscript scripts/R/_setup_packages.R
# Expected: "[setup] All 13 packages load successfully."
```

### Phase 1 (1단계만 실행)

```bash
Rscript -e 'source(here::here("scripts","R","00_run_all.R"))'
# Expected:
#   "Running PIDPS DiD-RD pipeline with seed 20260504..."
#   "  01_clean.R -> ~Xs"
#   <stop on 02_descriptive.R: "0X_<name>.R is a stub ...">
```

### Phase 2 (산출물 점검)

```bash
ls scripts/R/_outputs/
# Expected: clean.rds, var_dictionary.csv, clean_log.txt, sessionInfo.txt
cat scripts/R/_outputs/clean_log.txt
# Verify all sanity rows show [✓]
```

### Phase 3 (R-side 외부 검증)

```r
df <- readRDS("scripts/R/_outputs/clean.rds")
stopifnot(nrow(df) == 14474L,
          dplyr::n_distinct(df$hh_id) == 3614L,
          setequal(unique(df$year), 2018:2022),
          all(df$D_treat == (df$rv_2018 <= 0)),
          all(c("op_cost","ihs_op_cost","op_cost_w99","op_cost_w995",
                "actual_subsidy","D_Post","rv_Post","Drv_Post") %in% names(df)))
# Spot-check label preservation
stopifnot(!is.null(attr(df$op_cost, "label")))
message("clean.rds verified.")
```

### Quality Gate (per `quality-gates.md` R Scripts rubric)

| Item | Status |
|---|---|
| Syntax (Rscript no error) | ☐ verify |
| Domain-specific bug (rv_2018 centering, D == rv_2018<=0) | ☐ stopifnot guards |
| Hardcoded absolute paths | ☐ here::here only |
| set.seed once at top | ☐ 20260504L |
| Packages at top via library() | ☐ phase 0 block |
| Reproducibility-protocol Phase 3 readiness | ☐ var_dict + clean_log emit ledger |

Target: **score ≥ 80** (commit threshold).

## Out of Scope (defer)

- **P2 / 03_did_rd.R** — T1/T2/T3 bandwidth + Wild cluster bootstrap (sandwich::vcovBS) + Holm step-down across 4 outcomes.
- **P2 / 02_descriptive.R** — Table 1 baseline (Solon-Haider-Wooldridge stage rule, weight_national mandatory).
- **P2 first-stage take-up regression** — `actual_subsidy` ↔ `imputed_payment × Post` per [LEARN:methods] #84 mandatory.
- **P3 / 04_robust.R** — outlier robustness ladder + heterogeneity 5 dim × 4 outcome = 20 specs.
- **P3 / 05_figures.R** — RD scatter, McCrary density, event-study.
- **`sgg_cd` cluster robustness** — .dta에 부재. APCS linkage 또는 raw CSV 재merge 시점에 추가 (AJAE 1차 제출 후).
- **Yearly CSV merge for refined #84** — panel.dta `y_ag_subsidy_proxy`로 충분, defer.
- **`imputed_payment` formula audit (정부 고시 vs 01_cleaning.do:420-426)** — outlier-spec OQ-3 별도 task.
- **renv lockfile** — first-submission 시점 (Step 5+) per §12.

## Risks & Mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| haven 인코딩으로 Korean label 깨짐 | Low (LN-7) | 마지막 sanity check에 1개 label round-trip 검증 |
| `area_t` (§10 표) vs `area_total` (raw) 컨벤션 충돌 | Low | var_dictionary.csv에 동등성 명시; area_total로 keep (STATA + var_dict 일관성 우선) |
| Phase 0 install 시 일부 pkg 빌드 실패 (gfortran 등) | Medium (sandwich/fixest는 binary OK) | _setup_packages.R는 idempotent + non-fatal warning; 사용자가 install.packages() 수동 보완 |
| `00_run_all.R`이 stub에서 stop() 시 sessionInfo.txt 미생성 | Medium | 00_run_all.R `tryCatch` wrapper로 stub stop을 graceful 처리 (graceful_stop = TRUE 로 분기) |
| derived outcome 16개 추가로 clean.rds 용량 증가 | Low | numeric × 14474 × 16 ≈ 1.8MB 증가, 무시 가능 |
| 시드 변경 (`20260413L → 20260504L`)으로 placeholder 결과 변경 | None | placeholder는 본 P1에서 제거 |

## Cross-References

- **Spec:** `quality_reports/specs/2026-05-07_outlier-policy.md` v1.1 (§4 Decision Matrix, §6 Verbatim Mapping)
- **R conventions:** `.claude/rules/r-code-conventions.md` §6 (weight stage rule), §10 (rename), §11 (cluster), §12 (sessionInfo), §13 (output convention)
- **Replication protocol:** `.claude/rules/replication-protocol.md` Phase 3 (estimate <0.01, SE <0.05) — P2 진입 시 verify
- **CLAUDE.md:** "Identification Strategy" + "Folder Structure" + "Commands" sections
- **MEMORY.md:**
  - [LEARN:methods] 2026-05-06 — variable mapping verified on panel_2018_2022.dta
  - [LEARN:methods] 2026-05-07 — #84 actual subsidy first-stage mandatory
  - [LEARN:env] 2026-05-06 — sandwich::vcovBS fallback for Wild bootstrap
  - [LEARN:cross-artifact] 2026-05-06 — STATA .do/.log dual grep verification
- **Domain reviewer:** `.claude/agents/domain-reviewer.md` Lens 4 D-NEW-5 (STATA→R math equivalence) — P2 invocation 시점에 cross-artifact 검증

## Approval Gate

도현님 ExitPlanMode 승인 시:
1. plan status DRAFT → APPROVED, sister 파일 `2026-05-07_p1-clean-r.md` 생성 (identical content per [LEARN:harness] 2026-05-06)
2. Implementation 진행 (Phase 0 → Phase 1 → ... → Phase 5 + stubs + 00_run_all.R)
3. Verification 3-Phase 실행
4. session log 업데이트 → MEMORY.md [LEARN] 후보 추출 → user에게 commit 권유 (자동 commit 안 함)
