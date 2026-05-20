# Lens 1: Abstract — Post-Phase-1.5b Stability Check

**Manuscript:** `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex` (lines 32–37)
**Baseline:** 9.0/10 (post-Phase-1.5)
**This pass score:** **9.0/10**
**ΔΔ from baseline:** **0.0** (stable)

---

## Rubric Findings

### 1. Abstract claims still verifiable in body? — PASS

Phase 1.5b touched §5 (Results), §7 (Robustness), §9 (Conclusion), and Bibliography. The abstract was not touched. I cross-checked every numeric and theoretical claim in the abstract against the post-Phase-1.5b body text:

| Abstract claim | Verifying body location | Status |
|---|---|---|
| Sample N = 11,010 farm-years, 2,776 farms | §3 (line 56), §4.1 footnote (line 308) | Consistent |
| Symmetric observable-eligibility screening on both sides | §3 line 56, §4.1 line 308 | Consistent |
| Pure-tenant own-area $+1{,}151$ m² at T2, $p = .036$ | §5 line 355 (headline), §5 figure caption line 362, §5 headline-finding footnote line 378, §7 line 415, §9 lines 475, 486 | Consistent (5+ load-bearing sites) |
| Four-bin gradient $+1{,}151 \to +438 \to +258 \to -52 \to 0$ | §5 line 355, footnote line 378, §9 lines 475, 486 | Consistent |
| Pass-through $-13.7\%$ at T1, $p < .10$ | §5 line 372, §7 line 348, §9 lines 477, 486 | Consistent |
| U.S. $+25\%$ (Kirwan), EU $+46$–$55\%$ (Baldoni-Ciaian) reversal | §5 line 372, §9 line 477 | Consistent (Phase 1.5b §9 expansion preserved comparators) |
| op_cost_ex_rent $-3.57$M KRW at T1, "not individually significant after multiple-testing correction" | §5 line 366 (raw $p \approx .10$, NS after Holm), §9 lines 475, 486 | Consistent — the abstract's hedge ("not individually significant after multiple-testing correction") is the more cautious framing matching §5's "not significant after Holm step-down" |
| F1 (primary) wealth-bias channel via Carter-Olinto | §2 line 52, §3.2 (predictions) — F1 vocabulary load-bearing throughout | Consistent |
| F2 (auxiliary) supervision channel via Eswaran-Kotwal | §2 line 52, §5.4 joint-test reading line 372 | Consistent |
| Headline rejection of AHM separability for credit-constrained non-pure-owner subpopulation | §5 line 378, §9 line 486 | Consistent (Phase 1.5b §9 expansion preserves this exact framing) |
| "Per-farm flat-rate design itself is the policy lever" | §9 line 477 (incidence-reversal paragraph) | Consistent |

No Phase 1.5b edit introduced any drift that the abstract still asserts. The §9 expansion in particular re-states the abstract's headline almost verbatim (line 486), which is a positive consistency signal rather than a flag.

### 2. Word count — 200 (rendered) / 210 (raw including LaTeX tokens)

Raw `wc -w` returns 210 (each `\citep{KeyA, KeyB}` counts as ~2 tokens). Rendered word count (after LaTeX expands citations to "(Author year)" form) is approximately 200, which is at the upper edge of the AJAE 200-word abstract limit. This carries over from the Phase 1.5 MINOR (still flagged below).

### 3. New issues — None introduced by Phase 1.5b

Phase 1.5b's §9 expansion did not propagate any new claim back into the abstract (good — the abstract was correctly left untouched). No new numbers, citations, or framing in §5/§7/§9 contradict the abstract.

---

## Carried-over MINORs (from Phase 1.5)

- **MINOR — word count at upper edge.** Rendered word count ~200, AJAE limit 200. One trim pass could buy ~10 words of safety margin. Lowest-cost trim target: line 36's "(not individually significant after multiple-testing correction)" parenthetical could be shortened to "(NS after Holm)" — but that sacrifices reader transparency. Recommend: leave as-is unless the journal copy-editor flags.
- **MINOR — semicolon at end of paragraph 1 could be a period.** Line 34 ends with "...predicts a hired-labor margin response (F2, auxiliary)." (already a period — reviewed, this was already addressed in Phase 1.5). The earlier semicolon-could-be-period flag from Phase 1.5 appears to refer to the mid-sentence ";" before "implicit-labor supervision" — this is grammatically correct as a compound semicolon between two parallel falsification-prediction clauses. Leave as-is.

---

## CRITICAL / MAJOR — None

## MINOR — 1 carried over

1. Word count at the AJAE 200-word upper edge.

---

## Score derivation

- Baseline (post-Phase-1.5): 9.0/10
- Phase 1.5b changes: none to abstract; downstream §5/§7/§9 edits all consistent with abstract claims; §9 expansion re-states the abstract headline verbatim (positive signal)
- Deductions: 1.0 for word-count tightness (unchanged from Phase 1.5)
- **Final: 9.0/10**

**Target met.** Abstract is stable and submission-ready.
