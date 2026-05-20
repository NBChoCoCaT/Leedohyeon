# Lens 5 — Robustness (Seven-Pass Review #5, Post-Phase-2)

**Manuscript:** `paper/en/main.tex`
**Date:** 2026-05-20
**Baseline:** Post-Phase-1.5b score = 9.3/10 (open items: MINOR Phase-2-R1 §7 roadmap; MINOR Phase-2-R2 Spec B/C forward-ref from §6; NIT Phase-2-R3 wild-bootstrap caption silence on inference-type sensitivity).
**Phase 2 additions audited:** (a) CJM `rddensity` paragraph + `tab_cjm_density_en`; (b) CCT covariate-continuity paragraph + `tab_cct_covariate_continuity_en`; (c) Measurement-error sensitivity paragraph + `tab_fuzzy_bin_sensitivity_en`; (d) Wild bootstrap rewrite (B=9,999, honest analytic-vs-wild gap).

---

## 1. Phase 2 Closure Audit

### Phase 2 addition (a) — CJM `rddensity` corroboration of McCrary

**Insertion point:** End of the McCrary paragraph (L385), then `\input{tab_cjm_density_en}` at L387.

**Text:**
> "The narrow-window McCrary statistics are corroborated by the modern Cattaneo-Jansson-Ma (2020) `rddensity` jackknife test (Table~\ref{tab:cjm_density_en}): full-sample $t_{jk} = 0.68$ ($p = .50$), narrow windows return $p \in [.06, .36]$ in the same pattern. CJM's bandwidth-robust inference confirms the McCrary reading."

**Verification against `tab_cjm_density_en.tex`:**
- Full sample $t_{jk}=0.676$, $p=0.499$ — matches text (.68 / .50).
- T1 ±500: $p=0.064*$; T2 ±1,000: $p=0.076*$; T3 ±3,300: $p=0.358$ → range $p \in [0.064, 0.358]$. Text claim "$p \in [.06, .36]$" matches.
- N values are credible (full 2,178; T1 142; T2 293; T3 1,061) and consistent with the corresponding McCrary windows reported one paragraph earlier.

**Flow assessment:** Insertion is at the right place — directly after the McCrary discussion of narrow-window borderline p-values, the CJM result functions as a modern-method corroboration. The reader is told what changes (CJM uses jackknife variance, bandwidth-robust) and what does not change (same qualitative pattern, same headline reading). The "confirms the McCrary reading" closer is appropriate because the qualitative pattern (full passes, narrow approaches but does not reach .05) is preserved. **CLOSED.**

**One micro-flag:** the text says "CJM's bandwidth-robust inference" — strictly `rddensity` uses local-quadratic estimation with jackknife (not "bandwidth-robust" in the CCT 2014 sense of "robust to bandwidth selection in the bias-correction step"). The phrasing is colloquially correct (jackknife is robust across bandwidths) but a referee with `rddensity` expertise may parse "bandwidth-robust" as the wrong thing. Suggest: "CJM's jackknife-variance inference confirms the McCrary reading." NIT severity.

### Phase 2 addition (b) — CCT covariate continuity

**Insertion point:** L389 paragraph + `\input{tab_cct_covariate_continuity_en}` at L391.

**Text:**
> "0 of 18 cells are significant at $p < .05$, and 2 of 18 at $p < .10$ (within the false-positive rate expected under the null at $\alpha = .10$). No systematic covariate imbalance at the cutoff."

**Verification against `tab_cct_covariate_continuity_en.tex`:**
- Counting starred coefficients: T3 farm\_type ($-1.479*$), T3 type\_fulltime ($-0.352*$) → 2 cells starred at p<.10, 0 at p<.05.
- Text claim verified exactly.
- Expected under null at $\alpha = .10$: $18 \times 0.10 = 1.8 \approx 2$ → claim "within the false-positive rate expected under the null" is correct.

**Methodological note:** Six covariates × T1/T2/T3 = 18 cells (not, as one might naively read, 6 × 4 = 24); the text correctly accounts for this. The two marginal cells both occur at T3 (the widest, MSE-optimal bandwidth) and on related covariates (farm\_type, type\_fulltime are correlated — full-time farmers are concentrated in certain farm types), which is consistent with a single underlying tail rather than two independent violations. Suggest a half-sentence: "Both marginal cells occur at T3 and concern related covariates (farm type and full-time status), consistent with a single dimensional correlation rather than independent imbalances." This would preempt a referee who counts 2 starred cells and asks whether the imbalance is structural. NIT severity (not blocking).

**Flow assessment:** CCT covariate continuity is the canonical RD-balance check; placing it right after the cutoff-density check (McCrary + CJM) is the standard sequence (density first, then covariates), matching textbook ordering (Cattaneo-Idrobo-Titiunik 2020). The paragraph integrates without disturbing later items. **CLOSED.**

### Phase 2 addition (c) — Measurement-error sensitivity in baseline tenancy

**Insertion point:** L393 (new paragraph with `\label{sec:robustness-meas-error}`) + `\input{tab_fuzzy_bin_sensitivity_en}` at L395.

**Text claims:**
- "The pure-tenant T2 coefficient is $+1{,}151$ ($p = .037$), $+1{,}152$ ($p = .036$), and $+1{,}155$ ($p = .036$) across the three treatments respectively."

**Verification against `tab_fuzzy_bin_sensitivity_en.tex`:**
- Strict baseline: $+1{,}151**$, SE $548 \Rightarrow t = 2.10 \Rightarrow p \approx 0.036$ (two-tailed). Text says p=.037. Within ±.005 of computed.
- Donut: $+1{,}152**$, SE $546 \Rightarrow t = 2.11 \Rightarrow p \approx 0.035$. Text says p=.036. Within ±.005.
- Robust 25/75: $+1{,}155**$, SE $547 \Rightarrow t = 2.11 \Rightarrow p \approx 0.035$. Text says p=.036. Within ±.005.
- The 4-bin monotone direction is preserved in all three rows (pure_tenant > low_owner > mixed > high_owner ≈ pure_owner reference). Verified.
- The donut row drops to N=1,144 (vs N=1,240 strict) — Roth (2022) measurement-error logic correctly cited.

**Note:** The strict-baseline numbers in this table ($+1,151$ pt, $+438$ low, $+258$ mixed, $-52$ high) exactly match the headline F1 cell-by-cell numbers cited throughout §1, §4, §5, §6, and the Discussion. This is the right table to anchor the load-bearing identification, and it provides a referee with a direct path from headline to robustness without bibliographic detour. Strong.

**Flow assessment:** Placed third in the §7 sequence, right after the two cutoff-validity checks. The logic is "cutoff is real (McCrary + CJM) → balance holds (CCT) → the load-bearing bin assignment itself is robust to measurement noise (this paragraph)." This is exactly the correct ordering: density → covariate balance → identifying-variable measurement validity. **CLOSED.**

### Phase 2 addition (d) — Wild bootstrap rewrite (B=9,999 + honest gap disclosure)

**Old text (Phase 1.5b):** "Wild bootstrap p-values agree with the cluster-robust analytic p-values within ±.07 across the 14 cells, with the largest gap on op\_cost\_ex\_rent at T1 (analytic $p_{\text{cluster}} = .105$ vs.\ wild $p_{\text{wild}} = .041$, straddling the $\alpha = .05$ threshold)."

**New text (L410):**
> "Wild bootstrap and cluster-robust analytic p-values agree on 13 of 14 cells (within ±.02). The one notable departure is op\_cost\_ex\_rent at T1, where the analytic cluster-robust standard error gives $p_{\text{cluster}} = .105$ while the wild bootstrap returns $p_{\text{wild}} = .048$ (significant at $\alpha = .05$ before Holm correction; not significant after Holm step-down across the four-outcome family). The wild-vs-analytic gap reflects the documented small-cluster bias of analytic CR1 standard errors \citep{CameronGelbachMiller2008_clusterboot}; we report both inferences and treat the analytic $p = .105$ as the conservative headline. The headline pure-tenant area\_own estimate at T2 ($+1{,}151$~m\textsuperscript{2}) has wild bootstrap $p$ consistent with the analytic $p = .036$."

**Verification against `tab_wild_bootstrap_en.tex` (cell-by-cell |p_cluster − p_wild|):**

| # | Spec | Outcome | Bw | p_cluster | p_wild | gap | ≤ .02? |
|---|------|---------|-----|-----------|--------|-----|--------|
| 1 | A | op_cost | 3305 | .6675 | .6732 | .0057 | ✓ |
| 2 | A | off_farm_income | 3716 | .7137 | .7206 | .0069 | ✓ |
| 3 | A | consumption | 3931 | .0937 | .0926 | .0011 | ✓ |
| 4 | A | farm_income | 3268 | .3444 | .3671 | **.0227** | ✗ |
| 5 | B | op_cost | 3636 | .7581 | .7680 | .0099 | ✓ |
| 6 | B | off_farm_income | 3835 | .5698 | .5819 | .0121 | ✓ |
| 7 | B | consumption | 3817 | .2318 | .2391 | .0073 | ✓ |
| 8 | B | farm_income | 4221 | .3262 | .3665 | **.0403** | ✗ |
| 9 | A | rent_cost | 500 | .0959 | .1071 | .0112 | ✓ |
| 10 | A | rent_cost | 1000 | .1636 | .1760 | .0124 | ✓ |
| 11 | A | rent_cost | 3300 | .8060 | .8051 | .0009 | ✓ |
| 12 | A | op_cost_ex_rent | 500 | .1051 | .0481 | **.0570** | ✗ (flagged) |
| 13 | A | op_cost_ex_rent | 1000 | .1807 | .2020 | **.0213** | ✗ |
| 14 | A | op_cost_ex_rent | 3300 | .6512 | .6775 | **.0263** | ✗ |

**MAJOR finding — Wild bootstrap "13 of 14 within ±.02" claim is incorrect.**

By direct count from the embedded table, **9 of 14 cells are within ±.02** (cells #1, 2, 3, 5, 6, 7, 9, 10, 11). **5 of 14 exceed ±.02** (cells #4, 8, 12, 13, 14). The text claim "agree on 13 of 14 cells (within ±.02)" overstates the agreement by 4 cells.

The previous Phase-1.5b claim "within ±.07 across the 14 cells" was tight (max gap .0570 < .07 ✓) but loose; the Phase 2 rewrite attempted to tighten this to "13 of 14 within ±.02" and got the count wrong. A referee with a calculator finds this in 60 seconds.

**Suggested correction (one of three options, in increasing tightness):**

1. **±.05 framing (loosest):** "Wild bootstrap and cluster-robust analytic p-values agree on 13 of 14 cells within ±.05; the one notable departure is op\_cost\_ex\_rent at T1 (gap .057), ..." — verified: 13 of 14 cells have gap ≤ .05 (only cell #12 exceeds; gaps are .0227, .0403, .0570, .0213, .0263 for the five > .02 cells).

2. **±.04 framing (cleaner threshold):** "Wild bootstrap and cluster-robust analytic p-values agree on 12 of 14 cells within ±.04; the two departures are farm\_income (Spec B, gap .040) and op\_cost\_ex\_rent at T1 (gap .057)" — verified.

3. **Median framing (most honest):** "Across the 14 cells the median absolute gap between wild and analytic p-values is $\approx .012$; 9 of 14 cells fall within ±.02 and the maximum gap is .057 at op\_cost\_ex\_rent T1, the headline-relevant cell." — verified (median gap of the 14 values is ≈ 0.0117).

I would recommend option 3: it is the most defensible against a referee with R. The current "13 of 14 within ±.02" is the only Phase 2 addition with a verifiable numerical error.

**Second MAJOR finding — the pure-tenant area\_own T2 claim is not verifiable from `tab_wild_bootstrap_en.tex`.**

The text states: "The headline pure-tenant area\_own estimate at T2 ($+1{,}151$~m\textsuperscript{2}) has wild bootstrap $p$ consistent with the analytic $p = .036$."

Inspecting `tab_wild_bootstrap_en.tex`, the table contains 14 cells: 8 P2 replication cells on $\{$op\_cost, off\_farm\_income, consumption, farm\_income$\}$ (Panels A and B) and 6 P3b-1 CH4 cells on $\{$rent\_cost, op\_cost\_ex\_rent$\}$ at T1/T2/T3. The pure-tenant area\_own coefficient — the load-bearing F1 cell — **does not appear in this table**. A referee following the in-text citation chain will go to Table~\ref{tab:wild_bootstrap_en}, find the cell missing, and either flag the claim as unsupported or interpret the omission as evidence-suppressing. This is a credibility risk.

**Recommended fix:** either (i) extend `tab_wild_bootstrap_en.tex` with a Panel C reporting the 4-bin × area\_own wild bootstrap p-values at T2 (5 cells; pure\_tenant + low\_owner + mixed + high\_owner + reference), or (ii) remove the sentence and defer this to the online appendix with an explicit pointer ("Wild bootstrap inference on the 4-bin area\_own coefficients at T2 is reported in Online Appendix Table B.X, with the pure\_tenant cell p\_wild = [number] consistent with the analytic p = .036."). Option (i) is cleaner because the area\_own cell is the load-bearing headline and the wild bootstrap result deserves equal visibility to the cluster-robust result. **MAJOR**.

### Roadmap sentence at §7 head

**Status:** Still missing in current main.tex (verified via `grep -n "We organize the robustness"` — no match).

Phase-2-R1 from the 1.5b review (single highest-leverage edit) was not applied. With Phase 2 having added three more paragraphs (CJM, CCT, measurement-error), the §7 sequence is now 15+ items presented flat. A reader has no map. The roadmap recommendation from 1.5b remains the single highest-leverage §7 organizational fix. **MINOR-but-now-more-pressing** (15 items > 12 items).

### Phase-2-R2 — Spec B / Spec C forward reference from §6

**Status:** Not addressed in Phase 2. (Out of Phase 2 scope, but flagging for Phase 3.)

### Phase-2-R3 — Wild bootstrap caption inference-type sensitivity note

**Status:** Caption (`tab_wild_bootstrap_en.tex` L33) was rewritten and now contains the disclosure: "Reported p\_wild is new R-only inference at per-outcome MSE bandwidth." However, it does NOT include the explicit "cluster-robust analytic significance ≠ wild bootstrap significance at op\_cost\_ex\_rent T1" inference-type sensitivity note. The text paragraph now flags this directly in §7 (which is sufficient for a careful reader), so the caption gap is a NIT rather than a MINOR. **Partially addressed.**

---

## 2. Robustness Section Substantive Check (Post-Phase-2)

End-to-end §7 reading (now 15+ paragraphs):

1. **McCrary continuity + CJM (L385–387):** Strong. Honest narrow-window disclosure preserved; CJM corroboration cleanly placed. The mechanical-on-symmetric-sample disclosure (triple-margin extension is degenerate) is exactly the right framing.
2. **CCT covariate continuity (L389–391):** Strong. 0/18 at .05, 2/18 at .10 within FPR. **NEW.**
3. **Measurement-error sensitivity (L393–395):** Strong. The donut + Robust 25/75 + strict comparison is exactly the standard fuzzy-RD measurement-error treatment, and the pure_tenant coefficient is stable to ±0.4% across the three treatments — load-bearing F1 cell is invariant. **NEW.**
4. **McCrary density figure (L397–402):** Visual anchor for items 1–3. Fine.
5. **Differential-attrition placebo (L404):** Strong.
6. **Outlier-sensitivity ladder (L406–408):** Strong (Post-P2 cleanup).
7. **Wild cluster bootstrap (L410–412):** Rewritten with honest analytic-vs-wild gap disclosure. **One numerical-claim error (count of cells within ±.02) and one missing-table cell (area\_own at T2) are the residual Phase 2 issues.** (See MAJOR findings above.)
8. **Event-study (L414–421):** Strong.
9. **HonestDiD sensitivity (L423–432):** Strong (the cleanest HonestDiD discussion I've seen in DiD-RD work; the $\bar M^* = 0$ disclosure plus the bin-heterogeneity reframing is the right argument).
10. **Spec B (L434–436):** Strong.
11. **Spec C (L438–440):** Strong (sign preserved; Spec C strengthens, not weakens).
12. **Dropped-194 balance (L442–444):** Strong.
13. **Attrition placebo across bandwidths (L446–448):** Strong.
14. **Placebo cutoffs (L450–452):** Strong (32 cells; 3 at p<.10 ≈ 3.2 expected; Bonferroni-cleared headline).
15. **Why area-only as robustness + Area-only treatment robustness (L454–456):** Strong.
16. **Asymmetric-sample (L458):** Strong.
17. **Province-by-year FE (L462):** Strong; honest sgg_cd unavailability disclosure.
18. **Triple eligibility margin manipulation test on asymmetric comparator (L471):** Strong.

The flow of the three new Phase 2 additions (CJM corroboration → CCT covariate balance → measurement-error sensitivity) is logically tight: density at cutoff → covariate balance at cutoff → identifying-variable measurement validity. They integrate at the head of §7 without orphaning later items. No item is dislodged or made redundant by the additions.

**Internal cross-references:** All new `\ref{tab:cjm_density_en}`, `\ref{tab:cct_covariate_continuity_en}`, `\ref{tab:fuzzy_bin_sensitivity_en}` resolve to the three new tables (verified via `ls` of `_outputs_symmetric/`).

**Robustness density:** 18 distinct items. For AJAE this is appropriate (AJAE referees expect heavy §7); for Food Policy 4-5 items should migrate to online appendix. Not a defect at the AJAE-target stage; flagging for journal-fit awareness on the JAE/FP cascade.

---

## 3. Residual Issues

| ID | Severity | Issue | Recommendation |
|----|----------|-------|----------------|
| Phase-2b-M1 | **MAJOR** | Wild bootstrap text says "agree on 13 of 14 cells (within ±.02)"; direct table count yields 9 of 14 within ±.02 (5 cells exceed: gaps .0227, .0403, .0213, .0263, .0570). Verifiable in 60 s with the embedded table. | Replace with one of three honest framings; option 3 (median + max) is preferred. See §1(d) above. |
| Phase-2b-M2 | **MAJOR** | Wild bootstrap text claims "headline pure-tenant area\_own at T2 has wild bootstrap p consistent with analytic p=.036," but the area\_own × bin cells do not appear in `tab_wild_bootstrap_en.tex`. Reader cannot verify. | Either extend the table with a Panel C (5 area\_own × bin cells at T2) or drop the sentence and add an explicit Online Appendix pointer. Option (i) preferred — the area\_own headline deserves wild bootstrap visibility. |
| Phase-2-R1 (carried) | MINOR | §7 roadmap sentence still missing; now 18 items presented flat. | Insert the 4-sentence roadmap at L384 from the 1.5b recommendation (with three categories now expanded to four: cutoff-validity / specification / treatment-definition / inference). |
| Phase-2-R2 (carried) | MINOR | Spec B/C introduced without forward-reference from §6. | Add forward-reference in §6 (e.g., "we report Spec A as the headline; Spec B and Spec C robustness variants are deferred to \S\ref{sec:robustness}"). |
| Phase-2b-NIT-1 | NIT | "CJM's bandwidth-robust inference" → strictly "CJM's jackknife-variance inference". | One-word fix at L385. |
| Phase-2b-NIT-2 | NIT | CCT 2-marginal-cells correlation note absent. | Add half-sentence: "Both marginal cells occur at T3 and concern related covariates (farm type and full-time status), consistent with a single dimensional correlation rather than independent imbalances." |
| Phase-2b-NIT-3 | NIT | `tab_wild_bootstrap_en` caption still silent on inference-type sensitivity at op\_cost\_ex\_rent T1; relies on §7 text alone. | Add a one-line caption note flagging the inference-type sensitivity at T1. (Now lower priority because §7 text is explicit.) |

---

## 4. Score

| Component | Score | Δ from 1.5b | Notes |
|-----------|-------|------|-------|
| Identification placebos (McCrary + CJM, attrition, cutoff placebos) | **9.7** | +0.2 | CJM corroboration added; modern-method confirmation of McCrary reading. |
| Covariate continuity (NEW) | **9.5** | +9.5 (new) | 0/18 at .05, 2/18 at .10 → within FPR; load-bearing balance check. |
| Measurement-error sensitivity (NEW) | **9.5** | +9.5 (new) | Donut + Robust 25/75 + strict; pure\_tenant cell invariant ±0.4%. |
| Outlier sensitivity | 9.5 | 0 | Carried from 1.5b. |
| Inference robustness (wild bootstrap, Holm) | **8.5** | **−1.0** | Phase 2 rewrite is more honest in spirit (op\_cost\_ex\_rent T1 explicitly flagged + Holm-correction disclosure) but introduces two MAJOR issues: incorrect "13 of 14 within ±.02" count, and unsupported pure-tenant area\_own T2 claim. |
| Specification variants (Spec B, Spec C) | 9.0 | 0 | Carried. |
| Treatment-definition robustness | 9.0 | 0 | Carried. |
| Section organization | 8.0 | 0 | Roadmap still missing; now 18 items presented flat (vs. 12 in 1.5b). |
| Honest disclosure | **9.7** | −0.3 | Was 10.0 in 1.5b; the new "13 of 14 within ±.02" claim is the rare disclosure miss that undercuts the otherwise-strong honesty record. |

**Lens 5 score: 9.4/10**
**Δ from post-Phase-1.5b baseline (9.3): +0.1**

**Justification:**
- Phase 2 additions (a), (b), (c) are excellent: CJM corroboration is the right modern-method confirmation; CCT covariate continuity is the canonical balance check; measurement-error sensitivity directly defends the load-bearing F1 bin assignment against an obvious referee challenge. Each adds substantively to the manuscript's credibility. (+0.3)
- Phase 2 addition (d) — the wild bootstrap rewrite — is partially successful: the analytic-vs-wild gap disclosure on op\_cost\_ex\_rent T1 is exactly the right level of honesty, and the Holm-correction qualifier is correct. But two MAJOR issues (incorrect count + unsupported area\_own claim) introduce verifiable errors that a referee finds in 60 seconds. (−0.2)
- Roadmap sentence still missing; section organization unchanged (0).
- Net Δ = +0.1.

**Target ≥ 9.5: NOT MET (9.4).** Close, but blocked by the two MAJOR findings on the wild bootstrap rewrite. Both fixes are <30-minute edits:
- Phase-2b-M1: 1 sentence rewrite.
- Phase-2b-M2: either add a Panel C to `tab_wild_bootstrap_en.tex` (preferred — pull the 5 cells from `_outputs_symmetric/` if already computed, or add to the wild bootstrap script and re-run; B=9,999 takes <2 min for 5 cells) or rewrite the sentence to defer to online appendix.

With M1 and M2 closed, projected Lens 5 score is **9.6/10** (target met).

---

## 5. Recommendation for Phase 2 follow-up (Phase 2b)

**Highest-leverage three edits to close to ≥9.5:**

1. **Fix the wild bootstrap "13 of 14 within ±.02" claim (Phase-2b-M1).** Suggested rewrite at L410:

   > "Wild bootstrap and cluster-robust analytic p-values agree closely across the 14 cells: the median absolute gap is .012 and 9 of 14 cells fall within ±.02. The largest gap is .057 at op\_cost\_ex\_rent T1, where the analytic cluster-robust standard error gives $p_{\text{cluster}} = .105$ while the wild bootstrap returns $p_{\text{wild}} = .048$ (significant at $\alpha = .05$ before Holm correction; not significant after Holm step-down across the four-outcome family). The wild-vs-analytic gap reflects the documented small-cluster bias of analytic CR1 standard errors \citep{CameronGelbachMiller2008_clusterboot}; we report both inferences and treat the analytic $p = .105$ as the conservative headline."

2. **Resolve the area\_own × bin wild bootstrap reference (Phase-2b-M2).** Preferred: add a Panel C to `tab_wild_bootstrap_en.tex` with 5 cells (pure\_tenant, low\_owner, mixed, high\_owner area\_own at T2, plus reference). Alternate: drop the trailing sentence at L410 and add explicit Online Appendix pointer.

3. **Insert the §7 roadmap sentence (Phase-2-R1 carried).** At L384 immediately after `\label{sec:robustness}`:

   > "We organize the robustness analysis into four groups: (i) cutoff-validity checks (McCrary, CJM, CCT covariate continuity, measurement-error sensitivity in baseline tenancy); (ii) inference robustness (wild cluster bootstrap with $B = 9{,}999$, outlier-sensitivity ladder); (iii) specification variants (event-study parallel trends, HonestDiD, Spec B temporal restriction, Spec C covariate-rich, province-by-year FE); and (iv) treatment-definition variants (area-only baseline at \S\ref{sec:robustness-areaonly}, asymmetric-sample intermediate at \S\ref{sec:robustness-asymmetric}, placebo cutoffs, triple eligibility margin). The headline F1 monotone tenancy gradient and the $\hat\beta_3 \le 0$ operating-cost-net-of-rent point estimate are preserved across all 18 checks."

These three edits would close the open items, lift Section organization 8.0 → 9.5 and Inference robustness 8.5 → 9.5, and bring the overall Lens 5 score to **9.6/10**.
