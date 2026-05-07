---
date: 2026-05-07
status: COMPLETED
sentinel: quality_reports/plans/playful-popping-badger.md
sister-post-approval: quality_reports/plans/2026-05-07_outlier-policy.md
spec-output: quality_reports/specs/2026-05-07_outlier-policy.md
predecessor: quality_reports/session_logs/2026-05-06_step-3-3-plan.md
---

# Plan: Outlier 정책 결정 (Option C, 워밍업 작업)

## Context

도현님은 STATA → R 포팅 (Step 4 P1, `scripts/R/01_clean.R` 작성) 진입 전에 outlier 정책을 lock-in 하려는 단계. 정책이 합의되지 않은 상태로 R 코딩에 진입하면 (a) 텀페이퍼 결과 replication tolerance (replication-protocol Phase 3, estimate <0.01 / SE <0.05) 통과 실패, (b) AJAE submission 시 referee가 "어떤 outlier 처리를 했나" 질문에 답할 근거 부재, (c) main spec과 robustness spec 분리가 모호해져 paper draft 단계에서 후행 재작업 발생. **본 plan은 코드를 작성하지 않고**, 5개 변수 (4 outcomes + imputed_payment) × 3 정책 tier (term-paper baseline / term-paper robustness / AJAE additions) 결정을 spec 문서로 lock 한다.

도현님 사전 답변 (Q&A 4문):
- Q1=(c) **텀페이퍼 baseline + AJAE robustness 둘 다**
- Q2=4 outcomes + imputed_payment, **area_2018 제외** (running variable)
- Q3=(c) **`quality_reports/specs/2026-05-07_outlier-policy.md`** 단일 파일
- Q4=(a) **R EDA 1회** (분포 근거 첨부)

## Goal

`quality_reports/specs/2026-05-07_outlier-policy.md` 작성 완료 — 5개 변수 × 3 tier 결정 + R EDA 분포 근거 + STATA verbatim 재현 targets + AJAE robustness 추가 정책. Phase 3 도현님 검토 후 spec APPROVED, commit + push.

---

## Lock Notes (Prep grep + targeted-read 결과)

**LN-1. 텀페이퍼 baseline = NO outlier handling.** `02_analysis.do:268-275` (rwolf2 + 4 outcomes 동시 reghdfe) 직접 확인: 4 outcomes (`y_farm_income`, `y_off_income`, `y_consump`, `y_farm_cost`) 모두 raw 값으로 `reghdfe` 진입. Sample restriction은 `if abs(rv_2018)<=h` (bandwidth) 단 하나. Winsorize / log / asinh / drop 등 outlier 처리 없음.

**LN-2. 텀페이퍼 robustness = `06_robustness_aux.do` (B) IHS + (C) Winsorize p1/p99.**
- (B) `gen double ihs_y = asinh(y)` (line 93), 4 outcomes × 3 bandwidth (500 / 1000 / 3300) = 12 cells, 별도 table `table_rob_ihs.tex`.
- (C) `winsor2 y, cuts(1 99) suffix(_w99)` (line 143), 동일 12 cells, 별도 table `table_rob_winsor99.tex`.
- 둘 다 main 결과 confirmation용 별도 robustness export — main spec과 변수 자체는 변경하지 않음.

**LN-3. `imputed_payment`은 outlier 변수 아님 — deterministic formula.** `01_cleaning.do:420-424`: `area_total<5000` → 1,200,000 KRW flat (SFFP); `5000≤area_total<20000` → `(area/10000)×2,050,000` (SFRP rice); `20000≤area_total<60000` → `×1,970,000`; `≥60000` → `×1,890,000`. `replace imputed_payment = 0 if year<=2019` (line 426). Formula의 area_total max값으로 bound — outlier 처리 대신 formula audit (Step 4 별도 항목).

**LN-4. `10_highvalue_checks.do` p1/p99 trim은 main spec 아닌 high-value subsample 보조.** `replace v = . if v<r(p1) | v>r(p99)` (lines 104, 149)는 commercial farm subsample에 한정된 보조 정리. AJAE robustness 후보로는 검토하되, main spec에는 들어가지 않음.

**LN-5. area_2018 (running variable) outlier 처리 금지 — DiD-RD identification 원칙.** Outlier 처리 시 cutoff 주변 density 왜곡 → McCrary 검정 의미 상실. 도현님 Q2 답변과 정합. McCrary density test는 별도 robustness (Step 4 P3).

**LN-6. STATA `replace v = . if cond`은 R `feols` NA 자동 제외와 mathematical-equivalent.** R 코딩 시 명시적 `drop`을 쓸지 NA 처리만 할지 결정 필요 — sample size 변경은 보고 의무 (replication-protocol Phase 3).

---

## Approach (5 Phases, ~60 분)

### Phase 1 — STATA baseline 재확인 (~5 min, READ-ONLY)

이미 본 plan 작성 중 verbatim 확인 완료. spec 문서에 그대로 인용 (코드 블록 + 라인 번호).

- `02_analysis.do:268-275` (baseline rwolf2 spec)
- `06_robustness_aux.do:90-121` (B IHS)
- `06_robustness_aux.do:136-184` (C Winsorize)
- `01_cleaning.do:420-426` (imputed_payment formula)

### Phase 2 — Quick R EDA (~15 min)

**Sandbox 디렉토리:** `explorations/2026-05-07_outlier-eda/`

**Files (생성 예정):**
- `eda.R` (~50 lines): haven::read_dta + dplyr summarise + ggplot2
- `_outputs/distribution_table.csv` (5 vars × 12 stats: min/p1/p5/p25/median/p75/p95/p99/max/mean/sd/n_missing/n_zero/n_negative)
- `_outputs/boxplot_5vars.png` (log-scale, year-by-year facet)
- `_outputs/hist_5vars.png` (raw + log dual-panel)
- `README.md` (per `templates/exploration-readme.md`, 60/100 sandbox 임을 명시)

**핵심 EDA 항목:**
1. 5변수 분포 quantile (p1/p99 내부 변동 vs 꼬리 비대칭 진단)
2. Missing pattern (year × variable cell)
3. 0/음수 비율 (asinh 적용 적절성 판단)
4. Cutoff 근처 (`abs(rv_2018) ≤ 1000`) subsample에서 분포가 전체와 다른지

**불변량 (R 코딩 결과 사후 sanity check):** N=14,474 / 3,614 farms / 2018-2022 (CLAUDE.md identification snapshot 기준).

### Phase 3 — AJAE robustness 추가 정책 결정 (~15 min, 도현님 검토 필요)

EDA 결과 + 문헌 관행 검토. 검토 후보 (도현님 결정):

| 후보 | 출처 / 정당성 | 텀페이퍼 중복? | AJAE 채택 권장? |
|---|---|---|---|
| A. Asinh (`asinh(y)`) | Bellemare & Wichman 2020 RES&S | ✅ (B) | ❌ (중복) |
| B. Log(y+1) | 0/음수 처리 | ❌ | △ (분포 따라) |
| C. Winsorize 1/99 | 표준 | ✅ (C) | ❌ (중복) |
| D. Drop top 1% (실제 drop) | sample 변경, RDD 권장 안 함 | ❌ | ❌ |
| E. Domain implausibility (e.g., `y_farm_cost > 10×y_farm_income`) | domain knowledge | ❌ | ✅ (권장) |
| F. Winsorize 0.5/99.5 (보수적) | AJAE referee 일반 | ❌ | ✅ (권장) |

**제 잠정 권장 (도현님 OQ-1 결정 대기):** E + F 채택, A/B/C/D 미채택. 이유 — A/C는 텀페이퍼 robustness로 cover, B는 EDA 0/음수 비율 따라 conditional, D는 RDD identification 손상.

### Phase 4 — Spec 문서 작성 (~20 min)

**File:** `quality_reports/specs/2026-05-07_outlier-policy.md` (기반: `templates/requirements-spec.md`)

**Sections:**
1. Objective (1 sentence)
2. Requirements (MUST/SHOULD/MAY)
   - MUST: term-paper baseline raw 4 outcomes 재현, IHS + winsor99 robustness 재현, imputed_payment formula 보존
   - SHOULD: AJAE additions (E + F if approved), EDA 분포 근거 첨부
   - MAY: B (log+1) conditional on EDA, area_2018 McCrary 재확인 (Step 4 위임 명시)
3. Clarity Status (5변수 × 3 tier matrix CLEAR/ASSUMED/BLOCKED)
4. Decision summary table (5 vars × 3 tiers, R 코드 한 줄씩)
5. Variable-by-variable rules
   - y_farm_cost (primary, lumpy investment): baseline raw / robust IHS+winsor99 / AJAE add
   - y_off_income (precautionary labor): 동일 패턴
   - y_consump (smoothing): 동일 패턴
   - y_farm_income (omnibus): 동일 패턴
   - imputed_payment (treatment intensity): outlier 처리 안 함, formula audit Step 4
6. STATA → R verbatim mapping (코드 블록 + 라인 번호)
7. EDA evidence (Phase 2 출력 reference, 분포 근거)
8. Cross-references (`r-code-conventions.md` §10, `replication-protocol.md` Phase 3, `domain-reviewer.md` Lens 2 D-NEW-5)
9. Success Criteria (replication tolerance + AJAE robustness 출력 명시)
10. Approval (Dohyeon date)

### Phase 5 — Commit + Push (~5 min)

**Files to commit:**
- `quality_reports/specs/2026-05-07_outlier-policy.md`
- `quality_reports/plans/playful-popping-badger.md` (DRAFT → COMPLETED)
- `quality_reports/plans/2026-05-07_outlier-policy.md` (sister copy, identical content)
- `quality_reports/session_logs/2026-05-07_outlier-policy.md`

**Files NOT committed (Dohyeon 결정 대기):**
- `explorations/2026-05-07_outlier-eda/` — sandbox, 60/100 threshold; commit 여부 도현님 옵션. 권장: commit (분포 근거가 spec과 한 묶음으로 빠지면 spec verifiability 손상)

**Commit message:**
```
docs(spec): outlier policy decision — term-paper baseline + AJAE robustness

5 vars × 3 tiers spec lock-in pre R porting (Step 4 P1):
- baseline: raw 4 outcomes (term-paper 02_analysis.do:268-275)
- robust: IHS + winsor p1/p99 (06_robustness_aux.do (B)+(C))
- AJAE: domain implausibility + winsor 0.5/99.5 (or per Dohyeon)

EDA evidence: explorations/2026-05-07_outlier-eda/_outputs/
imputed_payment: deterministic formula, no outlier handling.
area_2018 (running var): excluded per DiD-RD identification.
```

**Push:** `git push origin main` (현재 origin/main 동기 상태 + 새 commit 1-2개).

---

## Files Modified / Created / NOT Modified

**Created:**
- `quality_reports/specs/2026-05-07_outlier-policy.md` (~200 lines)
- `quality_reports/plans/playful-popping-badger.md` (this file, ~150 lines)
- `quality_reports/plans/2026-05-07_outlier-policy.md` (post-approval sister, identical to sentinel)
- `quality_reports/session_logs/2026-05-07_outlier-policy.md` (incremental + end-of-phase)
- `explorations/2026-05-07_outlier-eda/{eda.R, README.md, _outputs/{distribution_table.csv, boxplot_5vars.png, hist_5vars.png}}` (sandbox)

**NOT modified (out of current plan scope):**
- `r-code-conventions.md` — §12 Outlier Policy promotion은 spec 안정화 + 1-2 R 사용 사이클 후 별도 commit
- `CLAUDE.md` — outlier 언급 없음, 추가 안 함
- `scripts/R/01_clean.R` — Step 4 P1에서 spec 따라 implement (out of scope)
- `MEMORY.md` — Phase 5 후 [LEARN] 후보 도현님 검토 (별도 commit 또는 동일 commit)

---

## Out of Scope (Step 4 P1 이후 위임)

- `scripts/R/01_clean.R` 실제 코드 작성 — spec 따라 추후 구현
- `scripts/R/05_robust.R` IHS + winsor99 + AJAE additions 구현 — spec 따라 추후 구현
- McCrary density test (running variable manipulation 검정) — Step 4 P3
- High-value (commercial) farm subsample 분석 — dissertation extension
- imputed_payment formula audit (rate-tier 정확성 cross-check vs 정부 고시) — Step 4 별도 항목
- `r-code-conventions.md` §12 신설 — spec 안정화 후 별도 PR

---

## Open Questions

**OQ-1 (Phase 3 도현님 결정):** AJAE additions에서 Candidate E (domain implausibility) + F (winsor 0.5/99.5) 둘 다 채택? E만? F만? 다른 조합?

**OQ-2 (spec 작성 중 결정):** R 코드에서 outlier 제외 시 `dplyr::filter()` (drop, sample size 변경) vs `dplyr::mutate(y = if_else(cond, NA_real_, y))` (NA, feols 자동 제외) 중 어느 쪽? 텀페이퍼 STATA `replace v = .` 패턴은 후자와 동등.

**OQ-3 (cross-reference):** spec에 `imputed_payment` formula audit task를 cross-reference 추가하되, 본 spec의 결정 사항은 아님 (Step 4 위임). 명시적 표기 필요.

**OQ-4 (Phase 2 EDA 결과 의존):** EDA에서 0/음수 비율이 5% 이상이면 Candidate B (log+1) MAY → SHOULD로 격상 권장.

---

## Memory Candidates (Phase 5 후 [LEARN] 추가 검토)

1. **[LEARN:methods]** 텀페이퍼 baseline = raw 4 outcomes (no outlier handling). Robustness = IHS + winsor p1/p99 별도 table. AJAE submission도 동일 구조 — main spec 변수 자체를 변경하지 않고 robustness export로 대응. **Why:** referee "어떤 outlier 처리?" 질문에 main = "없음", robustness = "IHS + winsor 두 별도 table"로 명료한 답. **Apply:** 모든 PIDPS DiD-RD 추정 paper / thesis chapter / KAEA 발표.

2. **[LEARN:methods]** DiD-RD running variable (rv_2018 / area_2018) outlier 처리 금지. McCrary density 왜곡 → identification 흐려짐. McCrary test는 별도 robustness (Step 4 P3). **Apply:** 모든 RDD 기반 paper.

3. **[LEARN:audit]** STATA `replace v = . if cond`은 R `feols` NA 자동 제외와 mathematical-equivalent. 명시적 `dplyr::filter()` drop은 sample size 변경 → 보고 의무 (replication-protocol Phase 3). **Apply:** 모든 STATA → R 포팅 작업.

---

## Resume Prompt (post-approval)

Plan APPROVED. 진행 순서:
1. Phase 1 STATA baseline 재확인 — 이미 prep에서 verbatim 확인 완료, spec 작성 시 인용.
2. Phase 2 R EDA 작성 — `explorations/2026-05-07_outlier-eda/` 디렉토리 생성, `eda.R` 작성, `Rscript` 실행, 출력 검증.
3. Phase 3 도현님 OQ-1 검토 (AJAE additions 선택) → spec에 lock.
4. Phase 4 spec 문서 작성.
5. Phase 5 sister + session log + commit + push.

각 Phase 완료 시 도현님께 짧은 status 보고 후 다음 진입.
