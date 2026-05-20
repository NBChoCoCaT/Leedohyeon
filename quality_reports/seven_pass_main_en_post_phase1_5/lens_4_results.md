# Lens 4 — Results & Tables (Post-Phase-1.5)

**Manuscript:** `paper/en/main.tex`
**Reviewer:** Lens 4 of third seven-pass review
**Prior score (post-Phase-1):** 8.0/10
**Phase-1.5 target:** ≥ 8.5/10
**AJAE-grade target:** ≥ 9.0/10

---

## Score: 8.7/10  (Δ = +0.7 vs. post-Phase-1)

Phase 1.5 closed all four targeted CRITICALs in spirit; the three remaining MAJORs (M3 Holm, M7 T3 MSE, M8 4-vs-5-bin) and one new MINOR (op_cost cell-level discrepancy across tables) hold the score below 9.0.

---

## Phase-1.5 Closure Audit

### C1 — Table 1 op_cost_ex_rent ↔ §4 line 322 prose  **CLOSED**

§4 line 322 prose:
> "control-group ($D_i = 0$) operating cost net of rent averages 24.4 M KRW versus the statutorily-eligible group ($D_i = 1$) average of 8.3 M KRW (difference −16.0 M KRW); off-farm income averages 7.3 M KRW versus 11.3 M KRW (difference +4.1 M KRW)."

`_outputs_symmetric/tab_descriptives_en.tex` row 1:
- op_cost_ex_rent: Control 24,355,776 / Treated 8,309,086 / Diff −16,046,690 → **24.4 / 8.3 / −16.0 ✓**
- off_farm_income: 7,267,203 / 11,339,222 / +4,072,019 → **7.3 / 11.3 / +4.1 ✓**

op_cost_ex_rent is now the first continuous row in Table 1, with op_cost (omnibus, −17.8M diff) and rent_cost (−1.8M diff) as the decomposition triad. Header ordering matches the §3 outcome hierarchy in `tab:alpha3-predictions`. **Closed.**

### C2 — op_cost (omnibus) vs op_cost_ex_rent (primary) distinction  **MOSTLY CLOSED**

§4 line 320 now explicitly defines:
> "$\text{op\_cost}_{i,t} = \text{op\_cost\_ex\_rent}_{i,t} + \text{rent\_cost}_{i,t}$ is reported alongside as the rent-inclusive omnibus comparator."

§6 line 366 final sentence (N5 cross-ref):
> "Table~\ref{tab:main_specA_en} reports the pooled DiD-RD on the omnibus full-rent operating cost (op\_cost) alongside off-farm income, consumption, and farm income; the pattern matches the rent-net headline in sign and bandwidth profile, with the magnitude attenuated by the rent-inclusion channel quantified separately in Table~\ref{tab:ch4_rent_en}."

The three-table chain is now coherent: Table 1 (descriptives, both rows present) → tab_main_specA_en (omnibus op_cost only) → tab_ch4_rent_en (op_cost_ex_rent + rent_cost decomposition). **MINOR residual**: see N-1 below — the op_cost coefficient in tab_main_specA_en (T1 = −3.73M) differs from the op_cost_ex_rent coefficient in tab_ch4_rent_en (T1 = −3.57M) by roughly the rent_cost magnitude (−0.16M at T1), which is internally consistent (op_cost ≈ op_cost_ex_rent + rent_cost) but the prose never quantifies the −3.73M omnibus headline — only the −3.57M ex-rent figure. **Closed at the conceptual level; minor numerical hygiene remains.**

### C3 — \ref{tab:main_specA_en} callout in prose  **CLOSED**

§6 line 366 contains an explicit `Table~\ref{tab:main_specA_en}` callout (the new sentence appended to the operating-cost paragraph). The table is also still `\input{}`-ed at line 368 immediately after. **Closed.**

### C4 — Figure 5 caption ↔ §7.1 prose (39% median shift)  **CLOSED**

§7.1 line 446 (area-only robustness paragraph):
> "1 sign flip on the off-farm-income outcome (which is statistically near zero under both designs), 3 cells crossing $\alpha = .05$ on direction-preserving outcomes, and 10 cells crossing $\alpha = .10$, with median absolute percentage shift of 39%."

Figure 5 caption (line 457):
> "the median absolute percentage shift is approximately 39%, with one sign flip (off-farm-income, pooled coefficient near zero under both) and three cells crossing $\alpha = .05$."

Caption and prose match on the three load-bearing numbers (39%, one sign flip, three α=.05 cells). The Wave 7 historical comparator (median 16%, asymmetric vs. area-only) is correctly footnoted in line 446 as the prior-comparison reference and not conflated with the current symmetric-vs-area-only forest. **Closed.**

### M1 — §5 +1,151 (Phase 1.5 N9) propagation  **CLOSED**

Searched the full manuscript for the +1,122 and +1,151 figures. Map of every load-bearing occurrence:

| Location | Value | Context | OK? |
|---|---|---|---|
| Abstract line 36 | +1,151 (p=.036), gradient 1,151→438→258→−52→0 | Symmetric main | ✓ |
| §1 line 58 | +1,151 (T2, p=.036); +438 (p=.047) | Symmetric main | ✓ |
| §5 line 342 | +1,151 (p=.036); +1,122 (p=.041) labeled "asymmetric-sample variant" | Wave 7 retained as comparator | ✓ |
| §6 line 355 | +1,151 / +438 / +258 / −52 / 0 at T2; T1 +1,578→656→117→−336→0; T3 +357→146→366→−27→0 | All from `tab_het_own_share_en.tex` | ✓ |
| §6 footnote line 378 | gradient +1,151 → +438 → +258 → −52 → 0 | Symmetric main | ✓ |
| §7 line 400 | +1,151 (T2, symmetric, p=.036) | Wild bootstrap | ✓ |
| §7.1 line 448 | +1,122 (p=.041), gradient 1,122 → 403 → 222 → −74 → 0 | Asymmetric (Wave 7 baseline) — correctly labeled | ✓ |
| §8 line 475 | +1,151 (T2); gradient 1,151→438→258→−52→0 | Symmetric main | ✓ |
| §8 line 486 (Conclusion) | +1,151 (T2, p=.036); 1,151→438→258→−52→0 | Symmetric main | ✓ |

The Phase-1.5 N9 propagation is **clean**: +1,151 is the symmetric-main number; +1,122 appears only in §5 ¶342 (as labeled comparator) and §7.1 ¶448 (as the asymmetric-sample variant subsection). No stale +1,122 leaks. **Closed.**

---

## Remaining MAJORs From Post-Phase-1 (Status)

### M3 — Holm step-down family composition  **UNCHANGED — STILL MAJOR**

§5 line 344 (Inference paragraph):
> "Across the primary outcome family (the four outcomes: $A_{\text{own}}$, $\text{op\_cost\_ex\_rent}$, $\text{off\_farm\_income}$, and $\text{consumption}$ or $\text{farm\_income}$ as the omnibus), we apply Holm step-down correction"

This is internally inconsistent with the framework. The §3 outcome hierarchy declares **two primary outcomes** ($A_{own}$, op\_cost\_ex\_rent), **one auxiliary** (off\_farm\_income), and **one ex-theory** (unit\_rent\_price). The "consumption or farm\_income" disjunction in §5 is undefined — Holm correction cannot be applied to a family with a literal `or` in its definition. AJAE referees will flag this as either a typo or as referee-bait for multiple-testing correction critique. **Action:** specify the Holm family as exactly {$A_{own}$, op\_cost\_ex\_rent, off\_farm\_income} (drop unit\_rent\_price per its ex-theory status) and remove the "or" disjunction. Also state on which test statistic the family adjustment is computed (the pooled DiD-RD coefficient at T2? all bandwidths?). Phase 1.5 did not touch this.

### M7 — T3 MSE-optimal h per outcome  **PARTIALLY EXPOSED — STILL MAJOR**

The `tab_main_specA_en.tex` header for T3 now correctly reads "T3 (h = h*_mse (per outcome))" and the N column varies by outcome (1,903 / 2,071 / 2,436 / 3,308). This is honest. However the §5 line 340 prose still describes T3 as a single "MSE-optimal $h$ via Calonico-Cattaneo-Titiunik (2014) with a triangular kernel" without telling the reader that the bandwidth is recomputed per outcome. §6 line 355 also references T3 as if it were a scalar ("T3 (MSE-optimal $h \approx 3{,}300$ m²)") which is inconsistent with the per-outcome N values shown in the table. **Action:** §5 should say "for each outcome we report rdrobust's MSE-optimal $h_k^*$; the per-outcome bandwidths and N's are listed in column T3 of each table" and §6 should drop the "$\approx 3{,}300$" approximation or qualify it as "the modal MSE-h, with per-outcome variation reported in Table X."

### M8 — 4-bin vs 5-bin partition language  **UNCHANGED — STILL MAJOR**

The §3 framework (Table notation line 121, prediction line 213, Online Appendix B.1) uses a **four-bin** partition $\{0, (0,.33], (.33,.67], 1\}$. The §5 Heterogeneity paragraph (line 342) and the §6 results (line 355) both report **five bins**: pure_tenant, low_owner, mixed, high_owner, pure_owner. The empirical heterogeneity table `tab_het_own_share_en.tex` is five-column. The discrepancy is bridged inconsistently — line 213 says "four-bin" but line 342 says "five baseline-tenancy bins". Either the theory says four-bin (and the empirical aggregates high_owner with pure_owner) or it says five-bin (and the partition cut points are $\{0, (0,.3), [.3,.7), [.7,1), 1\}$, which is what the empirics actually use). Phase 1.5 did not fix this; AJAE referees will note it on the first read of §3.

### M9 — Pre-trends |t|<1 unspecified  **UNCHANGED — STILL MAJOR**

§7 line 404 and Figure 6 caption assert "the 2018 pre-period coefficient is statistically zero (|t|<1)" for the event-study at T2, but no actual t-statistic value or pre-period coefficient is reported in the manuscript or in any of the input files I checked. The placeholder language "|t|<1" without a numerical anchor is exactly the kind of pre-trends gloss that HonestDiD-aware referees (a near-certainty at AJAE post-Roth 2022) will challenge. **Action:** report the actual 2018 placebo coefficient and SE in the event-study figure caption.

---

## New Findings This Pass

### N-1 (NEW MINOR) — op_cost coefficient slight cross-table discrepancy

`tab_main_specA_en.tex`: op_cost at T1 = **−3,732,607** (SE 2,189,530); T2 = **−2,762,226** (SE 1,967,784).

`tab_ch4_rent_decomposition_en.tex`: op_cost_ex_rent at T1 = **−3,567,680**; T2 = **−2,622,322**. rent_cost at T1 = **−164,927**; T2 = **−139,904**.

Sum check: T1 ex_rent + rent = −3,567,680 + (−164,927) = −3,732,607 ✓; T2 = −2,622,322 + (−139,904) = −2,762,226 ✓. The decomposition is arithmetically exact — internally clean.

§6 line 366 quotes "$-3.57$M KRW at T1 ... and $-2.62$M KRW at T2" (op_cost_ex_rent figures from ch4_rent table). The prose never quotes the −3.73M omnibus headline that tab_main_specA_en displays. A reader scanning §6→tab_main_specA_en will see −3,732,607 and wonder why the text says −3.57M. **Action:** Add a parenthetical to §6 line 366 final sentence: "(omnibus op\_cost coefficient = −3.73M at T1, −2.76M at T2; cf.\ Table~\ref{tab:main_specA_en})". This is a 30-second fix that closes the C2 residual cleanly.

### N-2 (NEW MINOR) — tab_main_specA_en caption misses op_cost identification

The caption is "DiD-RD: Spec A (2018-2022, Post = year >= 2020)" — too generic. Given that this table is the only one in §6 reporting op_cost (omnibus) explicitly, the caption should label that explicitly: "DiD-RD on the omnibus full-rent operating cost, off-farm income, consumption, and farm income (Spec A, 2018--2022)". The current caption forces the reader to read the column header to figure out what op_cost is (vs op_cost_ex_rent). AJAE-grade tables carry self-contained captions.

### N-3 (NEW MINOR) — Note line in tab_main_specA_en footer references work-in-progress

> "Wild / fractional cluster bootstrap deferred to P3 (`04\_robust.R`)."

This phrase is a development artifact and shouldn't survive into an AJAE submission. The wild bootstrap is reported in §7 at line 400, so this footnote is also stale. **Action:** rewrite the footer to "Cluster-robust SE in parentheses; wild cluster bootstrap p-values in Table~\ref{tab:wild_bootstrap_en}" or similar.

### N-4 (NEW MINOR) — tab_het_own_share_en footer references abandoned hypothesis label

> "Scenario classification: $\gamma$ (own-cultivation dominant) -- H3 strong in pure\_owner; ``land accumulation'' narrative strengthened."

The "$\gamma$ scenario" and "H3" labels are residual from the pre-AHM framing (Wave 6/7 channel-classification language) and are not introduced anywhere in the AHM-extension framework of §3. This is referee-bait. Should read something like "F1 pattern: monotone-decreasing in $s_{0,i}$ across the four non-pure-owner bins, consistent with eq.~(\ref{eq:CO-2})."

### N-5 (NEW MAJOR) — Holm step-down family construction conflicts with reported tables

Looking at `tab_ch4_rent_en.tex` row 1, op_cost_ex_rent at T1 = −3,567,680 (SE 2,190,391). Raw t ≈ −1.63 → raw two-sided p ≈ .105. §6 line 366 reports "raw $p \approx .10$; not significant after Holm step-down across the four-outcome primary family." With four outcomes in the family, the Holm-α at the smallest unadjusted p is .10/4 = .025; the binding test for the smallest-p outcome is α=.10/(family size) at the first step, then α/(family-1) at the second step. For op_cost_ex_rent at T1 with raw p ≈ .105, the Holm-adjusted p is bounded above by 4 × .105 = .42 — clearly not significant after correction. That's consistent with the prose.

However, the rent_cost coefficient in `tab_ch4_rent_en.tex` carries a single star (p<.10) on the raw cluster-robust SE: −164,927 / SE 98,526, raw t ≈ −1.67, raw p ≈ .094. The §6 line 372 then reports "$\hat\beta_5 = -164{,}927$ KRW, $p < .10$" without applying Holm. This is **internally consistent only if** rent_cost / unit_rent_price are explicitly excluded from the Holm family (per the §3 ex-theory designation). The exclusion should be stated explicitly. Currently §5 line 344 includes "consumption or farm_income" but **NOT** rent_cost / unit_rent_price in the family, so this is implicitly correct, but the "or" makes the family construction itself ill-defined.

**M3 status:** the manuscript implicitly uses Holm over {$A_{own}$, op_cost_ex_rent, off_farm_income, plus one of consumption/farm_income} = 4 outcomes, with the ex-theory unit_rent_price/rent_cost reported with raw p-values. This is defensible but needs explicit declaration. Promote M3 from MAJOR (post-Phase-1) to **still MAJOR** — Phase 1.5 did not address it.

### N-6 (NEW MINOR) — tab_descriptives_en "imputed_payment = 0 (0)" row is misleading

`tab_descriptives_en.tex` shows imputed_payment with Control mean 0, Treated mean 0. §3 line 264 says "Among SFFP-eligible households ($D_i = 1$ in the post-period), 100\% appear with positive imputed payment in the analysis panel". Since Table 1 reports baseline (2018 cross-section, per the table note), the imputed payment is structurally zero for both groups in 2018 (pre-policy). This is correct but **confusing without context** — the reader has to know that the table reports the 2018 pre-period to interpret the zero. **Action:** add a parenthetical "(2018 cross-section; imputation activates in 2020+)" to the imputed_payment row, or drop the row entirely since it carries no information at the baseline.

---

## Per-Table Audit

| Table | Status | Issues |
|---|---|---|
| `tab:notation` | Clean | — |
| `tab:alpha3-predictions` | Clean | Outcome hierarchy declared correctly |
| `tab:descriptives_en` | Mostly clean | N-6 (imputed_payment row); also missing rent_cost descriptive read in §4 prose (line 322 quotes op_cost_ex_rent and off_farm_income but not the rent_cost row, even though rent_cost is in Table 1 and Table 1 is the natural anchor for the −1.8M pre-period rent_cost gap that motivates the CH4 channel) |
| `tab:main_specA_en` | C3 closed; N-1/N-2/N-3 pending | Caption needs identification; footer note stale; cross-ref to ch4 figures needed for op_cost decomposition |
| `tab:ch4_rent_en` | Clean | Internally consistent with main_specA via op_cost = op_cost_ex_rent + rent_cost |
| `tab:het_own_share_en` | N-4 stale footer; M8 4-vs-5-bin | Bin count discrepancy with §3 framework |
| `tab:wild_bootstrap_en` | Not directly inspected | §7 line 400 prose claim "agree within ±.01" not verified against tab cell — depends on the tab being correct |
| `tab:rob_outlier_op_cost_en` | Not inspected | Referenced at line 396, 398; check that it covers op_cost or op_cost_ex_rent or both |
| `tab:sido_robustness_en` | Cited correctly at line 348, 452 | — |
| `tab:placebo-cutoffs` | Cited at line 442 | — |
| `tab:dropped-balance` | Cited at line 434 | — |
| `tab:attrition-placebo-full` | Cited at lines 394, 436 | — |
| `tab:specB` | Cited at line 426 | — |
| `tab:specC` | Cited at line 430 | — |

## Per-Figure Audit

| Figure | Status | Issues |
|---|---|---|
| `fig:f1-fourbin-gradient` (Fig 1) | Clean | T2, pure-tenant +1,151 with p=.036; caption correct |
| `fig:mccrary` (Fig 2) | Clean | Full-sample n=2,178, t=0.68, p=.50; narrow-window p-values listed in both prose and caption |
| `fig:event-study-T2` (Fig 3) | M9 unresolved | Caption says "$|t| < 1$" — no anchor t-stat or coefficient reported |
| `fig:honestdid` (Fig 4) | Clean conceptually | Caption describes $\bar M^* = 0$ correctly; the narrative around limitation is honest but the figure carries no specific $\bar M^*$ numerical annotation |
| `fig:forest-treatment-defs` (Fig 5) | **C4 CLOSED** | Caption now matches §7.1 prose: 39% median, 1 sign flip, 3 α=.05 cells |
| `fig:mccrary-multi-rv` (Fig 6) | Clean | Three margins, t-stats and p-values consistent between caption and §7 prose |

---

## Summary

**Phase 1.5 substantively delivered.** All four targeted CRITICALs are closed (C1, C2, C3, C4) and M1 (the +1,151 propagation) is clean across nine load-bearing locations. The score gain (+0.7) primarily reflects C1 (Table 1 now anchors op_cost_ex_rent as the §4 prose claims) and C4 (Figure 5 caption now matches §7.1 prose on the 39% median shift).

**To reach AJAE-grade ≥9.0 in Phase 2, address:**

1. **M3 (Holm family declaration)** — write the Holm family as the explicit set {$A_{own}$, op_cost_ex_rent, off_farm_income} with a one-sentence statement that rent_cost / unit_rent_price are reported with raw p per the §3 ex-theory designation. Remove the "or" disjunction. *(Critical for AJAE referee defense; cheap to fix.)*
2. **M7 (T3 MSE per-outcome)** — §5 line 340 and §6 line 355 wording should state that T3 is recomputed per outcome. *(30-minute fix.)*
3. **M8 (4-bin vs 5-bin)** — reconcile §3 (four-bin) with §5/§6/tables (five-bin). Either expand the §3 partition to five bins explicitly, or aggregate the high_owner cells in tables to deliver a true four-bin display. *(Theory-empirics alignment; 1-hour fix.)*
4. **M9 (pre-trends |t|<1)** — report the 2018 placebo coefficient and SE in Figure 3 caption. *(15-minute fix.)*
5. **N-1, N-2, N-3, N-4, N-6** (table/caption hygiene) — together a 30-minute pass.

If items 1–4 are addressed in Phase 2, the lens-4 score moves to 9.3–9.5/10. The empirical content is AJAE-grade; the remaining gap is documentation precision and cross-table consistency.
