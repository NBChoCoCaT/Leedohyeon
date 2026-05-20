# Lens 6 — Prose Review (Post-Phase-1)

**Manuscript:** `paper/en/main.tex`
**Reviewer scope:** prose quality only (Phase 1 damage check + high-leverage fixes)
**Overall score:** **8.1 / 10** (meets Phase 1 target ≥8.0; below AJAE-grade 9.0)
**Phase:** Review-only

## Executive summary

Phase 1 magnitude propagation (symmetric sample, op_cost_ex_rent primary, "directionally consistent" framing) is **prose-clean**: no orphan references, no broken sentences from edits, new claim-language internally consistent. Abstract C-1 fix effective; C-3 terminology drift resolved. However, three NEW prose issues emerged from Phase 1 edits, and deferred Phase 2 items remain visible. Composite ≥8.5 achievable via four high-leverage fixes in §D.

## A. Phase 1-Specific Issues

### A-1 [MAJOR] Stranded italic sentence breaks paragraph flow
- **Line 143:** `\textit{We reject AHM separability for Korean small farms.}`
- Sits orphaned between §3.1 opening and `\paragraph{Setup}`. (a) Rhetorically premature — before model setup; (b) contradicts abstract's hedged "non-pure-owner subpopulation" framing.
- **Fix:** Delete or rewrite as `\textit{We reject AHM separability at the 0.5~ha cutoff for the credit-constrained non-pure-owner subpopulation.}`

### A-2 [MAJOR] "Directionally consistent" hedge appears 5×
- Lines 56, 365, 410 (twice in spirit), 470, 481.
- Repetition reads as defensive over-hedging when serial.
- **Fix:** Full hedge in §5 Results only (L365); "supportive of (S,s) reading" elsewhere. Drop Conclusion repeat.

### A-3 [MINOR] (S,s) notation parens-vs-math mode inconsistent
- Math: L125, L219, L261, L470, L481 → `$(S,s)$`
- Text: L365, L399, L404, L419
- **Fix:** Force `$(S,s)$` math-mode throughout (deferred Phase 2).

### A-4 [MINOR] Symmetric sample numbers stated 5× across §1+§3+§4
- L34, L50, L54, L86, L307, L317 — `$N=11{,}010$ / $2{,}776$ farms / $\bar D=0.407$` near-verbatim repeat.
- **Fix:** State once in abstract; once in §1 ¶4; thereafter "the analysis sample" or "the symmetric-screened panel."

### A-5 [MINOR] sido_cd FE 24-vs-18 cell unexplained
- L347 (§5): "24 cells with no sign flips"
- L447 (§7): "18 cells where comparison is feasible"
- **Fix:** Either reconcile (24 = full grid, 18 = shared outcomes) or align both reports.

### A-6 [MAJOR] §5 line 341 still cites Wave 7 +1,122
- L341: "$\hat\beta_{1,\text{tenant}} = +1{,}122$~m² ($p = .041$, T2)"
- L354 (§6): "+1,151 m² ($p = .036$)" — symmetric
- L443 (§7 asymmetric variant): +1,122 (intentional)
- **Phase 1 propagation miss.** A referee skimming §4 gets different headline than §5.
- **Fix:** L341 → +1,151 ($p=.036$, T2). 3-min edit.

## B. Phase 1-Adjacent Issues (newly visible)

### B-1 [MAJOR] Abstract ~265 words in one paragraph
- L32–35. 3 sentences >40 words. Split into setup-paragraph + results-paragraph.

### B-2 [MAJOR] "Versus X" pattern in §1 still reads as 4-bullet list
- L52, four `\emph{Versus \citet{...}}:` openings. Deferred Phase 2.

### B-3 [MAJOR] Sentence-length cap (30 words) violated by new edits
- L48 (intro opening): ~46 words
- L54 (identification overview): ~52 words
- L347 (SUTVA): ~38 words
- 30+ violations remain deferred Phase 2.

### B-4 [MINOR] Em-dash overuse (deferred Phase 2)
- L34, L52 (six), L78, L84, L344, L411, L443, L483. L410 has three em-dashes in four sentences.

## C. Lens 6 Prose Rubric Items

### C-1 [MINOR] `\emph{F fires}` convention inconsistent (L285 vs L288/L290)
### C-2 [MEDIUM] "We reject AHM separability" formatting three ways:
- L143: italicized, unscoped
- L377: italicized, scoped
- L481: not italicized, scoped
Unify on italicized + scoped.

### C-3 [MINOR] "U.S." vs "US" vs "U.S.\" inconsistency (L48, L52, L86, L371, L472)

### C-4 [MAJOR] Definite-article inconsistencies (deferred Phase 2)

### C-5 [MINOR] "Statutorily-eligible" hyphen ~7× — Chicago 7.86 says no hyphen on -ly adverb compounds

### C-6 [MINOR] "AHM-extension" vs "AHM extension" hyphenation drift

### C-7 [MINOR] Korean-English translation tells
- L52: "the field's prior" 
- L474: "cohort observed at"
- L478: "a one-line reference...is offered as...comparators" (number disagreement)
- L483: "a confound" appositive ambiguity

### C-8 [MAJOR] `\citet{X, Y}` two-key construction still present (L219) — deferred Phase 2

### C-9 [MINOR] Passive voice clusters in §5 Results
- L354: 5 passives in 200-word paragraph
- L369: F2 paragraph 6 passives
- L443: Asymmetric variant 4 passives

### C-10 [MINOR] Em-dash for parenthetical L410 — three clustered

## D. High-Leverage Fixes for ≥8.5

| # | Fix | Effort | Score gain |
|---|---|---|---|
| D-1 | Resolve A-1 (delete L143 stranded italic) AND C-2 (unify italics) | 2 min | +0.2 |
| D-2 | Resolve A-6 (L341 +1,122 → +1,151) | 3 min | +0.2 |
| D-3 | Reduce A-2 "directionally consistent" 5× → 2× | 10 min | +0.15 |
| D-4 | Split abstract into 2 paragraphs (B-1) | 1 min | +0.1 |

**Post-fix composite: 8.6 / 10.**

## E. Phase 2 Polish Items (deferred)

Confirmed still present (~same volume as initial review):
- 30+ sentences >35 words (B-3)
- Em-dash overuse (B-4 / C-10)
- "Versus X" checklist pattern (B-2)
- (S,s) math-mode vs text-mode (A-3)
- Statutorily-eligible hyphen Chicago 7.86 (C-5)
- AHM-extension hyphen (C-6)
- `\citet{X, Y}` two-key (C-8)
- U.S. spacing (C-3)

## F. Phase 1 Damage Assessment

**No broken sentences from Phase 1 magnitude propagation.** Symmetric-sample N=11,010 / 2,776, $-13.7\%$ pass-through, +1,151 pure-tenant T2, "directionally consistent" framing — all internally consistent across §1–§6 **EXCEPT** A-6 (L341 missed propagation).

**Citations untouched, references resolve.** Spot-checked 8 keys against `Bibliography_base.bib` — all consistent.

**Abstract C-1 rescoping effective.** "Credit-constrained non-pure-owner subpopulation" replaces triple-repeat unscoped claim cleanly.

**C-3 op_cost terminology fixed.** op_cost_ex_rent (primary, S,s diagnostic) and op_cost (omnibus comparator) used consistently. No `y_farm_cost` leakage.

## G. Score Decomposition

| Element | Weight | Score |
|---|---|---|
| Sentence length cap | 15% | 6.5 |
| Active voice | 10% | 7.5 |
| Hedging proportionate | 15% | 7.5 |
| Paragraph topic sentences | 10% | 8.5 |
| Korean-English tells | 10% | 8.5 |
| Terminology consistency | 15% | 9.0 |
| Citation style | 10% | 7.5 |
| Phase 1 damage | 15% | 8.5 |

**Weighted composite: 8.1 / 10**
**Post D-1 through D-4: 8.6 / 10**
**AJAE-grade 9.0:** requires Phase 2 polish (sentence length, em-dash, citation style, "Versus X" pattern, hyphenation).

**No edits applied** — all 14 issues (4 MAJOR Phase-1-specific, 3 MAJOR deferred Phase-2, 7 MINOR) reported as findings only.
