# Lens 3 — Methods/Identification (Post-Phase-1, Second Pass)

**Reviewer:** domain-reviewer (PIDPS DiD-RD, calibrated to AJAE methods-referee severity)
**Target:** `paper/en/main.tex` (post-Phase-1)
**Date:** 2026-05-20

## Score: 7.5/10 (target ≥9.0 for AJAE-grade)
## Disposition: Major Revision

Phase 1 retired three of the five initial CRITICALs (C1, C2, C5) cleanly. C3 is half-fixed: sido×year robustness in table, but the textual SUTVA defense (line 347) contradicts the F1 mechanism on which the paper rests. C4 unaddressed (deferred). The new symmetric-screening estimand is mislabeled as "sharp DiD-RD" in three places — a methodological category error. A new CRITICAL has emerged: HonestDiD $\bar M^* = 0$ defended on grounds reading as special-pleading.

## Phase 1 fix acknowledgments

| Phase 1 fix | Status |
|---|---|
| C1 $D_i$ overload → eq.~(\ref{eq:Di-def}), Table 1, area-only renamed $D^{\text{area}}_i$ | ✅ Clean |
| C2 "Sharp DiD-RD restored on subset" → symmetric screening on both sides | ⚠️ Half-fixed — see CRIT-1 |
| C3 SUTVA via scalar Post FE → sido×year FE robustness | ⚠️ Partially fixed — see CRIT-3 internal contradiction |
| C4 $\tau$ anchor citations | ❌ Deferred |
| C5 SFFP/ABP mutual exclusivity at line 70 | ✅ Clean |
| M1 ITT one-liner | ✅ Clean (lines 313, 337, 84) |
| M3 McCrary p=.18 → t=0.68 p=.50 | ✅ headline; ⚠️ narrow-window soft-pedal (MAJ-1) |
| M5 Pure-owner 52% scoping | ✅ Clean (lines 377, 480) |
| M6 (S,s) magnitude | ✅ "directionally consistent" replaces "consistent with" |

## CRITICAL findings

### CRIT-1: Estimand is NOT sharp DiD-RD; manuscript calls it that 3×.

**Locations:** line 54, line 84 (gets it right elsewhere), line 317.

The construction is sample-conditional sharp, not unconditionally sharp:
1. The estimand is a LATE on a subpopulation defined by two non-cutoff observables (ii)+(vi), not a LATE at the cutoff in the Hahn-Todd-vanderKlaauw sense.
2. Compliance with full eight-criterion SFFP eligibility (criteria iii, iv, v, vii, viii via MAFRA/NAQS/aT) is unobserved. Footnote 6 line 263 puts non-receipt at ≈7.7%; actual-receipt rate among $D_i = 1$ ≈ 92.3%. **A design with $\Pr(\text{treatment} \mid D_i = 1) < 1$ is not sharp.**
3. §3 line 84 gets this right: "We do not estimate the sharp ATT...the ITT integrates over administrative non-receipt." §5 backslides.

**Required fix:** Replace "sharp DiD-RD identification" at line 317 with "intent-to-treat (ITT) DiD-RD identification *within the screened subpopulation*". Drop "$\iff$ by construction" from abstract line 34 + intro line 54. ~30-min mechanical fix.

### CRIT-2: HonestDiD $\bar M^* = 0$ defense reads as special-pleading.

**Location:** lines 408–410.

Three defense prongs each rebuttable:
1. "Event-study underpowered" — true but irrelevant; HonestDiD is conditional on available data.
2. "F1 power from cross-bin gradient" — non-sequitur; cross-bin gradient can be mimicked by differential pre-trends across $s_0$ bins.
3. "2018-baseline freeze" — conflates manipulation (which freeze addresses) with pre-trends (which it does not). Aging high-$s_0$ owners vs younger low-$s_0$ tenants can have different trends independent of policy.

AJAE referee will read this as conflating two distinct identification threats.

**Required fix:** Either (a) bin-level HonestDiD on pure-tenant subsample (1 day), OR (b) honestly accept the $\bar M^* = 0$ limit and reframe F1 as "consistent with wealth-biased liquidity under the parallel-trends maintained hypothesis; the single-pre-period design cannot bound the linear-trend sensitivity at non-zero $\bar M$" (2 hr).

### CRIT-3: §5 SUTVA paragraph contradicts §3 equilibrium-rent caveat.

**Location:** line 347 vs line 300 vs lines 196–212.

§5 line 347: "the F1 prediction is on $A_{\text{own},i}$... not through an interaction with the equilibrium rental price."

§3 derives the negative $\hat\beta_5$ rent response as the aggregate-equilibrium implication of the F1 pivot. If F1 causes the rent fall, then the rent fall feeds back into the rent-vs-own indifference (eq. CO-threshold line 191): $W^*(\mathbf{p})$ is a function of $\mathbf{p}$ including $r$. A fall in $r$ shifts $W^*$ upward → dampens the $A_{\text{own}}$ pivot for control households.

**Cannot simultaneously claim (a) F1 causes the rent reversal AND (b) F1 is independent of equilibrium rent for SUTVA purposes.**

**Required fix:** Restate as: "The sido×year robustness absorbs the largest geographic component; residual within-sido spillover biases $\hat\beta_1$ **toward zero** (control-side rents fall, weakening control-side substitution), so the F1 estimate is a **lower bound** on the partial-equilibrium pure-tenant response." This *strengthens* the F1 reading and is internally consistent.

## MAJOR findings

### MAJ-1: Narrow-window McCrary tests soft-pedaled.

Lines 384, 389. Narrow-window $p=.064$ (±500) and $p=.076$ (±1000) are exactly where T1/T2 identification operates. "Consistent with noisy local-window estimation" is a hedge, not an argument.

**Fix:** Run CJM (`rddensity::rddensity()`) — modern replacement; report as primary. Add donut-RD at ±100/±200.

### MAJ-2: Covariate continuity at cutoff is asserted but not tested.

No CCT 2014 covariate-continuity test. The dropped-balance Table (line 427) addresses balance between dropped vs retained, NOT across the cutoff within the analysis sample.

**Fix:** Add covariate-continuity table with `rdrobust(covariate, rv_2018)` p-values per covariate × bandwidth.

### MAJ-3: Measurement error in $s_{0,i}$ and self-reported area dismissed in one line.

Line 263. FHES area is self-reported; the 0.5 ha cutoff is enforced by NAQS land-registry records, not FHES self-report. The running variable used for identification differs from the running variable used administratively. Bin boundaries at 0.33/0.67 are exactly where F1 monotone-gradient is read off.

**Fix:** Either (i) Frisch-Waugh sensitivity at fuzzy bin boundaries (0.25-0.4), (ii) non-parametric local-polynomial $\hat\beta_1(s_{0,i})$ as continuous function, or (iii) discuss NAQS-FHES correspondence and acknowledge limitation.

### MAJ-4: Wild cluster bootstrap at B = 999 below standard.

Lines 343, 397. B=9,999 is the AJAE submission target. Single B=999 with seed=20260504L leaves enough MC noise to shift sig stars between drafts.

**Fix:** Run B=9,999 OR run three independent seeds and report spread.

### MAJ-5: Asymmetric-sample comparator risks "we tried both" trap.

Line 443. Framing as "cleaner sample-size-maximized" reads as specification-searching to adversarial referee.

**Fix:** Reframe with neutral language: "We document the asymmetric variant for replicability of the prior manuscript iteration, not as a robustness defense."

### MAJ-6: Anticipation defense (§3 line 180) prong (i) is an assertion without citation.

"the per-farm flat-rate SFFP component of PIDPS was specifically designed after 2018" lacks MAFRA legislative-history citation showing 0.5 ha cutoff was not in pre-2018 drafts.

**Fix:** MAFRA legislative-history citation OR falsification using 2017 Statistics Korea agricultural census.

## MINOR findings

- **MIN-1:** Holm step-down family drift — line 343 says "consumption *or* farm_income as omnibus"; pick one.
- **MIN-2:** T3 MSE-optimal h not reported per-outcome in §6.
- **MIN-3:** $T_{SFFP}/\tau$ five-year cumulative interpretation assumes saving; (S,s) predicts inaction. Bridge to precautionary-saving model needed.
- **MIN-4:** Triple-margin McCrary as "comparator" line 456 is correct but should state explicitly it's a property of upstream cohort, not analysis sample.
- **MIN-5:** Event-study $A_{\text{own}}$ at 2022 = +225 m² (line 408) doesn't match pooled $\hat\beta_1$ = +1,151 at T2. Either event-study drops bin-heterogeneity (pooled coefficient mechanically smaller with pure-owner zeros) or separate object. Clarify.

## Assumption ledger

| Assumption | Status |
|---|---|
| A1: Continuity of E[Y(0)|rv] | ⚠️ MAJ-2 covariate-continuity missing |
| A2: Density continuity (no manipulation) | ✅ full; ⚠️ MAJ-1 narrow-window |
| A3: 2018 baseline freeze | ✅ |
| A4: No anticipation | ⚠️ MAJ-6 |
| A5: Parallel pre-trends | ✅ 2018 placebo; ⚠️ CRIT-2 HonestDiD |
| A6: SUTVA | ⚠️ CRIT-3 contradiction |
| A7: ITT vs ATT | ⚠️ CRIT-1 mislabeling |
| A8: Bin-misclassification | ⚠️ MAJ-3 |
| A9: Local-linear functional form | ✅ |
| A10: Cluster independence | ✅; ⚠️ MAJ-4 B=999 |
| A11: (S,s) inaction band | ⚠️ MIN-3 + C4 deferred |
| A12: 4-bin partition robust | ⚠️ MAJ-3 |

6 clean / 5 MAJ or CRIT flags / 1 pending. AJAE target: ≤2 MAJ, 0 CRIT.

## Priority order for Phase 1.5 fixes

1. **CRIT-1** (sharpness mislabeling): 30-min mechanical fix lines 34/54/317.
2. **CRIT-3** (§5 vs §3 contradiction): 1-hr rewrite of SUTVA paragraph.
3. **CRIT-2** (HonestDiD defense): 2-hr honest reframe OR 1-day bin-level analysis.
4. **MAJ-2** (covariate continuity): 1-day analysis.
5. **MAJ-1** (narrow-window McCrary): 1-day analysis.
6. **MAJ-3** (measurement error in $s_0$): 1-day analysis.
7. **MAJ-4** (B=9,999 wild bootstrap): 6-hr compute.
8. **MAJ-5, 6, MIN-1..5:** editorial; <1 day.

Realistic Phase 2: ~5 working days to take 7.5 → 9.0.

## Positive findings

1. **Symmetric screening construction** genuinely cleaner than Wave 7 asymmetric — `01d_symmetric_clean.R` lines 66–69 verified.
2. **F2 sign-indeterminacy handling** exemplary — paper explicitly does not over-claim supervision channel.
3. **Three-prong differentiation from Kirwan/Baldoni-Ciaian** sharper post-Phase-1 (lines 48, 86, 472, 481).
4. **F1 four-bin gradient** is the right diagnostic for wealth-bias channel; cannot be mimicked by universal income effect. Survives Phase 1 cleanly.
5. **Notation table** comprehensive; $D_i$ vs $D^{\text{area}}_i$ split eliminates v1 overload completely.
6. **Holm step-down + wild cluster bootstrap + sido×year robustness** delivered with 0 sign flips, median |%Δ|=12.1% — exactly the right number.

**Bottom line:** One substantial revision away from AJAE-grade methods rigor. Three CRITs + six MAJs tractable in 5 working days. The underlying identification (symmetric-screened ITT DiD-RD with F1 four-bin tenancy gradient) is sound; methods section currently *overstates* what it has — correction is claim-strength calibration, not redesign.
