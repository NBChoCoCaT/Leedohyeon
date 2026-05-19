# Lens 6 — Prose Quality Review (Wave 7)

**Manuscript:** `paper/en/main.tex` (457 lines)
**Target:** AJAE first submission
**Reviewer focus:** sentence-level prose, hedging proportionality, paragraph cohesion, jargon, citation phrasing, Wave-7 edit seams.

---

## Verdict: **NEEDS WORK**

The prose is substantively dense and methodologically careful, but the writing is *consistently overweight* at the sentence level: roughly one in four sentences exceeds 40 words, and several headline paragraphs (abstract, intro ¶1, §3.1 setup, §6 headline) string together three or four nested clauses with em-dashes and parentheticals that an AJAE referee will mark as "compress this." Wave 7 left visible terminology seams between `D_treat`, `D_i`, `D_eligible_obs_2018`, and "statutorily-eligible indicator." The Conclusion contradicts the Results section on the pure-tenant point estimate (1,089 vs 1,122 m²) — that is a hard FAIL on its own and must be fixed before submission, but it is a numeric/copy-edit issue rather than a prose-style issue.

Hedging is *broadly* proportionate (the F1/F2 pre-spec discipline does most of the work), and citation form (\citet vs \citep) is used correctly throughout. Paragraph cohesion is uneven: most paragraphs have topic sentences, but several abstract/intro paragraphs front-load three contributions into a single sentence.

**Score: 6.5 / 10.** Below the 90-threshold for first submission; with ~2–3 hours of compression and seam-fixing this gets to 8+.

---

## CRITICAL

1. **Conclusion / Results contradiction on headline magnitude (L367 vs L447, L350).** §5 reports pure-tenant area\_own at T2 as **+1,122 m² (p = .041)**. The Conclusion L447 says **+1,089 m² (p = .033)** and gives the four-bin gradient as "1,089 → 410 → 393 → −101 → 0." The footnote at L367 also says "p = .033." The numbers do not match between sections. Either the Conclusion is stale Wave-5 text that survived the audit-fix or the Results are stale; pick one and propagate. A referee will catch this in the first pass and treat the entire paper as un-replicated.

2. **Terminology seam: `D_treat` vs `D_i` vs `D_eligible_obs_2018` vs "statutorily-eligible indicator."** The paper sometimes calls it $D_i$ (Tables, §3, §4), sometimes "statutorily-eligible indicator" (abstract, §1), sometimes "treatment dummy $D_i$" (§4.1 L317). The notation table (L118) defines $D_i$ correctly. But the abstract L40 introduces "statutorily-eligible-or-control subset" without defining the indicator. Pick one name in prose, keep $D_i$ in math, and add a one-line gloss in the abstract. Wave 7 CLAUDE.md uses `D_treat`; the paper never uses that string, which is fine — but consistency *within* the paper is not yet enforced.

---

## MAJOR

3. **Abstract is one 350-word block of run-on sentences (L40–43).** The single sentence "We pre-specify two falsification triggers... archived prior to estimation" runs 65+ words with a nested footnote, an em-dash aside, and a parenthetical. The abstract has three sentences that each exceed 50 words. AJAE abstracts under 250 words read better; this one is 290+ and the sentences cannot be parsed on one pass.

4. **Intro ¶2 "Our framework formalizes two AHM extensions..." (L58).** This is a 75-word sentence with three nested clauses and two citations in mid-sentence. Split at "(Channel A, primary)" and recast the second half as its own sentence.

5. **Intro ¶3 contribution paragraph (L60).** "Versus Kirwan... Versus Baldoni-Ciaian... Versus Kazukauskas... Versus Carter-Olinto" is a useful structure, but each "Versus" sentence runs 50–70 words and packs four ideas. The Kazukauskas sentence ("their European-panel evidence... that the disinvestment literature does not isolate") is 80 words. Break each "Versus" into two sentences: contrast claim + our extension.

6. **Theory §3.2–§3.3 "Imperfection / Asset-threshold rule / Closed-form predictions" structure (L196–227).** The structure is clean and readable. But §3.4 "Equilibrium rent caveat (B.1 disclosure)" L308 collapses back into a 4-sentence dense paragraph mixing institutional, theoretical, and empirical statements in one unit. Add a topic sentence: "The observed negative rent pass-through is consistent with our framework but not derived from it."

7. **Discussion §7 "Korean smallholder context" paragraph (L436).** The last sentence "The result generalizes beyond the Korean institutional context to any small-farm direct-payment design that severs the per-hectare landlord-capture channel..." is an over-claim relative to the rest of the paper's careful hedging. Either soften ("The mechanism may extend to...") or anchor to a specific comparable setting. Currently reads as inconsistent with the F2 sign-indeterminacy disclosure two paragraphs up.

8. **Long-equation flagged by quality_score.py (L311 area, eq:didrd-main).** The MEMORY note flags L311 as a long-equation heuristic; the equation itself is fine but the *surrounding prose* L319 (variable construction paragraph) is a single 220-word paragraph that crams every variable definition into one block. Break it into: running variable; treatment indicator; post indicator; primary outcomes; tenancy bin construction. Five short sentences each.

---

## MINOR

9. **"the present framing" / "under the present framing" recurs ~6 times** (L58, L66, L228, L275). Reads as a Wave-edit hedge artifact ("we redid the framing"). A referee does not need to know the framing was redone. Delete or replace with a substantive phrase ("under the AHM-extension scope of §3").

10. **Em-dash overuse.** L40, L56, L58, L60, L62, L66, L78, L94, L150, L196, L267, L308, L432, L434, L436, L440 all use em-dashes to bolt a parenthetical onto a sentence rather than to set up a definition. Cut em-dashes by ~50%; convert two-dash clauses to commas or new sentences. The current density signals an edited-down rather than written-through manuscript.

11. **Hedging tics: "to our knowledge" appears 2× (abstract L40, intro L66).** Once is enough. Pick the intro one and delete the abstract one.

12. **"under the AHM-extension scope archived prior to estimation"-type phrasing.** Abstract L40 and intro L58 and L66 all reference the ADR-archived pre-specification. This is good methodologically but reads as defensive. One reference in the intro suffices; the abstract can just say "pre-specified."

13. **Wave-edit comment seams visible in source.** L41 and L151 contain `% UNHEDGE post-§5 P3: restored Wave 5...` comments. These are fine in source but the `\textit{We reject AHM separability for Korean small farms.}` italic standalone-sentence pattern (abstract L42, §3.1 L152, §5 L367) reads three times across the paper — twice with footnotes explaining "headline restored." Once is rhetorical emphasis; three times is throat-clearing. Keep §5 L367; delete L42 and L152.

14. **Mixed register in §6 "Limitations."** L440 lists "Three caveats temper the headline" then enumerates (i), (ii), (iii) — but then appends a fourth caveat ("The 0.5 ha cutoff is institutionally unique...") at the end of (iii) without numbering. Either bump to (iv) or split.

15. **Passive voice in load-bearing methodological sentences.** L335 "where $f_k(\cdot)$ is... and $\beta_k$ is the DiD-RD coefficient" — fine. But L317 "we test the null... reporting the differential-attrition estimate" and L341 "Standard errors are cluster-robust... wild cluster bootstrap p-values follow..." are appropriately active. Overall passive use is acceptable. Flag only L387 "Wild bootstrap p-values agree with the cluster-robust analytic p-values within ±.01 on every cell" — this should be active: "We obtain wild-bootstrap p-values within ±.01 of the analytic values..."

16. **Jargon density acceptable but two terms warrant a one-line gloss for non-AHM AJAE referees:**
    - "α-strict AHM-extension scope" (L275, L227) — defined only in an ADR not in the paper. Add a footnote at first use.
    - "(S,s) inaction band" (L40, L62, L64) — assumed reader knows Caballero-Engel; one parenthetical gloss in the abstract or intro would help an applied ag-econ reader.

17. **Citation phrasing is correct throughout.** \citet used as subject; \citep used in parentheses. No miscoding spotted. Good.

---

## Top 10 specific findings (prioritized for quick fixes)

| # | Line | Issue | Quick fix |
|---|------|-------|-----------|
| 1 | L367 vs L447 | 1,122 m² (p=.041) vs 1,089 m² (p=.033) contradiction | Propagate the Results-section numbers to the Conclusion; delete stale Wave-5 numerics |
| 2 | L40–43 | Abstract single block, 290+ words, three 50-word sentences | Split into 4 paragraphs: question; design; results; contribution |
| 3 | L58 | "Our framework formalizes..." 75-word sentence | Split at "(Channel A, primary);" |
| 4 | L60 | Four "Versus" comparisons each 50–80 words | Two sentences per Versus (contrast + extension) |
| 5 | L319 | Variable-construction paragraph 220 words / 1 paragraph | Five short paragraphs by variable |
| 6 | L42, L152, L367 | Triple italicized "We reject AHM separability" | Keep only L367; delete the abstract and §3.1 echoes |
| 7 | L308 | "Equilibrium rent caveat" paragraph lacks topic sentence | Add lead: "The observed negative rent pass-through is consistent with but not derived from our model." |
| 8 | L436 | Over-claim "The result generalizes beyond Korea..." | Soften to "The mechanism may extend to other per-farm flat-rate settings; we leave this for future work." |
| 9 | L40, L58, L66, L228, L275 | "the present framing" / "under the present framing" tic | Delete 4 of 5 occurrences |
| 10 | L317 | "statutorily-eligible-or-control subset" used without prior definition in abstract | One-line gloss in abstract: "(the subset of households satisfying or failing only the area criterion)" |

---

## Wave-7 seams summary

- **Terminology:** $D_i$ / "statutorily-eligible indicator" / "treatment dummy" used interchangeably. `D_treat` and `D_eligible_obs_2018` from CLAUDE.md / scripts do NOT leak into the manuscript — that is the right call.
- **Tense:** consistent past/present mix (past for what was done, present for what holds). No tense breaks spotted.
- **Register:** mostly consistent academic. The italicized headline sentence echoed three times is the most visible seam.
- **Numerics:** the 1,122/1,089 split is the single most damaging seam — it is the kind of inconsistency `audit-reproducibility` would catch but `seven-pass` should flag pre-audit.
- **Wave-edit % comments:** harmless in source; do not need cleanup before submission.

---

## Score: **6.5 / 10**

Breakdown:
- Sentence length: 5/10 (too many 40–80 word sentences in load-bearing paragraphs)
- Active voice: 8/10 (mostly active; passive only where appropriate)
- Hedging: 8/10 (proportionate; small overuse of "to our knowledge" and "the present framing")
- Paragraph cohesion: 7/10 (topic sentences mostly present; some paragraphs cram multiple ideas)
- Jargon: 7/10 (acceptable for AJAE; two terms need gloss)
- Citation phrasing: 9/10 (clean)
- Redundancy: 6/10 (triple "We reject AHM separability"; double "to our knowledge"; "the present framing" ×5)
- Wave-7 seams: 5/10 (one numeric contradiction is critical; terminology seam is minor)

**Recommend:** ~2–3 hours of compression-and-cleanup pass focused on (a) the Conclusion ↔ Results numeric reconciliation [CRITICAL], (b) splitting the four longest sentences in the abstract and intro, (c) cutting the three "the present framing" instances and the double italicized headline, (d) adding a topic sentence to the equilibrium-rent paragraph. After that, score lands ≥ 8.5 and the prose is no longer the bottleneck for AJAE submission.
