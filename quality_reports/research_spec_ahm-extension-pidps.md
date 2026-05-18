# Research Specification: Wealth-Biased Liquidity, Tenure-Mode Pivot, and the Separability Null — An AHM-Extension Test Using Korea's 0.5 ha Subsidy Cutoff

**Date:** 2026-05-18
**Researcher:** Lee, Dohyeon (Korea University, Dept. of Food and Resource Economics)
**Paper type:** theory+empirics
**Supersedes:** the 5-channel + Step-k build-up framing in `quality_reports/plans/2026-05-15_section3-chain-restructure-appendix-a.md`; the P3b-2 "three-channel tenant-driven land transition" framing retained as auxiliary descriptive lens for the heterogeneity result.

---

## Research Question

Does Korea's per-farm flat-rate subsidy at the 0.5 ha eligibility cutoff (Small-Farmer Flat Payment, SFFP) **reject the AHM separability null** through two independent non-separability margins — wealth-biased liquidity and implicit-labor supervision — and produce the heterogeneity signature uniquely predicted by Carter-Olinto (2003)–style asset-threshold liquidity models?

---

## Motivation

The Agricultural Household Model (AHM) of Singh-Squire-Strauss (1986) predicts **separability** between farm production and household consumption-labor decisions when all relevant markets clear at parametric prices. de Janvry-Fafchamps-Sadoulet (1991) enumerate the four canonical sources of separability failure: missing credit, missing insurance, missing labor, and missing land markets. The empirical literature testing separability has converged on a small set of 1-tier papers — Benjamin (1992, *Econometrica*), LaFave & Thomas (2016, *Econometrica*) — which exploit demographic shocks rather than policy variation.

This paper introduces a **policy-induced separability test** using a sharp eligibility cutoff at 0.5 ha (5,000 ㎡) for Korea's PIDPS Small-Farmer Flat Payment, a per-farm (not per-hectare) lump-sum subsidy of 1.2M KRW/year effective 2020. Two AHM extensions generate sharp testable predictions about the response:

1. **Wealth-Biased Liquidity (Carter & Olinto 2003, *AJAE*; Kazukauskas et al. 2013, *AJAE*)** — A binding wealth/credit constraint on land acquisition implies an asset-threshold rule: small subsidies push marginal smallholders past the threshold to buy their previously-rented land, yielding a **monotone gradient** in baseline tenancy share (pure tenants respond most, pure owners by definition do not respond). This heterogeneity pattern is uniquely diagnostic of wealth-bias and cannot arise from a universal income-effect channel.

2. **Implicit-Labor Supervision (Eswaran & Kotwal 1986, *Economic Journal*)** — When labor markets are imperfect because hired labor requires costly supervision, the shadow wage of family vs. hired labor diverges; income shocks induce reallocation toward family-supervised activities. Predicts off-farm-labor changes inconsistent with separability.

The contribution is methodological as well as substantive: **the 0.5 ha cutoff provides cleaner-than-usual identification of the AHM separability null**, comparable in design to the eligibility-discontinuity strategies in Pitt & Khandker (1998, *JPE*), but applied to a developed-country setting where most prior separability tests were rejected on demographic instruments.

---

## Hypothesis

**Primary (H1, Carter-Olinto):** Subsidy eligibility induces own-cultivated land expansion (`area_own ↑`) with effect magnitude **monotonically increasing in baseline tenancy share** (`own_share` low → high).

**Primary (H2, Kazukauskas-style capital adjustment):** Subsidy eligibility induces capital-input adjustment (`op_cost_ex_rent`) consistent with credit-constrained investment under a fixed adjustment threshold.

**Auxiliary (H3, Eswaran-Kotwal):** Subsidy eligibility induces off-farm-labor reallocation (`off_farm_income`) inconsistent with the AHM separability null.

**Joint separability null (H0):** All three β = 0.

---

## Empirical Strategy

- **Method:** Difference-in-Differences with sharp RD at the 0.5 ha cutoff (DiD-RD).
- **Running variable:** `rv_2018 = area_2018 − 5000` (2018 baseline area centered at the 0.5 ha threshold; pre-policy → manipulation-blocked).
- **Treatment:** `D = 1` if `rv_2018 ≤ 0` (i.e., baseline area ≤ 0.5 ha → SFFP-eligible) × `Post = 1` for 2020+.
- **Bandwidths:** T1 ±500 ㎡, T2 ±1,000 ㎡, T3 MSE-optimal (`rdrobust`) — parallel reporting.
- **Inference:** Wild cluster bootstrap at the household level + Holm step-down across (H1, H2, H3).
- **Key identifying assumption:** No manipulation of 2018 baseline area (pre-policy → mechanically blocked); local randomization in a narrow window around 0.5 ha.
- **Robustness checks:**
  - McCrary density test on `rv_2018` (pre-policy → expected smooth);
  - Pre-trend test on 2018–2019 placebo "Post";
  - Donut-RD removing exact cutoff observations;
  - Triangular vs uniform kernel;
  - Subgroup gradient (H1) at quintiles of `own_share`.

---

## Falsification Predictions

| Pattern | Implication |
|---|---|
| **F1** — `area_own` ATT effect is **flat (non-monotone) in `own_share`**, OR pure owners (`own_share = 1`) also show the effect | Wealth-biased liquidity (Carter-Olinto) hypothesis **rejected**. Would reframe as **universal income effect** under separability and abandon the wealth-bias mechanism. |
| **F2** — `off_farm_income` shows no effect across bandwidths | Eswaran-Kotwal supervision channel **rejected**; auxiliary margin only weakens, primary (H1) survives. |
| **F1 + F2 jointly** | AHM **separability null cannot be rejected**; paper repositions as a precise null estimate with developed-country interpretation. |

---

## Data

- **Primary dataset:** Statistics Korea MDIS, Farm Household Economic Survey (FHES) Wave 1, 2018–2022.
- **Coverage:** 14,474 farm-years, 3,614 farms (verified on `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta`, 2026-05-06).
- **Key variables:**
  - **Running variable:** `area_2018` (㎡) → `rv_2018`.
  - **Treatment:** `D` (time-invariant household level; mean 0.349 in raw data).
  - **Primary outcomes:** `area_own` (자작 면적, primary #1); `op_cost_ex_rent` (rent 제외 경영비, primary #2 / capital).
  - **Auxiliary outcome:** `off_farm_income` (농외소득).
  - **Ex-theory descriptive:** `unit_rent_price` (rent_cost / area_rent), `rent_cost` — reported alongside but not derived from the AHM-extension model (see "Equilibrium Rent Caveat" below).
  - **Heterogeneity:** baseline `own_share` (2018 자작 비중) quintile.
- **Sample:** Farm-year panel, 2018–2022, with 2018 as anchor year for the running variable.

---

## Theoretical Framework (§3, target structure)

**Structure (S1, 4 subsections, ~3–4p main text):**

- §3.1 Baseline AHM and the Separability Null — Singh-Squire-Strauss (1986) household-as-utility-maximizer; dJFS (1991) market-failure taxonomy; the null β = 0 derived from FOCs under complete markets.
- §3.2 Extension: Wealth-Biased Liquidity Relaxation — Carter-Olinto (2003) asset-threshold rule, augmented with Kazukauskas et al. (2013) decoupled-subsidy-disinvestment FOC. Closed-form prediction in main text:
  - `∂(area_own)/∂T > 0` and `∂²(area_own)/∂T∂(tenancy_share) > 0`.
  - `∂(op_cost_ex_rent)/∂T ≤ 0` if `T/s_min < threshold` (credit-constrained, no full adjustment).
- §3.3 Auxiliary: Implicit Labor Market with Supervision — Eswaran-Kotwal (1986) shadow-wage divergence; closed-form prediction:
  - `∂(off_farm_income)/∂T ≠ 0` under non-separability (sign indeterminate ex ante, magnitude diagnostic of supervision-cost wedge).
- §3.4 Unified Predictions Table and Equilibrium Rent Caveat — single table mapping each prediction to its econometric β; **B.1 disclosure:** observed `unit_rent_price` and `rent_cost` movements are aggregate-equilibrium implications (via Floyd 1965 / Alston-James 2002 incidence theory) of the micro predictions, **not** model-internal AHM-extension outputs.

**Derivation depth (D2):** Closed-form FOC results in main text; full Lagrangian + comparative statics in `paper/en/online_appendix.tex` (separate file), with §A.1 (Carter-Olinto wealth-biased liquidity derivation), §A.2 (Eswaran-Kotwal supervision derivation), §A.3 (Mapping table).

---

## Expected Results

- **H1 (Carter-Olinto):** ✅ Empirically supported in P3b-2 — T2 area_own gradient pure_tenant +1,089 ㎡ (p=0.033), low_owner +410 (p=0.051), mixed +393 (p=0.063), pure_owner ≡ 0 ref; T3 cumulative area_total +408 ㎡ (p=0.003).
- **H2 (capital adjustment):** ✅ Empirically supported — T1 op_cost_ex_rent −4.02M KRW (p=0.055), T2 −3.22M (p=0.079).
- **H3 (Eswaran-Kotwal):** ❓ Auxiliary outcome — needs re-estimation under new theoretical hierarchy.
- **Equilibrium rent (B.1 disclosure):** consistent with incidence implication — T2 rent_cost −11.1% pass-through; unit_rent at T1 declines across non-pure-owner bins.

---

## Contribution (one-liner, **C2**)

> "Using the 0.5 ha eligibility cutoff as a natural experiment, we **reject AHM separability** for Korean small farms: subsidy-induced tenure-mode shifts (Carter-Olinto wealth-biased liquidity) and labor reallocation (Eswaran-Kotwal supervision-cost) provide two independent margins consistent with multi-failure non-separability."

**Differentiation:**
- vs. **Benjamin (1992) / LaFave-Thomas (2016)** — they test separability with demographic shocks; we use a sharp policy cutoff with cleaner exogeneity, in a developed-country setting.
- vs. **Carter & Olinto (2003)** — they test wealth-bias in Paraguay survey data; we extend to a developed-country flat-rate subsidy with a discontinuity design.
- vs. **Kirwan (2009) / Ciaian et al. (2023)** — they study capitalization under per-hectare subsidies; we study the AHM-internal margin under per-farm structure and explicitly demote rent-capitalization to an aggregate-equilibrium implication outside the model.
- vs. **Choi & Jodlowski (2025)** — land-ownership regulation; we study a price subsidy.
- vs. **최민영·문한필 (2025)** — off-farm-income RDD only; we combine area cutoff + DiD across multiple AHM-extension outcomes.

---

## Open Questions

1. Eswaran-Kotwal (1986) channel: should the §3.3 derivation present a **two-equation simultaneous system** (family vs hired labor) or compress to **a single FOC with supervision wedge**? D2 (closed-form in main) constraint suggests the latter; verify after §3.3 draft.
2. Online appendix layout: §A separate file (decision: yes, separate file per ADR-3). Whether to also separate §A.1 vs §A.2 vs §A.3 into distinct sections (yes — they correspond to different mechanisms).
3. Whether to include a **separability test statistic** (Benjamin 1992 / LaFave-Thomas 2016 style F-test of jointly zero β) as a single bolded result in the introduction. Recommendation: yes, this is the headline that frames C2.
4. How to reconcile P3b-2's **monotone tenant gradient** narrative with the **Carter-Olinto wealth-biased** language. Decision: replace "tenant-driven" prose with "wealth-biased liquidity" prose where it appears in introduction / abstract / conclusion; retain "tenant share" as the empirical variable label.

---

## Decision Records

- `quality_reports/decisions/2026-05-18_theoretical-scope.md` — α-strict + Combo α3 + B.1 (scope of literature + auxiliary channel demotion)
- `quality_reports/decisions/2026-05-18_outcome-hierarchy.md` — area_own promoted to #1 outcome; op_cost #2; off_farm_income auxiliary; unit_rent ex-theory
- `quality_reports/decisions/2026-05-18_section3-structure.md` — S1 (4 subsections lean) + D2 (closed-form in main, derivation in online appendix)

---

## Verification (CoVe)

**Outcome:** ✅ ALL PASS (9/9). Verified 2026-05-18 by `claim-verifier` agent (forked context).

| # | Claim | Status | Notes |
|---|---|---|---|
| 1 | Singh-Squire-Strauss (1986) — Johns Hopkins UP / World Bank, edited volume | PASS | xi + 335 pp; AJAE 69(2):498-500 (1987 review by Carter) confirms |
| 2 | de Janvry-Fafchamps-Sadoulet (1991) — EJ 101(409):1400–1417 | PASS | DOI 10.2307/2234892 |
| 3 | Carter & Olinto (2003) — AJAE 85(1):173–186 | PASS | — |
| 4 | Kazukauskas-Newman-Clancy-Sauer (2013) — AJAE 95(5):1068–1087 | PASS | DOI 10.1093/ajae/aat048; distinct from 2014 *Agricultural Econ* 45 productivity paper |
| 5 | Eswaran & Kotwal (1986) — EJ 96(382):482–498 | PASS | "Access to Capital and Agrarian Production Organisation"; distinct from 1985 AER contract paper |
| 6 | Benjamin (1992) — Econometrica 60(2):287–322 | PASS | DOI 10.2307/2951598 |
| 7 | LaFave & Thomas (2016) — Econometrica 84(5):1917–1960 | PASS | DOI 10.3982/ECTA12987; NBER w20699 |
| 8 | Pitt & Khandker (1998) — JPE 106(5):958–996 | PASS | DOI 10.1086/250037 |
| 9 | Foster & Rosenzweig (1995) — JPE 103(6):1176–1209 | PASS | — |

No discrepancies, no unverifiable claims. Spec citations are safe to bibliographize as-is. The Kirwan / Ciaian / Floyd / Alston-James / Choi-Jodlowski citations are not in this CoVe block because they were already verified in earlier session work (`Bibliography_base.bib` 2026-05-15 +9 entries pass).
