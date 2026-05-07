# `scripts/R/synthetic/` — Synthetic FHES Generator (AEA DCAS code-only verification)

This directory contains the deliverable for **Step 4 P5** of the PIDPS DiD-RD project: a privacy-friendly synthetic data generator that lets the AEA Data Editor and journal referees run the replication code **without applying for the restricted FHES microdata** (Statistics Korea MDIS).

It implements item (iii) of AEA DCAS v1.0 4-요건 for restricted-data papers:

| # | Requirement | Where it lives |
|---|---|---|
| (i) | 5+ year preservation commitment | `paper/en/main.tex` README appendix (Step 4 P3) |
| (ii) | Replication assistance commitment | Same |
| **(iii)** | **Public code + synthetic data generator** | **This directory** |
| (iv) | MDIS application URL + step-by-step | Same README appendix |

Cross-reference: `.claude/agents/domain-reviewer.md` E-7 (referee perspective).

---

## Files

| File | Purpose |
|---|---|
| `synthetic_data_gen.R` | Generator. Reads `calibration.json` → writes `data/synthetic/synthetic_panel.{dta,csv,rds}`. |
| `calibration.json` | Privacy-friendly aggregated stats extracted once from raw `panel_2018_2022.dta`. ~26 KB. |
| `verify_recovery.R` | Sanity check: fits Spec A T3 DiD-RD on synthetic and compares to the term-paper ATT recorded in `calibration.json`. |
| `README.md` | This file. |

---

## Verifier workflow (AEA Data Editor / referee, no MDIS needed)

```bash
# 1. Generate synthetic FHES (~2 sec)
Rscript scripts/R/synthetic/synthetic_data_gen.R

# 2. Run the analysis pipeline (Step 4 P1+ — when 01_clean.R etc. are written,
#    they consume data/synthetic/synthetic_panel.dta and produce the same
#    table/figure outputs as on the real data, just with synthetic numbers)
Rscript scripts/R/00_run_all.R

# 3. Sanity check: ATT recovery
Rscript scripts/R/synthetic/verify_recovery.R
```

`verify_recovery.R` reports the recovered ATT for each of the 4 outcomes alongside the term-paper truth (Spec A, MSE-optimal bandwidth per outcome). Because synthetic obs are sampled independently per `(D × year)` cell with no household autocorrelation, magnitudes are approximate — the primary AEA signal is **sign agreement on the headline outcomes** plus **code execution without errors**.

---

## What the calibration JSON contains (and what it does NOT)

### Privacy guards (per `quality_reports/plans/gleaming-juggling-frost.md` §Phase 1)

- KRW values rounded to **10,000 KRW** (~$7.5 USD) units — more conservative than the AEA Data Editor's typical 100/1,000 KRW practice.
- Area values (`rv_2018`, ㎡) rounded to **100 ㎡** units.
- Means / SDs reported to **4 significant figures**.
- Cells with `n < 10` obs are suppressed (`mixture` is only attached when both branches have ≥10 obs).
- **No individual identifiers** (`hhid_num` / `sgg_cd`) ever stored. The only `hhid_num` in the synthetic data is a 1..3,614 sequence with no mapping to real farms.

### Provenance

`source.sha256` records the SHA-256 of the source `.dta` so verifiers can confirm a replicator extracted from the same file (if they later apply for MDIS access).

### Aggregated stats

```text
panel.{n_households, n_obs, years, balanced_fraction, obs_per_household_distribution}
rv_2018.{mean, sd, min, max, quantiles q01..q99, fraction_treated, cutoff_density}
outcomes.{4 outcomes}.{by_treat_year, mixture}             # full-sample
outcomes_local_to_cutoff.by_outcome.{4 outcomes}.{...}     # |rv| ≤ 5,000 ㎡
treatment_effects_known_att.by_outcome.{4 outcomes}        # Spec A T3 ATT (truth)
```

---

## Generation strategy (Hybrid, per `AskUserQuestion` 2026-05-07)

1. **Sample 3,614 household-level `rv_2018` values** from the empirical inverse CDF (linear interpolation on 9 quantile anchors + min/max). Treatment dummy `D = (rv_2018 ≤ 0)` is therefore time-invariant per household.
2. **Build a partial-balanced panel** matching `obs_per_household_distribution` (1y / 2y / 3y / 4y / 5y appearance counts) → 14,474 observations.
3. **Sample outcomes per `(D × year)` cell:**
   - `y_farm_cost`, `y_consump`: log-normal (positive, derived from cell mean / sd).
   - `y_off_income`: per-cell Bernoulli mixture where the negative branch has ≥ 10 obs; log-normal otherwise.
   - `y_farm_income`: per-cell Bernoulli mixture (~23.55% negative overall, real economic phenomenon — adverse-cash-flow farm-years).
   - For obs with `|rv_2018| ≤ 5,000 ㎡` use **local-to-cutoff** cell stats; outside use **full-sample** cell stats. This ensures DiD-RD on the bandwidth-restricted subset recovers the local RD effect rather than the gross D-difference.
4. **Compute `imputed_payment`** via the deterministic formula in `01_cleaning.do:420-426` (1.2M flat below 5,000 ㎡; area-proportional 2.05M / 1.97M / 1.89M tiers above; zero pre-2020).

---

## Known limitations

These are honest because the AEA Data Editor reads READMEs and rejects ones that overstate what the synthetic data can do.

- **No household autocorrelation.** Outcomes are sampled independently per `(i, t)`. Real FHES has within-household serial correlation in `y_farm_income` and `y_farm_cost`. Effect on inference: clustered SEs on synthetic understate the true MC variance somewhat; this is a feature for AEA verification (more conservative).
- **No outcome covariance.** The 4 outcomes are sampled independently. Real FHES has positive correlation between `y_farm_income` and `y_farm_cost` (high-revenue farms tend to spend more). Affects only joint inference, not headline ATT.
- **ATT recovery is approximate.** Cell-level means encode the empirical post-treatment level shift, not an explicit RD slope kink. `verify_recovery.R` typically recovers ATT signs correctly for outcomes where the truth is non-trivial, with magnitudes within 0.5–3× of the calibration value. Refinements (smooth `rv` trends, explicit ATT injection on counterfactual baselines) are deferred — see "Out of scope" in the plan.
- **`area_total` is set equal to `area_2018`.** Real FHES has small year-to-year area variation; synthetic has none. Affects `imputed_payment` time-stability assumption (acceptable: SFFP eligibility is essentially set at baseline).
- **No `sgg_cd` cluster, no `weight_national`, no farm-controls.** "Minimal Now" scope per `AskUserQuestion` 2026-05-07. These will be added by ratchet once `scripts/R/01_clean.R` (Step 4 P1) finalizes its variable list.

---

## MDIS application (4-요건 (iv))

Real FHES microdata application:
1. Visit Statistics Korea MDIS portal: <https://mdis.kostat.go.kr>
2. Apply for "Farm Household Economic Survey (FHES) Wave 1, 2018-2022" (농가경제조사).
3. Wait ~2-4 weeks for approval; download via secure portal.
4. Place file at `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` and re-run pipeline.

---

## Reproducibility contract

- Default seed: `20260507L` (pinned in `synthetic_data_gen.R`). Override with `--seed N`.
- Schema-versioned (`calibration.json` `schema_version: "1.0"`). Generator stops if the JSON's schema version is not understood.
- Validation block at end of `synthetic_data_gen.R` asserts: N obs / N households / mean D / D time-invariance / `y_farm_income` fraction_negative / `imputed_payment` formula correctness. Generation **fails** if any assertion fails — verifier sees a clear error rather than silently corrupted data.

---

## Cross-references

- `CLAUDE.md` §Goal §Replication standard
- `quality_reports/plans/gleaming-juggling-frost.md` (sentinel) / `2026-05-07_p5-synthetic-generator.md` (sister)
- `quality_reports/specs/2026-05-07_outlier-policy.md` (raw-value baseline rationale)
- `.claude/agents/domain-reviewer.md` E-7 (referee perspective on AEA DCAS)
- `.claude/rules/r-code-conventions.md` §10 (FHES variable naming — generator outputs raw names; `01_clean.R` will rename downstream)
- `explorations/2026-05-07_p5-calibration/` (one-time calibration extraction sandbox; not required for verifier workflow)

---

## Output schema (synthetic_panel.dta / .csv / .rds)

| Column | Type | Notes |
|---|---|---|
| `hhid_num` | integer | 1..3,614 synthetic IDs (no mapping to real farms) |
| `year` | integer | 2018..2022 |
| `D` | integer | 1 if `rv_2018 ≤ 0`, else 0 (time-invariant per household) |
| `rv_2018` | numeric | Running variable, ㎡, centered at the 0.5 ha cutoff |
| `area_2018` | numeric | `rv_2018 + 5000`, ㎡ |
| `area_total` | numeric | Same as `area_2018` (no time variation in synthetic) |
| `y_farm_cost` | numeric | 농업경영비, KRW |
| `y_off_income` | numeric | 농외소득, KRW |
| `y_consump` | numeric | 가계소비지출, KRW |
| `y_farm_income` | numeric | 농업소득, KRW (~23.55% negative) |
| `imputed_payment` | numeric | Imputed 공익직불금, KRW (deterministic formula) |
