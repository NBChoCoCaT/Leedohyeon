# Requirements Specification: Outlier Policy for PIDPS DiD-RD

**Date:** 2026-05-07
**Status:** APPROVED (Dohyeon, 2026-05-07)
**Plan:** `quality_reports/plans/playful-popping-badger.md` (sister: `2026-05-07_outlier-policy.md`)
**Predecessor session log:** `quality_reports/session_logs/2026-05-06_step-3-3-plan.md`
**EDA evidence:** `explorations/2026-05-07_outlier-eda/_outputs/`
**Author:** Lee, Dohyeon (Claude assist)

---

## 1. Objective

PIDPS DiD-RD 분석의 5개 변수 (4 outcomes + `imputed_payment`)에 대한 outlier 정책을 3-tier 구조 (term-paper baseline / term-paper robustness / AJAE additions)로 lock-in 하여, STATA → R 포팅 (Step 4 P1, `scripts/R/01_clean.R`) 진입 시점에 일관된 정책을 보장한다.

**Running variable `area_2018` (`rv_2018`)는 본 정책 범위에서 제외** — DiD-RD identification 보호 (cutoff 주변 density 왜곡 방지). McCrary density test는 별도 robustness (Step 4 P3).

---

## 2. Requirements

### MUST Have (Non-Negotiable)

- [x] **M1.** Term-paper baseline 정확 재현: 4 outcomes (`y_farm_income`, `y_off_income`, `y_consump`, `y_farm_cost`) raw 값으로 main spec (`reghdfe` → R `feols`) 진입. Outlier 처리 없음. (Source: `02_analysis.do:268-275`.)
- [x] **M2.** Term-paper robustness 재현: (B) IHS 변환 `asinh(y)` for 4 outcomes × 3 bandwidths (500/1000/3300) — 별도 table. (Source: `06_robustness_aux.do:90-121`.)
- [x] **M3.** Term-paper robustness 재현: (C) Winsorize p1/p99 `winsor2 y, cuts(1 99)` for 4 outcomes × 3 bandwidths — 별도 table. (Source: `06_robustness_aux.do:136-184`.)
- [x] **M4.** `imputed_payment` formula 보존: `01_cleaning.do:420-426` deterministic rule (1.2M flat for `area_total<5000`; area-proportional 2.05M/1.97M/1.89M tier-by-tier). Outlier 처리 없음.
- [x] **M5.** `area_2018` (running variable) outlier 처리 금지. McCrary 검정 결과 변동 방지.
- [x] **M6.** Outlier 제외 시 R 코드는 `dplyr::mutate(y = if_else(cond, NA_real_, y))` 패턴 (NA 처리). STATA `replace v = . if cond` 와 mathematical-equivalent. **명시적 `dplyr::filter()` drop 금지** — sample size 변경은 보고 의무 (replication-protocol Phase 3).
- [x] **M7.** 모든 robustness 처리는 main spec과 분리된 별도 결과 export. main 결과의 변수 자체를 변경하지 않음.

### SHOULD Have (Preferred)

- [ ] **S1.** AJAE robustness E'' (Domain implausibility, ratio-based): `pcost = y_farm_revenue / y_farm_cost`. 임시 임계값 `pcost < 0.1 OR pcost > 100` → 4 outcomes 모두 NA 처리 후 재추정. (Source 정합: `10_highvalue_checks.do:96` 동일 변수 사용.) 구체 임계값은 별도 pcost 분포 EDA (1회) 후 refinement.
- [ ] **S2.** AJAE robustness F (Conservative winsorize): `winsor 0.5/99.5` for 4 outcomes × 3 bandwidths — 별도 table. Term-paper Winsorize p1/p99 (M3)에 더해 더 보수적인 추가 robustness.
- [ ] **S3.** EDA 분포 근거 첨부 (`explorations/2026-05-07_outlier-eda/_outputs/`).
- [ ] **S4.** AJAE-style "robustness ladder" 별도 table 출력 (baseline → IHS → winsor99 → winsor99.5 → pcost-implausibility) — main text는 baseline + 1-2 hint, online appendix에 ladder 전체.

### MAY Have (Optional, If Time)

- [ ] **A1.** Bandwidth × outlier 정책 cross-tab (e.g., T1+winsor99 vs T1+winsor99.5+pcost) — referee 추가 robustness 요청 대비.
- [ ] **A2.** Heterogeneity (5 dim × 4 outcome) 추정에서도 동일 outlier 정책 일관 적용 (Step 4 P3 위임).
- [ ] **A3.** Sub-district `sgg_cd` cluster robustness 시 동일 outlier 정책 (dissertation extension).

### REJECTED (with reason)

- [x] **R1.** Candidate B (log(y+1)) 폐기. **이유:** EDA H3 결과 `y_farm_income` 23.55% 음수 (3,408 적자 농가, real economic phenomenon). `log(음수+1) = NaN` → 데이터 손실. asinh (M2)이 음수 처리 가능한 정확 변환.
- [x] **R2.** Candidate D (Drop top 1% 실제 drop) 폐기. **이유:** sample size 변경 → RDD identification 손상 + replication-protocol Phase 3 보고 부담.
- [x] **R3.** Candidate A (Asinh) AJAE 추가 채택 폐기. **이유:** M2 (텀페이퍼 robustness B)에 이미 포함, 중복.
- [x] **R4.** Candidate C (Winsor 1/99) AJAE 추가 채택 폐기. **이유:** M3 (텀페이퍼 robustness C)에 이미 포함, 중복.
- [x] **R5.** Candidate E (도현님 원본: `y_farm_cost > 10×y_farm_income`) 재정의 후 폐기. **이유:** `y_farm_income < 0` 일 때 (23.55%) 비교 misfire → `y_farm_revenue` 기반 ratio (E'')로 대체.

---

## 3. Clarity Status

| Aspect | Status | Notes |
|---|---|---|
| 5 variables coverage | CLEAR | y_farm_cost, y_off_income, y_consump, y_farm_income, imputed_payment (Q2 답변) |
| `area_2018` 제외 정당성 | CLEAR | DiD-RD running variable identification 보호 (Plan LN-5) |
| Term-paper baseline 정의 | CLEAR | `02_analysis.do:268-275` raw 4 outcomes (Plan LN-1) |
| Term-paper robustness 정의 | CLEAR | `06_robustness_aux.do` (B) IHS + (C) winsor99 (Plan LN-2) |
| AJAE additions 선택 | CLEAR | E'' (pcost ratio) + F (winsor 0.5/99.5) (Q-A 답변) |
| pcost 임계값 (`< 0.1` / `> 100`) | ASSUMED | 임시값. 별도 pcost 분포 EDA 1회 후 refinement (Q-A 답변) |
| outlier 제외 R 패턴 | CLEAR | `dplyr::mutate(y = if_else(cond, NA_real_, y))` (Q-2 답변) |
| imputed_payment formula audit | CLEAR (cross-ref) | 본 spec 결정 사항 아님; Step 4 별도 task 위임 (Q-C 답변) |
| 결과 export 구조 | CLEAR | main spec 변수 불변 + robustness별 별도 table (M7) |
| log(y+1) 채택 여부 | CLEAR | 폐기 (R1, EDA H3 23.55% 음수) |

---

## 4. Decision Summary Matrix

5 variables × 3 tiers — 각 cell의 R 처리 한 줄.

| Variable | Tier 1 (baseline, MUST) | Tier 2 (term-paper robustness, MUST) | Tier 3 (AJAE additions, SHOULD) |
|---|---|---|---|
| `y_farm_cost` | raw, no transform | `asinh(y_farm_cost)` AND `winsor2(y_farm_cost, c(0.01, 0.99))` 별도 table | `winsor2(y_farm_cost, c(0.005, 0.995))` AND pcost-implausible→NA 별도 table |
| `y_off_income` | raw, no transform | `asinh(y_off_income)` AND `winsor2(y_off_income, c(0.01, 0.99))` 별도 table | `winsor2(y_off_income, c(0.005, 0.995))` AND pcost-implausible→NA 별도 table |
| `y_consump` | raw, no transform | `asinh(y_consump)` AND `winsor2(y_consump, c(0.01, 0.99))` 별도 table | `winsor2(y_consump, c(0.005, 0.995))` AND pcost-implausible→NA 별도 table |
| `y_farm_income` | raw, no transform (음수 보존) | `asinh(y_farm_income)` AND `winsor2(y_farm_income, c(0.01, 0.99))` 별도 table | `winsor2(y_farm_income, c(0.005, 0.995))` AND pcost-implausible→NA 별도 table |
| `imputed_payment` | formula 그대로 (`01_cleaning.do:420-426`) | (해당 없음 — outlier 변수 아님) | (해당 없음 — formula audit은 Step 4 별도 task) |

**Notation:**
- `winsor2(x, c(a, b))` = R `DescTools::Winsorize(x, probs = c(a, b))` 또는 동등 함수.
- `pcost-implausible→NA` = `y_farm_revenue / y_farm_cost < 0.1` OR `> 100` 인 행에 대해 4개 outcome 모두 NA 처리 (S1).
- `asinh()` = R base `asinh()`.

---

## 5. Variable-by-Variable Rules

### 5.1 `y_farm_cost` (농업경영비 전체, primary lumpy-investment outcome)

**Tier 1 (baseline, MUST):** raw 값으로 `feols(y_farm_cost ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = sub, cluster = ~hh_id)` 진입. Sample restriction `abs(rv_2018) ≤ h` 단 하나. Pre-transform 없음.

**Tier 2 (term-paper robustness):**
- (B) IHS: `asinh(y_farm_cost)` 변수 새로 만들어 동일 spec 재추정 → table_rob_ihs (`06_robustness_aux.do:90-121` 재현).
- (C) Winsor p1/p99: `DescTools::Winsorize(y_farm_cost, probs = c(0.01, 0.99))` → table_rob_winsor99 (`06_robustness_aux.do:136-184` 재현).

**Tier 3 (AJAE additions, SHOULD):**
- (F) Winsor 0.5/99.5: `DescTools::Winsorize(y_farm_cost, probs = c(0.005, 0.995))` → table_rob_winsor995.
- (E'') pcost-implausibility: `mutate(across(c(y_farm_cost, y_off_income, y_consump, y_farm_income), ~ if_else(pcost < 0.1 | pcost > 100, NA_real_, .x)))` where `pcost = y_farm_revenue / y_farm_cost` → table_rob_pcost.

**EDA 근거:** EDA full N=14,474 — y_farm_cost: min=32,456 (양수만), median=10.04M, p99=350M, max=1.93B. mean/median = 3.27 (heavy right-tail) → IHS 정당성. 음수/0 비율 0% → log(y+1) 비교 무의미하지만 채택 안 함 (정책 일관성).

### 5.2 `y_off_income` (농외소득, precautionary labor outcome)

**Tier 1 / Tier 2 / Tier 3:** y_farm_cost와 동일 패턴.

**EDA 근거:** zero 4.02% (582건) + 음수 0.97% (140건) = 4.99% (5% 임계값 직전). asinh가 정확 처리; winsor99도 lower tail 영향 있음 (p1=0).

### 5.3 `y_consump` (가계소비지출, smoothing outcome)

**Tier 1 / Tier 2 / Tier 3:** y_farm_cost와 동일 패턴.

**EDA 근거:** min=2.66M (양수만), p1=6.90M, mean/median=1.11 (mild skew). 가장 정상 분포에 가까움; transform 효과 작음.

### 5.4 `y_farm_income` (농가소득, omnibus outcome)

**Tier 1 (baseline):** raw 값 — **음수 23.55% (3,408건) 보존**. 농가 적자는 real economic phenomenon, outlier 아님.

**Tier 2 / Tier 3:**
- IHS asinh()는 음수 처리 가능 (M2 적용 가능).
- Winsor p1/p99: p1=-44.2M (음수 cap), p99=177.2M. Winsor는 양면 절단이므로 음수 절단 의미 보존.
- log(y+1) 폐기 (R1) — `y_farm_income < -1` 일 때 NaN.

**EDA 근거:** mean/median=3.57 (가장 heavy right-tail), min=-355.5M, max=1003.4M, p1=-44.2M (음수), p99=177.2M, 음수 23.55% (3,408 농가). Transform 함수 선택 시 음수 처리 가능 여부가 first-order 고려.

### 5.5 `imputed_payment` (treatment intensity proxy)

**Tier 1:** `01_cleaning.do:420-426` formula 그대로 적용 — outlier 처리 없음.

```stata
gen double imputed_payment = .
replace imputed_payment = 1200000                      if area_total < 5000  & !missing(area_total)
replace imputed_payment = (area_total/10000)*2050000   if area_total >= 5000  & area_total < 20000
replace imputed_payment = (area_total/10000)*1970000   if area_total >= 20000 & area_total < 60000
replace imputed_payment = (area_total/10000)*1890000   if area_total >= 60000
replace imputed_payment = 0                            if year <= 2019
```

**Tier 2 / Tier 3: 해당 없음.**

**EDA 근거:** 3-cluster 분포 — zero (year≤2019 + missing area): 5,697 (39.4%), flat 1.2M (SFFP): 3,204 (22.1%), area-proportional: 5,573 (38.5%). Bimodal/trimodal 분포는 deterministic formula로 induced. Outlier 정책이 아닌 **formula audit** (rate-tier 정확성 cross-check vs 정부 고시) 필요 — **Step 4 별도 task 위임** (cross-ref Section 8).

> **Note (OQ-3 cross-reference):** `imputed_payment` formula의 정부 고시 (2020년 농림축산식품부 공익직불제 시행 규정) 정확성 검증은 본 spec 결정 사항이 **아님**. Step 4 별도 task에서 다룬다 — `01_cleaning.do:420-424` rate (1.2M flat / 2.05M / 1.97M / 1.89M)과 정부 고시 표를 line-by-line 대조해야 함. Cross-reference: 본 spec Section 8.

---

## 6. STATA → R Verbatim Mapping

### 6.1 Baseline (M1)

**STATA (`02_analysis.do:268-275`):**
```stata
rwolf2 ///
    (reghdfe y_farm_income D_Post rv_Post Drv_Post if abs(rv_2018)<=`hA_min', absorb(hhid_num year) vce(cluster hhid_num)) ///
    (reghdfe y_off_income  D_Post rv_Post Drv_Post if abs(rv_2018)<=`hA_min', absorb(hhid_num year) vce(cluster hhid_num)) ///
    (reghdfe y_consump     D_Post rv_Post Drv_Post if abs(rv_2018)<=`hA_min', absorb(hhid_num year) vce(cluster hhid_num)) ///
    (reghdfe y_farm_cost   D_Post rv_Post Drv_Post if abs(rv_2018)<=`hA_min', absorb(hhid_num year) vce(cluster hhid_num)) ///
    , indepvars(D_Post) reps(500) seed(20260420) verbose
```

**R 등가 (M1 + M6 + r-code-conventions §10 rename 적용 후):**
```r
sub <- df |> dplyr::filter(abs(rv_2018) <= h)
out_list <- lapply(c("op_cost", "off_farm_income", "consumption", "farm_income"), function(y) {
  fixest::feols(
    as.formula(paste(y, "~ D_Post + rv_Post + Drv_Post | hh_id + year")),
    data = sub, cluster = ~hh_id
  )
})
# Wild cluster bootstrap + Romano-Wolf via sandwich::vcovBS + manual Holm/RW
# (fwildclusterboot fallback per MEMORY.md [LEARN:env] 2026-05-06)
```

**D-NEW-5 (mathematical-equivalence) check:** R `feols(y ~ D_Post + rv_Post + Drv_Post | hh_id + year)` ≡ STATA `reghdfe y D_Post rv_Post Drv_Post, absorb(hhid_num year) vce(cluster hhid_num)`. Verified per `domain-reviewer.md` Lens 4 D-NEW-5.

### 6.2 IHS Robustness (M2)

**STATA (`06_robustness_aux.do:92-95`):**
```stata
foreach y of local YVARS {
    gen double ihs_`y' = asinh(`y')
    label variable ihs_`y' "IHS(`y') = asinh(`y')"
}
```

**R 등가:**
```r
df <- df |> dplyr::mutate(across(all_of(c("op_cost","off_farm_income","consumption","farm_income")),
                                  ~ asinh(.x), .names = "ihs_{.col}"))
```

### 6.3 Winsor p1/p99 Robustness (M3)

**STATA (`06_robustness_aux.do:142-145`):**
```stata
foreach y of local YVARS {
    winsor2 `y', cuts(1 99) suffix(_w99)
    label variable `y'_w99 "`y' (winsorized p1/p99)"
}
```

**R 등가:**
```r
df <- df |> dplyr::mutate(across(all_of(c("op_cost","off_farm_income","consumption","farm_income")),
                                  ~ DescTools::Winsorize(.x, probs = c(0.01, 0.99), na.rm = TRUE),
                                  .names = "{.col}_w99"))
```

### 6.4 imputed_payment Formula (M4)

**STATA (`01_cleaning.do:420-426`):** 위 Section 5.5 인용 그대로.

**R 등가 (Step 4 P1 `01_clean.R` 작성 시):**
```r
df <- df |> dplyr::mutate(
  imputed_payment = dplyr::case_when(
    is.na(area_total)                        ~ NA_real_,
    area_total < 5000                        ~ 1200000,
    area_total < 20000                       ~ (area_total / 10000) * 2050000,
    area_total < 60000                       ~ (area_total / 10000) * 1970000,
    area_total >= 60000                      ~ (area_total / 10000) * 1890000
  ),
  imputed_payment = dplyr::if_else(year <= 2019, 0, imputed_payment)
)
```

### 6.5 Winsor 0.5/99.5 (S2, AJAE addition)

**R (텀페이퍼 STATA 없음, AJAE 신규):**
```r
df <- df |> dplyr::mutate(across(all_of(c("op_cost","off_farm_income","consumption","farm_income")),
                                  ~ DescTools::Winsorize(.x, probs = c(0.005, 0.995), na.rm = TRUE),
                                  .names = "{.col}_w995"))
```

### 6.6 pcost Implausibility (S1, AJAE addition)

**R (텀페이퍼 부분 사용 `10_highvalue_checks.do:96`):**
```r
df <- df |> dplyr::mutate(
  pcost = dplyr::if_else(y_farm_cost > 0, y_farm_revenue / y_farm_cost, NA_real_),
  pcost_implausible = !is.na(pcost) & (pcost < 0.1 | pcost > 100)
)
df_pcost <- df |> dplyr::mutate(across(
  all_of(c("op_cost","off_farm_income","consumption","farm_income")),
  ~ dplyr::if_else(pcost_implausible, NA_real_, .x)
))
```

> **Note (S1 임시 임계값):** `0.1` / `100`은 plausibility 가설 1차 통과값. 별도 pcost 분포 EDA 1회 (e.g., `explorations/2026-05-XX_pcost-eda/`) 후 refinement — Step 4 P1 진입 직전.

---

## 7. EDA Evidence

`explorations/2026-05-07_outlier-eda/_outputs/`:

- `distribution_table.csv` — 5 vars × 14 stats × 2 subsamples (full N=14,474 / cutoff-near `|rv_2018|≤1000` N=1,777). 본 spec의 모든 분포 인용은 이 파일에서 가져옴.
- `boxplot_5vars.png` — log-scale, year-by-year facet.
- `hist_5vars.png` — raw + log10 dual-panel histogram.
- `findings.md` — H1-H4 hypothesis 자동 평가:
  - **H1 (right-skew):** ✅ 5/5 vars right-skewed (mean > median).
  - **H2 (imputed bimodal):** ✅ formula-induced 3 cluster (zero 5,697 / flat 1.2M 3,204 / area-prop 5,573).
  - **H3 (zero/neg ≥ 5%):** ⚠️ TRUE — y_farm_income 23.55% 음수, y_off_income 4.99%, 나머지 0%.
  - **H4 (cutoff similarity):** △ 부분 — median ratio 0.83-1.92 (cutoff-near 작은 농가 → 작은 outcome, 예상).

**핵심 분포 수치 (Section 5 변수별 인용):**

| Variable | min | p1 | median | p99 | max | mean/median | n_zero | n_neg |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| y_farm_cost | 32,456 | 647,584 | 10.04M | 350M | 1.93B | 3.27 | 0 | 0 |
| y_off_income | -167.2M | 0 | 5.57M | 115.1M | 438.6M | 3.01 | 582 | 140 |
| y_consump | 2.66M | 6.90M | 24.71M | 74.5M | 385.0M | 1.11 | 0 | 0 |
| y_farm_income | -355.5M | -44.2M | 4.13M | 177.2M | 1003.4M | 3.57 | 0 | 3,408 |
| imputed_payment | 0 | 0 | 1.2M | 16.1M | 586.9M | 1.65 | 5,697 | 0 |

---

## 8. Cross-References

- **Plan:** `quality_reports/plans/playful-popping-badger.md` (sister: `2026-05-07_outlier-policy.md`)
- **R conventions:** `.claude/rules/r-code-conventions.md` §10 (variable rename `y_farm_cost → op_cost`, `y_off_income → off_farm_income`, `y_consump → consumption`, `y_farm_income → farm_income`)
- **Replication protocol:** `.claude/rules/replication-protocol.md` Phase 3 tolerance (estimate <0.01, SE <0.05) — outlier 정책 변경은 phase 3 retest trigger.
- **Domain reviewer:** `.claude/agents/domain-reviewer.md` Lens 2 (theory consistency: lumpy investment + (S,s) 모형이 raw 4 outcomes에 직접 적용된다는 가정), Lens 4 D-NEW-5 (STATA→R mathematical-equivalence).
- **Quality gates:** `.claude/rules/quality-gates.md` (outlier 정책 변경 시 score recalculation).
- **CLAUDE.md identification snapshot:** `rv_2018 = area_2018 - 5000` centered, cutoff at `rv_2018 = 0` (5 ha cutoff at `area_2018 = 5,000` m²) — running variable 정의는 본 spec 범위 밖.
- **EDA evidence:** `explorations/2026-05-07_outlier-eda/_outputs/`.
- **Step 4 P1 위임:** `imputed_payment` formula audit (rate-tier vs 정부 고시 정확성 cross-check) — 본 spec 외 별도 task. (OQ-3 답변 per Q-C.)
- **STATA source files:** `master_supporting_docs/own_drafts/stata_analysis/{01_cleaning.do, 02_analysis.do, 06_robustness_aux.do, 10_highvalue_checks.do}` — `.gitignore` 보호.
- **MEMORY.md cross-ref:** [LEARN:methods] 텀페이퍼 outlier 정책 (Phase 5 신규 추가); [LEARN:methods] 음수 비율 사전 확인 (Phase 5 신규 추가); [LEARN:audit] STATA `replace v = .` ↔ R NA 동등 (Phase 5 신규 추가).

---

## 9. Success Criteria

**Phase 5 commit 시점:**

1. ✅ `01_clean.R` 미작성 — 본 spec은 코드 결정이 아닌 정책 lock (Step 4 P1 위임 명시).
2. ✅ 5 variables × 3 tiers × R 코드 한 줄 모두 명시 (Section 4 matrix + Section 6 verbatim).
3. ✅ EDA 분포 근거 첨부 (`explorations/2026-05-07_outlier-eda/_outputs/`, Section 7).
4. ✅ MUST/SHOULD/MAY 등급 각 항목 EDA 또는 STATA source 인용으로 정당화.
5. ✅ REJECTED 항목 (R1-R5) 각각 명시적 이유.

**Step 4 P1 시점 (`scripts/R/01_clean.R` 작성 후):**

1. ☐ Term-paper baseline 추정값 ≡ R baseline 추정값 (replication-protocol Phase 3 tolerance: estimate <0.01, SE <0.05).
2. ☐ Term-paper IHS robustness 추정값 ≡ R asinh() 추정값 (동일 tolerance).
3. ☐ Term-paper Winsor99 추정값 ≡ R Winsorize() 추정값 (동일 tolerance).
4. ☐ AJAE additions (S1, S2) 별도 table 출력 — 부호/유의성 main 결과와 비교 보고.
5. ☐ Sample size 변경 사항 보고: pcost-implausibility로 N → N-? 명시.

**spec 안정화 (1-2 R 사용 사이클 후):**

1. ☐ `r-code-conventions.md` §12 "Outlier Policy" promotion (별도 commit).
2. ☐ pcost 임계값 0.1 / 100 → 데이터 기반 refinement.

---

## 10. Approval

- **Drafted:** 2026-05-07 (Claude assist)
- **Reviewed:** Lee, Dohyeon — 4 phases incrementally (Q1-Q4 + Q-A/Q-B/Q-C)
- **Status:** **APPROVED** (Dohyeon, 2026-05-07).
- **Next gate:** Step 4 P1 진입 직전 pcost 분포 EDA 추가 → S1 임계값 refinement → spec re-approval (별도 commit).

[x] User approved (date): 2026-05-07

---

## Appendix A — Open Questions Resolution Trail

| OQ | Resolution | Source |
|---|---|---|
| OQ-1 | E + F 둘 다 채택 | Q-A 답변 (Phase 3) |
| OQ-2 | `dplyr::mutate + NA_real_` (M6) | Q-2 답변 (Plan) |
| OQ-3 | imputed_payment formula audit cross-ref Section 5.5 + Section 8 (Step 4 위임) | Q-C 답변 (Phase 3) |
| OQ-4 | log(y+1) 폐기 (R1) — y_farm_income 23.55% 음수 → NaN 손실 | Q-B 답변 (Phase 3) |
| Q-A | E (원본) → E'' (`pcost` ratio 기반) 재정의 | Phase 3 EDA-driven |

## Appendix B — STATA File Coverage

| File | Lines used in spec | Tier mapped |
|---|---|---|
| `01_cleaning.do` | 420-426 | M4 (imputed_payment) |
| `02_analysis.do` | 268-275 | M1 (baseline) |
| `06_robustness_aux.do` | 90-121 | M2 (IHS) |
| `06_robustness_aux.do` | 136-184 | M3 (Winsor99) |
| `10_highvalue_checks.do` | 96 | S1 (pcost ratio source pattern) |

(나머지 12 .do 파일은 본 spec 결정 사항과 무관 — Step 4 P1 진입 시 코드 작성 참조용으로만 사용.)
