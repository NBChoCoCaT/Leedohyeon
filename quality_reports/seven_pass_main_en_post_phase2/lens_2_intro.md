# Lens 2 — Introduction Review (Post-Phase-2)

**Manuscript:** `paper/en/main.tex` lines 46–62 (§1 Introduction)
**Reviewer:** seven-pass / Lens 2 (intro)
**Date:** 2026-05-20
**Baseline:** Phase-1.5b score 5.6/10 (M1–M4 deferred)
**Target:** ≥ 8.0/10

---

## Headline

**Score: 8.2 / 10  (Δ = +2.6 from 5.6)**

Phase-2 restructure cleared the four deferred blockers (M1 length, M2 lit-review placement, M3 magnitude-lateness, M4 "Versus X" checklist). The intro now has a clean Cochrane arc, a sharp three-bullet contribution paragraph, and headline numbers in ¶5 (one paragraph earlier than Phase-1.5b). Remaining issues are presentation polish, not structural: a residual telegraphed-citation feel in ¶3 sentence 3, ¶4 still slightly dense on observability screening, and the road-map ¶7 is bare. Submission-ready (90-stage) after ~2 hours of Phase-3 polish.

---

## 1. Word-count verification (M1 cleared)

| Block | Words (incl. LaTeX tokens) |
|---|---|
| ¶1 Question + institutional anchor | 221 |
| ¶2 AHM null + two channels + F1/F2 | 239 |
| ¶3 Four reference points (compressed) | 169 |
| ¶4 DiD-RD + ITT + screening + cross-ref to §5 | 143 |
| ¶5 F1 gradient + (S,s) + headline magnitudes + rent reversal | 129 |
| ¶6 Three-contribution paragraph | 200 |
| ¶7 Roadmap | 44 |
| **Total** | **1,145** |

Counting on the rendered PDF (LaTeX commands collapsing to text) gives ~1,000–1,050 prose words. **Within the AJAE ≤ 1,200 envelope.** Phase-2 target of ~1,090 effectively met (the 1,145 is a `wc` overcount).

Action: none. M1 closed.

---

## 2. Cochrane arc verification

Cochrane's intro template = (i) question, (ii) what we do, (iii) what we find, (iv) why it matters / where it fits. Mapping:

| Cochrane element | Intro location | Status |
|---|---|---|
| (i) Question | ¶1 sentence 1 ("Does the AHM separability null hold…") | **Sharp**, theory-driven |
| Institutional anchor | ¶1 sentences 2–5 | Dense but defensible |
| Theoretical framing | ¶2 (null + 2 channels + F1/F2) | **Clean**, pre-specification flag is a referee shield |
| (iv-partial) Where it fits | ¶3 (four reference points compressed) | **Major improvement** — integrated synthesis replacing the checklist |
| (ii) What we do | ¶4 (DiD-RD + ITT + screening) | Tight; cross-ref to §5 working as intended |
| (iii) What we find | ¶5 (gradient + magnitudes + rent reversal) | **Headlines now in place** — M3 partially cleared |
| (iv) Why it matters | ¶6 (three-contribution paragraph) | Solid M/T/E structure |
| Roadmap | ¶7 | Functional but generic |

Arc is intact and reads in correct order. The Phase-1.5b complaint that the reader had to wait until ¶6 for any number is resolved.

---

## 3. Contribution sharpness (¶6)

The three-contribution paragraph is **the strongest paragraph** in the intro and a clear upgrade from prior versions:

- **Methodological:** "first AHM separability test at a per-farm flat-rate cutoff" + "first DiD-RD on Korean PIDPS" + ITT-on-conjunction-of-criteria methodological-purity claim is well-scoped. The cross-reference to §7.1 area-only robustness pre-empts the obvious referee question.
- **Theoretical:** Two-channel AHM extension with an explicit ex-theory disclosure on rental incidence — the disclosure is unusual and **net positive** for referee credibility because it pre-empts the "where is your structural model of rent?" complaint.
- **Empirical:** Monotone-in-tenancy gradient + (S,s) operating-cost response framed against muted Kirwan–Baldoni-Ciaian channel — the contrast is the paper's selling point and lands here.

The Choi–Jodlowski and Choi–Mun differentiation sits inside the methodological bullet rather than getting its own paragraph. This is the right call for length but the sentence is a touch buried; consider promoting it to its own short sentence in Phase 3.

---

## 4. Issues remaining (severity-ordered)

### Major

**M-int-1. ¶3 sentence 3 still reads as a citation telegraph.**

> "Closest in theoretical structure to ours is \citet{CarterOlinto2003_liquidity}, whose rural-Paraguay land-titling evidence we replicate in a developed-country direct-payment context with sharper identification."

The Carter–Olinto sentence is good. But the immediately prior Kazukauskas sentence is one of the longest in the intro (~75 words) and carries three nested clauses (decoupling-induced disinvestment ↔ operating-cost sub-prediction ↔ wealth-bias extension ↔ Carter–Olinto cross-partial). Reader has to hold four objects in working memory. **Split into two sentences.** Suggested:

> "The \citet{Kazukauskas2013_disinvestment} decoupling-induced disinvestment finding is the closest theoretical lineage for our operating-cost sub-prediction: when transfers are small relative to lumpy adjustment costs, the $(S,s)$ inaction band deepens and operating expenses fall \citep{CaballeroEngel1999_lumpy}. We extend the lineage by formalizing the wealth-bias signature — the Carter–Olinto cross-partial — that the disinvestment literature does not isolate."

Cost: +6 words. Worth it.

**M-int-2. ¶4 ITT-vs-ATT footnote opportunity.**

The ITT framing is correctly stated ("estimand is an ITT (not a sharp ATT — administrative compliance on the five unobservable criteria is $\approx 92\%$)") but the 92% number appears here for the first time without a footnote pointing to its source. A referee will ask: where does 92% come from? A one-line cross-ref to §2.2 (or wherever you derive the rate) closes the loop. This is a 5-second fix.

### Minor

**m-int-3. ¶1 institutional density.**

¶1 sentence 2 is 64 words and stacks: "largest restructuring of Korean farm subsidies in two decades" + "replacing the area-proportional Rice Income Compensation Scheme" + "hybrid program of which the SFFP is the per-farm flat-rate component." A reader unfamiliar with Korean farm policy parses this twice. Acceptable for AJAE (their typical reader knows U.S. farm-bill structure and can analogize), but consider a comma rephrase. Low priority.

**m-int-4. ¶5 magnitude presentation order.**

The headline numbers in ¶5 currently arrive as: (a) F1 monotone gradient confirmation (pure-tenant +1,151 m², low-owner +438 m²), then (b) op_cost_ex_rent −3.57M KRW, then (c) rent pass-through −13.7%. The order is correct for the theory (primary → operating-cost sub-prediction → reduced-form aggregate). But the rent-reversal vs. Kirwan/Baldoni-Ciaian comparison is **the most quotable single number in the paper** and currently lands last. For an abstract-skimming referee, consider whether (c) should be reordered to (a) — or at minimum, ensure the abstract leads with the reversal (it currently does, so OK to leave intro order intact).

**m-int-5. ¶7 roadmap is generic.**

44 words, eight clauses of the form "§X does Y." Functional but mechanical. AJAE roadmaps are often this terse, so leave it — but check whether two or three of the section pointers could be merged ("§\ref{sec:results}–\ref{sec:robustness} report estimates and robustness").

**m-int-6. Pre-specification footnote (¶2 end).**

> "The theoretical scope, outcome hierarchy, and F1/F2 pre-specifications were fixed prior to estimation; the corresponding pre-specification archive is bundled in the replication package."

Good signal to referees. But AJAE/JAE referees increasingly want a **timestamp** ("dated YYYY-MM-DD on Zenodo / OSF / a git tag"). Add the timestamp or "see README §X" pointer in Phase 3.

### Polish

**p-int-7. "to our knowledge" hedge in ¶6.**

> "to our knowledge we provide the first AHM separability test…"

Conventional but slightly defensive. Two "firsts" in one sentence ("first AHM separability test … and the first DiD-RD on Korean PIDPS"). Keep the hedge but consider splitting into two clauses to avoid the double-first.

**p-int-8. Calibration block ($T_{SFFP}/\tau$).**

¶5 sentence 2 is now compact ("$T_{SFFP}/\tau \in [0.024, 0.048]$") with the τ footnote moved to §3.4 per Phase-2 plan. Verify the §3.4 footnote actually exists at the new location.

---

## 5. What Phase-2 achieved (cleared blockers)

| Phase-1.5b blocker | Phase-2 disposition |
|---|---|
| M1 length 1,569w | **Cleared** — 1,145 token-count / ~1,000 prose; under AJAE 1,200 cap |
| M2 lit-review placement (separate ¶) | **Cleared** — integrated into ¶3 as compressed synthesis |
| M3 magnitudes lateness | **Largely cleared** — F1 + op_cost + rent now in ¶5 (was ¶6/abstract-only); could optionally promote rent reversal to ¶1 in Phase 3 |
| M4 "Versus X" checklist pattern | **Cleared** — ¶3 reads as a thesis ("our framework treats rental incidence as an aggregate-equilibrium implication outside the household-model core") not as a bulleted comparison |

---

## 6. Phase-3 punchlist (≤ 2 hours)

1. Split the Kazukauskas–Carter-Olinto sentence in ¶3 (M-int-1) — 5 min
2. Cross-ref the 92% compliance figure in ¶4 to §2.2 (M-int-2) — 2 min
3. Verify τ-calibration footnote is at §3.4 (p-int-8) — 5 min
4. Add timestamp to pre-specification footnote in ¶2 (m-int-6) — 5 min
5. (Optional) Promote rent-reversal one-liner into ¶1 for abstract-skimmers (m-int-4) — 10 min
6. (Optional) Lightly tighten ¶7 roadmap (m-int-5) — 5 min

**Total: 30 min mandatory + ~20 min optional.**

---

## 7. Scoring breakdown

| Dimension | Weight | Score | Notes |
|---|---|---|---|
| Length compliance | 0.15 | 9.5 | Under AJAE cap |
| Cochrane arc | 0.20 | 8.5 | All elements present, correctly ordered |
| Lit-review integration | 0.15 | 8.0 | ¶3 reads as synthesis, one long sentence to split |
| Contribution sharpness | 0.20 | 8.5 | Three-bullet structure strong; ¶6 is best-in-intro |
| Magnitude placement | 0.10 | 8.0 | In ¶5, not ¶6 — improved; rent-reversal could go earlier |
| Pre-specification credibility | 0.10 | 8.0 | Footnote good; timestamp would push to 9 |
| Roadmap | 0.05 | 7.0 | Functional but mechanical |
| Prose readability | 0.05 | 7.5 | One overloaded sentence (¶3), otherwise clean |

**Weighted: 8.2 / 10.**

Target ≥ 8.0 met. Phase 3 punchlist would carry intro to ~8.7–8.9, comfortably submission-ready.

---

## 8. Verdict

**APPROVE for first-submission stage after Phase-3 punchlist (mandatory items only).**

The Phase-2 restructure was the right operation on the right paragraph and the right amount of cutting. The intro now does its job: a referee who reads only §1 walks away knowing the question, the design, the headline result, and the contribution — and walks away thinking the author knows the literature without having been forced to read a comparison checklist. That is exactly the bar for AJAE.
