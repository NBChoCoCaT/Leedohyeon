# Wave 4 hot-fix — final polish (Lens MAJORs cluster)

**Date:** 2026-05-18
**Branch:** `feat/section1-section3-wave4-hotfix` (new, off `main` @ `05c81ac` post-Wave-3 merge)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 1 h (synthesis estimate)

---

## Context

Wave 4 is the final polish pass before the manuscript reaches **AJAE submission-readiness (≥9.0/10 ≈ 90/100 quality gate)**. After Wave 1 (PR #8, 6 CRITICAL), Wave 2 (PR #10, 4 CRITICAL), Wave 3 (PR #11, 1 CRITICAL + 6 MAJOR), and QS-1 (PR #9, quality-gate restored), the manuscript sits at **≈8.8–9.0/10**. Wave 4 lifts to **≈9.0–9.2/10** by closing 6 high-leverage MAJORs across Lens 2/4/6/7.

**Scope:** notation table augmentation + bibliography expansion + 3 surgical prose fixes. No CRITICAL items, no theory changes, no §B.1 derivation edits, no abstract changes (Wave 3 locked it). All edits preserve §3 / §B alignment and the Wave 1–3 cumulative state.

---

## The 6 MAJOR items

| ID | Title | Lens | Time |
|----|-------|------|------|
| **W4-1** | Baldoni-Ciaian range clarification at main.tex L60: add lower-bound (9.1–46.2% short-run / 11–55% long-run) | 7 | 5 min |
| **W4-2** | tab:notation augment with 7 missing symbols: $A_i$, $A_{2018,i}$, $rv_{2018,i}$, $h$, $\bar a$, $\Delta K$, $R$ | 4 | 20 min |
| **W4-3** | Add CCT 2014 ECMA + CGM 2008 RESTAT bib entries + cite in §3.1 DiD-RD design paragraph | 7 | 15 min |
| **W4-4** | Split L150 eq:null 195-char single-line equation into 4-line aligned form | 4 / score gate | 5 min |
| **W4-5** | "Aggregation note" italic inline label at L177 → proper `\paragraph{}` block | 6 | 5 min |
| **W4-6** | Lens 2 M4: §1 ¶2 reorder to lead with AHM concept (not the cite-anchor) | 2 | 10 min |

**Total:** 60 min ≈ 1 h (matches budget exactly).

---

## Critical files to modify

| File | Edits |
|------|-------|
| `paper/en/main.tex` | tab:notation L97-109 (W4-2 +7 rows); eq:null L150 split (W4-4); §3.1 "Estimand" paragraph (W4-3 CCT+CGM cite); §3.2 "Aggregation note" L177 (W4-5); §1 ¶3 Baldoni-Ciaian L60 (W4-1); §1 ¶2 L56 (W4-6 reorder) |
| `Bibliography_base.bib` | +2 entries (Calonico-Cattaneo-Titiunik 2014 + Cameron-Gelbach-Miller 2008), both marked `% VERIFY-PRE-SUBMIT` |
| `paper/en/online_appendix.tex` | **UNTOUCHED** in Wave 4 |
| `paper/ko/` | **UNTOUCHED** (CLAUDE.md bilingual rule) |

---

## Implementation order

Front-load Bibliography prep (W4-3 dependency) then mechanical edits.

### Phase 1 — W4-3 prep: CCT 2014 + CGM 2008 bib entries (~10 min)

Add two entries to `Bibliography_base.bib` (after McCrary2008_density, before §1 ¶6 Korean cites):

```bibtex
% W4-3 §3.1 DiD-RD design — Calonico-Cattaneo-Titiunik 2014 ECMA
% MSE-optimal bandwidth + robust bias-corrected RDD inference (rdrobust).
% VERIFY-PRE-SUBMIT: vol/issue/pages against canonical ECMA record.
@article{CalonicoCattaneoTitiunik2014_rdrobust,
  author  = {Calonico, Sebastian and Cattaneo, Matias D. and Titiunik, Rocio},
  title   = {Robust Nonparametric Confidence Intervals for Regression-Discontinuity Designs},
  journal = {Econometrica},
  volume  = {82},
  number  = {6},
  pages   = {2295--2326},
  year    = {2014},
  doi     = {10.3982/ECTA11757}
}

% W4-3 §3.1 inference — Cameron-Gelbach-Miller 2008 RESTAT
% Wild cluster bootstrap with few clusters.
% VERIFY-PRE-SUBMIT: vol/issue/pages against canonical RESTAT record.
@article{CameronGelbachMiller2008_clusterboot,
  author  = {Cameron, A. Colin and Gelbach, Jonah B. and Miller, Douglas L.},
  title   = {Bootstrap-Based Improvements for Inference with Clustered Errors},
  journal = {Review of Economics and Statistics},
  volume  = {90},
  number  = {3},
  pages   = {414--427},
  year    = {2008},
  doi     = {10.1162/rest.90.3.414}
}
```

### Phase 2 — W4-3 + W4-4 + W4-5 (§3 + §3.1, ~25 min combined)

**W4-3 (CCT + CGM cite in §3.1):** In the §3.1 "Estimand and pre-period inference" paragraph (post-Wave-2 expansion, now after the McCrary reference), add a sentence introducing the inference machinery:
- Reference cite to T3 (MSE-optimal) bandwidth → `\citet{CalonicoCattaneoTitiunik2014_rdrobust}` for the bandwidth selector
- Reference cite to wild cluster bootstrap → `\citet{CameronGelbachMiller2008_clusterboot}`

Insert near the existing "wild cluster bootstrap" mention in §1 ¶4 L62 or in §3.1 close (whichever lands more cleanly without bloat).

**W4-4 (eq:null L150 split):** Replace single 195-char line:
```latex
H_0: \quad \frac{\partial A_{own}}{\partial T_{SFFP}} \;=\; \frac{\partial L_f}{\partial T_{SFFP}} \;=\; \frac{\partial K}{\partial T_{SFFP}} \;=\; \frac{\partial L_o}{\partial T_{SFFP}} \;=\; 0.
```
With aligned multi-line `align*` or `aligned` env (4 derivatives on 4 lines, RHS = 0 visible). Closes the persistent quality_score equation-overflow flag at L150.

**W4-5 ("Aggregation note" `\paragraph{}` block):** main.tex L177 currently has `\textit{Aggregation note.} ` italic inline label as the leader of a long sentence. Convert to:
```latex
\paragraph{Aggregation note.} Equation (\ref{eq:CO-1}) is...
```
Preserves the content; semantic-block formatting per Lens 6 recommendation. May also help quality_score line-length heuristic at the affected line.

### Phase 3 — W4-1 (Baldoni-Ciaian range, ~5 min)

Edit main.tex L60: change `"pass-through of Pillar~I area-payments into rental rates of up to 46\% in the short run and 55\% in the long run"` to `"pass-through of Pillar~I area-payments into rental rates ranging 9.1–46.2\% short-run and 11–55\% long-run"`. Closes Lens 7 M1 across the load-bearing citation locus. Other Baldoni-Ciaian mentions (L40 abstract, L56 §1 ¶1, L273 §3.4 rent caveat) don't quote percentages, so no further edits needed.

### Phase 4 — W4-2 (tab:notation augmentation, ~20 min)

Add 7 new rows to tab:notation (between existing rows; preserve alphabetical-by-symbol or grouping-by-concept ordering). Insert before the `\bottomrule`:

```latex
$A_i$ & Post-period total cultivated area: $A_i = A_{own,i} + A_{rent,i}$ & (\ref{eq:ahm-budget}) \\
$A_{2018,i}$ & Baseline (2018) total cultivated area; defines eligibility via $rv_{2018,i}$ & (\ref{eq:ahm-budget}) \\
$rv_{2018,i}$ & DiD-RD running variable: $rv_{2018,i} = A_{2018,i} - 5{,}000$ m\textsuperscript{2}, centered at the cutoff & \S\ref{sec:identification} \\
$h$ & DiD-RD bandwidth half-width; reported in parallel for T1 ($h = 500$), T2 ($h = 1{,}000$), T3 (MSE-optimal) & \S\ref{sec:identification} \\
$\bar a$ & Per-crosser land purchase quantity (Online Appendix \S B.1 Step 2) & (\ref{eq:CO-1}); \S B.1 \\
$\Delta K$ & Discrete capital adjustment indicator: $\Delta K \ne 0$ triggers cost $\tau$ (Online Appendix \S B.1 Step 4) & (\ref{eq:CO-3}); \S B.1 \\
$R$ & Gross return on the alternative-use of period-1 funds; binds against the credit wedge $\lambda_1/\lambda_2$ in Online Appendix \S B.1 Step 1 & \S B.1 \\
```

May also widen the table or use `\scriptsize` if it overflows the page width. Wave 3 abstract was 21p (was 19p); adding 7 rows may push past 22p. Acceptable if minor.

### Phase 5 — W4-6 (§1 ¶2 lit-review-first reorder, ~10 min)

main.tex L56 currently opens: "We test the Agricultural Household Model (AHM) separability null \citep{SinghSquireStrauss1986_ahm, deJanvryFafchampsSadoulet1991_peasant} at the 0.5~ha SFFP cutoff."

Cites appear before the concept is introduced. Reorder:
- First sentence: "The Agricultural Household Model (AHM) separability null states that, under complete markets, smallholder production decisions are separable from consumption decisions; a lump-sum transfer enters only the consumption sub-problem and leaves production unaffected \citep{SinghSquireStrauss1986_ahm, deJanvryFafchampsSadoulet1991_peasant}. We test this null at the 0.5~ha SFFP cutoff."
- Rest of ¶2 preserved.

Concept-first → cite-after pattern. Cleaner Cochrane-canonical opening for ¶2.

### Phase 6 — Verification (~5 min)

1. **Compile main.tex:** `cd paper/en && latexmk -xelatex main.tex` → exit 0, page count ≤ 23 (was 21, +1 from tab:notation expansion), no Korean glyph warnings, no new undefined cites.
2. **paper/ko 0-diff** ✓.
3. **quality_score.py:** `python3 scripts/quality_score.py paper/en/main.tex` → improvement expected (L150 eq:null split should remove one of the 2 critical findings; Aggregation note paragraph block may help second).
4. **Bibliography validation:** 2 new entries (CCT + CGM) resolve via bibtex.

### Phase 7 — Commit + PR (~5 min)

`/commit` skill: stage edits → quality_score gate → gh pr create against main with 6-item itemized body. Manual approval gate.

---

## Decisions to lock (pre-implementation)

**Q1 — tab:notation row ordering:** preserve current ordering and insert new rows by topical grouping (area variables together, bandwidth in §identification group, etc.). Avoid alphabetical re-sort (would diff-noise).

**Q2 — CCT + CGM cite placement:** §3.1 "Estimand and pre-period inference" paragraph (after McCrary). Cite both in single short sentence introducing the inference machinery; defer rdrobust+wild bootstrap technical details to §robustness.

**Q3 — W4-4 eq:null format:** use `aligned` inside `\begin{equation}` (single equation number) rather than `align*` (multi-line, no number). Preserves the single-label `eq:null` reference structure.

**Q4 — Wave 4 inclusion of further Lens 3/5/6 MAJORs?** **NO.** Items deferred to Wave 5+ post-§5 estimation: Lens 3 M1 (pop/individual estimand mixing at eq:CO-1 — Wave 1 X1 already added Aggregation note, this MAJOR partially addressed and the rest depends on §5 estimand discussion), Lens 3 M3 (HonestDiD $\bar M^*$ uncommitted — Wave 2 X8 introduced the framework but specific $\bar M^*$ threshold needs §5 data), Lens 5 M1 (7.7% non-taker selection — needs §5 take-up data), Lens 5 M3 (multiple-testing family — needs §5 spec), Lens 5 M5 (HonestDiD $\bar M^*$ trigger same as Lens 3 M3), Lens 6 sentence-length copyedit on the remaining ~25 long sentences (low marginal value at this stage; deferred to pre-submission pass).

---

## Verification (end-to-end)

1. **Compile:** main.tex 22±1 p (was 21 p; +1 from tab:notation expansion); online_appendix.tex 9 p unchanged (untouched in Wave 4); both XeLaTeX exit 0; no Korean glyph warnings; no new undefined citations.
2. **quality_score.py:** ≥ 85 on main.tex post-W4-4 + W4-5 fixes (L150 + L173 critical findings should clear).
3. **paper/ko/ diff vs main:** 0 lines.
4. **Bibliography validation:** 2 new entries (`CalonicoCattaneoTitiunik2014_rdrobust`, `CameronGelbachMiller2008_clusterboot`) resolve via bibtex; both `% VERIFY-PRE-SUBMIT` flagged.
5. **tab:notation completeness:** all 24 symbols ($i$, $D_i$, $T_{SFFP}$, $T_i$, $A_{own,i}$, $A_{rent,i}$, $A_i$, $A_{2018,i}$, $rv_{2018,i}$, $h$, $s_{0,i}$, $W_i$, $W^*(\mathbf{p})$, $\varphi(W_i^*)$, $\rho(W_i)$, $\delta$, $\tau$, $\bar a$, $\Delta K$, $R$, $w_m$, $w_{f,i}$, $m$, $\mu, \lambda$) present.
6. **Baldoni-Ciaian range:** L60 now reports 9.1–46.2% / 11–55% full range, not upper-bound only.
7. **eq:null L150:** split into 4-line `aligned` form; no single-line equation overflow.
8. **Aggregation note:** `\paragraph{Aggregation note.}` block, not italic inline label.

---

## Out of scope (deferred to Wave 5+ post-§5 P3 estimation)

- UNHEDGE "We test" → "We reject" (X11 gating)
- Fill `% FILL post-§5 P3` placeholders (92.3% take-up, 17–34% hired-labor share, four-bin sub-threshold-mass shares)
- §5 / §6 / §7 / §8 / §9 STUB → real prose
- Lens 3 M3 HonestDiD $\bar M^*$ specific threshold (needs §5 data)
- Lens 5 M1 7.7% non-taker selection analysis (needs §5 take-up)
- Lens 5 M3 multiple-testing family declaration (needs §5 spec)
- Remaining Lens 6 sentence-length copyedit (~25 long sentences; pre-submission pass)

---

## Expected post-Wave-4 score

| Metric | Pre-Wave-4 | Post-Wave-4 | Δ |
|---|---|---|---|
| Composite 7-pass score | 8.8–9.0 / 10 | **9.0–9.2 / 10** | +0.2 |
| quality_score.py main.tex | 80 / 100 | **85–90 / 100** | +5–10 |
| AJAE submission-readiness | "near" | **"ready"** | crosses threshold |

Wave 4 is the **final polish before §5 P3 estimation**. After Wave 4 merge, the next session focuses on §5 results (Wave 5+ track), which requires P3b re-run data and is out of the current rolling-revision scope.
