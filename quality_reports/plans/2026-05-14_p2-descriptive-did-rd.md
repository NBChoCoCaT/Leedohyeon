# Plan — Step 4 P2: `02_descriptive.R` + `03_did_rd.R`

## Context

P1 (`01_clean.R`, commit `da192a8` merged via `1e278a5`) produced `scripts/R/_outputs/clean.rds` — a 14,474 × ~50 panel with `D_treat`, `Post`, `D_Post`, `rv_2018`, `rv_Post`, `Drv_Post`, 4 raw outcomes (`op_cost`, `off_farm_income`, `consumption`, `farm_income`) plus 12 outlier-policy derived outcomes (`ihs_*`, `*_w99`, `*_w995`), `actual_subsidy` (= raw `y_ag_subsidy_proxy` / FHES col #84), `imputed_payment`, `weight_national`, and demographics. P2 turns this into the headline empirical content for the AJAE / Food Policy / JAE submission.

P2 has two deliverables, both stubs that `stop()` today:

- **`02_descriptive.R`** — Table 1 (weighted descriptives), Balance Table (near-cutoff covariate balance for RD validity), and First-Stage Take-up paragraph supporting `[LEARN:methods]` #84 mandatory check.
- **`03_did_rd.R`** — DiD-RD main estimation. Two bandwidth designs in parallel: (1) **AJAE journal-grade** T1 ±500 ㎡ / T2 ±1,000 ㎡ / T3 MSE-optimal per outcome for Table 2 of the paper; (2) **Term-paper replication** with `hA_min` = min(MSE-optimal across 4 outcomes) — common bandwidth — to enable replication-protocol Phase 3 tolerance verification against `02_analysis.log`. Two specifications per design: **Spec A** (2018–2022 all, `Post = year ≥ 2020`) and **Spec B** (drop 2020, `Post = year ≥ 2021`, COVID-separated). Wild cluster bootstrap at `hh_id` via `sandwich::vcovBS` (`fwildclusterboot` deferred per `[LEARN:env]` 2026-05-06 gfortran issue). Holm step-down across the 4 primary outcomes.

User decisions confirmed via AskUserQuestion (2026-05-14 in-session): (Q1) **T1/T2/T3 + Spec A MSE-optimal `hA_min` parallel** for journal-grade + replication side by side; (Q2) **Spec B included in P2** (not deferred to P3). Outlier-ladder (ihs / w99 / w995) stays in P3 per outlier-policy spec v1.1 §M7.

## Lock notes — STATA ground truth captured from `02_analysis.log`

For replication-protocol Phase 3 tolerance (estimate < 0.01 abs diff, SE < 0.05 abs diff per `replication-protocol.md`). All coefficients are `D_Post` at `hA_min` common bandwidth, `reghdfe` with `absorb(hhid_num year) vce(cluster hhid_num)`.

**Spec A** (2018–2022, Post = year ≥ 2020) — `02_analysis.log` lines 394 / 442 / 490 / 538:

| Outcome (STATA name → R rename) | Estimate | SE | t | p |
|---|---:|---:|---:|---:|
| y_farm_income → farm_income | −3,584,777 | 2,368,291 | −1.51 | 0.130 |
| y_off_income → off_farm_income | 223,304.5 | 1,951,840 | 0.11 | 0.909 |
| y_consump → consumption | 1,254,742 | 789,824.3 | 1.59 | 0.112 |
| y_farm_cost → op_cost | 256,102.6 | 1,464,431 | 0.17 | 0.861 |

**Spec B** (2020 dropped, Post = year ≥ 2021) — lines 760 / 808 / 856 / 904:

| Outcome | Estimate | SE | t | p |
|---|---:|---:|---:|---:|
| farm_income | −3,906,468 | 2,713,951 | −1.44 | 0.150 |
| off_farm_income | 26,613.67 | 2,267,705 | 0.01 | 0.991 |
| consumption | 1,241,286 | 916,705.9 | 1.35 | 0.176 |
| op_cost | −34,428 | 1,862,314 | −0.02 | 0.985 |

`hA_min` numeric value to be captured at runtime from `rdrobust` MSE-optimal output (the STATA call: `rdrobust d_y rv_2018, c(0) p(1) bwselect(mserd) masspoints(off)`). First-difference cross-section `d_y_*` is constructed by STATA at line 119/199 only for the bandwidth-selection step; the regression itself uses the levels panel.

## Constraints

- **Cluster:** `hh_id` only (primary). `sgg_cd` deferred to AJAE post-submission per `LN-6` of the P1 plan (variable not in `.dta`).
- **Wild bootstrap:** `sandwich::vcovBS(model, cluster = ~hh_id, type = "wild", R = 9999)` seed-pinned via `PROJECT_SEED`. NOT `fwildclusterboot` (gfortran).
- **Multiple testing:** Holm step-down across the 4 primary outcomes per bandwidth-spec cell via `stats::p.adjust(p_vec, method = "holm")`. STATA term paper uses Romano-Wolf (`rwolf2`) — Holm is conservative-substitute; report both methods when feasible (Holm in main text, RW deferred to robustness P3).
- **Weights:** Solon–Haider–Wooldridge 2015 stage rule per `r-code-conventions.md` §6. Table 1 descriptives **weighted via `survey::svydesign(ids = ~hh_id, weights = ~weight_national)`**; main DiD-RD estimation **unweighted by default** (efficiency under correct spec). Weighted DiD-RD ladder deferred to P3 robustness.
- **Output convention:** `r-code-conventions.md` §13 — `tab_<topic>_{en,ko}.tex` via `modelsummary::modelsummary(... output = "latex")`; intermediate `*.rds` for downstream consumption.
- **Korean policy citation:** if any `.tex` output text references SFFP, PIDPS, statute article, etc., follow `quality-gates.md` Korean Policy Citation Accuracy contract (`policy-glossary-ko-en.md` is Step 5; P2 outputs are mostly numeric tables, so text leakage risk is low — only first-stage take-up paragraph carries policy claims).
- **Seed:** `PROJECT_SEED <- 20260504L` (set in `00_run_all.R`, shared via `pipeline_env`).
- **STATA → R math equivalence (LN-3 from P1):** baseline uses **no covariates** beyond `D_Post + rv_Post + Drv_Post + hh_id FE + year FE` per `02_analysis.do:264-275`. Demographics in `clean.rds` are preserved but NOT entered into the headline regression. Optional covariate-augmented spec for robustness in P3.

## Approach

### `scripts/R/02_descriptive.R` — REWRITE (~180 lines)

**Phase 0** — library, seed-inherit from pipeline env, guard:
- `library(dplyr, survey, modelsummary, fixest, sandwich, tibble, readr, here)`.
- Guard: `if (!exists("clean.rds", inherits = FALSE)) df <- readRDS(here("scripts","R","_outputs","clean.rds"))`. Pipeline-env-aware so direct invocation also works.

**Phase 1** — Table 1: weighted descriptives by treatment status:
- `svy <- survey::svydesign(ids = ~hh_id, weights = ~weight_national, data = df_pre2020)` where `df_pre2020 = df |> filter(year == 2018)` (one-row-per-farm at baseline). Rationale: Table 1 reports baseline characteristics, not post-policy panel means.
- Variables: `op_cost`, `off_farm_income`, `consumption`, `farm_income`, `area_2018`, `area_own`, `imputed_payment`, `age_code_base` (modal category), `sex_code`, `edu_code`, `type_fulltime`.
- Statistics: weighted mean + weighted SD (+ unweighted N) for treated (D=1) vs control (D=0), plus weighted difference + survey-weighted t-test p-value.
- Output: `tab_descriptives_en.tex` and `tab_descriptives_ko.tex` via `modelsummary::datasummary()` with column groupings.

**Phase 2** — Balance table near cutoff:
- Subset `df_balance <- df |> filter(year == 2018, abs(rv_2018) <= 1000)`.
- For each covariate above, two-sided unpaired test (treated vs control) on the unweighted subsample. `feols(covariate ~ D_treat, data = df_balance, cluster = ~hh_id)` for SE.
- Output: `tab_balance.tex`. Single language (Korean primary, English mirror sister-file).

**Phase 3** — First-stage take-up paragraph (data only; prose lives in `paper/en/`):
- Three regressions:
  1. `feols(actual_subsidy ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = df, cluster = ~hh_id)` — ITT first stage on actual subsidy received.
  2. `feols(imputed_payment ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = df, cluster = ~hh_id)` — formula-derived comparison.
  3. Take-up rate: `df |> filter(D_treat, year >= 2020) |> summarise(rate = mean(actual_subsidy > 0, na.rm = TRUE))`.
- Output: append rows to `tab_balance.tex` OR separate `tab_first_stage.tex`. Numeric block saved in `desc_summary.rds$first_stage`.

**Phase 4** — Save:
- `desc_summary.rds`: list of `list(table1, balance, first_stage)` fitted objects + N.
- Three `.tex` files. Korean labels preserved by reading `attr(df$op_cost, "label")` etc. via `coef_map` argument to `datasummary` / `modelsummary`.

### `scripts/R/03_did_rd.R` — REWRITE (~250 lines)

**Phase 0** — same library / seed / guard pattern as 02.

**Phase 1** — MSE-optimal bandwidth selection per outcome (mirror STATA `02_analysis.do:119`):
- For each outcome `y` ∈ {op_cost, off_farm_income, consumption, farm_income}: construct first-difference cross-section `d_y = y_post − y_pre` where `y_post = mean(y | year ≥ 2020)` and `y_pre = mean(y | year < 2020)` per household; then `rdrobust::rdbwselect(d_y, rv_2018_baseline, c = 0, p = 1, bwselect = "mserd", masspoints = "off")` to get `h*[outcome]`. Save `bw_table` (4 outcomes × {bw, N_left, N_right}).
- Repeat for Spec B (drop 2020 households; redefine post = year ≥ 2021).
- `hA_min <- min(bw_table_specA$h)`; `hB_min <- min(bw_table_specB$h)`.

**Phase 2** — Estimation matrix:

Build a tibble of specs to fit:

| design | spec | bandwidth | outcome (×4) |
|---|---|---|---|
| journal | A | T1=500 | (op_cost, off_farm_income, consumption, farm_income) |
| journal | A | T2=1000 | (×4) |
| journal | A | T3=h*[outcome] (per-outcome) | (×4) |
| journal | B | T1=500 | (×4) |
| journal | B | T2=1000 | (×4) |
| journal | B | T3=h*[outcome] | (×4) |
| replication | A | hA_min (common) | (×4) |
| replication | B | hB_min (common) | (×4) |

Total: 6 × 4 + 2 × 4 = **32 fits**. Estimator: `feols(<y> ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = subset, cluster = ~hh_id)` where `subset = df |> filter(abs(rv_2018) <= h)` (and additionally `year != 2020` for Spec B + redefined `D_Post = D_treat * (year >= 2021)`).

Use `purrr::pmap()` over the spec tibble; store fits as a list-column.

**Phase 3** — Wild cluster bootstrap:
- For each of the 32 fits: `wb <- sandwich::vcovBS(fit, cluster = ~hh_id, type = "wild", R = 9999)`. Extract `D_Post` SE + bootstrap p-value (two-sided, refit-method).
- Cache results in `main_results.rds` to avoid recomputing on each `Rscript` rerun.

**Phase 4** — Holm step-down per (design, spec, bandwidth) cell:
- 4 p-values per cell → `stats::p.adjust(p_vec, method = "holm")`. Annotate to table.

**Phase 5** — Replication-protocol Phase 3 tolerance check (replication cells only):
- For each of the 8 replication fits (2 specs × 4 outcomes), compare D_Post coefficient and SE against the lock-notes ground truth above. Use `abs(diff)` thresholds: estimate < 0.01 / SE < 0.05 (KRW scale — note these are absolute KRW differences, which is the right scale here since the ground-truth coefficients are 6–7 figure KRW values; effectively zero tolerance, meaning identical specification).
- Write `replication_check.txt`: PASS/FAIL per cell with computed diffs. If any FAIL, surface to stdout and write a CRITICAL line; do NOT stop the script (P3 audit will handle hard enforcement via `/audit-reproducibility`).

**Phase 6** — Tables:
- `tab_main_did_rd_en.tex` — 4-outcome × 3-bandwidth main table for Spec A (journal grade, AJAE Table 2). modelsummary stars from Wild bootstrap p-values + Holm adjusted.
- `tab_main_did_rd_ko.tex` — Korean mirror.
- `tab_specB.tex` — Spec B equivalent (robustness column in main text Table 2).
- `tab_replication_specA.tex` — STATA hA_min replication side-by-side. Two columns: STATA term paper vs R, per outcome. Display Estimate, SE, p in both.
- `main_results.rds` — list of (bw_table_specA, bw_table_specB, hA_min, hB_min, fits, vcov_wild, holm_p, replication_check).

### `scripts/R/_setup_packages.R` — EDIT

Add to `required` vector: `"survey"` (Solon–Haider–Wooldridge §6 weighted Table 1), `"purrr"` (pmap for 32-cell spec tibble). Idempotent.

### Notes on stubs not in scope

- `04_robust.R` (P3): outlier ladder, sgg_cd cluster, heterogeneity 5×4, weighted DiD-RD robustness, Romano-Wolf reproduction.
- `05_figures.R` (P3): RD scatter, McCrary density, event-study plot.

## Files to modify

| Path | Action | Approx lines |
|---|---|---|
| `scripts/R/02_descriptive.R` | REWRITE (stub → full) | ~180 |
| `scripts/R/03_did_rd.R` | REWRITE (stub → full) | ~250 |
| `scripts/R/_setup_packages.R` | EDIT (add 2 packages) | +2 |
| `scripts/R/_outputs/tab_descriptives_{en,ko}.tex` | CREATE (output) | n/a |
| `scripts/R/_outputs/tab_balance.tex` | CREATE (output) | n/a |
| `scripts/R/_outputs/tab_first_stage.tex` | CREATE (output) | n/a |
| `scripts/R/_outputs/desc_summary.rds` | CREATE (output) | n/a |
| `scripts/R/_outputs/main_results.rds` | CREATE (output) | n/a |
| `scripts/R/_outputs/tab_main_did_rd_{en,ko}.tex` | CREATE (output) | n/a |
| `scripts/R/_outputs/tab_specB.tex` | CREATE (output) | n/a |
| `scripts/R/_outputs/tab_replication_specA.tex` | CREATE (output) | n/a |
| `scripts/R/_outputs/replication_check.txt` | CREATE (output) | n/a |
| `quality_reports/plans/2026-05-14_p2-descriptive-did-rd.md` | CREATE (sister of harness sentinel) | identical content |
| `quality_reports/session_logs/2026-05-14_p2-descriptive-did-rd.md` | CREATE (incremental log per `session-logging.md`) | grows during impl |

## Critical reference files (read-only during implementation)

- `scripts/R/_outputs/clean.rds` (will exist post first `01_clean.R` run on this machine; schema known from `01_clean.R` source 75–157)
- `scripts/R/01_clean.R` lines 75–157 (rename map, derived columns — for column-name reference)
- `scripts/R/_outputs/var_dictionary.csv` (will exist post-run; KO ↔ EN lookup for `modelsummary` coef_map)
- `master_supporting_docs/own_drafts/stata_analysis/02_analysis.do` lines 101–275 (bandwidth + regression spec)
- `master_supporting_docs/own_drafts/stata_analysis/02_analysis.log` lines 394, 442, 490, 538 (Spec A D_Post coefs) and 760, 808, 856, 904 (Spec B D_Post coefs) — replication tolerance targets
- `.claude/rules/r-code-conventions.md` §6 (Solon–Haider–Wooldridge), §10 (renames already applied in clean.rds), §11 (cluster = hh_id), §12 (sessionInfo), §13 (output convention)
- `.claude/rules/replication-protocol.md` Phase 3 (tolerance contract)
- `.claude/rules/quality-gates.md` R Scripts rubric + Korean Policy Citation Accuracy (if first-stage para references PIDPS/SFFP)
- `quality_reports/plans/2026-05-07_p1-clean-r.md` (P1 plan — for design continuity)
- `MEMORY.md` [LEARN:methods] 2026-05-06 (variable mapping verified), 2026-05-07 (#84 first-stage mandatory), [LEARN:env] 2026-05-06 (sandwich::vcovBS fallback)

## Verification

### Phase 0 — packages
```bash
Rscript scripts/R/_setup_packages.R
# Expect: [setup] All 15 packages load successfully.  (was 13, +survey +purrr)
```

### Phase 1 — run P2 end-to-end
```bash
Rscript scripts/R/00_run_all.R
# Expect on this fresh machine:
#   01_clean.R -> ~3-8s (first run — produces clean.rds + var_dictionary.csv + clean_log.txt)
#   02_descriptive.R -> ~5-15s
#   03_did_rd.R -> ~60-180s (32 fits × 9999 Wild bootstrap reps; vcovBS dominates)
#   04_robust.R -> STUB (P3 boundary, expected halt)
```

### Phase 2 — output existence
```bash
ls scripts/R/_outputs/
# Expect: clean.rds, var_dictionary.csv, clean_log.txt, sessionInfo.txt,
#         desc_summary.rds, tab_descriptives_en.tex, tab_descriptives_ko.tex,
#         tab_balance.tex, tab_first_stage.tex,
#         main_results.rds, tab_main_did_rd_en.tex, tab_main_did_rd_ko.tex,
#         tab_specB.tex, tab_replication_specA.tex, replication_check.txt
```

### Phase 3 — replication tolerance (the hard gate)
```bash
cat scripts/R/_outputs/replication_check.txt
# Expect: 8/8 PASS for replication cells (Spec A × 4 + Spec B × 4).
#         Each row: D_Post est_R - est_STATA  AND  SE_R - SE_STATA, plus PASS/FAIL.
#         If any FAIL: investigate (likely culprits — feols vs reghdfe SE df-adjust,
#         the LEAR:env vcovBS R-level df-correction difference).
```

If Phase 3 fails: per `replication-protocol.md`, **do not proceed** — isolate which step introduces the difference (SE df-adjust, feols `vcov.fix = FALSE` flag, etc.) before considering the plan executed.

### Phase 4 — quality-gate
Apply `quality-gates.md` R Scripts rubric mentally: target score ≥ 80 (commit threshold). Critical risks: hardcoded paths (-20, mitigated by `here::here()`), missing seed (-10, mitigated by inherit from `00_run_all.R`), missing figure (-5, mitigated — figures are P3 not P2).

### Phase 5 — Korean Policy Citation Accuracy
Skip unless P2 tex output prose mentions SFFP / PIDPS / statute article. Default expectation: minimal text in tables.

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| `sandwich::vcovBS` SE differs materially from STATA cluster-robust SE | Medium | First fit unweighted Wild bootstrap; if SE diff > 0.05 vs STATA, check `fixest::vcov_cluster()` (no Wild but standard cluster) as intermediate sanity. fixest cluster-robust normally matches reghdfe to 4 decimals; Wild bootstrap should only add MC variance. |
| `rdrobust::rdbwselect` MSE-optimal differs from STATA `rdrobust` | Low (same package, ported) | Run on same first-difference y, same `p(1) bwselect("mserd") masspoints("off")` — should match within rounding. |
| `survey::svydesign` complains about FHES sampling structure (no strata var in clean.rds) | Medium | Use simple `ids = ~hh_id, weights = ~weight_national` design — close to FHES one-stage sampling with weights. If diagnostics flag concerns, document in session log and proceed (acceptable simplification per Solon-Haider-Wooldridge: weights matter more than design strata for descriptive purposes). |
| Wild bootstrap with R = 9999 too slow on macmini (multi-minute on 32 fits) | Medium | Profile first fit; if > 30s per fit, drop to R = 999 for development iterations + R = 9999 for final commit run. Time check inside script: `if (vcovBS_time > 30) message("...")`. |
| Spec B `D_Post` redefinition introduces bug if `D_Post` column is reused vs recomputed | Low | Recompute Spec-B `D_Post` inline: `D_treat * (year >= 2021)` — do NOT mutate clean.rds; use a temporary column inside the spec-B subset. |
| Holm vs Romano-Wolf inferential gap surfaces in referee review | Low | Document explicitly in `main_results.rds` notes: "Holm step-down conservative substitute for Romano-Wolf (STATA `rwolf2`, line 270); RW reproduction deferred to `04_robust.R`." |

## Approval gate

On ExitPlanMode approval:
1. Plan status DRAFT → APPROVED. Save **sister** to `quality_reports/plans/2026-05-14_p2-descriptive-did-rd.md` with **identical** content (per `[LEARN:harness]` 2026-05-06 — the harness sentinel at `~/.claude/plans/swift-tinkering-tulip.md` is primary; the sister is for searchability/indexing).
2. **Verify `clean.rds` exists on this machine before any `02_descriptive.R` work.** If not (P1 was developed on idoui-Macmini and outputs are gitignored), first run `Rscript scripts/R/_setup_packages.R` then `Rscript scripts/R/00_run_all.R` — the orchestrator will stop at the `02_descriptive.R` stub but produce `clean.rds`. Two-step bootstrap is the cleanest path.
3. Implement Phases 1–6 of `02_descriptive.R`, then `03_did_rd.R`. Incremental commits if intermediate milestones make sense; otherwise one feature branch + one commit per script.
4. Run Phase 1–3 verification. Surface any replication-tolerance FAIL to user immediately.
5. Update `quality_reports/session_logs/2026-05-14_p2-descriptive-did-rd.md` incrementally per `session-logging.md`.
6. On both scripts passing: present commit-ready summary; user invokes `/commit` (DO NOT auto-commit).
