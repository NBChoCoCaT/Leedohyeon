# Seven-Pass Review Synthesis — `paper/en/main.tex`

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` (467 lines, 91 KB)
**Reviewers:** 7 forked subagents (parallel) → 1 synthesizer
**Approx token usage:** ~580k across 7 lenses (well above the skill's 80–120k estimate; this manuscript triggered a long, dense review)

---

## Executive verdict

**Overall state: REVISE-MAJOR.**

Composite score **≈ 6.4 / 10**. Below the AJAE first-submission gate (9.0 / 10 per `quality-gates.md`) and below the commit gate (8.0 / 10). The paper has a real identification result and a defensible theoretical contribution, but at least **five blockers** would draw immediate referee fire on submission and **two** (the missing headline tables and the `op_cost` ↔ `op_cost_ex_rent` notational drift) would be flagged by a desk editor before any referee is invited.

| Lens | Critical | Major | Minor | Score |
|---|---:|---:|---:|---:|
| 1. Abstract | 3 | 4 | 6 | **6.0** |
| 2. Intro | 3 | 6 | — | **6.5** |
| 3. Methods | 5 | 7 | 5 | **6.5** |
| 4. Results | 3 | 4 | — | **4.0** |
| 5. Robustness | 3 | 7 | 6 | **6.5** |
| 6. Prose | 4 | 10 | 9 | **6.5** |
| 7. Citations | 0 | 3 | 5 | **8.5** |
| **Overall** | **21** | **41** | **31+** | **6.4** |

The single weakest lens is **§6 Results (4/10)** because three load-bearing tables that the prose refers to (F1 four-bin gradient, pooled DiD-RD, CH4 rent-decomposition) are **not actually `\input{}`-ed in `main.tex`**. The single strongest is **Citations (8.5/10)** — Wave 7 PR #21 and the 2026-05-06 citation-verification pass have done their job.

---

## Cross-lens CRITICAL issues (resolve in this order)

The 21 lens-level CRITICALs collapse to **10 distinct root causes**. Highest-leverage fixes first.

| # | Lens(es) | Root cause | Why critical | Fix |
|---|---|---|---|---|
| **X1** | L4 #1, L3 C1, L6 C-3 | **Headline tables missing from main text + `op_cost` ↔ `op_cost_ex_rent` notational drift.** Three load-bearing tables (`tab_het_own_share_en.tex`, `tab_main_did_rd_en.tex`, `tab_ch4_rent_decomposition_en.tex`) exist in `scripts/R/_outputs_eligibility/` but are never `\input{}`-ed; the prose cross-refs to `Table~\ref{tab:appB-mapping}` which is defined in `online_appendix.tex` only. Same variable surfaces in five forms (`op_cost`, `op_cost_ex_rent`, "operating cost", "operating cost net of rent", "op_cost_ex_rent"); §4 line 315 says primary outcome is `op_cost`, §3/§5/§6 say `op_cost_ex_rent`. | Desk editor will reject before referees are invited if the headline outcome variable is ambiguous and the headline tables are absent. | (a) `\input{}` the three tables in §6. (b) Pick one canonical name and propagate. (c) Reconcile line 315 with §3/§5/§6. |
| **X2** | L4 #2 | **§4 prose contradicts Table 1 on the op_cost benchmark.** §4 line 317: "control 41.1M vs treated 13.6M, diff −27.5M". Table 1: 30.0M vs 8.4M, diff −21.6M. §6 inherits this and §8 propagates "−29% relative to 13.6M". | Numeric inconsistency between body prose and own descriptive table is an automatic referee finding. | Recompute relative-magnitude statements from Table 1 numbers (or fix Table 1). Trace which is correct against `scripts/R/_outputs_eligibility/` source. |
| **X3** | L3 C1 | **`$D_i$` symbol overloaded.** Table 1 row 1 says `$D_i = 1 \iff A_{2018,i} \le 5000$` (area-only). §4 line 311 says `$D_i$` is the three-criterion conjunction. Same symbol, two definitions, same paper. | Methods referee will write down Table 1 definition, then reach §4 and conclude the paper does not know its own treatment. | Rename area-only to `$D_i^{\text{area}}$` (use only in §7.1 robustness); reserve `$D_i$` for the conjunction throughout. |
| **X4** | L3 C2 | **"Sharp DiD-RD restored on the subset" is sample selection, not identification.** Dropping 194 treated-but-ineligible households purifies the **treated side** on owned-area (<15.5K m²) and off-farm income (<45M); control side gets no analogous screening. The estimand is no longer "ITT of eligibility" but "ITT on the subpopulation passing (ii)+(vi) on the treated side, vs. all area-ineligible controls". | This is the central identification claim of the paper. An asymmetric-sample RD framed as "sharp" will be rejected by a competent referee. | Either (a) apply same screening on the control side (correct fix), OR (b) reverse §7.1 framing — area-only design as primary, screened design as robustness. |
| **X5** | L3 C3 | **SUTVA defense via scalar Post FE is mechanically wrong.** Line 343 claims within-village spillovers are absorbed by "the time fixed effect"; eq. (1) line 330 only includes a scalar `Post_t` dummy, which cannot absorb village-by-time variation. | Operating-cost-net-of-rent and rent-cost outcomes are precisely the ones exposed to local rental-market clearing — the headline incidence-reversal result is in the SUTVA blast radius. | Either add `sgg_cd × Post` FE (consistent with §5.5 promise) and re-estimate, OR drop the claim and acknowledge SUTVA as an unresolved threat on outcomes touching the rental margin. |
| **X6** | L3 C5 | **Line 70: SFFP and ABP described as "mutually exclusive at the household level" but in the same paragraph the marginal household is described as receiving "1,200,000 KRW on the SFFP side AND 985,000 KRW on the ABP side".** Either the marginal household receives both (contradicting "mutually exclusive") or it doesn't (contradicting "AND"). | This sentence motivates the discrete-transfer jump that justifies the RD; an institutional-fact contradiction at the cutoff motivation undermines the whole policy framing. | Restate as: "discrete transfer jump of approximately 215,000 KRW per year = 1,200,000 SFFP − 985,000 counterfactual ABP". |
| **X7** | L5 C2 | **§7.1 area-only demotion narrative absent.** §7.1 reads to a hostile referee as "we trimmed 194 households until p < .05". The Wave 7 promotion was an institutional-fidelity move (align treatment indicator with statutory definition), not finding-driven (24-cell comparison showed 0/24 α=.05 crosses). The paper never explains this. | This is the easiest single-paragraph fix in the whole revision and the highest robustness-marginal-return move. | Add a 4-sentence preamble to §7.1: (i) Wave 5 baseline = area-only, (ii) Wave 7 promotion was institutional alignment with 8-criterion SFFP statute, (iii) 24-cell comparison showed 0/24 crosses at α=.05 — finding-invariant, (iv) area-only retained as robustness for area-pure-RD readers. |
| **X8** | L5 C1 | **HonestDiD breakdown $\bar M^* = 0$ admitted, defended in one sentence.** Line 398 acknowledges the M̄* breakdown but the entire defense is "event-study underpowered vs. pooled DiD-RD". A referee at AJAE will stop reading here. | The "no parallel trends violation that would overturn the result" claim is the load-bearing pre-trends defense. One sentence is insufficient. | Expand to a paragraph: (i) state the M̄* breakdown precisely, (ii) explain why event-study is underpowered (cluster N, post-period length), (iii) report pooled DiD-RD anti-conservative bound (Rambachan-Roth 2023 SD-bound at M̄=0.5), (iv) cite the 2018 placebo coefficients |t|<1 as bypass. |
| **X9** | L1 C2-C3 | **Abstract has no policy-contribution sentence and omits the −12.0% rent-cost pass-through reversing Kirwan +25% / Baldoni-Ciaian +46–55%.** This is the most novel, AJAE-justifying contribution and it never reaches the abstract. The abstract's word budget is spent on identification trivia (14.6% non-compliance, 2018 baseline freeze). | The AJAE editor's 90-second screen sees the abstract first. No contribution sentence + no policy magnitude = desk-reject risk. | Rewrite per Lens 1's suggested ≤200-word abstract: motivation (per-farm flat-rate vs per-acre), method (DiD-RD at 0.5 ha), three quantified headlines (F1 +1,122 m², op_cost −3.98M, rent-cost −12% reversing US/EU), one-sentence contribution. |
| **X10** | L4 #3 | **Spec B caption contradicts §7.2 prose.** Caption: "drop 2020, Post≥2021". Prose: "richer covariate vector (farm-type FE + education tier)". These are different robustness checks. | A reader cannot tell which Spec B was actually estimated. | Verify against R output, fix whichever is wrong. Confirm the §5 distinguishing-covariates sentence matches reality. |

---

## MAJOR cross-lens issues (second-round)

| # | Lens(es) | Issue | Cluster |
|---|---|---|---|
| Y1 | L1 M2, L2 M1+M2, L3 M4, L4 #6 | **Three-channel "tenant-driven land transition" framing is asserted in intro/abstract/discussion but never identified in §3 or estimated as a decomposition in §6.** Bargaining margin and composition margin are reduced-form coefficients on separate outcomes, not "channels" in the structural sense. | Project framing ≠ paper delivery |
| Y2 | L2 C2-C3, L1 C2, L4 #4 | **Headline magnitudes (+1,122 m², −3.98M, −12%) are quarantined in intro ¶5 instead of ¶1; contribution paragraph is ¶6/7 of 7.** Editor desk-screen never reaches them. | Intro architecture |
| Y3 | L3 M3, L5 (placebo-cutoffs paragraph) | **McCrary $p=.18$ framed as "test passes".** Cattaneo-Jansson-Ma `rddensity` not reported. Modern RD convention rejects this framing. | Density-test rigor |
| Y4 | L3 (assumption ledger), L5 | **Covariate continuity at the cutoff (CCT 2014) is not tested.** Only differential-attrition is. | RD diagnostics |
| Y5 | L5 M (sgg_cd promise), L3 C3 | **Sub-district (`sgg_cd`) clustering robustness promised in §5 line 339 but never delivered in §7.** Dangling promise + reinforces SUTVA gap. | Promise-delivery drift |
| Y6 | L6 M-1, L2 (density issue) | **15+ sentences ≥ 50 words; ~30 sentences > 35 words; em-dash parentheticals stacked 3+ deep.** Intro at 1,520 words at AJAE upper bound — problem is density not length. | Prose mechanics |
| Y7 | L6 M-9 | **Line 446 "is sufficient to shift the rental–ownership margin" is a structural-mechanism claim from a reduced-form ITT coefficient.** Soften to "is associated with". | Hedging |
| Y8 | L7 (3 MAJOR), L4 (table×caption mismatches) | **10 unused .bib entries (α3 re-scope debris)** + Zimmert-Zorn year drift (.bib key suffix 2022, year field 2023) + Kazukauskas (S,s)-bridge framing risk. | Bibliography polish |
| Y9 | L3 M5 | **Pure-owner cohort = 52% of treated, contributes zero to F1 identification.** The headline "we reject AHM separability for Korean small farms" is identified off the 48% non-pure-owner cohort. | External validity / claim scope |
| Y10 | L3 M6 | **(S,s) anchor is necessary-not-sufficient.** Magnitude $-3.98M$ ≈ $-3.3 × T_{SFFP}$ exceeds pure (S,s) absorption capacity ($T_{SFFP} = 1.2M$); paper does not address whether this requires a stronger mechanism. | Theory–data bridge |

---

## MINOR polish (bulleted)

- L1: jargon "load-bearing" → "primary/auxiliary"; missing USD-equivalent for SFFP transfer; "falsifiable" defensive phrasing in abstract.
- L2: pre-specification claim buried in footnote — credibility-revolution move deserves main text; one M.3 "treatment-indicator alignment" sold as contribution, demote to robustness.
- L3: $B = 999$ Rademacher refits (line 339) below AJAE submission convention ($B = 9{,}999$); Holm family size unspecified; weighted-DiD-RD promise at line 317 has no §7 deliverable.
- L4: T3 bandwidth cited as two different values (h≈3,300 vs h≈1,710); F2 "small and near zero" has no magnitude given.
- L5: wild bootstrap actual p never tabulated; multi-RV owned-farmland test at p=.10 glossed; differential-attrition paragraphs split across §7.
- L6: 30+ minor consistency items — "(S,s)" text vs math, "statutorily-eligible" hyphen, "AHM-separability" hyphen, "F1 fires/not-fired" tense, Holm "correction" vs "adjustment".
- L7: ~10 .bib entries unused (Sandmo 1971, Blundell-Pistaferri 2003, AbelEberly 1994, etc. — α3 re-scope artifacts); Pitt-Khandker / Foster-Rosenzweig relevance stretch.

---

## Contradictions between lenses

| Tension | Lens A | Lens B | Resolution |
|---|---|---|---|
| **Trim vs. expand the intro?** | L2 says intro is too long (1,520w → 825w target) | L6 says sentences are too long (split → more sentences) | **Both apply, reconcilable:** cut CONTENT (¶4 strategy detail belongs in §5; ¶2 AHM over-explanation; M.3 "indicator alignment" contribution), then split the surviving long sentences. Net: fewer words, more sentences. |
| **Promote headline numbers in abstract vs. keep abstract ≤200w?** | L1 wants the −12% rent pass-through + F1 +1,122 m² in the abstract | L6 wants abstract ≤200 words | Reconcilable via tight number prose ("F1 +1,122 m² at T2, p=.041, with monotone tenancy gradient; op_cost −3.98M (−29%, p=.057); rent pass-through −12%, reversing Kirwan +25% / Baldoni-Ciaian +46–55%"). The current 270-word abstract loses words on identification trivia, not on numbers. |
| **Three-channel framing: drop or formalize?** | L3 M4 says drop OR formalize the decomposition | L4 #6 says the framing is invisible because tables aren't in main text | Both point to the same fix: if the project's three-channel monotone-gradient claim is load-bearing for AJAE (per CLAUDE.md §Theory), then the F1 four-bin gradient + CH4 rent-decomposition + unit_rent_price tables MUST be in main text §6, and §3 must derive the decomposition formally. Currently the framing lives in CLAUDE.md and `master_supporting_docs/`, not in the paper. |
| **AHM "we reject" claim: triple-repeated overclaim or core contribution?** | L6 C-1 says under-hedged, repeated 3× verbatim | L1 says the contribution is under-claimed in abstract | These are reconcilable: hedge the claim (add "at the 0.5 ha cutoff, via F1, for the 48% non-pure-owner subpopulation") AND state it clearly once with magnitudes. The current pattern (state it three times without scope) is the worst of both. |

---

## Revision plan (recommended order)

**Phase 1 — Blockers (5–8 days focused work):**

1. **X1 + X2:** Reconcile `op_cost` ↔ `op_cost_ex_rent` across §3, §4, §5, §6. Pick canonical name. Recompute the 41.1M vs 30.0M discrepancy from `scripts/R/_outputs_eligibility/`. **This is the single highest-leverage edit in the whole revision.**
2. **X1 (b):** `\input{}` the three missing headline tables (`tab_het_own_share_en.tex`, `tab_main_did_rd_en.tex`, `tab_ch4_rent_decomposition_en.tex`) into §6.
3. **X3 + X6:** Rewrite Table 1 row 1 + line 70 SFFP/ABP exclusivity. Symbol cleanup (`$D_i$` vs `$D_i^{\text{area}}$`).
4. **X4:** Decide on identification framing — symmetric screening (correct) vs. reverse §7.1 (faster). Document the decision in `quality_reports/specs/`.
5. **X5 + Y5:** Deliver `sgg_cd × Post` FE robustness; reword SUTVA defense to match the spec actually estimated.
6. **X7:** Write the §7.1 demotion narrative (4 sentences).
7. **X8:** Expand HonestDiD breakdown defense (paragraph).
8. **X9:** Rewrite abstract to ≤200 words with contribution + 3 magnitudes.
9. **X10:** Verify Spec B against R output; fix caption or prose.

**Phase 2 — Major polish (~3 days):**

10. **Y2:** Promote contribution paragraph to ¶4 of intro; move headline numbers into ¶1.
11. **Y1:** Decide three-channel framing: drop or formalize the decomposition with delta-method SEs.
12. **Y3 + Y4:** Add CJM `rddensity` test + CCT-2014 covariate continuity checks to §7.
13. **Y6:** Sentence-splitting pass on the 15+ long sentences flagged by Lens 6.
14. **Y9:** Reframe AHM rejection claim to "48% non-pure-owner subpopulation".
15. **Y10:** Tighten (S,s) prediction magnitude range OR acknowledge necessary-not-sufficient.

**Phase 3 — Minor polish (~1 day):**

16. L6 minor consistency (statutorily-eligible hyphen, (S,s) math mode, F1 fires tense).
17. L7 unused-entry decision (cut or reintegrate); Zimmert-Zorn year fix.
18. Lens 2 footnote-to-main-text move (pre-specification claim).
19. Lens 5 wild-bootstrap $B$ → 9,999; tabulate actual p-values; Holm-adjusted p-value column.
20. L1 + L4 jargon trim ("load-bearing", "falsifiable").

**Post-revision gate:** Re-run `/seven-pass-review` after Phase 1+2. Composite target ≥ 8.5/10 before any AJAE submission attempt.

---

## What this review does NOT cover

- **Numeric reproducibility against `scripts/R/_outputs*/`** — that's `/audit-reproducibility`'s job. The 41.1M vs 30.0M discrepancy in X2 was caught here only because it surfaced in prose; a full numeric audit would find more.
- **R code quality of the analysis pipeline** — that's `/review-r`'s job.
- **TikZ / figure source code** — none touched here.

Consider running `/audit-reproducibility paper/en/main.tex scripts/R/_outputs_eligibility/` and `/review-r scripts/R/03b_did_rd_eligibility.R scripts/R/04_robust*.R` as the natural cross-artifact follow-up before Phase 1 begins.

---

## Token-budget report

```
Seven-pass review complete.
Subagents: 7 (parallel) + 1 synthesizer.
Approx token usage: ~580k (high — manuscript is 91 KB; each lens read the full file).
Runtime: ~5 min wall-clock.
Output: 7 lens reports + this synthesis in
  quality_reports/seven_pass_main_en/
```
