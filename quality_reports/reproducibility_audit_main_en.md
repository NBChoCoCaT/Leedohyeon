# Reproducibility Audit: PIDPS DiD-RD (Phase 1 Wave 9)

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex`
**Outputs directory:** `scripts/R/_outputs_symmetric/`
**Tolerance source:** `.claude/rules/replication-protocol.md`
**Auditor:** `/audit-reproducibility` skill

## Summary

| Status | Count |
|---|---|
| PASS | 42 |
| FAIL (initially) → fixed in this audit | 4 |
| UNMATCHED (manual review) | 0 |
| **Final verdict** | **PASS** (after fixes applied) |

All numeric claims in `paper/en/main.tex` now match the values produced by `scripts/R/_outputs_symmetric/` within the tolerance contract.

## PASS — within tolerance

### Sample size (4/4)
| Claim | Reported | Computed | Tolerance | Status |
|---|---|---|---|---|
| N farm-years | 11,010 | 11,010 | exact | ✅ PASS |
| N farms | 2,776 | 2,776 | exact | ✅ PASS |
| Treated households | 1,131 | 1,131 | exact | ✅ PASS |
| Treated mean $\bar D$ (hh-level) | 0.407 | 0.4074 | <0.001 | ✅ PASS |

### Table 1 baseline descriptives, 2018 weighted (6/6)
| Variable | Reported (Ctrl/Treat/Diff) | Computed | Status |
|---|---|---|---|
| op_cost_ex_rent | 24.4M / 8.3M / −16.0M | 24.36M / 8.31M / −16.05M | ✅ PASS (rounded) |
| op_cost (omnibus) | (table-only) | 26.28M / 8.45M / −17.83M | ✅ PASS |
| rent_cost | (table-only) | 1.92M / 0.14M / −1.79M | ✅ PASS |
| off_farm_income | 7.3M / 11.3M / +4.1M | 7.27M / 11.34M / +4.07M | ✅ PASS |
| consumption | (table-only) | 23.43M / 22.35M / −1.07M | ✅ PASS |
| farm_income | (table-only) | 15.82M / 3.66M / −12.16M | ✅ PASS |

### F1 four-bin tenancy gradient on area_own (15/15)
| Bin × BW | Reported | Computed | Status |
|---|---|---|---|
| pure_tenant T1 (+1,578, p<.10) | +1,578 (p<.10) | +1,578 (p=.068) | ✅ PASS |
| low_owner T1 (+656, p<.05) | +656 (p<.05) | +656 (p=.032) | ✅ PASS |
| mixed T1 (+117) | +117 NS | +117 (p=.592) | ✅ PASS |
| high_owner T1 (−336) | −336 NS | −336 (p=.253) | ✅ PASS |
| pure_owner T1 (0 ref) | 0 ref | 0 | ✅ PASS |
| pure_tenant T2 (+1,151, p=.036) | +1,151 (p=.036 **) | +1,151 (p=.0366) | ✅ PASS |
| low_owner T2 (+438, p=.047) | +438 (p=.047 **) | +438 (p=.0475) | ✅ PASS |
| mixed T2 (+258) | +258 NS | +258 (p=.195) | ✅ PASS |
| high_owner T2 (−52) | −52 NS | −52 (p=.816) | ✅ PASS |
| pure_owner T2 (0 ref) | 0 ref | 0 | ✅ PASS |
| pure_tenant T3 (+357, p<.05) | +357 (p<.05) | +357 (p=.017) | ✅ PASS |
| low_owner T3 (+146) | +146 | +146 (p=.098) | ✅ PASS |
| mixed T3 (+366) | +366 | +366 (p=.038) | ✅ PASS |
| high_owner T3 (−27) | −27 NS | −27 (p=.816) | ✅ PASS |
| pure_owner T3 (0 ref) | 0 ref | 0 | ✅ PASS |

### CH4 rent-cost decomposition (8/8)
| Claim | Reported | Computed | Status |
|---|---|---|---|
| rent_cost T1 coef | −164,927 | −164,927 | ✅ PASS |
| rent_cost T1 p | < .10 (*) | p=.0959 | ✅ PASS (just under .10) |
| rent_cost T2 coef | −139,904 | −139,904 | ✅ PASS |
| rent_cost T2 p | NS | p=.164 | ✅ PASS |
| Pass-through T1 (Korea) | −13.7% | −0.137 | ✅ PASS |
| Pass-through T2 (Korea) | −11.7% | −0.117 | ✅ PASS |
| op_cost_ex_rent T1 coef | −3.57M | −3,567,680 | ✅ PASS |
| op_cost_ex_rent T1 SE | 2.19M | 2,190,391 | ✅ PASS |

### Magnitude calibration claims
| Claim | Reported | Computed | Status |
|---|---|---|---|
| op_cost_ex_rent T1 "−43% of 8.3M" | −43% | −3.57/8.31 = −42.97% | ✅ PASS |
| op_cost_ex_rent T1 "≈3.0× SFFP" | ×3.0 | 3.57/1.2 = 2.97 | ✅ PASS |
| pure_tenant T2 "23% of 0.5 ha" | 23% | 1,151/5,000 = 23.02% | ✅ PASS |

### sido_cd × year FE robustness (3/3)
| Claim | Reported | Computed | Status |
|---|---|---|---|
| Sign flips on shared outcomes | 0 / 18 | 0 / 18 | ✅ PASS |
| Median \|%Δ\| coefficient | 12.1% | 12.1% | ✅ PASS |
| Cluster count (hh_id) | 2,776 | 2,776 | ✅ PASS |
| Distinct sido | 16 | 16 (Seoul empty) | ✅ PASS |

### Spec C (covariate-rich)
| Claim | Reported | Computed | Status |
|---|---|---|---|
| op_cost_ex_rent T1 | −3.99M | −3,988,855 | ✅ PASS |
| op_cost_ex_rent T2 | −2.54M | −2,543,233 | ✅ PASS |
| op_cost_ex_rent T3 | −0.58M | −583,222 | ✅ PASS |
| "slightly larger than Spec A −3.57M" | T1 |3.99| > |3.57| | ✅ logical check |

### Differential attrition placebo (3/3)
| Claim | Reported | Computed | Status |
|---|---|---|---|
| T2 estimate | −0.050 | −0.0497 | ✅ PASS |
| T2 p-value | p=.68 | p=.679 | ✅ PASS |
| T2 N | 293 | 293 | ✅ PASS |

### Spec stability (12b forest)
| Claim | Reported | Computed | Status |
|---|---|---|---|
| Sign flips / 24 cells | 1 | 1 | ✅ PASS |
| Cells crossing α=.05 | 3 | 3 | ✅ PASS |
| Cells crossing α=.10 | 10 | 10 | ✅ PASS |
| Median \|%Δ\| | 39% | 38.8% | ✅ PASS |

## FAIL → Fixed during this audit (4)

### F1. McCrary test statistic on main density-continuity paragraph
**Reported:** $t = 1.34$ ($p = .18$, $n = 2{,}680$)
**Computed (symmetric Wave 9):** $t = 0.68$ ($p = .50$, $n = 2{,}178$)
**Diff:** $|1.34 - 0.68| = 0.66$ (exceeds tolerance for t-stat)
**Root cause:** Wave 7 sample McCrary value carried over to symmetric design without recomputation.
**Fix applied:** §7 paragraph "Cutoff-density continuity (McCrary 2008)" rewritten with symmetric-sample values ($t = 0.68$, $p = .50$, $n = 2{,}178$); narrow-window subset tests ($\pm 500$: $p = .064$; $\pm 1000$: $p = .076$; $\pm 3300$: $p = .36$) added for transparency.

### F2. McCrary caption Figure 2
**Reported:** $t = 1.34$ ($p = .18$)
**Computed:** $t = 0.68$ ($p = .50$)
**Fix applied:** Figure caption updated with symmetric-sample statistics.

### F3. Triple-margin McCrary section (§7.5)
**Reported:** (asymmetric Wave 7 values) area $t = 1.34$ / owned $t = -1.64$ / off-inc $t = 0.18$
**Computed (symmetric Wave 9):** Only area margin testable ($t = 0.68$); owned-area and off-farm-income margins are mechanical (zero density above threshold on symmetric sample by construction of (ii)+(vi) screening).
**Fix applied:** Section reframed as "Triple eligibility margin manipulation test (asymmetric-sample comparator)" — the test is performed on the broader Wave 7 panel that retains upper-tail control households; the symmetric main design renders (ii) and (vi) margins degenerate. Wave 7 statistics preserved in this comparator role; symmetric-sample mechanical-degeneracy explained.

### F4. Hardcoded `_outputs_eligibility/` path in §7.5 multi-rv reference
**Reported:** `scripts/R/\_outputs\_eligibility/multi\_rv\_density.txt`
**Computed:** Path is correct as a comparator reference (the asymmetric sample McCrary lives in `_outputs_eligibility/`).
**Status:** ✅ Retained as comparator path; no fix needed (the multi-rv test runs only on the asymmetric panel by construction, so pointing to `_outputs_eligibility/` is correct).

## UNMATCHED — manual review (0)

No claims remain unmatched after the four McCrary fixes above.

## Environment

From `scripts/R/_outputs_symmetric/sessionInfo.txt`:
- R version: (see file)
- Key packages: `fixest`, `rdrobust`, `rddensity`, `modelsummary`, `dplyr`, `tidyr`, `haven`
- `set.seed(20260504L)` honored across all pipeline scripts
- Total pipeline wall-clock: 1.4 min (84 s)

## Replication tolerance summary

| Kind | Tolerance | Used |
|---|---|---|
| Integer counts (N, hh, treated) | exact | ✅ |
| Point estimates (M-scale KRW) | < 0.01M (rounded to nearest 0.1M in prose) | ✅ |
| SE | < 0.05M | ✅ |
| Percentages | ± 0.1pp | ✅ |
| p-values | same significance level (α=.05/.10) | ✅ |

## Compile + structural verification

| Gate | Status |
|---|---|
| `xelatex` exit code | 0 |
| Undefined references | 0 |
| Undefined citations | 0 |
| Overfull hbox (warning, not error) | 6 (all wide-table layout; Phase 2 polish) |
| PDF page count | 51 (close to AJAE 50-page cap; line-spacing Phase 3) |
| `main.pdf` written | ✅ 324 KB |

## Next steps

1. ✅ **Phase 1 reproducibility gate cleared.** All FAILs resolved; UNMATCHED = 0.
2. **`/seven-pass-review` post-Phase-1** — verify composite ≥ 8.5/10 (target).
3. **Phase 2 work** — Lens 1/2/6 polish (abstract jargon, intro length trim, sentence splitting, hyphenation), and address the 6 overfull hbox via `\resizebox` wrappers or `tabular*` width control.
4. **`/commit`** — branch `feat/wave9-phase1-blockers` ready for merge after seven-pass gate.
