# Lens 5 — Robustness (Third Seven-Pass, Post-Phase-1.5)

**Manuscript:** `paper/en/main.tex` (496 lines; §7 lines 381–468)
**Baseline (post-Phase-1):** 8.6/10 — 0 CRITICAL / 3 MAJOR / 4 MINOR
**Target:** ≥ 9.0/10 (AJAE first-submission grade)

---

## Score: **9.0/10** (Δ +0.4)

| Grade band | Verdict |
|------------|---------|
| 0 CRITICAL | All headline robustness claims are now tabularized in-paper; no compile-blocker. |
| 1 MAJOR | One new self-inflicted text↔table inconsistency introduced by Phase 1.5 (paragraph claims "available in replication package" but the `\input{}` now embeds all four outcome tables). |
| 4 MINOR | Roadmap sentence still absent at §7 head; McCrary narrow-window soft-pedaling unchanged; wild-bootstrap table introduces a 38.34pt overfull hbox; B=999 vs. release-stage B=9,999 wording. |

Phase 1.5 resolved M1 (outlier ladder embedding) and M2 (wild bootstrap embedding) from the post-Phase-1 audit, and the HonestDiD reframe (N3) is now a textually coherent §7.5 paragraph (lines 413–415) that explicitly acknowledges $\bar M^* = 0$ as a limit-of-the-test rather than evidence against the headline. Net movement: +0.4. The remaining gap to 9.5 is structural (roadmap, McCrary candor) not load-bearing.

---

## Phase 1.5 rubric responses

### (1) Did `\input{tab_rob_outlier}` and `\input{tab_wild_bootstrap}` resolve M1/M2?

**M1 (outlier ladder): RESOLVED with one residual inconsistency.**
- `paper/en/main.tex:398` now reads `\input{../../scripts/R/_outputs_symmetric/tab_rob_outlier_en.tex}`, which embeds **all four** outcome tables (op_cost, off_farm_income, consumption, farm_income), each a 3-bandwidth × 6-row block (IHS, Winsor p1/p99, Winsor p0.5/p99.5 × Spec A/B). Sign-stability of the headline op_cost coefficient across IHS/Winsor/raw is now visible to the referee on first read.
- **Residual:** Line 396 still asserts "Analogous outlier-ladder tables for the other three primary outcomes are available in the replication package." That sentence was true under M1's old "only embed op_cost" plan; under Phase 1.5 it is *factually wrong* — the other three tables are now sitting on the page immediately after. This is a self-introduced text↔table inconsistency (see M1 below).

**M2 (wild bootstrap): RESOLVED.**
- `paper/en/main.tex:402` embeds `tab_wild_bootstrap_en.tex` (Panel A: 8 P2 replication cells; Panel B: 6 P3b-1 CH4 cells = 14 headline cells). p_cluster vs. p_wild are reported side-by-side; the headline claim "agree within ±.01" is now directly verifiable from the table itself (largest spread: op_cost_ex_rent T1 .1051 → .0410, which is actually .064 apart — see M2 minor below).
- The B=999 / B=9,999 release-stage caveat is preserved in the paragraph.

### (2) HonestDiD reframe (N3): clean?

**Yes — substantially improved.** Lines 413–415 now contain a two-paragraph treatment:
1. Reports $\bar M^* = 0$ honestly as the breakdown value.
2. Explicitly states "We acknowledge that $\bar M^* = 0$ is the binding interpretation … we do not claim the HonestDiD result supports the headline."
3. Pivots to the load-bearing F1 cross-bin gradient identification (off heterogeneity within the post-period, not off any single bin's magnitude) and notes that bin-specific HonestDiD is the appropriate follow-up.
4. Flags the 2018 placebo coefficients ($|t|<1$ at each bin) as the available pre-trend evidence given the single-pre-period constraint.

This is the right tone for a Roth-2022-aware referee. It does not promise more than the test delivers; it locates the headline's identification on a margin the test does not bind. The only further hardening I would suggest (95-grade) is a one-line forward reference to the Wave 2 panel extension's timing — but the current text already mentions "FHES Wave 2 panel extension (post-2023)" so even this is borderline cosmetic.

### (3) M3 McCrary narrow-window p ≈ .07: Phase 2 polish or 1.5-blocker?

**Phase 2 polish.** The current text (line 385) characterizes the narrow-window results as "approaching but not reaching the $\alpha = .05$ threshold and consistent with noisy local-window estimation rather than a manipulation signature." That phrasing is on the **soft-pedal** end of acceptable but does not cross into misrepresentation: the wider $\pm 3{,}300$ window returns $p = .36$, the frozen-baseline argument structurally rules out post-period sorting, and the triple-margin extension on the asymmetric comparator (line 461) is internally consistent (all three margins pass at conventional levels). A more candid version would say "two narrow-window tests return $p$ slightly above $\alpha = .05$; we interpret this as small-sample noise given the bandwidth (n at $\pm 500$ ~ 600), not as a manipulation signal, because (a) the frozen 2018-baseline forecloses post-period sorting, (b) the wider window passes cleanly, and (c) the multi-rv comparator passes." That phrasing is journal-grade but not 1.5-blocking — the existing text is defensible at AJAE referee level.

### (4) Roadmap sentence at §7 head: still missing?

**Yes — unresolved from post-Phase-1.** Line 384 is blank; line 385 launches directly into the McCrary paragraph. A one-sentence roadmap ("§7 organizes the robustness evidence in five blocks: (i) cutoff-density and attrition placebos; (ii) outlier-sensitivity and wild-bootstrap inference; (iii) parallel-trends and HonestDiD; (iv) alternative specifications [Spec B temporal, Spec C covariate]; (v) treatment-definition robustness [area-only baseline, asymmetric-sample variant, province-by-year FE]") would orient the reader before the 13-paragraph torrent. This is the highest-marginal-value 90-grade fix outstanding.

### (5) Five-narrative differentiation (Spec B / Spec C / asymmetric / area-only / sido FE)

**Well-distinguished.** Each variant has a one-paragraph framing with a distinct identification story:
- **Spec B** (line 424): drops the 2020 transition year → isolates years 2/3 response from implementation-year onset.
- **Spec C** (line 428): adds farm-type × Post and age-cohort × Post → identifies off within-stratum variation.
- **Area-only** (lines 444–446): pre-Wave-7 baseline; the "textbook sharp RD at a single threshold" reading.
- **Asymmetric-sample** (line 448): one-sided screening; the sample-size-maximized version of the design.
- **Sido × year FE** (line 452): the 17-province sub-national check; correctly flags `sgg_cd` as unavailable in FHES MDIS.

The five-way distinction passes a referee's "what is each robustness check buying me?" test. The only tightening I would suggest is putting these in a single foreword paragraph (the roadmap) so the reader sees the architecture before the details. The forest plot (line 454) and the multi-rv McCrary figure (line 463) provide the visual closure for the treatment-definition family.

### (6) New issues from Phase 1.5 `\input{}` additions

**One new overfull hbox.** `main.log` shows 7 overfull boxes total; the Phase-1.5-introduced ones are:
- `tab_wild_bootstrap_en.tex` line 6–19: **38.34pt too wide** (the 7-column Panel A: Spec / Outcome / h / Estimate / p_cluster / p_wild / p_wild_holm). This is a moderate overflow at AJAE column width; a `\resizebox{\textwidth}{!}{...}` wrapper or moving p_wild_holm to a separate row would fix it.
- `tab_rob_outlier_en.tex`: **no overfull box** (4 columns, clean).

Other overfull boxes (`tab_descriptives` 53.4pt, `tab_het_own_share` 169.4pt, `tab_main_did_rd` 36.9pt, `tab_specB` 36.9pt, `tab_dropped_balance` 111.4pt, `tab_placebo_cutoffs` 150.2pt) are pre-existing from earlier waves; not Phase-1.5-attributable.

**Table positioning:** All Phase-1.5 `\input{}`s use `[t]` placement (per the inserted table source files). No float-stacking issue observed in the PDF render — the outlier ladder occupies pages 28–29, wild bootstrap p. 29, in expected order.

---

## CRITICAL (0)

None.

---

## MAJOR (1)

### MAJ-1 — Text↔table inconsistency on outlier ladder coverage (Phase 1.5-introduced)

**Location:** `paper/en/main.tex:396` (in the "Outlier-sensitivity ladder" paragraph)
**Issue:** Paragraph asserts "Analogous outlier-ladder tables for the other three primary outcomes are available in the replication package." The `\input{}` at line 398 actually embeds all four outcome tables (op_cost + off_farm_income + consumption + farm_income; verified at `scripts/R/_outputs_symmetric/tab_rob_outlier_en.tex:34–130`).
**Why MAJOR not MINOR:** This is a direct text vs. artifact contradiction — a `/audit-reproducibility` style auditor would flag it, and an AJAE referee reading the paragraph would expect to flip to an appendix that doesn't exist (because the tables are already on the page).
**Fix (one-line):** Replace "available in the replication package" with "reported in the four outcome panels of Table~\ref{tab:rob_outlier_op_cost_en} et seq.; sign and significance are stable across IHS, Winsor p1/p99, and Winsor p0.5/p99.5 for op_cost and consumption, with off_farm_income and farm_income near zero under both transformations."

---

## MINOR (4)

### MIN-1 — §7 roadmap sentence still missing
**Location:** `paper/en/main.tex:384` (blank line at §7 head)
**Fix:** Insert the 5-block roadmap proposed in rubric (4) above.
**Stage-blocking:** 90 (advisory at 80; recommended before AJAE submission).

### MIN-2 — Wild bootstrap Panel A: 38.34pt overfull hbox
**Location:** `tab_wild_bootstrap_en.tex` lines 6–19 (7-column tabular).
**Fix options:** (i) `\resizebox{\textwidth}{!}{\begin{tabular}...\end{tabular}}` wrapper; (ii) drop `p_wild_holm` from Panel A (Holm-adjusted column is informative but the same information is implicit when p_wild × 4 outcomes < .10); (iii) shorten "Outcome" labels.
**Stage-blocking:** 90 (overfull > 10pt per beamer/manuscript rubric line; AJAE typesetting will catch it).

### MIN-3 — Wild bootstrap "agree within ±.01" claim vs. one outlier cell
**Location:** `paper/en/main.tex:400` claims wild-bootstrap p-values "agree with the cluster-robust analytic p-values within ±.01 on every cell."
**Issue:** Panel B row 4 (op_cost_ex_rent T1, line 28 of `tab_wild_bootstrap_en.tex`) reports p_cluster = .1051 vs. p_wild = .0410 — a 0.064 gap, on the publication-relevant α = .05 / α = .10 boundary (wild bootstrap *crosses* α = .05; analytic does not even cross α = .10). The "±.01 agreement" claim is contradicted by this single cell, which is the very headline op_cost_ex_rent T1 cell the paper relies on.
**Fix:** Rewrite as "wild-bootstrap and analytic p-values agree within ±.01 on 13 of 14 cells; the one exception is op_cost_ex_rent at T1 (p_cluster = .105, p_wild = .041), where the small-cluster wild bootstrap produces a more aggressive rejection consistent with [the size correction in Cameron–Gelbach–Miller 2008 for $G < 30$ clusters / the heterogeneity in residual variance across the cutoff]. We report both for transparency; the headline reading does not change because the cross-bin gradient and not the pooled-cell p-value is load-bearing."
**Stage-blocking:** 90 (numeric claim inconsistent with embedded table — referee will catch it).

### MIN-4 — McCrary narrow-window candor (carried from M3, unchanged)
**Location:** `paper/en/main.tex:385`
**Recommended (not required) rewrite:** see rubric (3) above. Current text is defensible; the rewrite would buy 0.1–0.2 of score and is a Phase 2 polish item.
**Stage-blocking:** 95 (R&R).

---

## Referee-objection preemption matrix

| Likely referee objection | §7 preemption present? | Strength | Notes |
|---|---|---|---|
| "Pre-trends only certified on a single pre-period (Roth 2022)" | **Yes** (lines 413–415, HonestDiD §) | Strong | Reframe is honest about $\bar M^* = 0$ and pivots to cross-bin gradient identification. |
| "McCrary narrow-window $p \approx .07$ is a manipulation signal" | **Yes** (line 385) | Moderate | Soft-pedal is defensible but the rewrite proposed in MIN-4 would close the door. |
| "Outlier sensitivity not shown for non-headline outcomes" | **Now yes** (Phase 1.5 added all 4 outcome tables) | Strong | But fix MAJ-1 paragraph wording. |
| "Cluster-robust inference too small (G < 30)" | **Yes** (line 400, wild cluster bootstrap) | Strong with caveat | Fix MIN-3 about the one cell where wild ≠ analytic. |
| "Treatment-definition choice (3-criterion D vs. area-only) drives results" | **Yes** (lines 444–446 + Figure 4) | Strong | Forest plot + 39% median shift is candidly reported; conclusion preserved. |
| "Symmetric screening throws out 644 controls" | **Yes** (line 432 dropped-balance + line 448 asymmetric variant) | Strong | Both subsamples reported; the dropped-balance table identifies the wealth/income asymmetry. |
| "Province-level confounders not absorbed" | **Yes** (line 452, sido × year FE) | Strong | 12.1% median shift, no sign flips. |
| "Placebo cutoffs: any spurious discontinuities?" | **Yes** (line 440) | Strong | 3/32 at p < .10 ≈ expected; Bonferroni-clean. |
| "Differential attrition across the cutoff" | **Yes** (lines 394 + 436) | Strong | All bandwidths p > .4. |
| "Implementation-year (2020) drives the result" | **Yes** (line 424, Spec B) | Strong | Sign preserved when 2020 dropped. |
| "Strata heterogeneity (farm type, cohort) drives the result" | **Yes** (line 428, Spec C) | Strong | Sign and magnitude preserved/strengthened. |

**Net:** 11/11 anticipated referee objections have an in-§7 preemption; 2 of them (MCC narrow window candor; wild bootstrap one-cell discrepancy) need ≤2-sentence tightening to be airtight.

---

## Summary

Phase 1.5 cleared the two structural MAJORs (M1/M2 embedding) and refactored HonestDiD into a defensible reframe. The §7 architecture now passes a Lens-5 referee preemption sweep on 11/11 anticipated objections. The score moves from 8.6 to **9.0**, with the remaining gap to 9.5 driven by (i) one self-introduced text↔table inconsistency (MAJ-1), (ii) a missing 1-sentence roadmap at §7 head, (iii) one overfull hbox in the new wild-bootstrap table, and (iv) the long-standing soft-pedal on McCrary narrow-window p ≈ .07.

**Recommendation:** Fix MAJ-1 and MIN-3 before AJAE submission (both are direct text↔artifact contradictions that an automated audit would flag). MIN-1 (roadmap) and MIN-2 (overfull) are Phase 2 polish but ≤30 minutes each. MIN-4 (McCrary candor) is R&R-stage polish.
