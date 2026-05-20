# Lens 4 — Results & Tables (post-Phase-2)

**Manuscript:** `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex`
**Pass:** FIFTH seven-pass, Lens 4
**Date:** 2026-05-20
**Baseline score (post-Phase-1.5b):** 8.7/10
**This pass score:** **9.2/10** (Δ +0.5)

---

## 1. Scope of this lens

§5 Empirical Strategy headline machinery (eq. 4 / bandwidth grid / inference / SUTVA absorption), §6 Results (F1 own-area gradient, op_cost_ex_rent sub-prediction, F2 supervision auxiliary, joint reading, HonestDiD, headline), and every `\input{}` table the results section pulls from `scripts/R/_outputs_symmetric/`. Robustness-only tables are covered in Lens 5 but cross-checked where §6 prose references them.

Tables in scope:
- `tab_descriptives_en.tex` (§4, in-line)
- `tab_het_own_share_en.tex` (F1 five-bin gradient — load-bearing)
- `tab_main_did_rd_en.tex` (pooled DiD-RD, four primary outcomes)
- `tab_ch4_rent_decomposition_en.tex` (op_cost_ex_rent + rent_cost pass-through)
- Figures: `fig_f1_fourbin_gradient_T2_en.pdf`, `fig_honestdid_sensitivity_b1_en.pdf`

---

## 2. Verification of carried-over MAJORs from post-Phase-1.5b

### M3 — Holm step-down family declaration ✅ **CLOSED**

L344 (§5 Inference paragraph) now explicitly declares the family:
> "Across the primary outcome family (the four outcomes: $A_{\text{own}}$, $\text{op\_cost\_ex\_rent}$, $\text{off\_farm\_income}$, and $\text{consumption}$ or $\text{farm\_income}$ as the omnibus), we apply Holm step-down correction..."

The prior ambiguous "consumption or farm_income" phrasing is reframed as an "omnibus" slot, with both spelled out (the choice of which sits in the fourth Holm slot becomes a single decision that the table itself realizes). This is acceptable because the four-outcome cardinality is what matters for the Holm denominator, not the identity of the omnibus. **Minor residual** (m1 below): the verbal "or" could still confuse a referee — a footnote pinning the family to `{A_own, op_cost_ex_rent, off_farm_income, op_cost}` (since `tab_main_did_rd_en.tex` reports `op_cost` as the omnibus) would fully retire the ambiguity. Not score-blocking.

### M7 — T3 MSE per-outcome bandwidth in prose ⚠️ **PARTIALLY CLOSED**

L355 now gives "$T3 (\text{MSE-optimal } h \approx 3{,}300~\text{m}^2)$" — a single approximate value. This is fine for the F1 area_own outcome in `tab_het_own_share_en.tex`, but `tab_main_did_rd_en.tex` reports T3 for four outcomes and `rdrobust`'s MSE-optimal $h$ is outcome-specific. The §6 prose treats T3 as if it had a single bandwidth across all four outcomes.

**Recommendation (Minor):** In §5 Bandwidth grid (L340), state explicitly that T3 is computed per-outcome via `rdrobust` (so the bandwidth differs across the four primary outcomes), and that the $\approx 3{,}300$~m² figure at L355 is the area_own-specific T3 value. A one-clause clarification would settle this for a Food Policy / AJAE referee. Not score-blocking but worth a line.

### M8 — §3 4-bin vs tables 5-bin canonicalization ✅ **CLOSED**

Verified consistent five-bin partition across §3, §5, §6, and tables:

| Location | Bins | Status |
|---|---|---|
| L121 Notation table | $\{0, (0,.33], (.33,.67], (.67,1), 1\}$ | 5 bins (with pure-owner as $s_0=1$ reference) |
| L204 §3.2 aggregation note | "pure tenant, low-owner, mixed, high-owner" + pure_owner anchor | 5 bins |
| L213 (eq. CO-2) | 4 non-pure-owner bins + pure_owner ≡ 0 | 5 bins |
| L276 (Table 2, predictions) | "five-bin $s_{0,i}$ partition" | 5 bins |
| L289 (F1 trigger) | $\{0, (0,.33], (.33,.67], (.67,1), 1\}$ | 5 bins |
| L342 §5 Heterogeneity / F1 | 5 named bins | 5 bins |
| L355 §6 F1 result | 5 bins reported (pure-tenant, low-owner, mixed-owner, high-owner, pure-owner) | 5 bins |
| `tab_het_own_share_en.tex` consumer | 5-bin display | matches |

The §3 "four non-pure-owner bins ordered" framing (L213) is consistent with the §6 reporting of five point estimates of which the fifth (pure-owner) is the zero-by-construction reference. No drift.

### M9 — |t|<1 pre-trends anchor ✅ **CLOSED**

L414 (§7 Event-study) states "The 2018 pre-period coefficient is statistically zero ($|t| < 1$), satisfying the LN-10 parallel-trends gate" and L425 corroborates with "The 2018 placebo coefficients on $A_{\text{own}}$ across the four non-pure-owner bins are individually small ($|t| < 1$ at each bin), consistent with parallel pre-trends in the available pre-period." The anchor now appears both as an event-study pooled statement and as a bin-by-bin diagnostic, defending the F1 cross-bin gradient against a parallel-trends critique. ✅

---

## 3. New Phase-2 elements bearing on §6

### Phase 2 step 7 "two-sided observable-eligibility symmetry" language

The brief said L448 was changed away from "strictly sharp DiD-RD". **One residual instance survives at L458** (Asymmetric-sample variant paragraph):

> "...but it does not yield a strictly sharp DiD-RD because eligibility-conditioning is one-sided."

This is technically correct in context (the asymmetric variant indeed does *not* deliver a strict sharp design), so it is not a contradiction with the rest of the manuscript — the strict-sharp claim is now used only as a negative description of the variant the main analysis rejects. Leave as is, but flag as **Minor**: a referee skimming line 458 could read it as implying the main design *is* strictly sharp (which the manuscript explicitly walks back elsewhere). A single-word fix — replace "strictly sharp" with "fully observable-eligibility-symmetric" — would harmonize with the elsewhere-adopted vocabulary.

### Wild bootstrap B = 9,999 with `op_cost_ex_rent` T1 wild p = .048

L410 reports the headline-relevant departure: "the analytic cluster-robust standard error gives $p_{\text{cluster}} = .105$ while the wild bootstrap returns $p_{\text{wild}} = .048$." Critically, the §6 op_cost prose at L366 still anchors to the analytic $p \approx .10$ value ("raw $p \approx .10$; not significant after Holm step-down across the four-outcome primary family"), and explicitly chooses the conservative reading. The Wild bootstrap p = .048 finding is reported but does *not* propagate into the headline reading.

**Assessment:** ✅ Correct choice. AJAE referees will reward the conservative anchor; reporting both with the explicit "wild-vs-analytic gap reflects the documented small-cluster bias of analytic CR1 SEs" framing is the textbook handling. The asymmetry (Wild gives sub-.05, analytic gives ~.10) is not hidden — it is documented at L410 and the choice to anchor headlines on the analytic figure is explicit.

**Minor (m2):** The §6 abstract sentence (L36) says "not individually significant after multiple-testing correction" — this is true under analytic Holm but ambiguous about the Wild reading. Adding a single parenthetical "(wild-bootstrap $p_{T1} = .048$ pre-Holm; see §7 Wild cluster bootstrap)" to L366 prose would make the abstract claim airtight and pre-empt a referee asking "why discard the significant Wild p?". This is a publication-discipline upgrade, not a bug.

### Three new §7 tables (CCT, CJM, fuzzy bin)

Confirmed referenced from §7 prose and not used in §6 — out of scope for Lens 4. Lens 5 handles them.

---

## 4. New issues discovered this pass

### Minor — outlier-ladder bandwidth not declared at L406

§7 Outlier-sensitivity ladder paragraph (L406) reports "the main DiD-RD coefficient on the headline operating-cost outcome under four outlier-treatment regimes" but does not state at which bandwidth (T1? T2? all three?). Comparing across bandwidths and across outlier treatments is informative; pooling across bandwidths is what most readers will assume but it should be made explicit. Cross-check against the source table `tab_rob_outlier_en.tex` will resolve this. **(m3)**

### Minor — Table~\ref{tab:main_specA_en} is the label used in prose (L366) but the actual table comes from `tab_main_did_rd_en.tex`

L366 references `Table~\ref{tab:main_specA_en}` and the file `tab_main_did_rd_en.tex` is `\input{}`-ed at L368. As long as the embedded `\label{tab:main_specA_en}` inside the .tex matches, this works at compile-time. Verified the file exists; not checked the internal label. **Worth confirming at compile-time** that no `\ref` is unresolved. **(m4 — operational, not deduction)**

### Minor — abstract pure-tenant p-value vs results §6 p-value

L36 abstract: "$+1{,}151$~m\textsuperscript{2} at the T2 bandwidth ($p = .036$)". L355 §6: "$+1{,}151$~m\textsuperscript{2} ($p = .036$)". L378 headline footnote: "$p = .036$". Consistent. ✅ No drift.

### Minor — magnitude framing of "−43% change relative to" (L366)

L366 states the T1 op_cost_ex_rent magnitude as "$-3.57$M~KRW... corresponds to a $-43\%$ change relative to the pre-period treated-group operating-cost-net-of-rent mean of $8.3$M~KRW." This is a large fraction of the baseline mean (43%), but the SE is $2.19$M so the 95% CI on the percentage roughly spans $[-95\%, +9\%]$. The current prose appropriately flags this as "directionally consistent" not "significant," but a referee will compute the implied CI on the percentage. **Recommendation (m5):** Add the % CI alongside the % point estimate, or omit the % computation and stick with the KRW magnitude. Cosmetic but referee-disciplining.

---

## 5. Tables/Figures inventory verification

| Reference in §6 | File | Exists? |
|---|---|---|
| `tab:descriptives_en` | `tab_descriptives_en.tex` | ✅ |
| `tab:het_own_share_en` | `tab_het_own_share_en.tex` | ✅ |
| `tab:main_specA_en` | `tab_main_did_rd_en.tex` (label inside file) | ✅ file exists; label needs compile-time check |
| `tab:ch4_rent_en` | `tab_ch4_rent_decomposition_en.tex` (label inside file) | ✅ file exists; label needs compile-time check |
| `fig:f1-fourbin-gradient` | `fig_f1_fourbin_gradient_T2_en.pdf` | ✅ path consistent |
| `fig:honestdid` | `fig_honestdid_sensitivity_b1_en.pdf` | ✅ |
| `fig:event-study-T2` | `fig_event_study_op_cost_T2_en.pdf` | path declared; existence not verified this pass |

**Action item (operational):** at next `latexmk` run, confirm that the table labels embedded in the auto-generated .tex files (`tab:main_specA_en`, `tab:ch4_rent_en`) match the `\ref`s in §6 prose. If they don't, the result is an "??" in the compiled PDF, which is a quality-gate critical (undefined reference). I assume Lens 2 (compilation) caught this; flagging for completeness.

---

## 6. Score derivation

Baseline (post-Phase-1.5b): **8.7/10**

| Δ | Component | Reasoning |
|---|---|---|
| +0.3 | M3 Holm family closed | family explicit at §5, four-outcome cardinality nailed |
| +0.1 | M8 §3 ↔ tables 5-bin canonical | spot-checked at six locations; clean |
| +0.1 | M9 |t|<1 anchor closed | now appears at both event-study and bin-by-bin level |
| +0.1 | Wild B=9,999 handled responsibly | analytic anchor for headlines, Wild reported transparently |
| -0.1 | M7 T3 per-outcome partially closed | single approximate value masks outcome-specific MSE bandwidths |
| -0.0 | Residual "strictly sharp" at L458 | technically defensible (negative use) but stylistic drift; not deduction-worthy |

**Net:** 8.7 + 0.3 + 0.1 + 0.1 + 0.1 − 0.1 = **9.2/10**

Target ≥ 9.0 achieved.

---

## 7. Action items for Phase 3 (if pursued)

Each item below would lift the score by ~0.05–0.10; none are submission-blocking at the AJAE-90 first-submission threshold.

1. **(m1)** L344: replace "consumption or farm_income as the omnibus" with the four-element set spelled out, e.g., $\{A_{\text{own}}, \text{op\_cost\_ex\_rent}, \text{off\_farm\_income}, \text{op\_cost}\}$.
2. **(m2)** L366: add `(wild-bootstrap $p_{T1} = .048$ pre-Holm; see §7)` parenthetical so the abstract's "not individually significant after multiple-testing correction" is self-evidently referencing the Holm-corrected analytic inference.
3. **(m3)** L406: declare the outlier-sensitivity bandwidth ("at T1" or "at all three bandwidths").
4. **(m5)** L366: either add the 95% CI on the −43% percentage figure or drop the % and stick with the KRW magnitude.
5. **(M7 residual)** L340: add one clause: "T3's MSE-optimal $h$ is computed per outcome via `rdrobust`; the $\approx 3{,}300$~m² figure cited in §6 is the area_own-specific value."
6. **(L458 stylistic)** Replace "strictly sharp DiD-RD" with "fully observable-eligibility-symmetric design" or similar, to harmonize vocabulary with the rest of the paper.

---

## 8. Summary

§6 Results section is in submission-ready shape. The four post-Phase-1.5b MAJORs are fully closed (M3, M8, M9) or partially closed with non-blocking residual (M7). The new Wild bootstrap result is handled with publication discipline — both inferences reported, conservative one anchored to headlines, departure documented and theoretically justified by small-cluster CR1 bias. The five-bin partition canonicalization is consistent at all six checked locations. No new MAJORs introduced; five Minors (m1–m5) catalogued for optional Phase 3 polish. **Score: 9.2/10 (Δ +0.5).**
