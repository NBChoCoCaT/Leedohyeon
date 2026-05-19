# Lens 4 — Results + Tables + Figures (Wave 7)

**Manuscript:** `paper/en/main.tex` (457 L)
**Scope:** §6 Results (L346–367), §7 Robustness (L370–425), §8 Discussion (L428–440), §9 Conclusion (L443–451). Tables/figures sourced from `scripts/R/_outputs_eligibility/`.

---

## Verdict

**NEEDS WORK.** Three Wave-5/Wave-7 magnitude inconsistencies bleed across the abstract → §6 → §9 spine; one figure has a clipped title; the forest plot caption color-codes are correct but the alpha3 cell-level table contradicts the verbal "near-zero" claim. None of the issues are fatal, but the headline-number drift between Results and Conclusion is a desk-review hit at AJAE.

**Score: 7.0 / 10**

---

## CRITICAL

### C1. Wave-5/Wave-7 magnitude drift: §6 vs §9 Conclusion (L447) inconsistent

The Results section reports **Wave 7 (statutorily-eligible) numbers** but the Conclusion reverts to **Wave 5 (area-only) numbers**. Same paper, three different versions of the headline.

| Quantity | §1 Abstract (L40) | §6 Results | §9 Conclusion (L447) | Source |
|---|---|---|---|---|
| Pure-tenant β₁ at T2 | +1,122 m² (p=.041) | +1,122 m² (p=.041) | **+1,089 m² (p=.033)** | tab_alpha3 row 12 = +1,121.88, p=.041 ✓ for Wave 7 |
| Operating-cost at T1 | −3.98M KRW (p=.057) | −3.98M (p=.057) | **−4.18M (p=.047)** | tab_main_did_rd shows −4,134,370 ≈ −4.13M for the area-only spec |
| Rent pass-through at T2 | (not stated) | **−12.0%** (L363) | **−11.1%** (L447) | inconsistent within the same manuscript |
| Monotone gradient bins | (not stated) | {+1,122, +403, +222, −74, 0} | **{1,089, 410, 393, −101, 0}** | Wave 5 area-only chain in conclusion |

The Conclusion's `1,089 → 410 → 393 → −101 → 0` chain matches the appB-mapping table T2 row in `online_appendix.tex` L541 — i.e., this is the **archived Wave 5 area-only chain that has not been updated to Wave 7**. Same for −4.18M / p=.047 and −11.1%. CLAUDE.md (current memory) confirms Wave 7 is the main spec, so the Conclusion is stale.

**Fix:** Rewrite §9 (L447) to match Wave 7. Decide once and globally: are the headline numbers `{+1,122, +403, +222, −74, 0}` / `−3.98M (p=.057)` / `−12.0%`? If yes, replace all instances in L447. If the Conclusion is intentionally citing the Wave 5 area-only baseline as "the more conservative number," say so explicitly (one sentence: "We report the area-only-treatment-baseline magnitudes here; the statutorily-eligible re-estimation moves these by 1–2% in absolute value (§6)."), but currently the asymmetry is silent and looks like an editorial error.

### C2. fig_f1_fourbin_gradient_T2_en.png title clipped at right edge

Title reads `F1: Four-bin tenancy gradient on own-cultivated area (T2, h = 1,000` — the closing `m²)` is cut off. This is the **headline diagnostic figure** of the paper. PDF version likely affected. **Fix:** widen plot margins or shrink title font in the R script that generated the figure (likely `10_alpha3_estimation.R` or similar).

### C3. Cell-level off_farm_income claim contradicts tab_alpha3 (L361)

§6 ¶3 states off-farm income "exhibits no systematic sign across cells" and the pooled β̂₄ is "small and statistically near zero." But `tab_alpha3_results_en.tex` shows off_farm_income cells with **large nonzero estimates at p < .001** (e.g., 1_pure_tenant T1 = −13.9M, p=.000; 1_pure_tenant T2 = −15.4M, p=.000; 5_pure_owner T2 = +11.7M, p=.000; 5_pure_owner T3 = +14.3M, p=.000). The text reading "no systematic sign" is technically defensible (the signs do flip), but "statistically near zero" is not — the cell-level p-values are tiny. Referee will hit this. **Fix:** rewrite L361 as "pooled β̂₄ is statistically near zero across bandwidths, although cell-level estimates exhibit large and highly significant but sign-inconsistent magnitudes (Online Appendix B.3); the cell-level rdrobust spec differs from the pooled DiD-RD spec and is reported as exploratory only." The current sentence understates the magnitudes that the appendix will surface.

---

## MAJOR

### M1. T3 bandwidth contradiction within §6 (L350 vs L359)

- L350: T3 (MSE-optimal $h \approx 3{,}300$ m²) — for $\hat\beta_1$ on area_own
- L359: at T3 ($h \approx 1{,}710$ m²) — for $\hat\beta_3$ on op_cost_ex_rent
- `tab_rob_outlier_en.tex` caption: T3 = ±3,300 m² for op_cost
- `tab_main_did_rd_en.tex` shows T3 N = {2,780, 3,310, 3,135, 4,210} across the 4 outcomes — confirming per-outcome MSE-optimal h

The per-outcome bandwidth is conceptually fine, but currently a reader sees "T3 = 3,300" in one paragraph and "T3 = 1,710" in the next without any signposting that T3 is outcome-specific. **Fix:** at L341 (Inference) or L350, add one sentence: "T3 is the per-outcome MSE-optimal bandwidth (`rdrobust`); reported $h$ values vary across outcomes." And reconcile the rob_outlier table caption, which appears to lock T3 = 3,300 across all four outcomes — inconsistent with the per-outcome h.

### M2. Rent pass-through reported as headline finding while p = .133

L363: "$\hat\beta_5 = -144{,}027$ KRW, **$p = .133$**" — i.e., not significant at conventional levels. Yet L434 (Discussion) headlines this as an "incidence-reversal" against Kirwan +25% and Baldoni-Ciaian +46–55%, and L447 (Conclusion) restates as "−11.1% rental-rate pass-through." The point estimate's sign is informative but referees at AJAE will ask why an insignificant coefficient is the basis for an institutional contrast claim. **Fix:** add one sentence after L363 acknowledging "$\hat\beta_5$ is not statistically distinguishable from zero at conventional levels (p = .133); we interpret the *sign* as institutionally consistent with the per-farm flat-rate severing the per-hectare landlord-capture channel, while flagging the negative result as aggregate-equilibrium signal not a sharp test." Then soften L434 to "reverses the *positive-sign* capitalization observed under area-proportional designs" rather than presenting the magnitude as comparable to the U.S./EU point estimates.

### M3. fig_mccrary_density_full_en legend says "Series 1 / Series 2"

The McCrary density figure (Figure~\ref{fig:mccrary}, L376–381) labels its two curves as "Series 1" and "Series 2" — not "Below cutoff" / "Above cutoff" or "Left of 5,000 m²" / "Right of 5,000 m²". **Fix:** rename legend labels in the R script. Also the in-figure caption text at the bottom ("Vertical bars: confidence bands. Smooth lines: estimated densities. Red dashed line marks the 0.5 ha (5,000 m²)...") is clipped at the right edge in the PNG; verify the PDF is not similarly clipped.

### M4. fig_honestdid_sensitivity_b1_en y-axis unit renders as raw caret

Y-axis reads `m^2` (literal caret), not `m²`. Minor LaTeX/ggplot escaping issue. **Fix:** in the R script, use `expression(beta[1]~(m^2))` or `bquote()` with the proper power notation.

### M5. fig_event_study_op_cost_T2 y-axis in scientific notation

Reads `4e+06, 2e+06, 0e+00, −2e+06, −4e+06, −6e+06`. Not reader-friendly. **Fix:** rescale to millions of KRW (axis title "Coefficient (million KRW)") and use plain numbers `−6, −4, −2, 0, 2, 4`. Also: the 2018 pre-period coefficient is approximately −1.8M KRW with CI not obviously including zero — L389 claims "$|t| < 1$" — verify numerically; the visual suggests $|t| \approx 1.5$.

### M6. Magnitude interpretation missing for §6 op_cost

L432 (Discussion) interprets +1,122 m² as "≈22% of the 0.5 ha eligibility threshold" — good. But §6 op_cost result (L359) gives "−3.98M KRW at T1" with **no comparator**. Reader has no anchor: % of mean op_cost? % of SFFP transfer (1.2M)? **Fix:** add one phrase: "(≈X% of the sample-mean operating cost; ≈3.3× the annual SFFP transfer)" or similar. Same gap for the pooled −3.13M at T2.

### M7. Spec B table referenced but not displayed; tolerance claim conceptually wrong

L407: "Spec B point estimates ... agree with Spec A within the replication-protocol Phase~3 tolerance ($\pm 0.01$ for point estimates, $\pm 0.05$ for standard errors)." The Phase~3 tolerance applies to **replication of someone else's exact specification**, not to a richer covariate spec returning a different coefficient. Two different specs producing the same coefficient to $\pm 0.01$ is implausible at op_cost's KRW scale anyway. **Fix:** present Spec A vs Spec B side-by-side in a brief table or appendix, and replace "$\pm 0.01$ ... $\pm 0.05$" with a robustness criterion like "the sign and 90% significance of all four primary cells survive."

### M8. F1 trigger logic creates "F1 doesn't fire → AHM rejected" inversion that confuses readers

L350: "F1 does not fire and the wealth-biased liquidity channel is supported."
L367: "**We reject AHM separability.**"

Both are true under the pre-spec, but the verbal collision (F1 not firing = good news for the paper) is reader-hostile. **Fix:** in the headline italic (L367), append: "F1's strict-AND trigger is constructed to fire when the wealth-bias signature is *absent*; the observed non-firing under monotone gradient is the rejection-bearing outcome (cf. \S\ref{sec:predictions} pre-spec)."

---

## MINOR

### m1. tab_main_did_rd_en caption says "Stars = Holm step-down adjusted p-value" but no stars appear in the table body. Either add the stars or remove the caption clause.

### m2. tab_main_did_rd_en title: `DiD-RD: Spec A (2018-2022, Post = year >= 2020)` — needs an explicit treatment-definition note. Reader can't tell from the caption alone whether this is `D_treat` or `D_eligible_obs_2018`. Add: "Treatment indicator: $D_i$ (statutorily-eligible on three FHES-observable criteria, frozen at 2018)."

### m3. tab_rob_outlier_en omits a "row" label in column 1 — entries like "Spec A, IHS asinh(y)" are clear, but the column header "Row" is unhelpful. Replace with "Specification".

### m4. tab_alpha3_results_en lacks a column for **N** at each cell. Reader cannot judge how the SE is computed without the cell-level N. Add `n_hh_yrs` column.

### m5. fig_forest_treatment_definitions_en y-axis labels (`A/T1/op_cost`, etc.) render at fine size but no superscript or m² indicator; outcomes are mixed-units (op_cost in KRW; only op_cost/off_farm_income/consumption/farm_income shown — area_own absent from this plot, which means the headline area_own cell is NOT visualized in the treatment-definition robustness). The L414 caption claims "24 journal-cell coefficients" but the plot only shows the 4 KRW outcomes × 3 BW × 2 Spec = 24 cells *excluding* area_own. **Fix:** clarify in caption that area_own is not in this forest plot (different units), and reference a separate panel or appendix that handles area_own.

### m6. fig_mccrary_multi_rv panel (c) off-farm income: density spike at 0 with most mass at 0 ⇒ this is a corner distribution where McCrary continuity is mechanically uninformative (no density "below" the threshold of 45M if most households are at 0). The p=.86 result is correct but a footnote noting the corner distribution would protect against referee skepticism.

### m7. L350 says T2 high-owner is `−74, NS` and pure-owner is `0` reference — but the alpha3 table T2 row 16 shows `5_pure_owner T2 = 0.00, p = NA`. The "$0$ reference" in the text is mechanical (the bin is pure_owner with no rented baseline), not estimated; clarify in the figure caption that the pure-owner bin is reference, not zero-estimate.

### m8. L383 differential-attrition placebo: "$-0.082$ ($p = .46$, $n = 319$)" — units of −0.082? Coefficient on an indicator outcome, so it's a probability (−8.2 percentage points). Add `pp` or `%` to be explicit.

### m9. L398: HonestDiD figure caption says "the breakdown $\bar M^*$ ... is reported alongside the figure." But the figure caption (L403) only restates this without giving a numeric $\bar M^*$. Add the actual breakdown value (visually $\bar M^*$ is somewhere in [0.5, 1.0] since the CI looks to include zero at $\bar M = 0.5$ already — the original DiD at $\bar M = 0$ may also include zero, which would be a major finding).

### m10. tab_rob_outlier_en uses a different SE precision (KRW units, 4-5 digits) than tab_main_did_rd_en (KRW with comma thousands separator). Apply one rounding rule across all KRW tables.

---

## Specific line-numbered suggestions (one-pass fixes)

| Line | Current | Fix |
|---|---|---|
| L40 (Abstract) | Wave 7 numbers ✓ | Keep |
| L350 | `T3 (MSE-optimal $h \approx 3{,}300$~m²)` | Add: "T3 is per-outcome MSE-optimal; $h$ varies by outcome (footnote table)" |
| L359 | "$h \approx 1{,}710$ m²" | Reconcile with tab_rob_outlier's `h=3,300` for op_cost T3 — one or the other |
| L361 | "small and statistically near zero across bandwidths" | "pooled $\hat\beta_4$ small and near zero; cell-level estimates large and significant but sign-inconsistent (B.3)" |
| L363 | `($p = .133$)` for pass-through | Acknowledge non-significance explicitly; soften "incidence reversal" claim |
| L389 | "$|t| < 1$ in 2018" | Verify against tab; visually the 2018 estimate looks larger |
| L407 | "$\pm 0.01$ … $\pm 0.05$" tolerance | Replace with substantive criterion |
| L432 | "+1,122 m² is approximately 22% of the 0.5 ha eligibility threshold" ✓ | Keep; add similar anchor for op_cost |
| L447 | `+1,089 m² (p=.033)` and `−4.18M (p=.047)` and `−11.1%` | **Replace all three with Wave 7 numbers: +1,122 (p=.041), −3.98M (p=.057), −12.0%** |
| L447 | gradient chain `1,089 → 410 → 393 → −101 → 0` | Replace with Wave 7: `1,122 → 403 → 222 → −74 → 0` |

---

## Verdict summary

- **3 CRITICAL** (Wave 5/7 drift in §9; figure title clipping; off_farm_income near-zero claim contradicted by appendix)
- **8 MAJOR** (T3 bandwidth ambiguity, p=.133 incidence reversal, figure legend, axis units, magnitude anchors missing, Spec B claim, F1 trigger framing, no scientific notation)
- **10 MINOR** (caption polish, table column adds, unit labels)

The figure suite is technically present and broadly readable; the cluster-robust SE labeling is consistent ("Cluster-robust SE (hh_id)" appears in 4/5 tex tables I inspected). The main risk is the **headline-number drift between §6 and §9** — at AJAE first submission, that is a desk-review trigger. Fix C1 + C2 + C3 + M1 + M2 before submission; the rest can wait for the R1 polish pass.

**Score: 7.0 / 10** — fixable in one focused 2-hour pass.
