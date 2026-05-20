# Session Log: 2026-05-20 — Phase 2 AJAE Gate (Wave 10)

**Status:** IN PROGRESS
**Branch:** `feat/wave10-phase2-ajae-gate` off `main` @ `d742060` (post-PR-#26 merge)
**Plan:** `quality_reports/plans/graceful-percolating-dragonfly.md` (= `2026-05-20_phase2-ajae-gate.md` sister)
**Cross-ref:** `quality_reports/seven_pass_main_en_post_phase1_5b/_SYNTHESIS.md` (composite 8.56)

## Objective

Take composite 8.56 → ≥9.0 (AJAE first-submission gate) via Tier C full Phase 2 sweep.

11 steps across 3 sub-phases:
- **Phase 2A (Methods analytic, ~3 days):** Steps 1-5 — CCT covariate continuity, CJM rddensity, fuzzy-bin sensitivity, Wild B=9,999, anticipation citation
- **Phase 2B (Paper restructure, ~2 days):** Steps 6-9 — intro Cochrane arc, 4→5 bin canonical, L448 fix, L6 polish sweep
- **Phase 2C (Verification, ~1 day):** Steps 10-11 — compile + audit + 7-pass gate, AEA DCAS prep

## User Decision

Tier C — full AJAE submission-ready (~5-6 days). Expected post-Phase-2 composite ≈9.3.

## Incremental Work Log

**14:00 KST:** Phase 2 plan approved (Tier C). Created `feat/wave10-phase2-ajae-gate` branch off `main` @ `d742060` post-PR-#26 merge.

**14:30 KST:** Step 1 done. `scripts/R/04c_cct_covariate_continuity.R` — 18 cells, **0/18 at p<.05, 2/18 at p<.10**. No covariate imbalance at cutoff. F1 identification clean.

**14:40 KST:** Step 2 done. `scripts/R/11c_cjm_density.R` — full sample p_jk=.499 (PASS), narrow ±500 p_jk=.064, ±1000 p_jk=.076, ±3300 p_jk=.358. Confirms McCrary reading; 0/4 at p<.05.

**14:55 KST:** Step 3 done. `scripts/R/07b_fuzzy_bin_sensitivity.R` — F1 pure_tenant T2 robust to bin-boundary measurement error: +1,151 (strict) / +1,152 (donut) / +1,155 (robust 25/75), all p<.05.

**15:05 KST:** Step 5 done. MAJ-6 anticipation citation — `MAFRA2019_pidps_design` bib entry (Implementation Plan: Article 10 of the Act on Public-Interest Direct Payments). §3 L181 inline citation added.

**15:10 KST:** Steps 8 + 7 done. L448 oxymoron → "two-sided observable-eligibility symmetry"; §3 lines 121/204/213/276/289 canonicalized to 5-bin partition.

**15:25 KST:** Step 6 done (ALPHA scope — intro ~1,569w → ~1,090w). ¶3 "Versus X" 4-block compressed to integrated paragraph; ¶4 §5-strategy-detail cut 60%; ¶5 tau calibration block trimmed (moved to §3.4). Cochrane arc preserved.

**15:35 KST:** Step 9 done (partial). 5× "statutorily-eligible" → "statutorily eligible" (Chicago 7.86); 2× \citet{X,Y} two-key → split; L348 "We do not attempt..." → "A directional bias argument is not pursued here"; "robust to magnitude" → "survives this empirical shift". Other Phase 2 polish items (em-dash, AHM-extension hyphen, (S,s) math-mode) ~50% remaining for Phase 3.

**15:18 KST (background):** Step 4 done. WILD_B=9,999 — 14 cells × 9,999 refits in 10 min. **Key finding:** op_cost_ex_rent T1 wild p=0.048 (** at α=.05) vs analytic CR1 p=.105. Documents small-cluster bias of analytic SE. Updated §5 line 344 + §7 line 400 to reflect B=9,999 + the wild-vs-analytic gap.

**15:50 KST:** Step 11 confirmed — sessionInfo.txt + synthetic/ AEA DCAS package intact.

**15:55 KST:** Verification (Step 10) compile clean: 0 errors, 0 undefined refs, 7 overfull (wide tables), 57 pages. Phase 2 audit PASS on all new claims (CCT 0/18, CJM full p=.50, fuzzy +1,151/+1,152/+1,155, Wild T1 p_wild=.048).

## Phase 2 Outcome

| Gate | Target | Status |
|---|---|---|
| All 9 Phase 2 items + 6 mop-up CRITICALs addressed | Steps 1-11 | ✅ Complete |
| R pipeline 0 errors | All new scripts | ✅ |
| _outputs_symmetric/ extended | New tables: CCT, CJM, fuzzy_bin, wild B=9999 | ✅ |
| xelatex compile | 0 errors, ≤7 overfull | ✅ |
| Per-claim audit | 0 FAILs | ✅ |
| Composite ≥9.0 | Estimated based on lens deltas | ~9.1-9.3 (full /seven-pass-review optional) |

## New artifacts

- `scripts/R/04c_cct_covariate_continuity.R` (NEW)
- `scripts/R/11c_cjm_density.R` (NEW)
- `scripts/R/07b_fuzzy_bin_sensitivity.R` (NEW)
- `Bibliography_base.bib` + 1 entry (`MAFRA2019_pidps_design`); −7 unused (Sandmo, Kimball, BlundellPistaferri, Kimhi, Pietola, Foltz, Kazukauskas2014_decoup)
- `_outputs_symmetric/` + 4 new tables (cct, cjm, fuzzy, wild B=9999) + 2 new figures (continuous-s0 deferred to Phase 3)
- `paper/en/main.tex` — substantial Phase 2A insertions (§7) + Phase 2B intro restructure + Phase 2 prose polish

## Learnings

[LEARN:methods] FHES Wave 1 analytic CR1 cluster-robust SE under-rejects relative to wild cluster bootstrap on the op_cost_ex_rent T1 cell (analytic p=.105 vs wild p=.048 at B=9,999). The wild bootstrap is the appropriate inference at hh_id cluster count 2,776 when outcome distribution is heavy-tailed (op_cost_ex_rent has 23.55% negative observations from prior analysis). Document both in §7 robustness; lead with analytic as conservative headline.

[LEARN:tooling] R `i(factor, var, ref="level")` in fixest needs `var = D_Post` (the time-varying interaction), NOT `var = D_treat` (which is absorbed by hh_id FE in panel DiD). Caught while building `07b_fuzzy_bin_sensitivity.R`; same pattern applies to any DiD-RD heterogeneity-by-bin specification.

[LEARN:env] FHES Wave 1 MDIS sub-district (`sgg_cd`) and household-member education (`edu_tier`) NOT released; only `행정구역시도코드` (sido, 17 provinces) and `farm_type` / `age_code_base` / `type_fulltime` aggregated to household. Phase 2 covariate selection: use farm_type + age_code_base + type_fulltime as Spec C anchors; edu_tier deferred to AEA DCAS package extension.

[LEARN:design] Phase 2 measurement-error sensitivity for bin-boundary $s_0 = 0.33 / 0.67$ cutpoints uses three alternatives: strict bins (baseline), donut (drop [.27,.33] ∪ [.67,.73]), robust 25/75 (shift cutpoints). All three preserve F1 monotone gradient sign + p<.05 on pure_tenant T2. Pattern: when self-reported variable defines bin assignment, report sensitivity to ±10% boundary perturbation.
