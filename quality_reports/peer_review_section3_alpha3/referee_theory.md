Calibrated to: American Journal of Agricultural Economics (AJAE), Disposition: THEORY

# Domain Referee Report

**Calibrated to:** American Journal of Agricultural Economics (AJAE)
**Disposition:** THEORY (Singh-Squire-Strauss / Carter-Olinto / Eswaran-Kotwal expert; closed-form Lagrangian + SC list reviewer)
**Critical peeve:** Notation drift — symbol defined as X in §2 used with a different meaning in §4/§5 (load-bearing in a separability-test paper)
**Constructive peeve:** Rewards rigorous up-front definition of key terms / notation table for heavy-math papers
**Date:** 2026-05-18
**Paper:** `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex` (§3, L79–210) + `/Users/leedo/Research/01_dissertation_PBDP/paper/en/online_appendix.tex` (§B.1–B.3, L77–437)
**Scope note:** §3 + Online Appendix B alpha test under α3 (AHM-extension separability-test) framing only. Title / Abstract / §1 / §5 / §6 are explicit TODO placeholders and are not evaluated.

## Executive verdict

**Score:** 78/100
**Recommendation:** Major Revision
**Headline:** The α3 AHM-extension scaffold is theoretically defensible and the Carter-Olinto derivation is the strongest part of the paper, but three concrete theory defects — a non-derived sign claim at eq:CO-1, a notation drift between the period-1/period-2 Lagrangian in B.1 and the static separability null in §3.1, and a missing source citation for the load-bearing $\tau \approx 25$ M KRW calibration — keep this below first-submission grade for AJAE until they are fixed. None is fatal; all are addressable in one revision pass.

## Dimension scores

| # | Dimension | Weight (AJAE adj) | Score | Weighted |
|---|---|---|---|---|
| 1 | Contribution & Novelty | 32% | 82/100 | 26.2 |
| 2 | Literature Positioning | 25% | 80/100 | 20.0 |
| 3 | Substantive Arguments | 22% | 70/100 | 15.4 |
| 4 | External Validity | 20% | 78/100 | 15.6 |
| 5 | Fit for AJAE | 6% | 88/100 | 5.3 |
| | **Composite** | | | **82.5/100** |

Rationale notes:
- Contribution = 82: novel as a developed-country AHM-separability test at a sharp policy cutoff; the joint-falsification design is genuinely Carter-Olinto-disciplined rather than Carter-Olinto-flavored, which is rare. Knock-down: §3.3 (supervision) is auxiliary and theoretically indeterminate in sign, which limits the marginal contribution of channel 2 relative to channel 1.
- Lit positioning = 80: the four AJAE anchors (Singh-Squire-Strauss, dJFS, Carter-Olinto, Kazukauskas) plus Benjamin and LaFave-Thomas are all present and apt. Missing: Strauss 1986 chapter (the empirical-formulation companion to SSS, frequently cited alongside the recursive-factorization argument), Ghatak-Mookherjee 2024 NBER w31932 (recent supervision-tenancy revisit, post-dates §3 bibliography window — desk reviewer flagged this and I concur), and ideally Pitt-Rosenzweig 1986 JPE for the production-utility-jointness lineage.
- Substantive arguments = 70: this is where I take the most off. Eq. CO-1 sign claim (\ref{eq:CO-1}) is presented as a strict inequality via "$-\varphi(W^*) \cdot \partial W^*/\partial T > 0$" but the FOC-to-density-times-threshold-shift step skips two lines of derivation that the appendix derives only via a discrete-mass / threshold-crossing argument (\ref{eq:appB-step2}); the main-text equation is therefore a population aggregate written as if it were an individual partial derivative. See Concern 1. The eq:CO-2 derivation in §B.1 Step 3 leans on "$\partial \varphi(W^*)/\partial s_0 \le 0$" as a stipulation rather than derived from the wealth-bias function $\rho(W)$ — this needs SC-list anchoring (Concern 3).
- External validity = 78: the "developed-country smallholder" framing is genuinely a wedge in the AHM-separability literature, which is overwhelmingly developing-country. SC3 (92.3% take-up) and SC6 (17–34% hired-labor share) are FHES-anchored, which is good. The B.1 closing paragraph explicitly cabins the equilibrium-incidence inference, which protects external validity from over-claim.
- Fit for AJAE = 88: AHM-separability cutoff designs sit squarely in the AJAE wheelhouse (Carter-Olinto 2003 was published in AJAE). The α3 reframing from a three-channel descriptive story to a separability-test paper is the correct move for this journal.

## Major concerns (each with "What would change my mind")

### Concern 1: Eq. CO-1 main-text sign claim is a population aggregate written as an individual partial derivative

**Dimension:** 3 (Substantive Arguments)
**Severity:** MAJOR

**Description.** Main-text equation (\ref{eq:CO-1}) reads
$$\frac{\partial A_{own,i}}{\partial T_{SFFP}} \;=\; -\,\varphi(W_i^*) \cdot \frac{\partial W^*}{\partial T} \;>\; 0,$$
with subscript $i$ on the LHS and a density $\varphi(W_i^*)$ on the RHS. But $\varphi(\cdot)$ is the density of household wealth at the threshold — a population object, not an individual one. The appendix (\ref{eq:appB-step2}) makes this explicit: the RHS is "$\bar a \cdot \varphi(W_i^*) \cdot |\partial W_i^*/\partial T_i|$" derived via a threshold-crossing probability (\ref{eq:appB-step2-prob}) aggregated over a per-crosser purchase quantity $\bar a$. The main-text equation has dropped $\bar a$ entirely. Either (a) the LHS should be $\partial \mathbb{E}[A_{own}]/\partial T$ or $\partial P(\text{cross})/\partial T \cdot \bar a$ at the eligibility window's mass, or (b) the appendix-to-main-text bridge should explain that the subscript-$i$ object is shorthand for a conditional expectation. As written, the main text claims an individual-level FOC sign that the appendix actually delivers as a population-level threshold-crossing claim. This is the difference between a theoretical comparative static on a continuous decision and a discrete-choice extensive-margin aggregate — and it matters for what F1 actually tests in §5.

**Why this matters.** F1's logic ("no $s_0$ gradient $\Rightarrow$ wealth-bias rejected") rests on (\ref{eq:CO-2}) being a true cross-partial of (\ref{eq:CO-1}). If (\ref{eq:CO-1}) is actually a discrete threshold-crossing aggregate, then (\ref{eq:CO-2}) is a comparison of crossing densities across $s_0$ bins, not a continuous cross-partial. The empirical specification implied differs: a hazard / discrete-choice model versus a continuous DiD-RD coefficient.

**What would change my mind.** Either (i) rewrite (\ref{eq:CO-1}) as $\partial \mathbb{E}[A_{own} \mid \text{eligibility window}]/\partial T_{SFFP}$ and explicitly state that the empirical $\hat\beta_1$ is the local-linear estimator of this aggregate at the cutoff, OR (ii) add a one-paragraph bridge in §3.2 (between current L138 and L141) acknowledging the population-aggregate nature of $\varphi(W^*)$ and stating that the individual-$i$ subscript is a notation shorthand for "household $i$ falling in the eligibility window." Either fix is a short paragraph; the substantive issue is acknowledgment, not re-derivation.

### Concern 2: Notation drift between the static §3.1 AHM separability null and the two-period §B.1 derivation

**Dimension:** 3 (Substantive Arguments) — also critical peeve
**Severity:** MAJOR

**Description.** §3.1 (\ref{eq:ahm-objective})–(\ref{eq:ahm-budget}) writes the AHM in a single-period static form with land identity $A = A_{own} + A_{rent}$ and decision variables $\{C, L_f, L_o, A_{own}, A_{rent}, K\}$. The separability null (\ref{eq:null}) is stated in static partial-derivative form. §B.1 then switches to a two-period Lagrangian (\ref{eq:appB-objective})–(\ref{eq:appB-lagrangian}) with $\{C_1, C_2, a, L_{f,t}, L_{o,t}, K\}$ where $a$ is the period-1 purchase quantity and $A_{own,i,2} = A_{own,i,1} + a$. The two formalizations are not equivalent: the static (\ref{eq:null}) is a sign restriction on a partial derivative, while (\ref{eq:appB-step2}) is a derivative of a period-2 stock with respect to a period-1 flow. The reader has to silently substitute "$\partial A_{own}/\partial T$" in (\ref{eq:null}) with "$\partial A_{own,i,2}/\partial T_i$" or "$\partial a/\partial T$" from the appendix — these are not the same object.

Additional drift:
- $T_i$ vs $T_{SFFP}$ vs $T_{SFFP} \cdot D_i$ alternation. Main text §3.1 L100 introduces "$T = T_{SFFP}$" without subscripting; L132 then defines "$T_i = T_{SFFP} \cdot D_i$"; (\ref{eq:CO-1}) uses "$T_{SFFP}$" without the $\cdot D_i$ on the denominator; (\ref{eq:appB-budget1}) uses "$T_i = T_{SFFP} \cdot D_i$". These are the same object across the three sections but the reader has to confirm that fact each time.
- $\rho(W)$ semantics. (\ref{eq:appB-rho}) defines "$\rho(W_i) \in [0,1]$" as the maximum fraction of land price externally financeable. Main-text §3.2 L125 describes "$\rho(W_i)$" as a "wealth-dependent credit access function." These are consistent in spirit but the main text never tells the reader that $\rho \in [0,1]$ has the share-of-purchase-price interpretation; if the reader brings a Carter-Olinto 2003 prior, they may mentally substitute "credit-access shadow price slope" instead. Make the [0,1] share interpretation explicit in §3.2.
- $s_0$ definitional symmetry. §3.2 L139 writes "$s_{0,i} = A_{own,2018,i}/A_{2018,i}$"; §B.1 Step 3 L185 writes "$s_{0,i} = A_{own,i,2018}/A_{i,2018}$". Formally identical; cosmetically different. In a separability-test paper that already asks the reader to track $W_i, W_i^*, T_i, T_{SFFP}, D_i, s_{0,i}, \varphi(W_i^*), \tau, m, \mu/\lambda, w_{f,i}, w_m, \rho(W_i)$, every cosmetic inconsistency multiplies cognitive load.

**Why this matters.** Notation drift in a separability-test paper is more than a typesetting issue. The separability null (\ref{eq:null}) is the load-bearing object the paper claims to reject; if the readers cannot map a static partial derivative in §3.1 to the period-2 stock derivative in §B.1, they will not know what is being rejected.

**What would change my mind.** Add a notation table at the head of §3 (per the constructive peeve — see Positive observations) and a one-paragraph bridge before (\ref{eq:CO-1}) stating that the period-1-flow / period-2-stock formulation in §B.1 is the operational form of the static partial in (\ref{eq:null}). Concretely: replace "$\partial A_{own}/\partial T$" in (\ref{eq:null}) with a footnote stating that this is shorthand for the period-2 stock response to a period-1 transfer, and that the appendix delivers the closed form. Also harmonize $T_i = T_{SFFP} \cdot D_i$ across §3.1/§3.2/§B.1 — pick one form and use it throughout.

### Concern 3: SC1–SC5 are necessary conditions framed as sufficient; "$\partial \varphi(W^*)/\partial s_0 \le 0$" needs derivation, not stipulation

**Dimension:** 3 (Substantive Arguments)
**Severity:** MAJOR

**Description.** The §B.1 Step 3 derivation of (\ref{eq:appB-step3}) — the monotone-tenancy gradient — relies on the line "Differentiating (\ref{eq:appB-step2}) with respect to $(1-s_{0,i})$ and using $\partial \varphi(W^*)/\partial s_0 \le 0$." That last inequality is the empirical signature the paper rests on. It is justified verbally ("households with low $s_{0,i}$ sit closer to the indifference threshold $W^*$ in baseline wealth: they have not previously crossed and have higher $\varphi(W^*)$ at the threshold") but never derived from primitives. The claim that pure tenants have higher threshold-crossing density is plausible — but it is a joint implication of (i) wealth-bias $\rho'(W) > 0$, (ii) a baseline-wealth distribution that is monotone-decreasing in $s_0$ across the eligibility window, and (iii) the geometric proximity of low-$s_0$ households to $W^*$. Assumption (ii) is the missing primitive and it should be either added to the SC list as SC2.5 ("baseline wealth is monotone-decreasing in $s_0$ within the eligibility window") or derived from a covariance argument linking $s_0$ to $W$ in the FHES sample.

Related: SC1–SC5 are described as "sufficient conditions" but several read as necessary (e.g., SC5 panel stationarity is necessary for DiD-RD identification, not sufficient for the comparative-statics result). Distinguish between "what the derivation needs" (sufficient) and "what the empirical strategy needs" (identification). The §B.2 SC6–SC8 list has the same issue: SC6 ($\ell_h > 0$) is necessary for the channel to operate at all; SC7 (bounded curvature) is a regularity condition; SC8 (interior $\ell_o > 0$) is operational. None are "sufficient conditions" in the technical sense.

**Why this matters.** F1 falsification cannot be a clean test if the prediction it falsifies rests on a stipulated rather than derived monotone density. The referee for the empirical side (Referee B) will pressure-test the $s_0$ quintile cutpoint definition; if the theoretical underpinning of "higher $\varphi$ at lower $s_0$" is a verbal assertion rather than an SC, then F1 collapses to a heterogeneity-test-vs-data exercise, which is much weaker than the falsification framing claims.

**What would change my mind.** Either (i) add SC2.5 to the §B.1 SC list stating "baseline wealth $W_i$ and baseline own-share $s_{0,i}$ are negatively correlated within the eligibility window," with empirical support from FHES Wave~1 (one-line correlation coefficient suffices), OR (ii) derive the threshold-density monotonicity from the wealth-bias function $\rho(W)$ plus the production technology — specifically, show that under $\rho'(W) > 0$ the indifference threshold $W^*$ is reached by low-$W$ households who, by the data, are predominantly tenants. Also relabel SC1–SC8 to distinguish "sufficient for the comp-stat sign" (SC1, SC2, SC4) from "regularity assumptions" (SC7) from "identification conditions" (SC5) from "interior-solution conditions" (SC3, SC6, SC8).

### Concern 4: The $\tau \approx 25$ M KRW calibration drives (\ref{eq:CO-3}) but has no source citation

**Dimension:** 3 (Substantive Arguments) — also AJAE-magnitude lens
**Severity:** MAJOR

**Description.** §B.1 L209 states "for a Korean small farm tractor or combine with adjustment cost $\tau \approx 25 \times 10^6$ KRW/year (down-payment-equivalent)." This is the denominator of the $T_{SFFP}/\tau \approx 0.048$ ratio that drives (\ref{eq:appB-ratio}), which in turn justifies SC4 and (\ref{eq:CO-3}). The number has no source citation. "Down-payment-equivalent" is a substantive claim about the financial structure of Korean small-farm capital purchases that needs an institutional reference (Rural Development Administration / Statistics Korea / industry equipment-price report). At AJAE this kind of magnitude calibration is exactly what the methods referee will demand; a theory referee notices it because the closed-form prediction (\ref{eq:CO-3}) is empirically meaningful only if the calibration is honestly anchored.

A second magnitude in the same vicinity — the 17–34% hired-labor-share calibration for SC6 (§B.2 L367) — is at least anchored to "FHES Wave 1" but does not cite a specific table or vintage of the FHES.

**Why this matters.** "$T_{SFFP}/\tau \ll 1$" is what makes (\ref{eq:CO-3}) a falsifiable prediction rather than a tautology. If $\tau$ is mis-calibrated by a factor of 5 — entirely plausible for "down-payment-equivalent" claims about discrete equipment purchases — then the (S,s)-style inaction-band logic does not bite at the SFFP transfer scale, and the predicted $\le 0$ sign on op\_cost\_ex\_rent loses its theoretical justification.

**What would change my mind.** Add a source citation for $\tau \approx 25$ M KRW (Rural Development Administration agricultural machinery price report, KAMICO, or comparable; cite vintage). Also, lift the $T_{SFFP}/\tau$ ratio computation and the 17–34% hired-labor share into a magnitude-calibration paragraph in main-text §3.4 (the desk reviewer's constructive peeve for the methods referee). One paragraph; the numbers are already in the appendix. This is the cheapest revision in this report.

### Concern 5: Eq. EK-1 indeterminate sign is honest but weakens the theoretical contribution of §3.3 below the auxiliary-channel threshold

**Dimension:** 1 (Contribution & Novelty) and 3 (Substantive Arguments)
**Severity:** MAJOR

**Description.** (\ref{eq:EK-1}) and its appendix derivation (\ref{eq:appB-EK-step2}) deliver "$\partial \text{off\_farm\_income}/\partial T_{SFFP} \ne 0$" with theoretically indeterminate sign. The §B.2 derivation correctly shows that the income effect (more leisure, less off-farm work) and the supervision-relaxation effect (less hired labor, more family time available, more off-farm work) push in opposite directions; (\ref{eq:appB-EK-step1}) returns "$f(U_{CC}, U_{Cl}, F_{LL}, m) \ne 0$" without a sign. This is theoretically honest but the resulting falsification F2 ("$\hat\beta_4 = 0$ across all bandwidths $\Rightarrow$ supervision rejected") is logically asymmetric: if the income and supervision-relaxation effects happen to cancel at the SFFP transfer scale, F2 fires even though the supervision mechanism is operative. This is a known weakness of sign-indeterminate tests (cf. LaFave-Thomas 2016 §V on "joint-rejection diagnostics") and the paper acknowledges it ("Auxiliary status" §3.3 L172). I am not objecting to the auxiliary framing; I am objecting to F2's framing as a "rejection of the supervision-cost mechanism" when in fact it is a rejection of (mechanism operative) AND (effects do not cancel at the SFFP scale).

**Why this matters.** F2 is one of the two pre-registered falsifications. If it cannot cleanly reject the underlying mechanism, the paper's contribution narrows to one falsifiable channel (F1) plus a sign-indeterminate auxiliary channel — which is a different paper than "joint AHM-separability rejection via two independent margins."

**What would change my mind.** Either (i) tighten F2 to a conditional rejection: "$\hat\beta_4 = 0$ rejects the supervision channel conditional on the income and supervision-relaxation effects not exactly canceling — we test for this via [auxiliary test, e.g., heterogeneity in $\hat\beta_4$ by hired-labor share]"; OR (ii) demote F2 to "informative-but-not-rejecting" status in the F1+F2 joint logic, so that the "precise developed-country null estimate complementing LaFave-Thomas 2016" reframe rests on F1 alone with F2 as supporting evidence. The current framing presents F2 as symmetric to F1 in falsification force; it is not.

## Minor suggestions

- **Add a notation table at the head of §3.** Per the constructive peeve. Format: symbol → definition → first-use equation → units. Cover at minimum: $\{W_i, T_i, T_{SFFP}, D_i, s_{0,i}, \varphi(W_i^*), W_i^*, \tau, m, \mu/\lambda, w_{f,i}, w_m, \rho(W_i), a, A_{own,i,t}, A_{rent,i,t}, \pi^*\}$. This would reduce the cognitive load of the §3.1 / §3.2 / §B.1 cross-reference work that the reader currently has to do silently.
- **Cite Ghatak-Mookherjee 2024 NBER w31932 in §3.3.** A recent supervision-tenancy revisit that post-dates the §3 bibliography window; flagged by the editor's desk review (Probe 3). One sentence in §3.3 acknowledging the recent literature.
- **Cite Strauss 1986 chapter alongside Singh-Squire-Strauss 1986 at §3.1 L88.** The Strauss chapter is the formal-derivation companion to the SSS volume's introductory chapter and is the standard cite for the recursive-factorization argument. Currently only the SSS volume is cited.
- **Cite Pitt-Rosenzweig 1986 JPE at §3.3 or §B.2.** For the production-utility-jointness lineage that the supervision channel rests on. Currently the EK-channel literature trail is Eswaran-Kotwal 1986 → Benjamin 1992 — Pitt-Rosenzweig is the missing link.
- **§B.1 L257 closing paragraph:** "A full equilibrium treatment of the rental market remains for future work." Consider citing one specific paper that could deliver this closure (e.g., a quantitative spatial GE model á la Sotelo 2020 JPE or Costinot-Donaldson 2016 AER) so that the "future work" claim is operational, not aspirational.
- **(\ref{eq:appB-step1}) sign argument is hand-waved with "(other terms)."** The denominator is left as an opaque "+(other terms)" which is fine for compactness but the sign of $\partial W^*/\partial T$ depends on the relative magnitudes of the explicit and (other terms) pieces. A footnote with the full denominator (Hessian determinant assumption) would close this gap. Minor because the sign holds under standard regularity.
- **Table B.3 column 5 (Empirical fit) leaks the §5 results forward.** The numbers shown ($+1{,}089$ m², $-4.02$M, etc.) are P3b-2 estimates being mapped to the theoretical predictions before §5 has executed. This is fine in an appendix mapping table but flag for §5 to consistently reproduce these numbers, and add a footnote to Table B.3 stating that empirical-fit entries are "preliminary P3b-2 estimates pre-§5."

## Strengths

- **The Carter-Olinto B.1 derivation is the strongest part of the paper.** The two-period Lagrangian, the threshold-crossing argument (\ref{eq:appB-threshold}), and the Step 1→Step 2 progression from $\partial W^*/\partial T < 0$ to $\partial A_{own}/\partial T > 0$ is textbook-clean and faithfully extends Carter-Olinto 2003 to a policy-cutoff setting. The (\ref{eq:appB-step3}) monotone-tenancy gradient is, modulo Concern 3, a genuine cross-partial signature uniquely diagnostic of wealth-biased liquidity — and not of a universal income effect. This is the kind of formal-extension contribution AJAE rewards.
- **The B.1 closing paragraph (L249–258) is an honest "we cannot close the equilibrium" admission, not a post-hoc rescue.** The editor's desk-review flag noted that the language leans toward reading (a) honest reframe; I evaluated independently and concur. The specific phrasing "does *not* pin down the equilibrium response of the rental price $r$" combined with the main-text §3.4 caveat ("consistent with but not derived from our AHM-extension model") is the language of a careful theorist who has correctly diagnosed that a partial-equilibrium household model cannot deliver a closure on $r$ and refuses to claim otherwise. The fact that the rental-rate result was previously a primary channel (per the editor's note on the P3b-2 framing) and is now demoted to an ex-theory aggregate-equilibrium implication is the methodologically correct demotion. I would have flagged a problem if the B.1 closing paragraph claimed "we derive a negative equilibrium-rent response," because that derivation does not appear in B.1 and would require an aggregation-and-supply-elasticity argument the model lacks. The author has not made that mistake.
- **Pre-registration discipline (F1 + F2 + joint F1+F2 reframe).** The "precise developed-country null estimate complementing LaFave-Thomas 2016" reframe is a credible Plan B that makes this a publishable paper even under double null. Few AHM-separability papers I have refereed pre-commit to a graceful failure path; this one does.
- **Notation table absence is the only major presentation gap.** Constructive peeve fully addressed by adding the table.
- **The α3 framing is the correct rewrite.** A three-channel "tenant-driven land transition" descriptive story is not an AJAE theory contribution. A two-extension AHM-separability test with pre-registered falsification and an honest equilibrium caveat is. The reframing is the load-bearing change and it lands.

## Disposition stance

As the THEORY referee: the paper takes a stand and earns the right to test it. The Carter-Olinto extension is derived from primitives in a way that the empirical specification can reject; the Eswaran-Kotwal extension is honestly demoted to auxiliary and its sign-indeterminate prediction is correctly cabined. The B.1 ex-theory reframe of the bargaining/incidence margin is an honest "we can't close the equilibrium" admission, not a post-hoc defense. The four-anchor positioning (Singh-Squire-Strauss / dJFS / Benjamin / LaFave-Thomas / Carter-Olinto / Kazukauskas / Eswaran-Kotwal / Pitt-Khandker / Foster-Rosenzweig) is correct for an AJAE separability paper and the editor's desk review correctly identified two missing citations (Ghatak-Mookherjee 2024; Strauss 1986 chapter; I add Pitt-Rosenzweig 1986).

Where the paper has not yet earned a first-submission grade is in two places: (i) the main-text equation (\ref{eq:CO-1}) sign claim is a population aggregate written as an individual partial derivative without acknowledgment, which is the kind of notation drift that I flag as fatal-grade in a separability-test paper, but is fixable in a paragraph; and (ii) the $\tau \approx 25$ M KRW calibration is uncited, which is the kind of magnitude-anchoring gap that AJAE's methods referees will hammer.

The five major concerns are all closable in one revision pass. Concern 1, 2, and 4 are presentation / acknowledgment / citation fixes. Concern 3 is one additional SC plus a short FHES-correlation footnote. Concern 5 is a framing tightening on F2's falsification logic. None of the five touches the theoretical core of the Carter-Olinto derivation, which is the contribution.

## Final recommendation

**Major Revision.** Composite 82.5/100 sits in the upper-Major-Rev band: the paper has a defensible theoretical contribution but three concrete substantive defects (Concerns 1, 3, 4) that should be fixed before the paper is sent out for first-submission review under quality gate 90/100. None of the defects is fatal; all are addressable in a revision that takes 1–2 weeks of writing rather than a re-derivation. I would expect a clean R&R after one cycle.

Concern severity ranking: Concern 1 (eq:CO-1 individual-vs-aggregate) and Concern 4 ($\tau$ source citation) are the highest-priority fixes; Concern 2 (static vs two-period notation drift) and Concern 3 (SC list as necessary vs sufficient) are second-priority; Concern 5 (EK-1 falsification asymmetry) is third-priority and can be addressed via a framing paragraph rather than a re-derivation.
