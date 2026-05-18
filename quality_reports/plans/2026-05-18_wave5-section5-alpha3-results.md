# Wave 5 — §5 Results full implementation (Option A2)

**Date:** 2026-05-18
**Branch:** `feat/section5-alpha3-results` (new, off `main` @ `62023a0` post-Wave-4 merge)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 4–5 h (Option A2 estimate from earlier user response)

---

## Context

Wave 1–4 closed 11 of 14 CRITICAL from the 7-pass synthesis and lifted quality_score.py to 90/100 (AJAE submission threshold). The 3 remaining CRITICAL all depend on **§5 P3 estimation data** under the α3 outcome hierarchy (post-ADR-0002 reorder). Wave 5 fills the data gap by running a new α3-specific R analysis script that re-tabulates existing P3b-2 estimates + adds missing pieces (F2, HonestDiD, attrition placebo, SC2.5 sub-threshold-mass, take-up descriptive), then writes §5 Results prose to replace the current STUB.

**Existing R infrastructure (mature; 3893 lines across 9 scripts):**
- `scripts/R/01_clean.R` → `clean.rds` (14,474 × 50 panel)
- `scripts/R/03_did_rd.R` → `main_results.rds` (Spec A × T1/T2/T3 × 4 outcomes; cross-validated against `stata_analysis/02_analysis.log` per replication-protocol Phase 3 ±0.01/0.05 tolerance)
- `scripts/R/06_channels.R` → `channels_results.rds` (channel decomposition incl. CH4 capitalization-avoidance)
- `scripts/R/07_heterogeneity.R` → `heterogeneity_results.rds` (4-bin tenancy × T2 main)
- `scripts/R/09_wild_bootstrap.R` → `main_results$wild_replication$p_wild` + `channels_results$ch4_wild_p` (manual Rademacher refit, B=9999)
- `scripts/R/_outputs/mccrary_test.rds`, `figures/`

**Raw data accessible:** `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` (2.2 MB) + 25 source CSVs (FHES 2018–2022).

**Stata canonical reference:** `master_supporting_docs/own_drafts/stata_analysis/02_analysis.log` etc. — the R pipeline already cross-validates against these.

---

## Wave 5 deliverables (7 items per earlier triage)

| ID | Item | Source | Action |
|----|------|--------|--------|
| **W5-1** | Outcome hierarchy α3 reorder | existing `heterogeneity_results.rds` + `channels_results.rds` | Re-aggregate into `alpha3_results.rds` with area_own primary #1, op_cost_ex_rent #2, off_farm_income aux |
| **W5-2** | T1 + T3 4-bin cells | existing inputs; estimation new | Run rdrobust at T1 (h=500) and T3 (MSE-optimal) for area_own × 4-bin partition |
| **W5-3** | F2 off_farm_income estimation | not yet estimated | rdrobust at T1/T2/T3 × {pooled, 4-bin}; new fwildclusterboot p-values |
| **W5-4** | SC2.5 four-bin sub-threshold-mass | `clean.rds` + wealth proxy | 4-bin cross-tab of `Pr(W_i < W_i^* \mid s_{0,i} \in bin)`; wealth proxy = total assets (자산총액) or 2018 land area |
| **W5-5** | HonestDiD M̄ bounds | `main_results.rds` parallel-trends | Install `HonestDiD` CRAN pkg; compute sensitivity bounds on β_1 (area_own) and β_3 (op_cost_ex_rent) under linear-trend bias |
| **W5-6** | Differential-attrition placebo | `clean.rds` (need attrition flag) | rdrobust on attrition indicator = `1[any year missing]`; test no discontinuity at cutoff |
| **W5-7** | Take-up (92.3%) + hired-labor share (17–34%) | `clean.rds` | Extend `02_descriptive.R` style cross-tabs; populate §3.4.1 placeholders |

**Plus paper writing:**
- §5 Results STUB → 4-paragraph prose (F1 result + magnitude interpretation, F2 result, robustness pre-summary, headline reading per joint test outcome)
- §3.4.1 92.3% / 17–34% / SC2.5 placeholders filled inline from W5-4/W5-7
- §B.3 `tab:appB-mapping` T1/T3 TBD cells filled from W5-1/W5-2/W5-3
- 1–2 new figures: F1 four-bin gradient bar chart by bandwidth; HonestDiD M̄ sensitivity plot

---

## Critical files to create/modify

| File | Action |
|------|--------|
| `scripts/R/10_alpha3_estimation.R` | **NEW** — load existing _outputs, run W5-1 through W5-7, write `alpha3_results.rds` + tex tables + figures |
| `scripts/R/_setup_packages.R` | +`HonestDiD` package |
| `scripts/R/_outputs/alpha3_results.rds` | **NEW** — combined α3 outputs |
| `scripts/R/_outputs/fig_f1_fourbin_gradient_*.{pdf,png}` | **NEW** |
| `scripts/R/_outputs/fig_honestdid_sensitivity_*.{pdf,png}` | **NEW** |
| `scripts/R/_outputs/tab_alpha3_results_*.tex` | **NEW** — §5 main table |
| `scripts/R/_outputs/replication_check.txt` | **UPDATE** — add α3 cells cross-check vs `stata_analysis/02_analysis.log` |
| `paper/en/main.tex` | §5 STUB → prose; §3.4.1 placeholders fill; §3 magnitudes consistency check |
| `paper/en/online_appendix.tex` | §B.1 SC2.5 sub-threshold-mass fill; §B.3 tab:appB-mapping T1/T3 cells fill |
| `paper/ko/` | **UNTOUCHED** (CLAUDE.md bilingual rule) |

---

## Implementation order

### Phase 1 — Environment + W5-5 prep (~30 min)

1. **Add HonestDiD to `_setup_packages.R`** — append `"HonestDiD"` to `required` vector. Re-run `Rscript scripts/R/_setup_packages.R`.
2. **Verify rdrobust + sandwich version** — confirm rdrobust ≥ 2.x, sandwich provides vcovBS (already confirmed in 03_did_rd.R header).
3. **Read existing `_outputs/*.rds` schemas** — understand `main_results`, `heterogeneity_results`, `channels_results` structure for the new script to consume.

### Phase 2 — Write `scripts/R/10_alpha3_estimation.R` (~120 min)

Single script structured into 7 numbered sections, one per W5 deliverable:

```r
# 10_alpha3_estimation.R — α3 outcome hierarchy + Wave 5 deliverables.
#
# Inputs:  _outputs/clean.rds, main_results.rds, channels_results.rds,
#          heterogeneity_results.rds
# Outputs: _outputs/alpha3_results.rds (mega-file),
#          _outputs/tab_alpha3_results_{en,ko}.tex,
#          _outputs/fig_f1_fourbin_gradient_*.{pdf,png},
#          _outputs/fig_honestdid_sensitivity_*.{pdf,png},
#          replication_check.txt UPDATE.
#
# Plan: quality_reports/plans/2026-05-18_wave5-section5-alpha3-results.md

set.seed(20260504L)

# §1 (W5-1): α3 outcome hierarchy re-aggregation
#   - Pull primary #1 = area_own four-bin from heterogeneity_results
#   - Pull primary #2 = op_cost_ex_rent from main_results
#   - Aux = off_farm_income (new in §3)
#   - Ex-theory = unit_rent_price, rent_cost from channels_results
alpha3_main <- tibble(...)  # ordered by ADR-0002 hierarchy

# §2 (W5-2): T1 + T3 4-bin cells for area_own
#   - rdrobust(area_own ~ rv_2018) over each s_0 bin at T1 (h=500) and T3 (MSE-optimal)
#   - Append to alpha3_main as new rows
fourbin_T1 <- map_dfr(s0_bins, ~ rdrobust(..., h=500))
fourbin_T3 <- map_dfr(s0_bins, ~ rdrobust(..., bwselect="mserd"))

# §3 (W5-3): F2 off_farm_income at T1/T2/T3 × {pooled, 4-bin}
#   - rdrobust(off_farm_income ~ rv_2018) at 3 bandwidths
#   - Wild cluster bootstrap p-values via manual Rademacher (mirror 09_wild_bootstrap.R)
f2_results <- map_dfr(bandwidths, ~ rdrobust(...))

# §4 (W5-4): SC2.5 sub-threshold-mass cross-tab
#   - Build composite net-worth W_i from FHES Wave 1 raw CSVs:
#       W_i = 자산총액 (total assets) − 부채총액 (total debt)
#     pulled from {2018,2019}_집계_농가수지_*.csv + {2018,2019}_집계_농가부채_*.csv
#     (need: read_csv2 with Korean encoding; left_join to clean.rds via hh_id)
#   - W_i^* threshold via empirical RDD-implied cutoff from heterogeneity_results
#     (i.e., the wealth percentile at which P(rent→own crossing) becomes positive)
#   - Cross-tab: Pr(W_i < W_i^* | s_0 ∈ bin) for 4 bins × 2 bandwidths {h=500, h=1000}
wealth_panel <- read_csv2("...2018_집계_농가수지_*.csv") |>
  left_join(read_csv2("...2018_집계_농가부채_*.csv"), by = "hh_id") |>
  mutate(W_i = 자산총액 - 부채총액) |>
  left_join(clean.rds$panel, by = "hh_id")
sc2_5_mass <- wealth_panel |>
  group_by(s_0_bin, bandwidth) |>
  summarise(p_below = mean(W_i < W_star), n = n())

# §5 (W5-5): HonestDiD M̄ sensitivity bounds
#   - Pull pre-period coefficients from main_results parallel-trends fit
#   - HonestDiD::createSensitivityResults_relativeMagnitudes(...) on β_1 + β_3
#   - Report M̄ at which 95% CI for β_k stops containing 0
honestdid_b1 <- HonestDiD::createSensitivityResults(...)
honestdid_b3 <- HonestDiD::createSensitivityResults(...)

# §6 (W5-6): Differential-attrition placebo
#   - Build attrition flag: panel |> group_by(hh_id) |> mutate(attrition = n() < 5)
#   - rdrobust(attrition ~ rv_2018) — null test for cross-cutoff differential
attrition_placebo <- rdrobust(attrition_flag, rv_2018)

# §7 (W5-7): Take-up + hired-labor descriptive
#   - take_up_rate = mean(D_i == 1 & sffp_received == TRUE | D_i == 1)
#   - hired_labor_share = mean(hired_labor_hours / total_labor_hours) at 4-bin level
take_up <- ...
hired_labor <- ...

# Save
saveRDS(list(
  alpha3_main = alpha3_main,
  fourbin_T1 = fourbin_T1, fourbin_T3 = fourbin_T3,
  f2_results = f2_results,
  sc2_5_mass = sc2_5_mass,
  honestdid_b1 = honestdid_b1, honestdid_b3 = honestdid_b3,
  attrition_placebo = attrition_placebo,
  take_up = take_up, hired_labor = hired_labor
), "scripts/R/_outputs/alpha3_results.rds")

# Generate tex tables (modelsummary)
# Generate figures (ggplot2)
# UPDATE replication_check.txt with α3 cells STATA cross-check
```

**Cross-validation strategy:** for area_own + op_cost_ex_rent + rent_cost cells that overlap with existing P3b-2 / STATA estimates, the script writes a PASS/FAIL ledger against `stata_analysis/02_analysis.log` per replication-protocol.md Phase 3 tolerance (±0.01 / ±0.05). New cells (F2, T1/T3 4-bin breakdown, HonestDiD) have no STATA cross-check; flagged as new estimates.

### Phase 3 — Run script + iterate (~45 min)

```bash
Rscript scripts/R/_setup_packages.R   # adds HonestDiD
Rscript scripts/R/10_alpha3_estimation.R 2>&1 | tee scripts/R/_outputs/alpha3_log.txt
```

Expected run time: ~10 min (Wild bootstrap reps × 9 cells dominates). Iterate on any errors. Verify replication_check.txt PASS for overlapping cells.

### Phase 4 — Fill paper TBD cells (~45 min)

1. **§B.3 tab:appB-mapping T1/T3 cells** — replace "TBD" in main.tex / online_appendix.tex with `\input{...}` or inline numbers from `alpha3_results$fourbin_T1` + `$fourbin_T3` + `$f2_results`.
2. **§3.4.1 placeholders** — replace `% FILL post-§5 P3` markers:
   - 92.3% take-up rate ← `alpha3_results$take_up`
   - 17–34% hired-labor share ← `alpha3_results$hired_labor`
   - SC2.5 four-bin sub-threshold-mass ← `alpha3_results$sc2_5_mass`
3. **§3 magnitude consistency** — verify abstract / §3.4 / §B.3 numbers all match `alpha3_results` (no stale numbers from pre-Wave-5 narrative).

### Phase 5 — §5 Results prose write-up (~60 min)

Replace §5 STUB with 4-paragraph prose structure:

**¶1 (F1 result):** "We estimate the four-bin discrete monotonicity (\ref{eq:CO-2}) at T1, T2, and T3. Table~\ref{tab:alpha3-results} reports... [numbers]. The pure-tenant own-area response is +X m² at T2 (p=Y), monotone-decreasing in baseline tenancy share. F1 does not fire under the strict-AND decision rule; the wealth-biased liquidity channel is supported."

**¶2 (Op-cost sub-prediction):** "The operating-cost-ex-rent response at narrow bandwidth is −X M KRW at T1 (p=Y), consistent with the eq.~CO-3 (S,s) inaction sub-prediction. Across τ ∈ [20M, 40M] KRW robustness range, β_3 remains weakly negative."

**¶3 (F2 result):** "The off-farm-income response on the supervision-margin auxiliary outcome is X (p=Y) at T2, statistically [zero / non-zero]. F2 [fires / does not fire] under the trigger rule; consistent with [supervision-cost wedge inoperative / cancellation regime] at SFFP scale per the EK-1 sign indeterminacy disclosed in §\ref{sec:supervision}."

**¶4 (Joint test reading):** "Per the joint test classification in §\ref{sec:predictions}: F1 does not fire + F2 [fires / does not fire] → [modal outcome / strongest reading]. The headline AHM-separability rejection rests on F1 via the four-bin discrete monotone gradient. The −11.1% unit-rent-price pass-through reported as ex-theory aggregate-equilibrium implication (B.1 honest-reframe disclosure)."

**Plus headline italic restoration (Wave 1 X11 UNHEDGE gating):** If F1 does not fire (β_2 monotone confirmed), restore "We reject AHM separability for Korean small farms." per the UNHEDGE comment in abstract L42 + §3.1 L122.

### Phase 6 — Figures (~30 min)

1. **`fig_f1_fourbin_gradient_{T1,T2,T3}_en.{pdf,png}`** — bar chart of $\hat\beta_1$ × 4-bin × {T1, T2, T3} with 95% CI (wild bootstrap). 3 panels (one per bandwidth) or single grouped chart.
2. **`fig_honestdid_sensitivity_b1_{en,ko}.{pdf,png}`** — Rambachan-Roth M̄ breakdown plot for β_1 (area_own).

Save under `scripts/R/_outputs/` per existing figure naming convention.

### Phase 7 — Verification (~30 min)

1. **Compile main.tex + online_appendix.tex** — exit 0, no Korean glyph warnings, no new undefined cites.
2. **paper/ko 0-diff** ✓.
3. **quality_score.py main.tex** → ≥ 90 (expect ~92–95 given §5 STUB → real prose).
4. **replication_check.txt** — all PR-Wave-5 overlap cells PASS STATA cross-check at ±0.01 / 0.05 tolerance.
5. **alpha3_results.rds** loads cleanly; structure matches schema documented in script header.
6. **Magnitude triple-consistency:** abstract / §3.4 / §B.3 / §5 all match `alpha3_results` exactly.

### Phase 8 — Commit + PR (~15 min)

`/commit` skill: stage R script + outputs + paper edits + plan + figures → quality_score gate → gh pr create against main with Wave 5 itemized body. Manual approval before merge.

---

## Decisions to lock (pre-implementation)

**Q1 — Output file structure: single `alpha3_results.rds` mega-file vs modular (`f1_grid.rds + f2_results.rds + honestdid.rds + attrition.rds + descriptive.rds`)?** **Single mega-file** — easier downstream consumption from paper, matches existing pattern (`main_results.rds`, `channels_results.rds` are mega-files). Modular split adds replication-package friction.

**Q2 — UNHEDGE gating in Wave 5?** **Conditional on F1 not-fired in actual estimation.** Wave 1 X11 left UNHEDGE comment marking the condition; Wave 5 unhedges abstract + §3.1 IFF the script delivers F1 not-fired result. Otherwise hedge remains.

**Q3 — STATA cross-check on new cells (F2, T1/T3 4-bin, HonestDiD, attrition)?** **Document as new (no STATA reference)** with a clear marker in replication_check.txt. Future Wave 6+ can add STATA do-files for these as cross-validation.

**Q4 — SC2.5 wealth proxy: total assets, 2018 land area, or composite net-worth index?** **Composite net-worth index** (자산총액 + 농가부채자산 − 부채총액) derived from FHES Wave 1 농가부채 + 농가수지 files. Most theoretically defensible (Carter-Olinto wealth-bias chain is about NET wealth, not gross assets or land area). Requires loading additional raw CSVs in `scripts/R/10_alpha3_estimation.R` if not already in `clean.rds`. Adds ~15 min to Phase 2 implementation. Document the wealth-proxy construction in §B.1 SC2.5 footnote with explicit formula.

**Q5 — Figures placement:** Main text §5 includes `fig_f1_fourbin_gradient_T2_en.{pdf}`; HonestDiD sensitivity plot in §7 robustness (still STUB, but figure can land there now).

**Q6 — paper/ko sync?** **Defer.** Wave 5 is paper/en canonical; paper/ko re-sync is a separate post-Wave-5 task per CLAUDE.md "Never simultaneous bilingual edits" rule.

---

## Verification (end-to-end)

1. **Script execution:** `Rscript scripts/R/10_alpha3_estimation.R` exits 0; `alpha3_results.rds` + 2 figures + 2 tex tables produced.
2. **R cross-check:** all α3 cells overlapping with existing P3b-2 / STATA estimates PASS ±0.01 / ±0.05 tolerance (logged in `replication_check.txt`).
3. **HonestDiD bounds:** β_1 and β_3 sensitivity bounds delivered; M̄* (breakdown M̄) reported.
4. **Compile:** main.tex 23±1 p (was 22 p; +1 from §5 prose expansion); online_appendix.tex 9 p (was 9 p; SC2.5 + B.3 cells inline, no page growth expected).
5. **quality_score.py main.tex:** ≥ 90 (expect ~92–95 with §5 prose + L186 boxed-eq still flagging).
6. **paper/ko 0-diff** vs main.
7. **Magnitude consistency check:** all abstract / §3.4 / §B.3 / §5 numbers match `alpha3_results` mega-file.

---

## Out of scope (deferred to post-Wave-5)

- **paper/ko re-sync** — per CLAUDE.md bilingual rule, single-language passes only.
- **§4 full build-out** — variable construction, sample restrictions, descriptive statistics beyond W5-7. Wave 6+ task.
- **§6 + §7 + §8 + §9 STUB → prose** — Identification Strategy detail, full Robustness section, Discussion, Conclusion. Wave 6+.
- **L186 eq:CO-1 boxed-form line-length polish** — pre-submission proof-reading pass.
- **8 `% VERIFY-PRE-SUBMIT` bib metadata audit** — pre-submission proof-reading pass.
- **STATA cross-check on new W5-3/W5-5/W5-6 cells** — Wave 6+ option.
- **2nd 7-pass-review confirmation run** — optional pre-submission audit.

---

## Expected post-Wave-5 status

| Metric | Pre-Wave-5 | Post-Wave-5 | Δ |
|---|---|---|---|
| 7-pass composite | ≈9.0–9.2 / 10 | **≈9.3–9.5 / 10** | +0.3 |
| quality_score.py | 90 / 100 | **92–95 / 100** | +2–5 |
| CRITICAL closed | 11 of 14 | **14 of 14** | +3 (Lens 3 M3 HonestDiD, Lens 5 M1 take-up, Lens 5 M3 multiple-testing) |
| AJAE submission gate | CROSSED | **CROSSED + headline rejection RESTORED** (if F1 not-fired) | excellence threshold approached |
| Paper §5 status | STUB | **REAL PROSE** | major deliverable |

Wave 5 is the **final pre-submission analytical pass**. After Wave 5 merge, the next session focuses on Wave 6+ (§4/6/7/8/9 STUB → prose, paper/ko re-sync, 2nd 7-pass-review).
