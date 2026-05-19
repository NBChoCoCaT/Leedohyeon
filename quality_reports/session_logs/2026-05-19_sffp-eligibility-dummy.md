# Session Log: 2026-05-19 — SFFP 자격 더미 (요건 1+2+6) 구성 및 기존 D 비교

**Status:** COMPLETED

## Objective

CLAUDE.md / `01_clean.R`은 SFFP 자격을 "0.5ha 컷오프 = 1.2M flat" sharp treatment로 가정. 사용자가 실제 SFFP 자격은 8요건 모두 충족 시에만 부여됨을 지적 (요건 1 경작면적, 2 소유면적 < 1.55ha, 3 영농기간 ≥ 3년, 4 거주기간 ≥ 3년, 5 개인 농외소득 < 2,000만, 6 농가 농외소득 < 4,500만, 7 농업경영체 등록, 8 공익기능 준수). 데이터로 검증 가능한 1+2+6을 결합한 `D_eligible_obs_2018` 더미를 만들고, 기존 `D_treat`와 표본·기초통계 차이를 정량화하여 식별 전략 재조정의 근거 마련.

## Changes Made

| File | Change | Reason | Quality Score |
|------|--------|--------|---|
| `scripts/R/01b_eligibility.R` | NEW (~250 lines) — raw 원부_토지 5년치 재집계 + eligibility 더미 + 비교 통계 | 비파괴적 보조 스크립트로 canonical pipeline (01_clean.R, clean.rds) 보존 | n/a (비추정 스크립트) |
| `scripts/R/_outputs/clean_with_eligibility.rds` | NEW | 신규 컬럼 포함 panel | — |
| `scripts/R/_outputs/eligibility_compare.{txt,rds}` | NEW | 비교 통계 로그 + 객체 | — |
| `scripts/R/_outputs/eligibility_compare_table.md` | NEW | 사람 읽기용 비교 표 | — |

**미수정:** `01_clean.R`, `clean.rds`, `02_descriptive.R`–`10_alpha3_estimation.R`, `CLAUDE.md`, `paper/en/main.tex`. P3b-2 기존 결과 (3-channel monotone gradient, −11.1% pass-through) 보존.

## Design Decisions

| Decision | Alternatives Considered | Rationale |
|----------|------------------------|-----------|
| 신규 보조 스크립트 `01b_eligibility.R` (`01_clean.R` 미수정) | `01_clean.R` 직접 수정 | Canonical pipeline 검증 무결성 유지; 다운스트림 영향 차단; 비교 결과 본 후 변경 범위 결정 가능 |
| 2018-baseline (`D_eligible_obs_2018`) 주분석 비교 | year-varying `D_eligible_obs_t` | `D_treat`도 2018 baseline이라 anti-manipulation 일관; year-varying은 보조로 함께 생성 |
| 소유면적 = ownership ∈ {1, 3} 합산 | ownership=1만 (기존 `area_own`과 동일) | 요건 #2의 "총 소유 농지"는 자가경작(=1) + 임대해 준 소유(=3) 모두 포함; ownership=3은 raw의 5.9%로 무시 불가 |
| `D_eligible_obs_2018 ⊆ D_treat` 부분집합 enforcing (logical AND with D_area) | 독립적 정의 | SFFP는 면적 컷오프 통과가 필요조건; 부분집합 관계가 fuzzy RD 1단계 해석과도 일관 |

## Incremental Work Log

**12:10 KST:** 사용자가 SFFP 8요건 명시. 현재 D는 요건 #1만 체크. 데이터 가용성 매핑 (1+2+6 가능, 3/4/5는 약함, 7/8 불가) 후 티어드 더미 권고.

**12:18 KST:** 사용자 승인 — "요건 1+2+6 변수 설정 후, 기존 D와 기초통계량 차이 확인". m² 단위 확정.

**12:22 KST:** 탐색 — `01_clean.R` 입력은 `panel_2018_2022.dta` (STATA로 이미 집계됨); raw CSV는 별도 처리 필요. `01_cleaning.do` line 57–106에서 area aggregation 확인 → 현재 `area_own = sum(area_raw × 1[ownership=1])`만 (ownership=3 누락).

**12:25 KST:** ownership 분포 확인 — 2018년 ownership=1: 18,104건 / =2: 10,894 / =3: 1,822 (5.9%). 지목 분포 확인 — 농지 (11/12/21/22/23) ≈ 80%. 5년 schema 일관.

**12:28 KST:** Plan 작성 (foamy-squishing-aurora.md), 승인 후 `01b_eligibility.R` 구현.

**12:29 KST:** 스크립트 실행 — 100% linkage, 모든 sanity check 통과.

## Learnings & Corrections

- **[LEARN:identification]** SFFP 자격은 8요건 (1 경작면적 ≤ 0.5ha, 2 소유면적 < 1.55ha, 3 영농 ≥ 3y, 4 거주 ≥ 3y, 5 개인 농외소득 < 2,000만, 6 농가 농외소득 < 4,500만, 7 농업경영체 등록, 8 공익기능 준수) 모두 충족 시. **현재 `D_treat`는 요건 #1만 체크 → ITT 해석이 정확** (sharp ATT 아님). Effective payment is flat 1.2M/year (2020–2024), 1.3M (2025+) — 금액 정액 framing은 유지.
- **[LEARN:data]** Raw 원부_토지의 `원시자료제공키값`이 panel의 `hhid` (string) → `hh_id` (integer) 매핑의 시작점. `clean.rds`는 `hhid` 문자열 보존하므로 raw CSV ↔ panel 직접 merge 가능.
- **[LEARN:data]** 기존 `area_own` (panel) = `ownership=1`만 포함 (자가소유 + 자작). SFFP 요건 #2의 "총 소유면적"이 아님. ownership=3 (임대해 준 소유) 5.9% 추가 집계 필요.
- **[LEARN:methods]** 면적 기준 treated 농가의 **14.6%가 SFFP 실제 부적격** (대부분 농외소득 초과 — 단일 변수로 12.8%). 면적·연령·자작비율은 거의 동일하나 농외소득은 −40% 차이.
- **[LEARN:workflow]** 비파괴적 보조 스크립트 (`01_clean.R` 미수정, 신규 `01b`) 패턴이 검증된 pipeline 보존 + 비교/탐색에 적합.

## Verification Results

| Check | Result | Status |
|-------|--------|--------|
| `nrow(clean_with_eligibility) == nrow(clean)` | 14,474 == 14,474 | PASS |
| Linkage rate (raw 원부_토지 ↔ panel) | 100.000% | PASS |
| `area_owned_total ≥ area_owned_cultiv` ∀ obs | TRUE | PASS |
| `cor(area_owned_cultiv [재집계], area_own [기존])` | 1.0000 | PASS (STATA→R equivalence) |
| `D_eligible_obs_2018 ⊆ D_treat` | TRUE | PASS |
| `D_treat unchanged` from canonical | TRUE | PASS |
| Sample waterfall: 1,325 → 1,301 (−24, req 2) → 1,131 (−170, req 6) | 14.6% loss | PASS (numerical) |

## Open Questions / Blockers

- [ ] **주분석 트리트먼트를 `D_eligible_obs_2018`로 승격할지** — ATT vs ITT 해석 trade-off (별도 plan 필요)
- [ ] **Fuzzy RD 1단계** — `actual_subsidy ∈ [1.1M, 1.3M]`을 SFFP 수령 proxy로 한 LATE 추정 가능성 (별도 task)
- [ ] **요건 #3, #4, #5 proxy 구성** — 가구원현황 raw (`전입월`, `취업상태코드`)로 거주기간/개인 농외소득 proxy 시도 가능 (후속)
- [ ] **CLAUDE.md identification 섹션 업데이트** — SFFP 자격이 8요건임을 명시, "Sharp DiD-RD → area-based ITT" 재기술 (사용자 결정 후 수정)
- [ ] **P3b-2 결과 재해석** — 3-channel monotone gradient는 D_eligible_obs_2018로 재추정 시 강해질 가능성 (always-takers 제거 효과); 표본 14.6% 손실로 SE 변화 모니터링 필요

## Phase 2 — Option B 재추정 (D_eligible_obs_2018 + subset analysis)

**13:18 KST:** 사용자 "Option B Bypass 진행" — `D_eligible_obs_2018` 재추정 + 결과 비교 즉시 실행.

**구현:** `scripts/R/03b_did_rd_eligibility.R` — Subset analysis (treated-but-ineligible 194 hh / 785 obs 제거 → 3,420 hh / 13,689 obs), `D_eligible_obs_2018` 트리트먼트, 동일 bandwidth (03_did_rd.R 값 고정), 동일 specification (FE: hh_id + year, cluster: hh_id).

**산출물:**
- `_outputs/main_results_eligibility.rds` — list(specs, results, sample_info, comparison)
- `_outputs/eligibility_estimation_compare.{txt,md}` — 24-cell side-by-side

**핵심 결과 (24 cells):**

| 차이 metric | 값 |
|---|---|
| Sign flip | **2 / 24** (모두 off_farm_income, 둘 다 비유의 → 정보가치 없음) |
| α=0.05 cross | **0 / 24** (모든 5% 유의 결과 보존) |
| α=0.10 cross | 2 / 24 (op_cost B-T2: \* → 비유의 p=0.117; consumption B-T3: 비유의 → \*) |
| Median \|%Δ\| coefficient | 16.5% |

**Primary outcome (op_cost — (S,s) lumpy-investment anchor, P3b-1 headline):**

| Spec | BW | Original (D_treat) | New (D_eligible) | %Δ |
|------|-----|---:|---:|---:|
| A | T1 | −4,180k\*\* (p=0.046) | −4,134k\*\* (p=0.048) | +1.1% |
| A | T2 | −3,348k\* (p=0.069) | −3,276k\* (p=0.085) | +2.2% |
| B | T1 | −5,032k\* (p=0.066) | −5,052k\* (p=0.066) | −0.4% |
| B | T2 | −4,758k\* (p=0.096) | −4,792k (p=0.117) | −0.7% |

**결론:** P3b-1 (S,s) 음의 op_cost 효과는 SFFP 자격 정의 변경에 **매우 안정적** (절댓값 변화 1–3%). 일반적으로 14.6% always-takers 제거 시 LATE가 더 강해질 수 있으나, 본 표본에서는 거의 변화 없음 — 이는 *제외된 194 농가가 op_cost 변화에서 control과 유사하게 행동했다*는 의미.

## Verification Results (Phase 2 추가)

| Check | Result | Status |
|-------|--------|--------|
| Sharp cutoff on subset: `D_elig == 1[rv_2018≤0]` ∀ obs | TRUE | PASS |
| 24 cells fit (Spec A × 3 BW × 4 outcomes + Spec B × 3 BW × 4 outcomes) | All converged | PASS |
| op_cost A-T1 robust to ITT/eligible definition | |Δ|=1.1% | PASS |
| α=0.05 결과 보존 | 0/24 crosses | PASS |
| 추정 시간 | 0.2s | PASS |

## Next Steps

- [ ] **권고 방향 (P3b-1 robustness 결과 반영):**
  - **Main analysis 유지:** `D_treat` (ITT 해석) — primary headline
  - **Robustness:** `D_eligible_obs_2018` subset 결과 (online appendix 표) — referee가 "but isn't actual SFFP eligibility different from area cutoff?"를 물을 때 즉답 가능
  - **§2 Institutional Context:** SFFP 8요건 명시 + 14.6% non-compliance율 + ITT 해석 정당화 (3 문단)
  - **§3 Identification:** "We estimate the intent-to-treat (ITT) effect of area-based SFFP eligibility..." 명시 (sharp ATT 표현 제거)
- [ ] CLAUDE.md identification 섹션 업데이트 (사용자 승인 후): "0.5ha cutoff = ITT assignment; SFFP receipt requires 8 eligibility criteria" 정정
- [ ] (선택) Fuzzy RD 1단계 + LATE: `actual_subsidy ∈ [1.1M, 1.3M]` 으로 SFFP 수령 proxy → LATE 추정 (Option C, 별도 plan)
