# Plan — P3c Phase 1: Multi-Definition Exit DiD + Conditional Event-Study + Reconciliation

**Status:** APPROVED (Dohyeon, 2026-05-15)
**Date:** 2026-05-15 (Session 2 — resume after spec sign-off)
**Author:** Lee Dohyeon (Claude assist)
**Sister (post-approval):** `01_dissertation_PBDP/quality_reports/plans/2026-05-15_p3c-phase1-implementation.md`
**Mode:** manual approval, plan-first; user invokes `/commit` after implementation

---

## Context

Spec `2026-05-15_p3c-channel-4-5-decomposition.md` APPROVED 2026-05-15 (Plan A — Empirics-first, 10–12주, advisor consultation deferred to ~2026-07-24). This plan implements **Phase 1 (full estimation)** per spec §3.1 M1–M5 + §3.2 S1 (gated on scenario α). S2 (hazard) deferred to next session per user decision this session; Panel B formatting bug in existing `tab_ch3_retention_{en,ko}.tex` fixed inline per user decision.

**Goal:** Produce the empirical evidence that (a) classifies the data into Scenario α/β/γ, (b) reframes the existing P3b-1 `ch3_exit` β=+0.1517 with bandwidth-tier + DiD pre-trend control, (c) separates Channel 4(iii) extensive margin from Channel 5 exit selection via survival-conditional event-study, and (d) tests own_share heterogeneity (only if scenario α confirmed).

## Exploration findings (Phase 1 plan-mode, this session)

- `06_channels.R` Phase 2 (lines 191–266): existing exit_indicator (Def 1 baseline only, MSE bandwidth) + `ch3_area_events` event-study (unconditional). Phase 4 (lines 309–481) generates LaTeX via manual `sprintf()`.
- `07_heterogeneity.R` Phase 0 (lines 57–77): time-invariant `own_bin` constructed from 2018 baseline; 5-level factor with `pure_owner` reference; reusable via `dplyr::left_join`.
- Reusable code patterns: `rdrobust::rdrobust(y, x=rv_2018, c=0, p=1)`, `fixest::feols(y ~ i(year, D_treat, ref=2019) | hh_id + year, cluster=~hh_id)`, `fixest::i(own_bin, D_Post, ref="5_pure_owner")`, `purrr::pmap_dfr()` over expand_grid.
- `tab_ch3_retention_en.tex` Panel B bug confirmed: 12 values per row instead of 5 (loop concatenates 3 outcomes into single bw row). Fix scope: `06_channels.R` lines 366–409 `write_ch3_table()` Panel B reshape.
- `00_run_all.R` pipeline vector: `01..07, 09_wild_bootstrap` (slot 08 free → assign to P3c).

## Implementation: new `08_p3c_decomposition.R`

Following codebase conventions (numbered scripts, Phase 0/1/.../N internal structure, RDS + dual-language LaTeX tables). 9 phases, ~450 lines.

### File-by-file changes

| Path | Action | Lines | Purpose |
|---|---|---|---|
| `scripts/R/08_p3c_decomposition.R` | **CREATE** | ~450 | P3c Phase 1 implementation (M1+M2+M3+M4+M5+S1-conditional) |
| `scripts/R/06_channels.R` | EDIT (Panel B fix) | ~30 changed | Fix `write_ch3_table()` Panel B reshape (lines 366–409) |
| `scripts/R/00_run_all.R` | EDIT | 1 line | Add `"08_p3c_decomposition.R"` to pipeline vector after `07_heterogeneity.R` |
| `scripts/R/_outputs/p3c_results.rds` | CREATE (runtime) | data | RDS with 8 fields (see Phase 9) |
| `scripts/R/_outputs/tab_ch5_exit_definitions_{en,ko}.tex` | CREATE (runtime) | ~40 each | M1 headline table |
| `scripts/R/_outputs/tab_ch5_reconciliation_{en,ko}.tex` | CREATE (runtime) | ~25 each | M4 reconciliation w/ existing +0.1517 |
| `scripts/R/_outputs/tab_ch5_area_decomposition_{en,ko}.tex` | CREATE (runtime) | ~30 each | M2 conditional vs unconditional + selection share |
| `scripts/R/_outputs/tab_ch5_attrition_profile_{en,ko}.tex` | CREATE (runtime) | ~20 each | M5 pre-policy attrition profiling |
| `scripts/R/_outputs/tab_ch5_exit_heterogeneity_{en,ko}.tex` | CREATE (runtime, **conditional on α**) | ~25 each | S1 own_share × exit; skipped if scenario ≠ α |
| `quality_reports/plans/2026-05-15_p3c-phase1-implementation.md` | CREATE (sister) | identical | per [LEARN:harness] |
| `quality_reports/session_logs/2026-05-15_p3c-phase1.md` | CREATE | grows | incremental log |

**Not in scope:** S2 hazard (deferred to next session); Wild bootstrap on exit cells (spec §4 defers to Phase 2); paper LaTeX edits (option A, post-Phase 1); CLAUDE.md updates.

### `08_p3c_decomposition.R` phase structure

```r
# Phase 0 — Load + guard
#   libraries: dplyr, tidyr, tibble, purrr, fixest, rdrobust, broom, readr, fs, here
#   set.seed(20260504L)
#   df <- readRDS(here("scripts/R/_outputs/clean.rds"))
#   ch <- readRDS(here("scripts/R/_outputs/channels_results.rds"))
#   het <- readRDS(here("scripts/R/_outputs/heterogeneity_results.rds"))
#   stopifnot all expected columns present

# Phase 1 — Per-farm summary + 4 exit definitions
#   farm <- df |> group_by(hh_id) |> summarise(n_years, first_year, last_year,
#                                              D_treat, rv_2018, own_share_0, area_2018,
#                                              age_2018, fulltime, .groups="drop")
#   farm |> mutate(
#     exit_def1 = as.integer(n_years < 5L),                                       # Def 1 baseline
#     exit_def2_raw = as.integer(n_years < 5L & last_year >= 2020L),              # Def 2 raw
#     exit_def2_corrected = as.integer(n_years < 5L & last_year %in% c(2020L, 2021L)),  # Def 2′ HEADLINE
#     exit_def3_last_year = last_year,                                            # Def 3 (hazard panel deferred)
#     exit_def4_completer = as.integer(n_years == 5L)                             # Def 4 mirror
#   )
#   farm |> mutate(own_bin = case_when(...)) per spec §6.3 — reuse 07_heterogeneity Phase 0 pattern
#   Save → p3c_results$farm_summary (tibble 3,614 × ~15)

# Phase 2 — M1 (Form A): per-farm cross-section RD on exit (rdrobust)
#   exit_defs <- c("exit_def1","exit_def2_raw","exit_def2_corrected","exit_def4_completer")
#   bw_grid <- c(T1=500L, T2=1000L, T3=3300L)
#   grid_a <- expand_grid(def=exit_defs, bw_id=names(bw_grid))
#   form_a <- pmap_dfr(grid_a, function(def, bw_id) {
#     h <- bw_grid[[bw_id]]
#     sub <- farm |> filter(abs(rv_2018) <= h)
#     fit <- rdrobust(y=sub[[def]], x=sub$rv_2018, c=0, p=1, h=c(h,h), masspoints="off")
#     tibble(def, bw_id, h, est=fit$Estimate[1], se=fit$se[1], p=fit$pv[1], n=fit$N[1])
#   })
#   → 4 defs × 3 bw = 12 Form A cells. Save → p3c_results$exit_did_form_a

# Phase 3 — M1 (Form B): DiD-style pre/post stacked on cross-section (Def 1 + Def 2′ only)
#   Per spec §7.1 Form B: pre_exit = 1[last_year < 2020 & n_years < 5], post_exit = exit_def2_corrected
#   df_did <- bind_rows(
#     farm |> transmute(hh_id, rv_2018, D_treat, period="pre",  exit=as.integer(last_year < 2020L & n_years < 5L)),
#     farm |> transmute(hh_id, rv_2018, D_treat, period="post", exit=exit_def2_corrected)
#   )
#   form_b <- pmap_dfr(tibble(bw_id=names(bw_grid)), function(bw_id) {
#     h <- bw_grid[[bw_id]]
#     sub <- df_did |> filter(abs(rv_2018) <= h)
#     fit <- feols(exit ~ D_treat * (period == "post") + rv_2018 * (period == "post"),
#                  data=sub, cluster=~hh_id)
#     tidy_did <- broom::tidy(fit) |> filter(grepl("D_treat:periodTRUE|D_treat", term))
#     tibble(bw_id, h, ...)  # extract D_treat:period interaction coeff
#   })
#   → 3 bw cells (D_treat × period interaction = headline causal estimate). Save → p3c_results$exit_did_form_b

# Phase 4 — M2: Survival-conditional area_total event-study
#   completers <- farm |> filter(exit_def4_completer == 1L) |> pull(hh_id)  # N=2,217
#   df_cond <- df |> filter(hh_id %in% completers)
#   cond_grid <- expand_grid(outcome=c("area_total","area_own","area_rent"), bw_id=names(bw_grid))
#   area_conditional <- pmap_dfr(cond_grid, function(outcome, bw_id) {
#     h <- bw_grid[[bw_id]]
#     sub <- df_cond |> filter(abs(rv_2018) <= h)
#     fm <- as.formula(paste0(outcome, " ~ i(year, D_treat, ref=2019) | hh_id + year"))
#     fit <- feols(fm, data=sub, cluster=~hh_id)
#     broom::tidy(fit) |> filter(grepl("year::", term)) |>
#       mutate(year=as.integer(str_extract(term, "[0-9]{4}")), outcome=outcome, bw_id=bw_id, h=h)
#   })
#   → 3 outcomes × 3 bw × 4 years = 36 rows (same shape as ch3_area_events). Save → p3c_results$area_conditional_events
#
#   Decomposition table:
#   decomp <- ch3_area_events |> filter(outcome == "area_total") |>
#             left_join(area_conditional |> filter(outcome == "area_total"),
#                       by=c("year","bw_id"), suffix=c("_uncond","_cond")) |>
#             mutate(selection_share = 1 - estimate_cond / estimate_uncond)
#   Save → p3c_results$area_decomposition

# Phase 5 — M3: Scenario α/β/γ classification
#   Headline cells: form_a |> filter(def == "exit_def2_corrected", bw_id %in% c("T1","T2","T3"))
#   AND form_a |> filter(def == "exit_def1", bw_id %in% c("T1","T2","T3"))  (8 cells = 2 defs × 3 bw + Form B 3 bw + ch3_exit MSE 1 = "all 4 def + Spec A" approximated)
#   classify_scenario_p3c <- function(cells) {
#     all_neg_sig <- all(cells$est < 0 & cells$p < 0.10)
#     all_pos_sig <- all(cells$est > 0 & cells$p < 0.10)
#     mixed_sig <- any(cells$est < 0 & cells$p < 0.10) && any(cells$est > 0 & cells$p > 0.10)
#     if (all_neg_sig) "α (Channel 5 confirmed)"
#     else if (all_pos_sig) "γ (Channel 5 rejected)"
#     else "β (mixed evidence)"
#   }
#   Save → p3c_results$scenario (string), p3c_results$scenario_basis (tibble of headline cells)

# Phase 6 — M4: P3b-1 reconciliation
#   Build reconciliation tibble comparing 5 estimators:
#     - "Existing ch3_exit (MSE)" — pull from ch$ch3_exit (est=+0.1517, se=0.0736, p=0.039, n=900)
#     - "Def 1 baseline T2" — from form_a
#     - "Def 2 raw T2" — from form_a
#     - "Def 2′ corrected T2 [HEADLINE]" — from form_a
#     - "Def 2′ Form B T2 (DiD pre-trend control)" — from form_b
#     - "Def 4 completer T2 (mirror)" — from form_a
#   Save → p3c_results$reconciliation (tibble 6 rows)

# Phase 7 — M5: Pre-policy attrition profiling embedded
#   Reproduce findings.md tables for replication-protocol audit:
#     attrition_by_year (5 last_years × treated/control × n, share_within_group)
#     profile_2018only (1 row: n=239, share_treated=44.4%, mean own_share, area, fulltime)
#   Save → p3c_results$attrition_by_year, p3c_results$profile_2018only

# Phase 8 — S1: own_share × exit heterogeneity (GATED on scenario α)
#   if (scenario starts with "α") {
#     exit_het <- pmap_dfr(expand_grid(def=c("exit_def1","exit_def2_corrected"), bw_id=names(bw_grid)),
#       function(def, bw_id) {
#         h <- bw_grid[[bw_id]]
#         sub <- farm |> filter(abs(rv_2018) <= h, !is.na(own_bin))
#         fit <- feols(as.formula(paste0(def, " ~ i(own_bin, D_treat, ref=\"5_pure_owner\") + rv_2018")),
#                      data=sub, cluster=~hh_id)
#         broom::tidy(fit) |> filter(grepl("own_bin", term)) |>
#           mutate(def=def, bw_id=bw_id, h=h, own_bin=str_extract(term, "[12345]_[a-z_]+"))
#       })
#     Save → p3c_results$exit_het (2 defs × 3 bw × 4 bins = 24 cells, ref omitted)
#     classify_h5 <- monotone check (pure_tenant > mixed > pure_owner≡0 by magnitude)
#     Save → p3c_results$h5_check
#   } else {
#     p3c_results$exit_het <- NULL
#     message("Scenario != α; S1 heterogeneity skipped per spec.")
#   }

# Phase 9 — Save RDS + LaTeX tables
#   saveRDS(p3c_results, here("scripts/R/_outputs/p3c_results.rds"))
#   write_ch5_exit_definitions_table(form_a, form_b, scenario, lang="en") → tab_ch5_exit_definitions_en.tex
#   ... (4 tables × 2 langs = 8-10 .tex files)
#   Console summary: scenario verdict, headline coefficient, decomposition share
```

### `06_channels.R` Panel B fix

Current `write_ch3_table()` (lines 366–409): loop iterates over 3 outcomes (area_total/area_own/area_rent) but concatenates ALL outcomes' years into single bw row → 12 values per row.

Fix: restructure loop to produce **3 separate panels** (Panel B = area_total, Panel C = area_own, Panel D = area_rent), each with bw × 4-year matrix (2018 / 2020 / 2021 / 2022; 2019 ref omitted). Follows `tab_stabilization_en.tex` pattern (multi-block stacked).

```r
# Pseudocode for fix:
build_panel <- function(outcome_var, area_events_df, lang) {
  df_sub <- area_events_df |> filter(outcome == outcome_var)
  # Pivot wider so each bw is a row, years are columns
  df_wide <- df_sub |> select(bw_id, year, estimate, std.error) |>
             pivot_wider(names_from = year, values_from = c(estimate, std.error))
  # Build LaTeX rows: 3 bw × (4 estimate cols + 4 SE cols stacked below in parens)
  rows <- map_chr(seq_len(nrow(df_wide)), function(i) {
    bw <- df_wide$bw_id[i]
    estimates <- format(df_wide[i, paste0("estimate_", c(2018, 2020, 2021, 2022))])
    paste0(bw, " & ", paste(estimates, collapse=" & "), " \\\\")
  })
  paste(c(panel_header, rows), collapse="\n")
}

panel_b <- build_panel("area_total", ch_area_events, lang)
panel_c <- build_panel("area_own",   ch_area_events, lang)
panel_d <- build_panel("area_rent",  ch_area_events, lang)
```

Verification: render `tab_ch3_retention_en.tex` and check each panel has 5 columns (bw + 4 years).

## Verification

```bash
# 1. Pipeline run
Rscript scripts/R/00_run_all.R 2>&1 | tail -30
# Expect: 8 scripts, +08_p3c_decomposition.R adds ~10s, total ~30s. 0 errors.

# 2. New RDS exists with all fields
Rscript -e '
r <- readRDS("scripts/R/_outputs/p3c_results.rds")
cat("Fields:", paste(names(r), collapse=", "), "\n")
cat("Scenario:", r$scenario, "\n")
cat("Headline Def 2′ Form B T2 estimate:", r$exit_did_form_b[r$exit_did_form_b$bw_id=="T2", "est"], "\n")
cat("Selection share at T3 2022:", r$area_decomposition[r$area_decomposition$bw_id=="T3" & r$area_decomposition$year==2022, "selection_share"], "\n")
'
# Expect: 8 fields listed; scenario string; numeric headline estimate; selection share in [0,1]

# 3. New LaTeX tables present + count rows
ls scripts/R/_outputs/ | grep -E '^tab_ch5_'
# Expect: 8 files (4 tables × 2 langs); 10 if S1 ran (scenario α)

# 4. Panel B bug fix verified
grep -c "^[TM][1-3].*&.*&.*&.*&.*\\\\\\\\$" scripts/R/_outputs/tab_ch3_retention_en.tex
# Expect: 9 (3 panels × 3 bw rows); each row has exactly 5 fields (bw + 4 years)

# 5. Sister plan parity
diff /Users/leedo/.claude/plans/inherited-knitting-sutton.md quality_reports/plans/2026-05-15_p3c-phase1-implementation.md
# Expect: empty diff

# 6. Quality gate
python3 scripts/quality_score.py scripts/R/08_p3c_decomposition.R scripts/R/06_channels.R
# Expect: ≥60 (explorations fast-track) for any false-positive newline overrides; ≥80 for clean R code.
# Document any overrides in commit message per [LEARN:tooling] 2026-05-14.
```

## Decision gate after this plan

1. User reviews scenario verdict (α/β/γ) printed to console + p3c_results.rds$scenario.
2. User reviews 4–5 new .tex tables.
3. **Joint decision:**
   - If **α**: proceed to option A (paper §3 LaTeX) — §3.6bis retained as sketched
   - If **β**: minor §3.6bis qualification + §7 limitations paragraph; option A entry next session
   - If **γ**: §3.6bis rewrite required (alternative narrative: per-farm flat-rate fails to deter exit due to compliance cost); option A entry +5–7 days

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| Form B parameterization (DiD-style on stacked cross-section) edge case: `period=="post"` interaction with non-unique D_treat values per hh_id | Low | Spec §7.1 documents; verified by Form B coefficient extraction in Phase 3. If problematic, fall back to plain `feols(exit ~ D_treat * period + rv_2018 * period, data=df_did)` without TRUE check |
| Scenario classification cells split (Form A and Form B disagree) | Medium | Headline = Def 2′ Form B T2 per spec; if conflict, report both and flag in scenario_basis tibble |
| Panel B fix in 06_channels.R cascades into other table writers | Low | `write_ch3_table()` is the only writer using that loop pattern (per Explore Agent report); `write_stabilization_table()` already uses correct multi-block pattern |
| own_bin × exit at T1 h=500 has empty bins (e.g., pure_tenant N<5) | Medium | Gating on scenario α only triggers if Form A shows significance; spec implicitly assumes adequate N. Report bin Ns in table; if any bin <5, use T2 only for heterogeneity |
| `08_p3c_decomposition.R` runtime exceeds budget (~10s expected) | Low | All cells are small RDD on cross-section (3,614 farms) or panel sub (≤14,474 obs); no bootstrap, no Wild — well under 30s. |
| Quality gate false positives (newline regex per [LEARN:tooling] 2026-05-14) | High | Document overrides in commit body following P2/P3c-Phase-0 precedent; do NOT fix the regex this session (out of scope) |

## Approval gate

On ExitPlanMode approval:

1. Mark plan APPROVED in this file + sister.
2. Create session log `quality_reports/session_logs/2026-05-15_p3c-phase1.md`.
3. Implement `08_p3c_decomposition.R` phases 0–9.
4. Edit `06_channels.R` Panel B (`write_ch3_table()` lines 366–409).
5. Edit `00_run_all.R` pipeline vector.
6. Run `Rscript scripts/R/00_run_all.R` + verify outputs.
7. Update session log with completion summary + scenario verdict.
8. Present scenario classification + reconciliation table + decomposition share to user.
9. **DO NOT auto-commit.** User invokes `/commit` after reviewing scenario verdict.
10. Pause for decision gate (α/β/γ → option A entry shape decision).

**Total wall-clock estimate: 4–5h** (Phases 0–9 implementation ~3h + Panel B fix ~0.5h + verification + session log ~1h + margin 0.5h).
