Calibrated to: American Journal of Agricultural Economics (AJAE), Disposition: CREDIBILITY+MEASUREMENT, Paper type: Theory+empirics

# Methods Referee Report

**Calibrated to:** American Journal of Agricultural Economics (AJAE)
**Disposition:** CREDIBILITY+MEASUREMENT hybrid (Empirical Ag Economics)
**Paper type:** Theory+empirics
**Critical peeve:** Heterogeneity must be pre-specified or clearly exploratory; no p-hacking via subgroup analysis.
**Constructive peeve:** Magnitude interpretation — what does a coefficient mean in dollars / percentage points / effect sizes relative to the mean?
**Date:** 2026-05-18

## Executive verdict

**Score:** 73/100
**Recommendation:** Major Revision
**Headline:** The §3 framework is theoretically tight and derives genuinely sharp closed-form predictions, but its empirical pre-specification posture is fragile in three load-bearing places (s₀ quintile cutpoints, outcome-hierarchy reorder timing relative to P3b-2 results, $T_{SFFP}/\tau$ calibration provenance), and the §B.3 mapping table cannot bear the weight the framework places on it until those pre-specification anchors are made auditable to a DCAS v1.0 referee.

### Paper-type rationale

The §3 alpha-test scope is unambiguously **theory+empirics**: §3.1 derives the AHM separability null (\ref{eq:null}); §3.2–3.3 derive two closed-form predictions (\ref{eq:CO-1})–(\ref{eq:CO-3}) and (\ref{eq:EK-1}) with full Lagrangian derivations in §B.1–B.2; §B.3 then maps each theoretical sign to an econometric $\hat\beta$ with a pre-registered falsification trigger. The model is doing real contribution work (it identifies the cross-partial signature \ref{eq:CO-2} as uniquely diagnostic of wealth-bias and not of universal income effect), and the empirics validate (or falsify) predictions whose signs would otherwise be unidentified. Pure reduced-form weighting (Identification 35/Estimation 25/Inference 20) would underweight the prediction-sharpness dimension and overweight §5 design choices that are not yet in scope. Theory+empirics weights (Model 20/Prediction 25/Test design 25/Honesty 15/Execution 15) are applied below, with AJAE adjustment: Magnitude lifted from 15→18 absorbed into Test design (which carries the measurement/construct-validity work for this paper-type), Honesty lifted from 15→17 to reward the disclosed B.1 reframe.

## Pre-scoring sanity checks

| Check | PASS/FAIL | Evidence |
|---|---|---|
| **Prediction sharpness** | PASS | Eqs. (\ref{eq:CO-1})–(\ref{eq:CO-3}) give signed predictions, not "some effect"; (\ref{eq:CO-2}) gives a sign on a *cross-partial* — sharper than a typical AHM-test paper. (\ref{eq:EK-1}) is honestly signed indeterminate, with the indeterminacy itself defended on theoretical grounds (L170). |
| **Test power** | PARTIAL | The §B.3 magnitudes (T2 pure-tenant $+1{,}089$ m², T3 area_total $+408$ at $p=.003$) suggest the design has power on $\beta_1$ and the gradient $\beta_2$. F2 power on $\beta_4$ (off_farm_income) is unverified — the cell reads "TBD (auxiliary in P3b-2)" (L409). Acknowledged limitation, not blocking, but means the F2 falsification is currently "we will look" rather than "we have looked and not seen it." |
| **Honest reporting** | PARTIAL | B.1 ex-theory demotion is honest (L249–258, L208 in main text). However, the outcome-hierarchy reorder per ADR-0002 (2026-05-18, same day as α3 rewrite) post-dates the P3b-2 c296ff9 results — see Concern 2 below. The §3 text does not disclose that the hierarchy is a post-results reorder. |
| **Construct validity (T, W, s₀)** | PARTIAL | $T_{SFFP} = 1{,}200{,}000$ KRW/year is a clean institutional construct (L100). $s_{0,i} = A_{own,2018,i}/A_{2018,i}$ is measurable from FHES with caveats on self-reported area (no measurement-error discussion). $W^*$ remains a latent — only comp-stat *signs* depend on it, which is methodologically defensible but should be made explicit. |
| **Magnitude calibration** | PARTIAL | $T_{SFFP}/\tau \approx 0.048$ is stated (\ref{eq:appB-ratio}) but $\tau \approx 25 \times 10^6$ KRW is asserted without a sourced citation (L209: "Korean small farm tractor or combine with adjustment cost $\tau \approx 25 \times 10^6$ KRW/year (down-payment-equivalent)"). 92.3% take-up (SC3, L240) and 17–34% hired-labor share (SC6, L367) are likewise asserted without explicit FHES wave-table cross-reference. |

**Any FAIL caps composite score at 70.** No outright FAIL; three PARTIALs collectively cap at the high-70s under the AJAE DCAS v1.0 standard, which is consistent with the Major Revision recommendation.

## Dimension scores

| # | Dimension | Weight | Score | Weighted |
|---|---|---|---|---|
| 1 | Model | 20% | 82 | 16.4 |
| 2 | Prediction sharpness | 25% | 84 | 21.0 |
| 3 | Test design (incl. construct validity, magnitude calibration; AJAE-adjusted) | 25% | 62 | 15.5 |
| 4 | Honesty (report non-confirming + disclose reframes; AJAE-adjusted to 17%) | 17% | 70 | 11.9 |
| 5 | Execution | 13% | 65 | 8.5 |
| | **Composite** | **100%** | | **73.3** |

Composite **73.3 → Major Revision** (65–79 band).

## Major concerns (each with "What would change my mind")

### Concern 1: $s_0$ quintile cutpoints and "pure tenant / pure owner" anchors are not auditably pre-locked

**Dimension:** 3 (Test design / pre-specification)
**Severity:** MAJOR
**Description:** Equation (\ref{eq:CO-2}) is the load-bearing falsification signature: a monotone-in-baseline-tenancy cross-partial. The §B.3 empirical-fit cell for $\beta_2$ reports "T2 monotone: $-1738$, $-600$, $-393$, $0$ across quintiles" (L407). Four bins are reported, but neither §3.2 nor §B.1 Step 3 (L184–198) commits to whether these are (a) own_share quintiles, (b) the four-bin "pure_tenant / low_owner / mixed / pure_owner" stratification used elsewhere in CLAUDE.md, or (c) a third anchor scheme. The desk review explicitly flags the $s_0$ quintile cutpoint, the pure-tenant/pure-owner anchor choice, and the bandwidth-by-channel grid as pressure-points for pre-specification audit. The text of §3.2 (L139) defines $s_0$ via the underlying continuous ratio; the §B.3 table presents discrete bins; the bridge between continuous theory and discrete empirics is unspecified. ADR-0002 (2026-05-18) documents the outcome-hierarchy reorder but does *not* commit to a binning rule. A DCAS v1.0 referee will read "monotone across four bins, three negative coefficients" as a tunable test until the cutpoints are visibly pre-locked.

**Why this matters:** The F1 falsification (L203) loses force if the bins were chosen after seeing the gradient. Under wealth-biased liquidity (Carter-Olinto 2003), the *direction* of monotonicity is pre-specified, but the *power* of the test depends on bin density at the threshold. With four bins, there are 4! = 24 orderings, of which 1 is the predicted monotone — a $p \approx 0.04$ prior under the null even before peeking. With quintiles (5 bins), the prior is $1/5! = 0.008$. Cutpoint choice therefore directly affects the Bayes factor on F1.

**What would change my mind:** A footnote in §3.2 or a paragraph in §B.1 Step 3 (after \ref{eq:appB-step3}) that (i) commits to the discrete partition rule — quintiles by FHES baseline $s_{0,i}$, or the four-bin {pure_tenant: $s_0 = 0$; low_owner: $0 < s_0 \le 0.33$; mixed: $0.33 < s_0 \le 0.67$; pure_owner: $s_0 = 1$} convention — and (ii) cites the ADR / pre-registration timestamp where this partition was locked relative to P3b-2 results. The R-conventions §10 doc would be a natural place to anchor; the §3 manuscript should at minimum reference it.

### Concern 2: Outcome-hierarchy reorder (ADR-0002, 2026-05-18) post-dates P3b-2 results without §3 disclosure of timing

**Dimension:** 4 (Honesty)
**Severity:** MAJOR
**Description:** ADR-0002 (`quality_reports/decisions/2026-05-18_outcome-hierarchy.md`) documents that `area_own` was promoted to primary #1 *on 2026-05-18* — the same day as the α3 §3 rewrite, and after the P3b-2 c296ff9 three-channel results (CLAUDE.md identification block lists rent_cost −11.1%, op_cost_ex_rent −4.02M/−3.22M, area_own monotone-gradient magnitudes already in the project record). The reorder is methodologically defensible — the ADR's Option-B rationale ("the theory dictates the hierarchy") is sound — but §3 of the manuscript does not disclose to the reader that the outcome ranking is a post-results reorder rather than an ex ante design. The §B.3 table footer simply asserts the new hierarchy without timestamp. To a referee inspecting only the manuscript (the AJAE-DCAS audit target), the framing reads as ex ante; to an editor with access to the project ADRs, it reads as post-hoc. The asymmetry is the problem.

**Why this matters:** AJAE editors at the DCAS v1.0 era explicitly value pre-specification *visible to the referee*, not pre-specification documented in private project artifacts the referee never sees. A pre-specification that has to be reconstructed from internal ADR timestamps is, for a referee's audit purpose, indistinguishable from no pre-specification. The honest move costs little — a footnote disclosing the timing — and protects the contribution from the post-hoc-framing reading the desk review flagged.

**What would change my mind:** (i) A footnote at L88 ("We test the \citet{SinghSquireStrauss1986_ahm} ... null") or at the §3.4 outcome-table (L181–199) that states: "The outcome hierarchy reported in Table 3 (area_own primary #1, op_cost_ex_rent primary #2, off_farm_income auxiliary, unit_rent_price / rent_cost ex-theory) is the realignment under α-strict scope adopted prior to §5 estimation under the present framing; the earlier P3b-2 three-channel framing reported rent outcomes as headline and is documented separately in ADR-0001 and ADR-0002." (ii) Public archival of the ADRs in the replication package (`scripts/R/synthetic/README.md` would be a natural cross-link) so the referee can independently verify the timestamp.

### Concern 3: $\tau \approx 25 \times 10^6$ KRW calibration is asserted without source — and $T/\tau = 0.048$ sits at the Caballero-Engel boundary

**Dimension:** 3 (Test design / construct validity / magnitude calibration)
**Severity:** MAJOR
**Description:** Equation (\ref{eq:appB-ratio}) computes $T_{SFFP}/\tau = 1.2/25 = 0.048$ and uses this to justify SC4 (L241) and the sub-prediction (\ref{eq:CO-3}). The denominator is stated as "$\tau \approx 25 \times 10^6$ KRW/year (down-payment-equivalent)" with no citation. Possible sources: (a) KAEA / KREI cost-of-cultivation surveys; (b) NABO / Korea Rural Economic Institute machinery investment tables; (c) a Kazukauskas (2013)-style imputation from depreciation flows; (d) CLAUDE.md project-memory calibration ("s_min ≈ 5,000만원 Korean tractor/combine 자가부담" — note: 5,000만원 = 50M KRW, double the §B.1 figure of 25M, which raises an internal consistency question the author should resolve). None of these is disclosed. Moreover, Caballero-Engel (1999) macro-lumpy work places $T/s_{\min}$ thresholds for triggering inaction in the 5–10% range; 4.8% is just inside that band. The sub-prediction (\ref{eq:CO-3}) — that the household absorbs $T$ on non-capital margins — is highly sensitive to whether the true $\tau$ is 20M, 25M, 40M, or 50M, with the threshold ratio moving from 6% to 2.4% across that range. Inside that range, the prediction $\beta_3 \le 0$ holds; outside, the theoretical sign breaks. The empirical $\beta_3$ reported in §B.3 (T1 $-4.02$M, $p=.055$) is at $p \approx .055$, also at a boundary.

**Why this matters:** The constructive peeve. A coefficient of $-4.02$M KRW on op_cost_ex_rent means what? Relative to a mean op_cost_ex_rent of (?, not reported in §3), it is a (?%, not reported) effect. The same applies to $-1{,}089$ m² on area_own (what is the mean area_own among pure tenants? 1,089 m² is what fraction?). A "magnitude calibration" sub-section at the close of §3.4 — listing (i) $T_{SFFP}/\tau$ with cited $\tau$ source, (ii) the threshold-density $\varphi(W^*)$ implied by 92.3% take-up *with* the FHES wave-table cell that produces 92.3%, (iii) the hired-labor share with KAEA/KREI source, (iv) the area_own and op_cost_ex_rent means against which the magnitudes are interpreted — would convert four asserted numbers into a calibration audit a DCAS v1.0 referee can follow. The numbers are doing real theoretical work; lifting them to a calibrated sub-section costs ~250 words and strengthens the framework's empirical anchoring.

**What would change my mind:** A "§3.4.1 Magnitude calibration" (or §B.4) sub-section with sourced citations for $\tau$, 92.3% take-up (FHES Wave 1 cell reference), 17–34% hired-labor share (FHES table), and a one-line robustness statement that the (\ref{eq:CO-3}) prediction $\beta_3 \le 0$ holds for $\tau \in [20\text{M}, 40\text{M}]$ KRW, with the comparison to CLAUDE.md's 50M figure resolved (e.g., 50M is total purchase price including financed share; 25M is down-payment-equivalent — make the bridge explicit). The (\ref{eq:appB-ratio}) ratio at 0.048 is *close enough* to the Caballero-Engel boundary that the robustness statement is necessary, not optional.

### Concern 4: Identification framework (§3) over-commits to clean DiD-RD without acknowledging the ITT-on-Channel-A versus post-2020 endogeneity distinction or addressing one-pre-period (Roth 2022) parallel-trends limits

**Dimension:** 3 (Test design / identification)
**Severity:** MAJOR
**Description:** §3 references but does not estimate; §5 is TODO. However, §3 commits the empirical strategy via (\ref{eq:appB-step2}) and the §B.3 table, which presume that $\partial A_{own}/\partial T_{SFFP}$ is the *causal* household-level response to the subsidy. Two identification subtleties bind that the §3 framework does not surface:

(i) **ITT versus post-2020 endogeneity.** The CLAUDE.md identification block locks the running variable at $rv_{2018} = area_{2018} - 5{,}000$. The treatment dummy $D$ is fixed at 2018 baseline. The DiD-RD estimand is therefore an *Intent-to-Treat* (ITT) over Channel A — own_share-induced eligibility — and is *not* the same as the post-2020 area changes (which become endogenous to the subsidy if a household crosses the 0.5 ha line in response to SFFP). §3.1 and §3.2 should explicitly note that the predicted $\partial A_{own,i}/\partial T_{SFFP}$ is the post-period area response (which may include endogenous threshold-crossings) and that the ITT design recovers the eligibility-induced reduced-form effect at the 2018-baseline frozen cutoff. This is a non-trivial caveat — the prior simulation in `.claude/agents/domain-reviewer.md` (per the task brief) flagged precisely this issue for AJAE referees.

(ii) **One pre-period parallel-trends.** With pre-periods 2018 and 2019 and post = 2020+, there is effectively *one* pre-period gap (2018→2019) over which to assess parallel trends prior to the policy. Roth (2022, AER:Insights) shows that pre-trend tests with one pre-period are nearly uninformative about the post-period parallel-trends violation. §3 should leave room for HonestDiD-style $\bar M$ bounds (Rambachan-Roth 2023, ReStud) in §robustness; currently §3 implicitly treats parallel trends as a binary pass/fail rather than a continuum.

**Why this matters:** The framework is committing §5 to claims the identification cannot fully support. A theory+empirics §3 should be honest about which assumptions are required for the predicted $\hat\beta$s to be interpretable as the theoretical comparative statics. Otherwise §5, when written, will either (a) over-claim, triggering a Reject-and-Resubmit, or (b) introduce caveats that contradict §3, triggering a coherence complaint.

**What would change my mind:** A short paragraph at the close of §3.1 (after L118) — two to four sentences — stating: "The DiD-RD design exploits the 2018-baseline frozen cutoff at 5,000 m² (CLAUDE.md identification block; \S\ref{sec:identification}); the recovered estimand is therefore an ITT over eligibility-as-determined-by-2018-area, and we caveat $\partial A_{own,i}/\partial T_{SFFP}$ as the eligibility-induced effect on post-period own area, robust to post-2020 threshold-crossings being endogenous. Parallel-trends inference rests on the 2018–2019 pre-period gap; we report HonestDiD bounds in the robustness appendix." This costs ~80 words and protects §3 from over-commitment.

### Concern 5: §B.3 mapping table lacks per-bandwidth predictions and conflates T1/T2/T3 magnitudes

**Dimension:** 3 (Test design)
**Severity:** MAJOR
**Description:** The §B.3 expanded mapping (L402–415) reports a single empirical-fit cell per row but mixes bandwidths within rows (e.g., $\beta_1$ row: "T2: $+1{,}089$ m² pure tenant ($p=.033$); T3: $+408$ ($p=.003$)"). The theoretical predictions (\ref{eq:CO-1})–(\ref{eq:CO-3}) are bandwidth-invariant signs; the empirical execution must report all three bandwidths (T1 ±500m², T2 ±1000m², T3 MSE-optimal per CLAUDE.md). The current table does not show T1 for $\beta_1$, does not show T3 for $\beta_2$, and the falsification trigger column reads "$\hat\beta_1 = 0$ uniformly" — which uniformly across what? Across T1, T2, T3? Across $s_0$ bins? The ambiguity makes the falsification rule operationally underspecified. A DCAS v1.0 referee will require the per-bandwidth fit grid before accepting the F1 trigger as binding.

**Why this matters:** Pre-registration discipline (the critical peeve) requires that falsification rules be operational. "$\hat\beta_1 = 0$ uniformly" admits multiple readings. If the rule is "$p > .10$ at all three bandwidths," state it. If it is "$|\hat\beta_1| < $ (some threshold) at the headline T2 bandwidth," state it. The §3 framing as currently written gives the author latitude that the heterogeneity-peeve will not let pass at AJAE.

**What would change my mind:** Expand the §B.3 table to a per-bandwidth grid (T1/T2/T3 × $\beta_1/\beta_2/\beta_3/\beta_4/\beta_5$), with the falsification trigger operationalized as a concrete decision rule (e.g., "F1 fires if $p(\hat\beta_2 > 0) > .10$ at T2 *and* the four-bin point estimates fail to be monotone in the predicted direction"). The R-conventions §10 bandwidth grid is the natural anchor; tying §B.3 to it makes the test reproducible.

## Minor suggestions

1. **§3.1 L100 lump-sum-vs-flow distinction.** State explicitly that $T_{SFFP} = 1{,}200{,}000$ KRW/year is an *annual flow* (not a one-shot lump sum), and clarify whether the household's optimization horizon in §B.1 treats this as a permanent annuity (which (\ref{eq:CO-threshold})'s $T/(1-\beta)$ permanent-income-equivalent transformation implies) or as a one-shot transfer to period-1 wealth (which the §B.1 two-period setup at L91–127 seems to use). The two are conceptually different; the (S,s) inaction logic in §B.1 Step 4 (\ref{eq:appB-step4}) is sensitive to which interpretation holds.

2. **Measurement error in $s_{0,i}$.** FHES self-reported $A_{own,2018,i}$ and $A_{2018,i}$ each have classical measurement error; the ratio $s_{0,i}$ inherits attenuation bias on $\beta_2$. A footnote acknowledging this — and noting that the four-bin discrete partition is robust to small measurement-error perturbations relative to the continuous-ratio interaction — would close a measurement loophole.

3. **92.3% take-up source.** SC3 (L240) cites "FHES Wave~1 take-up rates of 92.3% among eligible households" but does not give the wave-table reference. Add: "(FHES Wave 1, 2020, Table X.X)" or equivalent.

4. **17–34% hired-labor share source.** SC6 (L367) cites "FHES Wave~1 hired-labor share is approximately 17–34% across baseline-tenancy quintiles." Same fix: add the FHES table reference. The range itself — 17% at high $s_0$, 34% at low $s_0$ — is a substantive finding deserving a one-line cross-reference rather than a parenthetical.

5. **Bandwidth grid in §B.3 should be standardized notation.** The table currently uses bare "T2" / "T3" labels; spelling out "T1 ($\pm 500$ m²), T2 ($\pm 1{,}000$ m²), T3 (MSE-optimal, `rdrobust`)" in the table notes — matching the CLAUDE.md identification block — would make the empirical-fit cells legible without external lookup.

6. **§B.1 closing paragraph (L249–258) is excellent and should be cross-linked from main-text §3.4 paragraph at L208.** Currently the main-text "Equilibrium rent caveat" reads slightly defensively; the §B.1 closing paragraph reads honestly. A cross-reference would let §3.4 lean on §B.1's more measured tone.

7. **CLAUDE.md vs §B.1 numeric discrepancy.** CLAUDE.md cites "$T/s_{\min} \approx 2.4\%$ ($s_{\min} \approx 5{,}000$만원 = 50M KRW)"; §B.1 (\ref{eq:appB-ratio}) cites "$T/\tau \approx 0.048$ ($\tau \approx 25 \times 10^6$ KRW)." The factor-of-two discrepancy may be down-payment vs purchase price, but it should be reconciled in the paper before §5 lands. See Concern 3.

8. **AEA DCAS v1.0 compliance footnote.** The synthetic generator (scripts/R/synthetic/, P5 complete 2026-05-07) is the right vehicle for AJAE DCAS compliance under FHES restricted-microdata constraints, but §3 does not reference it. A single footnote at §3 (or a §B prefatory note) acknowledging the synthetic-verification strategy — without elevating it to the main text — would preview the replication package the editor will look for at Phase 4.

## Positive observations

1. **The (\ref{eq:CO-2}) cross-partial signature is genuinely sharp.** It rules out a universal income effect (under which all $s_0$ bins would respond proportionally) by exploiting heterogeneity in the threshold-crossing density $\varphi(W^*)$, which Carter-Olinto's wealth-bias structure gives a directional sign. Most AHM separability-test papers fall back on "look for any non-zero effect" tests; this paper commits to a cross-partial that is harder to satisfy by accident.

2. **The B.1 ex-theory demotion (L249–258) is methodologically honest.** Demoting unit_rent_price and rent_cost from primary outcomes (P3b-2 three-channel framing) to "consistent with but not derived from" reduced-form evidence (α3 framing) is the right move. The §B.1 closing paragraph explicitly states what the model does *not* show — a discipline rarer than it should be. The methods-referee reading: the reframe survives audit.

3. **F1 and F2 falsification triggers are real, not theater.** F1 fires on a directional gradient that the wealth-bias mechanism uniquely predicts; F2 fires on a single coefficient that the supervision mechanism uniquely predicts. F1+F2 jointly trigger the LaFave-Thomas (2016) precise-null reframe — also a real fallback rather than rhetorical retreat. The §3.4 paragraph (L201–206) and §B.3 table (L407–409) align on the trigger definitions.

4. **SC1–SC8 sufficient-condition list is appropriately granular.** SC3 (92.3% take-up empirical anchor) and SC4 ($T < \tau$ empirical anchor) tie theoretical regularity conditions to empirical magnitudes — the right level of discipline for a theory+empirics paper.

5. **Bibliography anchors (Kirwan 2009 JPE, Ciaian 2023 LUP, Kazukauskas 2013 AJAE, Carter-Olinto 2003 AJAE) are clean.** The four AJAE anchors are cited where they should be: Kirwan/Ciaian as the rent-incidence comparison ($-11.1\%$ pass-through reversal versus US $+25\%$ / EU $+46$–$55\%$), Kazukauskas as the decoupling-disinvestment lineage for (\ref{eq:CO-3}), Carter-Olinto as the wealth-bias backbone. No gratuitous citations; no missing anchors. The α3 framing earns its theoretical home.

6. **Recursive factorization argument (L102–116) is textbook-clean.** The separability null (\ref{eq:null}) is correctly derived from the recursive structure; the (\ref{eq:profit-max})–(\ref{eq:utility-max}) decomposition is the right pedagogical level for AJAE — granular enough for the methods referee to check, compact enough to be readable.

7. **The Lagrangian derivations in §B.1 and §B.2 are rigorous.** §B.1 Steps 1–4 (\ref{eq:appB-step1})–(\ref{eq:appB-step4}) walk through the comparative statics in the right order; the implicit-function-theorem step at (\ref{eq:appB-step1}) is correctly applied to the threshold condition (\ref{eq:appB-threshold}). §B.2 (\ref{eq:appB-EK-foc-C})–(\ref{eq:appB-EK-step2}) similarly works the FOCs cleanly to the shadow-wage divergence (\ref{eq:appB-EK-MPL}). A theory referee will find no derivation gaps.

---

**Summary for the editor:** The §3 + Appendix B alpha-test is a genuinely sharp theory+empirics framework with a real cross-partial falsification signature and honest reframes. It is not yet ready for AJAE because the pre-specification posture is fragile in five auditable places (s₀ binning, ADR-0002 timing disclosure, $\tau$ calibration provenance, ITT/parallel-trends caveats, per-bandwidth falsification grid). All five are *fixable in a Major Revision* without touching the theoretical core. None requires a reframe of the contribution. The disposition that produced this review (CREDIBILITY+MEASUREMENT) flags these specifically because a DCAS v1.0 audit at submission will surface them; addressing them in revision avoids re-litigation at the referee stage and converts a borderline-defensible §3 into one that can carry an aggressive §5 (when it lands) without coherence loss.
