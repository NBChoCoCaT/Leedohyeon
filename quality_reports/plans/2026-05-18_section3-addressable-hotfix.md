# §3 ADDRESSABLE hot-fix (10 referee concerns + 7-item pre-§1 checklist deferred items)

**Date:** 2026-05-18
**Branch:** `feat/section3-addressable-hotfix` (new, off `main`)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 1.5–2 h (per project-memory resume note)
**Sister project plan path:** `quality_reports/plans/2026-05-18_section3-addressable-hotfix.md` (copied post-approval, before edits start)

---

## Context

The §3 α3 alpha-test peer review (PR #5/#6 merged 2026-05-18) returned a Major-Revision verdict with **0 FATAL, 10 ADDRESSABLE, 7 TASTE** concerns. AJAE acceptance probability under clean R&R: **65–72%**. The §1 Abstract+Introduction α3 rewrite (PR #6, merged 05dcb36) closed 1 of 7 pre-§1 checklist items (`s_0` quintile pre-spec lock); **6 items remain** and map directly onto the 10 ADDRESSABLE concerns. The CoVe post-flight on §1 also surfaced 3 cannot-verify follow-ups (C10 novelty — already protected by "to our knowledge" hedge; C12 FHES microdata transparency; C13 τ KAMICO/KREI primary source — same as ADDRESSABLE A4).

This hot-fix is the **single highest-leverage path** to a clean R&R-ready §1+§3 bundle before §5 Results re-tabulation begins. Every change here is presentation / citation / disclosure — **no re-derivation, no new data analysis, no contribution reframing**. The α3 theoretical core (AHM-extension, Carter-Olinto-derived predictions, B.1 ex-theory demotion triple-confirmed honest-reframe) is preserved.

---

## Critical files to modify

| File | Sections touched | Edit type |
|------|------------------|-----------|
| `paper/en/main.tex` | §3 head (notation table); §3.1 (ITT/Roth paragraph close); §3.2 (eq:CO-1 bridge, $T_i$ harmonization, SC list); §3.4 (magnitude calibration sub-§3.4.1, ADR-0002 timing footnote, annual-flow/FHES cross-refs, F2 tightening) | Insertions + surgical edits |
| `paper/en/online_appendix.tex` | §B.1 (SC2.5 primitive, $s_0$ partition rule footnote); §B.3 (per-bandwidth T1/T2/T3 grid, operational falsification triggers) | Surgical edits + table expansion |
| `Bibliography_base.bib` | Add: KREI/KAMICO τ source, Roth (2022), Rambachan-Roth (2023), Choi-Jodlowski (2025), 최민영·문한필 (2025) | New entries (dual-form Korean entries) |
| `paper/en/main.tex` §4 Data (L207–213) | MDIS application URL + Wave 1 take-up rate footnote (C12) | Footnote addition |
| `paper/ko/main.tex` | **UNTOUCHED** (CLAUDE.md "Never simultaneous bilingual edits" rule) | — |

---

## Implementation order (10 ADDRESSABLE + ancillary bib + §4 footnote)

Order chosen to **front-load load-bearing fixes** (A4 highest leverage per editor) and **batch related edits** to one section to minimize diff complexity.

### Phase 1 — Bibliography prep (~15 min)
1. Add `Bibliography_base.bib` entries (dual-form for Korean):
   - `Roth2022_pretrends` — Roth, J. (2022), "Pretest with Caution," AER:I 4(3)
   - `RambachanRoth2023_honestdid` — Rambachan & Roth (2023), "A More Credible Approach to Parallel Trends," RES
   - `KREI_prodcost_2022` — KREI 농산물 생산비조사 (annual production-cost survey, AJAE-friendly primary source)
   - `KAMICO_pricelist_2022` — KAMICO 농기계 가격조사 (industry price-list, direct tractor/combine reference; secondary)
   - `ChoiJodlowski2025_landreg` — already on CLAUDE.md TODO list
   - `ChoiMun2025_pidps_offinc` — 최민영·문한필 (2025) RDD off-farm-income paper
2. Validate `/validate-bib` clean.

### Phase 2 — §3 head: notation table + A2/A1 bridge (~20 min)
3. **A2 (notation table)** — Insert table at L78 (between `\label{sec:theory}` and `\subsection{Baseline AHM}`):
   - Symbols column: $\{W_i, T_i, T_{SFFP}, D_i, s_{0,i}, \varphi(W_i^*), W_i^*, \tau, m, \mu/\lambda, w_{f,i}, w_m, \rho(W_i), A_{own,i}, A_{rent,i}, \beta\}$
   - Definition column: one-line each
   - First-use equation column: `(\ref{eq:ahm-objective})`, `(\ref{eq:CO-threshold})`, etc.
4. **A2 harmonization sweep** — `$T_i$` → `$T_i = T_{SFFP} \cdot D_i$` first-use, then `$T_i$` consistently. Audit §3.1/§3.2/§B.1 for drift. `s_{0,i}` subscript ordering pinned.
5. **A1 (eq:CO-1 bridge)** — One-paragraph insertion between §3.2 L138 and L141 (before `\label{eq:CO-2}`):
   > "Equation (\ref{eq:CO-1}) is a population-aggregate threshold-crossing magnitude written at the individual indexed by $i$ for compactness; the implied estimand is $\partial \mathbb{E}[A_{own,i} \mid \text{eligibility window}]/\partial T_{SFFP}$, i.e., an average over the $\varphi(W_i^*)$-weighted marginal types. The DiD-RD specification in §\ref{sec:identification} recovers this aggregate marginal effect as the local average treatment effect at the cutoff."

### Phase 3 — §3.2/§B.1: A3 (SC typology + SC2.5) + A6 (`s_0` partition rule cross-ref) (~20 min)
6. **A3** — In §B.1 SC list, relabel buckets into four types: *sufficient-for-sign*, *regularity*, *identification*, *interior-solution*. Add **SC2.5**: "baseline wealth $W_i$ and baseline own-share $s_{0,i}$ are negatively correlated within the eligibility window" + FHES correlation coefficient one-liner (use placeholder `corr(W_i, s_{0,i}) = [TBD from FHES Wave 1]` until measured, with comment `% FILL post-§5 P3 run`).
7. **A6** — §B.1 Step 3 (after `eq:appB-step3`) footnote: pin partition rule = four-bin `{pure_tenant: s_0=0; low_owner: 0<s_0≤0.33; mixed: 0.33<s_0≤0.67; pure_owner: s_0=1}` + ADR-0002 timestamp cross-ref + R-conventions §10 cross-link. **Mirror** from §1 ¶2 footnote 2 (already in `main`).

### Phase 4 — §3.4: A4 + A10 magnitude calibration §3.4.1 (highest leverage, ~25 min)
8. **A4 + A10 combined** — Insert new `\subsubsection{Magnitude calibration}` (label `sec:calibration`) between current §3.4 paragraph (L175) and the `tab:alpha3-predictions` table (L177). ~250 words covering:
   - Sourced $\tau$ dual citation: `\citep{KREI_prodcost_2022, KAMICO_pricelist_2022}` (Phase 1 entries)
   - **25M down-payment vs 50M purchase-price reconciliation footnote** (per CoVe C13 + editor's verdict §80–90; ≈50% LTV under typical Korean farm-equipment financing reconciles the two — explicit one-line statement)
   - Robustness range: $\beta_3 \le 0$ holds for $\tau \in [20\text{M}, 40\text{M}]$ KRW
   - $T_{SFFP}/\tau \in [0.024, 0.048]$ → comfortably inside Caballero-Engel inaction band
   - **Annual-flow vs lump-sum interpretation of $T_{SFFP}$** (A10) — "₩1.2M is an annual flow; we interpret the (S,s) capital-adjustment threshold $\tau$ as a discrete purchase event, with $T_{SFFP}/\tau$ measuring per-period transfer scale relative to one-shot adjustment scale."
   - FHES Wave 1 wave-table cross-refs: 92.3% take-up; 17–34% hired-labor share (placeholder `[FHES Wave 1, Table X.Y]` until measured)
   - One-line on $s_0$ measurement-error attenuation + four-bin discreteness robustness

### Phase 5 — §3.1 / §3.4: A7 + A8 disclosure paragraphs (~15 min)
9. **A7 (ADR-0002 timing)** — Footnote at §3.4 L181 outcome table caption or at L88 §3.1 first paragraph: explicit disclosure that outcome hierarchy is the α-strict realignment adopted under ADR-0001/0002 prior to §5 estimation, with reference to public ADR archive in `scripts/R/synthetic/README.md`. Mirror to §3 from §1 ¶2 footnote 2 (already in main).
10. **A8 (ITT/Roth-2022/HonestDiD)** — ~80-word paragraph at close of §3.1 (after L114):
    > "The DiD-RD design exploits the 2018-baseline frozen cutoff at 5{,}000 m\textsuperscript{2}; the recovered estimand is therefore an ITT over eligibility-as-determined-by-2018-area. We caveat $\partial A_{own,i}/\partial T_{SFFP}$ in (\ref{eq:CO-1}) as the eligibility-induced effect on post-period own area, robust to post-2020 threshold-crossings being endogenous. Parallel-trends inference rests on the 2018–2019 pre-period gap (\citealp{Roth2022_pretrends}); we report HonestDiD M̄ sensitivity bounds (\citealp{RambachanRoth2023_honestdid}) in the robustness appendix."

### Phase 6 — §3.4 / §B.3: A5 (F2 tightening) + A9 (per-bandwidth grid) (~15 min)
11. **A5 (F2 tightening) — DEMOTE.** Edit §3.4 L200 `\item[\textbf{F2.}]`: reframe F2 as "informative-but-not-rejecting" with explicit EK-1 sign-indeterminacy footnote — "$\hat\beta_4 = 0$ can reflect mechanism-inoperative OR mechanism-operative-with-canceling-effects (transfer relaxes both family-time scarcity favoring more off-farm labor AND cash constraint driving supervised hiring favoring less off-farm labor; cancellation possible at SFFP scale)." F1+F2 joint logic in `\item[\textbf{F1 + F2 jointly}]` (L201) updates to **F1 alone is rejection-bearing**, F2 supports. LaFave-Thomas graceful-failure clause unchanged.
12. **A9 (per-bandwidth §B.3 grid) — LANDSCAPE.** Verify `\usepackage{lscape}` in `paper/en/preamble*.tex` or `online_appendix.tex` header; add if missing. Replace single-row `tab:appB-mapping` rows (L406–409) with **full per-bandwidth grid**: 5 channels × {T1, T2, T3} × full $\hat\beta_1$–$\hat\beta_5$ cells. Wrap in `\begin{landscape}...\end{landscape}`. Operationalize falsification triggers per bandwidth (e.g., "F1 fires if $p(\hat\beta_2 > 0) > .10$ at T2 *and* four-bin point estimates fail to be monotone in the predicted direction at T1 *and* T2"). Tie to R-conventions §10.

### Phase 7 — Ancillary: §1 ¶6 cite + §4 microdata footnote (~10 min)
13. **§1 ¶6 cite update** — Replace TODO comment in §1 ¶6 with actual `\citep{ChoiJodlowski2025_landreg}` and `\citep{ChoiMun2025_pidps_offinc}` cites (entries added in Phase 1). One-sentence differentiation:
    > "Choi and Jodlowski (2025) study land-ownership regulation; 최민영·문한필 (2025) use an off-farm-income RDD only on the same 0.5 ha cutoff. Neither runs a DiD-RD with an AHM-separability test at the per-farm flat-rate cutoff."
14. **§4 Data MDIS footnote (C12)** — One-footnote at §4 (L208 area): MDIS application URL (kostat.go.kr/menu.es?mid=a20201060000 or canonical FHES microdata URL) + internal-verification log reference (CLAUDE.md "verified on `panel_2018_2022.dta` 2026-05-06"). Per editorial A6 and CoVe C12.

### Phase 8 — Verification (~15 min)
15. `latexmk -xelatex` on `paper/en/main.tex` — clean compile, no undefined citations, no warnings beyond the existing baseline.
16. `/validate-bib` — clean (no new orphans).
17. **Spot CoVe** on the 4 new bib entries (Roth 2022 AER:I, Rambachan-Roth 2023 RES, KREI τ source, ChoiMun 2025) — via `/verify-claims` on the bib entries only (~5 min).
18. Quick visual diff vs editorial_decision.md A1–A10 checklist (each item ticked off).

### Phase 9 — Commit + PR (~10 min)
19. `git checkout -b feat/section3-addressable-hotfix`
20. Stage + `/commit` (quality_score.py runs; threshold 80 advisory)
21. `gh pr create` against `main` with title: `§3 ADDRESSABLE hot-fix: 10 referee concerns + 6 pre-§1 checklist items`. Body: itemized A1–A10 mapping + bib entries + verification checklist.
22. Manual approval mode — user reviews PR before merge.

---

## Decisions locked (2026-05-18 pre-implementation)

**Q1 — τ source: Triangulate.** Cite **both** KREI 농산물 생산비조사 (primary, AJAE-friendly) **and** KAMICO 농기계 가격조사 (industry price-list, direct tractor/combine reference). Footnote in §3.4.1 explicitly reconciles 25M (down-payment-equivalent, ≈50% LTV on 50M purchase under typical Korean farm-equipment financing) vs 50M (KAMICO 30HP-class purchase-price midpoint). Bib entries: `KREI_prodcost_2022` + `KAMICO_pricelist_2022` (years to confirm during Phase 1).

**Q2 — F2 tightening (A5): Demote.** F2 reframed as "informative-but-not-rejecting" with explicit EK-1 sign-indeterminacy footnote ("$\hat\beta_4 = 0$ can reflect mechanism-inoperative OR mechanism-operative-with-canceling-effects"). F1+F2 joint logic rests on **F1 alone with F2 as supporting evidence**. No new spec needed in §5. (~5 min path.)

**Q3 — §B.3 per-bandwidth grid (A9): Full 3×4 grid + landscape.** Use `\begin{landscape}...\end{landscape}` (lscape package — verify it's in preamble; if not, add `\usepackage{lscape}`). Per-bandwidth grid: each of 5 channels × {T1, T2, T3} with full $\hat\beta_1$–$\hat\beta_5$ coefficient cells. Audit-friendliest layout; closes EMPIRICAL referee C5 "operationally underspecified" fully.

---

## Verification (end-to-end)

1. **Compile:** `cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex` — exit 0, PDF builds, no new undefined citations, page count within +1 of current 15 p baseline.
2. **Bib validation:** `/validate-bib` reports clean (no orphans, no missing entries for new cites).
3. **CoVe on 4 new bib entries:** `/verify-claims` against Roth 2022 AER:I, Rambachan-Roth 2023 RES, KREI/KAMICO τ source, ChoiMun 2025 — all PASS or with explicit `cannot-verify` notes documented.
4. **Editorial checklist:** Each of A1–A10 ticked off against `editorial_decision.md` §§35–48; 7-item pre-§1 checklist items #1, #2, #3, #4, #6, #7 marked ✅.
5. **No `paper/ko/` diff:** `git diff main paper/ko/` empty (CLAUDE.md bilingual rule).
6. **Quality score:** `python scripts/quality_score.py paper/en/main.tex` returns ≥ 80; ideally ≥ 85 given α3 baseline.

---

## What this hot-fix does NOT do (out of scope, deferred)

- §5 Results re-tabulation under α3 outcome hierarchy (option B, larger task; depends on P3b re-run data)
- `/seven-pass-review` integration audit (option E', after this hot-fix completes)
- C10 novelty cannot-verify (already protected by "to our knowledge" hedge in §1)
- §1 prose changes beyond the 2 ancillary cites in ¶6 (§1 wholesale rewrite is locked in PR #6)
- TASTE concerns from editorial_decision.md §§52–63 (Strauss 1986, Ghatak-Mookherjee 2024, Pitt-Rosenzweig 1986, Sotelo 2020 — author may push back; not load-bearing)
- AEA DCAS v1.0 synthetic-generator footnote at §3 (TASTE; SHOULD-do, can bundle later)
