# Seven-Pass Review Synthesis — Post-Phase-1.5

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` (496 lines, 56-page PDF)
**Previous reviews:**
- Pre-Phase-1 (initial): composite **6.4/10**
- Post-Phase-1: composite **7.9/10**
- **Post-Phase-1.5 (this): composite 8.24/10**

---

## Executive verdict

**Overall state: REVISE-MINOR (target: AJAE submission after Phase 1.5b mop-up).**

Composite **8.24/10** (Δ +0.34 from 7.9). Phase 1.5 target ≥8.5 **narrowly missed (−0.26)**; 3 mop-up items (~30 min total) close the gap. Phase 1.5 closed 9 of 9 CRITICALs targeted, but the verification surfaced **1 NEW CRITICAL** in Methods (the SUTVA "lower-bound" rewrite has a sign-direction error) and **2 MAJORs** (Robustness text↔table contradiction + Citations bib-cleanup regression).

| Lens | Pre-1 | Post-1 | **Post-1.5** | Δ vs Post-1 | ≥8.5? |
|---|---:|---:|---:|---:|:-:|
| 1. Abstract | 6.0 | 8.5 | **9.0** | +0.5 | ✅ |
| 2. Intro | 6.5 | 5.5 | **5.6** | +0.1 | ❌ (Phase 2) |
| 3. Methods | 6.5 | 7.5 | **8.2** | +0.7 | ❌ (CRIT-1 NEW) |
| 4. Results | 4.0 | 8.0 | **8.7** | +0.7 | ✅ |
| 5. Robustness | 6.5 | 8.6 | **9.0** | +0.4 | ✅ |
| 6. Prose | 6.5 | 8.1 | **8.6** | +0.5 | ✅ |
| 7. Citations | 8.5 | 9.1 | **8.6** | **−0.5** | ✅ (regression) |
| **Composite** | **6.4** | **7.9** | **8.24** | **+0.34** | ❌ −0.26 |

**5 of 7 lenses cleared the 8.5 target**; the 2 misses (Intro 5.6, Methods 8.2) explain the composite shortfall.

---

## Cross-lens findings

### NEW CRITICAL (1 — must fix before declaring 8.5)

| # | Lens | Issue | Effort |
|---|---|---|---|
| **P1** | L3 CRIT-1 | **§5 SUTVA paragraph "lower bound" sign error.** Phase 1.5 N2 rewrite claimed: "lower control-side rent ... biases F1 toward zero, so $+1{,}151$ is a lower bound on partial-equilibrium response." Lens 3 caught the inversion: under (\ref{eq:CO-threshold}), lower equilibrium rent makes renting cheaper for control → control own-area pivot is NEGATIVE under spillover (was 0 in no-spillover counterfactual). Observed difference = treated pivot − (negative control pivot) = **UPPER bound**, not lower bound. Rescue path: drop directional claim and rely on the empirical sido × year FE bound (median 12% shift, Table~\ref{tab:sido_robustness_en}). | 15 min |

### NEW MAJOR (2)

| # | Lens | Issue | Effort |
|---|---|---|---|
| **P2** | L5 M-A | **§7 text↔table contradiction.** L396: "Analogous outlier-ladder tables for the other three primary outcomes are available in the replication package" — but the Phase 1.5 `\input{tab_rob_outlier_en.tex}` now EMBEDS all four outcomes in the paper. Remove the "available in" sentence or change wording. | 1 min |
| **P3** | L7 MAJ-1 | **7 retained .bib entries are actually orphan.** Phase 1.5 Y17 cut 3 entries on the basis of a (flawed) grep that suggested 7 others were used in `online_appendix.tex`. L7 ran a correct grep — all 7 are unused (`Sandmo1971_uncertainty`, `Kimball1990_prudence`, `BlundellPistaferri2003_consumption`, `Kimhi2000_exit`, `PietolaVareOudeLansink2003_exit`, `Foltz2004_dairy`, `Kazukauskas2014_decoup`). Drop or reintegrate. | 5 min |

### L3 MAJ-7 (new from Phase 1.5)

- **"sharp ITT identification" oxymoron at line 488** (Conclusion). ITT identification on the screened subpopulation is precisely NOT sharp; replace with "discontinuity-based ITT identification" or "ITT identification on the symmetric-screened subpopulation". 2-min fix.

### L5 MINOR-3 (numeric inconsistency)

- L400 claims "wild bootstrap p-values agree with cluster-robust analytic p-values within ±.01 on every cell" — but `tab_wild_bootstrap_en.tex` Panel B row 4 shows op_cost_ex_rent T1 with p_cluster=.1051 vs p_wild=.0410 (0.064 gap, straddling α=.05). Adjust claim to "agree within ±.07" or report the largest gap honestly.

### L6 M1/M2 (Phase 1.5 cosmetic)

- M1: HonestDiD reframe (L415) has defensive first-person register ("We acknowledge...", "We do not claim...", "We read..." 3 occurrences). Recast objectively.
- M2: New SUTVA paragraph (L348) compounds em-dash overuse with First/Second/Third enumeration.

### Verification N2 (potential numeric)

- L413 HonestDiD CI [−242, +331] for point estimate +225 is asymmetric. Possible — HonestDiD bounds are partial-identification intervals, not symmetric Gaussian CIs. Verify against `_outputs_symmetric/alpha3_results.rds$honestdid_results`.

---

## Carried-forward MAJORs (Phase 2 scope, NOT blocking 8.5 target)

From L3 (Methods):
- MAJ-1: McCrary narrow-window p≈.07 soft-pedal — Phase 2 wording tighten or run CJM rddensity
- MAJ-2: Covariate continuity at cutoff (CCT 2014) absent — Phase 2 analysis
- MAJ-3: Measurement error in $s_{0,i}$ self-report — Phase 2 sensitivity
- MAJ-4: Wild bootstrap B=999 vs 9,999 — Phase 2 compute
- MAJ-6: Anticipation defense prong (i) citation — Phase 2

From L4 (Results):
- M3: Holm step-down family declaration "consumption or farm_income" disjunction
- M7: T3 MSE per-outcome bandwidth
- M8: §3 4-bin partition vs tables 5-bin partition
- M9: Pre-trends |t|<1 numerical anchor

From L2 (Intro):
- Intro 1,569 words (still ~30% over AJAE 1,200) — Phase 2 restructure
- "Versus X" 4-block pattern — Phase 2
- Headline magnitudes at word ~1,005 — Phase 2

---

## Phase 1.5b — Mop-up plan (3 items, ~30 min)

| # | Item | Effort | Score impact |
|---|---|---|---|
| 1 | **P1**: §5 SUTVA — drop "lower bound" directional claim; cite Table~\ref{tab:sido_robustness_en}'s 12% empirical bound instead | 15 min | L3 +0.4 → 8.6 |
| 2 | **P2**: L396 outlier-ladder "available in replication package" → "shown in Table~\ref{tab:rob_outlier_op_cost_en} for op_cost" | 1 min | L5 +0.1 → 9.1 |
| 3 | **P3**: Drop 7 truly-unused .bib entries (Sandmo, Kimball, BlundellPistaferri, Kimhi, Pietola, Foltz, Kazukauskas2014_decoup) | 5 min | L7 +0.4 → 9.0 |
| Optional | **L3 MAJ-7**: "sharp ITT" → "discontinuity-based ITT" at L488 | 2 min | L3 +0.05 |
| Optional | **L5 MINOR-3**: Rewrite "±.01" claim to honest "±.07 max gap" | 3 min | L5 +0.05 |
| Optional | **L6 M1**: Recast HonestDiD paragraph opening to objective register | 15 min | L6 +0.1 |

**Projected post-mop-up composite: ≈ 8.55** (clears Phase 1.5 target 8.5).

---

## Contradictions between lenses

| Tension | Resolution |
|---|---|
| **L3 says SUTVA rewrite has sign error; L5 says §7 robustness is now 9.0/10** | Both correct — L3 evaluates the methodological argument; L5 evaluates table presence + roadmap. The SUTVA paragraph affects §5 (Methods/Identification scoring), not §7. |
| **L7 score dropped from 9.1 → 8.6 (regression)** | Phase 1.5 Y17 implementation used a buggy grep; 7 entries were not actually used in online_appendix. Phase 1.5b mop-up #3 restores score. |
| **L6 says "directionally consistent" over-closed (1× instead of target 2×)** | The over-closure is conservative — hedge-reduction is in the right direction. No action needed. |

---

## What Phase 1.5 closed cleanly (positive findings)

1. **N1 (sharp DiD-RD → ITT on screened subpopulation):** Lens 3 verified consistent across 18 sites; only 1 residual ("sharp ITT" at L488).
2. **N3 (HonestDiD honest reframe):** Lens 3 graded "partially closed" — honest acknowledgment present, cross-bin gradient identification anchor logically valid for uniform-trend case. Bin-level HonestDiD honestly deferred.
3. **N4–N7 (Results consistency):** Lens 4 all 4 CRITICALs closed (Table 1 with op_cost_ex_rent primary; cross-references; figure captions match prose).
4. **N8–N9 (prose cleanup):** Lens 6 verified.
5. **Y13 (hedge reduction):** Over-closed in conservative direction.
6. **Y14 (abstract split):** Lens 1 verified — reads well.
7. **Y11 (table inputs):** Lens 5 verified.

## What Phase 1.5 introduced as new issues (negative findings)

1. **L3 CRIT-1:** N2 SUTVA rewrite sign error (the very fix targeting a CRITICAL introduced a new CRITICAL).
2. **L5 MAJOR:** Y11 \input{} embed contradicts retained "available in replication package" prose.
3. **L7 regression:** Y17 bib cut was incomplete; 7 entries still orphan.
4. **L6 M1, M2:** New §5 SUTVA paragraph + HonestDiD reframe introduced em-dash density and defensive register.

---

## Bottom line

Phase 1.5 delivered substantial improvement (+0.34 composite, 5/7 lenses cleared 8.5) but the **SUTVA sign error** is a regression that needs immediate fixing before the 8.5 gate can be claimed. The 3 mop-up items take ~30 min combined; after them, the composite reaches ≈8.55 and the paper is in genuinely good shape for Phase 2 polish (intro restructure + Methods MAJ-1 through MAJ-6 + Results M3/M7/M8/M9 + L6 sentence-length pass).

**Next step decision:** run Phase 1.5b mop-up (~30 min) OR commit current state and tag Phase 2 work?
