# Lens 5 (Robustness) — Seven-Pass Review, Wave 7

**Manuscript:** `paper/en/main.tex` (Wave 7, 33pp, main @ `6b9c35d`)
**Target journal:** AJAE first submission
**Scope:** §7 Robustness (L370–425), with cross-reference to §4 Data (L311–321), §5 Identification (L323–343), and intro framing (L40–67).
**Date:** 2026-05-19

---

## Verdict: **NEEDS WORK** (with caveat below)

The Wave 7 §7 is a substantial advance over the Wave 5 §7 stub. Three of the five Wave-5 CRITICAL gaps are now closed in the manuscript proper:

1. **C1 (anticipation)** — partially closed via the McCrary $t=1.34$, $p=.18$ result on the 2018 baseline and the explicit §5 L328 framing that "the McCrary continuity test verifies absence of pre-2018 strategic area reporting under PIDPS anticipation."
2. **C2 (McCrary in §3 framing)** — closed: McCrary is now in identification text (L328, L343) AND has a numerical robustness result (L374, Fig 1) AND is extended to a triple-margin density continuity test (§7.2 L418).
3. **C3 (attrition)** — closed: the §4 panel-attrition decomposition (L317) and §7 differential-attrition placebo (L383, $-0.082$, $p=.46$) is a competent reply.

Two Wave-5 gaps remain materially open (multiple-testing family definition; HonestDiD $\bar M^*$ breakdown value not given numerically), and three NEW Wave-7-stage robustness expectations are unmet (donut RDD; placebo cutoffs; minimum-detectable-effect power statement). The §7.1 area-only and §7.2 multi-RV additions are well-motivated but have framing risks that a sharp AJAE referee will pick up on within five minutes.

**The caveat:** the §7 prose is at submission-readiness on coverage breadth (8 subsections, the canonical AJAE robustness menu is broadly hit), but the prose is structurally thin — each subsection is a single paragraph, several subsections defer numerical results to replication-package files (`tab_wild_bootstrap_en.tex`, `tab_rob_outlier_en.tex`, `tab_specB.tex`, `multi_rv_density.txt`) rather than putting the headline robust estimate inline. AJAE referees typically expect the robustness coefficients to be **printed in the manuscript**, not deferred to the replication package. This is a presentation, not a substance, deficiency, but it compounds with the substantive gaps below into a 7/10 lens score.

---

## Q-by-Q answers (Q1–Q9 from the lens prompt)

### Q1. Are robustness checks MOTIVATED or THEATRICAL?
**Mostly motivated, with two theatrical risks.** Motivated: McCrary (referee-mandatory at any RDD), HonestDiD (referee-mandatory under single-pre-period DiD, L398 cites Roth 2022 correctly), attrition placebo (forced by the 80.1% panel completion at L317), outlier ladder (Athey-Imbens 2017 expectation), wild bootstrap (Cameron-Gelbach-Miller 2008 expectation given the 3,420-household clustering). **Theatrical risks:** (a) Spec B "richer covariate vector" (L407) is paragraph-deep but referees will want to see the *Spec B point estimates inline*, not in `tab_specB.tex` — the current text only asserts agreement within tolerance. (b) The §7.1 area-only comparison (L409) reframes a prior estimation choice (Wave 7 demoted the area-only `D_treat` to robustness) as a virtue rather than as an internal definitional pivot; a sharp referee will detect the asymmetry.

### Q2. McCrary at 0.5 ha ($t=1.34$, $p=.18$) — convincing or barely-PASS?
**Barely-PASS in absolute terms; defensible given the design.** Three issues:
- $t=1.34$ is the second-highest |t| among the three RVs in §7.2 (only off-farm income at $t=0.18$ is comfortably zero); cultivated area is the load-bearing one and it sits at the "wouldn't reject at $\alpha = .20$" margin. A referee will press on whether the *point estimate* of the log-density discontinuity (not just the $t$) is small in magnitude.
- The McCrary test is computed on the **frozen 2018 cross-section** ($n = 2{,}680$). This is the correct estimand under the manuscript's claim that 2018 is the relevant manipulation period — but the McCrary literature post-Cattaneo-Jansson-Ma (2020, *JASA*) has migrated toward the local-polynomial density estimator. The 2008 McCrary test in a 2026 submission to AJAE is **a one-line referee request away from a "please rerun with `rddensity`"** comment.
- The cultivated-area threshold of 5,000 m² is the **only sharp policy threshold**; the secondary $t=-1.64$ ($p=.10$) on owned-farmland (15,500 m²) — a margin that itself is part of the treatment definition under Wave 7's `D_eligible_obs_2018` — is borderline non-rejected. A sharp referee will compute the joint test (do the three RVs jointly reject density continuity?) and ask why the joint test is not reported.

**Convincing enough to PASS, not convincing enough to silence**: estimate ≈ 6/10 on the McCrary alone.

### Q3. Differential attrition placebo — sufficient?
**Yes, given how it is constructed.** Estimating a placebo RDD on $\mathbf{1}\{n_{\text{years}} = 5\}$ with $\hat\beta = -0.082$, $p = .46$ at $h = 1{,}000$ m² is the right test, the right outcome, the right bandwidth. **Two refinements a sharp referee will request:**
- Report at all three bandwidths (T1/T2/T3), not just $h = 1{,}000$. The §7 paragraph (L383) only gives T2; if attrition differential becomes significant at T1 (the marginal-window spec), the headline ITT identification at T1 is in question.
- The compound test: do attriters differ on *baseline observables* across the cutoff? The current paper only tests the binary attrition indicator, not the joint distribution of baseline covariates conditional on attrition. A McCrary-style joint covariate balance test on the attriter subset would fully close this.

### Q4. Power / MDE — is the study powered?
**Not explicitly stated. This is a gap.** With $N = 13{,}689$ farm-years across 3,420 households and 4 primary outcomes × 3 bandwidths = 12 cells in the main table, the implicit power against the headline $+1{,}122$ m² own-area effect at T2 is presumably adequate (the estimate is $p=.041$, so post-hoc the test was powered). But the manuscript never reports a minimum-detectable-effect (MDE) calculation at the prespecified bandwidth grid, never reports the design-effective N at T1 ($n = 760$, L359) which is **0.45× the pure-tenant own-area MDE** under standard small-cluster MDE arithmetic, and never confronts the operating-cost null at T3 ($p > .50$) as either a precision-driven null or a substantive null.

The §7.4 wild bootstrap subsection (L387) reports "$B = 999$ now, $B = 9{,}999$ at the replication-release stage" — this $B = 999$ is inadequate for a $p \approx .041$ headline; wild bootstrap CI half-width at $B=999$ is $\pm 0.014$, so a manuscript claim of $p = .041$ has Monte-Carlo error bar $[.027, .055]$. A sharp AJAE referee will say: "you cannot claim $p = .041$ at $B = 999$ on the load-bearing test; rerun at $B = 9{,}999$ before submission." This is a **MAJOR** issue.

### Q5. Placebo cutoffs (not just McCrary) — alternative cutoffs tested?
**No, and this is a CRITICAL gap.** Standard AJAE-grade RDD robustness requires placebo cutoffs at non-policy thresholds — e.g., 0.3 ha, 0.4 ha, 0.6 ha, 0.7 ha — to verify that the DiD-RD discontinuity is unique to the 0.5 ha statutory cutoff and not an artifact of the running-variable distribution. The Wave 7 §7 has McCrary density continuity but no DiD-RD placebo on non-policy cutoffs. This is the third-most-likely referee comment after (1) "rerun with `rddensity`" and (2) "give me $B = 9{,}999$ wild bootstrap."

### Q6. Anticipation / pre-trends — "no pre-trends" demonstrated cleanly?
**Partially. The HonestDiD subsection (L398–405) is correct in spirit but missing the headline number.** The manuscript says "the breakdown $\bar M^*$ at which the 95\% CI first includes zero is reported alongside the figure" — this is a placeholder. **The breakdown value should be stated in the manuscript text**, e.g., "the breakdown $\bar M^* = 1.6$ exceeds the conventional 1.0 threshold, so the headline survives linear-trend extrapolation up to 60\% larger than the observed pre-period gap." Without this number, a referee cannot evaluate the robustness; they will ask for it as the first R&R comment.

The L389 event-study assertion ("2018 pre-period coefficient is statistically zero $|t| < 1$") is correct framing under LN-10 but is single-pre-period evidence (only 2018→2019 gap exists; pre-2018 data is unavailable per the FHES Wave 1 design). Roth (2022) is cited (L398) but the manuscript should be more explicit that the single-pre-period limitation is *the* central reason HonestDiD is required, not just one of several robustness checks. As written, HonestDiD is presented as a routine robustness; in fact it is the load-bearing pre-trends defense.

### Q7. §7.1 area-only comparison — framing risk for a sharp referee?
**Framing risk is real.** The §7.1 paragraph (L409) frames the area-only vs. statutorily-eligible comparison as "the headline coefficients are robust to the more permissive area-only definition" — and indeed the numerics support this (0/24 cells flip $\alpha = .05$, 3 cells flip $\alpha = .10$, all on the auxiliary off-farm income outcome whose pooled coefficient is near zero). But the **direction of the comparison is inverted from how a Wave-5-aware reader will read it.** The historical record (per the CLAUDE.md and MEMORY.md trail) is that the area-only `D_treat` was the Wave 5 main analysis, and the statutorily-eligible `D_eligible_obs_2018` was promoted to main in Wave 7 PR #15. The §7.1 prose presents the comparison as if Wave 7 always was the main definition and area-only is a robustness alternative — a sharp referee reading the replication package will see the Wave-5/Wave-7 history and ask why the promotion happened.

The right reply is: "we initially used area-only because it maps directly to the area-cutoff policy threshold; we discovered that 14.6% of area-eligible households fail criteria (ii) or (vi), and promoted the statutorily-eligible definition to align ITT with the actual eligibility rule." This story is **in §3 (L92) but not echoed in §7.1**, leaving §7.1 reading as if the area-only definition was always a robustness check.

**Second framing risk:** the §7.1 paragraph says "three sign flips appear, all on the off-farm income outcome whose pooled coefficient is statistically indistinguishable from zero." This is a fair reading, but a referee will ask: *the F2 null IS the off-farm income outcome*. If the F2 coefficient flips sign under the area-only definition, that affects the interpretation of F2-as-informative. The manuscript should clarify that F2 reads as null under *both* definitions; only the bin-level point-estimate signs flip, not the pooled sign.

### Q8. §7.2 multi-RV McCrary — right framing?
**Right framing, executed competently, but does not address what it claims to address.** §7.2 (L418) computes McCrary on each of the three FHES-observable eligibility margins separately. This is a correct first-order test. **What it does not test:**
- **Joint manipulation.** A household manipulating *one* RV to land in the eligible region need not manipulate the *other two*; the McCrary on each margin individually is a marginal test, not a joint test. The right test is a joint density-continuity test on the 3D distribution at the joint threshold $(5000, 15500, 45M)$.
- **The interaction.** §3 (L92) reports that 1.8% of the area-eligible cohort fails (ii) and 12.8% fails (vi). If these are correlated — e.g., households at the area cutoff who are also at the off-farm-income cutoff — then the manipulation surface is the joint surface, not the marginal surfaces. §7.2 ignores this.
- **The 15,500 m² threshold $t = -1.64$ ($p = .10$).** This is borderline non-rejected and the L418 paragraph reads it as "passes at conventional levels" — but $p = .10$ on the load-bearing-secondary margin is exactly the level at which a referee will say "you have not ruled out manipulation on owned farmland."

**Framing fix:** §7.2 should report (a) the joint test, (b) the correlation across the three RVs at the joint threshold, and (c) explicitly state that $p = .10$ on owned farmland is not the same as $p > .20$ on the others.

### Q9. What OBJECTIONS would a sharp AJAE referee STILL raise?
See "Sharp-referee top 10" section below.

---

## CRITICAL issues (block first submission)

**C1. Wild bootstrap $B = 999$ for a $p = .041$ headline.** L387 says "manual cluster-Rademacher refits with $B = 999$ following CGM 2008; full $B = 9{,}999$ at the replication-release stage." The headline pure-tenant own-area test at T2 has analytic $p = .041$ and the manuscript claims wild bootstrap "consistent with the analytic $p = .041$" *at $B = 999$.* Monte-Carlo CI on a wild bootstrap p-value at $B = 999$ around the true $p = .04$ is approximately $\pm 0.012$ (sqrt(.04 × .96 / 999) ≈ .006 SE, ×1.96 ≈ .012). The headline survives at $B = 999$, but the AJAE submission-grade standard is $B = 9{,}999$ minimum. **Fix:** rerun at $B = 9{,}999$ before submission and update L387; if any cell crosses $\alpha = .05$ under the larger $B$, that is load-bearing news.

**C2. HonestDiD $\bar M^*$ breakdown not stated numerically.** L398 and L403 both promise the breakdown value but do not state it. Without $\bar M^*$, the HonestDiD subsection is a citation, not a robustness check. **Fix:** state the breakdown value inline (e.g., "$\bar M^* = 1.6$").

**C3. No placebo cutoffs.** AJAE-grade RDD requires testing $D_i \cdot \text{Post}_t$ at non-policy cutoffs (e.g., 0.3, 0.4, 0.6, 0.7 ha) to demonstrate the headline is not an artifact of the running-variable distribution. The manuscript does not have this. **Fix:** add a §7.X placebo-cutoff table with $\hat\beta_1$ at 4–6 non-policy thresholds; expectation is that none cross $\alpha = .05$.

---

## MAJOR issues (block at 90/100 first-submission threshold; surfaceable at R&R if pushed)

**M1. Spec B coefficients deferred to replication package.** L407 asserts agreement within Phase 3 tolerance without printing Spec B point estimates inline. AJAE referees expect the four-outcome × three-bandwidth Spec B coefficient table in the manuscript (or at minimum, an inline table with the four primary $\hat\beta$ point estimates). **Fix:** insert a 4-row × 2-column table showing Spec A vs. Spec B point estimates and SE at T2 for the four primary outcomes.

**M2. Multiple-testing family definition still unstated.** Wave-5 review (Lens 5 M3) flagged this; Wave 7 inherits it. The Holm step-down (L341) does not state the inference family. With four primary outcomes × five bins × three bandwidths = 60 cells in the headline, the family definition is load-bearing. **Fix:** explicitly state in §5 inference paragraph (L341) that Holm is applied across {$\hat\beta_1$ pure-tenant, $\hat\beta_3$ op_cost, $\hat\beta_4$ off-farm income, $\hat\beta_5$ rent-cost} at T2 as the primary family (m = 4); other cells are reported as descriptive.

**M3. Monotonicity test is informal.** The F1 four-bin monotonicity claim (L350) is currently presented as "the four non-pure-owner-bin point estimates are monotone-decreasing." A sharp referee will request a formal monotonicity test (Romano-Wolf, or a one-sided test of monotonicity along a partial order; Bugni-Hahn-Mullen 2018 for the four-bin partial order). **Fix:** report the Romano-Wolf adjusted $p$ on the monotonicity null in §6 or §7; this is non-optional under modern AJAE standards on monotonicity claims.

**M4. Donut RDD and kernel sensitivity missing.** Wave-5 Lens 5 m1 flagged this; Wave 7 inherits it. Standard AJAE RDD robustness includes donut-hole (drop ±50, ±100 m² around the cutoff to address heaping/manipulation in the immediate neighborhood) and kernel-choice robustness (triangular is in main spec; uniform and Epanechnikov are standard alternatives). The current §7 has neither. **Fix:** add a donut and kernel-sensitivity row to the §7 outlier-ladder table.

**M5. §7.1 area-only framing inversion.** As detailed in Q7 above. The §7.1 prose presents the Wave 7 statutorily-eligible definition as the long-standing main definition, when in fact Wave 7 promoted it from a Wave 5 area-only baseline. A sharp referee reading the replication package will detect this asymmetry. **Fix:** add one sentence in §7.1 acknowledging that the area-only $D^{\text{area}}_i$ was the prior baseline and that the promotion to statutorily-eligible was driven by the 14.6% non-receipt margin discovery.

**M6. §7.2 multi-RV McCrary tests marginals, not joint.** As detailed in Q8 above. The three separate McCrary tests on cultivated area, owned farmland, and off-farm income do not constitute a joint density-continuity test on the 3D eligibility surface. **Fix:** state explicitly in §7.2 that these are marginal tests; report the correlation structure across RVs; if possible, report a joint Hotelling-style test.

**M7. McCrary 2008 vs. Cattaneo-Jansson-Ma 2020 `rddensity`.** AJAE-2026 referees increasingly expect the `rddensity` local-polynomial density estimator. The McCrary 2008 cite (L374, L418) is correct but the modern alternative is one R&R comment away. **Fix:** rerun with `rddensity` and report both; the disagreement (or agreement) on $t$-statistic is highly diagnostic.

**M8. Operating-cost T3 null is acknowledged but not interpreted.** L359 reports $\hat\beta_3$ at T3 attenuates "to approximately zero ($p > .50$)" — but the manuscript does not say whether this is an *expected* attenuation (S,s inaction band weakens at wider bandwidths because wider-window households are off the inaction margin) or an *adverse* result (the headline only holds at narrow bandwidths). The §7.3 outlier-ladder claim of "sign and significance stable across all four treatments" (L385) does not address the T3 attenuation; a referee will read T3 attenuation as either evidence the result is local (good) or evidence the result is fragile (bad). **Fix:** add one sentence interpreting T3 attenuation as an expected consequence of the locality of the inaction band (mechanism-implied, not fragility-implied).

---

## MINOR issues (close before final submission)

**m1. McCrary $n = 2{,}680$ vs. $n = 319$ at $h = 1{,}000$ for attrition placebo.** L374 reports the McCrary $n = 2{,}680$ on the full cross-section; L383 reports attrition placebo $n = 319$ "at $h = 1{,}000$." The $n = 319$ is the narrow-window count — but the McCrary uses the full sample. The asymmetry should be motivated.

**m2. Outlier ladder cites four regimes but only asserts "sign and significance stable" without numerics.** L385 should print the four point estimates inline (raw, IHS, 1/99 winsorize, 0.5/99.5 winsorize) on the headline op_cost coefficient at T2.

**m3. Sub-district ($sgg_cd$) clustering is promised but not reported.** L341 says "Sub-district clustering is reported in §7 as a robustness check." Search §7 — sub-district clustering is not in §7. **Fix:** add a one-line sub-district-clustering result, or remove the L341 promise.

**m4. Event-study figure caption (L394) restates the LN-10 gate but does not give the 2018 pre-period coefficient point estimate.** Reader cannot verify "$|t| < 1$" without the estimate. **Fix:** insert the 2018 estimate in the figure caption.

**m5. Multi-RV figure (L423) caption is unusually long.** Three $t$-statistics in the caption (1.34, $-$1.64, 0.18) work, but the visual would be cleaner if the figure displayed the $t$ values on each panel and the caption referred to the figure.

---

## What MISSING items a sharp AJAE referee will raise (top 10)

1. **"Rerun the wild bootstrap at $B = 9{,}999$."** — minutes-to-flag.
2. **"State the HonestDiD breakdown value $\bar M^*$ in the text."** — minutes-to-flag.
3. **"Run placebo cutoffs at 0.3, 0.4, 0.6, 0.7 ha."** — minutes-to-flag.
4. **"Rerun the McCrary with `rddensity` (Cattaneo-Jansson-Ma 2020)."** — minutes-to-flag.
5. **"Print Spec B coefficients inline; the assertion of within-tolerance agreement is not auditable from the manuscript."** — minutes-to-flag.
6. **"What is your inference family for the Holm step-down?"** — referee comment #1 from a multi-testing-aware reader.
7. **"The monotonicity claim is informal; report a Romano-Wolf or Bugni-Hahn-Mullen joint monotonicity p-value."** — referee comment from an econometrics reader.
8. **"The §7.2 multi-RV McCrary tests are marginal; report the joint test."** — referee comment #1 from a manipulation-focused reader.
9. **"At T3 the headline op_cost effect attenuates to zero — is the headline local-to-the-cutoff or fragile?"** — referee comment from a robustness-focused reader.
10. **"Donut RDD and alternative kernel choice — these are AJAE-standard, please add."** — referee comment from a methods-conservative reader.

---

## Score: **7.0 / 10**

Breakdown of the score:
- **+1.5 from Wave 5 (6.8 → 8.3 pre-deductions):** C1 anticipation, C2 McCrary-in-§3, C3 attrition all closed. The Wave 5 critical gaps are gone. This alone is a 22% improvement.
- **−0.5 for C1 wild-bootstrap $B = 999$ on the load-bearing headline:** this is a clean critical-tier deduction since the analytic $p = .041$ is the only sub-.05 headline value.
- **−0.4 for C2 HonestDiD breakdown not stated:** a literal missing number that the referee will demand.
- **−0.3 for C3 missing placebo cutoffs:** standard AJAE RDD robustness, two-line fix, big credibility win.
- **−0.1 for the §7.1 framing inversion and §7.2 marginal-vs-joint:** sharp-referee-detectable but defensible in R&R.

Net **7.0/10**. The lens 5 Wave-5 score was 6.8/10 with three critical gaps; the Wave-7 robustness section is genuinely stronger but the standard has also moved up (this is a submission-stage review, not a draft review). To clear 8.0 requires C1 ($B = 9{,}999$), C2 ($\bar M^*$ inline), C3 (placebo cutoffs added), and three of the eight MAJOR fixes (M1 Spec B inline, M2 inference family stated, M7 `rddensity` rerun are highest-leverage). All ten of these are mechanical, not conceptual — the §7 framework is sound; the deficits are presentation and one-off computations.

## Cross-references

- Wave 5 Lens 5: `quality_reports/seven_pass_main/lens_5_robustness.md` (6.8/10; three critical gaps now closed).
- §3 framing: `paper/en/main.tex` L92 (statutorily-eligible vs. area-only ITT-vs-ATT wedge).
- §5 identification: `paper/en/main.tex` L328 (McCrary-in-§5 framing now present).
- §7.1 area-only comparison source: `scripts/R/_outputs_eligibility/treatment_definition_comparison.md` (0/24 cells flip $\alpha=.05$).
- §7.2 multi-RV densities source: `scripts/R/_outputs_eligibility/multi_rv_density.txt`.
- Replication-package robustness tables (not inline; M1 candidates): `scripts/R/_outputs_eligibility/tab_specB.tex`, `tab_rob_outlier_en.tex`, `tab_wild_bootstrap_en.tex`.
