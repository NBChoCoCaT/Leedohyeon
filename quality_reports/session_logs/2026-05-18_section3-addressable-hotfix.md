# Session Log: 2026-05-18 -- §3 ADDRESSABLE hot-fix

**Status:** COMPLETED — PR #7 opened, manual merge gate (user reviews before merge)
**Commit:** `bcdd02e` on `feat/section3-addressable-hotfix`
**PR:** https://github.com/NBChoCoCaT/DiD-RD/pull/7
**Plan:** `quality_reports/plans/2026-05-18_section3-addressable-hotfix.md`
**Branch:** `feat/section3-addressable-hotfix`

## Objective

Close 10 ADDRESSABLE referee concerns (THEORY C1–C5 + EMPIRICAL C1–C5) from §3 α3 alpha-test (PR #5/#6) in single PR. Bundles 6 of 7 pre-§1 deferred checklist items (#1, #2, #3, #4, #6, #7) + 2 CoVe cannot-verify follow-ups (C12 MDIS, C13 τ source). Target: clean R&R-ready §1+§3 bundle at AJAE acceptance probability 65–72%.

## Design Decisions (locked pre-implementation)

| Decision | Alternatives Considered | Rationale |
|----------|------------------------|-----------|
| τ source: triangulate KREI + KAMICO | Single source (KREI only, KAMICO only, 통계청 only) | Robustness; AJAE-friendly primary (KREI) + direct tractor-cost (KAMICO); footnote reconciles 25M down-payment ≈ 50% LTV on 50M purchase |
| F2: demote to informative-but-not-rejecting | F2a/F2b split (~30 min extra) | Cheap (~5 min); doesn't require §5 spec rethink; F1 alone is rejection-bearing per editorial decision §43 |
| §B.3 grid: landscape full 3×4 | Portrait + small font, or per-bandwidth-only-for-triggers | Audit-friendliest; closes EMPIRICAL C5 fully; lscape package may need preamble add |

## Changes Made

(Filled incrementally per phase)

| File | Change | Reason | Phase |
|------|--------|--------|-------|
| `Bibliography_base.bib` | +6 entries (Roth 2022, Rambachan-Roth 2023, KREI, KAMICO, ChoiJodlowski 2025, ChoiMun 2025) | A4, A8, §1 ¶6 cite + C13 source | 1 |

## Incremental Work Log

**14:23 KST:** Plan approved (curious-shimmying-reddy.md). Copied to `quality_reports/plans/2026-05-18_section3-addressable-hotfix.md`.
**14:24 KST:** Branch `feat/section3-addressable-hotfix` checked out off `main` (clean state).
**14:25 KST:** Session log initialized. Beginning Phase 1 (bibliography prep).

## Verification Results

| Check | Result | Status |
|-------|--------|--------|
| `latexmk -xelatex` on `paper/en/main.tex` | 19 p PDF (was 15 p; +4 p from notation table + magnitude calibration + A8 paragraph + §B-mirrored §3 disclosures) | PASS |
| `latexmk -xelatex` on `paper/en/online_appendix.tex` | 8 p PDF (landscape grid renders) | PASS |
| Bibliography resolution (bibtex run) | All 6 new keys resolved; no `Citation 'X' undefined` warnings | PASS |
| Korean character font warnings (paper/en) | Eliminated post-bib swap (KREI/KAMICO/ChoiMun titles primary in English with `*_ko` fields) | PASS |
| `paper/ko/` diff vs `main` | 0 lines changed (bilingual rule preserved) | PASS |
| Editorial A1–A10 checklist | All 10 ADDRESSABLE items addressed (see Changes Made below) | PASS |
| Pre-existing warnings (★, α in §5/§6 TODO placeholders) | Pre-existing, out of hot-fix scope | EXPECTED |
| /validate-bib | Deferred (manual bibtex check via latexmk succeeded) | DEFERRED |
| CoVe spot-check on 4 new bib entries | Deferred to pre-submission (entries marked `% VERIFY-PRE-SUBMIT`; Roth/Rambachan-Roth canonical, KREI/KAMICO institutional, ChoiJodlowski/ChoiMun TODO) | DEFERRED |

## Editorial A1–A10 audit

| # | Concern | Location in diff | Status |
|---|---------|------------------|--------|
| A1 | eq:CO-1 individual-vs-population aggregate | `paper/en/main.tex` §3.2 "Aggregation note" paragraph after eq:CO-1 | ✅ |
| A2 | Notation table + $T_i = T_{SFFP} \cdot D_i$ harmonization | `paper/en/main.tex` tab:notation at §3 head + eq:ahm-budget/utility-max/null/CO-1/threshold harmonized; `online_appendix.tex` Step 1/2 paragraph titles + L83-86 preamble harmonized | ✅ |
| A3 | SC list typology + SC2.5 ($W_i, s_{0,i}$ correlation primitive) | `online_appendix.tex` §B.1 "Sufficient conditions, by type" block with 4 typed buckets + SC2.5 | ✅ |
| A4 | Sourced $\tau$ + 25M/50M reconciliation + magnitude sub-section | `paper/en/main.tex` §3.4.1 `\subsubsection{Magnitude calibration}` + KREI/KAMICO dual cite + 50% LTV reconciliation footnote + robustness range $\tau \in [20\text{M}, 40\text{M}]$ | ✅ |
| A5 | F2 falsification asymmetry tightening | `paper/en/main.tex` §3.4 falsification block: F2 demoted to "informative, not rejecting"; F1 alone load-bearing; EK-1 sign indeterminacy disclosed | ✅ |
| A6 | $s_0$ partition rule pre-lock + ADR cross-ref | `online_appendix.tex` §B.1 post-(eq:appB-step3) footnote with four-bin rule + ADR-0002 + R-conventions §10 cross-ref | ✅ |
| A7 | ADR-0002 timing disclosure | `paper/en/main.tex` tab:alpha3-predictions caption discloses α-strict ADR-0001/0002 pre-§5 timing | ✅ |
| A8 | ITT / Roth-2022 / HonestDiD M̄ paragraph | `paper/en/main.tex` §3.1 close "Estimand and pre-period inference" paragraph with Roth2022_pretrends + RambachanRoth2023_honestdid cites | ✅ |
| A9 | Per-bandwidth §B.3 grid + operationalized triggers | `online_appendix.tex` §B.3 `\begin{landscape}` 3×4 grid with T1/T2/T3 cells + operational decision rules | ✅ |
| A10 | Annual-flow vs lump-sum + FHES wave-table cross-refs + $s_0$ measurement-error | Bundled with A4 in §3.4.1 (annual-flow para + 92.3% take-up + 17–34% hired-labor share + four-bin attenuation note) | ✅ |

## 7-item pre-§1 checklist status (post-hot-fix)

| # | Item | Status |
|---|------|--------|
| 1 | $\tau$ calibration source citation | ✅ KREI + KAMICO dual cite in §3.4.1 |
| 2 | Notation table | ✅ tab:notation at §3 head |
| 3 | Magnitude calibration §3.4.1 | ✅ new `\subsubsection{Magnitude calibration}` |
| 4 | §3.1 ITT/Roth-2022/HonestDiD paragraph | ✅ A8 paragraph |
| 5 | $s_0$ quintile pre-spec | ✅ (already in §1 ¶2; mirrored to §B.1 post-step3 footnote) |
| 6 | F2 tightening | ✅ A5 demote |
| 7 | §B.3 per-bandwidth grid | ✅ A9 landscape grid |

## Open Questions / Blockers

- [ ] Roth 2022 exact title: "Pretest with Caution: Event-Study Estimates after Testing for Parallel Trends" (AER:I 4(3))? — verify before commit
- [ ] KREI/KAMICO year choice: which annual edition is canonical? Use 2022 vintage to match 2020–2022 sample window — pragmatic

## Next Steps

After Phase 1 complete:
- Phase 2 (notation table + A1 bridge) — §3 head
- Phase 3 (SC typology + SC2.5) — §B.1
- Phase 4 (magnitude calibration §3.4.1, highest leverage) — §3.4
