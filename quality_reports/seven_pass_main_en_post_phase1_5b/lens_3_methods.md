# Lens 3 — Methods/Identification (Post-Phase-1.5b, Fourth Pass)

**Score: 9.0/10** (Δ +0.8 from 8.2 baseline) — Phase 1.5b target ≥8.5 **ACHIEVED with margin**.
**Disposition:** PASS

## CRITICAL closure audit

### P1 SUTVA sign-direction fix — CLOSED. Clean.

L348 ¶ "Third" rewrites cleanly:
1. **Theoretical:** "the sign of the residual within-province bias is ambiguous in theory" — followed by explicit two-sided argument (lower rent pushes control own-area negative AND reduces treated's relative ownership cost, partially offsetting). "We do not attempt a directional bias argument here."
2. **Empirical:** "we treat Table~\ref{tab:sido_robustness_en} as the operative empirical bound: the median absolute coefficient shift under province-by-year FE absorption is 12%, and no sign flips occur on the shared outcomes."

This is the methodologically correct move for SUTVA sensitivity when equilibrium-feedback sign is ambiguous — consistent with Manski (1993) reflection-problem treatment and standard interference-robustness practice. No new issues introduced. The rent-margin outcomes ($\hat\beta_5$, rent_cost, area_rent) remain correctly disclaimed as reduced-form aggregate-equilibrium objects.

**Δ: +0.5**

### MAJ-7 "sharp ITT" oxymoron — PARTIALLY CLOSED

Line 488 cleanly fixed: "discontinuity-based ITT identification on the symmetric-screened subpopulation". One residual at L448: "does not yield a strictly sharp DiD-RD because eligibility-conditioning is one-sided" — the "strictly sharp DiD-RD" phrase is the same oxymoron MAJ-7 targeted, surviving because Phase 1.5b only touched the conclusion. It's negated ("does not yield") and lives in a comparator paragraph, but a sharp referee would flag.

**Recommended micro-fix:** L448 "does not yield a strictly sharp DiD-RD" → "does not yield two-sided observable-eligibility symmetry."

**Δ: +0.2 (would be +0.3 with L448 also fixed)**

### L6 M1 HonestDiD register — CLOSED

L415 paragraph reads as third-person methodological statement: "$\bar M^* = 0$ is the binding interpretation: ... The HonestDiD result is therefore not evidence supporting the headline; the headline rests on identification anchors that the sensitivity test does not adjudicate." First-person "We acknowledge / We do not claim / We read" are gone. The substantive identification argument (cross-bin gradient identified off heterogeneity across $s_{0,i}$, cannot be mimicked by universal trend deviation) is now stated as logic rather than as a plea.

**Δ: +0.15**

## Carried-forward MAJs — Phase 2 scope

| Ref | Issue | Status |
|---|---|---|
| MAJ-1 | Narrow-window McCrary CJM not at multiple bandwidths | Phase 2 — code-side |
| MAJ-2 | Covariate continuity at cutoff table absent | Phase 2 — code-side + appendix |
| MAJ-3 | Self-reported area_2018 measurement error | Phase 2 — discussion + sensitivity |
| MAJ-4 | B=999 vs B=9,999 wild bootstrap | Disclosed L344 (acceptable interim) |
| MAJ-6 | Anticipation citation (Malani-Reif / Abbring-vdBerg) | Phase 2 — citation |

None aggravated by Phase 1.5b.

## New observations

**Positive 1:** L318 explicit "estimand is NOT a sharp ATT" + cohort-average compliance footnote — correct ITT framing pre-empts the obvious referee question.

**Positive 2:** §5.3 SUTVA paragraph is now an exemplar of how to handle ambiguous-sign equilibrium-feedback bias: state theoretical ambiguity → name empirical bound → cite numbers → state robustness conclusion. The Manski-Pepper-style partial-identification move done correctly.

**Concern (minor):** L448 "strictly sharp DiD-RD" — see MAJ-7 above.

## Score breakdown

| Item | Phase 1.5b delta |
|---|---|
| CRIT-1 SUTVA sign error | +0.50 (closed) |
| MAJ-7 sharp ITT | +0.20 (mostly closed; −0.10 residual L448) |
| L6 M1 HonestDiD register | +0.15 (closed) |
| Carried-forward MAJ-1..MAJ-6 | 0 |
| New: L448 "strictly sharp DiD-RD" | −0.05 (MINOR) |

**Net: +0.80. Score: 9.0/10.**
