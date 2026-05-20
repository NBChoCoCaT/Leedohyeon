# Lens 1: Abstract Audit (Post-Phase-1)
**Date:** 2026-05-20
**Manuscript:** paper/en/main.tex (abstract = lines 32–35)
**Reviewer focus:** Abstract only (with body cross-check)
**Compared to previous review:** baseline 6/10 → **8.5/10** (Δ = +2.5)

## Score: 8.5/10

Just hits the Phase-1 target (≥8.5). One MAJOR (length overrun) and the somewhat-buried policy implication keep it below the AJAE submission threshold of 9.0. All three initial-review CRITICALs are resolved; two of four initial-review MAJORs are fully resolved, one is partially resolved, one remains.

## Rubric checklist

| # | Criterion | Status |
|---|-----------|--------|
| 1 | First sentence states/motivates the question | PASS — opens with Korea PIDPS institutional context and contrasts per-farm flat-rate with U.S./EU CAP area-proportional schedules. Frames *why* this cutoff is informative. |
| 2 | Identification method NAMED (DiD-RD + symmetric screening) | PASS — "difference-in-differences regression-discontinuity design … applying symmetric observable-eligibility screening on both sides." |
| 3 | Three headline magnitudes quantified | PASS — +1,151 m² (p=.036), −13.7% (p<.10), −3.57M KRW (with multiple-testing caveat). |
| 4 | One-sentence CONTRIBUTION vs Kirwan/Ciaian | PASS — final sentence: "per-farm flat-rate payment design itself is the policy lever that severs the per-acre landlord-capture channel." |
| 5 | Policy implications preview | PARTIAL — implication is embedded in the same closing sentence as the rejection statement; not a stand-alone forward-looking line. |
| 6 | Word count 150–200 (AJAE typical) | FAIL — 228 prose words (264 incl. inline numerics like "+1,151"); ~14% over the upper bound. |
| 7 | Hedging proportionate (AHM scope + (S,s) honesty) | PASS — rejection scoped to "credit-constrained non-pure-owner subpopulation"; (S,s) result honestly described as "directionally consistent … not individually significant after multiple-testing correction." |
| 8 | Cross-check with body | PASS — all numeric claims match §3, §4, §5, §6, §7 verbatim. |

## CRITICAL findings

*None.* All three initial-review CRITICALs (C1 AHM-null opening, C2 missing contribution, C3 missing policy preview) are resolved.

## MAJOR findings

- **MAJOR-1 (Length overrun, 228 words vs ≤200 AJAE-typical).** The body of the abstract runs ~228 prose words; including the inline math/numeric tokens it reads as ~260+. AJAE's published abstract style cluster is 150–200. Recommended trim targets:
  - The two-extension setup sentence ("Two AHM extensions yield falsifiable predictions: wealth-biased liquidity … F2, auxiliary.") spends ~38 words on theoretical scaffolding. Compress to one clause: "We pre-specify two falsification tests: a monotone-in-tenancy gradient on own-cultivated area (F1, primary) and a hired-labor margin response (F2, auxiliary)." (~25 words; saves ~13.)
  - The four-bin gradient string "+1,151 → +438 → +258 → −52 → 0" duplicates the +1,151 already given as the headline pure-tenant effect. Either drop the +1,151 from the gradient string or drop the standalone "pure-tenant own-area response is +1,151 m² at T2 (p=.036)" sentence and let the gradient carry it. (~10 word savings.)
  - The closing sentence is two independent clauses joined by ";". Splitting into two crisper sentences (rejection statement; then policy lever) would also let the policy implication stand on its own (addresses Resolved-PARTIAL on Rubric #5).

- **MAJOR-2 (Policy implication subordinated to rejection clause).** Rubric #5 is the weakest pass. The current closing reads as one compound sentence in which the policy line is grammatically a coordinate clause after the AHM-rejection statement: "We reject AHM separability … via the wealth-biased liquidity channel; the per-farm flat-rate payment design itself is the policy lever …". For AJAE policy-journal readers (and for the journal-cascade fallback to *Food Policy*), the policy implication deserves its own sentence and ideally one forward-looking word ("This identifies the per-farm flat-rate design — distinct from area-proportional U.S./EU schedules — as the policy lever that severs the landlord-capture channel."). This also clears word budget if MAJOR-1 trims are taken.

## MINOR findings

- **MINOR-1 (Citation density in abstract).** Four `\citep{…}` calls (Kirwan, Baldoni-Ciaian, Carter-Olinto, Eswaran-Kotwal) inside a 228-word abstract is at the upper end of AJAE convention. The Carter-Olinto and Eswaran-Kotwal citations could be dropped from the abstract and retained in §2 — the F1/F2 labels alone carry the falsification structure for an abstract reader. Saves ~6 effective words and reduces visual noise.

- **MINOR-2 (Hedging on −13.7% pass-through reads as understated).** "$p < .10$" understates what is, in context, the most novel claim in the paper (sign reversal vs Kirwan and Baldoni-Ciaian). Consider giving the exact p-value as elsewhere in the body, or noting "directionally robust at T2 (−11.7%)" to convey corroboration. (The body §6 already cites the T2 estimate of −11.7%; the abstract reports only T1.)

- **MINOR-3 (Reference-cohort ambiguity in gradient).** The gradient string "+1,151 → +438 → +258 → −52 → 0" has five entries; abstract reader without the bin definitions in front of them may not immediately parse "five bins" vs "four non-pure-owner bins (+ one reference)." A parenthetical "(pure-tenant → low-owner → mixed → high-owner → pure-owner [ref])" or a one-clause label improves readability with ~10 added words — defer if MAJOR-1 wordcount trim is binding.

## Resolved from initial review

- **[Resolved] C1 (first sentence was AHM-null definition).** First sentence now opens with the Korean PIDPS institutional context and the per-farm-flat-rate / area-proportional contrast. Motivates the question rather than defining the theory.
- **[Resolved] C2 (no contribution sentence).** Closing sentence now names the contribution: per-farm flat-rate design severs the landlord-capture channel.
- **[Resolved] C3 (no policy-implications preview).** Kirwan/Ciaian reversal is now named explicitly with magnitudes (+25% U.S., +46–55% EU vs −13.7% Korea), and the per-farm flat-rate policy lever appears in the closing sentence. Partial only because the implication is grammatically subordinate (see MAJOR-2).
- **[Resolved] MAJOR (incomplete quantification).** All three headline magnitudes (F1 +1,151 m², rent pass-through −13.7%, (S,s) op_cost_ex_rent −3.57M) are now quantified with p-values.
- **[Resolved] MAJOR (AHM rejection buried).** Rejection now appears in the explicit final sentence and is properly scoped to "credit-constrained non-pure-owner subpopulation," matching §5 (line 377) and §7 (line 481).
- **[Partially resolved] MAJOR (word-budget on identification trivia).** The identification sentence is tighter than the pre-Phase-1 version, but the abstract is still ~14% over the AJAE budget — see MAJOR-1.
- **[Partially resolved] MAJOR (theoretical scaffolding heavy).** Reduced but the two-extension paragraph still consumes ~38 words on F1/F2 setup. See MAJOR-1 first sub-bullet.

## Verbatim abstract

> Korea's 2020 Public-Interest Direct Payment Scheme transfers 1.2 million KRW per year to smallholders below a 0.5-ha cultivated-area cutoff under a per-farm flat-rate design, distinct from the area-proportional U.S. and EU CAP schedules [Kirwan 2009; Baldoni-Ciaian 2023]. We test the Agricultural Household Model's separability null at this cutoff via a difference-in-differences regression-discontinuity design on the Farm Household Economic Survey panel (N = 11,010 farm-years, 2,776 farms, 2018–2022), applying symmetric observable-eligibility screening on both sides. Two AHM extensions yield falsifiable predictions: wealth-biased liquidity [Carter-Olinto 2003] predicts a monotone-in-tenancy gradient on own-cultivated area (F1, primary); implicit-labor supervision [Eswaran-Kotwal 1986] predicts a hired-labor margin response (F2, auxiliary). The pure-tenant own-area response is +1,151 m² at the T2 bandwidth (p = .036), monotone-decreasing across four non-pure-owner bins (+1,151 → +438 → +258 → −52 → 0). The per-farm flat-rate design reverses the rent-cost pass-through documented for area-proportional schedules: pass-through is −13.7% at T1 (p < .10), against +25% in the U.S. [Kirwan 2009] and +46–55% in the EU [Baldoni-Ciaian 2023]. The operating-cost-net-of-rent response is −3.57 M KRW at T1 (directionally consistent with (S,s) inaction; not individually significant after multiple-testing correction). We reject AHM separability at the 0.5 ha cutoff for the credit-constrained non-pure-owner subpopulation via the wealth-biased liquidity channel; the per-farm flat-rate payment design itself is the policy lever that severs the per-acre landlord-capture channel.

## Cross-check matrix

| Abstract claim | Body location | Matches? |
|---|---|---|
| 1.2 M KRW/year transfer, per-farm flat-rate, 0.5-ha cutoff | §1 / §3.1 institutional eligibility | YES |
| Distinct from area-proportional U.S./EU CAP | §6 line 371, §7 line 472 | YES |
| DiD-RD at 0.5 ha cutoff | §3 line 54, §4 line 317 | YES |
| Symmetric observable-eligibility screening on both sides | §3 line 54, §4 line 317 | YES |
| N = 11,010 farm-years, 2,776 farms, 2018–2022 | §3 line 54, §4 lines 307, 321; footnote on `01d_symmetric_clean.R` log 2026-05-20 | YES |
| F1 (monotone tenancy gradient on own area, primary) | §2 line 50, §5 line 354 | YES |
| F2 (hired-labor margin response, auxiliary) | §2 line 50, §5 results not block-quoted but referenced | YES |
| Pure-tenant +1,151 m² at T2 (p = .036) | §5 line 354 ("+1,151 m² (p = .036)"); §7 line 481 | YES |
| Four-bin gradient +1,151 → +438 → +258 → −52 → 0 | §5 line 354, §6 line 377, §7 lines 470 and 481 | YES |
| Low-owner +438 m² at T2 (p = .047) | §5 line 354 | YES (consistent though abstract drops the p-value) |
| Rent pass-through −13.7% at T1 (p < .10) | §3 line 56, §4 line 347, §6 line 371, §7 line 472, §8 line 481 | YES |
| Reverses U.S. +25% (Kirwan) and EU +46–55% (Baldoni-Ciaian) | §6 line 371, §7 line 472 | YES |
| op_cost_ex_rent −3.57M KRW at T1, directionally consistent, NS with Holm | §3 line 56, §6 line 371, §7 line 470, §8 line 481 | YES |
| Rejection scoped to credit-constrained non-pure-owner subpopulation | §6 line 377 (headline finding), §7 line 470, §8 line 481 | YES — wording is consistent across §6/§7/§8 and abstract |
| Per-farm flat-rate severs landlord-capture channel | §7 line 472, §8 line 481 | YES |

No abstract claim is unsupported in the body. No body number contradicts the abstract.

## Word count

- **228 prose words** (excluding citation keys and `\label`/`\noindent` LaTeX commands).
- ~260 effective tokens including inline numerics like "+1,151", "−13.7%", "−3.57 M KRW", which AJAE counts as words.
- AJAE-typical target: 150–200. Overrun: ~14% on prose, ~30% on effective tokens.
- Recommended trim ≥30 words to hit upper-bound 200 (see MAJOR-1).

## Summary disposition

**Phase 1 target (≥8.5) MET.** AJAE submission target (≥9.0) **NOT YET MET**, blocked by word-count overrun and the subordinated policy implication. Both are 30-minute fixes; addressing MAJOR-1 and MAJOR-2 in tandem would lift this lens to 9.0–9.2.
