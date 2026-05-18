# Lens 6 (Prose quality) — Seven-Pass Review

**Score:** 6.5/10

The α3 framing is intellectually disciplined and the new PR #7 prose blocks (aggregation note, magnitude calibration sub-section, F1/F2 reframe, ITT/HonestDiD paragraph) are substantively correct. The dominant prose problem is **sentence length**: §1 Introduction and §3 are saturated with 45–90 word sentences, several with stacked em-dashes and three or more parenthetical clauses. The Falsification description (§3.4) is logically dense but reads as bullet-debt — the `[F1 (load-bearing)]`, `[F1 not fired + F2 null]`, `[F1 fires]` labels are typographically inconsistent with `[F1]` / `[F2]` above them and the semantics of "fires" / "not fired" invert mid-list. Active-vs-passive balance is acceptable. Hedging is mostly proportionate but the abstract italicized rejection sentence ("We reject AHM separability for Korean small farms.") prematurely commits to a result the §5/§6 placeholders cannot yet support.

---

## CRITICAL prose issues

1. **Abstract overclaim vs. placeholder Results.** Lines 40 and 119 both contain the italicized declarative *"We reject AHM separability for Korean small farms."* §5 Results (L280–284) is a TODO stub. Until headline results are written, the unconditional past-tense rejection in the abstract violates hedging discipline; it should read *"We test the AHM separability null..."* with the conclusion conditional on the forthcoming §5 evidence, or be marked clearly as a *preliminary* / *expected* finding (L62 already uses "Preliminary results from the forthcoming §5..."; the abstract and §3.1 close should match).

2. **§3.4 Falsification description list is logically inconsistent (L250–257).** The `description` block has five labeled items: `[F1]`, `[F2]`, `[F1 (load-bearing)]`, `[F1 not fired + F2 null]`, `[F1 fires]`. The first `[F1]` (L252) says F1 *firing* means the gradient test is *rejected*. The last item `[F1 fires]` (L256) then says F1 *firing* means *"the wealth-bias-channel signature is absent"* and the paper *"repositions as a precise null estimate"* — semantically the same event, but the prose reads as if it were a new outcome. Worse, item `[F1 (load-bearing)]` (L254) re-defines F1 a second time after item `[F1]` already defined it. Recommend collapsing to three items: (i) F1 (defined once, with the "fires = trigger condition met = wealth-bias rejected" semantics fixed); (ii) F2 (informative-not-rejecting); (iii) a Joint-outcomes paragraph (outside the `description` block) covering the two modal outcomes.

3. **§3.4 "F1 fires" / "F1 not fired" terminology (L254–256) is confusing.** In smoke-detector usage "fires" means "alarm triggered." Here it means "rejection trigger condition met = reject the wealth-bias hypothesis." Readers will repeatedly invert this. Either replace "fires" with explicit "rejection trigger condition met" / "rejection trigger not met," or add a parenthetical at first use: *"F1 fires (the rejection trigger condition is met) when..."*.

4. **Broken cross-ref (L65 vs. L56).** Footnote 2 at L56 says *"the F1+F2 pre-registration"* but the §1 ¶6 footnote (L64 area) and §3.4 (L253) demote F2 to "informative, not rejecting" — i.e., F2 is not a pre-registered *rejection* trigger. The early "F1+F2 pre-registration" phrasing leaks the pre-A5 framing and contradicts the now-load-bearing F1-only stance.

---

## MAJOR prose issues

5. **§1 ¶1 (L54) is a single 290-word, 5-clause paragraph that doubles as a sentence-chain.** The first sentence (66 words) carries three subordinate clauses ("replacing… of which… is the per-farm flat-rate component"). The footnote inside it inserts another 50-word aside. Recommend splitting after "Article 10 of the Act…" into two paragraphs (institutional vs. research-question).

6. **§1 ¶3 (L58) is a four-reference "Versus X / Versus Y" walk that runs ~440 words in a single paragraph.** Each `\emph{Versus...}` block is itself a 60–80 word sentence. The cumulative density makes the contribution narrative hard to extract. Recommend either four micro-paragraphs (one per comparator) or a contribution table.

7. **§3.2 "Aggregation note" italic inline label (L172) is awkward inside a math-heavy paragraph.** The phrase *"\textit{Aggregation note.}"* sits mid-paragraph after eq:CO-1 and is followed by ~90 words of explanatory prose. It reads as a half-paragraph that should either (a) become a proper `\paragraph{Aggregation note.}` block (consistent with the surrounding `\paragraph{Setup.} \paragraph{Separability theorem.}` structure), or (b) move into a footnote. Current inline italic is the worst of both worlds.

8. **§3.4.1 magnitude calibration footnote (L224) is one sentence of 64 words.** The 50%-LTV reconciliation footnote works but the sentence *"The two figures of ${\sim}50$M~KRW (purchase-price) and ${\sim}25$M~KRW (down-payment-equivalent) referenced across the literature on Korean farm-equipment financing reconcile under typical 50\% loan-to-value installment terms: a 50M~KRW machine financed at 50\% LTV requires a 25M~KRW down payment, with the balance amortized over the equipment lifetime."* should be split at the colon.

9. **§3.4.1 ¶2 "Transfer-to-adjustment-cost ratio" (L226) closes with a 51-word sentence on annual-flow vs. lump-sum interpretation.** Split after "one-shot capital threshold" — the multi-year cumulative ratio is a separate point.

10. **§4 Data MDIS footnote (L266) is 4 sentences crammed into one footnote (~95 words).** The MDIS URL, the internal verification log date, the synthetic generator path, and the AEA DCAS v1.0 reference are four distinct ideas. Either split into two footnotes (data source / replication path) or restructure as a numbered list.

11. **§3.1 close A8 paragraph (L151) "Estimand and pre-period inference" is logically tight but the last sentence is 49 words.** *"Parallel-trends inference rests on the 2018–2019 pre-period gap; following Roth (2022), single-pre-period pretests do not certify the parallel-trends restriction and we therefore report Rambachan-Roth (2023) sensitivity bounds (HonestDiD $\bar M$) on $\hat\beta_1$ and $\hat\beta_3$ in the robustness appendix."* Split after "do not certify the parallel-trends restriction."

12. **§B.1 Step-3 footnote on partition rule (L203–214) is a 130-word footnote sentence-chain.** Break into three short sentences (definition / ADR archive reference / quintile-vs-four-bin tradeoff).

13. **Passive voice clusters in §3.4 (L259) "equilibrium rent caveat".** *"These observed rent movements are consistent with but not derived from our AHM-extension model. The micro mechanism is: rented-area contraction... aggregates into a reduced rental-demand schedule."* The colon-then-fragment is awkward; recommend *"The micro mechanism runs as follows. Rented-area contraction... aggregates into..."*.

---

## MINOR polish

14. **L40 abstract**: "1.2 million KRW per-farm flat-rate transfer" — the hyphenation chain "per-farm flat-rate" is correct as a compound modifier but appears with subtly different spacing in §1 ¶1 ("per-farm flat-rate component"). Standardize.

15. **L40 abstract**: "deep within the $(S,s)$ inaction band and the wealth-bias rejection region simultaneously" — "simultaneously" is redundant given "and."

16. **L54**: "approximately one million Korean farms receive PIDPS payments annually under a total budget of 2.3 trillion KRW" — sourced? No citation. Either cite the MAFRA budget document or hedge with "approximately."

17. **L56**: "the bargaining and rental-incidence margin of price adjustment is demoted" — "is demoted" is passive; "we demote" would mirror the active first-person tone of the surrounding paragraph.

18. **L62**: "1.2 million KRW per year, the relevant magnitude is" — comma splice risk; rewrite as "1.2 million KRW per year; the relevant magnitude is..."

19. **L64**: Sentence opener "This paper makes three contributions." is fine but the next-line `\ \emph{Theoretically},` has a leading `\ ` (stray space command) on L65 — likely artifact of the PR #7 insertion. Remove the leading `\ `.

20. **L172 §3.2 aggregation note**: "the implied estimand is $\partial \mathbb{E}[A_{own,i} \mid \text{eligibility window}]/\partial T_{SFFP}$, i.e., an average over the $\varphi(W_i^*)$-weighted marginal types" — "i.e." after a math display reads choppy; consider "that is,".

21. **L226**: "Both endpoints sit comfortably inside the 5–10\% inaction band" — "comfortably" is informal hedging; replace with "well within" or drop.

22. **L228 footnote**: "% FILL post-§5 P3: cross-reference exact table cell." — visible in source; will not render but should be tagged or removed before submission.

23. **L259**: "P3b-2 reports estimates in the range $-130$ to $-48$ KRW/m²" — "P3b-2" is an internal pipeline tag, not a publication-grade reference. Replace with section reference (e.g., "robustness §X.Y reports") or drop.

24. **§B.1 L228**: parenthetical "(down-payment-equivalent)" appears for $\tau \approx 25 \times 10^6$ KRW but the main-text §3.4.1 (L224) gives the *same* gloss; redundant across artifacts. Pick one site.

---

## Specific PR #7 new prose audit

| Section | Line | Issue | Severity |
|---|---|---|---|
| §1 ¶6 Choi-Mun cite differentiation | L64 | Bib swap works — `author` field is "Choi, Min-young and Mun, Han-pil" so `\citet` renders cleanly as "Choi and Mun (2025)". No Korean glyph leak. Sentence itself reads smoothly. | OK |
| §1 ¶7 stray leading `\ ` | L65 | Line starts with `\ \emph{Theoretically},` — likely PR #7 paste artifact; renders as extra horizontal space at line start | MINOR |
| §3.2 A1 aggregation note | L172 | Inline italic "*Aggregation note.*" mid-paragraph is awkward; recommend `\paragraph{}` block or footnote | MAJOR |
| §3.1 close "Estimand & pre-period inference" | L151 | Last sentence 49 words; split at semicolon | MAJOR |
| §3.4.1 magnitude calibration | L221–228 | 50%-LTV footnote runs 64 words; "Transfer-to-adjustment-cost ratio" para closes with 51-word sentence | MAJOR |
| §3.4 F2 demotion | L253 | "Informative, not rejecting" label inside `description` block works; prose ~120 words in one item — could split | MINOR |
| §3.4 F1 fires/not fired semantics | L254–256 | Terminology inverts mid-list; the three "F1..." items are inconsistent | CRITICAL |
| §4 Data MDIS footnote | L266 | Four ideas in one footnote (~95 words); split | MAJOR |
| Abstract L40 italic rejection | L40 | Premature given §5 stub | CRITICAL |
| §3.1 italic rejection (echo) | L119 | Same overclaim; remove or hedge | CRITICAL |

---

## Long-sentence flag list (>40 words)

| Line | Word count | Quote (truncated) |
|---|---|---|
| L40 | 65 | "We test the Agricultural Household Model (AHM) separability null at the 0.5 ha eligibility cutoff for Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS), exploiting the Small-Farmer Flat Payment (SFFP)..." |
| L40 | 51 | "At a transfer-to-capital-adjustment-cost ratio $T_{SFFP}/\tau \in [0.024,\, 0.048]$---reconciling 50M KRW purchase-price and 25M KRW down-payment-equivalent for Korean smallholder machinery---closed-form predictions place the cohort deep within..." |
| L40 | 49 | "Using a difference-in-differences regression-discontinuity design on the Farm Household Economic Survey panel (2018--2022, $N = 14{,}474$ farm-years across $3{,}614$ farms), we document a monotone tenancy gradient consistent with..." |
| L54 | 66 | "Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS) marked the largest restructuring of Korean farm subsidies in two decades, replacing the area-proportional Rice Income Compensation Scheme with a hybrid program of which the Small-Farmer Flat Payment (SFFP) is the per-farm flat-rate component." |
| L54 | 55 | "The SFFP transfers 1,200,000 KRW per year to households whose baseline cultivated area falls at or below 0.5 ha ($5{,}000$ m²); approximately one million Korean farms receive PIDPS payments annually under a total budget of 2.3 trillion KRW..." |
| L54 | 50 | "The per-farm flat-rate design is institutionally distinctive: it is not the area-proportional structure of U.S. crop subsidies or the EU Common Agricultural Policy Pillar I, with the closest cousin a Swiss spatial-RD on a similarly national, non-supranational direct-payment scheme." |
| L56 | 56 | "Under complete markets the AHM's recursive factorization implies that smallholder production decisions---land tenure, capital investment, labor allocation---are separable from consumption decisions; a lump-sum transfer enters only the consumption sub-problem and leaves production unaffected." |
| L56 | 90 | "Our framework formalizes two AHM extensions through which separability fails: wealth-biased liquidity, under which credit access is increasing in baseline wealth and the SFFP transfer relaxes the rental-versus-ownership margin asymmetrically across the tenancy distribution (Channel A, primary); and implicit-labor supervision, under which the household's shadow wage diverges from the market wage when own-family labor is imperfectly substitutable with hired labor (Channel B, auxiliary)." |
| L58 | 66 | "Versus Kirwan (2009): the U.S. Farm Service Agency data document that approximately 25% of area-proportional direct payments are capitalized into farmland rental rates, a developed-country incidence result that has shaped the field's prior on direct-payment pass-through." |
| L58 | 56 | "Their EU CAP evidence reports pass-through of Pillar I area-payments into rental rates of up to 46% in the short run and 55% in the long run, exceeding the U.S. Kirwan estimate at the upper end..." |
| L58 | 55 | "We extend this lineage by formalizing the wealth-bias signature (the Carter-Olinto cross-partial) that the disinvestment literature does not isolate." |
| L58 | 53 | "If both F1 and F2 fail to fire, we read the joint null as a precise complement to LaFave-Thomas (2016)---evidence that smallholder separability survives in developed-country settings where labor and credit markets approach completeness." |
| L60 | 47 | "We report three bandwidths in parallel---T1 ($\pm 500$ m²), T2 ($\pm 1{,}000$ m²), and T3 (MSE-optimal)---to surface the spatial concentration of the effect rather than collapse it to a single optimal-bandwidth estimate." |
| L60 | 65 | "Under the α3 framework's outcome hierarchy, the primary outcomes are own-cultivated area ($A_{\text{own}}$, primary outcome #1, diagnostic of Channel A wealth-bias) and operating cost net of rent (op_cost_ex_rent, primary outcome #2, diagnostic of the eq. CO-3 (S,s) inaction sub-prediction)..." |
| L62 | 49 | "Both endpoints place the smallholder cohort within the (S,s) inaction band of Caballero-Engel (1999)-type lumpy-investment models: the eq. CO-3 sub-prediction of $\beta_{\text{op\_cost\_ex\_rent}} \le 0$ holds across the range..." |
| L62 | 47 | "F1 predicts a monotone-in-baseline-tenancy gradient in $\partial A_{\text{own},i} / \partial T_{SFFP}$: pure-tenant smallholders, with the lowest baseline ownership share, exhibit the largest response; pure-owner smallholders, anchored at $s_0 = 1$, exhibit zero response by construction." |
| L62 | 51 | "Preliminary results from the forthcoming §5 document the F1 monotone gradient consistent with the wealth-bias-channel signature, alongside the eq. CO-3 negative operating-cost response at narrow bandwidths..." |
| L64 | 47 | "Methodologically, to our knowledge we provide the first AHM separability test at a per-farm flat-rate direct-payment cutoff and the first DiD-RD evidence on the Korean PIDPS..." |
| L65 | 65 | "Empirically, the monotone-in-tenancy gradient in own-cultivated area and the (S,s) operating-cost response provide developed-country evidence on non-incidence-margin direct-payment effects in smallholder settings where the Kirwan-Baldoni-Ciaian capitalization channel is muted by the per-farm flat-rate design." |
| L131 | 49 | "The household-specific transfer $T_i = T_{SFFP} \cdot D_i$ with policy scale $T_{SFFP} = 1{,}200{,}000$ KRW/year enters disposable income if and only if the household is SFFP-eligible (baseline area $A_{2018,i} \le 5{,}000$ m², equivalently treatment dummy $D_i = 1$)..." |
| L151 | 49 | "Parallel-trends inference rests on the 2018-2019 pre-period gap; following Roth (2022), single-pre-period pretests do not certify the parallel-trends restriction and we therefore report Rambachan-Roth (2023) sensitivity bounds (HonestDiD $\bar M$) on $\hat\beta_1$ and $\hat\beta_3$ in the robustness appendix." |
| L172 | 41 | "The DiD-RD specification in §identification recovers this aggregate marginal effect as the local average treatment effect at the cutoff, not a household-specific partial derivative." |
| L172 | 53 | "By the wealth-bias slope $\rho'(W) > 0$, the threshold-crossing density is monotone in baseline tenancy: pure tenants face the largest $\varphi(W^*)$ in the eligibility window, while pure owner-operators sit inframarginally above $W^*$ and exhibit zero response by construction." |
| L184 | 42 | "This adjustment-threshold logic parallels the (S,s) inaction band of Caballero-Engel (1999) cast within an AHM-internal credit constraint; we take the predictions of Carter-Olinto / Kazukauskas as load-bearing rather than the macro lumpy-investment framework..." |
| L224 | 64 | "The two figures of ${\sim}50$M KRW (purchase-price) and ${\sim}25$M KRW (down-payment-equivalent) referenced across the literature on Korean farm-equipment financing reconcile under typical 50% loan-to-value installment terms..." |
| L226 | 51 | "The annual-flow interpretation of $T_{SFFP}$ (per-year transfer) and the lump-sum interpretation of $\tau$ (one-shot adjustment) make $T_{SFFP}/\tau$ measure per-period transfer scale relative to a one-shot capital threshold; under a multi-year horizon..." |
| L253 | 64 | "F2 is consistent with the supervision-cost mechanism being inoperative at the SFFP scale, but does not on its own reject it: the EK-1 sign is theoretically indeterminate ex ante because the transfer relaxes both the family-time scarcity (favoring more off-farm labor) and the cash constraint..." |
| L259 | 45 | "These observed rent movements are consistent with but not derived from our AHM-extension model." (one of the cleaner ones, but the surrounding micro-mechanism sentence is 50+ words) |
| L266 | 95 | MDIS footnote — see §4 row above |
| L82–94 (online_appx) | 56 | "This section derives the three closed-form predictions reported in main-text equations §CO-1 to §CO-3..." |
| L203–214 (online_appx) | 130 | Step-3 footnote on four-bin partition (single paragraph) |

**Total long-sentence count:** ~30 sentences ≥40 words across main.tex §1+§3, ~8 in online_appendix.tex §B.1–B.2. AJAE-grade prose typically targets <30 long sentences per ~30-page manuscript; current main.tex §1+§3 alone exceeds this.

---

## Hedging calibration

Hedging is **mostly proportionate** with two systematic issues. (a) The abstract and §3.1 close commit prematurely to *"We reject AHM separability"* in italics — overclaiming relative to the §5 stub. (b) §1 ¶6 uses *"to our knowledge we provide the first..."* (L64), which is the conventional mid-strength hedge and reads well. (c) §3.4.1 uses *"sit comfortably inside the 5–10% inaction band"* — "comfortably" is colloquial; *"well within"* is the AJAE-grade equivalent. (d) §3 closed-form prediction boxes use the unhedged equality form (e.g., L169 $\partial A_{own}/\partial T_{SFFP} > 0$ inside `\boxed{}`); this is appropriate for closed-form derivation results and should not be hedged. (e) Falsification language *"F2 is consistent with... being inoperative ... but does not on its own reject it"* (L253) is exactly the right strength of hedge for an informative-not-rejecting trigger.

The single largest hedging fix: remove or condition the italicized *"We reject AHM separability for Korean small farms"* sentence (L40, L119) until §5 results lock. Replace with: *"We test whether AHM separability holds in this setting and document the empirical signature predicted by the wealth-biased liquidity channel."*

---

## Score rationale

- **Sentence length (–1.5):** ~30 long sentences in §1+§3 main text; AJAE-grade target is <15. Multiple 60–90 word sentences with stacked em-dashes in §1 ¶1, ¶3.
- **Falsification list inconsistency (–1.0):** §3.4 `description` block has five items with overlapping/redefined `[F1...]` labels and inverted "fires" semantics — load-bearing prose that confuses the reader on the central design lock.
- **Premature abstract rejection claim (–0.5):** italic L40 and L119 commit ahead of §5 results.
- **Minor polish issues (–0.5):** stray `\ ` at L65, "P3b-2" internal pipeline tag at L259, comma splice at L62.
- **Strengths (+0.0 baseline):** active voice dominant, jargon defined cleanly on first use (PIDPS, SFFP, AHM, DiD-RD, FHES, ADR all introduced with full expansion), Korean bibliography swap works (no Korean glyph leak in `\citet` rendering), equation prose integration is good (all `\ref{eq:...}` cross-refs resolve; equations sit inside paragraphs rather than as displayed islands), §3 notation table (Table 1) is well-placed and reduces notation friction.

**6.5/10** — Publishable framework prose with disciplined structure (notation table, sub-section headers, paragraph labels), undermined by sentence-length saturation in §1 and the §3.4 falsification list inconsistency. A focused copy-edit pass — splitting ~30 long sentences and rewriting the 5-item F1/F2 `description` block as 3 items with stable "fires" semantics — would lift this to 8.5/10 without changing a single substantive claim.
