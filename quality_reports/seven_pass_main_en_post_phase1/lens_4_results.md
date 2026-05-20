# Lens 4 — Results & Tables (post-Phase-1, second seven-pass)

**Manuscript:** `paper/en/main.tex` (492 lines, compiled state)
**Lens focus:** §6 Results + Table 1 (descriptives) + all `\input{}`-ed tables (§4 + §7)
**Reviewer baseline:** Initial Lens 4 = **4/10** (MAJOR FAILURE; three tables not `\input{}`-ed; §4 prose/Table 1 numeric drift)
**Phase 1 deliverables verified:** F1 4-bin, pooled DiD-RD, CH4 rent-decomposition tables all now `\input{}`-ed (lines 356, 367, 373); §4 line 321 updated to symmetric Table 1 numbers (24.4M / 8.3M / −16.0M op_cost_ex_rent); Spec B caption / prose alignment confirmed (line 419) and Spec C added (lines 423–425).

---

## Headline Score: **8.0 / 10** (target ≥8.5; +4.0 vs. initial 4/10)

The three Phase-1 CRITICAL items are correctly closed. Remaining gaps are concentrated in (a) table caption stand-alone-ness (still below AJAE bar), (b) one MAJOR cross-table numeric inconsistency (pure-tenant T2 coefficient: §6 prose = +1,151 m² but §5 prose at line 341 = +1,122 m² — the wrong/old number is in the empirical-strategy section), and (c) Holm step-down family-definition drift (§5 text lists "consumption or farm_income" as the omnibus, but the F2/headline tables present a 4-outcome family that excludes consumption from the primary set). These are MAJOR but fixable in one editing pass.

---

## A. Per-Table Audit (stand-alone caption check, AJAE standard)

AJAE rule: caption must specify (i) outcome variable + units, (ii) sample N, (iii) bandwidth definition, (iv) FE / cluster structure, (v) inference method, (vi) significance stars.

| Table | label | Stand-alone? | Issues |
|---|---|---|---|
| **Table 1: Descriptives** (`tab_descriptives_en.tex`) | `descriptives_en` | **PARTIAL** | Caption is only "Descriptive Statistics by Treatment Status". Does NOT say: sample size, year(s), weighting note in caption (only in footer), units. Note says "Baseline = 2018 cross-section" but op_cost shows 26.3M control vs 8.4M treated — these are NOT exactly the 24.4M / 8.3M cited in §4 line 321. **MINOR drift: 26.3M vs 24.4M (op_cost vs op_cost_ex_rent ambiguity).** See item C1. |
| **Table 2: F1 heterogeneity** (`tab_het_own_share_en.tex`) | `het_own_share_en` | **NO** | Caption: "own\_share × D\_Post heterogeneity: 5-bin × 4 outcome (Spec A)". Caption does NOT name the 4 outcomes, does NOT say N, does NOT say which bandwidths reported (h=500/1000/3300 are in body only), does NOT define h units (m²), does NOT say cluster level (only footer). Footer mentions "Scenario classification: γ (own-cultivation dominant) — H3 strong in pure_owner; 'land accumulation' narrative strengthened" — **stale Wave-5 narrative leakage from prior framing; should be deleted.** |
| **Table 3: Pooled DiD-RD** (`tab_main_did_rd_en.tex`) | `main_specA_en` (NOTE: paper text refers to it as Table~\ref{tab:ch4_rent_en} only — see C3) | **NO** | Caption: "DiD-RD: Spec A (2018-2022, Post = year >= 2020)". Does NOT name 4 outcomes in caption, does NOT define h units, footer says "Stars = Holm step-down adjusted p-value" yet NO star appears in the body — **either Holm is producing all-NS, in which case the caption is misleading; or stars are missing.** The op_cost coef is −3.73M (T1) but the §6 prose at line 365 says −3.57M for op_cost_ex_rent. **CRITICAL ambiguity: this table reports op_cost (inclusive of rent), the §6 prose claims op_cost_ex_rent — see C2.** |
| **Table 4: CH4 rent decomposition** (`tab_ch4_rent_decomposition_en.tex`) | `ch4_rent_en` | **PARTIAL** | Caption names the benchmark contrast. Footer "Headline scenario classification (Spec A T3): MIXED" — **stale internal-jargon leakage**, should be removed for AJAE. Pass-through column lacks SE/CI; only point estimate. |
| **Table 5: Spec B** (`tab_specB.tex`) | `specB` | NO | Same problem as Table 3 — "drop 2020" caption is now correct (Phase-1 fix verified), but body row labels are `op_cost` (rent-inclusive); §7 prose treats them as op_cost_ex_rent. Same C2 ambiguity. |
| **Table 6: Spec C** (`tab_specC.tex`) | `specC` | NO | Caption: "Spec C — covariate-rich robustness: farm_type×Post + age_code_base×Post interactions. Cluster = hh_id." Does name interactions; does NOT say N (in body only), bandwidth definitions (T1/T2/T3 only by label), units. Body rows are labeled `op_cost_ex_rent` here, which agrees with §7 prose (line 423) — but the inconsistency with Table 3's `op_cost` label is unresolved. |
| **Table 7: sido robustness** (`tab_sido_robustness_en.tex`) | `sido_robustness_en` | PARTIAL | Caption gives FE + cluster. Body rows labeled `op_cost_ex_rent` (matches §7 prose). Outcome list in caption missing; relies on body sub-headers. |
| **Table 8: Dropped balance** (`tab_dropped_balance_en.tex`) | `dropped-balance` | YES | Caption fully self-contained: groups, n_hh, pre-period window, mean/SD. Good. |
| **Table 9: Placebo cutoffs** (`tab_placebo-cutoffs`) | `placebo-cutoffs` | YES | Caption gives spec, bandwidth, design intent. Good. |
| **Table 10: Attrition placebo** (`tab_attrition-placebo-full`) | `attrition-placebo-full` | YES | Self-contained. Good. |

**A-summary:** 3 of 10 tables (descriptives, F1 heterogeneity, pooled DiD-RD) fall below AJAE stand-alone-ness — these are the THREE HEADLINE TABLES. This is a Major issue for first submission.

---

## B. Per-Figure Audit

| Figure | Caption self-contained? | Issues |
|---|---|---|
| Fig 1 F1 four-bin gradient (line 358–363) | YES | Includes magnitudes (+1,151 m², p=.036), bandwidth, mechanism reading. Good. |
| Fig 2 McCrary density (lines 386–391) | YES | Includes test stat, p, narrow-window decomposition, sample size, design rationale. Excellent. |
| Fig 3 Event-study T2 (lines 401–406) | YES | Includes parallel-trends gate result, (S,s) reading. Good — verifies "2018 pre-period \|t\| < 1" from figure. |
| Fig 4 HonestDiD sensitivity (lines 412–417) | YES | Reads cleanly with §7 prose context. |
| Fig 5 Forest plot, treatment defs (lines 449–454) | PARTIAL | 24 cells comparison good, but caption says "stable to within 2.2% in absolute value" — this number is for an earlier-Wave comparison; §7 prose at line 441 says 39% median absolute shift. **MAJOR contradiction: 2.2% (figure caption) vs 39% (§7 prose line 441).** See C4. |
| Fig 6 McCrary multi-rv (lines 458–463) | YES | Self-contained. Good. |

**B-summary:** 5 of 6 figures pass the stand-alone test. One serious caption/prose conflict (Fig 5).

---

## C. CRITICAL Issues

### C1. Table 1 vs §4 prose — units/measure ambiguity
**Where:** `tab_descriptives_en.tex` line 9 shows `op_cost` 26,280,404 (control) / 8,447,763 (treated) / diff −17,832,642. §4 line 321 says "control-group ... operating cost net of rent averages 24.4 M KRW versus the statutorily-eligible group ... average of 8.3 M KRW (difference −16.0 M KRW)."
**Problem:** The Table 1 variable name is `op_cost` (rent-inclusive omnibus) while §4 prose claims `op_cost_ex_rent`. 26.3 − 8.4 = 17.8M (matches table); 24.4 − 8.3 = 16.0M (claimed in §4). These are DIFFERENT measures with DIFFERENT control means.
**Fix:** Either (i) rebuild Table 1 to report op_cost_ex_rent (matches §4), or (ii) re-edit §4 line 321 to say op_cost = 26.3M / 8.4M / −17.8M and add a separate sentence for op_cost_ex_rent. Phase-1 fix only achieved partial reconciliation.
**Severity:** CRITICAL (AJAE referees will catch this in first read).

### C2. Pooled DiD-RD table — outcome label says op_cost but §6 prose says op_cost_ex_rent
**Where:** `tab_main_did_rd_en.tex` column header "op_cost"; T1 row coefficient −3,732,607. §6 prose line 365 reports "−3.57M KRW at T1" on "operating cost net of rent" (op_cost_ex_rent). Note also: −3,732,607 ≠ −3,570,000 (they are 4.5% apart — these are likely different specifications).
**Problem:** Either the table column should read `op_cost_ex_rent` and the body coefs should be −3.57M / −2.62M (matching the CH4 rent-decomposition table column 2 — see `tab_ch4_rent_decomposition_en.tex` lines 9–14 which give exactly −3,567,680 at T1 and −2,622,322 at T2), OR §6 prose should cite the −3.73M op_cost number. **The CH4 table and the §6 prose agree. The pooled DiD-RD table is reporting a different (op_cost-inclusive) outcome.**
**Fix:** Confirm which is the headline outcome. Rebuild `tab_main_did_rd_en.tex` to report op_cost_ex_rent (so the pooled headline table matches both the prose and the CH4 channel-decomposition table), OR explicitly rename the column and clarify in §6 prose that two separate operating-cost measures are reported in two tables.
**Severity:** CRITICAL — three-channel coherence breaks because the pooled and rent-decomposition tables look like they should agree on the op_cost row but do not.

### C3. Cross-reference of Table label vs Table number
**Where:** `tab_main_did_rd_en.tex` carries `\label{tab:main_specA_en}` (note the `_en` suffix). §6 prose at line 354 calls "Table~\ref{tab:het_own_share_en}" (F1 het table); line 367 just `\input{}`s the pooled table without a `\ref{}` callout in surrounding text. **No `\ref{tab:main_specA_en}` appears anywhere in main.tex.** The pooled DiD-RD table is `\input{}`-ed but never referenced — it floats orphan.
**Fix:** Add at least one explicit "Table~\ref{tab:main_specA_en}" callout in §6 (e.g., in the "Operating-cost sub-prediction" paragraph). Also reconcile naming: §6 line 365 cites "Table~\ref{tab:ch4_rent_en}" for the −3.57M number, which is correct *for the CH4 decomposition table*, but the pooled table itself (which would be the natural headline table) is unreferenced.
**Severity:** CRITICAL (AJAE submissions cannot have unreferenced tables).

### C4. Figure 5 caption vs §7 prose — 2.2% vs 39%
**Where:** Fig 5 caption line 452: "headline operating-cost coefficients (op_cost rows) are stable to within 2.2% in absolute value across definitions." §7 prose line 441: "with median absolute percentage shift of 39%."
**Problem:** The 2.2% figure is from the prior Wave-7 area-vs-eligible comparison (carried over from the earlier comparison.md). The 39% figure is the symmetric-screened-vs-area-only comparison (the comparison the figure now visualizes). The figure caption is **stale** by one wave; the prose is current.
**Fix:** Rewrite Fig 5 caption to say "...with the symmetric screening producing a median absolute percentage shift of 39% relative to the area-only baseline (3 sign flips on the off-farm-income outcome, which is statistically near zero under both designs)."
**Severity:** CRITICAL (a referee comparing figure to prose will note the discrepancy and request a redo).

---

## D. MAJOR Issues

### M1. §5 line 341 vs §6 line 354 — +1,122 m² vs +1,151 m² pure-tenant T2
**Where:** §5 (Empirical Strategy) line 341: "The statutorily-eligible subset estimation delivers $\hat\beta_{1,\text{tenant}} = +1{,}122$~m² ($p = .041$, T2)."
§6 (Results) line 354 / Table 2: "+1,151 m² (p = .036)" at T2.
**Problem:** The +1,122 / p=.041 is the **asymmetric-sample** Wave-7 baseline (confirmed: it appears in §7 line 443 robustness for the asymmetric variant). The +1,151 / p=.036 is the **symmetric-screened** main result. §5 imported the wrong (old) magnitude when summarizing what the F1 trigger evaluates against.
**Fix:** §5 line 341 should say "+1,151 m² (p = .036, T2)" — replace the asymmetric numbers with the symmetric main numbers. Keep the asymmetric +1,122 / .041 numbers in §7.3 robustness only.
**Severity:** MAJOR (internal contradiction across §5/§6 — load-bearing F1 statement).

### M2. Headline pure-tenant magnitude interpretation — +1,151 m² = 23% of 0.5 ha threshold
**Where:** §8 Discussion line 470: "The pure-tenant own-cultivated-area response of +1,151 m² at T2 is approximately 23% of the 0.5~ha eligibility threshold."
**Check:** 1,151 / 5,000 = 23.0%. ✅ Correctly stated. M4 benchmark (initial review) **passes**.

### M3. Holm step-down family — definition drift
**Where:** §5 line 343 (Inference paragraph): "Across the primary outcome family (the four outcomes: $A_{\text{own}}$, $\text{op\_cost\_ex\_rent}$, $\text{off\_farm\_income}$, and $\text{consumption}$ or $\text{farm\_income}$ as the omnibus), we apply Holm step-down correction."
**Problem:** "consumption *or* farm_income as the omnibus" is non-specific — Holm requires a fixed family of size 4 (or 5). Looking at the actual tables: `tab_main_did_rd_en.tex` reports 4 outcomes = {op_cost, off_farm_income, consumption, farm_income}, while the theoretically-load-bearing outcomes per §3 Table `alpha3-predictions` are {A_own, op_cost_ex_rent, off_farm_income, unit_rent_price}. **The Holm family is not consistently defined; A_own is not in the empirical 4-outcome family even though §5 names it.**
**Fix:** Specify the Holm family unambiguously: e.g., "Holm step-down applied across the 4-outcome primary family {A_own, op_cost_ex_rent, off_farm_income, unit_rent_price}; the omnibus {op_cost, consumption, farm_income} are reported in the secondary family table (Table~\ref{tab:main_specA_en}) without Holm adjustment." This also ties to C2 (table column-name mismatch).
**Severity:** MAJOR — multiple-testing correction is a referee target.

### M4. Significance-without-magnitude
**Where:** §6 line 354: "The pure-tenant response is statistically distinguishable from zero at the p < .10 level across all three bandwidths and at p < .05 in T2 and T3."
**Check:** Magnitudes ARE reported alongside (+1,151 m², +1,578 m², +357 m²). ✅ Passes the rubric "no p-value-only declarations." Headline magnitudes consistently reported in m² with a % conversion (23%) in §8.
**Result:** PASSES rubric item 4.

### M5. Op-cost magnitude interpretation
**Where:** §6 line 365: "−3.57M KRW at T1 ... corresponds to a −43% change relative to the pre-period treated-group operating-cost-net-of-rent mean of 8.3M KRW, equivalent to approximately −3.0× the annual SFFP transfer of 1.2M KRW."
**Check:** 3.57 / 8.3 = 43.0%. ✅ 3.57 / 1.2 = 2.97×. ✅ Both interpretations are explicit. Good practice.
**Result:** Passes rubric item 3.

### M6. Three-channel coherence — DOES the set READ TOGETHER?
**Test:** A reader hits §6 in order: Table 2 (F1 het) → Table 3 (pooled DiD-RD) → Table 4 (CH4 rent decomp).
- Table 2 row "area_own h=1000": +1,151** / +438** / +258 / −52 / 0 → readable, monotone clear.
- Table 3 column "op_cost" T2: −2,762,226 (1,967,784) → BUT §6 prose cites −2.62M from op_cost_ex_rent (which is Table 4 column 2, value −2,622,322). **The reader cannot get the −2.62M figure from Table 3; they need Table 4.**
- Table 4 column "rent_cost" T1: −164,927* and "Pass-through (Korea)" = −13.7%. Matches §6 line 371.

**Problem:** The pooled DiD-RD table is supposed to be the headline summary table but it does not actually carry the headline numbers cited in prose. The CH4 table carries them instead. A reader following table-by-table will be confused about which is "the" main table.
**Fix:** Either merge them, or relabel the pooled table column to op_cost_ex_rent and recompute, or add a row to Table 4 with A_own (the load-bearing primary #1 outcome) so Table 4 becomes the headline.
**Severity:** MAJOR (rubric item 7 — tables-read-together test fails).

### M7. T3 MSE-optimal bandwidth value
**Where:** §6 line 354: "T3 (MSE-optimal h ≈ 3,300 m²)". Table 2 body rows use h=3300. Table 10 (`tab_attrition-placebo-full`) uses T3 = 2,097 m². The two T3 bandwidths are DIFFERENT.
**Problem:** rdrobust MSE-optimal h is outcome-specific. F1 het table uses one value, attrition placebo uses another. Footer of Table 3 says "$h^*_\mathrm{mse}$ (per outcome)" — this confirms per-outcome optimality, but the paper prose treats T3 as a single bandwidth. The N column in Table 3 also varies across outcomes at T3 (1,903 / 2,071 / 2,436 / 3,308), confirming per-outcome MSE-h.
**Fix:** Be explicit in caption + §5 that T3 is per-outcome and the values vary; or report a single h (e.g., median MSE-optimal across outcomes) for cross-comparability. This is a referee-bait item.
**Severity:** MAJOR.

### M8. Heterogeneity table monotonicity readability
**Where:** Table 2 row "area_own h=1000": Pure tenant +1,151** / Low owner +438** / Mixed +258 / High owner −52 / Pure owner 0.
**Test:** Is it clear that pure_tenant > low_owner > mixed > high_owner > pure_owner ≡ 0?
- Numerically yes: 1,151 > 438 > 258 > −52 > 0 (with the last sign-ambiguity acknowledged).
- Table column headers correctly label the bins with own-share ranges (own=0 / (0,0.3) / [0.3,0.7) / [0.7,1) / =1, ref).
- BUT: the bin partition in §3 / online appendix is stated as 4 bins {0, (0, .33], (.33, .67], 1} (line 119 + line 203 boxed eq.) — i.e., a 4-bin partition with no separate "high owner" tier. **The table reports 5 bins; the theory specifies 4.**
**Problem:** 4-bin (theory) vs 5-bin (empirics) drift. Either the theory needs to be updated to 5 bins, or the empirics collapsed to 4. Also, the bin breakpoints differ: theory says (0,.33] / (.33,.67]; table says (0, 0.3) / [0.3, 0.7) — minor but notable boundary-rounding inconsistency.
**Fix:** Reconcile partition. If 5 bins is the operative empirical choice, update §3 Table notation + §3.2 eq. (CO-2) to enumerate 5 bins (pure_tenant, low, mixed, high, pure_owner). If 4 bins is correct, collapse Table 2 by merging "Mixed" + "High owner" into "Mixed".
**Severity:** MAJOR (theory↔empirics partition mismatch).

### M9. Pre-trends placebo verifiability
**Where:** §7 line 399: "The 2018 pre-period coefficient is statistically zero (|t| < 1), satisfying the LN-10 parallel-trends gate."
**Test:** Can a reader verify |t| < 1 from Fig 3 (event-study figure)? The figure caption states it; the actual coefficient/CI is not numerically given (only visually). For AJAE-grade, attach a 2-row pre-period coefficient table to the figure or state the value: "2018: β̂ = X (SE Y, |t|<1)."
**Fix:** Either add the numeric pre-period coef to the figure caption or to §7 prose. Currently the reader must trust the figure.
**Severity:** MAJOR (rubric item 9 — pre-trends verifiable).

---

## E. MINOR Issues

### N1. Stale "Wave-5 narrative" footers in two tables
- `tab_het_own_share_en.tex` line 50: "Scenario classification: γ (own-cultivation dominant) — H3 strong in pure_owner; 'land accumulation' narrative strengthened" — pre-α3 framing; should be deleted.
- `tab_ch4_rent_decomposition_en.tex` line 21: "Headline scenario classification (Spec A T3): MIXED — see per-bandwidth detail" — same issue.

### N2. Stale Wild-bootstrap footer
- `tab_main_did_rd_en.tex` and `tab_specB.tex` footers: "Wild / fractional cluster bootstrap deferred to P3 (`04_robust.R`)." This was an internal P3 milestone marker — should be removed for journal submission. The §7 line 397 paragraph already documents wild-bootstrap status.

### N3. Units in cross-table comparisons
- Table 1 uses KRW with full integer (26,280,404). §4 prose uses M KRW (24.4). §6 prose uses M KRW (−3.57M). §7 prose uses M KRW. Consistent in prose; tables use raw KRW. For AJAE, prefer to either: (i) report all KRW in Million KRW with unit clearly in column header, or (ii) keep raw KRW but add scale note. Currently consistent enough to pass, but pulling readers between scales.

### N4. Pass-through % SE
- Table 4 column "Pass-through (Korea)" has no SE / CI. For a quantity cited in §6 line 371 and §8 line 472 as policy-load-bearing (−13.7% reverses Kirwan +25%), a confidence interval should be reported. Easy delta-method derivation from rent_cost SE.

### N5. Spec C edu-tier deferral
- `tab_specC.tex` footer says "edu_tier merge deferred to Phase 2." For a first-submission table, this kind of internal-milestone language reads as half-done. Remove or rephrase to "Education-cohort covariates are not yet linked to the panel (HH-member CSV merge planned for the replication package release)."

### N6. Asymmetric-sample variant numbers in §7.3 line 443
- "+1,122 m² (p = .041) ... gradient +1,122 → +403 → +222 → −74 → 0" — these are the asymmetric-sample Wave-7 numbers, used **correctly** here. The same numbers leak into §5 line 341 (M1 above). Once M1 is fixed, this paragraph is the sole location.

### N7. Table 3 (pooled DiD-RD) label
- `\label{tab:main_specA_en}` vs paper's text-reference convention (`tab:descriptives_en`, `tab:het_own_share_en`, `tab:ch4_rent_en` all use shorter names). Rename to `tab:main_didrd_en` for consistency with the heading hierarchy.

---

## F. p-value vs effect-size audit (rubric item 4)

| Claim in §6 | Magnitude given? | % conversion? | Both p and SE? |
|---|---|---|---|
| Pure-tenant T2 +1,151 m², p=.036 | YES | 23% of cutoff (§8) | YES (Table 2 row) |
| Low-owner T2 +438 m², p=.047 | YES | (no % conversion) | YES |
| Op_cost_ex_rent T1 −3.57M, p≈.10 | YES | −43%, −3× transfer | YES |
| Rent_cost T1 −164,927, p<.10 | YES | −13.7% pass-through | YES (Table 4) |
| Off-farm income pooled β₄ "near zero" | partial (cell ranges quoted as −13.9M to +14.3M) | NO | partially |

**Verdict:** No p-only declarations on headline. Good. One MINOR weakness: the off-farm-income near-zero claim does not give a single point estimate + SE for the pooled coefficient (only cell-level ranges). Adding "$\hat\beta_4 = X \pm Y$ at T2" would close this.

---

## G. Holm step-down audit (rubric item 5)

**Status:** UNCLEAR. The pooled DiD-RD table footer says "Stars = Holm step-down adjusted p-value" but the table body has NO stars on the op_cost/off_farm/consumption/farm_income coefficients at T1 or T2 (one * appears on consumption T3). §6 prose at line 365 says "not significant after Holm step-down across the four-outcome primary family." The CH4 rent table line 9 shows rent_cost T1 = −164,927*, but that table's footer does NOT explicitly state Holm. **Inference:** the F1 het table's *,**,*** are pre-Holm (raw); the pooled and rent tables are post-Holm. This is inconsistent across tables.
**Fix:** State explicitly in each table's footer whether the stars are raw or Holm-adjusted. AJAE convention favors reporting BOTH (analytic SE p AND Holm-adjusted p) for each headline cell.

---

## H. Three-channel coherence (rubric item 7) — Final read-together test

**Test:** A referee opens the paper, reads §6 in order, and tries to map prose claims to tables.

1. "F1 monotone tenancy gradient" → Table 2 area_own panel → ✅ CLEAR
2. "Op_cost_ex_rent T1 −3.57M, T2 −2.62M" → Table 4 column 2 → ✅ CLEAR (but Table 3 has the wrong outcome name, see C2)
3. "Rent_cost pass-through −13.7%" → Table 4 column 1 + column 3 → ✅ CLEAR

**Pooled DiD-RD table (Table 3) does not appear in the §6 prose narrative.** It is `\input{}`-ed at line 367 (between paragraphs on op_cost sub-prediction and F2) but no prose sentence references it. This is the biggest single drag on the readability — a table sits in the page flow without a callout.

---

## Summary table — scoring breakdown

| Rubric item | Score | Comment |
|---|---|---|
| 1. Stand-alone tables | 6/10 | Table 1, Table 2, Table 3 below AJAE bar |
| 2. Units consistency | 8/10 | KRW vs M KRW mixed across table/prose but reconcilable |
| 3. Magnitude interpretation in % | 9/10 | +1,151 m² = 23%; −3.57M = −43%/−3× transfer; pass-through −13.7% |
| 4. p-value vs effect size | 9/10 | All headline claims paired with magnitudes |
| 5. Multiple testing (Holm) | 6/10 | Inconsistent — see G |
| 6. Figure legibility | 8/10 | 5/6 self-contained; Fig 5 caption stale (C4) |
| 7. Three-channel coherence | 7/10 | Table 3 orphan; outcome-name mismatch (C2) |
| 8. Heterogeneity table clarity | 7/10 | Monotonicity readable but 4-bin theory vs 5-bin empirics (M8) |
| 9. Pre-trends verifiability | 7/10 | Stated but not numerically extractable from Fig 3 (M9) |
| Cross-table numeric consistency | 7/10 | +1,151 vs +1,122 drift §5↔§6 (M1); Fig 5 2.2% vs 39% (C4); op_cost vs op_cost_ex_rent (C2) |
| **Weighted total** | **8.0 / 10** | (+4.0 vs initial 4/10) |

---

## Top-5 priority fixes to reach ≥ 8.5

1. **(C2)** Rebuild `tab_main_did_rd_en.tex` to report op_cost_ex_rent (matching CH4 table column 2 and §6 prose), OR clearly distinguish the two in caption and add an explicit prose callout. Fix coef labels.
2. **(C3 + N7)** Add a `\ref{tab:main_specA_en}` (or `tab:main_didrd_en` after renaming) in §6 prose near line 365 — table currently `\input{}`-ed but unreferenced.
3. **(M1)** Change §5 line 341 from "+1,122 m² (p=.041)" to "+1,151 m² (p=.036)" — the symmetric-sample number. Keep +1,122 only in §7.3 (line 443).
4. **(C4)** Rewrite Fig 5 caption — replace "2.2%" with "39%" symmetric-vs-area-only median absolute percentage shift.
5. **(M3)** State the Holm-family unambiguously — exactly which 4 outcomes are in the primary family and whether table stars are raw or Holm-adjusted. Per-table footer note.

After these, score projects to **8.7–9.0** (clears the 8.5 target).

---

## Items deferred to other lenses

- Theory↔empirics partition (M8, 4 vs 5 bin) cross-references Lens 2/3 (theory + identification).
- HonestDiD M̄* = 0 robustness narrative — Lens 5 (robustness).
- Wild-cluster bootstrap B=999 vs B=9,999 — Lens 5.
- Stale "Wave-5 narrative" footers (N1) — touch Lens 6 (prose) too.

**Lens 4 final score: 8.0 / 10 (target 8.5; +4.0 over initial 4/10).**
