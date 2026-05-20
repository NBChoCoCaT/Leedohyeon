# Lens 3: Methods & Identification
**Date:** 2026-05-20
**Score:** 6.5/10
**Disposition:** major-revision

## CRITICAL findings

### C1. The "$D_i$" symbol is overloaded and internally inconsistent — referee will flag immediately.

Line 110 (Table 1 notation): "$D_i$ — SFFP-eligibility dummy: $D_i = 1$ if $A_{2018,i} \le 5{,}000$ m\textsuperscript{2}, else $0$" — i.e., the **area-only** dummy.

Line 311 (Data §4): "$D_i = \mathbf{1}\{rv_{2018,i} \le 0\} \cdot \mathbf{1}\{A_{owned,2018,i} < 15{,}500 \text{ m}^2\} \cdot \mathbf{1}\{Y_{off,2018,i} < 45{,}000{,}000 \text{ KRW}\}$" — i.e., the **three-criterion conjunction**.

Line 54 (Intro), Line 84 (§2.3), Line 313 (Data) likewise treat $D_i$ as the conjunction.

This is the **central treatment variable in the paper** and its definition shifts between Table 1 and §4 without any cross-reference flag. A methods referee will read Table 1, write down "$D_i$ = area indicator," then reach §4 line 311 and conclude the paper does not know what its own treatment is. **Fix:** rewrite Table 1 row to: "$D_i$: statutorily-eligible indicator, defined in eq.\,(\ref{eq:Di-def}) [§4 line 311]; coincides with $\mathbf{1}\{rv_{2018,i} \le 0\}$ on the 3,420-household analysis sample by construction (194 area-eligible-but-ineligible households dropped)." Use $D^{\text{area}}_i$ exclusively for the area-only-treatment robustness in §7.1.

### C2. The "sharp DiD-RD on the resulting subset" claim (line 313) is a methodological sleight-of-hand.

Line 313: "On the resulting subset, $D_i = 1$ coincides with $rv_{2018,i} \le 0$ by construction, restoring sharp DiD-RD identification at the area cutoff."

This is **not identification** — it is sample selection. Dropping 194 treated-but-ineligible units from the treated side **changes the population to which inference applies** and creates a selected-sample-counts-as-sharp construction. The selected sample is conditional on $\mathbf{1}\{A_{owned,2018} < 15{,}500\} \cdot \mathbf{1}\{Y_{off,2018} < 45M\}$, which is **not symmetric around the cutoff** — control households (area $> 5{,}000$) are NOT subject to the same screening. This generates an asymmetric-sample RD where the treated side is purified on two additional dimensions but the control side is not.

The implication: the estimand is no longer "ITT of eligibility" but "ITT of eligibility on the subpopulation that already passes (ii) and (vi) on the treated side, compared to all area-ineligible controls." This is a **first-stage selection RD** in disguise.

**Fix options the referee will demand:**
1. Apply the same screening on the control side (households with owned area < 15,500 AND off-farm income < 45M on **both** sides), restoring symmetry. This is the right answer.
2. Or, present the area-only design as primary and the screened design as robustness, reversing the current §7.1 framing.

The current line 84 defense ("the headline operating-cost coefficient moves by no more than 2.2\%") shows the result is empirically robust, but the **identification argument is wrong as stated**.

### C3. SUTVA defense at line 343 contains a logical error.

Line 343 sub-claim 2: "Korean rural-rental markets clear at the village-or-district level... so within-village spillovers are absorbed by the time fixed effect in (\ref{eq:didrd-main}) rather than confounding the cross-cutoff comparison."

The specification at eq. (1) line 330 contains $\zeta_k \text{Post}_t$ (a single common Post indicator) — **not village-by-year fixed effects**. A scalar Post dummy cannot absorb village-specific rental-market clearing. If treated and control households are co-located within a village and the rental rate falls by the same amount on both sides, a Post dummy absorbs the level shift but does not handle the spillover-induced behavioral response on the control side (control farms also face lower rent, may rent more, contaminating the cross-cutoff comparison on $A_{\text{rent}}$ and operating cost).

**Fix:** either add $sgg\_cd \times \text{Post}$ fixed effects (consistent with the §5.5 sub-district clustering robustness already announced) and re-estimate, OR drop the claim and acknowledge SUTVA as an unresolved threat for outcomes touching the rental margin. The F1 prediction on $A_{\text{own}}$ is partially protected (own-area is not directly traded), but the operating-cost-net-of-rent outcome and rent-cost outcome remain exposed.

### C4. The s_min anchor at line 259 is sourced to **non-existent citations**.

Line 259: "$\tau$ ... \citet{KREI_prodcost_2022} reports a purchase-price midpoint of approximately ${\sim}50$M~KRW ... \citet{KAMICO_pricelist_2022} corroborates this anchor."

These BibTeX keys (KREI_prodcost_2022, KAMICO_pricelist_2022) — **verify whether they resolve in Bibliography_base.bib**. (Lens 7 reports them present with Korean dual fields, but cross-check the metadata quality: are they grey-literature URLs or properly cited primary sources?) The (S,s) theory-to-data bridge is the entire backbone of $\hat\beta_3 \le 0$ → if a referee resolves these `\citet` calls and finds them undefined or self-cited to grey literature without DOIs, the whole anchor collapses.

**Fix:** Either (a) substitute defensible citations (Korean Statistical Office *Farm Machinery and Equipment Survey* with year and table number; KAMICO published price list with URL and access date), or (b) acknowledge the anchor as illustrative and reframe the prediction as "if $\tau \in [25M, 50M]$ KRW based on author calibration from publicly available farm-machinery price data ([URL]), then $T_{SFFP}/\tau < 1$." Do not present $\tau$ as established literature when it is not yet cited.

### C5. The "$5{,}000$ m² ≤" mutual-exclusivity inconsistency at line 70.

Line 70: "At the 0.5-hectare cutoff itself, the marginal household receives the 1,200,000~KRW flat amount on the SFFP side **and** approximately 985,000~KRW on the ABP side" — this is **internally contradictory** with line 70's own statement that "The two branches are mutually exclusive at the household level."

Line 70 likely intends "the *expected* transfer jump at the cutoff is 1.2M minus the would-have-been ABP of 985K = 215K." But as written it implies a marginal household receiving both — and that mis-statement undermines the institutional motivation for ITT and for the "discrete jump" framing. **Fix:** restate line 70 as: "At the 0.5~ha cutoff, the marginal SFFP-eligible household receives 1{,}200{,}000~KRW (flat). The counterfactual ABP transfer for a household just above the cutoff is approximately 985{,}000~KRW... yielding a discrete transfer jump of approximately 215{,}000~KRW per year at the cutoff."

## MAJOR findings

### M1. The "DiD-RD" identification one-liner is buried and never stated cleanly.

§5 line 326 calls the design "DiD-RD" and gives a verbal sketch but **never writes the one-sentence referee-copyable identification claim**: "Under (i) frozen-baseline running variable, (ii) RD continuity, (iii) parallel trends in 2018→2019, (iv) no anticipation, and (v) SUTVA, $\hat\beta_k$ from (1) identifies the ITT-LATE at the 0.5 ha cutoff of statutory SFFP eligibility on outcome $k$ during the 2020–2022 post-period."

**Fix:** Add this exact sentence as the first paragraph of §5, immediately after "Design overview."

### M2. Threat enumeration is incomplete — anticipation is the most under-defended.

Line 180 (anticipation defense, §3): three-pronged argument (post-2018 SFFP design + McCrary + HonestDiD). This is **partially adequate** but the Act on Public-Interest Direct Payments was passed in **2019**, one calendar year after the 2018 baseline. A referee will ask: "Was a 0.5 ha cutoff discussed in MAFRA white papers, presidential commission reports, or parliamentary deliberations prior to 2018?" The paper does not address this. The McCrary test alone tests **sorting at the cutoff**, not anticipation behavior elsewhere in the pre-period distribution.

**Fix:** A footnote citing the MAFRA / 농림축산식품부 white-paper timeline establishing when the 0.5 ha number first appeared in policy discourse.

### M3. The McCrary $p = .18$ is not a "pass" — it is underpowered.

Line 374: "$t = 1.34$ ($p = .18$, $n = 2{,}680$); the null of density continuity is not rejected."

With $n = 2{,}680$, $|t| = 1.34$ is a non-trivial point estimate. McCrary's null is continuity, and a reviewer will read "we accept continuity because we did not reject it" as a low-power confound. The 2020+ RD literature (Cattaneo–Jansson–Ma; `rddensity`) explicitly warns against this framing.

**Fix:** Report the Cattaneo–Jansson–Ma (2020) `rddensity` test alongside McCrary; report the bias-corrected p-value and confidence interval on the density jump; frame as "We find no evidence of manipulation: the bias-corrected p-value from CJM (2020) is X, and the 95% CI on the density discontinuity is [L, U] containing zero."

### M4. Three-channel identification: the bargaining margin is asserted but never identified.

The intro (line 52) and §2.3 (line 86) reference "bargaining margin" (unit_rent_price) as one of three channels distinct from composition (rented area) and land-pivot (own area). The discussion (line 448) treats unit_rent_price as part of the incidence reversal.

But §5 estimates a single-equation DiD-RD on each outcome — there is no formal decomposition that separately identifies the bargaining margin from the composition margin. The implicit decomposition rent_cost = unit_rent_price × area_rent is never written down or tested. The "$-12.0\%$ rent-cost pass-through" at line 363 is a single reduced-form coefficient.

**Fix:** Either (a) drop the three-channel framing entirely and report unit_rent_price as ex-theory robustness, OR (b) write down the additive decomposition d(rent_cost)/dT = (d unit_rent_price/dT) × area_rent + unit_rent_price × (d area_rent/dT) and report all three components with delta-method standard errors.

### M5. Sample selection at the cutoff: pure owner-operators are 52% but identification does not use them.

The four-bin gradient at line 350 has pure_owner ≡ 0 by construction (the reference bin). 52% of the treated cohort is in this bin (line 450) and contributes **zero** to the F1 monotone-gradient identification. The headline "we reject AHM separability for Korean small farms" is identified off the 48% non-pure-owner cohort.

**Fix:** Reframe the conclusion to "We reject AHM separability for the **48% non-pure-owner subpopulation** at the 0.5~ha cutoff, where the wealth-biased liquidity channel is active." This is more honest and likely strengthens the AJAE-grade contribution (precise mechanism identification, not blanket rejection).

### M6. (S,s) anchor presented but never tested.

The theory predicts $\beta_3 \le 0$ if $T/\tau < 1$. The empirical result confirms negative sign. But this is **one observation of a single inequality**, not a test. A sharp referee will ask: "What would have falsified the (S,s) anchor?" The (S,s) prediction is weakly observationally equivalent to several alternatives (precautionary saving, time-allocation reallocation toward own-labor).

**Fix:** Either (a) tighten the (S,s) prediction to a magnitude range using the calibrated $\tau$, or (b) acknowledge that $\beta_3 \le 0$ is necessary-but-not-sufficient for the (S,s) mechanism.

### M7. Bandwidth strategy — T3 attenuation undercuts the headline.

Line 359: "at T3 ($h \approx 1{,}710$~m\textsuperscript{2}) the point estimate attenuates to approximately zero ($p > .50$)." The paper frames this as "the wider T3 bandwidth dilutes the marginal-window signal as expected," which is **defensive interpretation**.

**Fix:** Add diagnostic plots (binscatter of residuals vs. running variable at T3) to argue that the attenuation reflects genuine locality rather than spurious T1 results.

## MINOR findings

### m1. Line 339: $B = 999$ Rademacher refits is below contemporary AJAE convention.
AEA Data Editor / AJAE practice expects $B = 9{,}999$ at submission.

### m2. Line 339: Holm step-down family-size unspecified.
Make this explicit: "Family = 4 primary outcomes... Heterogeneity grid and ex-theory outcome are NOT in the family."

### m3. Line 387: "Wild bootstrap p-values agree with the cluster-robust analytic p-values within $\pm .01$".
Report actual cluster count and cite MacKinnon-Webb (2018) on cluster-count thresholds.

### m4. The "weighted version reported in §7" promise at line 317 is opaque.
Searched §7 — there is no weighted-DiD-RD table. Fix the cross-reference.

### m5. Line 343 ex-theory caveat inconsistent with line 448 contribution claim.
Either the rent result is in the contribution claim or it is out — pick one.

## Assumption ledger

| Assumption | Stated? | Defended? | Tested? |
|---|---|---|---|
| Parallel trends | Yes (§3 line 180, §5 line 341) | Partially (HonestDiD §7 line 398) | Yes — event-study line 389, but HonestDiD breakdown $\bar M^* = 0$ admitted |
| RD continuity (McCrary) | Yes (§5 line 326) | Weakly (single test, p=.18 framed as pass) | Yes (§7 line 374), but underpowered framing — see M3 |
| No manipulation | Yes (§5 line 326, frozen-baseline argument) | Strongly (baseline is pre-Act-passage) | Yes — McCrary + triple-margin (line 432) — adequate |
| SUTVA | Yes (§5 line 343) | Weakly — the within-village FE absorption claim is wrong (see C3) | No formal test |
| Anticipation | Yes (§3 line 180) | Partially — three-pronged but missing pre-2018 policy-discourse trace (see M2) | McCrary only |
| Covariate balance at cutoff | No explicit covariate continuity test | Only differential-attrition tested | Partially |
| Differential attrition | Yes (§4 line 309) | Yes (§7 line 383) | Yes — adequate |
| Sample-selection (194 drop) | Yes (§2.3 line 84) | Weakly — claim of "restored sharpness" is wrong (see C2) | Balance table line 411 — partially adequate |
| Spillovers | Yes (§5 line 343) | Wrongly (see C3) | No |
| Measurement (self-report vs. cadastral) | No | No | No |

**Gap: covariate continuity at the cutoff is not tested.** The CCT-2014 convention requires `rdrobust` checks on pre-determined covariates (age, education, owned-land at baseline). **Add to §7.**

**Gap: measurement of $A_{2018}$ as self-reported.** FHES is a survey panel — the running variable is self-reported area, not cadastral. Measurement error in $rv_{2018}$ near the cutoff is a known RD threat (Pei-Shen 2017). **Add a footnote acknowledging the self-report nature.**

## Three-channel identification audit

| Channel | Identifying variation | Argued? | Tested? |
|---|---|---|---|
| Bargaining margin (unit_rent_price) | Per-farm flat-rate breaks per-acre landlord capture | Asserted in intro / discussion; never formalized | Yes (reduced form $\hat\beta_5 = -144{,}027$, $p=.133$ line 363), but not as a "bargaining" mechanism |
| Composition / capitalization-avoidance | Substitution from rented to owned land | Asserted in conclusion line 448; mechanism is verbal, not derived | Reduced-form −12% pass-through (line 363); no separate area_rent test in §6 |
| Land-pivot / extensive margin (area_own) | F1 monotone tenancy gradient | Yes — fully formalized via Carter-Olinto threshold equation (line 191) | Yes (line 350) — this is the only channel with full identification chain |

**Verdict:** Only the land-pivot channel has a clean identification argument linking theory to estimator to result. The other two channels are asserted from the reduced form. There is a **structural mismatch between the project's three-channel framing and the paper's two-channel (liquidity + supervision) AHM-extension framing.** Drop the three-channel language from intro/discussion and frame as a wealth-biased-liquidity test with an incidence reduced-form auxiliary, OR add the formal three-channel decomposition.

## (S,s) anchor — theory-to-data bridge

**Partially survives.**

**Strengths:** Two-endpoint anchor (25M down-payment / 50M purchase price); $T/\tau \in [0.024, 0.048]$ within standard 5–10% inaction band; robustness range $\tau \in [20M, 40M]$ preserves prediction; multi-year cumulative ratio addressed.

**Weaknesses:**
- $\tau$ citations may be grey-literature (see C4)
- Magnitude prediction not tight — $-3.98M$ point estimate may **exceed** the (S,s) absorption capacity ($T_{SFFP} = 1.2M$) by 3.3×, requiring a stronger mechanism than pure (S,s) inaction
- Necessary-not-sufficient problem
- Pure-owner cohort (52% of treated) makes $\tau$ calibration suspect — should be calibrated on the non-pure-owner cohort

**Bottom line:** Weakest theory-to-data link. Tighter magnitude prediction and non-pure-owner-conditional $\tau$ calibration needed for AJAE acceptance.

---

**Overall disposition:** Methodologically sophisticated paper with a clean primary identification claim (F1 monotone tenancy gradient) but **five critical issues**:

1. C1 ($D_i$ overloaded notation)
2. C2 ("sharp DiD-RD restored" via selection — wrong claim)
3. C3 (SUTVA defense via time FE — wrong mechanically)
4. C4 ($\tau$ anchor citation quality)
5. C5 (SFFP/ABP mutual-exclusivity contradicted at line 70)

**Major revision** rather than reject. Estimated rewrite effort: 2–3 days for methods sections + covariate-continuity and CJM-density tests for §7. A revision addressing C1–C5 + M1–M3 + the assumption-ledger gaps would move this to 8.5/10 and AJAE-ready.
