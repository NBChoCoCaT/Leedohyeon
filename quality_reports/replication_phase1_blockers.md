# Phase 1 Blockers — R-side Replication Report

**Date:** 2026-05-20
**Plan:** `quality_reports/plans/2026-05-20_phase1-blockers.md`
**Branch:** `feat/wave9-phase1-blockers`
**Output dir:** `scripts/R/_outputs_symmetric/`

## Sample Waterfall

| Stage | Obs | HH | Treated | Control | Treated share |
|---|---:|---:|---:|---:|---:|
| Wave 5 (full panel, `_outputs/clean.rds`) | 14,474 | 3,614 | 1,325 | 2,289 | 0.367 |
| Wave 7 (eligibility subset, `_outputs_eligibility/clean.rds`) | 13,689 | 3,420 | 1,131 | 2,289 | 0.331 |
| **Wave 9 (symmetric screening, `_outputs_symmetric/clean.rds`) — Phase 1 base** | **11,010** | **2,776** | **1,131** | **1,645** | **0.407** |

**Symmetric screening drops 644 control-side households** (28% of Wave 7 control side) — large-farm owners and off-farm-income-rich households that would NOT pass SFFP criteria (ii) ≥1.55ha or (vi) ≥45M KRW even if their cultivated area dropped below 0.5 ha.

Sanity (`scripts/R/_outputs_symmetric/symmetric_log.txt`):
- ✅ Within-subset sharp: `D_eligible_obs_2018 == 1[rv_2018≤0]` ∀ obs
- ✅ Treated unchanged: 1,131 hh
- ✅ No NA in load-bearing columns

## Headline Comparison

### F1 monotone gradient (area_own × tenancy bin, T2, area in m²)

| Bin | Wave 7 | **Wave 9 (Symmetric)** | Δ |
|---|---:|---:|---|
| Pure tenant | +1,122 (p=.041 \*\*) | **+1,151 (p≈.036 \*\*)** | +2.6% / tightened |
| Low owner | +403 (p=.069 \*) | **+438 (p≈.047 \*\*)** | +8.7% / promoted to \*\* |
| Mixed | +222 (NS) | +258 (NS) | +16% |
| High owner | −74 (NS) | −52 (NS) | smaller |
| Pure owner | ≡ 0 (ref) | ≡ 0 (ref) | — |

**F1 strengthened.** Monotonic gradient preserved; both pure-tenant and low-owner now significant at p<.05.

### CH4 rent-cost pass-through

| BW | Wave 7 | **Wave 9 (Symmetric)** |
|---|---:|---:|
| T1 (h=500) | NS | **−164,927 (p<.10 \*), −13.7%** |
| T2 (h=1000) | −11.1% (p=.133 NS) | −11.7% (p≈.16 NS) |
| T3 (mse) | NS | −1.1% (NS) |

**Incidence reversal Korea −13.7% (T1, \*) vs. Kirwan +25% / Ciaian +46-55% survives + now significant at narrow BW.**

### op_cost_ex_rent ((S,s) lumpy-investment test, PRIMARY per Step 1 swap)

| BW | Wave 7 | **Wave 9 (Symmetric)** | Outcome |
|---|---:|---:|---|
| T1 | −3.98M (p=.057 \*) | −3,567,680 (SE 2.19M, raw p≈.10, NS) | Attenuated |
| T2 | −3.13M (p=.097 \*) | −2,622,322 (SE 1.96M, p≈.18, NS) | Attenuated |

**(S,s) primary attenuated to directional consistency** — magnitude preserved, statistical significance lost (raw p above .10, Holm-adjusted NS). Treated as supporting evidence per 2026-05-20 user decision (Option A).

### Spec stability (12b forest)

| Metric | Wave 7 | **Wave 9** |
|---|---:|---:|
| Sign flips / 24 cells | 2 | 3 |
| α=.05 crosses | **0** | **0** ✅ |
| α=.10 crosses | 2 | 3 |
| Median \|%Δ\| coef | 16.5% | 16.9% |

### sido_cd × year FE robustness (X5 fallback A')

24 cells fit (4 outcomes × 3 BW × 2 specs). **0/18 sign flips vs. main DiD-RD** on shared outcomes; median \|%Δ\| coef = 12.1%. Province-by-year FE absorbed effects modest beyond what hh_id FE already captured.

### Spec C — covariate-rich (farm_type × Post + age × Post)

12 cells fit. op_cost_ex_rent T1 = −3,988,855 (SE 2,473,289, t=−1.61, p≈.107) — direction preserved, slightly stronger than Spec A symmetric.

### McCrary density / placebo cutoffs / attrition

- ✅ McCrary 3-margin: PASS at all cutoffs (area, owned-area, off-farm-income)
- ✅ Placebo cutoffs: 4/32 at p<.10 (within false-positive rate)
- ✅ Differential attrition: all 3 BW NS — no treatment-arm-balanced attrition

## Outputs created in `_outputs_symmetric/`

**New artifacts (Phase 1A):**
- `clean.rds` (11,010 obs / 2,776 hh / sido_cd attached)
- `symmetric_log.txt`, `sido_merge_log.txt`
- `sido_results.rds` + `tab_sido_robustness_en.tex` (24-cell sido × year FE)
- `specC_results.rds` + `tab_specC.tex` (12-cell covariate-rich Spec C)

**Regenerated from existing scripts (12 + 14 figures, 30+ tables):**
- `tab_descriptives_en.tex` (Table 1 — symmetric Wave 9 magnitudes)
- `tab_main_did_rd_en.tex` (Spec A op_cost omnibus)
- `tab_ch4_rent_decomposition_en.tex` (CH4 — including op_cost_ex_rent primary)
- `tab_het_own_share_en.tex` (F1 4-bin gradient)
- `tab_specB.tex` (Spec B — drop 2020)
- `tab_dropped_balance_en.tex`, `tab_attrition_placebo_full_en.tex`, `tab_placebo_cutoffs_en.tex` (robustness)
- `fig_event_study_*.{pdf,png}`, `fig_mccrary_density_*.{pdf,png}`, etc. (88 figures)
- `alpha3_results.rds`, `channels_results.rds`, `desc_summary.rds`, `mccrary_test.rds`, `heterogeneity_results.rds`, `p3c_results.rds`, `rob_results.rds`, `dropped_balance.rds`, `attrition_placebo_full.rds`, `placebo_cutoffs.rds`
- `sessionInfo.txt`

## Phase 1A reproducibility status

- All R scripts exit 0 under `set.seed(20260504L)`.
- Pipeline driver (`run_symmetric_pipeline.R`) completes in 1.4 min wall-clock.
- New R scripts (`01d`, `01e`, `03d`, `04b`): documented headers, snake_case, hh_id cluster.
- 3-way `.elig` / `.sym` assertion in scripts 02/03/04/06/08 allows pipeline reuse across Wave 5 / 7 / 9 samples.
- 13b/14b/15b updated to respect `OUT_DIR` injection (per pipeline_env pattern).

**Replication-protocol Phase 3 tolerance:** Symmetric Wave 9 is a NEW sample (not a replication of Wave 7), so within-sample tolerance applies internally. All scripts read from the same `clean.rds`; cross-script numeric consistency is by construction. Audit-reproducibility against paper text scheduled for Phase 1C Step 21.
