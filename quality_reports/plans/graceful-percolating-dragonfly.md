# Phase 1 Blockers — Implementation Plan

**Date:** 2026-05-20
**Status:** DRAFT (pending approval)
**Cross-reference:** `quality_reports/seven_pass_main_en/_SYNTHESIS.md` (composite 6.4/10, REVISE-MAJOR)
**Estimated time:** 7–9 days (3–4 days R re-estimation + 3–4 days paper revision + 1 day verification)
**Branch (proposed):** `feat/wave9-phase1-blockers` off `main` @ `50fadf0`

---

## Context

The 2026-05-20 `/seven-pass-review` flagged 21 CRITICAL findings collapsing to 10 distinct blockers (X1–X10 + 2 bonuses). The composite 6.4/10 is well below the AJAE first-submission gate (9.0/10). Without resolution, the paper would either (a) be desk-rejected for `$D_i$` definitional ambiguity + missing headline tables, or (b) draw fatal referee fire on "sharp DiD-RD restored" identification framing and SUTVA defense.

Per user decisions (2026-05-20 AskUserQuestion answers):

| Decision | Choice | Implication |
|---|---|---|
| Q1 op_cost canonical | **B**: `op_cost_ex_rent` primary (CLAUDE.md updates) | Paper §3/§5/§6 already uses this; CLAUDE.md / MEMORY.md / `r-code-conventions.md` §10 updated to match. No paper rewrite for the variable name itself; `tab_main_did_rd_en.tex` (which uses `op_cost`) retained as supplementary omnibus. |
| X4 framing | **A**: Symmetric screening (re-estimate) | Control side also screened on (ii)+(vi). New `_outputs_symmetric/` directory; full re-estimation of headline DiD-RD + heterogeneity + CH4 + Spec B + balance + attrition. **Sample size will shrink** → SE risk on F1 monotone gradient. |
| X5 sgg_cd | **A**: Actual R re-estimation | New `04b_sgg_robustness.R` script; 4 outcomes × 3 BW × 2 specs = 24-cell robustness table |
| Spec B/C | **C**: Both | `tab_specB.tex` (drop 2020, Post≥2021 — already exists) retained; new `tab_specC.tex` (covariate-rich: farm-type FE + education tier) generated |

**Outcome of Phase 1:** composite ≥ 8.5/10 (excellence threshold, Phase 2/3 polish before AJAE submission).

---

## Critical pre-implementation risk

**X4 symmetric screening may attenuate or eliminate the F1 monotone-gradient headline result.**

- Current headline (Wave 7 asymmetric): pure-tenant own-area response = +1,122 m² at T2, p=.041, monotone-decreasing across four non-pure-owner bins.
- Symmetric sample will drop ineligible-on-(ii)+(vi) households on the **control side** (area > 5000 m² but owned-total ≥ 15.5K or off-farm income ≥ 45M). These are likely "larger" farms — landlords renting out land, off-farm-income-rich households.
- Removing them from control → reduces SE precision AND removes the natural "non-credit-constrained landlord" comparator that makes the F1 wealth-bias mechanism identifiable.
- **Risk:** If +1,122 m² T2 p moves above .10, F1 "does not fire" no longer holds → narrative reframe: the wealth-bias channel is no longer rejected.
- **Mitigation:** Stop the implementation after Phase 1A Step 4 (symmetric main estimation) and present the new headline to the user before paper rewriting. If F1 attenuates, user decides between (i) accepting the new headline + reframing narrative, (ii) reverting to asymmetric with reframed identification text (Option C in original AskUserQuestion).

---

## Phase 1A — R-side re-estimation (3–4 days)

### Step 1: Update CLAUDE.md / MEMORY.md / r-code-conventions.md (op_cost_ex_rent canonical)

**Files to modify (3):**

1. `CLAUDE.md` line ~85 (Identification Strategy section, "Primary outcomes" line) — swap `op_cost` ↔ `op_cost_ex_rent` roles. The new line reads: "Primary outcomes: `op_cost_ex_rent` (operating cost net of rent, lumpy-investment (S,s) test, primary); `off_farm_income` (precautionary labor); `consumption` (smoothing); `farm_income` (omnibus). Auxiliary: `op_cost` (full operating cost, omnibus — reported alongside as the rent-inclusive comparator); `rent_cost`, `area_rent`, `unit_rent_price` (CH4 rent-pass-through decomposition channel)."
2. `.claude/rules/r-code-conventions.md` §10 row 6 — same swap, with note "primary changed from `op_cost` to `op_cost_ex_rent` on 2026-05-20 per Phase 1 Blockers decision Q1B (cleaner (S,s) test, removes Kirwan pass-through contamination)".
3. `MEMORY.md` — add `[LEARN:methods]` entry at end of file: "Primary lumpy-investment outcome for the (S,s) test was changed from `op_cost` (full) to `op_cost_ex_rent` (rent-net) on 2026-05-20. The rent-net version removes the Kirwan pass-through contamination from the lumpy-capital signal; the rent-net component is studied separately in the CH4 channel decomposition. CLAUDE.md + r-code-conventions.md §10 updated. The 2026-05-06 LEARN entry remains historical."

**No R script changes in this step** — the existing `03_did_rd.R` already estimates both `op_cost` and `op_cost_ex_rent`. The CH4 decomposition table already has `op_cost_ex_rent`. The change is purely about which is "primary" in the paper narrative.

### Step 2: Create `scripts/R/01d_symmetric_clean.R` (NEW)

**Purpose:** Construct symmetric-screening panel — control side also passes (ii)+(vi).

**Pattern:** Follow `01c_subset_clean.R` (reads `_outputs/clean_with_eligibility.rds`, filters, writes to a new OUT_DIR).

**Filter rule:**
```r
# Symmetric screening: both sides screened on (ii)+(vi) regardless of (i)
df_sym <- df_full |>
  dplyr::filter(
    area_owned_total_2018 < 15500,     # criterion (ii) — observable
    off_farm_income_2018  < 45000000   # criterion (vi) — observable
  )
```

**Sanity checks (must hold, else stop):**
- Within-subset sharp: `D_eligible_obs_2018 == (rv_2018 <= 0)` for all obs (since (i) alone determines D_eligible on the screened sample).
- Treated count: ≥ 1,131 hh (same as `_outputs_eligibility/clean.rds`, since treated side is unaffected by screening — treated-side already satisfies (ii)+(vi)).
- Control count: < 2,289 hh (will be smaller than Wave 7 control count of 2,289 because control households failing (ii) or (vi) are now dropped).

**Output:** `scripts/R/_outputs_symmetric/clean.rds` (mirror of `_outputs_eligibility/clean.rds` schema)

**Sample waterfall logged to `_outputs_symmetric/sample_waterfall.txt`:**
- Start: 3,420 hh / 13,689 obs (Wave 7)
- After dropping control-side (ii)+(vi)-ineligible: ??? hh / ??? obs (to be computed)
- Treated unchanged: 1,131 hh / ??? obs
- Control retained: ??? hh / ??? obs
- Treated share: % (vs. 0.312 in Wave 7)

### Step 3: Create `scripts/R/run_symmetric_pipeline.R` (NEW)

**Purpose:** Wrapper sourcing 02–10 with OUT_DIR=`_outputs_symmetric/` (mirrors `run_eligibility_pipeline.R`).

**Difference from `run_eligibility_pipeline.R`:** OUT_DIR points to `_outputs_symmetric/`, no other change. Scripts 02_descriptive.R through 10_alpha3_estimation.R read `clean.rds` from `OUT_DIR` and write tables/figures back to `OUT_DIR` via the `pipeline_env$OUT_DIR` injection pattern.

**Time:** ~5 minutes (one-shot serial execution).

### Step 4: STOP — present symmetric main results to user

**Mandatory checkpoint before Phase 1B starts.** After Step 3 completes, read `_outputs_symmetric/main_results.rds` (or equivalent) and `_outputs_symmetric/het_own_share.rds` and present:

- Pure-tenant own-area T2 coefficient + p-value (was: +1,122 m², p=.041)
- Four-bin gradient monotonicity (was: 1,122 → 403 → 222 → −74 → 0)
- op_cost_ex_rent T1 coefficient + p-value (was: −3.98M, p=.057)
- CH4 rent_cost T2 coefficient (was: −12.0% pass-through, p=.133)
- New sample N

**User decides:**
- If results survive (F1 monotone gradient still fires at p<.10): proceed to Phase 1B with new magnitudes.
- If F1 attenuates: stop. User chooses (i) accept new headline + narrative reframe, or (ii) revert to asymmetric Wave 7 with reframed identification text only (cheaper).

### Step 5: Create `scripts/R/04b_sgg_robustness.R` (NEW)

**Purpose:** Run sgg_cd × Post FE robustness on the chosen sample.

**Specification:**
```r
# Within hh + year FE, sub-district × Post interaction
m_sgg <- feols(
  outcome ~ D_treat * Post + i(sgg_cd, Post, ref = NA) | hh_id + year,
  cluster = ~sgg_cd,
  data = df_bw
)
```

(Alternative: `i(sgg_cd, Post)` adds sub-district-specific time effects, absorbing village-level rental-market clearing that the scalar Post FE cannot. Cluster shifts from `hh_id` to `sgg_cd` per the SUTVA-spillover concern.)

**Outputs:**
- `tab_sgg_robustness_en.tex` (24-cell: 4 outcomes × 3 BW × 2 specs)
- `sgg_results.rds`

**Verify:** Coefficient direction preserved on the 4 primary outcomes (op_cost_ex_rent, off_farm_income, consumption, farm_income). If sign flips on a primary outcome, escalate as a finding for Phase 1B narrative.

### Step 6: Add Spec C (covariate-rich) to `03_did_rd.R` (or `03d_specC.R`)

**Specification:**
```r
# Spec C: Spec A + farm-type FE (farm_type_cd) + education tier (edu_tier)
m_C <- feols(
  outcome ~ D_treat * Post * (rv_2018 / 1000) + i(farm_type_cd) + i(edu_tier) | hh_id + year,
  cluster = ~hh_id,
  data = df_bw
)
```

**Verify:** `farm_type_cd` and `edu_tier` exist in `clean.rds`. If not, this step requires raw FHES data merge — escalate as blocker before Phase 1B.

**Output:** `tab_specC.tex` (Spec C analogue of `tab_specB.tex`)

### Step 7: Regenerate Wave 7 outputs in symmetric directory

After Steps 2–6, the following files in `_outputs_symmetric/` must exist and match expected schemas (verified against `_outputs_eligibility/` shapes):

- `clean.rds` (Step 2 output)
- `desc_summary.rds` + `tab_descriptives_en.tex` (Step 3 via `02_descriptive.R`)
- `main_results.rds` + `tab_main_did_rd_en.tex` (Step 3 via `03_did_rd.R`)
- `tab_ch4_rent_decomposition_en.tex` (Step 3 via `06_channels.R` or `08_p3c_decomposition.R`)
- `tab_het_own_share_en.tex` (Step 3 via `07_heterogeneity.R`)
- `tab_specB.tex` (Step 3 via `03_did_rd.R`)
- `tab_specC.tex` (Step 6)
- `tab_sgg_robustness_en.tex` (Step 5)
- `tab_dropped_balance_en.tex`, `tab_attrition_placebo_full_en.tex`, `tab_placebo_cutoffs_en.tex` (Step 3)
- `alpha3_results.rds`, `desc_summary.rds`, `mccrary_test.rds`, etc. (Step 3)
- All `fig_*_en.{pdf,png}` (Step 3 via `05_figures.R`)
- `sessionInfo.txt` (per `r-code-conventions.md` §12)

**Replication-protocol Phase 3 check (tolerance < 0.01 for point estimates, < 0.05 for SEs):** new outputs are NOT replications of prior outputs — symmetric sample is different — so the tolerance check applies only within the new pipeline (consistency across scripts on same sample). Document this in `quality_reports/replication_phase1_blockers.md`.

---

## Phase 1B — Paper text revision (3–4 days)

### Step 8: Update §2.1 — fix line 70 SFFP/ABP mutual-exclusivity contradiction (X6)

**Site:** `paper/en/main.tex` line 70.

**Current:** "At the 0.5-hectare cutoff itself, the marginal household receives the 1,200,000 KRW flat amount on the SFFP side **and** approximately 985,000 KRW on the ABP side..."

**New:** "The two branches are mutually exclusive at the household level: an SFFP-eligible household does NOT receive ABP. At the 0.5-hectare cutoff, the marginal SFFP-eligible household receives 1,200,000 KRW (flat); the counterfactual ABP transfer for a household just above the cutoff (i.e., area > 0.5 ha) is approximately 985,000 KRW (computed at the 1,970,000 KRW/ha base rate on 0.5 ha at the discontinuity). This yields a discrete transfer jump of approximately 215,000 KRW per year at the cutoff."

### Step 9: Update §4 Table 1 row 1 + §4 line 311 — `$D_i$` definitional reconciliation (X3)

**Sites:** `paper/en/main.tex` line 110 (Table 1 row), line 311 (§4 equation), line 313 (sharp claim).

**Table 1 row 1 (line 110) — new:**
> "$D_i$ — Statutorily-eligible indicator; the conjunction of three FHES-observable SFFP criteria (cultivated area ≤ 0.5 ha, household-aggregate owned farmland < 1.55 ha, household off-farm income < 45M KRW), all fixed at 2018 baseline. Defined formally in equation (D_i-def), §4. Within the analysis sample (3,420 farms / 13,689 obs, see §4 sample restriction), $D_i = 1 \iff rv_{2018,i} \le 0$ by construction. The area-only variant $D_i^{\text{area}}$ used in the §7.1 robustness is defined separately."

**§4 line 311 — new (label the equation):**
```latex
\begin{equation}\label{eq:Di-def}
D_i = \mathbf{1}\{rv_{2018,i} \le 0\} \cdot \mathbf{1}\{A_{\text{owned},2018,i} < 15{,}500 \text{ m}^2\} \cdot \mathbf{1}\{Y_{\text{off},2018,i} < 45{,}000{,}000 \text{ KRW}\}
\end{equation}
```

**§4 line 313 — remove "sharp DiD-RD restored" (X4 + Step 10):**

If user-decision was A (symmetric screening, Step 4 succeeded), the §4 line 313 text becomes:
> "We apply the same observable-eligibility screening on both sides of the cutoff: households failing criteria (ii) or (vi) are dropped from both the treated and control groups. The resulting analysis sample of {N_sym} farms ({obs_sym} farm-years) is symmetric in observable eligibility around the cutoff. On this sample, $D_i = 1 \iff rv_{2018,i} \le 0$, yielding sharp DiD-RD identification at the area cutoff among households satisfying the SFFP observable-eligibility criteria. The estimand is the ITT of statutory SFFP eligibility on the population passing the three FHES-observable criteria."

If user-decision was C-fallback (reframe without re-estimation), the text becomes:
> "Among area-eligible households, 14.6% (194 of 1,325) fail criteria (ii) or (vi) and are dropped. The control side is not subject to this screening; therefore, the analysis sample is not symmetric in observable eligibility around the cutoff. The estimand is the ITT of statutory SFFP eligibility on a subpopulation conditional on observable eligibility on the treated side. We acknowledge that the previous wording ('restoring sharp DiD-RD') overstated the identification claim; the asymmetric-sample design retains a fuzzy RD interpretation in observable-eligibility space."

### Step 10: Update §4 line 317 — Table 1 magnitude correction (X2)

**Site:** `paper/en/main.tex` line 317.

**Current (incorrect):** "control-group ($D_i = 0$) operating cost averages 41.1M KRW versus the statutorily-eligible group ($D_i = 1$) average of 13.6M KRW (difference −27.5M KRW)..."

**New (after Step 7 regenerates Table 1 on symmetric sample):**

After reading new `_outputs_symmetric/desc_summary.rds`:
- Control op_cost_ex_rent mean: NEW_VAL (was 30.0M on Wave 7 → ??? on symmetric)
- Treated op_cost_ex_rent mean: NEW_VAL (was 8.4M on Wave 7 → ??? on symmetric)
- Difference: NEW_VAL
- Off-farm income mean: NEW_VAL

Quote the new numbers verbatim. Update §6 line 359 "$-29\%$ relative to 13.6M" to use the new treated-group mean denominator.

### Step 11: §6 — `\input{}` the three missing headline tables (X1b)

**Sites:** Insert `\input{}` calls at appropriate positions in §6 / §7.

**Currently the prose references `Table~\ref{tab:appB-mapping}` (line 350) — this table is defined only in the online appendix.** Move the F1 four-bin gradient table (`tab_het_own_share_en.tex`) into main text:

```latex
\begin{table}[!h]
\centering
\input{../../scripts/R/_outputs_symmetric/tab_het_own_share_en.tex}
\end{table}
```

Add the pooled DiD-RD table after §6's headline paragraph:

```latex
\begin{table}[!h]
\centering
\input{../../scripts/R/_outputs_symmetric/tab_main_did_rd_en.tex}
\end{table}
```

Add the CH4 rent-decomposition table after the discussion of $\hat\beta_5$:

```latex
\begin{table}[!h]
\centering
\input{../../scripts/R/_outputs_symmetric/tab_ch4_rent_decomposition_en.tex}
\end{table}
```

Update `\ref{tab:appB-mapping}` → `\ref{tab:het_own_share_en}` throughout.

### Step 12: §5 line 339 + §5 line 343 — sgg_cd × Post FE delivery (X5)

**Site:** `paper/en/main.tex` line 339 (Inference paragraph) + line 343 (SUTVA paragraph).

**Line 339 — change "Sub-district clustering is reported in §7 as a robustness check" to:**
> "Sub-district ($sgg\_cd$) clustering with sub-district-by-Post fixed effects is reported in §\ref{sec:robustness} (Table~\ref{tab:sgg_robustness_en}) as a robustness check addressing within-village rental-market spillovers."

**Line 343 — rewrite the SUTVA defense (second numbered argument):**
> "Second, Korean rural-rental markets clear at the village-or-district level. To absorb this spillover, we re-estimate (\ref{eq:didrd-main}) with sub-district-by-Post fixed effects ($\zeta_{k,s,t}\, \mathbf{1}\{sgg\_cd_i = s\} \cdot \text{Post}_t$) and cluster standard errors at the sub-district level. Results (\S\ref{sec:robustness}, Table~\ref{tab:sgg_robustness_en}) preserve the headline sign on all four primary outcomes and remain significant for the F1 monotone-gradient claim. The scalar-Post specification in (\ref{eq:didrd-main}) absorbs only common time shocks; the village-by-time absorption operates through the sgg_cd × Post robustness."

Insert `\input{tab_sgg_robustness_en}` in §7 after the existing robustness paragraphs.

### Step 13: §7.1 — Area-only robustness demotion narrative (X7)

**Site:** `paper/en/main.tex` line 423 (§7.1 paragraph opening).

**Insert preamble (4 sentences) before existing content:**
> "**Why area-only as robustness.** The Wave 5 baseline of this analysis used the area-only treatment definition $D^{\text{area}}_i = \mathbf{1}\{A_{2018,i} \le 5{,}000 \text{ m}^2\}$. Wave 7 promoted the three-criterion conjunction $D_i$ to the main analysis to align the empirical treatment indicator with the statutory SFFP eligibility definition (\S\ref{sec:institutional-eligibility}), not because the area-only finding was empirically weaker. The 24-cell coefficient comparison shows zero cells crossing the $\alpha = .05$ significance boundary between the two treatment definitions (full comparison in `treatment_definition_comparison.md`, replication package). We retain the area-only definition as a robustness check for readers who interpret the 0.5 ha cutoff as the institutional gate and consider the additional (ii)+(vi) criteria as auxiliary."

### Step 14: §7.2 — Spec B (temporal) + Spec C (covariate-rich) as two paragraphs (X10)

**Site:** `paper/en/main.tex` line 407–409 (current Spec B paragraph + `\input{}`).

**Rewrite as two paragraphs:**

```latex
\paragraph{Alternative spec — temporal restriction (Spec B).}
Spec B drops the 2020 transition year and restricts the post-period to 2021–2022, removing
the PIDPS implementation year from the panel. The headline F1 monotone-gradient sign is
preserved with point estimates within X\% of Spec A (Table~\ref{tab:specB}).

\begin{table}[!h]
\centering
\input{../../scripts/R/_outputs_symmetric/tab_specB.tex}
\end{table}

\paragraph{Alternative spec — richer covariate vector (Spec C).}
Spec C substitutes a richer pre-period covariate vector in place of Spec A's parsimonious set,
adding farm-type fixed effects ($i$.farm\_type\_cd) and head-of-household education-tier
indicators ($i$.edu\_tier). The F1 monotone-gradient sign and magnitude are preserved within
Y\% (Table~\ref{tab:specC}).

\begin{table}[!h]
\centering
\input{../../scripts/R/_outputs_symmetric/tab_specC.tex}
\end{table}
```

Fill in X and Y after reading the new outputs.

### Step 15: §7 — HonestDiD breakdown defense expansion (X8)

**Site:** `paper/en/main.tex` line 398.

**Expand the single-sentence defense to a paragraph (~120 words):**

> "We acknowledge the HonestDiD breakdown $\bar M^* = 0$ — the 95% CI on the event-study post-period coefficient includes zero already under the no-trend-violation baseline. Three observations frame this finding. First, the event-study specification on a single pre-period (2018→2019) is underpowered relative to the cross-bandwidth pooled DiD-RD (\ref{eq:didrd-main}), where the F1 monotone-gradient test draws power from the cross-bin gradient comparison, not from the post-period coefficient magnitude. Second, the 2018 placebo coefficients on $A_{\text{own}}$ are individually small ($|t| < 1$) across the four non-pure-owner bins (Figure~\ref{fig:event_study_area_own_T2_en}), consistent with parallel pre-trends. Third, the headline identification draws on the 2018-baseline freeze, which rules out post-policy manipulation by construction (the running variable is fixed in pre-treatment time). The HonestDiD breakdown is a feature of the event-study test's power, not evidence of trend violation; the headline DiD-RD remains identified under the maintained assumptions stated in §\ref{sec:identification}."

### Step 16: Abstract rewrite ≤200 words with magnitudes + contribution (X9)

**Site:** `paper/en/main.tex` lines 32–35.

**New abstract (≤200 words, with placeholder slots for symmetric magnitudes):**

> "Korea's 2020 Public-Interest Direct Payment Scheme transfers 1.2 million KRW per year to smallholders below a 0.5-ha eligibility cutoff under a per-farm flat-rate design, distinct from the area-proportional U.S. and EU CAP schedules. We test the Agricultural Household Model's separability null at this cutoff using a difference-in-differences regression-discontinuity design on the FHES panel ($N = N\_sym$ farm-years, $K\_sym$ farms, 2018–2022), with symmetric observable-eligibility screening on both sides of the cutoff. Two AHM extensions yield falsifiable predictions: wealth-biased liquidity predicts a monotone-in-baseline-tenancy gradient on own-cultivated area (F1, primary); implicit-labor supervision predicts a hired-labor margin response (F2, auxiliary). We find a pure-tenant own-area response of $+X$ m² at the T2 bandwidth ($p = p_1$), monotone-decreasing across four non-pure-owner bins, with a negative operating-cost-net-of-rent response of $-Y$ M KRW at T1 ($p = p_2$) consistent with $(S,s)$ inaction. The per-farm flat-rate design reverses the rent-pass-through documented for area-proportional schedules in the U.S. (+25%; Kirwan 2009) and EU (+46–55%; Baldoni-Ciaian 2023): pass-through here is $-Z\%$. We reject AHM separability at the 0.5-ha cutoff for the credit-constrained non-pure-owner subpopulation via the wealth-biased liquidity channel; the per-farm payment design itself is the policy lever."

Fill X / Y / Z / p_1 / p_2 / N_sym / K_sym after Step 4 / Step 7.

### Step 17: §1 intro — promote headline numbers + contribution paragraph (X9 cross-effect)

**Site:** `paper/en/main.tex` lines 48–60 (intro paragraphs).

**Move headline magnitudes from ¶5 to ¶1 (Lens 2 M-1).** Move contribution paragraph from ¶6/7 to ¶4 (Lens 2 C-2). This restructure was flagged by Lens 2 with a 10-move concrete recommendation — apply in this step. Target intro length: ~825 words (Lens 2 target), down from current 1,520. Cut the §5-prose-dropped-into-intro material at ¶4 (Lens 2 C-3) — referee will read it in §5 anyway.

### Step 18: Propagate magnitude updates through §6 / §8 / §9

**Sites:** `paper/en/main.tex` lines 350, 359, 363, 446–457 (and any line referencing the headline magnitudes).

For every numeric claim in main text, replace the Wave 7 value with the corresponding `_outputs_symmetric/` value. Use `/audit-reproducibility paper/en/main.tex scripts/R/_outputs_symmetric/` as a forcing function in Phase 1C.

### Step 19: Resolve op_cost_ex_rent notational drift to canonical (X1)

**Sites:** Lens 6 C-3 listed lines 34, 54, 56, 180, 216, 261, 267, 276, 315, 333, 359, 389, 394, 411, 446, 457. Pick **"operating cost net of rent"** in prose, **`$\text{op\_cost\_ex\_rent}$`** in math. Replace:

- Line 315 ("operating cost" / `op_cost`) → "operating cost net of rent" + `$\text{op\_cost\_ex\_rent}$`
- Lines 389, 394 (Figure caption) → "operating cost net of rent"
- All hyphenated "operating-cost-net-of-rent" (lines 34, 56) → "operating cost net of rent" (no hyphens — Chicago Manual 7.86)
- Add a sentence to §4 line 315 explicitly noting that `op_cost` (full operating cost, including rent) is reported alongside as the rent-inclusive omnibus comparator in `tab_main_did_rd_en.tex`.

---

## Phase 1C — Verification (1 day)

### Step 20: Compile + overfull hbox check

```bash
cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex
```

**Pass criteria:**
- Exit 0
- Overfull hbox count ≤ 1 (Wave 8 baseline)
- Undefined references / citations: 0

### Step 21: `/audit-reproducibility`

```bash
/audit-reproducibility paper/en/main.tex scripts/R/_outputs_symmetric/
```

**Pass criteria (per `replication-protocol.md` Phase 3 tolerance):**
- Every numeric claim in main text within < 0.01 of corresponding `_outputs_symmetric/*.rds` value (point estimates)
- Every standard error within < 0.05
- Every N exact match
- Every percentage within < 0.1pp

**Any FAIL → return to Step 18 (magnitude propagation) and fix.**

### Step 22: `/seven-pass-review` post-revision gate

```bash
/seven-pass-review paper/en/main.tex
```

**Pass criteria for end of Phase 1:**
- Composite ≥ 8.5/10 (target; gates Phase 2 polish)
- All 10 Phase-1 CRITICALs resolved (X1–X10)
- No NEW CRITICALs introduced

Save the new `_SYNTHESIS.md` to `quality_reports/seven_pass_main_en/_SYNTHESIS_post_phase1.md` for diff against this run.

### Step 23: Save session log + commit

`quality_reports/session_logs/2026-05-20_phase1-blockers.md` per `templates/session-log.md` — incremental log throughout Phase 1A/1B, end-of-Phase summary, learnings via [LEARN] entries to MEMORY.md.

`/commit` invocation with commit body referencing this plan + Step 22 score. Expected score: ≥ 8.5/10. Score gate threshold per `quality-gates.md` is 80 for commit; submission is 90.

---

## Files to modify (summary)

**R scripts (5 new):**
- `scripts/R/01d_symmetric_clean.R` (NEW)
- `scripts/R/run_symmetric_pipeline.R` (NEW)
- `scripts/R/04b_sgg_robustness.R` (NEW)
- `scripts/R/03d_specC.R` (NEW; or extend `03_did_rd.R`)
- *(existing 02–10 scripts: no source change, just re-run under OUT_DIR=`_outputs_symmetric/`)*

**Rule / memory updates (3):**
- `CLAUDE.md` (Step 1: op_cost_ex_rent canonical)
- `.claude/rules/r-code-conventions.md` (Step 1: §10 swap)
- `MEMORY.md` (Step 1: [LEARN:methods] entry)

**Paper text (1, but many sites):**
- `paper/en/main.tex` — Steps 8–19 touch lines 32–35 (abstract), 48–60 (intro), 70 (SFFP/ABP), 110 (Table 1), 311–313 ($D_i$ def + sharp claim), 317 (Table 1 magnitudes), 339 (sgg_cd promise), 343 (SUTVA), 350 (Table ref), 359/363 (magnitudes), 389/394 (figure captions), 398 (HonestDiD), 407–409 (Spec B/C), 411 (balance), 423 (§7.1 narrative), 446–457 (discussion magnitudes).

**Outputs regenerated:**
- `scripts/R/_outputs_symmetric/` — full mirror of `_outputs_eligibility/` schema, on symmetric sample.

---

## Quality-gate exit criteria

| Gate | Threshold | Where enforced |
|---|---|---|
| R script syntax + reproducibility | All scripts exit 0; `set.seed(20260504L)` honored | Phase 1A Step 7 |
| Replication-protocol Phase 3 tolerance | Point < 0.01, SE < 0.05, N exact, % < 0.1pp | Phase 1C Step 21 |
| XeLaTeX compile | Exit 0, overfull ≤ 1, no undefined ref/cite | Phase 1C Step 20 |
| Composite quality score | ≥ 8.5/10 (target) | Phase 1C Step 22 |

## Verification — how to test end-to-end

1. Run `Rscript scripts/R/01d_symmetric_clean.R` — verify `_outputs_symmetric/clean.rds` exists with N≥ some lower bound and sharp-RD property holds.
2. Run `Rscript scripts/R/run_symmetric_pipeline.R` — verify all expected .rds / .tex files created in `_outputs_symmetric/`.
3. Run `Rscript scripts/R/04b_sgg_robustness.R` — verify `tab_sgg_robustness_en.tex` exists.
4. Run `Rscript scripts/R/03d_specC.R` (or equivalent) — verify `tab_specC.tex` exists.
5. Run `latexmk -xelatex -interaction=nonstopmode paper/en/main.tex` — verify exit 0.
6. Run `/audit-reproducibility paper/en/main.tex scripts/R/_outputs_symmetric/` — verify zero tolerance FAILs.
7. Run `/seven-pass-review paper/en/main.tex` — verify composite ≥ 8.5.

---

## What this plan does NOT cover (deferred to Phase 2/3)

- Lens 1 minor abstract polish ("load-bearing" jargon, USD equivalent)
- Lens 2 intro length trim from ~825 → final polish
- Lens 3 covariate-continuity (CCT 2014) + Cattaneo-Jansson-Ma rddensity (these are NEW robustness checks, not blocker fixes — Phase 2)
- Lens 6 sentence-length splitting (15+ long sentences) — Phase 2
- Lens 6 "statutorily-eligible" hyphen drop (16+ instances) — Phase 3
- Lens 7 unused-bib-entry decision (10 entries) — Phase 3
- Three-channel framing decision (drop vs formalize decomposition) — depends on Step 4 outcome; deferred

---

## Stop conditions (immediate user check-in)

1. **Phase 1A Step 4:** Symmetric main result departs materially from Wave 7 headline → user decides reframe vs revert.
2. **Phase 1A Step 5:** sgg_cd × Post FE sign flips on a primary outcome → user decides whether to keep or move the SUTVA narrative.
3. **Phase 1A Step 6:** `farm_type_cd` or `edu_tier` missing from `clean.rds` → escalate as data-merge blocker.
4. **Phase 1B Step 16/17:** Abstract / intro restructure produces a draft that diverges from CLAUDE.md three-channel framing → user decides between current framing and dropped framing.
5. **Phase 1C Step 22:** Composite < 8.0 after all Phase-1 work → diagnose which Phase-1 step under-delivered; do NOT proceed to Phase 2 commit.
