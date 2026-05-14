# Plan — Step 4 P3b: CH4 Kirwan + own_share heterogeneity + (S,s) two-margin test

## Session 3 Implementation Block (2026-05-18): Option 2 = A + B (~1.5h)

**Scope today:** Phase 4 submission strategy lock (A) + P3b-6 Wild bootstrap (B). Both anchor downstream work: A determines paper §1 narrative shape; B closes a known inference gap that any submission path will require.

Predecessor session: P3b-2 (`d6dadc9`, 2026-05-17) — three-channel tenant-driven land transition narrative locked.

### Work order

| Phase | Task | Time | Output |
|---|---|---|---|
| **A1** | Read `paper/narrative_draft_p3b.md` + CLAUDE.md current state | 5min | context refresh |
| **A2** | Present 3-path scenario table (AJAE / JAE / Food Policy) with per-path trade-offs | 10min | AskUserQuestion |
| **A3** | Lock submission strategy + update CLAUDE.md "Goal" section if needed | 15min | docs edit |
| **B1** | Try `install.packages("fwildclusterboot")` (CRAN binary may be available now) | 5min | Path A/B decision |
| **B2** | Implement Wild bootstrap on 14 headline cells (8 P2 replication + 6 P3b-1 CH4 main) | ~50min | wild_results in main_results.rds |
| **B3** | Update `replication_check.txt` + new `tab_wild_bootstrap_{en,ko}.tex` | ~15min | tex output |
| **F** | Commit + push | ~15min | feature commit |

### Phase 4 — submission strategy lock (A)

Present 3-path table to user, then update CLAUDE.md if framing change is substantive:

| Path | Strategy | Tradeoffs | Estimated P(accept) |
|---|---|---|---|
| **AJAE direct** | Three-channel tenant-driven land transition as the headline; per-farm vs per-hectare reframe of EU/US consensus | High ceiling; tough referee pool; possible R&R cycle 1-2 years | 45-55% |
| **JAE safe** | Two-margin (S,s) + CH4 incidence as headline; heterogeneity supporting | More forgiving referees; faster decision; narrative slightly less ambitious | 80-90% |
| **Food Policy** | Policy-evaluation framing (smallholder consolidation policy); take-up 92.3% + per-farm design lessons | Policy audience; less methods-heavy critique; venue prestige below AJAE/JAE | 65-75% |

**Decision-locking implications:**
- AJAE: paper §1 leads with Kirwan/Ciaian inversion + three-channel evidence; §6 mechanism-heavy
- JAE: paper §1 leads with two-margin theoretical test; (S,s) + incidence joint framing
- Food Policy: paper §1 leads with PIDPS-SFFP policy design + take-up; light methods

**Recommendation rationale:** Three-channel finding is strong enough to attempt AJAE (top tier) directly; even if R&R/reject, JAE remains as fallback with minimal reframing cost. Food Policy is appropriate post-rejection if AJAE/JAE both decline.

### P3b-6 Wild bootstrap (B) — 14 headline cells

Path-A-first, Path-B-fallback strategy per existing plan §"File 4: 04_robust.R EXTEND":

**Path A — `fwildclusterboot` install attempt:**
```r
install.packages("fwildclusterboot", repos = "https://cloud.r-project.org")
# Check if binary is now available for R 4.5.3 macos-arm64 — if not, source install
# requires gfortran on `/opt/gfortran/` per [LEARN:env] 2026-05-06.
```

If install succeeds:
```r
library(fwildclusterboot)
# Per cell:
bt <- boottest(fit, param = "D_Post", clustid = ~hh_id, B = 9999,
                seed = PROJECT_SEED, type = "rademacher")
p_wild <- bt$p_val
```

**Path B fallback — manual cluster-Rademacher refit:**
```r
wild_cluster_p <- function(fit, df, cluster_var = "hh_id", B = 999,
                            target_coef = "D_Post") {
  resid    <- residuals(fit)
  y_hat    <- fitted(fit)
  clusters <- unique(df[[cluster_var]])
  cluster_idx <- match(df[[cluster_var]], clusters)
  t_obs    <- coef(fit)[target_coef] / sqrt(diag(vcov(fit)))[target_coef]
  t_boot   <- numeric(B)
  for (b in seq_len(B)) {
    v <- sample(c(-1, 1), length(clusters), replace = TRUE)
    y_b <- y_hat + v[cluster_idx] * resid
    fit_b <- update(fit, y_b ~ ., data = df)  # may need explicit data + formula
    t_boot[b] <- coef(fit_b)[target_coef] / sqrt(diag(vcov(fit_b)))[target_coef]
  }
  mean(abs(t_boot) >= abs(t_obs))
}
```

Expected timing: 999 × ~0.05s/refit × 14 cells ≈ 12 min wall-clock (acceptable). B=999 sufficient for stochastic tolerance per `quality-gates.md` §Tolerance Thresholds.

**14 target cells:**

| Source | Cells | Spec | Outcome | Notes |
|---|---|---|---|---|
| P2 main_results.rds$wild_replication | 8 | A × {op_cost, off_farm_income, consumption, farm_income} + B × same | per-outcome STATA bandwidth | matches STATA 11_multiple_testing.log anchors |
| P3b-1 channels_results.rds$ch4_results | 6 | A × {T1, T2, T3} × {rent_cost, op_cost_ex_rent} | fixed bw 500/1000/3300 | CH4 headline (used in submission narrative) |

For 8 replication cells: compare to STATA 11_multiple_testing.log Wild p-values (±0.01 stochastic tolerance per `quality-gates.md`). 8/8 PASS expected.

For 6 CH4 cells: R-only, no STATA anchor. Report Wild p-values alongside cluster-robust p-values for paper §3 robustness.

### Files to modify

| Path | Action | ~lines |
|---|---|---|
| `scripts/R/04_robust.R` | EDIT — wrap Phase 3 Wild bootstrap behind `USE_FWB` (Path A) OR add manual Rademacher block (Path B) | +30-80 lines |
| `scripts/R/06_channels.R` | EDIT — add 6 CH4 cell Wild bootstrap (post-fit, after Phase 1 results) | +20-40 lines |
| `scripts/R/_outputs/main_results.rds` | UPDATE — `wild_replication$p_wild` populated (currently NA from P3b-1) | runtime |
| `scripts/R/_outputs/channels_results.rds` | UPDATE — add `ch4_wild_p` column | runtime |
| `scripts/R/_outputs/tab_wild_bootstrap_{en,ko}.tex` | CREATE — 14-cell Wild bootstrap p-value table | runtime |
| `scripts/R/_outputs/replication_check.txt` | UPDATE — add Wild bootstrap comparison rows | runtime |
| `scripts/R/_setup_packages.R` | EDIT (optional) — add `fwildclusterboot` to `optional` vec if Path A succeeds; document attempt | 1-3 lines |
| `CLAUDE.md` | EDIT (conditional) — update "Goal" or "Quality Thresholds" if Phase 4 locks a specific submission path | 1-5 lines |
| `quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md` | EDIT — add Session 3 block (sync sister) | identical content |
| `quality_reports/session_logs/2026-05-18_p3b-6.md` | CREATE — incremental session log | grows during impl |

### Verification

```bash
Rscript scripts/R/00_run_all.R 2>&1 | tail -20
# Expect: pipeline 7 scripts; Wild bootstrap adds ~12 min if Path B, ~30s if Path A.
# Total: ~13s (P3 baseline) + 12 min Wild = ~12-13 min OR ~45s with Path A.

cat scripts/R/_outputs/replication_check.txt | tail -30
# Expect: Wild bootstrap section populated. 8/8 P2 replication cells match
# STATA 11_multiple_testing.log within ±0.01 p-value tolerance.

Rscript -e '
mr <- readRDS("scripts/R/_outputs/main_results.rds")
print(mr$wild_replication |> dplyr::select(spec, outcome, est, se_wild, p_wild))
'
# Verify p_wild populated, sign-aligned with p_cluster from P2.
```

### Risks (Session 3 specific)

| Risk | Mitigation |
|---|---|
| Path A install still fails on R 4.5.3 | Path B manual Rademacher is documented and tested-feasible. Set B=999 ceiling. |
| Wild bootstrap p_wild ≠ STATA p_wild within tolerance | Investigate: STATA boottest uses Rademacher, R fwildclusterboot Mammen-default? Force `type="rademacher"` to match. |
| 12 min wall-clock for Path B exceeds session budget | Cells are independent — could parallelize via `future::plan(multisession)` or restrict to 14 → 6 cells if time-pressed. |
| Submission lock decision changes mid-paper (R&R cycle) | CLAUDE.md update should be soft (Goal section "Primary submission target: X (alternative: Y)") to allow pivots. |

---

## Session 2 Implementation Block (2026-05-17): Option 2 = A + D (~5-6h)

**Scope today:** P3b-2 expanded (A) + P3b-3 reframed stabilization (D). P3b-1.5 paper-grade table (B), P3b-4/5/6, and paper/en/main.tex (E) deferred to subsequent sessions per user resume-prompt.

### Work order (Phase A through F)

| Phase | Task | Time | Output |
|---|---|---|---|
| **A** | Update `domain-reviewer.md` B-6 CH3 violation criterion (축소→stabilization) | 15min | docs edit |
| **B** | **`scripts/R/07_heterogeneity.R` Phase 1** — own_share × 4 outcomes implementation | ~2h | 120 interaction cells |
| **C** | **Scenario classification (α / β / γ) + pause for decision** | 30min | classification report |
| **D** | **P3b-3 reframed** — extensive margin event-study formalized in `06_channels.R` extension OR new section | ~1h | stabilization table |
| **E** | Integrated narrative draft (paper §6 초안) | ~1h | narrative.md sketch |
| **F** | Commit + push + checkpoint | ~30min | feature commit |

### Implementation spec — `scripts/R/07_heterogeneity.R` Phase 1

**own_bin construction (5 levels):**
```r
df$own_bin <- dplyr::case_when(
  own_share == 0   ~ "1_pure_tenant",
  own_share < 0.3  ~ "2_low_owner",
  own_share < 0.7  ~ "3_mixed",
  own_share < 1    ~ "4_high_owner",
  own_share == 1   ~ "5_pure_owner"  # reference
)
```

**Baseline counts (treated, 2018):** pure_tenant 120, low_owner 84, mixed 121, high_owner 159, pure_owner 526. Verified via pre-check 2026-05-15 + today's resume-verification.

**Panel availability:** `own_share` present in all years (2018: 2,823 → 2022: 2,947 non-NA) — supports time-varying interaction, not just baseline-fixed.

**Interaction spec via fixest::i():**
```r
# 4 outcomes × 3 bw × 2 specs = 24 interaction regressions; each produces 5 bin coefficients
feols(rent_cost        ~ i(own_bin, D_Post, ref="5_pure_owner") + rv_Post + Drv_Post | hh_id + year, ...)
feols(unit_rent_price  ~ ... , data = df_renters)   # renters subset only (area_rent > 0)
feols(area_own         ~ ...)
feols(area_rent        ~ ...)
```

**Sample handling notes:**
- `unit_rent_price = rent_cost / area_rent` — defined only where `area_rent > 0` (renters subset, ~half of treated). Report N per cell to make sample restriction transparent.
- `rent_cost` regression uses full sample (pure_owner contributes 0 by construction; coefficient identifies any noise/measurement issue).
- Spec B (drop 2020, Post=year≥2021) mirror spec applied to all 4 outcomes.

**Total: 4 outcomes × 5 bins × 3 bw × 2 specs = 120 interaction cells.**

### Key hypothesis tests (paper §6 evidence)

| Hyp | Statement | Outcome | Predicted gradient |
|---|---|---|---|
| **H1 (bargaining)** | Tenant unit-rent decline driven by tenants | `unit_rent_price` | pure_tenant β << mixed << pure_owner ≈ 0 |
| **H2 (composition)** | Rented area reduction concentrated in tenants | `area_rent` | pure_tenant β << pure_owner ≈ 0 (sharp negative) |
| **H3 (extensive margin)** | Own-cultivation expansion concentrated in owners | `area_own` | pure_owner β > 0 dominant |
| **H4 ((S,s) heterogeneity)** | Inaction-region behavior strongest among tenants | `op_cost_ex_rent` | pure_tenant β << pure_owner |

H1 is the **AJAE-decisive test**: confirming monotone gradient locks the bargaining mechanism narrative.

### Scenario classification (Phase C decision gate)

| Scenario | Pattern | Implication |
|---|---|---|
| **α (bargaining confirmed)** | H1 ✓ (pure_tenant >> mixed >> pure_owner ≈ 0) | Bargaining mechanism decisive → AJAE-grade evidence locked |
| **β (mixed pattern)** | H1 cells similar across bins | Market dynamics > tenant-specific; reframe §6 |
| **γ (own_cultivation dominant)** | H3 strongly positive only in pure_owner | "Land accumulation" narrative strengthened; H1 secondary |

Pause at end of Phase C, present scenario + per-cell detail to user, decide Phase D scope before proceeding.

### P3b-3 reframed (Phase D)

**Replace "축소 가설" with "Stabilization / Extensive Margin Retention" framing.**

Concrete actions:
1. **Extension to `06_channels.R`** OR new section in `07_heterogeneity.R`: formalize area_total event-study output as a paper-grade table (event-study coefficient + SE + p-value across 3 bandwidths × 4 years × {area_total, area_own, area_rent} = 36 cells).
2. **Static vs dynamic note**: explicitly document that panel DiD-RD β ≈ 0 hides the dynamic pattern; event-study is the correct framing for paper §5.
3. **Own/rent decomposition table**: 2022 +408 m² = own +237 (58%) + rent +171 (42%). Promote from mechanism check.R to paper-grade output.
4. **`domain-reviewer.md` B-6 CH3 violation criterion update**: replace "exit deterrence" prediction with "stabilization + extensive margin" framing; cross-ref to Kazukauskas et al. (2013 AJAE) for retention literature.

### Out of scope (next session candidates)

- P3b-1.5 paper-grade table (B option in resume prompt)
- P3b-4 (5×4 demographic heterogeneity)
- P3b-5 (First-stage IV / LATE)
- P3b-6 (Wild bootstrap on headline cells)
- E option (paper/en/main.tex intro+conclusion)

### Risks specific to today's session

| Risk | Mitigation |
|---|---|
| pure_tenant N=120 → narrow-bw SE inflation may obscure H1 gradient | Report Wide-bandwidth (T2/T3) cells to compensate. Spec B mirror as second look. |
| `unit_rent_price` undefined for non-renters | Document NA-exclusion sample restriction (N reduction ~50%). Report per-cell N transparently. |
| own_bin reference category choice (pure_owner = "no rent activity" base) | Use pure_owner as ref so coefficients = "extra effect on tenants/mixed vs pure owners" — natural interpretation. |
| H1 ✗ (β similar across bins) → scenario β → §6 reframe | Phase C pause point: present scenario before Phase D — user decides whether to pivot narrative or continue stabilization framing. |
| `area_own` time-varying (panel) vs baseline-only — careful with `own_bin` time invariance | Define `own_bin` from year=2018 baseline only (per-hh fixed), to avoid endogenous bin transitions. |

### Verification (today's session)

```bash
# After Phase B implementation:
Rscript scripts/R/00_run_all.R 2>&1 | tail -20
# Expect: pipeline 7 scripts now, 07_heterogeneity.R ~10s
ls scripts/R/_outputs/ | grep "het"  # heterogeneity_results.rds, tab_het_*.tex

# After Phase C: scenario classification
Rscript -e '
het <- readRDS("scripts/R/_outputs/heterogeneity_results.rds")
print(het$h1_gradient_check)   # H1 test: pure_tenant β / pure_owner β ratio
'
```

---

## Context

P3a (`4a03505`, 15/16 PASS) completed Tier 1 — McCrary density (exact match), outlier ladder, 66 figures. Pre-check (`explorations/2026-05-15_p3b-precheck/check.R`, 2026-05-15) confirmed:

- **CH4 viable**: 47.9% tenancy in treated group (484/1,010 farms), 56.5% near-cutoff. First-stage variation abundant.
- **CH3 cautious overall (Δ=−3.49pp) but viable in RD-bound (near-cutoff Δ=+0.7pp)** — identification clean for RD spec.
- **own_share bimodal** (52% pure owner + 12% pure tenant + 36% mixed) → strong 5-bin heterogeneity dimension.
- **rent_cost mean 4.3M KRW** among renters → measurable magnitude for capitalization test.

This unlocks a **JAE/AJAE-grade framing** — the original (S,s) single-anchor framing transitions to a **two-margin theoretical test**:

1. **Incidence margin (CH4):** does per-farm flat-rate (Korea SFFP) break the rent capitalization channel that EU per-hectare flat-rate amplifies (Ciaian et al. 2023 *Land Use Policy* 134: 46–55%) and that US per-hectare proportional captures (Kirwan 2009 *JPE* 117(1): ~25%)?
2. **Behavioral margin ((S,s) inaction):** does T/s_min ≈ 2.4% place the lump-sum deeply within the lumpy-investment inaction region, predicting β(op_cost_ex_rent) ≤ 0?

If both hold: Korea is the first OECD case to demonstrate per-farm flat-rate as a design that simultaneously (a) avoids landlord pass-through and (b) sits in the (S,s) inaction region for tenant farmers — distinct from both US and EU defaults. **Publishable AJAE/JAE contribution regardless of statistical significance level**, because the framing reverses the 2018+ EU literature's "flat-rate amplifies capitalization" prior.

## Scope (revised post P3b-1, ~12 hours remaining)

| Item | Description | Time | Status |
|---|---|---|---|
| **P3b-1** ✅ | CH4 Kirwan/Ciaian decomposition + mechanism deepening (bargaining vs composition) | 2h | **DONE** (2026-05-16) |
| **P3b-1.5** ⭐ NEW | Area decomposition table (own/rent/total event-study) + bargaining table (unit_rent_price) | 1h | NEW priority |
| **P3b-2 ★ EXPANDED** | own_share × D_Post × **{rent_cost, unit_rent_price, area_own, area_rent}** 5-bin × 4 outcome | 3h | **PRIORITY 1** — confirms bargaining is the mechanism |
| **P3b-3 REFRAMED** | Extensive margin dynamics (area_total event-study + own/rent decomposition + exit DiD attempt) | 2h | PRIORITY 2 |
| **P3b-4** | 5×4 demographic heterogeneity | 3h | PRIORITY 3 |
| **P3b-5** | First-stage IV (LATE) | 2h | PRIORITY 4 (less critical after mechanism finding) |
| **P3b-6** | Wild bootstrap on headline cells | 1h | PRIORITY 5 |

**Out of scope (P3c or deferred):** `debt_total`, `farm_type` 작목 전환, Korean PDF via `showtext`, IHS/w99 robustness ladder extensions (P3a완료).

### P3b-1.5 NEW work item (added 2026-05-16 post-mechanism deepening)

The mechanism check (`explorations/2026-05-16_p3b-mechanism/check.R`) produced findings worth promoting to paper-table format:

**Table 1: CH4 rent decomposition (bargaining vs composition)**
- 3 bw × {rent_cost, area_rent, unit_rent_price} = 9 cells
- Documents the bargaining channel (T1 −67 KRW/m², p=0.05) as the policy mechanism

**Table 2: area_total event-study (own vs rent decomposition)**
- 3 bw × 4 years × {area_total, area_own, area_rent} = 36 cells
- Documents the dynamic +408 m² (2022) and own-cultivation dominance (58%)

Adds ~80 lines to `06_channels.R` Phase 3 + 1 new figure (own/rent area decomp).

### P3b-2 expansion (substantially upgraded)

Original P3b-2 was own_share × D_Post × rent_cost (5 bins × 1 outcome = 5 interaction cells per bw).
**Revised P3b-2 (priority 1 next session):** own_share × D_Post × **{rent_cost, unit_rent_price, area_own, area_rent}** = **4 outcomes** × 5 bins × 3 bw × 2 specs = **120 interaction cells**.

Predicted patterns (testable):
- **pure_tenant**: largest unit_rent_price effect (bargaining hypothesis); largest area_rent reduction
- **mixed**: linear-in-share gradient
- **pure_owner**: rent_cost / unit_rent_price ≡ 0 (reference); area_own should show expansion effect concentrated here
- If pure_tenant β(unit_rent_price) >> mixed >> pure_owner ≡ 0: **bargaining mechanism CONFIRMED at subgroup level → AJAE-grade evidence**

## Lock notes (pre-check + P3b-1 mechanism deepening confirmed)

- **LN-1:** Treated tenancy = 47.9% (484/1,010); near-cutoff (|rv_2018|≤1000) treated = 56.5%. CH4 first-stage variation abundant.
- **LN-2:** own_share bimodal: pure owner 52.1% (526) + pure tenant 11.9% (120) + mixed 36.0% (364) — 5-bin partition viable.
- **LN-3:** rent_cost mean = 433K KRW per treated renter (median 0, max 60M — right-skewed). Use raw + asinh log transforms in robustness.
- **LN-4:** Near-cutoff attrition: treated 81.5% vs control 80.8% (Δ=+0.7pp < 2pp threshold) — RD spec clean for CH3.
- **LN-5:** Ciaian, Espinosa, Gomez y Paloma & Heckelei (2023) *Land Use Policy* 134 — EU per-hectare flat-rate: 46% short-run, 55% long-run capitalization. **Inverts the original "flat-rate avoids capitalization" prior.** Korean per-farm flat-rate is the third design unique to this paper.
- **LN-6:** Kirwan (2009) *JPE* 117(1) (note: JPE not AER per lit-review correction) — US per-hectare proportional: ~25% capitalization. Baseline comparison.
- **LN-7:** B-6 (S,s) prediction: T/s_min ≈ 2.4% → inaction region → β(op_cost_ex_rent) ≤ 0. P2/P3a outlier ladder confirms negative sign for `op_cost` (raw); P3b isolates rent-net component.
- **LN-8 (P3b-1 NEW, 2026-05-16):** **Korea exhibits NEGATIVE rent pass-through** (−11.1% at T2, −12.9% at T1), reversing the EU/US capitalization sign. This is even stronger than the original "≈ 0" prediction. Three candidate mechanisms tested in `explorations/2026-05-16_p3b-mechanism/check.R`:
  - **(a) Bargaining — CONFIRMED at T1**: unit_rent_price (rent_cost / area_rent among renters) β = −67 KRW/m² at h=500 (**p = 0.0498, exactly 5% significant**). Tenant bargaining power increases post-policy.
  - **(b) Composition — partial only**: area_rent β = −851 (T1), −548 (T2), −39 (T3), all p > 0.2 (sign-consistent negative but non-significant). Modest mechanical contribution.
  - **(c) Market dynamics — absorbed by year FE.**
- **LN-9 (P3b-1 NEW, 2026-05-16):** **Event-study reveals dynamic area expansion (NOT exit deterrence).** area_total at T3 h=3300:
  - 2018 pre: +67 m² (p=0.59) **— parallel trends OK**
  - 2020 (year 1 post): +128 (p=0.20)
  - 2021 (year 2): +343 m² (**p = 0.005***)
  - 2022 (year 3): +408 m² (**p = 0.003***)
  - Decomposition: 2022 +408 = own +237 (p=0.012**, **58% share**) + rent +171 (p=0.144, 42%). **Own-cultivation expansion dominates.** "축소 가설" rejected — treated farms RETAIN and EXPAND cultivated area, primarily via own-cultivation. Static (panel-averaged) area_total β ≈ 0 hides this dynamic via pre/post averaging — **event-study is the correct framing for paper.**
- **LN-10 (P3b-1 NEW, 2026-05-16):** Parallel-trends gate clean for all 4 outcomes (area_total, area_own, area_rent, rent_cost): all 2018 pre-period |t| < 1. RD identification strong; Roth-Rambachan sensitivity unlikely to flag.

## Scenario matrix (P3b-1 deliverable shape)

| `rent_cost` β | `op_cost_ex_rent` β | Interpretation | Best venue |
|---|---|---|---|
| **< 0** | < 0 | **⭐⭐ BEST+ — Korea NEGATIVE pass-through (better than ≈ 0) + (S,s) inaction confirmed** | **AJAE / JAE** |
| ≈ 0 | < 0 | Best case — Korea breaks EU/US capitalization + (S,s) inaction | **AJAE / JAE** |
| > 0 | < 0 | Partial capitalize + residual (S,s) inaction | JAE / Food Policy |
| ≈ 0 | ≈ 0 | Underpowered null on both | KR journal + thesis |
| > 0 | ≈ 0 | Full capitalize (reproduces Ciaian EU pattern) — Korea ≡ EU | ERAE (external validity) |

**P3b-1 RESULT (2026-05-16): SCENARIO 1+ BEST+** — joint test across T1/T2/T3, Spec A:

- `rent_cost` β sign-consistently **NEGATIVE** across all 3 bandwidths: T1 −155K (p=0.091*), T2 −133K (p=0.138), T3 −41K (p=0.423)
- Korea pass-through: **−11.1%** (T2 headline) vs Kirwan US +25% vs Ciaian EU +46-55%
- `op_cost_ex_rent` β sign-consistently **NEGATIVE** at narrow bw: T1 −4.02M (p=0.055*), T2 −3.22M (p=0.079*), T3 +0.30M (p=0.839)

→ **Two-margin joint pattern confirmed in narrow bandwidths.** T3 attenuation is typical RD wide-window averaging; narrow bw captures local policy effect. Headline submission target: AJAE/JAE (Phase 4 Task #13 reading).

## Approach — file structure

P3b adds **3 new scripts** + **2 file extensions**, extending the pipeline from 5 → 8 scripts:

```
scripts/R/
├── 01_clean.R          (P1, existing)
├── 02_descriptive.R    (P2, existing)
├── 03_did_rd.R         (P2, existing)
├── 04_robust.R         (P3a, existing — extend for Wild bootstrap retry)
├── 05_figures.R        (P3a, existing — extend for channel/heterogeneity figures)
├── 06_channels.R       (P3b NEW — CH4 + CH3)
├── 07_heterogeneity.R  (P3b NEW — own_share × CH4 + 5×4 demographic)
└── 08_iv.R             (P3b NEW — first-stage IV / LATE)
```

`00_run_all.R` pipeline vector extends to 8 scripts.

### File 1: `scripts/R/06_channels.R` — NEW (~280 lines)

**Phase 0:** library + seed + guard.

**Phase 1 — CH4 Kirwan/Ciaian rent decomposition (P3b-1):**
- Reuse `03_did_rd.R` spec tibble (32 fits for journal-grade T1/T2/T3 × A/B); swap LHS:
  ```r
  feols(rent_cost ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = sub, cluster = ~hh_id)
  feols(op_cost_ex_rent ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = sub, cluster = ~hh_id)
  ```
- Pass-through rate: `β(rent_cost) / 1.2M_KRW` — direct comparison to Ciaian (46–55%) and Kirwan (~25%).
- 24 cells (2 outcomes × 3 bw × 2 specs × 2 outcomes); 32 with Spec A MSE-replication reference.
- Scenario matrix population: classify each (spec, bw) cell into 1 of 4 cases above.

**Phase 2 — CH3 retention (P3b-3):**
- Exit indicator constructed cross-sectional (per-farm):
  ```r
  exit_data <- df |> dplyr::group_by(hh_id) |>
    dplyr::summarise(exit = as.integer(dplyr::n_distinct(year) < 5L),
                     rv_2018 = dplyr::first(rv_2018),
                     D_treat = dplyr::first(D_treat))
  # RD on cross-section
  rdrobust::rdrobust(y = exit_data$exit, x = exit_data$rv_2018, c = 0, p = 1,
                     bwselect = "mserd", masspoints = "off")
  ```
- Area dynamics (event-study) for the panel:
  ```r
  feols(area_total ~ i(year, D_treat, ref = 2019) | hh_id + year, data = sub, cluster = ~hh_id)
  ```
- Three bandwidth subsets: T1/T2/T3.

**Phase 3 — Save:** `channels_results.rds`, `tab_ch4_rent_decomposition_{en,ko}.tex`, `tab_ch3_retention_{en,ko}.tex`, append to `replication_check.txt` (no STATA anchor for these — R-only, document as R-only cells).

### File 2: `scripts/R/07_heterogeneity.R` — NEW (~320 lines)

**Phase 0:** library + seed + guard.

**Phase 1 — own_share × CH4 (P3b-2):**
- Construct 5 bins per `LN-2`:
  ```r
  df$own_bin <- dplyr::case_when(
    own_share == 0   ~ "pure_tenant",
    own_share < 0.3  ~ "low_owner",
    own_share < 0.7  ~ "mixed",
    own_share < 1    ~ "high_owner",
    own_share == 1   ~ "pure_owner"
  )
  ```
- Interaction spec via fixest:
  ```r
  feols(rent_cost ~ i(own_bin, D_Post, ref = "pure_owner") + rv_Post + Drv_Post
        | hh_id + year, data = sub, cluster = ~hh_id)
  ```
- Predicted patterns:
  - **pure_owner**: rent_cost ≡ 0 (no rent to begin with); coefficient identifies if any phantom variation
  - **pure_tenant**: full capitalization exposure — largest |β(rent_cost)| if landlord pass-through
  - **mixed**: linear-in-share interpolation, monotone gradient expected
- 3 bandwidths × 2 outcomes × 5 bins = 30 interaction cells per outcome.

**Phase 2 — 5×4 demographic heterogeneity (P3b-4):**
- Dimensions: `type_fulltime` (3 levels), `age_code_base` (binarized 65+ cutoff), `sex_code` (2 levels), `edu_code` (4-group binning needed), `own_share` (5 bins — reuse from Phase 1).
- 4 P2 outcomes (op_cost, off_farm_income, consumption, farm_income).
- Spec: Spec A T3 (MSE-optimal) per cell to limit cell count.
- Total: 5 dim × 4 outcome = 20 interaction tables; emphasize:
  - `type_fulltime × op_cost` (전업농 (S,s) 강함)
  - `age_code_base × area_total` (고령농 축소)
  - `own_share × rent_cost` (covered in Phase 1; cross-reference)

**Phase 3 — Save:** `heterogeneity_results.rds`, `tab_het_own_share_ch4.tex`, `tab_het_demographic_{en,ko}.tex` (compact per-dimension format), heterogeneity coefficient plots (deferred to 05_figures.R extension).

### File 3: `scripts/R/08_iv.R` — NEW (~180 lines)

**Phase 0:** library + seed + guard.

**Phase 1 — First-stage IV / LATE (P3b-5):**
- 2SLS via fixest:
  ```r
  iv_fit <- fixest::feols(
    y_outcome ~ rv_Post + Drv_Post | hh_id + year | actual_subsidy ~ D_Post,
    data = sub, cluster = ~hh_id
  )
  # Extract: first-stage F-stat, IV (LATE) estimate, compare to ITT/take-up
  ```
- 4 outcomes × 3 bandwidths × 2 specs = 24 IV fits.
- Take-up rate confirmed = 92.3% (from P2 02_descriptive.R desc_summary.rds).
- LATE = ITT / 0.923 (mechanical scaling); first-stage F-stat for instrument strength.

**Phase 2 — Save:** `iv_results.rds`, `tab_iv_late_{en,ko}.tex` (4 outcomes × T3 spec, comparison: ITT vs LATE side-by-side).

### File 4: `scripts/R/04_robust.R` — EXTEND for Wild bootstrap (P3b-6)

Currently Wild bootstrap is gated by `if (USE_FWB)` and SKIPPED. Two attempts:

**Path A — fwildclusterboot via R-tools gfortran:**
- User-side prerequisite: install official `gfortran-12.2-universal.pkg` from mac.r-project.org/tools/ (one-time, ~10 min). After install, `install.packages("fwildclusterboot", repos = "https://cloud.r-project.org", type = "source")` should compile.
- If successful: Wild bootstrap p-values on 8 replication cells (matching STATA `11_multiple_testing.log` ±0.01) + 24 journal-grade cells.

**Path B — manual cluster-Rademacher refit (fallback):**
```r
wild_cluster_p <- function(fit, df, cluster_var, B = 999) {
  resid <- residuals(fit)
  clusters <- unique(df[[cluster_var]])
  t_boot <- numeric(B)
  for (b in seq_len(B)) {
    v <- sample(c(-1, 1), length(clusters), replace = TRUE)
    weights_vec <- v[match(df[[cluster_var]], clusters)]
    y_b <- predict(fit) + weights_vec * resid
    fit_b <- fixest::feols(update(formula(fit), y_b ~ .), data = df, cluster = ~hh_id)
    t_boot[b] <- coef(fit_b)["D_Post"] / sqrt(diag(vcov(fit_b)))["D_Post"]
  }
  t_obs <- coef(fit)["D_Post"] / sqrt(diag(vcov(fit)))["D_Post"]
  mean(abs(t_boot) >= abs(t_obs))
}
```
- B=999 × 8 cells × ~0.05s/refit ≈ 7 minutes. Feasible.
- Apply only to **headline cells** (8 replication + ~6 from P3b-1 CH4 main results) — NOT to 60+ heterogeneity cells (cluster-robust SE sufficient there).

### File 5: `scripts/R/05_figures.R` — EXTEND for channel/heterogeneity figures

Add **Phase 4 — CH4/CH3 channel figures (~10 new figures)**:
- `fig_ch4_rent_pass_through_{en,ko}.{pdf,png}` — bar chart: pass-through rate Korea (Spec A T3) vs EU Ciaian 46% vs US Kirwan 25%
- `fig_ch4_op_cost_decomposition_{en,ko}.{pdf,png}` — op_cost total / rent_cost / op_cost_ex_rent stacked bars per bandwidth
- `fig_own_share_heterogeneity_{en,ko}.{pdf,png}` — interaction coefficients by own_bin (5 levels) for rent_cost and op_cost_ex_rent
- `fig_ch3_area_event_study_{en,ko}.{pdf,png}` — year-by-year area_total coefficients
- `fig_ch3_exit_rd_{en,ko}.{pdf,png}` — exit_indicator RD scatter

20 new files (10 figures × 2 fmts). Total figure count: 66 (P3a) + 20 (P3b) = 86 files.

### Auxiliary edits

**`scripts/R/00_run_all.R`** — extend pipeline vector to 8 scripts:
```r
pipeline <- c("01_clean.R", "02_descriptive.R", "03_did_rd.R",
              "04_robust.R", "05_figures.R",
              "06_channels.R", "07_heterogeneity.R", "08_iv.R")
```

**`CLAUDE.md` "Identification Strategy" §Theory line** — extend B-6 framing to two-margin:
- Current (af22000): "(S,s) directional prediction … β(op_cost) ≤ 0"
- Update: "**Two-margin theory test**: (i) **Incidence margin (CH4)** — Korean per-farm flat-rate distinct from US per-hectare proportional (Kirwan 2009 JPE ~25% capitalize) and EU per-hectare flat-rate (Ciaian et al. 2023 *Land Use Policy* 46–55% capitalize) → predict β(rent_cost) ≈ 0; (ii) **Behavioral margin ((S,s))** — T/s_min ≈ 2.4% deeply within inaction region → β(op_cost_ex_rent) ≤ 0. Joint two-margin pattern is publishable JAE/AJAE contribution regardless of single-margin significance."

**`.claude/agents/domain-reviewer.md` Lens 1 B-6** — add Ciaian 2023 citation alongside Kirwan; refine prediction asymmetry note.

**`.claude/agents/domain-reviewer.md` Lens 5 E-7** — add CH4 incidence test to "AJAE referee 7-angle defense" as a new mitigated angle (the 8th angle, or refine existing).

These cross-reference edits are LOW-risk text additions and may be committed alongside P3b implementation (or separately for cleaner history). Recommendation: commit cross-refs first as docs(claude.md) + docs(domain-reviewer) immediately after P3b plan approval, then implement.

## Files to modify

| Path | Action | Approx lines |
|---|---|---|
| `scripts/R/06_channels.R` | **CREATE** | ~280 |
| `scripts/R/07_heterogeneity.R` | **CREATE** | ~320 |
| `scripts/R/08_iv.R` | **CREATE** | ~180 |
| `scripts/R/04_robust.R` | EDIT (Phase 3 Wild bootstrap retry) | ~60 lines changed |
| `scripts/R/05_figures.R` | EDIT (add Phase 4 channel/het figures) | ~150 lines added |
| `scripts/R/00_run_all.R` | EDIT (pipeline vector → 8 scripts) | 3 lines |
| `CLAUDE.md` | EDIT (Two-margin framing on §Theory line) | 1-2 lines |
| `.claude/agents/domain-reviewer.md` | EDIT (B-6 + E-7 Ciaian cross-ref) | ~10 lines |
| `quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md` | **CREATE** (sister) | identical content |
| `quality_reports/session_logs/2026-05-16_p3b.md` | **CREATE** (incremental log) | grows during impl |

## Critical reference files (read-only during implementation)

- `scripts/R/_outputs/clean.rds` — 16 outcome cols + `rent_cost`, `op_cost_ex_rent`, `area_total`, `own_share`, `area_own`, `area_rent`, `actual_subsidy`, demographics
- `scripts/R/_outputs/main_results.rds` (P2 32-fit specs to reuse for spec tibble)
- `scripts/R/_outputs/rob_results.rds` (P3a outlier ladder reference)
- `scripts/R/_outputs/desc_summary.rds` (P2 take-up rate 92.3% for IV LATE comparison)
- `explorations/2026-05-15_p3b-precheck/check.R` (pre-check confirming viability)
- `master_supporting_docs/own_drafts/stata_analysis/02_analysis.do` lines 130–140 (rdplot pattern for figures)
- `.claude/rules/r-code-conventions.md` §10 (rename map already applied), §11 (cluster = hh_id), §13 (figure output convention)
- `.claude/rules/replication-protocol.md` Phase 3 (no STATA anchors for CH4/CH3/IV — document as R-only)
- `.claude/agents/domain-reviewer.md` Lens 1 B-6, Lens 5 E-7 (theoretical anchor + referee defense to update)
- **External references (literature anchors):** Kirwan 2009 JPE 117(1); Ciaian et al. 2023 *Land Use Policy* 134; Caballero-Engel 1999 (S,s); Blundell-Pistaferri 2008 consumption smoothing
- `MEMORY.md` LEARN entries 2026-05-06 (gfortran), 2026-05-14 (sandwich × fixest, %8.0f rounding)

## Verification

### Phase 0 — Package availability
```bash
# Optional but encouraged: fwildclusterboot install attempt (Path A)
# User runs once outside Rscript:
#   1. Download gfortran-12.2-universal.pkg from https://mac.r-project.org/tools/
#   2. sudo installer -pkg gfortran-12.2-universal.pkg -target /
#   3. Rscript -e 'install.packages("fwildclusterboot", repos="https://cloud.r-project.org", type="source")'
# If fails, P3b-6 falls back to manual Rademacher (Path B).
```

### Phase 1 — Pipeline run
```bash
Rscript scripts/R/00_run_all.R
# Expected timing (extends P3a 13.75s baseline):
#   01–05 (existing) : ~13s
#   06_channels.R    : ~5s (24 + 16 fits, no bootstrap)
#   07_heterogeneity : ~15s (60+ interaction fits)
#   08_iv.R          : ~5s (24 IV fits)
#   Wild bootstrap   : +7 min if Path B active; +1 min if Path A
# Total: ~45s without Wild, ~7-8 min with Wild
```

### Phase 2 — Output existence (~30 new files)
```bash
ls scripts/R/_outputs/ | grep -E '^(channels|heterogeneity|iv|tab_ch4|tab_ch3|tab_het|tab_iv|fig_ch4|fig_ch3|fig_own_share)'
# Expect: channels_results.rds, heterogeneity_results.rds, iv_results.rds,
#         tab_ch4_rent_decomposition_{en,ko}.tex, tab_ch3_retention_{en,ko}.tex,
#         tab_het_own_share_ch4.tex, tab_het_demographic_{en,ko}.tex,
#         tab_iv_late_{en,ko}.tex,
#         fig_ch4_*, fig_ch3_*, fig_own_share_* (20 new files)
```

### Phase 3 — Scenario classification (the headline gate)
```bash
Rscript -e '
ch <- readRDS("scripts/R/_outputs/channels_results.rds")
# Pull Spec A T3 (MSE) cells for headline classification
spec_A_T3 <- ch$ch4_results |> dplyr::filter(spec == "A", bw_id == "T3")
print(spec_A_T3)
# Compute pass-through
spec_A_T3$pass_through_rate <- spec_A_T3$rent_cost_est / 1.2e6
'
```

Manually classify into 4-cell scenario matrix (best case / partial / null / Korea≡EU). Result determines Phase 4 (Task #13) submission strategy reading.

### Phase 4 — Quality gate
- `04_robust.R`, `05_figures.R`: existing 100/100 expected (no LaTeX strings changed; new lines are R code)
- `06_channels.R`, `07_heterogeneity.R`, `08_iv.R`: target ≥80; expect known LaTeX-string false-positive pattern (per P2/P3a precedent) — document override in commit if encountered.

### Phase 5 — Visual sanity check (figures)
- `fig_ch4_rent_pass_through_en.pdf` — Korea bar should be visibly lower than 46% (Ciaian EU) and 25% (Kirwan US) if best case
- `fig_own_share_heterogeneity_en.pdf` — pure_owner coefficient ≈ 0 (no rent to begin), pure_tenant largest, mixed monotone
- `fig_ch3_area_event_study_en.pdf` — pre-period (2018) coefficient ≈ 0 (parallel trends), 2020+ deviation visualized

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| `rent_cost` median = 0 (right-skewed) → CH4 estimation noisy | Medium | Use both raw and `asinh(rent_cost)` transforms (already in clean.rds as no — need to compute in 06_channels.R Phase 1). Report both in `tab_ch4`. |
| Pure owner own_bin coefficient identifies as numerical noise (no rent at all) | Low | Document explicitly in table footnote — "pure_owner reference category by construction; coefficient ≡ 0." Use as reference. |
| `area_total` event-study reveals pre-trend (parallel trends violation) | Medium | If 2018 coefficient ≠ 0 at 95%, report Roth-Rambachan 2024 sensitivity bounds; flag in `domain-reviewer.md` E-7 Lens 5 HIGH-risk slot. |
| Heterogeneity 60+ cells: tabulation explodes | Low | Compact per-dimension 4-table format (per P3a `tab_rob_outlier_*.tex` pattern). One .tex per dimension. |
| IV first-stage F < 10 (weak instrument) | Low | Take-up 92.3% suggests strong first-stage; verify with `fitstat(iv_fit, "ivf")`. If <10, IV results degraded but ITT still primary. |
| Wild bootstrap (P3b-6) infeasibility on all 60+ cells | High | Restrict Wild bootstrap to ~14 headline cells (8 replication + 6 CH4 main); cluster-robust SE sufficient for heterogeneity per Cameron-Miller (2015) practice. |
| Korean rent_cost variable encoding (해당 컬럼 단위/정의 모호) | Low | Verified in clean.rds via `attr(df$rent_cost, "label")` — STATA mapping confirmed in 01_cleaning.do (per P1 [LEARN:methods]). |
| gfortran install failure (Path A) | Medium | Path B manual Rademacher implemented as primary (Path A bonus only) — does NOT block P3b headline. |

## Approval gate

On ExitPlanMode approval:
1. Plan status DRAFT → APPROVED. Save **sister** to `quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md` (identical content per `[LEARN:harness]` 2026-05-06).
2. **Optional: commit cross-reference updates first** (`docs(claude.md): two-margin framing` + `docs(domain-reviewer): add Ciaian 2023 to B-6`) — small atomic commits before implementation. Or batch into P3b feature commit.
3. Implement in order P3b-1 → P3b-2 → P3b-3 → P3b-4 → P3b-5 → P3b-6. Each item is a logical milestone — incremental commits acceptable if needed.
4. After P3b-1 (~2h), pause and **classify Spec A T3 cells against the 4-scenario matrix** — this informs whether to continue full plan or pivot (e.g., if scenario = "Korea ≡ EU", reframe Phase 4 immediately).
5. Update `quality_reports/session_logs/2026-05-16_p3b.md` incrementally per `session-logging.md`.
6. Final pipeline run + verification + quality gate → present commit-ready summary; user invokes `/commit`.
7. After commit + push: Phase 4 (Task #13) submission strategy decision based on full P3b results (scenarios 1–4 + heterogeneity + IV LATE + Wild bootstrap status).
