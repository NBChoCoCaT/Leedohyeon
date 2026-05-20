# Lens 4 — Results & Tables (post Phase 1.5b)

**Manuscript:** `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex`
**Date:** 2026-05-20
**Reviewer:** Lens 4 (results & tables), fourth seven-pass review (post Phase 1.5b)
**Scope:** §5 Empirical Strategy (lines 327–348), §6 Results (lines 351–378), §7 Robustness (lines 381–468), with cross-checks against §1 Abstract, §3 Theory pre-specifications, and table `\input{}`s.
**Carry-forward:** Phase 1.5 score on §6 was 8.7/10. Phase 1.5b made no §6-targeted changes. The task is to sanity-check that 8.7 holds and to assess each of the four Phase-2-carry-forward MAJORs (M3, M7, M8, M9) as RESOLVED, PARTIAL, or OPEN.

---

## Summary scorecard

| Item | Status post-1.5b | Notes |
|------|------------------|-------|
| M3 — Holm family declaration | **RESOLVED** | Family of four outcomes declared in §5 ¶ "Inference" (L344), echoed in §6 ¶ "Operating-cost" (L366) and §7 ¶ "Wild cluster bootstrap" (L400). |
| M7 — T3 MSE per-outcome bandwidth in prose | **PARTIAL** | A single representative value ($h \approx 3{,}300$ m²) appears once at L355; per-outcome T3 bandwidths still pushed to the table. |
| M8 — §3 four-bin vs tables five-bin partition | **OPEN** | Internal inconsistency persists: §3 calls it a four-bin partition (L58, L121, L213, footnote), §5 (L342) and §3 (L264, L320) call it five-bin; tables uniformly report five bins. |
| M9 — |t|<1 pre-trends anchor | **RESOLVED** | Anchored at L404 (event-study) and L415 (bin-specific 2018 placebo). |

**Net §6 score (post-1.5b):** **8.7 / 10** — unchanged from Phase 1.5. M8 is the only remaining drag and is shared with Lens 2/3 narrative-consistency lens (cross-listed below).

---

## 1. Sanity check — Phase 1.5 score 8.7 holds

The Results section (L351–378) is unchanged in substance between Phase 1.5 and Phase 1.5b. Spot-checks:

- **Headline numbers preserved.** Pure-tenant $A_{\text{own}}$ at T2 = $+1{,}151$ m² ($p = .036$); low-owner $+438$ ($p = .047$); four-bin gradient $+1{,}151 \to +438 \to +258 \to -52 \to 0$ (L355, L362 caption, L378 footnote). These are consistent with the abstract (L36) and the conclusion (L486).
- **Operating-cost claims preserved.** $-3.57$M KRW at T1, SE $2.19$M, raw $p \approx .10$; $-2.62$M at T2, SE $1.96$M, $p \approx .18$ (L366). Multiple-testing language (`not significant after Holm step-down`) is intact.
- **Rent pass-through preserved.** $-13.7\%$ at T1 ($\hat\beta_5 = -164{,}927$ KRW, $p < .10$); $-11.7\%$ at T2 ($-139{,}904$, NS) (L372).
- **Headline finding paragraph (L378) intact** with the strict-AND F1 trigger logic and the 48%/52% non-pure-owner / pure-owner split.

All four primary-outcome table `\input{}` paths point to `scripts/R/_outputs_symmetric/` (lines 357, 368, 374), consistent with the symmetric-screening main design.

**Verdict:** §6 quality is unchanged from Phase 1.5. Baseline score 8.7 is the appropriate floor.

---

## 2. M3 — Holm step-down family declaration (RESOLVED)

**Phase 1 issue:** the Holm step-down family was applied without an explicit declaration of the outcome family.

**Status (post-1.5b):** Resolved by three coordinated declarations.

- **§5 ¶ "Inference" (L344):** "Across the primary outcome family (the four outcomes: $A_{\text{own}}$, $\text{op\_cost\_ex\_rent}$, $\text{off\_farm\_income}$, and $\text{consumption}$ or $\text{farm\_income}$ as the omnibus), we apply Holm step-down correction to control the family-wise error rate."
- **§6 ¶ "Operating-cost sub-prediction" (L366):** "raw $p \approx .10$; not significant after Holm step-down across the four-outcome primary family".
- **§7 ¶ "Wild cluster bootstrap" (L400):** "Holm step-down is applied across the primary outcome family."

**Residual minor:** the family description in L344 carries a small ambiguity — "$\text{consumption}$ or $\text{farm\_income}$ as the omnibus" reads as if the fourth slot is one-or-the-other. A reader who counts strictly will see either four or potentially five outcomes. Recommend tightening to "four outcomes ($A_{\text{own}}$, $\text{op\_cost\_ex\_rent}$, $\text{off\_farm\_income}$, plus a single omnibus indicator — either $\text{consumption}$ or $\text{farm\_income}$ — fixed ex ante)". This is **MINOR**, no Phase 2 deduction at the 90 threshold.

---

## 3. M7 — T3 MSE per-outcome bandwidth in prose (PARTIAL)

**Phase 1 issue:** T3 bandwidth is MSE-optimal per outcome via `rdrobust`, hence each outcome carries its own $h$. Prose used "T3" as if it were a single number, opaque to readers who don't open the table.

**Status (post-1.5b):** Partially resolved.

- **L355** now provides a representative T3 value: "T3 (MSE-optimal $h \approx 3{,}300$~m\textsuperscript{2})". This anchors the magnitude.
- **L385** mentions "$\pm 3{,}300$~m\textsuperscript{2} window returns $p = .36$" in the McCrary context, reinforcing the 3,300 m² order-of-magnitude.
- **L120** (notation table): "T3 (MSE-optimal)" without numeric anchor — acceptable for a glossary entry.

**Residual:** the prose still does not say that T3 bandwidth varies per outcome (i.e., the 3,300 figure is for one specific outcome and bandwidth on other outcomes will differ). A referee who reads carefully will notice the table reports different $h$ per outcome at T3 but the prose collapses them to a single number. For the 90-threshold submission this is acceptable; for the 95-threshold R&R it should be tightened. Recommend a one-clause edit at L355 or L340:

> "T3 (MSE-optimal $h$ via \citealp{CalonicoCattaneoTitiunik2014_rdrobust} computed separately per outcome; $h$ ranges from approximately 2,000 to 4,000 m² across the four primary outcomes — see column header of Table~\ref{tab:main_specA_en})."

**M7 verdict:** Partial. Carries forward to Phase 2 as a low-priority MAJOR.

---

## 4. M8 — §3 four-bin vs tables five-bin partition (OPEN)

This is the **only material §6-adjacent finding** that remains open.

**Internal terminology audit:**

| Location | Wording | Bin count implied |
|----------|---------|-------------------|
| L58 footnote (§3 abstract paragraph) | "pre-specified four-bin rule (pure tenant $s_0 = 0$; low-owner $0 < s_0 \le 0.33$; mixed $0.33 < s_0 \le 0.67$; pure owner $s_0 = 1$)" | **4** (and the listed bins are 4: pure tenant, low, mixed, pure owner — no `high_owner`) |
| L121 (notation table) | "four-bin partition $\{0,\ (0,.33],\ (.33,.67],\ 1\}$" | **4** |
| L204 (§3 aggregation note) | "Operationalized as a discrete four-bin partition" | **4** |
| L213 (§3 prediction expression) | "This four-bin discrete monotonicity in baseline tenancy" | **4** |
| L264 (§3 sample-margin) | "five-bin discreteness of the partition rule" | **5** |
| L276 (§3 prediction-summary table row) | "four-bin $s_{0,i}$ partition" | **4** |
| L289 (§3 F1 trigger definition) | "$s_{0,i} \in \{0,\ (0,.33],\ (.33,.67],\ 1\}$" | **4** (set has 4 elements) |
| L320 (§4 Data) | "the five-bin partition" | **5** |
| L342 (§5 Heterogeneity) | "five baseline-tenancy bins $b(i) \in \{$pure tenant, low\_owner, mixed, high\_owner, pure\_owner$\}$" | **5** |
| L355 (§6 results prose), L362 (figure caption), L378 (footnote), L475/L486 (discussion/conclusion) | five bins listed: pure_tenant, low_owner, mixed, high_owner, pure_owner | **5** |
| `tab_het_own_share_en.tex` | reports five rows | **5** |

**Diagnosis.** The theory (§3) was originally written with a four-bin partition $\{0, (0,.33], (.33,.67], 1\}$, where the rightmost bin ($s_0 = 1$) is the pure-owner anchor and "mixed" covers the upper interior interval $(0.33, 0.67]$. The empirical implementation (§5, §6) introduced a five-bin partition by splitting the interior into low_owner $(0, .33]$, mixed $(.33, .67]$, and high_owner $(.67, 1)$, plus the two endpoint anchors pure_tenant ($s_0 = 0$) and pure_owner ($s_0 = 1$). The §3 footnote at L58 and the prediction expression at L289 still list **only four** of those bins (no `high_owner`).

**Severity.** This is not just a labeling mismatch — the F1 trigger definition at L289 specifies the set $\{0,\ (0,.33],\ (.33,.67],\ 1\}$, which **does not contain a `high_owner` bin** at all. Yet the result the trigger evaluates against (L355) explicitly reports five bins including high_owner $= -52$ at T2. A referee can legitimately ask: which partition is the trigger evaluated against, and was it pre-specified or chosen post-hoc?

The headline reading is unaffected by this: the four non-pure-owner monotone gradient claim collapses cleanly under either partition (pure_tenant > low_owner > mixed > high_owner > pure_owner = 0 is consistent with pure_tenant > low_owner > mixed > pure_owner = 0 if the mixed-or-high_owner bin is the binding constraint). But the pre-specification narrative is wounded.

**Recommended fix (Phase 2, MAJOR):** Decide on five bins as the canonical partition (matches the tables, figures, and all of §5/§6) and rewrite the §3 footnote at L58, the L121 glossary row, L204, L213, L276, and L289 to reference the five-bin partition $\{0,\ (0,.33],\ (.33,.67],\ (.67,1),\ 1\}$. The `four-bin` language at L264 and L320 needs the opposite direction — those already say five-bin; flag as resolved by the upstream §3 edit.

Alternative: keep §3 as four-bin (the theoretical aggregation step) and explicitly note in §5/§6 that the empirical partition further splits the $(0.33, 1)$ interior into low/mixed/high triplets. This is cleaner theoretically but requires a §5 ¶ "Heterogeneity / F1" rewrite at L342 to explain the four→five reconciliation.

**M8 verdict:** OPEN. The cleanest Phase 2 patch is the five-bin canonical resolution. Estimate: 60–90 min of careful §3/§5 editing plus a CoVe pass to confirm no broken footnote cross-refs. This is the binding issue keeping §6 at 8.7 rather than 9.0+.

---

## 5. M9 — |t|<1 pre-trends anchor (RESOLVED)

**Phase 1 issue:** the parallel-trends sanity check was stated informally; the LN-10 gate language was used without an anchored t-statistic threshold.

**Status (post-1.5b):** Resolved at two locations.

- **L404 (event-study paragraph, op_cost outcome):** "The 2018 pre-period coefficient is statistically zero ($|t| < 1$), satisfying the LN-10 parallel-trends gate".
- **L415 (HonestDiD sensitivity, bin-specific A_own):** "The 2018 placebo coefficients on $A_{\text{own}}$ across the four non-pure-owner bins are individually small ($|t| < 1$ at each bin), consistent with parallel pre-trends in the available pre-period."

Both anchors use the same explicit numeric threshold and both reference the 2018 baseline pre-period correctly (the single-pre-period limitation is separately disclosed at L483 limitation (i)).

**Residual minor:** L404's phrase "satisfying the LN-10 parallel-trends gate" introduces an internal-jargon acronym "LN-10" that is not defined in the prose, though the abstract or methods may have established it. A quick grep shows LN-10 appears only once in the manuscript (L404). If LN-10 is a pre-specification label from the PAP, recommend either a one-line glossary mention at first use, or replace with "the parallel-trends pre-test threshold" for journal-prose clarity. **MINOR**, post-90 polish.

---

## 6. Results-section level adjacent items observed

These are not part of the four Phase-2 MAJORs but surfaced during this lens's read.

### 6.1 Wild-bootstrap p-value tolerance (residual MAJOR-leaning)

L400: "Wild bootstrap p-values agree with the cluster-robust analytic p-values within $\pm .07$ across the 14 cells, with the largest gap on op\_cost\_ex\_rent at T1 (analytic $p_{\text{cluster}} = .105$ vs.\ wild $p_{\text{wild}} = .041$, straddling the $\alpha = .05$ threshold)."

The replication-package tolerance in `.claude/rules/quality-gates.md` lists "Wild bootstrap p-values: ± 0.005 across reps". A $\pm .07$ inter-method gap is order-of-magnitude larger than the cross-rep reproducibility tolerance — but it is a *between-method* gap (analytic vs. wild), not a *within-method* MC gap, so the rule does not strictly bind. The prose is appropriately defensive ("we treat the cluster-robust analytic p-value as the headline inference"). The $B = 999 \to 9{,}999$ resolution at replication-release stage is the right escalation. **Not a deduction**, but a Phase 2 watch-item.

### 6.2 F1 trigger language self-consistency (post-1.5 polish, holding)

L355 says "strict-AND F1 trigger ... trigger fires iff $\hat\beta_{1,\text{tenant}}$ at T2 has $p > .10$ \emph{and} the four-bin gradient is non-monotone" — and the trigger evaluates `four-bin`. This is internally consistent with the §3 L289 trigger definition's four-element set, but inconsistent with the table-and-figure five-bin reporting. Same root cause as M8. Will resolve with M8.

### 6.3 Operating-cost statistical-significance attenuation disclosure (post-1.5 polish, holding)

L366 honestly discloses that op_cost_ex_rent magnitude is "not significant after Holm step-down" and frames it as "directionally consistent" rather than load-bearing. L378 footnote and L486 (conclusion) maintain that disclosure. The headline never overclaims op_cost significance. This is a strength of the §6 narrative; preserves the post-Phase-1.5 calibration.

### 6.4 Table-input path stability

All §6 and §7 `\input{}` calls target `scripts/R/_outputs_symmetric/`:
- L357 `tab_het_own_share_en.tex`
- L368 `tab_main_did_rd_en.tex`
- L374 `tab_ch4_rent_decomposition_en.tex`
- L398 `tab_rob_outlier_en.tex`
- L402 `tab_wild_bootstrap_en.tex`
- L426 `tab_specB.tex`
- L430 `tab_specC.tex`
- L434 `tab_dropped_balance_en.tex`
- L438 `tab_attrition_placebo_full_en.tex`
- L442 `tab_placebo_cutoffs_en.tex`
- L450 `tab_sido_robustness_en.tex`

This is consistent with the symmetric-screening main design. The asymmetric-sample variant (L448) reports numbers in prose only ($+1{,}122$ / $-3.98$M etc.) and does not pull a separate `_outputs/` table, which is the right call given the §7 framing as a robustness comparator.

### 6.5 Figure availability

Spot-checked against `scripts/R/_outputs_symmetric/`: `fig_f1_fourbin_gradient_T2_en.pdf`, `fig_mccrary_density_full_en.pdf`, `fig_event_study_op_cost_T2_en.pdf`, `fig_honestdid_sensitivity_b1_en.pdf`, `fig_forest_treatment_definitions_en.pdf`, `fig_mccrary_multi_rv_en.pdf` — all six referenced figures exist on disk. No broken-image risk.

---

## 7. Final score and recommended Phase 2 actions

**§6 results & tables score (post-1.5b): 8.7 / 10** — unchanged from Phase 1.5; floor held.

| Action | Priority | Est. effort | Phase |
|--------|----------|-------------|-------|
| M8 — reconcile four-bin / five-bin partition in §3 and §5 (the only material drag) | MAJOR | 60–90 min | **Phase 2** |
| M7 — add a per-outcome T3 bandwidth clause at L340 or L355 | MAJOR (low) | 10–15 min | Phase 2 |
| L344 family ambiguity ("$\text{consumption}$ or $\text{farm\_income}$") tightening | minor | 5 min | Pre-95 polish |
| L404 LN-10 acronym definition (or replace) | minor | 5 min | Pre-95 polish |
| Wild-bootstrap $B = 9{,}999$ replication-release closeout | watch-item | scripted | Pre-submission |

If M8 is cleanly resolved with five-bin canonicalization, §6 score rises to 9.2/10 and the 90-threshold submission gate becomes attainable for §6 in isolation. M7's prose addition is cheap insurance.

**No critical issues. No deductions exceeding the "Numeric claim inconsistent with `_outputs/*.rds`" threshold were detected in the §6 prose; all headline numbers (1,151, 438, 258, -52; -3.57M, -2.62M; -13.7%, -11.7%) match the canonical Wave-7 symmetric-screened numbers cited in CLAUDE.md and the abstract.**

---

*End of Lens 4 report. Synthesis with Lenses 1–3, 5–7 will form the post-Phase-1.5b seven-pass aggregate.*
