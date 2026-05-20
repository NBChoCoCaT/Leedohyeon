# Lens 5 — Robustness (Seven-Pass Review #4, Post-Phase-1.5b)

**Manuscript:** `paper/en/main.tex`
**Date:** 2026-05-20
**Baseline:** Post-Phase-1.5 score = 9.0/10 (open items: M1 outlier text↔table contradiction; MINOR-3 ±.01 wild-bootstrap precision claim; roadmap sentence missing at §7 head).

---

## 1. Phase 1.5b Closure Audit

### P2 — Outlier-ladder text ↔ table consistency (was MAJOR)

**Old text (Phase 1.5):** "Analogous outlier-ladder tables for the other three primary outcomes are available in the replication package."

**New text (L396):**
> "Table~\ref{tab:rob_outlier_op_cost_en} reports the main DiD-RD coefficient on the headline operating-cost outcome under four outlier-treatment regimes: raw values, inverse-hyperbolic-sine (IHS) transformation, Winsorization at the 1st/99th percentiles, and Winsorization at the 0.5th/99.5th percentiles. The sign and significance of the headline estimate are stable across all four treatments, ruling out outlier-driven inference. **The same outlier-treatment ladder is reported for off-farm income, consumption, and farm income in the same `\input{}` block; the headline-stability conclusion holds across all four primary outcomes.**"

**Embedded table:** `\input{../../scripts/R/_outputs_symmetric/tab_rob_outlier_en.tex}` (single block at L398).

**Assessment:**
- The text now correctly states that the ladder is reported for all four outcomes inside the SAME `\input{}` block (previously the text said tables were "available in the replication package" while the embedded table actually printed all four — a direct text↔table contradiction).
- Mention of the file mechanism (`\input{}` block) is honest and reader-verifiable.
- The hedge "headline-stability conclusion holds" is appropriate (still op_cost is the explicit headline; the other three are framed as supporting).
- **CLOSED.** No residual contradiction.

### MINOR-3 — Wild bootstrap "±.01" precision claim (was MINOR)

**Old text (Phase 1.5):** "agree with the cluster-robust analytic p-values within ±.01"

**New text (L400):**
> "Wild bootstrap p-values agree with the cluster-robust analytic p-values within **±.07 across the 14 cells, with the largest gap on op\_cost\_ex\_rent at T1 (analytic $p_{\text{cluster}} = .105$ vs.\ wild $p_{\text{wild}} = .041$, straddling the $\alpha = .05$ threshold).**"

**Verification against `tab_wild_bootstrap_en.tex` (cell-by-cell |p_cluster − p_wild|):**

| Spec | Outcome | Bw | p_cluster | p_wild | |gap| |
|------|---------|-----|-----------|--------|------|
| A | op_cost | h^A_min | 0.6675 | 0.6927 | 0.0252 |
| A | off_farm_income | h^A_min | 0.7137 | 0.7207 | 0.0070 |
| A | consumption | h^A_min | 0.0937 | 0.0811 | 0.0126 |
| A | farm_income | h^A_min | 0.3444 | 0.3744 | 0.0300 |
| B | op_cost | h^B_min | 0.7581 | 0.7788 | 0.0207 |
| B | off_farm_income | h^B_min | 0.5698 | 0.5786 | 0.0088 |
| B | consumption | h^B_min | 0.2318 | 0.2232 | 0.0086 |
| B | farm_income | h^B_min | 0.3262 | 0.3554 | 0.0292 |
| A | rent_cost | T1 | 0.0959 | 0.1141 | 0.0182 |
| A | rent_cost | T2 | 0.1636 | 0.1602 | 0.0034 |
| A | rent_cost | T3 | 0.8060 | 0.8108 | 0.0048 |
| A | op_cost_ex_rent | T1 | 0.1051 | 0.0410 | **0.0641** |
| A | op_cost_ex_rent | T2 | 0.1807 | 0.2162 | 0.0355 |
| A | op_cost_ex_rent | T3 | 0.6512 | 0.6707 | 0.0195 |

- **Max gap = 0.0641** at op_cost_ex_rent T1 → bounded by the claimed ±.07 (verified).
- The cited numerals (analytic .105, wild .041) match the table exactly (.1051 → .105 rounded; .0410 → .041 exactly).
- Honest disclosure that this cell **straddles α = .05** is exactly the right framing — this is the only cell where the inference type matters for headline interpretation, and the manuscript continues to flag it as such (L400 closing sentence: "the replication-release stage will resolve the op_cost_ex_rent T1 cell at B = 9,999").
- **CLOSED.** Claim is verifiable, tight, and honest.

### Roadmap sentence at §7 head

**Status:** Still missing.

§7 opens directly with `\paragraph{Cutoff-density continuity (McCrary 2008).}` at L385 with no introductory roadmap (L383–384 are empty after the section header).

The section currently runs through 12 distinct robustness items (McCrary → attrition placebo → outlier ladder → wild cluster bootstrap → event study → HonestDiD → Spec B → Spec C → dropped-balance → attrition across bandwidths → placebo cutoffs → area-only justification → area-only robustness → asymmetric-sample). A reader has no map of what's coming, which is heavy lift for AJAE referees who often skim §7.

**Severity:** MINOR (Phase 2 polish). Not blocking; recommended for first-submission polish (90-tier).

---

## 2. Robustness Section Substantive Check

Reading §7 end-to-end:

- **McCrary continuity (L385–392):** Frozen-2018 baseline rationale + narrow-window honesty (.064/.076 disclosed). Strong.
- **Attrition placebo (L394, 436–438):** Reported across all three bandwidths in the dedicated table; numbers in text (.754/.460/.410) match the embedded Table~\ref{tab:attrition-placebo-full}. Strong.
- **Outlier ladder (L396–398):** Post-P2 fix is clean.
- **Wild bootstrap (L400–402):** Post-MINOR-3 fix is clean.
- **Event study (L404–411):** LN-10 gate satisfied (|t|<1 in 2018); load-bearing 2020 discontinuity figure shown.
- **HonestDiD (L413–422):** Honest disclosure that $\bar M^* = 0$ for the pooled event-study spec; the manuscript correctly argues this is a property of the single-pre-period pooled spec rather than evidence against the F1 cross-bin gradient. The reframing (load-bearing identification is the heterogeneity gradient, not the magnitude of any single bin) is well-articulated and theoretically sound. This is one of the cleaner HonestDiD discussions I've seen in DiD-RD work — explicitly cites \citet{Roth2022_pretrends} on single-pre-period limitations.
- **Spec B (L424–426) and Spec C (L428–430):** Both preserve sign of op_cost_ex_rent across narrow bandwidths; Spec C is slightly *larger* than Spec A (consistent with reading that het-controls strengthen the (S,s) result).
- **Dropped-194 balance (L432–434):** Direct response to the symmetric-screening selection concern — dropped HHs differ on exactly the variables eligibility rule targets and not on `own_share` or `area_own`. Defensible.
- **Placebo cutoffs (L440–442):** 32 cells, 3 reach p<.10 (vs 3.2 expected under null), 1 reaches p<.05 (vs 1.6 expected) — honest reading of the null. Bonferroni-cleared headline survives.
- **Area-only (L444–446):** Wave-7 promotion rationale + 24-cell comparison + median 39% shift. Clean.
- **Asymmetric-sample (L448):** Direct disclosure of the intermediate design + reasons for not preferring it. Clean.

**Observed robustness density:** Heavy (12 robustness items). For AJAE this is appropriate; for Food Policy might want to thin and push 3-4 items to online appendix. Not a defect; flagging for journal-fit awareness.

**Internal cross-references:** All `\ref{tab:...}` and `\ref{fig:...}` calls in §7 resolve to embedded tables/figures (or to the online appendix where called out).

---

## 3. Residual Issues

| ID | Severity | Issue | Recommendation |
|----|----------|-------|----------------|
| Phase-2-R1 | MINOR | §7 has no opening roadmap sentence | Add 1–2 sentence preview enumerating the 12 robustness items grouped by category (identification placebos / specification variants / treatment-definition variants) |
| Phase-2-R2 | MINOR | Spec B and Spec C are introduced without forward-reference from §6 (results); a reader meeting "Spec B" / "Spec C" for the first time in §7 must rely on context | Add forward-reference in §6 (e.g., "we report Spec A as the headline; Spec B and Spec C robustness variants are deferred to \S\ref{sec:robustness}") |
| Phase-2-R3 | NIT | Wild bootstrap caption says "(B=999, Rademacher)" — the manuscript text now correctly flags op_cost_ex_rent T1 as straddling .05, but the caption itself is silent on inference-type sensitivity | Consider adding 1-line caption note: "* p<.10 in cluster-robust analytic inference does not equal * p<.10 in wild bootstrap inference for the op_cost_ex_rent T1 cell." |

None of these are blocking. P2 and MINOR-3 are fully closed.

---

## 4. Score

| Component | Score | Notes |
|-----------|-------|-------|
| Identification placebos (McCrary, attrition, cutoff placebos) | 9.5/10 | Multiple bandwidths, frozen baseline, honest narrow-window disclosure |
| Outlier sensitivity | 9.5/10 | Post-P2 text↔table consistent across all 4 outcomes |
| Inference robustness (wild bootstrap, Holm) | 9.5/10 | Post-MINOR-3 ±.07 claim verifiable to ±.0009; op_cost_ex_rent T1 straddle honestly flagged |
| Specification variants (Spec B, Spec C) | 9.0/10 | Direction preserved; Spec C strengthens, not weakens, the result |
| Treatment-definition robustness (area-only, asymmetric) | 9.0/10 | Side-by-side comparison + rationale for symmetric main choice |
| Section organization | 8.0/10 | Roadmap sentence still missing; 12 items presented as flat sequence rather than grouped |
| Honest disclosure (HonestDiD, McCrary narrow windows, op_cost_ex_rent T1 straddle) | 10/10 | This is the strongest aspect — manuscript voluntarily flags weaknesses without hedging the headline |

**Lens 5 score: 9.3/10**
**Δ from post-Phase-1.5 baseline (9.0): +0.3**

**Justification for +0.3:**
- P2 closure is materially significant — the prior text↔table contradiction was a direct credibility issue that referees would flag immediately. Now resolved (+0.2).
- MINOR-3 closure converts an inaccurate quantitative claim into a verifiable, honest one with a load-bearing caveat (op_cost_ex_rent T1 inference-type sensitivity) explicitly flagged. This is the kind of disclosure that builds referee trust (+0.1).
- The missing roadmap sentence prevents 9.5+ (−0.2).

**Target maintained:** ≥ 9.0 ✓

---

## 5. Recommendation for Phase 2

Single highest-leverage edit in §7:

Insert at L384 (immediately after `\label{sec:robustness}`):

```
We organize the robustness analysis into three groups: (i) identification placebos
that probe the running-variable density (McCrary), differential attrition across
the cutoff, and placebo cutoffs at non-policy thresholds; (ii) specification
variants that probe outlier treatment, wild-cluster inference, event-study
parallel trends, HonestDiD pre-trend sensitivity, and alternative time-window
(Spec B) and covariate-rich (Spec C) specifications; and (iii) treatment-
definition variants that probe the area-only baseline (\S\ref{sec:robustness-areaonly})
and the asymmetric-sample intermediate (\S\ref{sec:robustness-asymmetric}).
The headline F1 monotone tenancy gradient and the operating-cost-net-of-rent
$\hat\beta_3 \le 0$ point estimate are preserved across all 12 checks.
```

This 1-sentence-paragraph fix would lift Section organization from 8.0 → 9.5 and overall Lens 5 score from 9.3 → 9.5+.
