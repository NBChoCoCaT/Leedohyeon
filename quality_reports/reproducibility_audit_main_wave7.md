# Reproducibility Audit: paper/en/main.tex (Wave 7)

**Date:** 2026-05-19
**Manuscript:** paper/en/main.tex (39 pages, post-PR #16 merge)
**Outputs directory:** scripts/R/_outputs_eligibility/
**Tolerance source:** .claude/rules/replication-protocol.md (estimate < 0.01, SE < 0.05, integers exact)

## Summary

| Status | Count |
|---|---|
| PASS | 18 |
| FAIL (outside tolerance) | **4** |
| UNMATCHED | 0 |
| **Overall verdict** | **FAIL** (4 BLOCKERS — minor text errors; magnitudes themselves all PASS) |

## PASS

| Claim | Location | Reported | Computed (RDS) | Status |
|---|---|---|---|---|
| Sample size N (obs) | §4 line 315, Abstract | 13,689 | 13,689 | PASS exact |
| Sample size N (farms) | §4 line 315, Abstract | 3,420 | 3,420 | PASS exact |
| Treatment mean D̄ | §4 line 315 | 0.312 | 0.3121 | PASS (round-down) |
| F1 pure_tenant T2 estimate | §5, §6, Abstract | +1,122 m² | 1121.88 | PASS (Δ=0.12 < 0.5) |
| F1 pure_tenant T2 p-value | §5, §6, Abstract | .041 | .0412 | PASS |
| F1 low_owner T2 estimate | §6 | +403 m² | 402.52 | PASS |
| F1 low_owner T2 p-value | §6 | .069 | .0694 | PASS |
| F1 mixed T2 estimate | §6 | +222 m² | 221.80 | PASS |
| F1 high_owner T2 estimate | §6 | −74 m² | −74.50 | PASS |
| F1 monotone gradient (4 bins) | §6 | 1122 > 403 > 222 > −74 | confirmed | PASS |
| op_cost_ex_rent T1 estimate | §6 line 359, §8, Abstract | −3.98M KRW | −3,978,705 | PASS |
| op_cost_ex_rent T1 p-value | §6 line 359, §8 | .057 | .0574 | PASS |
| op_cost_ex_rent T2 estimate | §6 line 359 | −3.13M KRW | −3,131,702 | PASS |
| op_cost_ex_rent T2 p-value | §6 line 359 | .097 | .0973 | PASS |
| Rent-cost pass-through T2 | §3, §6, §8 | −12.0% | −12.002% | PASS |
| Rent-cost β T2 | §6 line 363 | −144,027 KRW | −144,026.6 | PASS |
| McCrary T-stat (full) | §7 line 374 | t = 1.34 | 1.3413 | PASS |
| McCrary p-value | §7 | p = .18 | .1798 | PASS |
| McCrary n | §7 | 2,680 | 2,680 | PASS exact |
| Attrition placebo estimate | §7 line 383 | −0.082 | −0.0825 | PASS |
| Attrition placebo p-value | §7 line 383 | .46 | .460 | PASS |
| Attrition placebo n | §7 line 383 | 319 | 319 | PASS exact |
| Multi-RV area t | §7.2 | 1.34 | 1.3413 | PASS |
| Multi-RV owned t | §7.2 | −1.64 | −1.6371 | PASS |
| Multi-RV off-inc t | §7.2 | 0.18 | 0.1777 | PASS |
| 22% of 0.5 ha threshold | §8 | ≈ 22% | 1122/5000 = 22.4% | PASS |
| Discussion magnitudes | §8 | all match §6 | confirmed | PASS |

## FAIL (BLOCKERS — minor text errors; magnitudes themselves all PASS)

### FAIL-1: §4 line 317 panel-attrition decomposition uses Wave 5 stats

| Field | Value |
|---|---|
| Location | §4 Data, "Panel-attrition decomposition" paragraph (line 317) |
| Paper claims | "Of 3,614 farms × 5 years = 18,070 expected farm-years, 14,474 are observed (80.1%); residual 3,596 missing" |
| Correct (Wave 7 subset) | 3,420 farms × 5 = 17,100 expected; 13,689 observed (80.05%); residual 3,411 missing |
| Tolerance | Exact (integers) |
| Severity | **CRITICAL** — inconsistent with line 315 sample size |
| Fix | Replace 3,614 → 3,420; 18,070 → 17,100; 14,474 → 13,689; 3,596 → 3,411; 80.1% → 80.05% (or 80.1%) |

### FAIL-2: §5 notation table line 117 uses Wave 5 sample size

| Field | Value |
|---|---|
| Location | §3 Notation table (line 117): `$i = 1,\ldots,3614$` |
| Paper claims | Household index $i = 1,\ldots,3614$ |
| Correct (Wave 7 subset) | $i = 1,\ldots,3420$ |
| Severity | **MAJOR** — table 1 notation conflicts with §4 sample statement |
| Fix | Replace 3614 → 3420 |

### FAIL-3: §6 line 359 op_cost_ex_rent n_obs mismatch

| Field | Value |
|---|---|
| Location | §6 Results, "Operating-cost sub-prediction" (line 359) |
| Paper claims | "T1: p=.057, n=788; T2: p=.097, n=1,618" |
| Actual op_cost_ex_rent n (ch4_results.rds) | T1 n=760; T2 n=1,567 |
| Note | The 788/1,618 values match op_cost_pooled (regular op_cost), but the cited magnitudes (−3.98M / −3.13M) and p-values come from op_cost_ex_rent (which has fewer obs due to rent_cost missingness) |
| Severity | **MAJOR** — n_obs / magnitude variable mismatch |
| Fix | Replace n = 788 → n = 760 ; n = 1,618 → n = 1,567 |

### FAIL-4: §6 paragraph 350 — pure-tenant T1 significance claim

| Field | Value |
|---|---|
| Location | §6 Results, "F1 result: own-area response and tenancy gradient" (line 350) |
| Paper claims | "the pure-tenant response is statistically distinguishable from zero at the p < .10 level across all three bandwidths and at p < .05 in T1, T2, and T3" |
| Actual p-values | T1 p = .0528; T2 p = .0412; T3 p = .0229 |
| Tolerance | Same significance level (p-value tolerance) |
| Severity | **MAJOR** — T1 is NOT < .05 (it is .053, between .05 and .10) |
| Fix | Change "at p < .05 in T1, T2, and T3" → "at p < .05 in T2 and T3" |

## UNMATCHED

(none)

## Environment

R 4.5.3 (2026-03-11); fixest 0.13+, rdrobust 2.2+, rddensity 2.6+, HonestDiD 0.2+ (full sessionInfo in `scripts/R/_outputs_eligibility/sessionInfo.txt`).

## Next steps

1. Apply the 4 FAIL fixes (all are minor text edits; no re-estimation required).
2. After fixes, the manuscript will be 100% reproducibility-audit PASS at the documented tolerance thresholds.
3. Note: all magnitudes themselves PASS — the FAIL items are downstream text-consistency errors introduced during the Wave 7 paragraph rewrites (PR #15) where some Wave 5 stats persisted in non-edited paragraphs.
