# Lens 5: Robustness
**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` §7 (lines 370--439)
**Score:** 6.5/10

A workmanlike §7 that contains essentially all of the right boxes (McCrary, attrition placebo, outlier ladder, wild bootstrap, event-study, HonestDiD, Spec B, dropped-194 balance, placebo cutoffs, area-only fallback, multi-RV manipulation test) but reads as a check-list rather than a referee-defense argument. The biggest weaknesses are (i) the HonestDiD result is buried with a face-value devastating disclosure (breakdown $\bar M^* = 0$) that is then explained away in a single dense sentence rather than treated as a structured defense; (ii) at least three of the eleven paragraphs have no opening motivation sentence; (iii) the placebo-cutoff and outlier-ladder paragraphs read theatrically ("we also ran...") rather than anticipating a specific referee objection; (iv) the §7.1 (area-only) demotion narrative is institutionally accurate but the reader is never told WHY the analysis was demoted from main, only that "the area-only definition expands the treated cohort." Several specific referee objections AJAE will raise are not preempted at all (sub-district clustering, bandwidth-cherry-picking proof, anticipation effects beyond the in-text disclaimer in §2/§5).

---

## CRITICAL findings

### C1. HonestDiD $\bar M^* = 0$ is reported but the defense is one sentence and reads like a confession
Line 398 contains the single most dangerous referee-bait sentence in the manuscript: *"the 95\% confidence interval includes zero already at $\bar M = 0$ (breakdown $\bar M^* = 0$) because the single-pre-period event-study spec is underpowered relative to the cross-bandwidth pooled DiD-RD specification."* A referee scanning §7 will stop here. The current text essentially says: "our event-study point estimate is consistent with the null even before we allow any pre-trend violation." The follow-up "the pooled DiD-RD significance therefore derives from cross-bandwidth pooling and the 2018-baseline freeze..., not from the event-study spec" is the correct defense but it is buried inside the same paragraph and lacks any formal argument structure (e.g., a side-by-side comparison of event-study SE vs. pooled DiD-RD SE, or a power-calculation footnote). This is referee-objection material — Roth/Rambachan & Roth referees will demand a dedicated sub-paragraph, ideally with a numerical statement like "the event-study SE at 2022 is $\approx 3\times$ the pooled DiD-RD SE due to triangular-kernel down-weighting at the single pre-period." Without that, the reader is left thinking the F1 finding does not survive HonestDiD — a paper-killer reading.

### C2. The §7.1 area-only "robustness" paragraph fails to explain the demotion rationale
Lines 423--430 present the area-only treatment as if it were a routine alternative-specification check ("we re-estimate the headline DiD-RD specification using the area-only treatment definition... which expands the treated cohort by including the 14.6% of area-eligible households who fail criteria (ii) or (vi)"). The reader is never told that the area-only `D_treat` was the original Wave 5 main specification, that the move to statutorily-eligible was a Wave 7 decision driven by 8-criteria SFFP institutional fidelity, and that the demotion was a deliberate ITT-fidelity choice, NOT a finding-driven cherry-pick. As written, a hostile referee can read this as: "the authors quietly trimmed 194 households until the headline crossed $p < .05$." The honest defense — that the 14.6% non-compliance rate is the ITT-vs-ATT wedge and the F1 finding is robust to either definition — is implicit, but never stated. Either label this paragraph "Statutory-eligibility vs. area-only treatment (ITT vs. ATT wedge)" and lead with the institutional rationale, or add a one-paragraph footnote at §5 (Empirical Strategy) cross-referenced from here. Currently this is the highest-risk paragraph in §7 for AJAE desk review.

### C3. Sub-district (`sgg_cd`) clustering is promised in §5 but not delivered in §7
Line 339: *"Sub-district ($sgg\_cd$) clustering is reported in §7 as a robustness check."* I cannot find this in §7. The wild cluster bootstrap paragraph (line 387) only describes household-clustered wild bootstrap, not sub-district clustering. Either the §5 sentence is a dangling promise (referees check this; the AJAE desk reviewer in particular will diff §5 against §7), or the sub-district result lives only in the replication-package and §7 needs to say "see \texttt{tab\_cluster\_sgg.tex}" explicitly. This is a -10 (Major) under the quality-gates.md rubric ("Missing robustness check (cluster=`sgg_cd`, MSE-bandwidth)").

---

## MAJOR findings

### M1. Placebo-cutoff paragraph is theatrical, not motivated
Lines 419--421 read: "We test for spurious discontinuities by re-estimating the DiD-RD at four non-policy cutoffs..." This is correct technically (32 cells, 3.2 expected at $\alpha=.10$, "broadly consistent" interpretation), but the paragraph never *names the referee objection* it preempts: *"a referee may ask whether 0.5 ha is the unique cutoff at which the DiD-RD pattern appears, or whether any cutoff in the support of $A_{2018}$ would generate a similar discontinuity."* Without that framing the paragraph reads as a fishing exercise. Also: 3 cells at $p<.10$ and 1 at $p<.05$ out of 32 is exactly the expected null distribution, but the paragraph buries this with the slightly defensive "do not survive a Bonferroni correction." Lead with the expected count, then report.

### M2. Outlier ladder is not actually shown — the manuscript only refers to a replication-package file
Line 385: "The replication-package outlier-ladder table (\texttt{tab\_rob\_outlier\_en.tex}) reports..." but the table is not inputted in §7. The reader cannot see the four estimates (raw / IHS / Winsor-1-99 / Winsor-0.5-99.5). For a published-page robustness, the actual numbers should appear in §7 or be `\input{}`ed (as is done for `tab_specB`, `tab_dropped_balance`, `tab_attrition_placebo_full`, `tab_placebo_cutoffs`). The selective inclusion of some tables but not others looks suspicious — either include all four, or move all to the online appendix and reference uniformly.

### M3. Wild cluster bootstrap reports "$B = 999$ in the current draft, $B = 9{,}999$ at the replication-release stage" — this will draw fire
Line 387. Referees will demand $B = 9{,}999$ at submission, not at replication-release. AJAE / Food Policy practice is that the manuscript-stage wild bootstrap should already be at $B \ge 9{,}999$; $B = 999$ at submission is a tell-tale sign of an underdone robustness section. Either run the higher-$B$ bootstrap before submission (the cells you list — 14 cells × $B = 9{,}999$ — is a few hours of compute, not a blocker), or drop the "current draft" language and just say $B = 9{,}999$ once you have run it. Also: "wild bootstrap p-values agree with the cluster-robust analytic p-values within $\pm .01$ on every cell" is a load-bearing claim — show one cell explicitly in a footnote (the pure-tenant $A_{own}$ cell, since it is the headline) so the referee can spot-check.

### M4. Event-study paragraph (line 389) covers only op_cost at T2, not the headline outcome $A_{own}$
The event-study figure is on op_cost at T2. But the F1 headline is on own-cultivated area $A_{own}$, not op_cost. A referee will ask: "where is the event-study on the actual headline outcome?" Either add a second event-study figure for $A_{own}$ at T2 (the natural pre-trends gate for the F1 finding) or explain in the figure caption why op_cost is the chosen outcome for the parallel-trends gate (e.g., op_cost has higher within-household variance and is the more demanding pre-trends test). The LN-10 parallel-trends gate is stated as "all 2018 pre |t|<1" in CLAUDE.md but the manuscript only shows one figure.

### M5. The dropped-194-households balance paragraph (line 411) is a good idea but reads as ad hoc
Lines 411--413 are essentially defending the §7.1 demotion (the move from area-only to statutorily-eligible), and that is the right move. But the placement is wrong — this paragraph belongs IMMEDIATELY BEFORE the §7.1 area-only paragraph (lines 423--430), so the reader sees "here is who we dropped → here is what happens if we put them back." Currently the order is: balance (411) → attrition-across-bandwidths (415) → placebo-cutoffs (419) → area-only (423). The narrative thread is broken.

### M6. No explicit "MSE-optimal bandwidth from `rdrobust`" robustness paragraph
The three-bandwidth grid (T1 / T2 / T3) is reported in main results, but §7 does not have a separate "MSE-bandwidth as primary, T1/T2 as robustness" framing. A natural referee objection — *"why is T2 the working bandwidth and not the MSE-optimal T3?"* — is not preempted. A one-paragraph statement that the MSE-optimal T3 ($h \approx 3{,}300$ for $A_{own}$, $h \approx 1{,}710$ for op_cost) sits within the reported grid, and that the pure-tenant $p = .023$ at T3 (line 350) is the MSE-optimal headline figure, would close this.

### M7. Spec B is described but the reader still does not know WHY it is the chosen alternative
Line 407: "Spec B substitutes a richer pre-period covariate vector (adding farm-type fixed effects and head-of-household education-tier indicators)." But §5 (Empirical Strategy) line 333 says the baseline `Spec A` already includes "farm-type indicators, head-of-household age tier, and education tier" — so what does Spec B actually add over Spec A? "farm-type fixed effects" vs. "farm-type indicators" — these read identically. Either there is a genuine difference (FE absorbs heterogeneity, indicators do not) that needs to be spelled out, or the two specs are nearly identical and the robustness check is meaningless. This is a load-bearing distinction because the headline Spec A and Spec B comparison in line 407 ($-3.98$M vs. $-4.88$M at T1; $-3.13$M vs. $-4.64$M at T2) shows non-trivial movement — Spec B coefficients are 20--50% larger in absolute value. A referee will notice this and ask which spec is "right."

---

## MINOR findings

### m1. Footnote-able numbers are body text
Line 387's "wild bootstrap $p$ consistent with the analytic $p = .041$" should be a parenthetical or a footnote; the paragraph already has the headline-cell comparison.

### m2. "broadly consistent with the false-positive rate expected under the null at $\alpha = .10$ (32 × .10 ≈ 3.2 expected)" is exactly right but written defensively
Replace "broadly consistent with" with "matches the expected count under the null."

### m3. The multi-RV McCrary test (line 432) has the owned-farmland test at $t = -1.64$ ($p = .10$)
Line 432: "owned farmland threshold ($15{,}500$~m\textsuperscript{2}) is $t = -1.64$ ($p = .10$)." A referee will note that this is on the boundary of conventional significance. The current phrasing "All three margins pass the density-continuity test at conventional levels" is technically true ($p = .10$ does not reject at $\alpha = .05$) but it is the kind of marginal-significance claim referees love to attack. Add a sentence: "The owned-farmland margin sits at the conventional $\alpha = .10$ boundary; we report the test for completeness and note that the eligibility-criterion is a strict $<$ inequality (criterion ii: $< 1.55$ ha), so any density discontinuity at this margin would also need to manipulate two other observable criteria simultaneously."

### m4. "headline pure-tenant area\_own estimate at T2 ($+1{,}122$~m\textsuperscript{2}) has wild bootstrap $p$ consistent with the analytic $p = .041$" — give the actual wild-bootstrap $p$
Line 387. The point of the wild bootstrap is to deliver the $p$. State it: "wild bootstrap $p = .043$ vs. analytic $p = .041$" (or whatever the number is).

### m5. The "differential-attrition placebo" paragraph (line 383) is in the wrong location
It currently sits second, between McCrary and outlier ladder. It belongs with the other attrition material — i.e., adjacent to "Attrition placebo across bandwidths" (line 415). Currently the two attrition paragraphs are separated by four other paragraphs.

### m6. "Holm step-down adjustment applied across the primary outcome family" appears in §7 (line 387) but the actual adjusted p-values are nowhere shown
A small adjusted-$p$ table (or a footnote: "After Holm correction across four outcomes, the pure-tenant $A_{own}$ T2 estimate remains significant at $p < .10$ (Holm-adjusted $p = .098$)") would close this gap.

---

## Referee-objection preemption matrix

| Objection | Preempted? | Where | Convincing? |
|---|---|---|---|
| 0.5 ha arbitrary | YES | §7 placebo-cutoffs (lines 419--421) | Partially — 32-cell test reported, but no leading motivation; referee may still ask for 0.45 / 0.55 finer grid |
| Manipulation at cutoff | YES | §7 McCrary (line 374) + multi-RV (line 432) | Yes for cultivated-area margin; weak for owned-farmland margin ($p=.10$) |
| Pre-trends | PARTIAL | §7 event-study op_cost only (line 389) | NO for $A_{own}$ — event-study figure is on op_cost, not the F1 headline outcome |
| Outliers | YES (table not shown) | §7 outlier ladder (line 385) | Partial — reader cannot see the four estimates; only a verbal claim |
| Cluster level | NO | Promised in §5 line 339, not delivered in §7 | NO — dangling promise, this is the highest-priority fix |
| Anticipation effects | YES | §3 estimand box (line 180) + §7 McCrary | Yes for pre-2018 sorting; not addressed for 2019--2020 anticipation between Act enactment and effective date |
| SUTVA / spillovers | YES | §5 (line 343, three-paragraph defense) | Yes — best-defended objection in the paper; this is the model |
| HonestDiD breakdown $\bar M^* = 0$ | PARTIAL | §7 HonestDiD (line 398) | NO — defense is one sentence; needs structured power argument |
| ITT vs. ATT wedge / 194 dropped | PARTIAL | §7.1 area-only (line 423) + dropped-balance (line 411) | Partial — institutional rationale for the demotion is never stated |
| MSE-optimal bandwidth | NO | T3 in §6 results, no dedicated §7 paragraph | NO — referees will ask why T2 is "working" |
| Holm-adjusted p-values | NO | Mentioned in §5 + §7 line 387, no adjusted table | NO |
| Spec A vs Spec B difference | NO | §7 line 407, but covariates appear identical | NO — risks looking like a circular robustness |

---

## Robustness check inventory (motivated vs. theatrical)

| Check | Present? | Motivation given? | Convincing? |
|---|---|---|---|
| McCrary density (single RV) | YES | YES — "addresses the residual pre-2018 strategic-reporting concern" | Yes |
| Multi-RV manipulation (triple eligibility) | YES | Implicit — "to assess manipulation at any of the three margins" | Yes (with the $p=.10$ caveat in m3) |
| Differential-attrition placebo (T2) | YES | YES — "frozen 2018-baseline running variable ensures..." | Yes |
| Attrition placebo across bandwidths | YES | NO motivation sentence — just "extends the T2 placebo" | Theatrical placement (separated from sibling at line 383) |
| Outlier ladder | YES (verbal only) | NO motivation — "we also estimated..." style | Theatrical — table is not shown in §7 |
| Wild cluster bootstrap | YES | Implicit | Partial — $B=999$ is a tell; sub-district variant missing |
| Event-study (op_cost T2) | YES | YES — "satisfying the LN-10 parallel-trends gate" | Partial — wrong outcome (op_cost, not $A_{own}$) |
| HonestDiD $\bar M$ sensitivity | YES | YES — "single-pre-period pretests do not certify the parallel-trends restriction" | NO — breakdown $\bar M^* = 0$ defense is one sentence |
| Spec B alternative covariates | YES | NO clear motivation | Partial — covariate difference vs. Spec A is opaque |
| Dropped-194 balance | YES | YES — "natural concern... whether the 194 dropped households differ" | Yes — well-motivated, wrong location (M5) |
| Placebo cutoffs (32 cells) | YES | NO opening motivation — referee objection not named | Theatrical — defensive phrasing |
| Area-only treatment (§7.1) | YES | NO — demotion rationale never stated | NO — biggest risk in §7 (C2) |
| Sub-district clustering | NO | — | NO — promised in §5, missing in §7 (C3) |
| MSE-optimal bandwidth as headline | NO | — | NO — referees will ask |

**Count:** 11 substantive checks shown + 2--3 missing or unconvincing. The ratio of "motivated" to "theatrical" is roughly 5:6. AJAE-grade §7 should be ≥ 9:2.

---

## §7.1 demotion narrative

The §7.1 area-only robustness paragraph (lines 423--430) is the single highest-risk passage in §7 for AJAE desk review and submission-stage referees.

**What the paragraph says now:** *"We re-estimate the headline DiD-RD specification using the area-only treatment definition... which reflects only the SFFP area criterion (i) and ignores the observable owned-area (ii) and off-farm-income (vi) criteria. The area-only definition expands the treated cohort by including the 14.6\% of area-eligible households who fail criteria (ii) or (vi)."*

**What is missing:**

1. **The historical fact** that area-only `D_treat` was the original Wave 5 main analysis specification, and that the demotion was made on institutional-fidelity grounds (8-criteria SFFP), NOT on finding-driven grounds. Without this, a hostile referee can read the §7.1 narrative as: *"the authors trimmed 194 households until $p<.05$ on the headline."* The truth is the opposite — the demotion was made before the headline coefficient was finalized — but the reader cannot know this.
2. **The ITT-vs-ATT wedge framing.** The 14.6% non-compliance rate is exactly the wedge between intent-to-treat (under area-only) and average-treatment-on-the-treated (under statutory-eligible). This is a textbook distinction in the policy-evaluation literature and the manuscript should frame it as such, not as a "more permissive vs. stricter definition" comparison.
3. **The narrative connection to §3.1 (Estimand and pre-period inference, line 180)** where ITT is defined. The §7.1 paragraph and the §3.1 ITT box never reference each other.
4. **The headline-finding stability claim** is stated correctly (zero cells crossing $\alpha = .05$, three at $\alpha = .10$, 1--2% movement in op_cost) but the reader does not know WHY this matters: it matters because the F1 finding is robust to either treatment definition, which is exactly the right defense against the trim-to-significance worry.

**Proposed rewrite (one-paragraph sketch):**

> "**Statutory eligibility vs. area-only: the ITT--ATT wedge.** Our headline specification uses the statutorily-eligible treatment indicator $D_i$ (criteria i + ii + vi), which removes the 14.6\% of area-eligible households who fail criterion (ii) (owned farmland $\ge 1.55$ ha) or (vi) (household off-farm income $\ge 45$M KRW). An alternative — the area-only indicator $D^{\text{area}}_i = \mathbf{1}\{A_{2018,i} \le 5{,}000\}$, used in earlier drafts and in §6.1 of our preregistered analysis — recovers a pure intent-to-treat estimand over the area cutoff alone; the 14.6\% wedge is the ITT--ATT margin. We adopted $D_i$ as the main specification on institutional-fidelity grounds (the eight-criterion SFFP rule, Act on Public-Interest Direct Payments Article 10), not because of the resulting point estimates: the 24-cell coefficient comparison shows zero cells crossing $\alpha = .05$ and only three at $\alpha = .10$ across treatment definitions; the op\_cost\_ex\_rent headline moves by 1.1\% and 2.2\% in absolute value at T1 and T2 of Spec A. The F1 finding is therefore robust to either definition; the choice of $D_i$ is a labeling, not an identification, decision."

This is the rewrite the §7.1 needs. Without it, the §7.1 paragraph is a referee-magnet.

---

## Bottom line

§7 is a **B-grade robustness** as written: it has all the right ingredients but is missing the structural argument that turns ingredients into a defense. The four highest-value fixes, in priority order, are:

1. **Rewrite §7.1 to lead with the ITT--ATT wedge and the institutional-fidelity rationale for the demotion** (this is paper-life-or-death).
2. **Add a structured HonestDiD defense paragraph** explaining the event-study underpowering with a numerical SE comparison (close the $\bar M^* = 0$ flank).
3. **Deliver the sub-district clustering robustness promised in §5 line 339** (a dangling promise is a tell).
4. **Add an $A_{own}$ event-study figure to match the F1 headline outcome** (currently only op_cost has one).

Lower-priority but cheap: reorder the §7 paragraphs so attrition material is contiguous (M5); show the outlier-ladder estimates inline (M2); raise wild bootstrap to $B = 9{,}999$ before submission (M3); name Spec B's distinguishing covariates explicitly (M7).

A clean version of §7 with these fixes would score 8.5/10 and be submission-ready. The current 6.5 reflects a section that an AJAE editor's desk review will mark as "comprehensive but defensive" — survivable, but exactly the kind of §7 that gets a second referee assignment focused on robustness.
