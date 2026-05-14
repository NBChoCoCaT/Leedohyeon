# Plan — Step 4 P3b: CH4 Kirwan + own_share heterogeneity + (S,s) two-margin test

## Context

P3a (`4a03505`, 15/16 PASS) completed Tier 1 — McCrary density (exact match), outlier ladder, 66 figures. Pre-check (`explorations/2026-05-15_p3b-precheck/check.R`, 2026-05-15) confirmed:

- **CH4 viable**: 47.9% tenancy in treated group (484/1,010 farms), 56.5% near-cutoff. First-stage variation abundant.
- **CH3 cautious overall (Δ=−3.49pp) but viable in RD-bound (near-cutoff Δ=+0.7pp)** — identification clean for RD spec.
- **own_share bimodal** (52% pure owner + 12% pure tenant + 36% mixed) → strong 5-bin heterogeneity dimension.
- **rent_cost mean 4.3M KRW** among renters → measurable magnitude for capitalization test.

This unlocks a **JAE/AJAE-grade framing** — the original (S,s) single-anchor framing transitions to a **two-margin theoretical test**:

1. **Incidence margin (CH4):** does per-farm flat-rate (Korea SFFP) break the rent capitalization channel that EU per-hectare flat-rate amplifies (Ciaian et al. 2023 *Land Use Policy* 134: 46–55%) and that US per-hectare proportional captures (Kirwan 2009 *JPE* 117(1): ~25%)?
2. **Behavioral margin ((S,s) inaction):** does T/s_min ≈ 2.4% place the lump-sum deeply within the lumpy-investment inaction region, predicting β(op_cost_ex_rent) ≤ 0?

If both hold: Korea is the first OECD case to demonstrate per-farm flat-rate as a design that simultaneously (a) avoids landlord pass-through and (b) sits in the (S,s) inaction region for tenant farmers — distinct from both US and EU defaults. **Publishable AJAE/JAE contribution regardless of statistical significance level**, because the framing reverses the 2018+ EU literature's "flat-rate amplifies capitalization" prior.

## Scope (6 work items, ~13 hours)

Per user-supplied P3b spec (2026-05-15):

| Item | Description | Time | Priority |
|---|---|---|---|
| **P3b-1** | CH4 Kirwan/Ciaian decomposition (rent_cost + op_cost_ex_rent) | 2h | 1 |
| **P3b-2** | own_share × D_Post heterogeneity (5 bins × CH4) | 3h | 2 |
| **P3b-3** | CH3 RD-bound retention (exit_indicator + area_total event-study) | 2h | 3 |
| **P3b-4** | 5×4 demographic heterogeneity | 3h | 4 |
| **P3b-5** | First-stage IV (LATE direct estimate) | 2h | 5 |
| **P3b-6** | Wild bootstrap (post-headline result confirmation) | 1h | 6 |

**Out of scope (P3c or deferred):** `debt_total`, `farm_type` 작목 전환, Korean PDF via `showtext`, IHS/w99 robustness ladder extensions (P3a완료).

## Lock notes (pre-check confirmed)

- **LN-1:** Treated tenancy = 47.9% (484/1,010); near-cutoff (|rv_2018|≤1000) treated = 56.5%. CH4 first-stage variation abundant.
- **LN-2:** own_share bimodal: pure owner 52.1% (526) + pure tenant 11.9% (120) + mixed 36.0% (364) — 5-bin partition viable.
- **LN-3:** rent_cost mean = 433K KRW per treated renter (median 0, max 60M — right-skewed). Use raw + asinh log transforms in robustness.
- **LN-4:** Near-cutoff attrition: treated 81.5% vs control 80.8% (Δ=+0.7pp < 2pp threshold) — RD spec clean for CH3.
- **LN-5:** Ciaian, Espinosa, Gomez y Paloma & Heckelei (2023) *Land Use Policy* 134 — EU per-hectare flat-rate: 46% short-run, 55% long-run capitalization. **Inverts the original "flat-rate avoids capitalization" prior.** Korean per-farm flat-rate is the third design unique to this paper.
- **LN-6:** Kirwan (2009) *JPE* 117(1) (note: JPE not AER per lit-review correction) — US per-hectare proportional: ~25% capitalization. Baseline comparison.
- **LN-7:** B-6 (S,s) prediction: T/s_min ≈ 2.4% → inaction region → β(op_cost_ex_rent) ≤ 0. P2/P3a outlier ladder confirms negative sign for `op_cost` (raw); P3b isolates rent-net component.

## Scenario matrix (P3b-1 deliverable shape)

| `rent_cost` β | `op_cost_ex_rent` β | Interpretation | Best venue |
|---|---|---|---|
| ≈ 0 | < 0 | **⭐ Best case** — Korea breaks both EU/US capitalization AND (S,s) inaction confirms behavioral channel | **AJAE / JAE** |
| > 0 | < 0 | Partial capitalize + residual (S,s) inaction | JAE / Food Policy |
| ≈ 0 | ≈ 0 | Underpowered null on both | KR journal + thesis |
| > 0 | ≈ 0 | Full capitalize (reproduces Ciaian EU pattern) — Korea ≡ EU | ERAE (external validity) |

→ P3b-1 result determines submission strategy direction. Phase 4 evaluation (Task #13) gates on this.

## Approach — file structure

P3b adds **3 new scripts** + **2 file extensions**, extending the pipeline from 5 → 8 scripts:

```
scripts/R/
├── 01_clean.R          (P1, existing)
├── 02_descriptive.R    (P2, existing)
├── 03_did_rd.R         (P2, existing)
├── 04_robust.R         (P3a, existing — extend for Wild bootstrap retry)
├── 05_figures.R        (P3a, existing — extend for channel/heterogeneity figures)
├── 06_channels.R       (P3b NEW — CH4 + CH3)
├── 07_heterogeneity.R  (P3b NEW — own_share × CH4 + 5×4 demographic)
└── 08_iv.R             (P3b NEW — first-stage IV / LATE)
```

`00_run_all.R` pipeline vector extends to 8 scripts.

### File 1: `scripts/R/06_channels.R` — NEW (~280 lines)

**Phase 0:** library + seed + guard.

**Phase 1 — CH4 Kirwan/Ciaian rent decomposition (P3b-1):**
- Reuse `03_did_rd.R` spec tibble (32 fits for journal-grade T1/T2/T3 × A/B); swap LHS:
  ```r
  feols(rent_cost ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = sub, cluster = ~hh_id)
  feols(op_cost_ex_rent ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = sub, cluster = ~hh_id)
  ```
- Pass-through rate: `β(rent_cost) / 1.2M_KRW` — direct comparison to Ciaian (46–55%) and Kirwan (~25%).
- 24 cells (2 outcomes × 3 bw × 2 specs × 2 outcomes); 32 with Spec A MSE-replication reference.
- Scenario matrix population: classify each (spec, bw) cell into 1 of 4 cases above.

**Phase 2 — CH3 retention (P3b-3):**
- Exit indicator constructed cross-sectional (per-farm):
  ```r
  exit_data <- df |> dplyr::group_by(hh_id) |>
    dplyr::summarise(exit = as.integer(dplyr::n_distinct(year) < 5L),
                     rv_2018 = dplyr::first(rv_2018),
                     D_treat = dplyr::first(D_treat))
  # RD on cross-section
  rdrobust::rdrobust(y = exit_data$exit, x = exit_data$rv_2018, c = 0, p = 1,
                     bwselect = "mserd", masspoints = "off")
  ```
- Area dynamics (event-study) for the panel:
  ```r
  feols(area_total ~ i(year, D_treat, ref = 2019) | hh_id + year, data = sub, cluster = ~hh_id)
  ```
- Three bandwidth subsets: T1/T2/T3.

**Phase 3 — Save:** `channels_results.rds`, `tab_ch4_rent_decomposition_{en,ko}.tex`, `tab_ch3_retention_{en,ko}.tex`, append to `replication_check.txt` (no STATA anchor for these — R-only, document as R-only cells).

### File 2: `scripts/R/07_heterogeneity.R` — NEW (~320 lines)

**Phase 0:** library + seed + guard.

**Phase 1 — own_share × CH4 (P3b-2):**
- Construct 5 bins per `LN-2`:
  ```r
  df$own_bin <- dplyr::case_when(
    own_share == 0   ~ "pure_tenant",
    own_share < 0.3  ~ "low_owner",
    own_share < 0.7  ~ "mixed",
    own_share < 1    ~ "high_owner",
    own_share == 1   ~ "pure_owner"
  )
  ```
- Interaction spec via fixest:
  ```r
  feols(rent_cost ~ i(own_bin, D_Post, ref = "pure_owner") + rv_Post + Drv_Post
        | hh_id + year, data = sub, cluster = ~hh_id)
  ```
- Predicted patterns:
  - **pure_owner**: rent_cost ≡ 0 (no rent to begin with); coefficient identifies if any phantom variation
  - **pure_tenant**: full capitalization exposure — largest |β(rent_cost)| if landlord pass-through
  - **mixed**: linear-in-share interpolation, monotone gradient expected
- 3 bandwidths × 2 outcomes × 5 bins = 30 interaction cells per outcome.

**Phase 2 — 5×4 demographic heterogeneity (P3b-4):**
- Dimensions: `type_fulltime` (3 levels), `age_code_base` (binarized 65+ cutoff), `sex_code` (2 levels), `edu_code` (4-group binning needed), `own_share` (5 bins — reuse from Phase 1).
- 4 P2 outcomes (op_cost, off_farm_income, consumption, farm_income).
- Spec: Spec A T3 (MSE-optimal) per cell to limit cell count.
- Total: 5 dim × 4 outcome = 20 interaction tables; emphasize:
  - `type_fulltime × op_cost` (전업농 (S,s) 강함)
  - `age_code_base × area_total` (고령농 축소)
  - `own_share × rent_cost` (covered in Phase 1; cross-reference)

**Phase 3 — Save:** `heterogeneity_results.rds`, `tab_het_own_share_ch4.tex`, `tab_het_demographic_{en,ko}.tex` (compact per-dimension format), heterogeneity coefficient plots (deferred to 05_figures.R extension).

### File 3: `scripts/R/08_iv.R` — NEW (~180 lines)

**Phase 0:** library + seed + guard.

**Phase 1 — First-stage IV / LATE (P3b-5):**
- 2SLS via fixest:
  ```r
  iv_fit <- fixest::feols(
    y_outcome ~ rv_Post + Drv_Post | hh_id + year | actual_subsidy ~ D_Post,
    data = sub, cluster = ~hh_id
  )
  # Extract: first-stage F-stat, IV (LATE) estimate, compare to ITT/take-up
  ```
- 4 outcomes × 3 bandwidths × 2 specs = 24 IV fits.
- Take-up rate confirmed = 92.3% (from P2 02_descriptive.R desc_summary.rds).
- LATE = ITT / 0.923 (mechanical scaling); first-stage F-stat for instrument strength.

**Phase 2 — Save:** `iv_results.rds`, `tab_iv_late_{en,ko}.tex` (4 outcomes × T3 spec, comparison: ITT vs LATE side-by-side).

### File 4: `scripts/R/04_robust.R` — EXTEND for Wild bootstrap (P3b-6)

Currently Wild bootstrap is gated by `if (USE_FWB)` and SKIPPED. Two attempts:

**Path A — fwildclusterboot via R-tools gfortran:**
- User-side prerequisite: install official `gfortran-12.2-universal.pkg` from mac.r-project.org/tools/ (one-time, ~10 min). After install, `install.packages("fwildclusterboot", repos = "https://cloud.r-project.org", type = "source")` should compile.
- If successful: Wild bootstrap p-values on 8 replication cells (matching STATA `11_multiple_testing.log` ±0.01) + 24 journal-grade cells.

**Path B — manual cluster-Rademacher refit (fallback):**
```r
wild_cluster_p <- function(fit, df, cluster_var, B = 999) {
  resid <- residuals(fit)
  clusters <- unique(df[[cluster_var]])
  t_boot <- numeric(B)
  for (b in seq_len(B)) {
    v <- sample(c(-1, 1), length(clusters), replace = TRUE)
    weights_vec <- v[match(df[[cluster_var]], clusters)]
    y_b <- predict(fit) + weights_vec * resid
    fit_b <- fixest::feols(update(formula(fit), y_b ~ .), data = df, cluster = ~hh_id)
    t_boot[b] <- coef(fit_b)["D_Post"] / sqrt(diag(vcov(fit_b)))["D_Post"]
  }
  t_obs <- coef(fit)["D_Post"] / sqrt(diag(vcov(fit)))["D_Post"]
  mean(abs(t_boot) >= abs(t_obs))
}
```
- B=999 × 8 cells × ~0.05s/refit ≈ 7 minutes. Feasible.
- Apply only to **headline cells** (8 replication + ~6 from P3b-1 CH4 main results) — NOT to 60+ heterogeneity cells (cluster-robust SE sufficient there).

### File 5: `scripts/R/05_figures.R` — EXTEND for channel/heterogeneity figures

Add **Phase 4 — CH4/CH3 channel figures (~10 new figures)**:
- `fig_ch4_rent_pass_through_{en,ko}.{pdf,png}` — bar chart: pass-through rate Korea (Spec A T3) vs EU Ciaian 46% vs US Kirwan 25%
- `fig_ch4_op_cost_decomposition_{en,ko}.{pdf,png}` — op_cost total / rent_cost / op_cost_ex_rent stacked bars per bandwidth
- `fig_own_share_heterogeneity_{en,ko}.{pdf,png}` — interaction coefficients by own_bin (5 levels) for rent_cost and op_cost_ex_rent
- `fig_ch3_area_event_study_{en,ko}.{pdf,png}` — year-by-year area_total coefficients
- `fig_ch3_exit_rd_{en,ko}.{pdf,png}` — exit_indicator RD scatter

20 new files (10 figures × 2 fmts). Total figure count: 66 (P3a) + 20 (P3b) = 86 files.

### Auxiliary edits

**`scripts/R/00_run_all.R`** — extend pipeline vector to 8 scripts:
```r
pipeline <- c("01_clean.R", "02_descriptive.R", "03_did_rd.R",
              "04_robust.R", "05_figures.R",
              "06_channels.R", "07_heterogeneity.R", "08_iv.R")
```

**`CLAUDE.md` "Identification Strategy" §Theory line** — extend B-6 framing to two-margin:
- Current (af22000): "(S,s) directional prediction … β(op_cost) ≤ 0"
- Update: "**Two-margin theory test**: (i) **Incidence margin (CH4)** — Korean per-farm flat-rate distinct from US per-hectare proportional (Kirwan 2009 JPE ~25% capitalize) and EU per-hectare flat-rate (Ciaian et al. 2023 *Land Use Policy* 46–55% capitalize) → predict β(rent_cost) ≈ 0; (ii) **Behavioral margin ((S,s))** — T/s_min ≈ 2.4% deeply within inaction region → β(op_cost_ex_rent) ≤ 0. Joint two-margin pattern is publishable JAE/AJAE contribution regardless of single-margin significance."

**`.claude/agents/domain-reviewer.md` Lens 1 B-6** — add Ciaian 2023 citation alongside Kirwan; refine prediction asymmetry note.

**`.claude/agents/domain-reviewer.md` Lens 5 E-7** — add CH4 incidence test to "AJAE referee 7-angle defense" as a new mitigated angle (the 8th angle, or refine existing).

These cross-reference edits are LOW-risk text additions and may be committed alongside P3b implementation (or separately for cleaner history). Recommendation: commit cross-refs first as docs(claude.md) + docs(domain-reviewer) immediately after P3b plan approval, then implement.

## Files to modify

| Path | Action | Approx lines |
|---|---|---|
| `scripts/R/06_channels.R` | **CREATE** | ~280 |
| `scripts/R/07_heterogeneity.R` | **CREATE** | ~320 |
| `scripts/R/08_iv.R` | **CREATE** | ~180 |
| `scripts/R/04_robust.R` | EDIT (Phase 3 Wild bootstrap retry) | ~60 lines changed |
| `scripts/R/05_figures.R` | EDIT (add Phase 4 channel/het figures) | ~150 lines added |
| `scripts/R/00_run_all.R` | EDIT (pipeline vector → 8 scripts) | 3 lines |
| `CLAUDE.md` | EDIT (Two-margin framing on §Theory line) | 1-2 lines |
| `.claude/agents/domain-reviewer.md` | EDIT (B-6 + E-7 Ciaian cross-ref) | ~10 lines |
| `quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md` | **CREATE** (sister) | identical content |
| `quality_reports/session_logs/2026-05-16_p3b.md` | **CREATE** (incremental log) | grows during impl |

## Critical reference files (read-only during implementation)

- `scripts/R/_outputs/clean.rds` — 16 outcome cols + `rent_cost`, `op_cost_ex_rent`, `area_total`, `own_share`, `area_own`, `area_rent`, `actual_subsidy`, demographics
- `scripts/R/_outputs/main_results.rds` (P2 32-fit specs to reuse for spec tibble)
- `scripts/R/_outputs/rob_results.rds` (P3a outlier ladder reference)
- `scripts/R/_outputs/desc_summary.rds` (P2 take-up rate 92.3% for IV LATE comparison)
- `explorations/2026-05-15_p3b-precheck/check.R` (pre-check confirming viability)
- `master_supporting_docs/own_drafts/stata_analysis/02_analysis.do` lines 130–140 (rdplot pattern for figures)
- `.claude/rules/r-code-conventions.md` §10 (rename map already applied), §11 (cluster = hh_id), §13 (figure output convention)
- `.claude/rules/replication-protocol.md` Phase 3 (no STATA anchors for CH4/CH3/IV — document as R-only)
- `.claude/agents/domain-reviewer.md` Lens 1 B-6, Lens 5 E-7 (theoretical anchor + referee defense to update)
- **External references (literature anchors):** Kirwan 2009 JPE 117(1); Ciaian et al. 2023 *Land Use Policy* 134; Caballero-Engel 1999 (S,s); Blundell-Pistaferri 2008 consumption smoothing
- `MEMORY.md` LEARN entries 2026-05-06 (gfortran), 2026-05-14 (sandwich × fixest, %8.0f rounding)

## Verification

### Phase 0 — Package availability
```bash
# Optional but encouraged: fwildclusterboot install attempt (Path A)
# User runs once outside Rscript:
#   1. Download gfortran-12.2-universal.pkg from https://mac.r-project.org/tools/
#   2. sudo installer -pkg gfortran-12.2-universal.pkg -target /
#   3. Rscript -e 'install.packages("fwildclusterboot", repos="https://cloud.r-project.org", type="source")'
# If fails, P3b-6 falls back to manual Rademacher (Path B).
```

### Phase 1 — Pipeline run
```bash
Rscript scripts/R/00_run_all.R
# Expected timing (extends P3a 13.75s baseline):
#   01–05 (existing) : ~13s
#   06_channels.R    : ~5s (24 + 16 fits, no bootstrap)
#   07_heterogeneity : ~15s (60+ interaction fits)
#   08_iv.R          : ~5s (24 IV fits)
#   Wild bootstrap   : +7 min if Path B active; +1 min if Path A
# Total: ~45s without Wild, ~7-8 min with Wild
```

### Phase 2 — Output existence (~30 new files)
```bash
ls scripts/R/_outputs/ | grep -E '^(channels|heterogeneity|iv|tab_ch4|tab_ch3|tab_het|tab_iv|fig_ch4|fig_ch3|fig_own_share)'
# Expect: channels_results.rds, heterogeneity_results.rds, iv_results.rds,
#         tab_ch4_rent_decomposition_{en,ko}.tex, tab_ch3_retention_{en,ko}.tex,
#         tab_het_own_share_ch4.tex, tab_het_demographic_{en,ko}.tex,
#         tab_iv_late_{en,ko}.tex,
#         fig_ch4_*, fig_ch3_*, fig_own_share_* (20 new files)
```

### Phase 3 — Scenario classification (the headline gate)
```bash
Rscript -e '
ch <- readRDS("scripts/R/_outputs/channels_results.rds")
# Pull Spec A T3 (MSE) cells for headline classification
spec_A_T3 <- ch$ch4_results |> dplyr::filter(spec == "A", bw_id == "T3")
print(spec_A_T3)
# Compute pass-through
spec_A_T3$pass_through_rate <- spec_A_T3$rent_cost_est / 1.2e6
'
```

Manually classify into 4-cell scenario matrix (best case / partial / null / Korea≡EU). Result determines Phase 4 (Task #13) submission strategy reading.

### Phase 4 — Quality gate
- `04_robust.R`, `05_figures.R`: existing 100/100 expected (no LaTeX strings changed; new lines are R code)
- `06_channels.R`, `07_heterogeneity.R`, `08_iv.R`: target ≥80; expect known LaTeX-string false-positive pattern (per P2/P3a precedent) — document override in commit if encountered.

### Phase 5 — Visual sanity check (figures)
- `fig_ch4_rent_pass_through_en.pdf` — Korea bar should be visibly lower than 46% (Ciaian EU) and 25% (Kirwan US) if best case
- `fig_own_share_heterogeneity_en.pdf` — pure_owner coefficient ≈ 0 (no rent to begin), pure_tenant largest, mixed monotone
- `fig_ch3_area_event_study_en.pdf` — pre-period (2018) coefficient ≈ 0 (parallel trends), 2020+ deviation visualized

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| `rent_cost` median = 0 (right-skewed) → CH4 estimation noisy | Medium | Use both raw and `asinh(rent_cost)` transforms (already in clean.rds as no — need to compute in 06_channels.R Phase 1). Report both in `tab_ch4`. |
| Pure owner own_bin coefficient identifies as numerical noise (no rent at all) | Low | Document explicitly in table footnote — "pure_owner reference category by construction; coefficient ≡ 0." Use as reference. |
| `area_total` event-study reveals pre-trend (parallel trends violation) | Medium | If 2018 coefficient ≠ 0 at 95%, report Roth-Rambachan 2024 sensitivity bounds; flag in `domain-reviewer.md` E-7 Lens 5 HIGH-risk slot. |
| Heterogeneity 60+ cells: tabulation explodes | Low | Compact per-dimension 4-table format (per P3a `tab_rob_outlier_*.tex` pattern). One .tex per dimension. |
| IV first-stage F < 10 (weak instrument) | Low | Take-up 92.3% suggests strong first-stage; verify with `fitstat(iv_fit, "ivf")`. If <10, IV results degraded but ITT still primary. |
| Wild bootstrap (P3b-6) infeasibility on all 60+ cells | High | Restrict Wild bootstrap to ~14 headline cells (8 replication + 6 CH4 main); cluster-robust SE sufficient for heterogeneity per Cameron-Miller (2015) practice. |
| Korean rent_cost variable encoding (해당 컬럼 단위/정의 모호) | Low | Verified in clean.rds via `attr(df$rent_cost, "label")` — STATA mapping confirmed in 01_cleaning.do (per P1 [LEARN:methods]). |
| gfortran install failure (Path A) | Medium | Path B manual Rademacher implemented as primary (Path A bonus only) — does NOT block P3b headline. |

## Approval gate

On ExitPlanMode approval:
1. Plan status DRAFT → APPROVED. Save **sister** to `quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md` (identical content per `[LEARN:harness]` 2026-05-06).
2. **Optional: commit cross-reference updates first** (`docs(claude.md): two-margin framing` + `docs(domain-reviewer): add Ciaian 2023 to B-6`) — small atomic commits before implementation. Or batch into P3b feature commit.
3. Implement in order P3b-1 → P3b-2 → P3b-3 → P3b-4 → P3b-5 → P3b-6. Each item is a logical milestone — incremental commits acceptable if needed.
4. After P3b-1 (~2h), pause and **classify Spec A T3 cells against the 4-scenario matrix** — this informs whether to continue full plan or pivot (e.g., if scenario = "Korea ≡ EU", reframe Phase 4 immediately).
5. Update `quality_reports/session_logs/2026-05-16_p3b.md` incrementally per `session-logging.md`.
6. Final pipeline run + verification + quality gate → present commit-ready summary; user invokes `/commit`.
7. After commit + push: Phase 4 (Task #13) submission strategy decision based on full P3b results (scenarios 1–4 + heterogeneity + IV LATE + Wild bootstrap status).
