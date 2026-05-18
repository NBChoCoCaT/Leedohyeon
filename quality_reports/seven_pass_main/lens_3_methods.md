# Lens 3 (Methods / identification) — Seven-Pass Review

**Manuscript:** `paper/en/main.tex` (319 L) + `paper/en/online_appendix.tex` (491 L)
**Date:** 2026-05-18
**Reviewer focus:** §3 Theoretical Framework, §6 Identification stub, §B.1 wealth-biased liquidity Lagrangian, §B.2 EK supervision, §B.3 mapping landscape table.

**Score:** 6.8 / 10

This is a serious draft. The α3 framework now has (i) a notation table, (ii) typed SC1–SC5 list with SC2.5 surfaced as a primitive, (iii) ITT-over-eligibility disclosure with Roth/Rambachan-Roth, (iv) sourced τ calibration via KREI+KAMICO and a 50% LTV reconciliation, (v) F2 demoted to "informative-not-rejecting," and (vi) a landscape per-bandwidth grid. For an AJAE-targeted theory section, that is most of the way home. The score is held below 8 by three load-bearing issues — a tightness gap in the SC2.5 wiring to Step 3, a sign-derivation hand-wave in eq.~(B.\arabic{step1}) that an AJAE referee will catch on first pass, and a still-presentational falsification rule for F1 that doesn't quite collapse to executable code despite the §B.3 grid.

---

## CRITICAL issues

### C1 — Step 1 sign derivation is not transparent (online_appendix.tex L163–169)
The implicit-function expression
$$\frac{\partial W_i^*}{\partial T_i} = - \frac{(R - \lambda_1/\lambda_2)\, p_{land}\, \rho'}{(R - \lambda_1/\lambda_2)\, p_{land}\, \rho' + \text{(other terms)}} < 0$$
claims the result is negative but the "(other terms)" placeholder hides the sign argument entirely. The numerator and denominator share the term $(R - \lambda_1/\lambda_2)\, p_{land}\, \rho'$, so the ratio's sign is **NOT** automatically negative — it depends on the sign of $(R - \lambda_1/\lambda_2)$ (the wedge between the market interest rate and the household's intertemporal MRS) and on what's hidden in "other terms." A credit-constrained household has $\lambda_1/\lambda_2 > R$ (shadow value of period-1 cash exceeds the market rate), which **flips** the numerator sign. An AJAE referee in macro-IO or development will spot this immediately.

**Fix:** Write the full implicit-function expression (cancel the common factor, derive a clean sign from a stated assumption like "$\lambda_1/\lambda_2 \le R$ in the binding regime" or "$\rho'' \le 0$ ensures concavity in the threshold"). Promote this assumption to SC1' or SC2'' and label it as `sufficient-for-sign (Step 1)`. The current writing reads like a sign-by-assertion.

### C2 — SC2.5 is load-bearing but its Step 3 wiring relies on an unstated lemma (online_appendix.tex L189–201, L263–274)
SC2.5 states $\mathrm{Cov}(W_i, s_{0,i}) < 0$ within the eligibility window. Step 3 then asserts "low-$s_{0,i}$ households sit closer to the indifference threshold $W^*$ in baseline wealth: they have not previously crossed and have higher $\varphi(W^*)$ at the threshold," and concludes $\partial \varphi(W^*)/\partial s_0 \le 0$.

The leap from $\mathrm{Cov}(W, s_0) < 0$ (a moment) to **monotone** $\partial \varphi(W^*)/\partial s_0 \le 0$ (a pointwise density gradient) is **not** automatic. Negative covariance is consistent with non-monotone conditional densities (e.g., bimodal mixtures, exactly what CLAUDE.md flags as the empirical own_share distribution: "52% pure owner + 12% pure tenant + 36% mixed"). Bimodality is precisely the data shape that breaks the monotone-in-$s_0$ density argument.

**Fix:** Either (i) strengthen SC2.5 to a stochastic-dominance condition — "$F(W \mid s_0)$ is decreasing in $s_0$ in the first-order stochastic sense within the eligibility window" — and verify on FHES Wave 1 with a Kolmogorov-Smirnov test by $s_0$ bin, or (ii) re-state Step 3 as a four-bin discrete claim ("$\varphi(W^* \mid s_0 = 0) \ge \varphi(W^* \mid s_0 \in (0, 0.33]) \ge \ldots$") and verify the four inequalities directly. The current writing finesses a real gap between SC2.5 and the Step 3 conclusion.

### C3 — F1's "operational decision rule" still contains a logical AND/OR ambiguity (online_appendix.tex L452)
The cell reads: "F1 fires if $p(\hat\beta_2 > 0) > .10$ at T2 **and** four-bin point estimates not weakly monotone-decreasing in $s_{0,i}$ at T1 **or** T2 (Holm-corrected)."

Without parentheses, this parses as $A \wedge (B \vee C)$ but a reader can also read it as $(A \wedge B) \vee C$. AJAE referees will read it the second way ("any monotonicity break fires F1") and flag the rule as over-sensitive given P3b-2's noisy four-bin point estimates at T1. The trigger column header (L449) also reads "F1 fires if $\hat\beta_2 \le 0$ at T2 **or** four-bin point estimates fail monotone-in-$(1-s_{0,i})$ ordering at T1 **and** T2" which differs from the Operational column. The header is "$\hat\beta_2 \le 0$ at T2 OR (monotone fails at T1 AND T2)" — meaningfully different from the Operational column's "(p > .10 at T2) AND (monotone fails at T1 OR T2)."

**Fix:** Reconcile the trigger column and the operational column to one boolean expression with explicit parentheses. Pre-register the exact formula in ADR-0001 or a new ADR-0004.

---

## MAJOR issues

### M1 — "Aggregation note" after eq:CO-1 mixes individual and population estimands (main.tex L172)
The note says eq:CO-1 is "a population-aggregate threshold-crossing magnitude written at the individual indexed by $i$ for compactness; the implied estimand is $\partial \mathbb{E}[A_{own,i} \mid \text{eligibility window}]/\partial T_{SFFP}$." Good — that's the right disclosure. But the boxed equation still carries the $i$ subscript on the LHS and on $\varphi(W_i^*)$, which an AJAE referee will read as $\varphi$ evaluated at household-$i$'s wealth — which doesn't make sense for a population density. Either drop the $i$ subscripts on the LHS and on $\varphi$ (write $\partial \mathbb{E}[A_{own} \mid W^* \in \text{window}]/\partial T_{SFFP}$) or carry the $i$ subscript through and explicitly cast $\varphi(W_i^*)$ as a conditional density at $W_i^*$.

### M2 — Magnitude calibration footnote claims "50% LTV" reconciles 50M vs 25M but provides no source (main.tex L224 footnote)
The 50% LTV figure is asserted ("typical 50% loan-to-value installment terms") with no cite. For Korean smallholder machinery, the empirically relevant LTV range is plausibly 50–80% under NongHyup financing programs, and the difference is not innocuous: at 70% LTV the down-payment is 15M, pushing $T_{SFFP}/\tau$ to 0.08 and shrinking the inaction-band margin. The robustness range $\tau \in [20\mathrm{M}, 40\mathrm{M}]$ partially covers this but the AJAE referee will ask for the LTV source explicitly.

**Fix:** Cite the KAMICO pricelist directly for LTV terms, or NongHyup 농기계 할부금융 program documentation. Promote to a brief sub-footnote.

### M3 — "Estimand and pre-period inference" paragraph (main.tex L151) is one sentence away from a full identification claim
The paragraph is good — it discloses ITT-over-eligibility, the 2018-baseline freeze, single-pre-period limitation, and the Roth 2022 + Rambachan-Roth 2023 HonestDiD response. What it does not do is **commit to a specific $\bar M$ value** (e.g., $\bar M = 1$ or $\bar M = 2$) for the smoothness-restricted alternative. The HonestDiD literature flags that the published version of the sensitivity bound is parameter-dependent; a paper that says "we report HonestDiD bounds" without saying "we report bounds at $\bar M \in \{0.5, 1, 2\}$ with $\bar M = 1$ headline" leaves the referee to infer the implementation choice. Pre-spec this.

### M4 — EK-1 sign-indeterminacy framing in F2 (main.tex L253) is theoretically correct but missing a key qualifier
The "cancellation possibility" language is right — the income effect on leisure and the supervision-relaxation channel can offset. What's missing is the **scope condition**: this cancellation only goes through if both margins are simultaneously interior in the SFFP eligibility window. If 88%+ of treated households have $\ell_h = 0$ (no hired labor — plausible for sub-0.5-ha smallholders), SC6 in §B.2 (L404) breaks, and the EK-1 mechanism is **inoperative** rather than canceling. The "F2 informative not rejecting" framing should distinguish (i) cancellation in an interior regime from (ii) SC6 corner-solution slack. Currently the main-text paragraph conflates the two.

### M5 — §B.3 landscape table operational rules tie to "R-conventions §10" but that doc is not co-located with the paper (online_appendix.tex L436, L443)
The table's operational decision rules say they "tie to R-conventions §10 bandwidth grid and ADR-0002 outcome-hierarchy pre-lock." Neither file is cited in the bibliography or `\input`-ed. For AJAE replication-package review this is fine; for a referee reading the PDF cold this is a dangling reference. Either include the R-conventions §10 grid as a small inline table at L443 or footnote the file path with the replication-package commit SHA.

### M6 — SC4 (T_SFFP < τ) is stated as sufficient-for-sign but the eq:CO-3 sign is $\le 0$, not $< 0$ (main.tex L181–183; online_appendix.tex L279–282, L240–243)
SC4 underwrites Step 4 which delivers $\partial\, \text{op\_cost\_ex\_rent}/\partial T_{SFFP} \le 0$. The non-strict inequality is correct (handles the corner case of no binding variable-input constraint, as the appendix notes at L240–243). But the F2-analog falsification trigger in the §B.3 table (L453) reads "$\hat\beta_3 > 0$ at any bandwidth" — which would also fire on a sampling-noise positive estimate. The asymmetry between the theoretical prediction (weak inequality) and the empirical trigger (strict) needs an explicit power calculation. What is the expected MDE on $\beta_3$ at T1 and T2 under the calibration? If MDE > the magnitude implied by the inaction-band logic, the F2-analog will fire on noise.

---

## MINOR polish

### m1 — Notation drift: $T_i$ vs $T_{SFFP}$ in eq:CO-1 (main.tex L169 boxed)
The boxed LHS is $\partial A_{own,i}/\partial T_{SFFP}$ (population-parameter derivative) but the equation is derived from differentiating with respect to $T_i$. The aggregation note (L172) addresses this in prose but the equation itself doesn't show the chain rule $\partial A_{own}/\partial T_{SFFP} = \partial A_{own}/\partial T_i \cdot D_i$. Add the one-line chain rule.

### m2 — Table 1 notation row for $\varphi(W_i^*)$ (main.tex L102) reads "Population density of household wealth at the threshold $W^*$ in the eligibility window"
But the symbol is written $\varphi(W_i^*)$ (with the $i$ subscript), which contradicts "population density." Drop the $i$ subscript on $\varphi$ in the notation table and propagate that fix to eq:CO-1.

### m3 — eq:CO-2 (main.tex L173–176) uses "$\partial^2 A_{own,i}/[\partial T_{SFFP} \partial (1 - s_{0,i})]$" but $s_{0,i}$ is a baseline (pre-treatment) covariate, not a continuous policy variable
The mixed partial derivative against a discrete-bin covariate ($s_0 \in \{0, (0, 0.33], (0.33, 0.67], 1\}$) is awkward. Replace with: "across baseline-tenancy bins $b \in \{1,2,3,4\}$, $\beta_2^{(b)}$ is monotone increasing in $b$" — i.e., recast as a comparative statement across discrete groups, matching the actual estimator (§B.3 row 2's "four-bin point estimates").

### m4 — §3.4 close "Equilibrium rent caveat" paragraph (main.tex L259) reports numeric estimates ($-130$ to $-48$ KRW/m², $-11.1\%$ pass-through) inside a theory section
These are §5-style empirical magnitudes that pre-empt the Results section. Move to §5.4 ex-theory unit_rent_price subsection (which is queued per the §5 TODO), or footnote them with "preliminary P3b-2 estimates pending §5 finalization." Currently the theory section discusses concrete estimates the reader has not yet been told the spec for.

### m5 — eq:appB-ratio (online_appendix.tex L228) uses $\tau \approx 25 \times 10^6$ KRW (down-payment-equivalent) but main-text §3.4.1 leads with 50M purchase-price as the headline
The two documents disagree on which τ is the headline. Pick one (50M is the cleaner, more-conservative headline; 25M is the inaction-band-friendlier one) and use the other only in robustness. Currently the appendix headline ratio is 0.048 (the larger one), and main-text §3.4.1 reports the interval [0.024, 0.048] — consistent in range but the appendix should at minimum disclose that 0.024 is the purchase-price endpoint with a parenthetical cross-reference.

### m6 — Citation: "Floyd (1965)" and "Alston and James (2002)" for incidence theory (main.tex L259; online_appendix.tex L296)
These are good citations for tax-incidence theory but a referee in agricultural economics will expect the **Alston-James (2002) Handbook of Agricultural Economics Vol. 2B Ch. 33** to be cited with chapter, not just the book. Confirm the BibTeX entry has the chapter number.

### m7 — SC3 "Participation slack" empirical support of "92.3% take-up" (online_appendix.tex L278)
The figure is cited to "FHES Wave 1" but the §3.4.1 (L228) sample-margin cross-reference says "% FILL post-§5 P3: cross-reference exact table cell" — the take-up rate is pre-committed in §B.1 but the cross-reference cell is pending. Lock the table cell pre-§5 estimation to preserve the pre-spec posture.

### m8 — Aggregation note at L172 says estimand is "the local average treatment effect at the cutoff" — but the design is DiD-RD, not pure RD
Strictly, the DiD-RD recovers an ITT-LATE-equivalent at the eligibility cutoff *averaged across the pre/post comparison*. The "LATE at the cutoff" framing is closer to a pure RD reading. Either tighten to "the ITT effect on the LATE-eligible subpopulation at the 0.5 ha cutoff, in the post-vs-pre difference" or cite Grembi-Nannicini-Troiano (2016) for the DiD-RD-specific estimand interpretation.

---

## Detailed audit table

| Item | Location | Issue | Severity |
|---|---|---|---|
| Step 1 sign hand-wave | online_appendix.tex L163–169 | "(other terms)" hides the sign argument; sign depends on $\lambda_1/\lambda_2$ vs $R$ | CRITICAL |
| SC2.5 → Step 3 leap | online_appendix.tex L189–201, L263–274 | Cov < 0 (moment) ⇏ $\partial\varphi/\partial s_0 \le 0$ (monotone density); bimodal $s_0$ distribution in data breaks this | CRITICAL |
| F1 boolean ambiguity | online_appendix.tex L449, L452 | AND/OR parenthesization conflict between Trigger column and Operational column | CRITICAL |
| Population vs individual mixing in eq:CO-1 | main.tex L169–172 | LHS keeps $i$ subscripts; $\varphi(W_i^*)$ on boxed eq vs "population density" in note | MAJOR |
| 50% LTV uncited | main.tex L224 footnote | NongHyup / KAMICO LTV source missing; LTV range matters for $T_{SFFP}/\tau$ | MAJOR |
| HonestDiD $\bar M$ not pre-spec | main.tex L151 | Says "we report HonestDiD bounds" without committing to $\bar M$ values | MAJOR |
| EK-1 cancellation vs SC6 slack | main.tex L253 | F2 framing conflates cancellation with corner-solution slack | MAJOR |
| R-conventions §10 dangling ref | online_appendix.tex L436, L443 | Op-rule table cites external doc not in bibliography | MAJOR |
| SC4 weak inequality vs strict trigger | online_appendix.tex L453 | β_3 ≤ 0 (theory) vs β_3 > 0 trigger (strict); no MDE | MAJOR |
| Chain-rule omission $T_i$ vs $T_{SFFP}$ | main.tex L169 boxed | Differentiation against $T_i$ but LHS is $\partial/\partial T_{SFFP}$ | minor |
| Notation table $\varphi(W_i^*)$ subscript | main.tex L102 | "$i$" subscript on a population-density symbol | minor |
| Mixed partial against discrete $s_0$ | main.tex L173–176 (eq:CO-2) | Continuous derivative notation for a four-bin covariate | minor |
| §3.4 numeric estimates in theory section | main.tex L259 | -130/-48/-11.1% should move to §5 or footnote as preliminary | minor |
| τ headline disagreement appendix vs main | online_appendix.tex L228 vs main.tex §3.4.1 | Appendix leads with 25M, main leads with 50M | minor |
| Alston-James chapter cite | main.tex L259; online_appendix.tex L296 | Verify Handbook Vol. 2B Ch. 33 detail in BibTeX | minor |
| Take-up 92.3% pre-spec lock | online_appendix.tex L278 vs main.tex L228 footnote | Cross-ref pending — should lock pre-§5 | minor |
| LATE-at-cutoff vs DiD-RD estimand | main.tex L172 | "Local ATE at cutoff" is RD, not DiD-RD; cite Grembi et al. | minor |

---

## Identification credibility summary

The AHM-separability test rests on three foundations: (i) the 2018-baseline frozen running variable, which buys clean RD identification against ex-ante manipulation; (ii) the Carter-Olinto-style wealth-bias cross-partial, formalized as eq:CO-2 and underwritten by SC2.5; and (iii) the Caballero-Engel (S,s) inaction-band logic mapped to the operating-cost prediction via SC4 and the $T_{SFFP}/\tau \in [0.024, 0.048]$ calibration. The first foundation is rock-solid — the 2018-freeze is the cleanest single design choice in the paper and the McCrary continuity check is already in P3b. The third foundation is now empirically anchored by the KREI+KAMICO dual cite and is defensible at AJAE level, modulo the LTV-source critique (M2) and the appendix/main headline alignment (m5).

The second foundation — the Carter-Olinto wealth-bias channel — is where the AJAE referee will spend the most time, and where the paper is most exposed. The chain runs: SC2.5 ($\mathrm{Cov}(W, s_0) < 0$) $\Rightarrow$ $\partial \varphi(W^*)/\partial s_0 \le 0$ $\Rightarrow$ eq:CO-2 monotone gradient $\Rightarrow$ F1 falsification trigger. Each link in this chain has a soft spot: the SC2.5-to-monotone-density leap (C2) is the load-bearing one, and the §B.3 F1 operational rule (C3) has a parenthesization bug that an AJAE referee will read as either over-sensitive or under-sensitive depending on interpretation. Combined with the Step 1 sign hand-wave (C1) — which is recoverable but as-written is not transparent — the wealth-bias channel's theoretical scaffolding is the weakest part of an otherwise strong framework.

For the §3 → §5/§6 setup, §3 does enough work to license §5's headline claims under the present framing — the four-bin partition rule is pre-locked, F1's load-bearing status is explicit, F2 is correctly demoted, and the ex-theory rent-capitalization disclosure (Floyd 1965; Alston-James 2002) is appropriately scoped outside the model. What §3 does not yet do is hand §6 a fully operationalized identification stub with explicit ($D \times \text{Post}$, $rv \times \text{Post}$, $D \times rv \times \text{Post}$) triple-interaction in the regression form and a written HonestDiD $\bar M$ commitment. §6 is a placeholder, which is fine for this draft, but §3.1's "Estimand and pre-period inference" paragraph should expand by ~50% to fully anticipate §6 in pre-spec form. With C1–C3 resolved and M1–M6 addressed, this section becomes AJAE-credible at ≈8.5–9.0 on the same rubric.

---

## Score rationale

- **Foundation (notation, scope, ex-theory discipline):** 8.5/10. The notation table, A1 aggregation note, A5 F2 demote, A8 estimand paragraph, and A9 landscape grid are all serious contributions. The α3 framework is meaningfully tightened from the pre-PR-7 draft.
- **Derivation rigor (Step 1–4, SC list):** 6.0/10. The SC1–SC5+SC2.5 typed taxonomy is excellent (A3 hot-fix landed). But C1 (Step 1 sign hand-wave) and C2 (SC2.5-to-monotone-density gap) are AJAE-referee-visible holes. M6 (weak-vs-strict inequality in SC4 vs F2-analog trigger) compounds.
- **Identification disclosure (ITT, parallel trends, HonestDiD):** 7.5/10. The A8 paragraph is strong but M3 (no $\bar M$ commitment) and m8 (LATE-at-cutoff vs DiD-RD estimand framing) leave easy points on the table.
- **Magnitude calibration (τ, $T_{SFFP}/\tau$):** 7.5/10. KREI+KAMICO dual cite and the 50% LTV reconciliation are exactly what the A4 hot-fix needed. M2 (LTV source) and m5 (appendix/main headline) are easy fixes.
- **Falsification logic (F1 load-bearing, F2 informative-not-rejecting, §B.3 grid):** 5.5/10. The A5 demote is correct theoretically (M4 caveat aside), but C3 (boolean ambiguity in §B.3 F1 trigger) is the single highest-priority fix. The operational decision rules are 80% of the way to executable but the 20% gap is exactly what a pre-registration audit will catch.

**Weighted score: 6.8/10.** With C1–C3 resolved and M1–M6 addressed in a §3 revision pass (≈6–10 hours of work, no new analysis), this becomes 8.5–9.0/10 and clears the 90/100 first-submission AJAE threshold for the methods/identification dimension. Without resolving C1–C3, expect an AJAE R&R with a 1st referee report concentrated on the wealth-bias derivation chain.
