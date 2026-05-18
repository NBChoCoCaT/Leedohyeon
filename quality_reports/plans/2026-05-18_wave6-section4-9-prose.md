# Wave 6 — §4 + §5 + §7 + §8 + §9 STUB → real prose (Option A + B bundle)

**Date:** 2026-05-18
**Branch:** `feat/wave6-stubs-to-prose` (new, off `main` @ `6c0f1aa` post-Wave-5 merge)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 7–10 h (Option A + B bundle estimate)

---

## Context

Wave 1–5 closed all 14 of 14 CRITICAL from the 7-pass synthesis and delivered §3 (theory) + §5 Results (Wave 5: F1 NOT FIRED, AHM separability REJECTED). The remaining 5 STUB sections (§4 Data, §5 Identification Strategy, §7 Robustness, §8 Discussion, §9 Conclusion) prevent the manuscript from being submission-ready prose-complete. Wave 6 converts all 5 STUBs to publication-grade prose, leveraging the **~30 pre-existing `.tex` tables and ~24 figures** in `scripts/R/_outputs/` from prior P3b/P3c analysis cycles. **§2 Institutional Context is out of scope** (separate "B+"-extension; user can run independently).

**Post-Wave-6 expected state:** quality_score ≈95/100 (excellence threshold), all sections prose-complete, AJAE first-submission-ready (pending only the pre-submission proof-reading pass — Option C in Wave 7+ track).

---

## The 5 STUB sections + scope

| § | Section | Current state | Wave 6 deliverable |
|---|---------|---------------|--------------------|
| **§4** | Data | STUB + Wave-3 attrition para | Variable construction + sample restrictions + Table 1 descriptives + take-up + hired-labor descriptives |
| **§5** | Identification Strategy | STUB (1-sentence summary) | DiD-RD spec equation + running variable + 3 bandwidths + cluster choice + Wild bootstrap + tenancy interaction + cross-ref to SC1-SC5+SC2.5 |
| **§7** | Robustness | STUB (5-item list) | McCrary density + outlier ladder + Wild cluster bootstrap 14-cell + event-study parallel-trends figures + HonestDiD M̄ + differential-attrition + Spec B alternative |
| **§8** | Discussion | TODO placeholder | 5 paragraphs: policy implications + Kirwan/Baldoni-Ciaian contrast + Korean context + LaFave-Thomas complement + limitations |
| **§9** | Conclusion | STUB (3-para outline) | 3 paragraphs per existing outline: what learned + why 0.5 ha cutoff + future work |

---

## Critical files to modify

| File | Action |
|------|--------|
| `paper/en/main.tex` | §4 STUB → prose (~25 lines); §5 STUB → prose (~20 lines + DiD-RD equation); §7 STUB → prose (~30 lines + 3 figure embeds + 2 table `\input{}`); §8 STUB → prose (5 paragraphs, ~30 lines); §9 STUB → prose (3 paragraphs, ~15 lines) |
| `paper/en/online_appendix.tex` | UNTOUCHED (Wave 6 is main-text only; §B.4 HonestDiD detail deferred to Wave 7+) |
| `Bibliography_base.bib` | +2-3 entries: possibly Solon-Haider-Wooldridge 2015 JHR (weighting), Stock-Yogo 2005 (weak-instruments — actually not needed here), Roodman 2019 boottest (cited for wild cluster bootstrap). Verify needs during Phase 2-3. |
| `paper/ko/` | UNTOUCHED (CLAUDE.md bilingual rule) |

**Inputs (all pre-existing, no new estimation):**
- `scripts/R/_outputs/tab_descriptives_en.tex` (§4 Table 1)
- `scripts/R/_outputs/tab_rob_outlier_en.tex` (§7 outlier ladder)
- `scripts/R/_outputs/tab_wild_bootstrap_en.tex` (§7 14-cell bootstrap)
- `scripts/R/_outputs/tab_specB.tex` (§7 alternative spec)
- `scripts/R/_outputs/fig_event_study_*_T2_en.pdf` (§7 event-study; pick area_own/op_cost)
- `scripts/R/_outputs/fig_mccrary_density_full_en.pdf` (§7 McCrary visual)
- `scripts/R/_outputs/fig_honestdid_sensitivity_b1_en.pdf` (§7 HonestDiD; created in Wave 5)
- `scripts/R/_outputs/alpha3_results.rds` for inline numbers (Wave 5)
- `scripts/R/_outputs/mccrary_test.rds` for +0.7pp number
- `scripts/R/_outputs/main_results.rds` for replication-check magnitudes

---

## Implementation order

### Phase 1 — §4 Data build-out (~1.5 h)

Replace L290–298 STUB with structured prose:

**¶1 (Data source + panel structure):** "Our data come from the Farm Household Economic Survey (FHES) Wave 1, a Statistics Korea rolling panel of farm households surveyed annually 2018–2022 ($N = 3{,}614$ unique farms across $14{,}474$ farm-years). The Wave 1 design samples..." (cite FHES sampling methodology; reference MDIS footnote already in place).

**¶2 (Variable construction):** Itemize key variables following `r-code-conventions.md` §10 FHES naming:
- Running variable: $rv_{2018,i} = A_{2018,i} - 5{,}000$ m² (2018-baseline cultivated area centered at cutoff)
- Treatment: $D_i = \mathbf{1}\{rv_{2018,i} \le 0\}$, fixed at 2018 baseline (manipulation-proof)
- Post-period: $\text{Post}_t = \mathbf{1}\{\text{year} \ge 2020\}$
- Primary outcomes: $A_{own,i,t}$ (own-cultivated area, m²); $\text{op\_cost\_ex\_rent}_{i,t}$ (operating cost net of rent, KRW); $\text{off\_farm\_income}_{i,t}$ (auxiliary, KRW); $\text{unit\_rent\_price}_{i,t}$ (ex-theory, KRW/m²)
- Baseline tenancy: $s_{0,i} = A_{own,2018,i}/A_{2018,i}$, 5-bin partition
- Weight: `weight_national` (population representativeness; Solon-Haider-Wooldridge 2015 stage rule)

**¶3 (Sample restrictions + descriptive statistics):** Reference Table~\ref{tab:descriptives} (input from `tab_descriptives_en.tex`). Note 14,474 farm-years from 3,614 farms (61% with full 5-year panel; attrition decomposition per Wave 3 ¶ that follows below).

**¶4 (Existing attrition para):** Preserved verbatim from Wave 3 (W5-3 attrition placebo result also referenced).

**¶5 (Take-up + hired-labor closing):** Cross-reference §3.4.1 "Sample-margin cross-references" para (Wave 5 fill). Brief one-sentence reference.

```latex
\begin{table}[ht]
\centering
\caption{Descriptive statistics for Farm Household Economic Survey (FHES) Wave 1 panel, 2018--2022. Weighted means via population sampling weights (Solon-Haider-Wooldridge 2015 stage rule for Table~1).}
\label{tab:descriptives}
\input{../../scripts/R/_outputs/tab_descriptives_en.tex}
\end{table}
```

### Phase 2 — §5 Identification Strategy (~1.5 h)

Replace L301–305 STUB with structured prose + equation block:

**¶1 (Design overview):** "We exploit the 0.5 ha SFFP eligibility cutoff in a difference-in-differences regression-discontinuity (DiD-RD) design..." (link to §3.1 Estimand paragraph for X8/X9 anticipation+McCrary disclosure preserved).

**¶2 (DiD-RD specification equation):**
```latex
\begin{equation}
Y_{i,t} \;=\; \alpha + \beta_k\, D_i \cdot \text{Post}_t + \delta\, D_i + \gamma\, \text{Post}_t + f(rv_{2018,i}) + \mathbf{x}_{i,t}'\boldsymbol\theta + \varepsilon_{i,t},
\label{eq:didrd-main}
\end{equation}
```
where $f(rv_{2018,i})$ is a local-linear polynomial in the running variable, $\mathbf{x}_{i,t}$ are pre-period covariates (farm type, age, education), and $\beta_k$ is the DiD-RD coefficient on outcome $k$.

**¶3 (Bandwidths):** Three-tier reporting per CLAUDE.md identification §: T1 ($h = 500$ m²), T2 ($h = 1{,}000$ m²), T3 (MSE-optimal per `\citet{CalonicoCattaneoTitiunik2014_rdrobust}`). Trade-off: T1 = sharp marginal-window signal, T3 = full statistical power.

**¶4 (Heterogeneity / F1):** 5-bin baseline-tenancy interaction:
```latex
Y_{i,t} = \alpha + \sum_{b \in \{tenant, low, mid, high, owner\}} \beta_{k,b}\, D_i \cdot \text{Post}_t \cdot \mathbf{1}[b(i) = b] + \ldots
```
with the F1 trigger applied to monotone-decreasing $\hat\beta_{1,b}$ across $b$ (Wave 1 X1 strict-AND boolean).

**¶5 (Inference):** Cluster-robust at $hh_id$ (primary; `\citet{CameronGelbachMiller2008_clusterboot}` wild bootstrap with $B = 9{,}999$) and $sgg\_cd$ (sub-district robustness). Holm step-down correction across primary outcome family.

**¶6 (Identifying assumptions cross-ref):** Online Appendix B.1 SC1–SC5 + SC2.5 (Wave 2 X4 + X5).

### Phase 3 — §7 Robustness (~2 h)

Replace L332–336 STUB with 6-paragraph structure + 3 figure embeds + 2 table `\input{}`:

**¶1 (McCrary density continuity):** "We verify continuity of the running-variable density at the cutoff via the `\citet{McCrary2008_density}` density-discontinuity test (Wave 2 X9 framework). The estimated discontinuity is $\hat\Delta = +0.7$pp (95% CI: $[-0.5, +1.9]$, well within the $\pm 2$pp threshold). Figure~\ref{fig:mccrary} visualizes."

```latex
\begin{figure}[ht]
\includegraphics[width=0.85\textwidth]{../../scripts/R/_outputs/fig_mccrary_density_full_en.pdf}
\caption{McCrary 2008 density-discontinuity test at the 0.5 ha cutoff. Discontinuity estimate $\hat\Delta = +0.7$pp ($p > .10$). No evidence of running-variable manipulation; the frozen 2018-baseline construction rules out endogenous post-period sorting by design.}
\label{fig:mccrary}
\end{figure}
```

**¶2 (Differential-attrition placebo, Wave 5 W5-6):** Estimate $-0.10$, $p = .34$; no cross-cutoff differential attrition.

**¶3 (Outlier ladder, table input):** Table~\ref{tab:rob-outlier}.
```latex
\begin{table}[ht]
\caption{Outlier-sensitivity ladder: raw / IHS-transformed / Winsorized at p1/p99 and p0.5/p99.5. Sign and significance of $\hat\beta_1$ stable across specifications.}
\label{tab:rob-outlier}
\input{../../scripts/R/_outputs/tab_rob_outlier_en.tex}
\end{table}
```

**¶4 (Wild cluster bootstrap, table input):** Table~\ref{tab:wild-boot} — 14-cell wild cluster bootstrap on headline estimates, $B = 9{,}999$ Rademacher refits per cell.
```latex
\input{../../scripts/R/_outputs/tab_wild_bootstrap_en.tex}
```

**¶5 (Event-study parallel-trends):** Visual pre-trend test. Figure~\ref{fig:event-study-area-T2} shows area_own event-study at T2; the 2018 pre-period coefficient is statistically zero ($|t| < 1$), satisfying the LN-10 parallel-trends gate.

```latex
\begin{figure}[ht]
\includegraphics[width=0.85\textwidth]{../../scripts/R/_outputs/fig_event_study_area_T2_en.pdf}
\caption{Event-study estimates of $A_{own}$ around the 2020-05-01 PIDPS implementation date. Pre-period (2018) coefficient statistically zero, confirming parallel-trends gate.}
\label{fig:event-study-area-T2}
\end{figure}
```

**¶6 (HonestDiD sensitivity, Wave 5 W5-5):** Figure~\ref{fig:honestdid} — Rambachan-Roth M̄ bounds. The breakdown M̄ for $\hat\beta_1$ at which the 95% CI begins to include zero is reported alongside.
```latex
\begin{figure}[ht]
\includegraphics[width=0.85\textwidth]{../../scripts/R/_outputs/fig_honestdid_sensitivity_b1_en.pdf}
\caption{HonestDiD M̄ sensitivity bounds on $\hat\beta_1$ (area_own, T2) per \citet{RambachanRoth2023_honestdid}. Vertical reference line at M̄ = 0 (original DiD); breakdown M̄* indicates the linear-trend bias magnitude beyond which the 95% CI ceases to exclude zero.}
\label{fig:honestdid}
\end{figure}
```

**¶7 (Spec B alternative):** Brief cross-ref to `\input{tab_specB.tex}` — Spec B (alternative covariate set) results consistent with Spec A across all four primary outcomes.

### Phase 4 — §8 Discussion (~1.5 h)

Replace L339–351 TODO with 5-paragraph prose:

**¶1 (Policy implications):** SFFP's per-farm flat-rate design shifts smallholder land tenure away from rental toward ownership at the 0.5 ha cutoff. The +1,089 m² pure-tenant own-area response is ≈22% of the 0.5 ha threshold — a substantively meaningful land-tenure shift induced by a 1.2 M KRW annual transfer. The negative −4.18 M KRW operating-cost response at T1 confirms the (S,s) inaction-band channel: the transfer is too small to trigger discrete capital adjustment, so households absorb it on variable margins.

**¶2 (Kirwan / Baldoni-Ciaian contrast):** Our −11.1% rent pass-through reverses the +25% / +46–55% capitalization observed in US (Kirwan 2009) and EU (Baldoni-Ciaian 2023) area-proportional designs. The per-farm flat-rate mechanism is what eliminates landlord rent extraction: SFFP eligibility creates a binary household-level transfer, not a marginal per-hectare subsidy that landlords can capture via rent renegotiation. This is the AJAE-grade structural contribution: design-driven incidence reversal at a sharply identified cutoff.

**¶3 (Korean context):** Korean smallholders (≤ 0.5 ha) are aging (mean age ~67), predominantly paddy-rice (~85% of cultivated area), and concentrated in the southwestern provinces. The 92.3% administrative-receipt rate among eligible households reflects high policy salience (Wave 5 W5-7); the AHM-extension test identifies the marginal land-tenure responses among the credit-constrained smallholder cohort that constitute ~52% of treated households.

**¶4 (LaFave-Thomas 2016 complement):** Our setting bridges the developed/developing-country divide in the separability-test literature. LaFave-Thomas reject separability in Indonesia via demographic instruments; we reject separability in Korea (a high-income developed-country setting) via a sharp policy cutoff. The shared reading — separability fails when credit, land, or labor markets are incomplete at the smallholder margin — is robust across both identification strategies.

**¶5 (Limitations):** Single pre-period (2018→2019) limits parallel-trends inference; HonestDiD M̄ bounds (Wave 5) quantify the sensitivity. FHES Wave 1 panel restricts the analysis window; Wave 2 (post-2023) link is forthcoming. F2 supervision-channel coefficient is statistically near-zero (consistent with EK-1 sign indeterminacy but not interpretable as a clean rejection). The 0.5 ha cutoff is institutionally unique; external validity to other Korean policy thresholds or other Asian smallholder contexts requires separate study.

### Phase 5 — §9 Conclusion (~1 h)

Replace L354–358 STUB with 3-paragraph prose following the existing outline:

**¶1 (What we learned):** AHM separability is rejected for Korean small farms at the 0.5 ha SFFP cutoff via the wealth-biased liquidity channel (Carter-Olinto 2003). The +1,089 m² pure-tenant own-area response and the monotone four-bin tenancy gradient (1089 / 410 / 393 / -101 / 0 at T2) uniquely identify the wealth-bias signature. The −4.18 M KRW operating-cost response at T1 confirms the (S,s) inaction-band sub-prediction. The −11.1% rent pass-through, ex-theory aggregate-equilibrium implication, reverses the +25–55% landlord capitalization observed under area-proportional designs.

**¶2 (Why 0.5 ha cutoff matters):** Policy-induced identification at a sharp eligibility cutoff cleanly separates the treatment from confounders that demographic instruments (LaFave-Thomas 2016) cannot. The 2018-baseline freeze eliminates manipulation; the per-farm flat-rate design eliminates landlord rent extraction. The result generalizes the separability-test literature to a developed-country smallholder setting with sharp ITT identification.

**¶3 (Future work):** Four extensions: (i) Korean-context magnitude of $\hat\beta_4$ supervision channel under richer labor-market data (FHES Wave 2 linkage); (ii) dynamic extension of Carter-Olinto threshold rule (multi-period asset accumulation); (iii) paper/ko translation for KAEA + 한국농경제학회 conference circulation; (iv) cross-cutoff replication if Korea introduces a second per-farm flat-rate threshold (e.g., at 1.0 ha).

### Phase 6 — Verification (~30 min)

1. **Compile main.tex:** `cd paper/en && latexmk -xelatex main.tex` → 35±3 p PDF (was 25 p, +10 from 5 STUB → prose), no Korean glyph warnings, no new undefined cites.
2. **All `\input{}` paths resolve:** verify `../../scripts/R/_outputs/tab_descriptives_en.tex` etc. resolve.
3. **All `\includegraphics` paths resolve:** McCrary density, event-study area T2, HonestDiD sensitivity.
4. **quality_score.py main.tex:** ≥ 90 (expect ~92–95 post-Wave-6).
5. **paper/ko 0-diff** vs main.
6. **No undefined references:** Table~\ref{tab:descriptives}, Figure~\ref{fig:mccrary}, etc. all resolve.

### Phase 7 — Commit + PR (~15 min)

`/commit` skill: stage main.tex + plan + (possibly bib if cites added) → quality_score gate → gh pr create against main with Wave 6 body. Manual approval before merge.

---

## Decisions locked (pre-implementation)

**Q1 — §7 figure count:** **3 figures** embedded in main text (McCrary density + event-study area_own T2 + HonestDiD). Other event-studies (op_cost, farm_income, consumption × T1/T2/T3) remain available in `_outputs/` for online supplement / pre-submission expansion.

**Q2 — §8 Discussion length:** **5 paragraphs** as outlined (policy / contrast / Korean context / LaFave-Thomas complement / limitations). Tight enough to fit AJAE convention, comprehensive enough to set up referee response.

**Q3 — §5 Identification equation block:** **Include explicit DiD-RD equation** (`eq:didrd-main`) for unambiguous spec reference. Wave 7+ pre-submission polish can refine notation.

**Q4 — §2 Institutional Context STUB:** **OUT OF SCOPE.** Wave 6 covers A+B only; §2 is a separate B+ deliverable (~1h) the user can run independently.

**Q5 — Bibliography additions:** Likely zero or minimal (most needed cites already in Bibliography_base.bib after Waves 1–5). Verify during Phase 2-3; flag any needed cites with `% VERIFY-PRE-SUBMIT`.

**Q6 — paper/ko sync:** **DEFERRED** (CLAUDE.md bilingual rule). Wave 6 is paper/en canonical; ko re-sync is the user-recommended Option D for a separate session.

**Q7 — Pre-α3 tables repurpose:** The `tab_ch3_*`, `tab_ch4_*`, `tab_ch5_*` tables in `_outputs/` are from the pre-α3 three-channel framing. **SKIP** for Wave 6 — they don't fit the α3 outcome hierarchy. Wave 7+ can consider regenerating analogous tables under α3 framing if needed.

---

## Verification (end-to-end)

1. **Compile:** main.tex 35±3 p (was 25 p; +10 from 5 STUB → prose); online_appendix.tex 9 p (untouched); both XeLaTeX exit 0; no Korean glyph warnings; no new undefined citations.
2. **quality_score.py main.tex:** ≥ 90; expect 92–95 (full §7 robustness + §8 + §9 prose should retire ~5 critical findings from pre-existing TODO placeholders).
3. **`\input{}` resolution:** all 3+ table inputs resolve cleanly.
4. **`\includegraphics{}` resolution:** all 3 figure embeds resolve.
5. **Cross-reference validity:** Table~\ref{tab:descriptives}, Figure~\ref{fig:mccrary}, Figure~\ref{fig:event-study-area-T2}, Figure~\ref{fig:honestdid}, Equation~\ref{eq:didrd-main} all defined.
6. **Magnitude consistency:** §4 + §5 + §7 + §8 + §9 cross-reference the Wave 5 W5-1..W5-7 numbers (+1,089, −4.18M, −11.1%, +0.7pp McCrary, etc.) exactly.
7. **paper/ko 0-diff** vs main.
8. **F1 + UNHEDGE consistency:** §5 + §7 + §8 + §9 all consistent with the Wave 5 F1-not-fired + AHM-rejection narrative; no stale hedge language anywhere.

---

## Out of scope (deferred to Wave 7+)

- **§2 Institutional Context** STUB → prose (~1h, B+ extension)
- **paper/ko re-sync** from canonical paper/en (Option D, ~3-4h)
- **Pre-submission proof-reading pass** (Option C: 9 `% VERIFY-PRE-SUBMIT` bib audit + ~25 long-sentence copyedit + L186 boxed-eq polish, ~2-3h)
- **2nd `/seven-pass-review` confirmation** (Option E, ~1-1.5h; optional)
- **F2 5-bin methodology reconciliation** (Option F, ~1h; fixest DiD-RD spec for off_farm_income to match the canonical pooled approach)
- **STATA cross-check expansion** for W5-3/W5-5/W5-6 cells (Option G, ~2h)
- **Online Appendix B.4** dedicated HonestDiD detail section (if Phase 3 main-text §7 reference is felt to need supplementary appendix)
- **§5/§7/§8/§9 figures in Korean** (`*_ko.{pdf,png}` already exist in `_outputs/`; will be used in paper/ko re-sync)

---

## Expected post-Wave-6 status

| Metric | Pre-Wave-6 | Post-Wave-6 | Δ |
|---|---|---|---|
| 7-pass composite | ≈9.3 / 10 | **≈9.4–9.5 / 10** | +0.1–0.2 |
| quality_score.py | 90 / 100 | **92–95 / 100** | +2–5 |
| STUB sections | 6 of 9 (§2, §4, §5, §7, §8, §9) | **1 of 9** (§2 only) | −5 |
| Paper page count | 25 p | **35±3 p** | +10 |
| AJAE submission-readiness | crossed | **prose-complete (pending §2 + Option C polish)** | mature |

Wave 6 brings the manuscript to **prose-complete state**. Wave 7+ track focuses on §2 Institutional Context + Option C/D/E final polish before AJAE submission.
