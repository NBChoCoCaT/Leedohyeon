# Lens 1 — Abstract Audit (Post-Wave-7)

**Manuscript:** `paper/en/main.tex` (39 pp; abstract L38–43)
**Target:** AJAE first submission
**Reviewer:** Lens 1 of 7 (abstract-focused)
**Date:** 2026-05-19

---

## Verdict: **NEEDS WORK**

Substantively the abstract is on-target — it asks the question, names the design, quantifies the headline, and states the contribution. But there is **one CRITICAL internal-consistency issue** (abstract numbers do not match the conclusion/headline-footnote numbers) and **one MAJOR length-discipline issue** (the abstract is ~2.6× the AJAE house norm). Both are blocking for a first-submission upload; both are mechanical to fix.

Composite score: **6.5 / 10** (would be ≥8 once CRITICAL is closed).

---

## CRITICAL issues (block submission)

**C1. Numeric inconsistency between abstract and §8 Conclusion (and §6 headline-finding footnote).**

The abstract (L40) reports the Wave-7 statutorily-eligible numbers:
- pure-tenant own-area `+1,122` m² at T2, `p = .041`
- op_cost `−3.98M` KRW at T1, `p = .057`
- rent-cost pass-through `−12.0%`

§6 Results (L350, L359, L363) is internally consistent with the abstract on these three figures.

However:
- The headline-finding footnote at **L367** still cites `p = .033` for the pure-tenant T2 coefficient (Wave 5 area-only baseline number) — contradicts the abstract's `p = .041` and §6 Results L350's `p = .041`.
- The Conclusion at **L447** reports the OLD Wave-5 area-only baseline numbers throughout: `+1,089` m² (`p = .033`), four-bin gradient `1,089 → 410 → 393 → −101 → 0`, op_cost `−4.18M` (`p = .047`), pass-through `−11.1%`.

This is a Wave-7 migration that was completed in §1, §3 calibration block (L64), §4 identification (L339), §5 results (L350–363), but NOT propagated to §6 headline-finding footnote (L367) or §8 Conclusion (L447). The abstract is correct against the current treatment definition (`D_eligible_obs_2018`); the Conclusion and the L367 footnote are stale.

**Why this blocks submission:** Any AJAE referee or desk editor running a 30-second consistency check between abstract and conclusion will flag this immediately. It will not survive desk review.

**Fix scope:** Mechanical — replace stale numerics in L367 footnote and L447 with the Wave-7 statutorily-eligible figures already used in the abstract and §6.

---

## MAJOR issues (R1-stage referee will flag)

**M1. Length: ~370–394 words (raw `wc -w` = 394; ~370 after stripping LaTeX). AJAE house norm is 100–150 words; common upper tolerance ≈200.**

The abstract runs to ~14 sentences, several of which serially compound (the post-`---` clauses on L40 are particularly heavy). AJAE explicitly caps abstracts at 150 words in submission guidelines. The first-pass desk-editor in JEL/AJAE listings is typically allotted ~120 words. At ~2.6× the norm, this WILL be flagged for compression by the editorial office before peer review. It is also a signal of authorial discipline that reviewers weigh.

The length is not "justified" by any unusual content burden — the same four claims (question, design, magnitudes, contribution) could be made in 150 words. The excess comes from:
- L40 sentence 3 (Two-AHM-extensions clause): re-states theoretical framework in detail unneeded in an abstract;
- L40 sentence 4 (pre-specification + ADR footnote): pre-registration disclosure is appropriate in §4, premature in abstract;
- L40 sentence 5 (robustness moves by no more than 2.2%, no journal-cell crosses α=.05): robustness summary belongs in §7, not abstract.

A standard AJAE abstract gives the question (1 sentence), the design (1–2), the headline numbers (1–2), and the contribution (1). Everything else is paper-body content.

**M2. Abstract first sentence is the same as §1 first sentence (L40 vs L56).**

Verbatim duplication. AJAE referees often note this as a stylistic tell. It's not a structural defect, but Cochrane-style guides explicitly flag it (the abstract should pose the question in its own voice; the intro should expand and contextualize). With both currently identical, the intro's first sentence does no additional work — and the abstract loses the rhetorical opportunity for a sharper opener.

**M3. The "we reject the AHM separability null" claim is italicized + isolated (L42), which is appropriately strong, but the conditional structure is now confused.**

The italicized sentence at L42 reads correctly given F1 not-fired. However, the immediately following clause ("A joint F1–F2 null would have been a precise complement to LaFave-Thomas 2016; under the realized F1 confirmation, the wealth-biased liquidity channel is supported") is a counterfactual conditional that an abstract should not be carrying. Abstracts assert; conditionals belong in §6 (which already has them at L363). Reviewer-grade question: why is the abstract telling me what *would have* been concluded under a different empirical realization?

**M4. The four-claims-vs-body cross-check is mostly fine, but two abstract claims have weakened body support:**

- (a) The pass-through claim "−12.0% rent-cost pass-through" is correctly framed in the abstract as "an aggregate-equilibrium implication outside the household-model core." §6 L363 confirms `p = .133` for $\hat\beta_5$, i.e., **statistically insignificant**. The abstract reports the magnitude but elides the p-value. An R1 referee will note this. The current framing ("$-12.0\%$ pass-through ... outside the household-model core") is defensible, but a fair reading is that the abstract is over-claiming on a statistically null estimate.
- (b) The op-cost number `−3.98M KRW` at T1 carries `p = .057` in both the abstract and §6 L359 — i.e., marginal at the 5% level. The abstract sells this as "consistent with $(S,s)$-band disinvestment" without flagging that the wider-bandwidth T3 estimate "attenuates to approximately zero ($p > .50$)" (L359). The implied robustness across bandwidths does not exist; the result is bandwidth-fragile. An AJAE referee will spot this when they read §6.

---

## MINOR issues (polish)

- **m1.** L40 contains `$p\!=\!.041$` and `$p\!=\!.057$` (LaTeX-spaced) but the body uses both styles (`$p = .041$` at L350 and `$p\!=\!.041$` at L64). Pick one and be consistent.
- **m2.** "We test this at Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS), exploiting the Small-Farmer Flat Payment (SFFP)" — two acronym introductions plus a citation triplet inside the second sentence. Reads heavy. AJAE prefers the policy name once with abbreviation, then the abbreviation thereafter; the abstract has space to defer the Swiss/U.S./EU citations to the intro.
- **m3.** The keywords on L45 lead with "Agricultural Household Model" before "regression discontinuity" — AJAE keyword convention typically front-loads method terms for indexing. Consider re-ordering (RD/DiD first, then AHM/separability, then policy/region).
- **m4.** The ADR-0001/0002 footnote on L40 inside the abstract is unusual; AJAE abstracts almost never carry footnotes. Move the pre-registration disclosure to §4 (where it is already covered at L62, L339).
- **m5.** "First AHM-separability test at a per-farm flat-rate direct-payment cutoff and the first DiD-RD evidence on the Korean PIDPS" (L40) — the dual "first" is fine but reads as marketing. AJAE prefers the contribution stated once cleanly; consider dropping the "first DiD-RD on Korean PIDPS" sub-clause (the AHM-separability claim is the load-bearing one).
- **m6.** The abstract uses three distinct hedging modes ("consistent with," "supported," "we reject"). The reject claim is the strongest; the other two are weaker. Reviewers want one stance per outcome, not three intensities in one paragraph.

---

## Specific line-numbered fix locations

| Line | Issue | Severity |
|------|-------|----------|
| L40 (abstract body) | ~370–394 words; trim to ≤200; ideally ≤150 | MAJOR (M1) |
| L40 sentence 1 | Verbatim duplicate of L56 (§1 first sentence) | MAJOR (M2) |
| L40 (Two AHM extensions clause) | Move to §1 intro paragraph 2 | MAJOR (M1) |
| L40 (pre-specification + ADR footnote) | Remove from abstract; covered in §4 | MAJOR (M1, m4) |
| L40 (robustness 2.2% / no α=.05 crossing) | Move to §7.1 only | MAJOR (M1) |
| L40 ($-12.0\%$ pass-through) | Flag statistically insignificant or drop | MAJOR (M4a) |
| L40 ($-3.98$M T1 op_cost) | Either acknowledge T3 attenuation or drop the "consistent with" hedge | MAJOR (M4b) |
| L42 conditional counterfactual | Cut "A joint F1–F2 null would have been..." | MAJOR (M3) |
| L367 footnote `p = .033` | Update to `p = .041` (match Wave 7) | **CRITICAL (C1)** |
| L447 entire paragraph (Conclusion) | Refresh ALL Wave-5 numerics to Wave-7 (`+1,089` → `+1,122`; `p=.033` → `p=.041`; gradient `1,089→410→393→−101→0` → match §6 L350; `−4.18M p=.047` → `−3.98M p=.057`; `−11.1%` → `−12.0%`) | **CRITICAL (C1)** |
| L45 keywords | Re-order method-first | MINOR (m3) |
| L40 various | Standardize `p\!=\!` vs `p = ` | MINOR (m1) |

---

## Cross-check summary (Q5 from prompt)

| Claim in abstract | Body location | Match? |
|---|---|---|
| Pure-tenant `+1,122` m² T2 `p=.041` | L64, L339, L350, L355 | YES (consistent everywhere in §1–§6 except L367 footnote which still says `.033`) |
| Op_cost `−3.98M` KRW T1 `p=.057` | L64, L359 | YES |
| Pass-through `−12.0%` | L363 (gives `$-144{,}027$ KRW, p = .133`) | MAGNITUDE matches; abstract omits p-value |
| "First AHM-separability test at per-farm flat-rate cutoff" | L60, L66 | YES |
| "we reject the AHM separability null" | L367 headline finding | YES on substance, but L367 footnote cites wrong p-value |
| Wave-5 numbers `+1,089 / −4.18M / −11.1%` | **L447 Conclusion** | **NO — Conclusion is stale, contradicts the abstract** |

---

## Score: **6.5 / 10**

Breakdown:
- Question-first: 9/10 (clear, but verbatim with §1)
- Methods named: 9/10 (DiD-RD, ITT, statutorily-eligible all present)
- Magnitudes quantified: 8/10 (all three present, but missing p on pass-through, missing T3 attenuation on op_cost)
- Contribution stated: 8/10 (first AHM-sep test at flat-rate cutoff is stated; could be tighter)
- Cross-check with body: **4/10** (CRITICAL: L367 footnote and L447 Conclusion still on Wave 5 numbers)
- Length discipline: **3/10** (~2.5× AJAE house norm)
- Hedging calibration: 7/10 (reject claim is right, but conditional counterfactual at L42 should go; pass-through over-claim at the magnitude-only level)

**Path to ≥8/10:** Close C1 (mechanical Wave-7 refresh of L367 footnote + L447) and trim length per M1 (target ≤200 words by cutting the four flagged clauses).

---

*Lens 1 audit complete. Hand off to Lens 2 (introduction).*
