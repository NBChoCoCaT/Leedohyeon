# Plan — Step 4 P3a (Tier 1 mandatory): `04_robust.R` + `05_figures.R`

## Context

P2 (commit `32fb15f` + merge `e7f0fb5`, replication 8/8 PASS) produced the headline DiD-RD main estimation but explicitly deferred 5 items to P3:
- Wild cluster bootstrap (sandwich × fixest incompatibility, see MEMORY `[LEARN:env]` 2026-05-14)
- Romano-Wolf multi-testing
- Outlier robustness ladder (16 derived outcome columns in clean.rds unused)
- McCrary density test + RD scatter + event-study figures
- AJAE referee-mandatory diagnostics (per domain-reviewer.md Lens 5 E-7)

P3a covers **Tier 1 mandatory only** (6 items). Tier 2 (heterogeneity, Kirwan, area dynamics, IV) and Tier 3 (debt, exit prob) are separate plans (Task #14, #15), gated on Tier 1 results per user preference for incremental delivery.

**Two design-changing findings from Phase 1 exploration:**

1. **STATA `rwolf2` v1 failed** in term paper (`11_multiple_testing.log` lines 350–357). STATA itself fell back to **Wild cluster bootstrap + Holm stepdown** (`boottest` + `p.adjust(method="holm")`). This means the P3 "Romano-Wolf reproduction" item simplifies dramatically — we only need to (a) fix Wild bootstrap to actually compute (currently NA in P2's `main_results.rds`), and (b) apply Holm across the 4 outcomes. Holm is already coded in `03_did_rd.R` lines 392-402 from P2; the only missing piece is real Wild p-values to feed it.

2. **STATA outlier ladder uses BW_A from `02_analysis.do` Step 1** — bandwidths {500, 1000, 3300} not recomputed per transform. Translates to 4 outcomes × 3 bandwidths × 2 transforms (IHS, Winsor p1/p99) = **24 STATA-anchored cells** for tolerance verification. The PIDPS outlier-policy spec v1.1 adds Tier 3 (Winsor p0.5/p99.5, AJAE addition) — adds 12 more cells without STATA anchors (R-only).

## User decisions (P3 scope)

- **Phase 3a = Tier 1 only** (6 mandatory items). Tier 2/3 deferred (Tasks #14/#15).
- Wild bootstrap: try `fwildclusterboot` CRAN install first (R 4.5 binary may now be available); if fails, fall back to `lm()` + `factor(hh_id) + factor(year)` dummies + `sandwich::vcovBS.lm(type='wild')` (per `[LEARN:env]` 2026-05-14 documented workaround).
- "Romano-Wolf" = Wild bootstrap p-values + Holm stepdown (matches STATA fallback).
- Outlier ladder = 24 STATA-anchored cells + 12 R-only Tier 3 cells (Winsor 0.5/99.5).
- All figures use `theme_custom` per INV-12 (currently template-only in `r-code-conventions.md` §4; instantiate in `05_figures.R`).

## Lock notes — STATA ground truth (`06_robustness_aux.log`, `04_robustness.log`, `07_eventstudy.log`)

For P3a replication-protocol Phase 3 tolerance verification (same protocol as P2).

### Outlier ladder anchors (4 representative cells; full 24 via Phase 1 scan)

| Cell | Transform | Outcome | h | β | SE |
|---|---|---|---:|---:|---:|
| IHS y_farm_cost T1 | `asinh()` | y_farm_cost | 500 | −0.1071 | 0.1238 |
| IHS y_farm_cost T3 | `asinh()` | y_farm_cost | 3300 | 0.0518 | 0.0512 |
| Winsor y_farm_cost T1 | p1/p99 | y_farm_cost | 500 | −4,191,323 | 2,091,791 |
| Winsor y_farm_cost T3 | p1/p99 | y_farm_cost | 3300 | 242,386 | 1,359,933 |

Tolerance (replication-protocol Phase 3): IHS cells abs(diff) < 0.01 on `asinh()` scale (~1% relative); Winsor cells abs(diff) < 0.5 KRW estimate, < 100 KRW SE (matching P2 protocol).

### McCrary anchor (`04_robustness.log`)

```
Full sample (N=2823):  T-stat = 1.4495,  p-value (robust) = 0.1472
±500㎡ window (N=167): T-stat = -1.1280, p-value (robust) = 0.2593
```

→ No evidence of manipulation. P3 R must reproduce within 0.01 on T-stat.

### Event-study anchor (`07_eventstudy.log` lines 85-89, y_farm_cost only as sanity check)

```
T1 (h=500):  β_2018=-2,061K, β_2020=-4,691K, β_2021=-4,559K, β_2022=-2,381K   (base year 2019)
T3 (h=MSE):  β_2018=-1,108K, β_2020=  -961K, β_2021=-2,077K, β_2022=  -841K
```

Tolerance: < 0.5 KRW per coefficient.

### Wild bootstrap anchor (`11_multiple_testing.log` lines 211-222)

```
y_farm_cost:  T1 β=-4,180,142  p_wild=0.0180  p_holm=0.072
              T2 β=-3,348,456  p_wild=0.0611  p_holm=0.244
              T3 β=  250,859   p_wild=0.8669  p_holm=1.000
y_consump:    T1 β= 3,702,711  p_wild=0.0681
              T2 β= 2,094,707  p_wild=0.1982
              T3 β= 1,254,742  p_wild=0.1201
```

Tolerance: Wild bootstrap is stochastic — p_wild ± 0.005 across reps (per `quality-gates.md` Tolerance Thresholds, B=9999 seed-pinned). Match within 0.01 acceptable.

## Approach

### File 1: `scripts/R/04_robust.R` — REWRITE (~340 lines)

Currently a 28-line stub. New responsibilities:

**Phase 0** — library, seed inherit, guard (mirror `02_descriptive.R`/`03_did_rd.R` pattern).

**Phase 1 — Install / detect `rddensity` + `fwildclusterboot`**
- `_setup_packages.R` already runs; add `rddensity`, `fwildclusterboot`, `wildrwolf` to required vector.
- Wrap `fwildclusterboot` import in `tryCatch`. On import failure, set flag `USE_FWB <- FALSE` and dispatch to `lm()`-fallback path for Wild bootstrap.

**Phase 2 — McCrary density test (Tier 1 item 1)**
- `rddensity::rddensity(rv_2018_baseline, c=0)` on year=2018 cross-section (2,823 farms, deduplicated).
- Extract T-stat + p-value; write to `mccrary_test.rds` and append to `replication_check.txt`.
- Per-bandwidth subsets (±500, ±1000, ±3300) per STATA `04_robustness.do` lines 61-67.

**Phase 3 — Wild cluster bootstrap (Tier 1 items 4+5: bootstrap + RW-via-Holm)**
- Reuse the 32-fit spec tibble from `03_did_rd.R` (load via `readRDS("main_results.rds")$specs`).
- **Path A (preferred):** `fwildclusterboot::boottest(fit, param="D_Post", clustid=~hh_id, B=9999, seed=PROJECT_SEED)`. Returns p-value directly.
- **Path B (fallback):** Refit each cell as `lm(y ~ D_Post + rv_Post + Drv_Post + factor(hh_id) + factor(year), data=sub)`; then `sandwich::vcovBS(lm_fit, cluster=sub$hh_id, type="wild", R=9999)` → extract SE → t-stat → p-value. Performance: 5-10 min for 32 fits (per Phase 1 R-side scan).
- Apply Holm stepdown across the 4 outcomes per (design, spec, bw_id) cell — same code as P2 (already in main_results.rds `p_cluster_holm`).
- Update `main_results.rds` with `p_wild_holm` populated. Add per-cell `p_wild` to `replication_check.txt`.
- Tolerance check: P2 replication 8 cells already pass on `se_cluster`; now add Wild p-value match (±0.01 vs STATA `11_multiple_testing.log` lines 211-222).

**Phase 4 — Outlier ladder (Tier 1 item 6)**
- Reuse 12 outlier columns in `clean.rds` (`ihs_*`, `*_w99`, `*_w995` from `01_clean.R` Phase 4).
- 4 outcomes × 3 bandwidths × 4 transforms (raw / IHS / w99 / w995) × 2 specs = **96 fits**.
- Of which 4 × 3 × 2 (IHS + w99) × 1 (Spec A) = **24 STATA-anchored** (replication tolerance check).
- Remaining 72 fits: AJAE-additional robustness, R-only (no STATA anchor; report side-by-side).
- Use identical feols spec from P2 (`<y> ~ D_Post + rv_Post + Drv_Post | hh_id + year, cluster=~hh_id`).
- Bandwidth set: STATA uses {500, 1000, 3300} for outlier ladder (fixed across outcomes — per Phase 1 finding). Use these three for replication; add Spec A T3 per-outcome MSE for AJAE main text where outlier matters.
- Wild bootstrap on each ladder cell (extends Phase 3 from 32 → 32+96=128 fits if all-cell Wild needed; expected 8-15 min via `lm()`-fallback).
- Output: `rob_results.rds` (list of fits per design × spec × bw × transform × outcome), `tab_rob_outlier_{en,ko}.tex` (compact 4-table layout per outcome), append-to-`replication_check.txt` (24 IHS+Winsor cells).

**Phase 5 — Save**
- `mccrary_test.rds`, `rob_results.rds`, `tab_rob_outlier_{en,ko}.tex`, updated `main_results.rds` (with Wild p-values).
- Append to `replication_check.txt`: 8 main cells (P2) + ~16 outlier cells (P3a) + 2 McCrary cells = 26 total. Target: 26/26 PASS.

### File 2: `scripts/R/05_figures.R` — REWRITE (~280 lines)

Currently a 24-line stub.

**Phase 0** — library + seed + guard. Define **`theme_pidps_custom()`** per `r-code-conventions.md` §4 template:
```r
theme_pidps_custom <- function() {
  theme_minimal(base_size = 11, base_family = "sans") %+replace%
    theme(
      plot.title    = element_text(color = "#0E4D92", face = "bold", size = 12),  # primary_blue
      plot.subtitle = element_text(color = "#6E6E6E", size = 10),                  # accent_gray
      panel.grid.minor = element_blank(),
      legend.position  = "bottom",
      plot.background  = element_rect(fill = "white", color = NA)
    )
}
```

**Phase 1 — RD scatter (Tier 1 item 2): 8 PDFs**
- 4 outcomes × 2 specs (A: 2020-Post, B: 2021-Post). Match STATA `02_analysis.do` lines 130-140 `rdplot` outputs.
- Construct first-difference d_y per household (mirror `03_did_rd.R` Phase 1 `compute_fd()`).
- Use `rdrobust::rdplot(y=d_y, x=rv_2018, c=0, p=1, ...)` to generate ggplot output, then layer `theme_pidps_custom()`.
- Files: `fig_rd_<outcome>_spec_{A,B}.pdf` + `.png` (per §13: PDF cairo + PNG transparent).
- Titles + axis labels per STATA verbatim (Korean for `paper/ko/`; produce English mirror).

**Phase 2 — Event-study (Tier 1 item 3): 12 PDFs**
- Per STATA `07_eventstudy.do` lines 92-101: 4 outcomes × 3 tiers (T1/T2/T3).
- Spec: `feols(<y> ~ i(year, D_treat, ref=2019) | hh_id + year, cluster=~hh_id)` with sample restriction `abs(rv_2018) <= h_tier`.
- Plot via `fixest::iplot(fit)` + custom layers (red dashed zero line, gray vertical at 2020 policy effective).
- Confidence bands: 95% from cluster-robust SE (Wild bootstrap version optional, time-permitting).
- Files: `fig_event_study_<outcome>_T{1,2,3}.pdf` + `.png`.

**Phase 3 — McCrary density (Tier 1 item 1, visual): 2 PDFs**
- Reuse `mccrary_test.rds` from `04_robust.R`.
- `rddensity::rdplotdensity(rdd_obj, X)` → ggplot.
- Layered with theme + manipulation-test caption.
- Files: `fig_mccrary_density_full.pdf` + `fig_mccrary_density_pm500.pdf`.

**Phase 4 — Save + summary message**
- Total: 8 (RD scatter) + 12 (event-study) + 2 (McCrary) = **22 figure files × 2 formats = 44 files** in `_outputs/`.

### Auxiliary edit: `scripts/R/_setup_packages.R` (+3 packages)

Add to `required` vector: `rddensity`, `fwildclusterboot`, `wildrwolf`. Idempotent.

## Files to modify

| Path | Action | Approx lines |
|---|---|---|
| `scripts/R/_setup_packages.R` | EDIT (add 3 packages) | +3 |
| `scripts/R/04_robust.R` | REWRITE (stub → full) | ~340 |
| `scripts/R/05_figures.R` | REWRITE (stub → full) | ~280 |
| `quality_reports/plans/2026-05-15_p3a-tier1-robust-figures.md` | CREATE (sister of harness sentinel) | identical content |
| `quality_reports/session_logs/2026-05-15_p3a-tier1.md` | CREATE (per session-logging.md) | grows during impl |

Plus runtime outputs (gitignored):
- `_outputs/mccrary_test.rds`, `rob_results.rds`
- `_outputs/main_results.rds` UPDATED (Wild p-values populated)
- `_outputs/tab_rob_outlier_{en,ko}.tex`
- `_outputs/replication_check.txt` UPDATED (8 → ~26 cells)
- `_outputs/fig_rd_<o>_spec_{A,B}.{pdf,png}` (16 files)
- `_outputs/fig_event_study_<o>_T{1,2,3}.{pdf,png}` (24 files)
- `_outputs/fig_mccrary_density_{full,pm500}.{pdf,png}` (4 files)

## Critical reference files (read-only during implementation)

- `scripts/R/_outputs/clean.rds` (16 outcome cols)
- `scripts/R/_outputs/main_results.rds` (P2 32-fit specs to reuse)
- `master_supporting_docs/own_drafts/stata_analysis/06_robustness_aux.do` + `.log` (24 outlier ladder cells)
- `master_supporting_docs/own_drafts/stata_analysis/04_robustness.do` + `.log` (McCrary T-stats)
- `master_supporting_docs/own_drafts/stata_analysis/07_eventstudy.do` + `.log` (12 event-study coefficient sets)
- `master_supporting_docs/own_drafts/stata_analysis/11_multiple_testing.log` (Wild bootstrap p-values per cell)
- `master_supporting_docs/own_drafts/stata_analysis/02_analysis.do` lines 130-140 (rdplot patterns)
- `.claude/rules/r-code-conventions.md` §4 (palette + theme_custom template), §13 (figure output convention)
- `.claude/rules/content-invariants.md` INV-11 (bg=transparent), INV-12 (project theme)
- `.claude/agents/domain-reviewer.md` Lens 1 B-6 (theoretical anchor), Lens 5 E-7 (referee defense)
- `quality_reports/specs/2026-05-07_outlier-policy.md` v1.1 (M2/M3/S2 cells)
- `MEMORY.md` `[LEARN:env]` 2026-05-14 (sandwich × fixest workaround), 2026-05-06 (gfortran)
- `MEMORY.md` `[LEARN:methods]` 2026-05-14 (`%8.0f` rounding, h_int ± 2 search)

## Verification

### Phase 1 — packages
```bash
Rscript scripts/R/_setup_packages.R
# Expect: All 18 packages load successfully (was 15, +rddensity +fwildclusterboot +wildrwolf).
# If fwildclusterboot OR wildrwolf fails: setup emits warning, NOT fatal; falls back to lm-with-dummies.
```

### Phase 2 — pipeline end-to-end
```bash
Rscript scripts/R/00_run_all.R
# Expected timing:
#   01_clean.R       -> 0.8s
#   02_descriptive.R -> 1.8s
#   03_did_rd.R      -> 1.3s
#   04_robust.R      -> 5-10 min (Wild bootstrap on 32+96=128 fits)
#   05_figures.R     -> 30-60s (44 file writes)
# Pipeline complete (no stub stop; P3a fills all 5 scripts).
```

### Phase 3 — replication tolerance (the hard gate)
```bash
cat scripts/R/_outputs/replication_check.txt
# Expect total: 8 (P2 main cells) + 24 (P3a outlier IHS+w99) + 2 (P3a McCrary) = 34 cells.
# Target: 34/34 PASS.
# Specifically:
#   8/8 main (P2)     — already passing
#   8/8 IHS Spec A    — new
#   8/8 Winsor99 A    — new
#   2/2 McCrary       — new
# Wild bootstrap p-values: ±0.01 vs 11_multiple_testing.log (stochastic tolerance per quality-gates §Tolerance B=9999).
```

### Phase 4 — figure visual audit (manual)
- Open 4 RD scatter PDFs (Spec A): jump at cutoff visible, fit line smooth?
- Open 4 event-study PDFs (T3 MSE): pre-period (2018) coefficient near zero (parallel trends)?
- Open `fig_mccrary_density_full.pdf`: density continuous at rv_2018 = 0?
- Theme consistency: all 22 figures use `theme_pidps_custom()` (primary blue title, white background, bottom legend).
- INV-11 compliance: all `.png` files have transparent backgrounds (check with `file <png>` or open in slide-compatible viewer).

### Phase 5 — quality-gate (per `quality-gates.md` R Scripts rubric)
- `04_robust.R` + `05_figures.R` both target ≥ 80. Known false-positive pattern: `quality_score.py` regex `["'][/\\]` triggers on LaTeX strings + `"\n"` — document override in commit body if encountered (per P2 precedent).

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| `fwildclusterboot` CRAN binary still requires gfortran on R 4.5 | Medium-High | Fallback to `lm()`-with-dummies route is documented in `[LEARN:env]` 2026-05-14; performance acceptable (5-10 min). |
| `rddensity` install fails | Low | Pure R, no compiled deps. Backup: hand-code McCrary via local linear regression (Cattaneo-Jansson-Ma 2020 §3 formulas). |
| IHS coefficient scale mismatch with STATA | Low | STATA uses `asinh()` natively; R `asinh()` is base R. Same function. Pre-computed in clean.rds Phase 4 verified. |
| Outlier ladder bandwidth interpretation drift | Medium | STATA uses BW_A from Step 1 (per-outcome h*[i]) — Phase 1 found `06_robustness_aux.do` reuses same bandwidths. Match P2's refined h*[i] via h_int ± 2 (already in `03_did_rd.R` `refine_h_to_stata_n()`). |
| Event-study base year ambiguity (2018 vs 2019) | Low | STATA `07_eventstudy.do` line 7-14 explicit: base = 2019, lags = 2018, leads = 2020-2022. |
| Wild bootstrap stochastic drift > tolerance | Low | Seed-pin at PROJECT_SEED=20260504. Both R and STATA use deterministic seeds; ±0.01 p-value MC noise per `quality-gates.md` §Tolerance. |
| `theme_pidps_custom` doesn't match institutional palette exactly | Low | Use exact hex from §4 (primary_blue=#0E4D92, accent_gray=#6E6E6E, etc.). Easy to override post-feedback. |
| 44 PNG files balloon repo / slow CI | None | All PNG/PDF gitignored (per `.gitignore` `scripts/R/_outputs/`). Regenerated on demand. |

## Approval gate

On ExitPlanMode approval:
1. Plan status DRAFT → APPROVED. Save **sister** to `quality_reports/plans/2026-05-15_p3a-tier1-robust-figures.md` with identical content (per `[LEARN:harness]` 2026-05-06).
2. Implement in order: `_setup_packages.R` edit → install run → `04_robust.R` Phases 0-5 → `05_figures.R` Phases 0-4 → full pipeline verification → tolerance check.
3. Iterate on `fwildclusterboot` install attempt; if it works (CRAN binary now ships for R 4.5), use Path A; else Path B `lm()`-fallback.
4. Update `quality_reports/session_logs/2026-05-15_p3a-tier1.md` incrementally per `session-logging.md`.
5. On 26/26 (or 34/34 if all IHS+Winsor cells succeed) replication PASS + all figures generated: present commit-ready summary; user invokes `/commit` (DO NOT auto-commit).
6. After commit + push: Phase 4 (P3a evaluation; Task #13) decides whether to proceed to Tier 2 (Task #14) immediately or pause for submission strategy reconsideration.
