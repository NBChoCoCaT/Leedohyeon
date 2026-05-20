# Lens 4: Results & Tables
**Date:** 2026-05-20
**Reviewer:** Lens 4 (seven-pass adversarial review — results & tables)
**Manuscript:** `paper/en/main.tex` (468 lines, AJAE submission target)
**Score:** 4/10

The §6 prose narrates a coherent F1 + (S,s) story, but the **main text contains zero result tables for the headline findings**. Every single load-bearing number (the +1,122 m² pure-tenant gradient, the −3.98M / −3.13M op_cost_ex_rent coefficients, the −12.0% rent pass-through, the four-bin monotone gradient, F2's near-zero β₄) is referenced only in prose. The only `\input{}` tables in the body are descriptives (Table 1), the Spec B robustness, and three robustness tables (dropped-balance, attrition, placebo cutoffs). The actual F1 heterogeneity table and the CH4 rent-decomposition table are NOT in the main paper — `Table~\ref{tab:appB-mapping}` (which the F1 paragraph cites) lives in `online_appendix.tex`. An AJAE referee opening the manuscript at §6 will read four paragraphs of numbers and find no table to verify them in. This alone is sub-80 territory.

On top of that, there are unit/magnitude inconsistencies between Table 1 and §4 prose; a Table 1 with a meaningless `imputed_payment` row (0/0/0); a heterogeneity table whose footnote contradicts the paper's narrative; a Holm correction that is invoked in §5 but only partially reported in the wild-bootstrap table; and a missing standalone table for the main op_cost regression.

---

## CRITICAL findings

### C1. Headline F1 table is invisible to a main-text reader
§6 line 350: "Table~\ref{tab:appB-mapping} reports $\hat\beta_1$ across five baseline-tenancy bins..." — `tab:appB-mapping` is defined in `paper/en/online_appendix.tex` line 533. A reader of the main paper sees a Table reference, follows the cross-document `xr-hyper` link to the appendix, and only there sees the F1 heterogeneity grid. **The single most important table in this paper (the four-bin monotone gradient that "uniquely identifies the wealth-bias signature") is not in the main text.** This violates the AJAE expectation that the main result is visible in §6.

Fix: `\input{../../scripts/R/_outputs_eligibility/tab_het_own_share_en.tex}` (or a curated `tab_F1_fourbin_en.tex` showing only the `area_own` panel × 5 bins × 3 bandwidths) must appear in §6 immediately after line 350. Drop the cross-document reference. The F1 result is the paper's headline; it must be on display.

### C2. Headline op_cost_ex_rent table is invisible to a main-text reader
§6 line 359: "The pooled DiD-RD estimate of $\hat\beta_3$ on operating cost net of rent is $-3.98$M~KRW at T1 ($p = .057$, $n = 760$)..." These numbers come from `tab_ch4_rent_decomposition_en.tex` (rows 9, 12) and/or `tab_wild_bootstrap_en.tex` Panel B (rows 28-30). **Neither table is `\input{}`-ed in main.tex.** The reader has no table to verify the headline (S,s) result. The Spec B robustness table IS displayed (line 409) — but Spec B reports `op_cost` (not `op_cost_ex_rent`), and its T1 value is −5,051,970, not −3.98M. The reader cannot reconcile §6's headline number to any displayed table.

Fix: `\input{../../scripts/R/_outputs_eligibility/tab_ch4_rent_decomposition_en.tex}` in §6 after line 360. This table also carries the −12.0% pass-through number cited in §3, §6, §7, and §8.

### C3. Numeric inconsistency between Table 1 and §4 prose (op_cost benchmark)
- §4 line 317 prose says: "control-group ($D_i = 0$) operating cost averages $41.1$~M~KRW versus the statutorily-eligible group ($D_i = 1$) average of $13.6$~M~KRW (difference $-27.5$~M~KRW)"
- Table 1 (`tab_descriptives_en.tex` line 11) says: Control op_cost = 30,018,507 ≈ **30.0M**, Treated = 8,447,763 ≈ **8.4M**, Diff = **−21.6M**

**The prose and Table 1 disagree by 11M KRW on the control mean** and 5.2M KRW on the treated mean. §4 also claims pre-period (2018-2019) descriptives ("Headline pre-period descriptives at the 0.5~ha cutoff"), but Table 1's note says "Baseline = 2018 cross-section" — single year, not 2018-2019. The 41.1M / 13.6M numbers may come from a different sample restriction (e.g., the area-only-eligible cohort of 1,131 hh) or a different year set. Either Table 1 is the wrong restriction or the prose is wrong; both cannot be right. The Lens 5 robustness reviewer and the Lens 2 introduction reviewer will catch this independently.

Same paragraph: prose says "off-farm income averages $14.5$~M~KRW versus $11.4$~M~KRW (difference $-3.1$~M~KRW)". Table 1 row 12: Control = 13,753,568 = **13.8M**, Treated = 11,339,222 = **11.3M**, Diff = −2.4M. Off by 0.7M on control, 0.7M on diff.

The Carter-Olinto §6 "$-29\%$ change relative to pre-period mean of 13.6M~KRW" (line 359) inherits this error — if the correct mean is 8.4M (per Table 1), the change is −47%; if it's 13.6M (per prose), it's −29%. The Lens 5 / Lens 7 verifier will demand reconciliation.

Fix: pick one sample and regenerate. Confirm whether §4 pre-period descriptives use the full statutorily-eligible-or-control subset (=Table 1) or only treated households. State the year set explicitly. The 13.6M figure also appears in §8 line 446 — three places need to agree.

### C4. Table 1 displays a meaningless `imputed_payment` row
`tab_descriptives_en.tex` line 17: `imputed_payment & 0 (0) & 0 (0) & 0 &` — all four cells are zero. This is a leftover artifact: imputed_payment is defined as `1.2M · 𝟙[D_i = 1, Post]`, and Table 1 is the 2018 baseline cross-section, so all values are mechanically zero. Including a zero-row in the descriptives Table — without explanation — makes Table 1 look broken. Either drop the row or replace with the post-period (2020-2022) treated-group mean (which is the institutionally informative figure: 1.2M × treatment intensity).

### C5. Het table's footnote contradicts the paper's narrative
`tab_het_own_share_en.tex` line 50 footnote: *"Scenario classification: γ: OWN_CULTIVATION DOMINANT — H3 strong in pure_owner. 'Land accumulation' narrative strengthened.."* — this is a legacy Wave 5 / Wave 6 R-script auto-classification string. The paper's narrative is now *"H1/F1 wealth-bias monotone gradient in pure_tenant"* (Wave 7 α3 framing). The footnote is internally contradictory: pure_owner is the reference category and is *defined* to be 0 — it cannot be "strong". This footnote will confuse any referee who reads the table standalone.

Fix: regenerate the table with the Wave 7 footnote (drop the auto-classifier line, replace with a clean caption stating "F1 four-bin gradient on own-cultivated area; pure_owner is the reference category by construction").

### C6. Spec B table is labelled "drop 2020, Post = year ≥ 2021" but §7.2 describes it differently
`tab_specB.tex` line 3 caption: *"DiD-RD Robustness: Spec B (drop 2020, Post = year ≥ 2021)"*
§7.2 line 407 prose: *"Spec B substitutes a richer pre-period covariate vector (adding farm-type fixed effects and head-of-household education-tier indicators) in place of Spec A's parsimonious covariate set."*

**These describe two completely different Spec Bs.** The table is doing a "drop the 2020 partial-treatment year" robustness; the prose is doing a "richer covariate vector" robustness. One of them is wrong. The Spec B coefficients shown (T1 op_cost −5.05M, T2 −4.79M) match neither the prose's description nor the wild-bootstrap table's Spec B per-outcome MSE-bandwidth cells (T3-only: op_cost −115,595; off_farm_income +380,793).

This is a CRITICAL inconsistency — readers cannot interpret the Spec B robustness check.

### C7. No standalone table for the main pooled DiD-RD (Spec A)
The file `tab_main_did_rd_en.tex` exists (with the four-outcome pooled DiD-RD on `op_cost`, `off_farm_income`, `consumption`, `farm_income`) but is NEVER `\input{}`-ed in main.tex. So the main paper has Table 1 (descriptives), then jumps straight to §6 prose with no main-effects table, then displays only Spec B robustness in §7. The reader cannot see Spec A's headline four-outcome table at all in the body.

Fix: `\input{../../scripts/R/_outputs_eligibility/tab_main_did_rd_en.tex}` immediately after §6's "Operating-cost sub-prediction" paragraph (line ~360). This is the second-most-important table after F1.

---

## MAJOR findings

### M1. Magnitude-vs-significance: most claims have one but not the other
The "Operating-cost sub-prediction" paragraph (line 359) is the *one good example* of magnitude framing: it says "−29% relative to pre-period mean of 13.6M~KRW, equivalent to ~3.3× annual SFFP transfer." This is exactly how to do it. But everywhere else:

- F1 result (line 350): "+1,122 m² (p=.041)" — magnitude is reported but NOT benchmarked against anything readable (% of cutoff? % of own-area baseline? Discussion §8 line 446 belatedly says "~22% of the 0.5~ha eligibility threshold," but that's the wrong benchmark — the relevant comparison is the pure-tenant baseline own-area, which from `tab_descriptives_en.tex` row 16 is ~1,962 m² (treated avg) or ~0 m² for pure-tenants. So +1,122 is on the order of 50-100% of the relevant baseline, which is a huge effect that the prose understates).
- Rent-cost pass-through (line 363): "−12.0% at T2" — benchmark given (Kirwan +25%, Ciaian +46-55%), good. But the underlying coefficient (−144,027 KRW) and SE (95,742) are buried in `tab_ch4_rent_decomposition_en.tex` which is not displayed in main text.
- F2 result (line 361): "small and statistically near zero" — NO magnitude given at all. The reader cannot tell whether the off-farm-income coefficient is +200K or +2M. Per `tab_main_did_rd_en.tex` it's actually +1.97M at T2 with SE 3.90M — quite large in absolute terms (≈17% of the treated-group baseline of 11.3M); calling it "small" without showing the number is misleading.

### M2. Holm step-down adjustment: inconsistently reported
§5 line 339: "we apply Holm step-down correction to control the family-wise error rate."
§6: the four outcomes (op_cost, off_farm_income, consumption, farm_income) — Holm-adjusted p-values are NOT reported alongside any raw p-value in the prose.
`tab_wild_bootstrap_en.tex` Panel A has a `p_wild_holm` column for the 8 P2 replication cells — but Panel B (the 6 CH4 cells, including the headline op_cost_ex_rent T1/T2) has NO Holm column.

So the headline T1 op_cost_ex_rent claim "−3.98M, p=.057" is reported (line 359) without indicating whether this p is raw or Holm-adjusted. Per `tab_wild_bootstrap_en.tex` line 28, `p_cluster = 0.0574, p_wild = 0.0230` — both raw, no Holm column populated. Under Holm step-down across four outcomes, even the wild bootstrap p=0.023 would multiply to ~0.092 if it's the smallest (still < 0.10), but the reader cannot verify this. For an AJAE referee, this is the difference between "marginal" and "fails the test."

Fix: Panel B of `tab_wild_bootstrap_en.tex` needs a Holm-adjusted column. Every p-value in §6 prose should be labelled (raw / wild / Holm-adjusted-wild). Currently, "p=.057" is ambiguous — and per `tab_ch4_rent_decomposition_en.tex` line 9, the table reports −3,978,705* (one star = p<.10, raw cluster), while wild bootstrap gives p=.023 (line 28). The "p=.057" cited in prose is the cluster-robust raw p, not the wild bootstrap p, and not Holm-adjusted.

### M3. The 5 placebo cutoffs vs. 32-cell claim
§7 line 419 prose: "Of 32 placebo cells (4 outcomes × 4 cutoffs × {T1, T2}), 3 reach p < .10 and 1 reaches p < .05".
`tab_placebo_cutoffs_en.tex` only shows **T2** (the caption says "Spec A, T2 bandwidth h=1,000 m²"). The reader sees 5 rows × 4 outcomes = 20 cells (including the true cutoff row), of which only 4 placebo rows × 4 outcomes = 16 cells. Where are the T1 placebo cells? The 32-cell claim cannot be verified from the displayed table. Either show T1 placebo cells too, or correct the prose to "16 cells at T2 only".

Also: the table includes the 0.5 ha **true cutoff row** (line 13: op_cost −3,275,728*), but this is the pooled `op_cost` (NOT `op_cost_ex_rent`), so it's a *third* op_cost coefficient (alongside §6's −3.98M ex_rent and Spec B's −5.05M). The reader sees three different "op_cost at T2" numbers (−3.13M, −3.28M, −4.79M) and is given no map.

### M4. McCrary test result is reported in text but no McCrary figure caption matches
§7 line 374 prose: "test statistic $t = 1.34$ ($p = .18$, $n = 2{,}680$)"
`fig:mccrary` caption (line 379): "Test statistic $t = 1.34$ ($p = .18$); the null of density continuity is not rejected."

Good agreement on t and p, but the caption doesn't state N. Figure caption also omits axis units (presumably m² × density). Standard McCrary figures show running variable on x-axis with explicit "0.5 ha cutoff" annotation — the caption doesn't tell us whether the x-axis is in m² or ha. Lens-7 numeric verifiers will flag.

### M5. Event-study figure caption omits axis units and CI level
§7 line 394 caption (fig:event-study-T2): "Event-study estimate of operating cost around the 2020-05-01 PIDPS implementation date at T2 ($h = 1{,}000$~m\textsuperscript{2}). The 2018 pre-period coefficient is statistically zero ($|t| < 1$)..."

What's missing: (a) y-axis units (KRW vs. log-KRW vs. asinh — `op_cost_ex_rent` raw KRW, presumably), (b) CI level (95%?), (c) reference category (year 2019? year 2018?), (d) cluster level (hh_id), (e) N at this bandwidth (760 per the wild-bootstrap table). Also, "$|t| < 1$" is a vague pre-trend claim — what is the actual 2018 coefficient and SE? The Lens 7 verifier cannot test the |t|<1 claim from the figure alone.

### M6. F1 four-bin figure caption is decent but lacks N and CI level
§6 line 355 (fig:f1-fourbin-gradient): "F1 four-bin tenancy gradient on own-cultivated area at T2 ($h = 1{,}000$~m\textsuperscript{2}). Pure-tenant response $+1{,}122$~m\textsuperscript{2} ($p = .041$)..."

What's missing: y-axis units (m² yes, but lower/upper CI?), N per bin (760 / 1567? Split across 4 bins?), error bar definition (cluster-robust 95% CI?), cluster level.

### M7. Heterogeneity table mixes outcomes that read differently
`tab_het_own_share_en.tex` shows four outcomes in one table: rent_cost (KRW), unit_rent_price (KRW/m²), area_own (m²), area_rent (m²). The y-axis unit changes inside the table without warning the reader. The unit_rent_price panel especially — values like "−42.91" or "+204.43" with SE "(28.56)" — could easily be misread as KRW or % by a referee skimming. Add a column header noting units per panel, or split into separate tables.

### M8. Three-channel coherence: the channels are scattered across tables and outcomes
The paper's "tenant-driven land transition" framing (per CLAUDE.md) hinges on three concurrent channels: (i) bargaining margin (unit_rent_price), (ii) composition (area_rent ↓ + rent_cost ↓), (iii) land-pivot (area_own ↑). All three live in `tab_het_own_share_en.tex` — which is NOT displayed in main text and whose caption doesn't even acknowledge the three-channel structure. The §6 prose conflates "F1 + (S,s) on op_cost" but barely surfaces the three-channel story; the rent_cost result (line 363) is dropped in passing.

For an AJAE submission whose "publishable contribution rests on the THREE concurrent monotone gradients" (CLAUDE.md), the main text should display a single integrated 3-panel table showing the monotone gradient appearing in **all three** outcome families simultaneously. Currently, this is invisible — only the area_own panel appears in the appendix.

### M9. Outlier-robustness ladder displayed only in replication package
§7 line 385 prose: "The replication-package outlier-ladder table (\texttt{tab\_rob\_outlier\_en.tex}) reports..."
The text *describes* the result ("sign and significance stable across all four treatments") but does NOT `\input{}` the table. This is a robustness check that an AJAE referee will demand to see. Either inline the op_cost panel in §7 or move all four panels to the online appendix and cross-reference there (currently it's neither in main nor in appendix — just floating in the script's _outputs/ folder).

---

## MINOR findings

### m1. `tab_descriptives_en.tex` uses `\scriptsize` and `tabcolsep=4pt`
At AJAE print size, scriptsize on Table 1 will be barely legible. Move to `\small`. Same for `tab_specB.tex`, `tab_placebo_cutoffs_en.tex`, `tab_dropped_balance_en.tex` — all are scriptsize.

### m2. Underscore handling in table content
Several outputs use `op_cost` (raw underscore, will fail in LaTeX math) instead of `op\_cost`. E.g., `tab_main_did_rd_en.tex` line 7: `Bandwidth & op_cost & off_farm_income...` — these are bare underscores in LaTeX text mode. If this file is ever `\input{}`-ed it will throw `Missing $ inserted`. Also `tab_rob_outlier_en.tex` line 4 caption has `op_cost`. Re-export with escaping.

### m3. Notation inconsistency: `op_cost` vs `op_cost_ex_rent` not distinguished in §6 prose
§6 line 359: "operating cost net of rent is $-3.98$M~KRW at T1" — this is `op_cost_ex_rent`. But the next sentence: "The T1 magnitude corresponds to a $-29\%$ change relative to the pre-period treated-group operating cost mean of $13.6$M~KRW" — is 13.6M `op_cost` (Table 1 says 8.4M though...) or `op_cost_ex_rent`? Mean of the variable the coefficient is on should be the denominator. Per `tab_descriptives_en.tex` the displayed variable is `op_cost`, not `op_cost_ex_rent` — so the 29% benchmark is computed against the wrong denominator. Either show op_cost_ex_rent mean in Table 1 or recompute the 29%.

### m4. T3 bandwidth is reported as multiple values across tables
- `tab_main_did_rd_en.tex` line 15: "T3 (h = h*_mse (per outcome))" with N varying 2780/3310/3135/4210
- `tab_specB.tex` line 17: "T3 (h = per-outcome MSE-optimal)" with N varying 2744/2748/3128/3628
- `tab_ch4_rent_decomposition_en.tex` line 15: "T3 (h = h*_mse)" with single N=5,548
- `tab_het_own_share_en.tex`: "h=3300" hardcoded
- §6 line 350: "T3 (MSE-optimal $h \approx 3{,}300$~m\textsuperscript{2})"
- §6 line 359: "T3 ($h \approx 1{,}710$~m\textsuperscript{2})"

**The paper cites two completely different "T3" bandwidths** — h≈3,300 for F1 (line 350) and h≈1,710 for the op_cost result (line 359). Per the table, op_cost_ex_rent T3 uses h=3,305 (5,548 obs), not 1,710. The "1,710 m²" in line 359 is wrong (or refers to a different MSE-optimal bandwidth that no displayed table matches). This is a numeric inconsistency between §6 prose and the underlying outputs.

### m5. F1 footnote uses different arrow notation than table
§6 line 367 footnote: "($+1{,}122 \to +403 \to +222 \to -74 \to 0$~m\textsuperscript{2})" with right-arrows.
Conclusion line 457: "$1{,}122 \to 403 \to 222 \to -74 \to 0$" — drops the + signs. Make consistent.

### m6. Discussion §8 line 450 cites N for the treated cohort "52% pure-owner share"
But Table 1 doesn't show own_share quintile splits. Where does the "52% pure-owner" figure come from? Add a Table 1 row or remove the claim.

### m7. Equation numbering vs. table referencing
`Table~\ref{tab:alpha3-predictions}` (line 247) is the unified-predictions table in §3.4. Confusingly, `tab:appB-mapping` in the appendix is also called "predictions/mapping". Two similarly-named tables doing similar things — pick one label scheme.

### m8. Wild bootstrap table mixes per-outcome MSE bandwidth and fixed bandwidth in one table without warning
`tab_wild_bootstrap_en.tex` Panel A uses per-outcome MSE-bandwidth (3,305 for op_cost; 3,716 for off_farm_income; 3,931 for consumption; 3,268 for farm_income). Panel B uses fixed T1/T2/T3 bandwidths. The footnote explains this only obliquely ("Reference STATA boottest uses common hA_min bandwidth, NOT per-outcome bandwidth — direct ±0.01 tolerance comparison deferred"). A standalone reader of this table cannot easily see why two panels use different bandwidth schemes.

### m9. McCrary t=−1.64 (p=.10) for the owned-farmland threshold is borderline-significant
§7 line 432: "the owned-farmland threshold (15{,}500~m\textsuperscript{2}) is $t = -1.64$ ($p = .10$)". The prose says "all three margins pass the density-continuity test at conventional levels" — but p=.10 is exactly at the 10% boundary. A referee might fairly say the owned-farmland margin shows borderline manipulation evidence. Either acknowledge the borderline result or report bootstrap-CI bounds.

### m10. The Spec A pooled main table — when found — uses underscored variable names AND scriptsize-formatting-defaults
`tab_main_did_rd_en.tex` is not `\scriptsize` (it uses default size) but the column headers are `op_cost off_farm_income consumption farm_income` raw — will compile only if the underscore catcode is changed, or will throw errors. This table isn't currently `\input{}`-ed, so the bug is latent, but it will surface when the table is added (per C7 fix recommendation).

---

## Per-table audit

| Table # | Displayed in main? | Standalone? | Units clear? | N stated? | Inference stated? | Issues |
|---|---|---|---|---|---|---|
| Table~\ref{tab:notation} (lines 100-135) | YES inline | YES (good) | YES (m², KRW, year) | n/a | n/a | None — well done. |
| Table~\ref{tab:alpha3-predictions} (lines 265-283) | YES inline | PARTIAL — refers to "C-O 2003", "K et al. 2013", "E-K 1986" using acronyms | n/a | n/a | n/a | Acronyms not defined in caption — spell out first use. |
| Table~\ref{tab:descriptives_en} (Table 1) | YES via \input (line 319) | Partial — caption says "Descriptive Statistics by Treatment Status" with no year, no bandwidth, no N decomposition | Mixed (KRW, m²) — column unit not in header | N stated per group | "survey-weighted t-test" — cluster level NOT stated | C3 (numeric mismatch with §4 prose), C4 (zero imputed_payment row), m1 (scriptsize). Caption needs N(total), year, units in column header. |
| Table~\ref{tab:appB-mapping} | NO — only in online appendix | n/a (lives in appendix) | n/a | n/a | n/a | **C1: this is the headline F1 table; must be in main text.** |
| Main DiD-RD pooled (`tab_main_did_rd_en.tex`) | **NO — never \input** | Standalone OK but bandwidth=h*_mse opaque | KRW for all 4 outcomes — but `op_cost` includes rent vs §6 uses ex_rent | YES varies by outcome | "Cluster-robust SE (hh\_id)" stated, Holm/wild bootstrap "deferred" | **C7. Must be inserted into §6.** |
| CH4 rent decomposition (`tab_ch4_rent_decomposition_en.tex`) | **NO — never \input** | YES — good caption | YES (KRW, m²) | YES | YES (cluster hh_id) | **C2. Must be inserted into §6.** Plus footnote calls scenario "MIXED" — confusing. |
| Het own-share (`tab_het_own_share_en.tex`) | **NO — never \input** (but cited as "tab_het_own_share_en.tex" in §6 line 361) | Partial — 5 outcomes mixed (KRW + KRW/m² + m²) without column-level unit warning | Inconsistent across panels | NO — per-bin N not reported | Cluster hh_id stated | **C5 (footnote contradicts narrative), M7 (mixed units), M8 (three-channel coherence)**. Must be inserted into §6. |
| Wild bootstrap (`tab_wild_bootstrap_en.tex`) | **NO — never \input** | Partial — two panels with different bandwidth conventions | KRW | YES (implicit) | Wild bootstrap B=999 stated, Holm in Panel A only | **M2. Panel B needs Holm column.** |
| Spec B (`tab_specB.tex`) | YES via \input (line 409) | Caption says "drop 2020, Post≥2021" — contradicts §7.2 prose | KRW | YES per outcome | Cluster hh_id, "Wild bootstrap deferred" | **C6 — caption describes a different Spec B than the prose. Critical.** |
| Dropped balance (`tab_dropped_balance_en.tex`) | YES via \input (line 413) | YES — good caption | Mixed (KRW, m², tier) — units in row labels OK | YES (n_hh per group) | Welch's t-test, no clustering | m1 (scriptsize). The "Head age (tier 1-6)" row says "5 (1)" both groups but diff=1 — looks like a rounding/coding issue. |
| Attrition placebo (`tab_attrition_placebo_full_en.tex`) | YES via \input (line 417) | YES — good caption | n/a (probability indicator) | YES | YES (cluster hh_id) | Clean. |
| Placebo cutoffs (`tab_placebo_cutoffs_en.tex`) | YES via \input (line 421) | T2 only; T1 not displayed despite §7 claiming "32 cells" | KRW | NO — per-cell N missing | Cluster hh_id | **M3 — table shows 16 cells not 32; T1 panel missing.** m1 (scriptsize). |
| Outlier ladder (`tab_rob_outlier_en.tex`) | **NO — never \input** | Four separate tables (op_cost, off_farm_income, consumption, farm_income) | Mixed (KRW for Winsor rows, dimensionless for IHS rows) | YES | Cluster hh_id stated | **M9. Either inline op_cost panel in §7 or move to online appendix.** |

---

## Per-figure audit

| Figure # | Displayed? | Caption complete? | Axis units? | Legible 8pt? | Issues |
|---|---|---|---|---|---|
| fig:f1-fourbin-gradient (line 352) | YES | Partial — magnitude + p stated; missing N, CI level, error-bar definition | Caption implies m² on y but not stated | Cannot verify without rendering PDF | **M6.** Add N per bin, CI level, cluster. |
| fig:event-study-T2 (line 391) | YES | Partial — pre-period claim made but no coefficient/SE given | y-axis unit not stated (KRW? log? IHS?) | Cannot verify | **M5.** Add y-axis unit, CI level, reference year, N. |
| fig:honestdid (line 400) | YES | Partial — $\bar M^*$ breakdown discussed in §7 line 398 but caption doesn't state the actual breakdown value | Y-axis presumably 95% CI for $\hat\beta_1$ | Cannot verify | Caption should report the actual $\bar M^* = 0$ explicitly. |
| fig:mccrary (line 377) | YES | Partial — t, p stated; missing N | Caption doesn't say x is in m² or ha | Cannot verify | **M4.** Add N, x-axis unit. |
| fig:forest-treatment-defs (line 425) | YES | Good — explains color coding | Forest plot — units depend on outcome | Cannot verify | Caption could state "scaled per-outcome to standardize" if applicable. |
| fig:mccrary-multi-rv (line 434) | YES | Good — all three t-stats reported | Three panels with different x-axis units (m², m², KRW) — should state in caption | Cannot verify | Mild — units could be in caption explicitly. |

---

## Magnitude-vs-significance audit

| Claim in text | Coefficient given? | Magnitude given? | Benchmark (% of mean / subsidy)? | Verdict |
|---|---|---|---|---|
| "pure-tenant response is $+1{,}122$~m\textsuperscript{2} ($p = .041$)" (line 350) | YES | YES (m²) | NO (§8 line 446 belatedly says "22% of 0.5 ha threshold" — wrong benchmark) | Inadequate. Should be % of pure-tenant baseline own-area. |
| "+1,674 / +728 / +183 / −277 / 0 at T1" (line 350) | YES | YES | NO | Inadequate. Just raw m². |
| "operating cost net of rent is $-3.98$M~KRW at T1 ($p = .057$)" (line 359) | YES | YES | YES — "−29% relative to pre-period 13.6M" and "≈3.3× annual SFFP" | **Adequate** (modulo C3 numeric inconsistency on the 13.6M benchmark). |
| "T3 attenuates to approximately zero ($p > .50$)" (line 359) | NO — no point estimate given | NO | NO | Inadequate. Per table actual T3 = +215,034 — say so. |
| "F2 result: small and statistically near zero" (line 361) | NO | NO | NO | **Inadequate.** Per Table `tab_main_did_rd_en.tex` actual T2 β₄ = +1.97M with SE 3.90M. Disclose. |
| "rent-cost reduced-form pass-through is $-12.0\%$ at T2 ($\hat\beta_5 = -144{,}027$ KRW, $p = .133$)" (line 363) | YES | YES (% of subsidy) | YES (Kirwan +25%, Ciaian +46-55%) | **Adequate.** Best-treated number in the paper. |
| "the 2018 pre-period coefficient is statistically zero ($|t| < 1$)" (line 389) | NO | NO | NO | Inadequate. Give the coefficient, SE, and t. |
| "headline-cell coefficients agree with Spec A...Spec A op_cost_ex_rent at T1 = $-3.98$M, Spec B = $-4.88$M" (line 407) | YES | YES | NO benchmark | Adequate — comparison done. **But the Spec B claim of $-4.88$M does not match `tab_specB.tex` line 11 which says $-5,051,970 = -5.05M$.** Off by 0.17M. |
| McCrary t=1.34, p=.18, n=2680 (line 374) | YES | YES | n/a | Adequate. |
| "92.3% administrative receipt rate" (line 450, line 263) | YES | n/a | n/a | Footnote source given; not in displayed table. |

---

## Holm correction status

**Status: PARTIAL and INCONSISTENT.**

- §5 line 339 declares: "Across the primary outcome family (the four outcomes), we apply Holm step-down correction to control the family-wise error rate."
- `tab_wild_bootstrap_en.tex` Panel A: `p_wild_holm` column populated for the 8 P2 replication cells (per-outcome MSE bandwidth).
- `tab_wild_bootstrap_en.tex` Panel B: 6 CH4 cells (rent_cost × {T1,T2,T3}, op_cost_ex_rent × {T1,T2,T3}) — **no `p_wild_holm` column.**
- `tab_main_did_rd_en.tex` footnote: "Stars = Holm step-down adjusted p-value. Wild / fractional cluster bootstrap deferred to P3" — but the stars in the cells are not visible in the table (no `*` marks appear on any cell coefficient because none of the pooled cluster-robust p-values cross the threshold after Holm adjustment).
- `tab_ch4_rent_decomposition_en.tex` line 9: shows `*` on op_cost_ex_rent T1 (−3,978,705*) — this star is the RAW cluster-robust p<.10, not Holm-adjusted. Footnote does not clarify.
- §6 prose reports "$p = .057$" (line 359) — **raw cluster-robust, not Holm-adjusted.** The reader is expected to mentally adjust for 4 outcomes.

**Fix required:** Every p-value in §6 prose must be labelled as one of: `p_cluster` (raw), `p_wild` (wild bootstrap raw), or `p_wild_holm` (Holm-adjusted wild bootstrap). Currently they are unlabelled and ambiguous. The headline op_cost_ex_rent T1 result transforms from "p=.057 (raw cluster)" → "p=.023 (wild raw)" → "p=~0.09 (Holm-adjusted wild)" depending on which row of which table the reader trusts. AJAE referees will see this immediately.

---

## Summary

The §6 results section relies on **no displayed tables** for any of its headline claims. The four most important results tables (F1 four-bin gradient, pooled DiD-RD, CH4 rent decomposition, wild bootstrap inference) are present in `scripts/R/_outputs_eligibility/` but never `\input{}`-ed in main.tex. The displayed Table 1 (descriptives) contradicts §4 prose on the operating-cost benchmark by ~11M KRW. The displayed Spec B table caption contradicts §7.2 prose on what Spec B even is. The headline op_cost benchmark "−29% of 13.6M" inherits the §4/Table 1 mismatch. Holm correction is invoked but not consistently displayed; p-values in §6 prose are unlabelled.

**Score: 4/10.** Below the 80-commit threshold and well below the 90-submission threshold. C1/C2/C3/C6 are submission-blocking. With table insertions + numeric reconciliation + footnote regeneration this can reach 8/10 (90-equivalent) within one revision pass.

**Top priority fixes (ordered):**
1. (C1) `\input{tab_het_own_share_en.tex}` (or a curated F1 panel) in §6 after line 350.
2. (C2) `\input{tab_ch4_rent_decomposition_en.tex}` in §6 after line 360.
3. (C7) `\input{tab_main_did_rd_en.tex}` in §6 between F1 and op_cost paragraphs.
4. (C3) Reconcile 41.1M / 13.6M / 30.0M / 8.4M — pick one sample, one year set, one variable, recompute, fix all four citing locations.
5. (C6) Fix `tab_specB.tex` caption to match the actual Spec B definition (richer covariates) — or regenerate the table with the prose-described spec.
6. (C5) Regenerate `tab_het_own_share_en.tex` with Wave 7 footnote (drop the "γ: OWN_CULTIVATION DOMINANT" auto-classifier line).
7. (M2) Add `p_wild_holm` column to Panel B of `tab_wild_bootstrap_en.tex`. Label all §6 p-values as raw vs. Holm-adjusted.
8. (m4) Reconcile T3 bandwidth claims (h≈3,300 vs. h≈1,710) — pick one and apply uniformly.
