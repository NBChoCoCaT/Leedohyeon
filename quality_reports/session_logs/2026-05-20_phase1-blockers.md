# Session Log: 2026-05-20 — Phase 1 Blockers (Wave 9)

**Status:** IN PROGRESS
**Branch:** `feat/wave9-phase1-blockers` off `main` @ `50fadf0`
**Plan:** `quality_reports/plans/graceful-percolating-dragonfly.md` (= `2026-05-20_phase1-blockers.md` sister)
**Cross-ref:** `quality_reports/seven_pass_main_en/_SYNTHESIS.md`

## Objective

Resolve all 10 CRITICAL blockers (X1–X10 + bonuses) from the 2026-05-20 seven-pass review. Composite target ≥ 8.5/10 post-Phase-1. Path: R-side re-estimation on symmetric-screened sample → paper text revision → compile/audit/seven-pass verification gate.

## User Decisions (AskUserQuestion 2026-05-20)

| Q | Choice |
|---|---|
| Q1 op_cost canonical | B — `op_cost_ex_rent` primary; CLAUDE.md updates |
| X4 framing | A — Symmetric screening (re-estimate both sides) |
| X5 sgg_cd | A — Actual R re-estimation (`04b_sgg_robustness.R`) |
| Spec B/C | C — Both (B temporal + C covariate-rich) |

## Pre-implementation Risk

X4 symmetric screening drops control-side households failing (ii)+(vi). May attenuate F1 monotone-gradient headline (+1,122 m² T2 p=.041). STOP CONDITION 1 at Phase 1A Step 4.

## Incremental Work Log

**10:30 KST:** Plan approved (`graceful-percolating-dragonfly.md`). Created sister file `2026-05-20_phase1-blockers.md`. Branched `feat/wave9-phase1-blockers`. TaskCreate × 10. Step 1 in_progress.

**10:45 KST:** Step 1 done. CLAUDE.md / r-code-conventions.md / MEMORY.md updated — op_cost_ex_rent canonical, historical op_cost mapping preserved.

**10:50 KST:** Step 2 done. `01d_symmetric_clean.R` — 11,010 obs / 2,776 hh (treated 1,131 unchanged; control 1,645, −644 from Wave 7).

**10:55 KST:** Step 3 done. `run_symmetric_pipeline.R` — full 14-script pipeline 1.4 min. 3-way `.elig` / `.sym` assertion added to 02/03/04/06/08; 13b/14b/15b/11b/12b patched to respect `OUT_DIR` injection.

**11:00 KST:** Step 4 CHECKPOINT. **F1 strengthened** (pure_tenant T2 +1,151 m² p=.036 **; low_owner T2 +438 p=.047 ** — both promoted to **). **CH4 incidence reversal strengthened** (T1 −13.7% p<.10 *). **(S,s) op_cost_ex_rent attenuated** (T1 raw p≈.10, NS w/ Holm). User chose Option A — proceed with strengthened F1+CH4 headline, (S,s) directional-consistency narrative.

**11:05 KST:** Step 5 STOP CONDITION 2. FHES Wave 1 MDIS doesn't release sgg_cd; only 17-province sido_cd is available. User chose Option A' — sido_cd × year FE + Wild bootstrap. `01e_add_sido.R` added (16 sido linked, Seoul empty by construction).

**11:10 KST:** Step 5 delivered. `04b_sido_robustness.R` — 24-cell sido_cd × year FE. **0/18 sign flips** vs main; median |%Δ| = 12.1%. Province-FE absorbed effects modest beyond hh_id FE.

**11:15 KST:** Step 6 done. `03d_specC.R` — Spec C farm_type × Post + age × Post. op_cost_ex_rent T1 = −3.99M (t=−1.61) — slightly stronger than Spec A symmetric. edu_tier deferred (not in clean.rds).

**11:20 KST:** Step 7 done. All 30+ tables + 88 figures regenerated in `_outputs_symmetric/`. `replication_phase1_blockers.md` written.

**11:30 KST:** Phase 1B-1 done. paper §2.1 line 70 SFFP/ABP fix (X6), §4 Table 1 + line 311 $D_i$ definition reconciled (X3), §4 line 313 "sharp DiD-RD restored" reframed for symmetric (X4), §4 line 317 magnitudes corrected to symmetric Table 1 values (X2: 24.4M/8.3M/−16.0M), §6 \input{tab_het_own_share_en, tab_main_did_rd_en, tab_ch4_rent_decomposition_en} inserted (X1b), §5 line 339 sgg → sido reword + line 343 SUTVA defense rewrite with sido_cd × year FE (X5), §7.1 demotion narrative added (X7), §7 \paragraph{Asymmetric-sample variant} inserted.

**11:40 KST:** Phase 1B-2 done. Abstract rewrite ≤200w with symmetric magnitudes + policy contribution + rent-pass-through reversal (X9). §1 intro headline magnitudes updated (line 54+56+58). Spec B description corrected to "drop 2020, Post≥2021" + new \paragraph{Spec C} added (X10). HonestDiD $\bar M^* = 0$ defense expanded to paragraph (X8). Discussion + Conclusion magnitude propagation (Step 18). op_cost_ex_rent canonical naming preserved.

**11:50 KST:** Phase 1C verification. xelatex compile pass. Multiple table-side fixes: underscores escaped (tab_descriptives_en, tab_main_did_rd_en, tab_specB, tab_ch4, tab_specC, tab_sido), m^2 → m$^2$, h*_mse → $h^{*}_{\mathrm{mse}}$, γ → $\gamma$, em-dash → "--", over-escaped p$<$ corrected. **Final: 0 errors, 0 undefined refs, 6 overfull hbox (all wide-table layout issues, not prose; Phase 2 polish item), main.pdf 50 pages (322 KB).**

## Phase 1 Outcome

| Gate | Target | Status |
|---|---|---|
| All 10 X-blockers + 2 bonus addressed | X1–X10 + Y5 + X10 | ✅ All in paper text |
| R pipeline 0 errors | exit 0 | ✅ 1.4 min wall-clock |
| `_outputs_symmetric/` complete | All Wave-7-equivalent .rds/.tex/figures | ✅ 30+ tables, 88 figures |
| xelatex compile | exit 0, ≤1 overfull | ⚠️ 0 errors but 6 overfull (wide tables; Phase 2) |
| PDF page count | ≤ 50 (AJAE cap) | ✅ Exactly 50 |
| Symmetric headline survives | F1 monotone gradient at p<.10 | ✅ STRENGTHENED — pure_tenant + low_owner now p<.05 |

## Learnings

[LEARN:design] Symmetric observable-eligibility screening on BOTH sides of an SFFP-eligibility cutoff is identification-cleaner than asymmetric (Wave 7) construction. The seven-pass review caught the "sharp DiD-RD restored" claim as sample selection; symmetric screening makes the sharp-RD claim defensible (D_i = 1 iff rv_2018 ≤ 0 by construction on the screened population). Cost: 644 control-side households dropped → SE inflation on some primary outcomes (e.g., op_cost_ex_rent loses statistical significance) but FE absorbs little. Trade-off: identification rigor > marginal statistical power.

[LEARN:tooling] 5 R analysis scripts (02/03/04/06/08) hardcoded sample-size assertions for Wave 5 / Wave 7; 3 figure/robustness scripts (13b/14b/15b) hardcoded OUT_DIR. The 3-way assertion (sym / elig / full) and OUT_DIR injection pattern enables sample-variant pipelines without touching the analysis logic. Apply to any future Wave (10+) addition.

[LEARN:env] FHES Wave 1 MDIS does not release `sgg_cd` (시군구, ~250 sub-districts); only `행정구역시도코드` (시도, 17 provinces) is published. Any paper text promising sgg-level robustness must be reworded to sido or omitted. The 16-vs-17 sido gap (Seoul empty for smallholder agriculture) is by construction; document this in §5 inference paragraph + replication README.

[LEARN:tooling] R `modelsummary` table outputs require underscore escaping for variable names containing `_` (op_cost, off_farm_income, etc.) when they appear in table body. Symbols like `h*_mse`, `m^2`, Greek letters, and em-dashes also need math-mode or text-escape wrapping. Add a post-processing pass to the table-generating R scripts (Phase 2 fix).

## Next Steps

- **Phase 2 (Lens 1/2/6 polish):** abstract jargon, intro length trim, sentence-length splitting, "statutorily-eligible" hyphen drop, CJM `rddensity`, CCT covariate-continuity tests
- **Phase 3 (Lens 7 polish):** unused .bib entries decision, Zimmert-Zorn year fix, citation count optimization
- **Pre-commit:** `/audit-reproducibility paper/en/main.tex scripts/R/_outputs_symmetric/` + `/seven-pass-review` post-revision composite ≥ 8.5 target
- User decision: commit & PR `feat/wave9-phase1-blockers` to `main` (10 blockers resolved + symmetric headline strengthened)


---
**Context compaction (auto) at 14:38**
Check git log and quality_reports/plans/ for current state.
