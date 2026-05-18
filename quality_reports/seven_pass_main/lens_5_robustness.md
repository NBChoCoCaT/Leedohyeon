# Lens 5 (Robustness) — Seven-Pass Review

**Score:** 6.8/10

Reviewing pre-emption coverage of §3 + Online Appendix §B against a sharp AJAE referee, given that §7 is an acknowledged placeholder. Bottom line: the framework has done unusually thorough work on the inaction-band calibration, the ex-theory demotion of $\hat\beta_5$, and the F1/F2 asymmetry — but leaves three referee-attack surfaces materially exposed: anticipation effects, manipulation/density evidence for the running variable, and FHES Wave-1 attrition / take-up selection.

---

## CRITICAL gaps (referee will hit)

**C1. Anticipation effects unaddressed.** PIDPS was enacted as the *Act on Public-Interest Direct Payments to Farmers and Fishers* well before the 2020-05-01 effective date; the SFFP cutoff was publicly known in advance. Yet the manuscript nowhere acknowledges anticipation/sorting in 2018–2019. The frozen-2018 running variable defense (main.tex L60, L149 "post-2020 area changes cannot induce manipulation") protects against *post-treatment* manipulation but is silent on *pre-2018* manipulation if the policy was foreseeable when 2018 baseline was reported. A first-tier AJAE referee will ask: when did the cutoff become public knowledge? If before the 2018 FHES baseline reference date, then `area_2018` itself could be endogenous, and the frozen-rv defense collapses. SC5 (online_appendix.tex L283–286) only argues $\text{Cov}(W_{i,2018}, T_{i,2020+}) = 0$ "by construction," but construction does not establish exogeneity if anticipation moved 2018 area reporting. **Fix:** add a 1-paragraph anticipation-defense (legislative timeline + pre-2018 area distribution check + McCrary on the 2018 baseline density).

**C2. McCrary density test promised but not pre-specified with a result.** Line 273 (§4 stub) and line 291 (§7 stub: "$\Delta = +0.7$pp $< 2$pp threshold") imply the test has been *run* with a passing result, but the framework section never pre-specifies the test on the frozen 2018 baseline rv. For a sharp referee, the McCrary result on `rv_2018` is load-bearing for the entire RDD identification; surfacing it in robustness only (and citing a $+0.7$pp result in the stub) without theoretical/specification framing in §3 invites the referee to flag it as post-hoc. **Fix:** mention the planned McCrary test in §3.1 or §4 alongside the frozen-rv defense, not buried in §7.

**C3. FHES Wave-1 attrition across 3,614 farms over 2018–2022 is never quantified.** The CLAUDE.md and footnote at L266 cite $N = 14{,}474$ farm-years across 3,614 farms — exactly $3{,}614 \times 5 = 18{,}070$ if balanced, but we observe 14,474, implying ~3,596 missing farm-years (≈20%). The manuscript does not say whether the panel is balanced, what attrition looks like, whether attrition differs across the cutoff, or whether the DiD-RD is run on the balanced or unbalanced panel. A referee will ask immediately whether differential attrition correlates with $D_i$. **Fix:** add an attrition table (balanced vs. unbalanced count by treatment status) to §4 and a differential-attrition robustness in §7.

---

## MAJOR pre-emption gaps

**M1. The 92.3% take-up figure cuts both ways and the 7.7% non-takers are not addressed.** SC3 (online_appendix.tex L277) and §3.4.1 (main.tex L228) cite 92.3% as evidence of participation slack supporting the interior-solution condition. A sharp referee will instead read it as: 7.7% of eligible households declined a free 1.2M KRW transfer. That is a striking non-trivial selection margin (likely correlated with off-farm income, retirement status, or non-paddy crop mix), and the ITT framing in §3.1 ("eligibility-as-determined-by-2018-area," L149–151) does not insulate against selection on observables in the response margin. **Fix:** either (i) report observable covariates for the 7.7% non-takers, or (ii) explicitly note that the ITT estimand absorbs non-takers and bounds the LATE on takers via a Lee-bounds argument.

**M2. Lower-$\tau$ robustness endpoint (20M KRW) may break (S,s) inaction.** §3.4.1 (L226) states that $T_{SFFP}/\tau$ at the $\tau = 20$M endpoint gives $0.060$, still within the 5–10% inaction band. But equation \ref{eq:CO-3} only carries the weak inequality $\le 0$ — it is *load-bearing* on the inaction band being deep. At $\tau = 20$M, $T_{SFFP}/\tau = 0.06$ sits at the *boundary* of the cited 5–10% band. A referee will ask: what if the true $\tau$ for the marginal smallholder with 0% LTV (cash-purchase regime) is below 20M, e.g., for a used or shared-equipment cohort? The cumulative 5-year ratio of 0.12–0.24 (L226) is even more boundary-grazing. The paper does not provide a sensitivity curve showing where the eq. CO-3 sign flips. **Fix:** add a one-figure plot of $\beta_3$-implied direction across $\tau \in [10\text{M}, 80\text{M}]$ to demonstrate the prediction is not knife-edge.

**M3. Multiple-testing surface is large and under-disclosed in §3 framing.** With 5 channels × 3 bandwidths = 15 tests on $\beta_1$, plus 4 bins × 3 bandwidths = 12 tests on the monotonicity gradient $\beta_2$, the paper runs ≥27 hypothesis tests on primary outcomes. CLAUDE.md mentions wild cluster bootstrap + Holm step-down, and main.tex L60 echoes this, but §3 framing does not state the *family* over which Holm is applied (primary #1 + #2? or all 27?). The four-bin monotonicity test in Online Appendix Table B.2 (decision rule on L452) requires monotone *ordering* across bins — which is a joint-ordering test, not 4 separate tests. **Fix:** §3.5 (or §4) needs an explicit "inference family" definition; otherwise the referee will assume the worst (no correction) or the best (over-correction), and either way the paper loses the framing battle.

**M4. EK-1 sign cancellation is asserted but not bounded.** F2's "informative not rejecting" status (main.tex L253) rests on the two opposing channels canceling. A sharp referee asks: under what parameter regime does cancellation occur? The paper does not give a wedge condition ($m \cdot \mu/\lambda$ versus $U_{Cl}/U_{CC}$) that delineates which dominates. This leaves F2 vulnerable to the critique that the paper is hedging — claiming a null is informative without saying *what* would make it informative versus uninformative. **Fix:** Online Appendix §B.2 step 1 ($\partial(\mu/\lambda)/\partial T_i$, L378–382) needs one extra line on what conditions ensure cancellation rather than dominance.

**M5. Pre-trends inference rests on a single pre-period gap (2018–2019).** The manuscript correctly cites Roth (2022) and Rambachan-Roth (2023) HonestDiD at L151. But the single-pre-period limitation is real: with only one pre-period gap, even HonestDiD's $\bar M$ bounds rest on extrapolating from a single difference. A referee with Roth (2022) in hand will press: what does the data show at $\bar M = 1$? At $\bar M = 2$? The paper *plans* the sensitivity for the robustness appendix but does not commit to a specific $\bar M^*$ at which the sign would flip, weakening the pre-emption. **Fix:** state a target $\bar M^*$ (e.g., "sign holds for $\bar M \le 1.5$") as the falsification trigger.

---

## MINOR pre-emption gaps

**m1. Donut RDD and kernel choice not mentioned.** Standard AJAE robustness for sharp RDD includes (i) donut-hole sensitivity (drop ±50, ±100 m² around the cutoff) and (ii) triangular vs. uniform vs. epanechnikov kernel. §7 stub (L291) mentions outlier ladder + alternative bandwidths but not donut or kernel.

**m2. Bandwidth grid in Online Appendix Table B.2 has "TBD" entries for T1 and T3.** L451–454 leave T1 and T3 empirical estimates as "TBD"; the operational decision rules cite *T2 only* for F1 trigger (L452). A referee will read this as: the per-bandwidth grid is aspirational, not operational. The MSE-optimal T3 is the standard-bearer in modern RDD; running T3 should be a hard pre-commitment, not "queued for next cycle" (cf. $\beta_4$ at L454).

**m3. The unit_rent_price reversal claim is bold but the demotion is structurally sound — minor risk is in the wording.** §3.4 equilibrium rent caveat (L259) calls $\hat\beta_5$ "consistent with but not derived from" the model, and Online Appendix §B.1 closing (L289–298) repeats this. The B.3 table separator (L455–457) marks "ex-theory" cleanly. *However*, the abstract (L40) and intro (L58) repeatedly frame the SFFP-vs-Kirwan-vs-Ciaian-reversal as a contribution. A sharp referee may ask why the bold cross-country reversal claim is featured in the abstract if it is not derived from the model. **Fix:** soften abstract framing or move the reversal into a discussion-section asset (§8) rather than a primary contribution.

**m4. SC2.5 negative-correlation primitive cites a placeholder.** Online Appendix L266–274 (SC2.5) lists the negative wealth-tenancy correlation as load-bearing for Step 3 monotonicity but flags it as "placeholder estimate; finalized in §\ref{sec:results}." A sharp referee will flag this as: the entire monotone-gradient prediction rests on an empirical primitive that has not been verified at the time the theoretical derivation was framed. **Fix:** report the FHES correlation immediately in §3.2 (not §5).

---

## Pre-emption coverage matrix

| Threat | Pre-empted? | Where | Sufficient? |
|---|---|---|---|
| Single-pre-period (Roth 2022) | YES | main.tex L151 | Partial — no $\bar M^*$ trigger committed |
| HonestDiD $\bar M$ sensitivity (Rambachan-Roth 2023) | YES (planned) | main.tex L151 | Robustness-appendix plan only |
| Anticipation effects (pre-2020 policy announcement) | NO | — | **Critical gap** |
| RV manipulation (2018 frozen baseline) | YES | main.tex L60, L149 | Yes for post-2020; gap on pre-2018 anticipation |
| McCrary density test | Partial | §7 stub L291; not in §3 | Needs §3 framing |
| Bandwidth sensitivity (T1/T2/T3) | YES | main.tex L60, App B.3 | T1/T3 entries TBD in B.3 |
| Donut RDD / kernel choice | NO | — | Minor gap |
| $\tau \in [20\text{M}, 40\text{M}]$ calibration | YES | main.tex L224–226 | Boundary-grazing at lower end |
| 0% LTV cash-purchase low-$\tau$ scenario | NO | — | Minor gap |
| Cumulative SFFP vs. annual flow ($T/\tau$ interpretation) | YES | main.tex L226 | Hand-waved at 0.12–0.24 |
| F1/F2 asymmetry | YES | main.tex L250–256 | Strong — load-bearing F1, informative F2 |
| EK-1 sign indeterminacy | YES | main.tex L203, L253; App B.2 | No cancellation-regime bound |
| FHES attrition 3,614 farms 2018–2022 | NO | — | **Critical gap** |
| $s_0$ measurement error / four-bin attenuation | YES | main.tex L228; App B.1 footnote | Sufficient |
| 92.3% take-up / 7.7% non-taker selection | Partial | App SC3 L277; main.tex L228 | Selection not addressed |
| B.1 ex-theory demotion of $\hat\beta_5$ | YES | main.tex L243–245, L259; App B.1 L289–298; App B.3 L455–457 | Strong — three independent confirmations |
| Multiple-testing / Holm family definition | Partial | main.tex L60 mentions | Family not pinned down |
| Power calculations | NO | — | Standard AJAE expectation |
| External validity (LMIC / developed) | YES | main.tex L58 | LaFave-Thomas graceful failure clause works |
| ADR-0002 timing disclosure | YES | main.tex L40 fn.2, L232 caption | Consistent and audit-locked |
| $s_0$ four-bin partition pre-spec | YES | App B.1 L203–214 footnote | Audit-locked |
| Per-bandwidth grid in B.3 | Partial | App B.3 Table | TBD entries undercut credibility |

---

## Sharp-referee imagined critiques (top 5)

1. **"The PIDPS Act was passed before 2018 FHES baseline. How do you rule out farmers strategically reporting baseline area in 2018 to land below the 0.5 ha cutoff?"** No defense in current draft. This is the single highest-leverage critique a Roth-Borusyak-savvy referee will raise. The frozen-rv defense addresses only the *symptom* (post-treatment crossing) not the *root cause* (pre-baseline manipulation under anticipation).

2. **"3,614 farms × 5 years = 18,070 — but you report 14,474 farm-years. That is 20% attrition. Is attrition differential at the cutoff?"** The omission of an attrition table is, in 2026 AJAE standards, near-automatic R&R material. The paper doesn't even acknowledge the imbalance.

3. **"Your monotonicity gradient is a joint-ordering test across four bins. Holm step-down on four bin-level $t$-tests is not the right inference; you need a monotonicity test (e.g., Kolmogorov-Smirnov-style ordering)."** §3 framing on inference (L60) is one sentence; Online Appendix B.3 trigger rule (L452) implicitly relies on 4 separate tests being monotone-ordered. The right test is Romano-Wolf or KS.

4. **"At $\tau = 20$M, $T_{SFFP}/\tau = 0.06$, right at the edge of the 5–10% inaction band. What if the true $\tau$ for low-collateral non-pure-tenant cohorts is $\tau = 10$M? Your prediction \ref{eq:CO-3} flips."** The robustness range is a range, not a sensitivity curve. The paper does not show where the sign breaks.

5. **"You demote $\hat\beta_5$ to ex-theory aggregate-equilibrium but then headline it in the abstract as a reversal of Kirwan and Baldoni-Ciaian. Either it's a contribution or it's not. Which is it?"** The demotion is structurally sound *internally* (three independent disclosures in §3.4 + §B.1 + §B.3), but the abstract/intro framing still leans on the reversal. A sharp referee will call this rhetorical hedge.

---

## Score rationale

**6.8/10.** The paper has done genuinely thoughtful work on the load-bearing items: the F1/F2 asymmetry is well-articulated (rare among separability papers); the ex-theory demotion of $\hat\beta_5$ is structurally enforced across three locations; the $\tau$-band calibration is sourced (KREI + KAMICO triangulation); the four-bin partition is audit-locked via ADR-0002; the SC1–SC5 taxonomy is referee-grade. This earns the paper above-median pre-emption coverage and demonstrates the author has anticipated most theory-side attacks.

What knocks it down to 6.8 rather than ~8: three critical gaps are *complete omissions*, not weak defenses — anticipation effects, attrition quantification, and McCrary in §3 framing. Each one is the kind of thing a competent AJAE first-round referee writes as the lead bullet of their report. The major gaps (multiple-testing family undefined, low-$\tau$ boundary grazing, EK-1 cancellation regime, single-pre-period $\bar M^*$ uncommitted) compound the risk: individually each is fixable in a revision, but together they signal that the robustness appendix (§7) when written needs to be *substantially longer than a normal AJAE appendix* to recover the pre-emption deficit. The ex-theory demotion of $\hat\beta_5$ saves the paper from a desk-reject on the rental-reversal claim but cannot rescue the identification-side gaps.

Above 6.8 requires closing C1–C3 in §3 framing (not deferring to §7) — anticipation defense, attrition table, McCrary in §3. Below 6.8 would require these *plus* the F1/F2 framing to be weaker than it currently is, which it isn't. Net: solid B-grade pre-emption with three high-leverage holes that a sharp AJAE referee will land on within ten minutes.
