---
date: 2026-05-07
status: COMPLETED
sentinel: quality_reports/plans/gleaming-juggling-frost.md
sister-post-approval: quality_reports/plans/2026-05-07_p5-synthetic-generator.md
predecessor: quality_reports/plans/2026-05-07_outlier-policy.md
spec-decisions: AskUserQuestion (2026-05-07, 4 Q answered)
---

# Plan: Step 4 P5 — Synthetic FHES Data Generator (AEA DCAS code-only verification)

## Context

PIDPS DiD-RD project은 Statistics Korea MDIS의 restricted FHES microdata에 의존한다. AJAE/Food Policy 1차 제출 시 AEA Data Editor 및 referee는 raw 데이터 access 없이 replication code의 실행 가능성과 numerical accuracy를 verify해야 한다. `domain-reviewer.md` E-7 (commit 07243e8) 에 명시된 AEA DCAS v1.0 4-요건 중 (iii) "public code + synthetic data generator"의 구체화로, 직전 commit 92cd80e에서 CLAUDE.md docs를 추가했으나 실제 코드는 미작성 상태. 본 plan은 generator + calibration JSON + README + CLAUDE.md folder structure 업데이트를 수행한다.

도현님 결정 (AskUserQuestion 2026-05-07):
- **Q1 = Hybrid (calibration JSON file)** — raw access 1회 → privacy-friendly aggregated stats만 commit, generator는 JSON만 읽음
- **Q2 = Known-ATT** — 텀페이퍼 main coefficient hard-code → AEA verifier가 numerical accuracy도 확인 가능
- **Q3 = Minimal Now** — 8 vars 우선 (P1 무관, ratchet으로 확장)
- **Q4 = New subdirectory `scripts/R/synthetic/`** — 명료성 가장 높음

## Goal

`scripts/R/synthetic/{synthetic_data_gen.R, calibration.json, README.md}` 작성 + CLAUDE.md folder structure 업데이트. AEA verifier가 raw 없이 generator 실행 → synthetic FHES `.dta` 생성 → (Step 4 P1 후) `01_clean.R → 03_did_rd.R` 파이프라인 실행 → 텀페이퍼 main ATT가 tolerance 내 recover 됨.

---

## Lock Notes (Prep grep + targeted-read 결과)

**LN-1. Raw .dta + STATA log 모두 존재 — Phase 1 calibration extraction 실행 가능.**
- `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` ✓ (14,474 obs / 3,614 farms / 2018-2022 verified 2026-05-06)
- `stata_analysis/02_analysis.log` (1,140 lines) — `D_Post` 계수 6+ 곳 추출 가능

**LN-2. `imputed_payment` formula verbatim (`01_cleaning.do:420-426`).**
```stata
gen double imputed_payment = .
replace imputed_payment = 1200000                    if area_total < 5000  & !missing(area_total)
replace imputed_payment = (area_total/10000)*2050000 if area_total >= 5000  & area_total < 20000
replace imputed_payment = (area_total/10000)*1970000 if area_total >= 20000 & area_total < 60000
replace imputed_payment = (area_total/10000)*1890000 if area_total >= 60000
replace imputed_payment = 0 if year<=2019
```
Generator: rv_2018 sample 후 `area_total = rv_2018 + 5000` 복원 → 동일 formula 적용. Calibration JSON에 imputed_payment 별도 저장 불필요 (deterministic).

**LN-3. Term-paper main spec (`02_analysis.do:268-275`) outcome 순서:**
```
y_farm_income, y_off_income, y_consump, y_farm_cost
```
Bandwidth `hA_min` (T1/T2/T3 중 min) 통일. Cluster `hhid_num`. Absorb `hhid_num year`. RV 변수: `D_Post`, `rv_Post`, `Drv_Post` (사전 계산된 interaction).

**LN-4. STATA log line 394, 442, 490, 538 (bandwidth ±500 추정값 example):**
| Outcome (line) | D_Post 계수 | SE |
|---|---|---|
| y_farm_income (394) | -3,584,777 | 2,368,291 |
| y_off_income (442) | 223,304.5 | 1,951,840 |
| y_consump (490) | 1,254,742 | 789,824.3 |
| y_farm_cost (538) | 256,102.6 | 1,464,431 |

(Phase 1 calibration extraction 시 정확 매핑 + 다른 bandwidth 4×3 = 12 cells 모두 JSON에 기록.)

**LN-5. CLAUDE.md folder structure 현재 inline 한 줄 (line 57):**
```
├── scripts/R/                  # FHES pipeline (numbered 01_clean → 05_robust) + synthetic_data_gen.R (Step 4 P5 AEA DCAS); _outputs/ has RDS/figures
```
도현님 Q4 = New subdirectory → 별도 줄로 분리.

**LN-6. Outlier policy spec (2026-05-07, APPROVED v1.1) 반영 필수.**
- 4 outcomes raw 값 (no transform) — Tier 1 baseline 재현
- `y_farm_income` 23.55% 음수 보존 — Bernoulli mixture 모델 필요 (asinh 등 변환은 robustness, generator는 raw 분포 복원)
- `imputed_payment` deterministic formula 그대로

**LN-7. R-conventions §10 변수 명명.**
Raw 데이터 변수명 (`y_farm_cost`, `D`, `area_2018`, `hhid_num`)을 generator가 출력해야 함. 이후 `01_clean.R`이 R-conventions snake_case (`op_cost`, `D_treat`, `rv_2018`, `hh_id`)로 rename. Generator는 raw 이름 사용 (FHES 호환성).

---

## Approach (5 Phases, ~120 분)

### Phase 1 — Calibration parameter extraction (~30 min)

**Sandbox:** `explorations/2026-05-07_p5-calibration/`

**Files:**
- `extract_calibration.R` (~120 lines): `haven::read_dta` → `dplyr::summarise` → `jsonlite::write_json`
- `_outputs/calibration_preview.json` — privacy-check용 미리보기 (도현님 검토)
- STATA log 파싱 helper: `parse_stata_log.R` (~40 lines, regex로 D_Post 계수 추출)

**Calibration JSON schema (~3-5 KB):**
```json
{
  "schema_version": "1.0",
  "extraction_date": "2026-05-07",
  "source": "panel_2018_2022.dta (Statistics Korea MDIS, FHES Wave 1, 2018-2022)",
  "source_sha256": "<dta hash>",
  "n_households": 3614,
  "n_obs": 14474,
  "years": [2018, 2019, 2020, 2021, 2022],
  "panel": {
    "balanced_fraction": <Phase 1 측정>,
    "obs_per_household_distribution": {"3": ..., "4": ..., "5": ...}
  },
  "rv_2018": {
    "mean": ..., "sd": ...,
    "quantiles": {"q01": ..., "q05": ..., "q10": ..., "q25": ..., "q50": ..., "q75": ..., "q90": ..., "q95": ..., "q99": ..., "max": ...},
    "fraction_treated": 0.349,
    "left_density_at_cutoff": ..., "right_density_at_cutoff": ...
  },
  "outcomes": {
    "y_farm_cost": {"mean_by_treat_year": {...}, "sd_by_treat_year": {...}, "fraction_zero": ...},
    "y_off_income": {..., "fraction_zero": 0.0499, "fraction_negative": ...},
    "y_consump": {...},
    "y_farm_income": {..., "fraction_negative": 0.2355}
  },
  "treatment_effects_known_att": {
    "spec": "reghdfe y D_Post rv_Post Drv_Post if |rv_2018|<=h, absorb(hhid_num year) vce(cluster hhid_num)",
    "source": "stata_analysis/02_analysis.log",
    "by_outcome_bandwidth": {
      "y_farm_cost": {"bw_500": ..., "bw_1000": ..., "bw_3300": ...},
      "y_off_income": {...}, "y_consump": {...}, "y_farm_income": {...}
    }
  }
}
```

**Privacy guards:**
- Quantile 정밀도: 1만원 단위 반올림 (raw 정밀도 < 1원 = re-id risk)
- Mean/SD: 유효숫자 4자리
- 개별 hh_id, sgg_cd 절대 미저장
- by_treat_year 셀 N < 10인 cell은 marginal로 합산 (small-cell suppression)

**도현님 검토 포인트:** JSON 작성 후 도현님에게 `cat _outputs/calibration_preview.json` 보여드림 → privacy 수준 OK 확인 → Phase 2 진입.

### Phase 2 — Generator script (~45 min)

**File:** `scripts/R/synthetic/synthetic_data_gen.R` (~280-350 lines)

**Section structure:**
```
1. Header (~40 lines): purpose, AEA DCAS v1.0 reference, citation, run instructions, schema_version compatibility
2. Setup: library(haven, dplyr, jsonlite); set.seed(20260507L)
3. read_calibration() → list
4. generate_household_ids(N = 3614)
5. generate_panel_structure() — 5 years × 3614 = 18,070 max; balanced_fraction에 따라 unbalanced subset → ≈14,474
6. generate_rv_2018(quantiles) — inverse-CDF interpolation (approx::approxfun on quantile points)
   → rv_2018 sample (-4986 ~ +521696 range 보존)
   → area_total = rv_2018 + 5000 복원
   → D = (rv_2018 <= 0) — deterministic, time-invariant per household
7. generate_outcomes(D, year, calibration):
   - For each outcome × treat × year cell: sample from log-normal (positive vars) or 3-component mixture (y_farm_income negative + zero + positive)
   - Independent across outcomes (Phase 1 limitation; documented in README)
8. apply_known_att(outcomes, D, year, att_table):
   - For year >= 2020: outcome[D=1] += att_value (additive injection)
   - 4 outcomes 각각 calibration JSON의 by_outcome_bandwidth["bw_500"] 사용 (T1 ATT)
9. compute_imputed_payment(area_total, year) — formula from LN-2 verbatim
10. validate_synthetic(df) — assert N=14474 ±1%, mean(D)=0.349 ±0.01,
                             fraction_negative(y_farm_income)=0.2355 ±0.02,
                             D time-invariant (per household), McCrary p > 0.10
11. recover_att_check(df) — fit feols → compare to calibration ATT (tolerance check, prints warnings if off)
12. write_outputs(df) → data/synthetic/{synthetic_panel.dta, .csv, .rds}
```

**Key design decisions:**
- **rv_2018 distribution:** quantile 9개 + max → linear interpolation inverse-CDF. Heavy right tail (q99 → max gap 큼) 처리: q99~max 사이는 Pareto fit (single param from q95-q99 ratio).
- **Treatment dummy time-invariance:** generator는 household-level rv_2018 sample 후 모든 year에 동일 값 broadcast → D 자동 time-invariant.
- **y_farm_income mixture:**
  - Bernoulli(p_neg=0.2355): negative log-normal (mean/sd from calibration cell)
  - 1 - p_neg: positive log-normal
  - (zero가 별도면 3-component; 0 비율 calibration 측정 후 결정)
- **ATT injection:** additive, T1 bandwidth ATT 사용 (가장 좁은 — variance도 가장 큼). Justification: bandwidth가 좁을수록 LATE 가까움. 다른 bandwidth ATT는 calibration JSON에 보존되어 있으므로 verifier가 cross-check 가능.
- **Independence assumption:** outcome 간 correlation 무시 (4 outcomes 독립 sample). Limitation README 명시. Future enhancement: Gaussian copula.

### Phase 3 — README + verification harness (~20 min)

**File:** `scripts/R/synthetic/README.md` (~150 lines)

**Sections:**
1. **Purpose** (AEA DCAS v1.0 4-요건 (iii) compliance, E-7 referee perspective cross-ref)
2. **Verifier workflow** (단계별):
   ```bash
   # 1. Generate synthetic FHES (raw 불필요)
   Rscript scripts/R/synthetic/synthetic_data_gen.R

   # 2. (Step 4 P1 후) clean → analyze
   Rscript scripts/R/00_run_all.R

   # 3. Verify ATT recovery
   Rscript scripts/R/synthetic/verify_recovery.R   # tolerance check
   ```
3. **Calibration provenance** (extracted 2026-05-07 from MDIS FHES Wave 1, hash recorded)
4. **Privacy statement** (aggregated stats only, 1만원 단위 반올림, small-cell suppression)
5. **Known limitations** (independence between outcomes, simple parametric forms, T1 bandwidth ATT only)
6. **MDIS application URL** (4-요건 (iv) 참고)
7. **Cross-references** (CLAUDE.md Goal §Replication standard, domain-reviewer.md E-7)

**Verification harness (optional Phase 2 내 통합):**
- Generator는 자체 self-test → assertion 실패 시 stop()
- 별도 `verify_recovery.R` (~30 lines): synthetic data로 feols fit → ATT 비교 → tolerance 보고서

### Phase 4 — CLAUDE.md update (~10 min)

**Change 1: Folder Structure 줄 분리.**

Current (line 57):
```
├── scripts/R/                  # FHES pipeline (numbered 01_clean → 05_robust) + synthetic_data_gen.R (Step 4 P5 AEA DCAS); _outputs/ has RDS/figures
```

New:
```
├── scripts/R/                  # FHES pipeline (numbered 01_clean → 05_robust); _outputs/ has RDS/figures
│   └── synthetic/              # Step 4 P5 — AEA DCAS code-only verification (synthetic_data_gen.R + calibration.json + README.md)
```

**Change 2: Goal §Replication standard 경로 명시.**

Current (line 18):
```
... (iii) public code + `scripts/R/synthetic_data_gen.R` (Step 4 P5 deliverable — synthetic FHES generator preserving covariate moments + cutoff density for code-only verification), ...
```

New:
```
... (iii) public code + `scripts/R/synthetic/` (Step 4 P5 deliverable — synthetic FHES generator + calibration JSON preserving covariate moments + cutoff density for code-only verification; Hybrid strategy per AskUserQuestion 2026-05-07), ...
```

**Change 3: Current Project State 표 한 줄 추가 (line 137-146 근처).**
```
| AEA DCAS synthetic generator (Step 4 P5) | `scripts/R/synthetic/` | ✅ Complete (2026-05-07) |
```

### Phase 5 — Sister + session log + MEMORY [LEARN] + commit + push (~15 min)

**Files to commit:**
- `scripts/R/synthetic/synthetic_data_gen.R` (~300 lines)
- `scripts/R/synthetic/calibration.json` (~3-5 KB)
- `scripts/R/synthetic/README.md` (~150 lines)
- `scripts/R/synthetic/verify_recovery.R` (~30 lines, optional)
- `explorations/2026-05-07_p5-calibration/{extract_calibration.R, parse_stata_log.R, README.md, _outputs/}`
- `CLAUDE.md` (3 changes 위)
- `quality_reports/plans/gleaming-juggling-frost.md` (sentinel, this file, DRAFT → COMPLETED)
- `quality_reports/plans/2026-05-07_p5-synthetic-generator.md` (sister, identical)
- `quality_reports/session_logs/2026-05-07_p5-synthetic-generator.md`
- `MEMORY.md` ([LEARN:methods] candidates 아래)

**Commit message:**
```
feat(synthetic): Step 4 P5 — AEA DCAS code-only verification generator

scripts/R/synthetic/{synthetic_data_gen.R + calibration.json + README}
enables AEA Data Editor / referees to verify code without MDIS access
to restricted FHES microdata. Hybrid strategy (per AskUserQuestion
2026-05-07): aggregated calibration stats (means/sd/quantiles, 1만원
정밀도) extracted once from raw, committed as privacy-friendly JSON;
generator samples 14,474 obs preserving:
  - cutoff density (continuity at rv_2018=0)
  - covariate moments (4 outcomes × treatment cell)
  - panel structure (3,614 households × 2018-2022)
  - known ATT (term-paper main result, recovered within tolerance)

CLAUDE.md folder structure: new scripts/R/synthetic/ subdirectory line.
Cross-ref: domain-reviewer.md E-7; AEA DCAS v1.0 4-요건 (iii).
```

**Push gate:** Phase 2 self-test PASS + Phase 5 verification 통과 후 `git push origin main`.

---

## Files Created / Modified / NOT Modified

**Created:**
- `scripts/R/synthetic/synthetic_data_gen.R` (~300 lines)
- `scripts/R/synthetic/calibration.json` (~3-5 KB)
- `scripts/R/synthetic/README.md` (~150 lines)
- `scripts/R/synthetic/verify_recovery.R` (~30 lines)
- `explorations/2026-05-07_p5-calibration/{extract_calibration.R, parse_stata_log.R, _outputs/, README.md}`
- `quality_reports/plans/gleaming-juggling-frost.md` (sentinel, this file)
- `quality_reports/plans/2026-05-07_p5-synthetic-generator.md` (sister)
- `quality_reports/session_logs/2026-05-07_p5-synthetic-generator.md`
- `data/synthetic/.gitkeep` (synthetic_panel.{dta,csv,rds}는 generator 실행 시 산출, gitignored)

**Modified:**
- `CLAUDE.md` (3 changes — folder structure, Goal §Replication, Current Project State)
- `MEMORY.md` ([LEARN:methods] 1-2 entries append)

**NOT modified (out of current plan scope):**
- `scripts/R/01_clean.R`–`05_figures.R` — Step 4 P1+ 위임 (generator는 raw FHES 변수명 출력, P1이 R-conventions rename)
- `.gitignore` — `data/synthetic/synthetic_panel.*`은 generator 실행 산출, 별도 gitignore 추가 검토 (Phase 5에서)
- `r-code-conventions.md` — generator는 §10 raw 이름 사용, §10 자체 변경 없음
- `Bibliography_base.bib` — AEA DCAS는 policy doc, BibTeX entry 없음 (RG report URL만)

---

## Out of Scope (별도 task / 후속 위임)

- `scripts/R/01_clean.R`–`05_robust.R` 실제 FHES-specific 코드 (Step 4 P1)
- McCrary density test 별도 implementation (Step 4 P3) — generator는 cutoff continuity 보존만
- Gaussian copula (outcome 간 correlation 보존) — Phase 2 independence assumption 강화 (future enhancement)
- Wave 2 FHES (2023+) linkage — 현재 panel 2018-2022 only
- APCS 외부 데이터 linkage — 미래 확장
- `var_dictionary.csv` 신설 — Step 4 P1
- `scripts/R/synthetic/`의 `/review-r` — P5 commit 후 별도 round
- ATT injection multiplicative variant — additive로 시작, 필요 시 v1.1
- T2/T3 bandwidth ATT injection 다중 mode — calibration JSON에는 보존, generator는 T1만 사용

---

## Open Questions

**OQ-1 (Phase 1 검토):** Calibration JSON privacy 정밀도 — 1만원 단위 반올림 (10,000 KRW = ~$7.5)이 충분한가? AEA Data Editor 표준 (보통 100원 또는 1000원)보다 더 보수적 — 도현님 보수성 검토.

**OQ-2 (Phase 2 결정):** y_farm_income 음수 모델 — Bernoulli mixture (negative log-normal | positive log-normal)이 1-pass 단순. 더 정밀하게 하려면 truncated normal + log-normal mixture. Phase 2 초기 단순 mixture로 시작, validation에서 fraction_negative ±0.02 tolerance 통과 확인.

**OQ-3 (Phase 2 결정):** ATT injection bandwidth — T1 (±500) 사용 권장 (LATE 가까움) vs T3 (MSE-optimal, 텀페이퍼 main estimate). 도현님 결정 필요. 둘 다 calibration JSON에 보존되므로 generator-time toggle 가능. 임시: T1.

**OQ-4 (Phase 5 검토):** `data/synthetic/` 디렉토리의 `synthetic_panel.{dta,csv,rds}` 파일 자체는 commit할지 (verifier가 generator 실행 안 해도 즉시 사용 가능) vs gitignore (always-fresh-from-generator). 권장: gitignore + README에 "Run generator before use" 명시. 이유: synthetic이라도 ~5MB .dta는 git bloat.

---

## Memory Candidates (Phase 5 commit 포함, 도현님 검토)

1. **[LEARN:methods]** AEA DCAS v1.0 4-요건 중 (iii) "synthetic data generator"의 Hybrid 구현 — calibration JSON (privacy-friendly aggregated stats) + generator script (calibration만 읽음) 분리 패턴. **Why:** raw 데이터 access 1회로 모든 verifier가 reproducible synthetic 생성. Pure parametric은 spec 변경 시 매번 hard-code 갱신, pure empirical은 raw 매번 필요. Hybrid는 separation of concerns. **Apply:** 모든 restricted-data 연구 (FHES, KOSIS 가계동향, 의료 패널 등) AEA DCAS 대응.

2. **[LEARN:methods]** Generator known-ATT 주입 패턴 — 텀페이퍼 main coefficient를 calibration JSON에 보존 + generator additive injection으로 synthetic 데이터에 truth 부여. **Why:** AEA verifier가 code 실행 가능성 (null 모드)뿐 아니라 numerical accuracy (estimate ≈ truth)도 직접 확인. DCAS verification robustness 강화. **Apply:** 모든 known-effect 시뮬레이션 (DiD, RD, IV).

3. **[LEARN:audit]** STATA `.log` 파일은 계량경제학 결과 reproducibility의 ground truth — `.do` 파일 (intent)뿐 아니라 `.log` (executed result)를 regex parsing으로 ATT/SE 추출 가능. Calibration JSON 자동 생성 가능. **Why:** STATA → R 포팅 검증 시 paper claim과 직접 비교 데이터 확보 (manual transcribe 오류 제거). **Apply:** STATA → R / Python 포팅 모든 quantitative paper.

(2/3개는 outlier-policy spec MEMORY [LEARN:audit] 패턴과 짝)

---

## Resume Prompt (post-approval)

Plan APPROVED. 진행 순서:
1. **Phase 1 calibration extraction** — `explorations/2026-05-07_p5-calibration/` 디렉토리 생성, `extract_calibration.R` + `parse_stata_log.R` 작성, raw .dta + STATA log 읽어 `_outputs/calibration_preview.json` 생성. 도현님께 privacy 검토 받음 (OQ-1).
2. **Phase 2 generator script** — `scripts/R/synthetic/synthetic_data_gen.R` 작성. 도현님 OQ-2 (음수 모델), OQ-3 (ATT bandwidth) 결정 받음. self-test PASS 확인.
3. **Phase 3 README + verification harness** — `scripts/R/synthetic/README.md` 작성, `verify_recovery.R` (optional).
4. **Phase 4 CLAUDE.md update** — 3 changes 적용.
5. **Phase 5 sister + session log + MEMORY + commit + push** — OQ-4 결정 (synthetic .dta commit vs gitignore).

각 Phase 완료 시 도현님께 짧은 status 보고 후 다음 진입.
