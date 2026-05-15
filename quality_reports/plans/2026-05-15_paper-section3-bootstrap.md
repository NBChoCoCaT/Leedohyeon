# Plan — paper/en §3 (Theoretical Framework) LaTeX Bootstrap + Scenario β framing

**Status:** APPROVED (Dohyeon, 2026-05-15)
**Date:** 2026-05-15 (Session 3 — option A entry after P3c Phase 1 merge `709ceda`)
**Author:** Lee Dohyeon (Claude assist)
**Sister (post-approval):** `01_dissertation_PBDP/quality_reports/plans/2026-05-15_paper-section3-bootstrap.md`
**Mode:** manual approval, plan-first; user invokes `/commit` after implementation; §1 intro deferred to next session

---

## Context

P3c Phase 1 merged at `709ceda` 2026-05-15. Scenario verdict = **β (mixed evidence)**, three core findings: (1) +0.1517 contamination quantified; (2) Form B sign consistent with Ch5 prediction (β<0) but underpowered; (3) Channel 4(iii) endogeneity critique resolved (selection share 3.7%). Submission strategy AJAE direct 50–55% retained; 5-channel framework intact; **Channel 5 reframed from primary mechanism → supplementary robustness anchor**.

This plan bootstraps `paper/en/main.tex` from scratch (currently no `paper/en/` directory exists). Scope = scaffold + **§3 Theoretical Framework full content** with Scenario β framing on §3.6bis. §1 introduction deferred to next session per user.

## Exploration findings (this session)

- `paper/en/` directory does NOT exist. Only `paper/narrative_draft_p3b.md` for §5–§6 mechanism narrative.
- `Bibliography_base.bib` (58 lines) is **essentially empty** — only template entries Example2024_book / Example2025_article. **All 11 §3-critical citations missing.**
- `Preambles/header.tex` (148 lines) — Beamer-specific block (lines 74–95) but otherwise reusable for article class. Strategy: create `paper/en/preamble_en.tex` selecting non-Beamer portions.
- `master_supporting_docs/own_drafts/초안.md` (388 lines) §3 content (lines 60–189) provides Korean bootstrap source for translation.
- Project replication conventions: XeLaTeX engine, double-spaced, AJAE submission target (≤50 pages double-spaced including references per CLAUDE.md), bilingual dual-field bib convention.
- BasicTeX with `xecjk biblatex biber latexmk` installed per MEMORY [LEARN:env] 2026-05-06 → compile-verify feasible this session.

## Out-of-scope (deferred per user)

- §1 Introduction full content → next session.
- §2 Institutional Context, §4 Data, §5 Identification, §6–§9 → stub-only (`\section{}` + 2-3 line placeholder describing what goes there).
- `paper/ko/main.tex` → per CLAUDE.md "Deferred until paper/en stable".
- Bib pre-flight verification per MEMORY [LEARN:citation-verification] 2026-05-06 → entries drafted **TENTATIVE**, marked `% VERIFY-PRE-SUBMIT`. Full verification at submission stage.
- S2 hazard model in §3.6bis → deferred from P3c.
- Wild bootstrap on exit cells → spec §4 defers to P3c Phase 2.

## Implementation: 5 phases, ~5h wall-clock

### File-by-file changes

| Path | Action | Lines | Phase |
|---|---|---|---|
| `Bibliography_base.bib` | **REPLACE template + APPEND 11 entries** | +60 | 1 |
| `paper/en/preamble_en.tex` | **CREATE** | ~70 | 2 |
| `paper/en/main.tex` | **CREATE** | ~450 (§3 full + stubs) | 3, 4 |
| `paper/en/main.pdf` | CREATE (runtime, latexmk) | binary | 5 |
| `quality_reports/plans/2026-05-15_paper-section3-bootstrap.md` | CREATE (sister, identical) | this file | post-approval |
| `quality_reports/session_logs/2026-05-15_paper-section3.md` | CREATE | grows | post-approval |

### Phase 1 — Bibliography population (~45min)

Replace `Bibliography_base.bib` template entries with **11 §3-critical** BibTeX entries. Drafted from memory; marked `% TENTATIVE — verify pre-submission`:

1. `SinghSquireStrauss1986_ahm` — *Agricultural Household Models* (World Bank/JHU Press)
2. `DeJanvryFafchampsSadoulet1991_peasant` — *Economic Journal* on peasant household + market imperfections
3. `CaballeroEngel1999_lumpy` — *Econometrica* (S,s) lumpy investment
4. `Sandmo1971_uncertainty` — *AER* on competitive firm under price uncertainty
5. `BlundellPistaferri2003_consumption` — IFS Working Paper or *Review of Economic Studies* on consumption smoothing
6. `Kirwan2009_rentcap` — *JPE* 117(1) US farmland rent capitalization
7. `CiaianEspinosaGomezPalomaHeckelei2023_eucap` — *Land Use Policy* 134 EU per-hectare capitalization
8. `Kimhi2000_exit` — *AJAE* 82(1) on part-time farming + exit dynamics
9. `PietolaVareOudeLansink2003_exit` — *ERAE* 30(1) Finnish farm exit
10. `Foltz2004_dairy` — *AJAE* 86(3) dairy farm entry-exit
11. `KazukauskasNewmanSauer2013_decoup` — *Agricultural Economics* on decoupled subsidies + retention/productivity

Style: Plain `@article{key, ... }` / `@book{ ... }` blocks with author/title/journal/volume/number/pages/year/doi fields. Korean entries (Choi-Jodlowski 2025, 최민영-문한필 2025) deferred to next session with §1 (they are differentiation citations, not §3).

### Phase 2 — `paper/en/preamble_en.tex` (~15min)

Extract non-Beamer portions of `Preambles/header.tex`:
- `\usepackage{iftex}` engine detection
- `amsmath, amssymb, amsthm, booktabs, graphicx`
- `xcolor` palette (primary-blue, primary-gold, etc.)
- `hyperref` with colorlinks
- (skip Beamer-specific lines 74-95)

Add article-specific elements:
- `\usepackage[margin=1in]{geometry}` (AJAE convention)
- `\usepackage{setspace}` + `\doublespacing` (journal submission)
- `\usepackage[round, authoryear]{natbib}` (AJAE style)
- `\usepackage{caption}` + `\captionsetup{font=small}`

### Phase 3 — `paper/en/main.tex` scaffold (~20min)

```latex
\documentclass[12pt, a4paper]{article}
\input{preamble_en}

\title{Three-Channel Tenant-Driven Land Transition: Evidence from Korea's Per-Farm Flat-Rate Direct Payment Scheme}
\author{Lee, Dohyeon\\Korea University, Dept.\ of Food and Resource Economics}
\date{\today}
\bibliographystyle{aer}  % or chicago / kluwer per AJAE preference

\begin{document}
\maketitle

\begin{abstract}
% TODO §1 ABSTRACT (next session)
\end{abstract}

\section{Introduction} % TODO (next session)
\textit{[Stub — full introduction next session.]}

\section{Institutional Context} % TODO
\textit{[Stub — PIDPS-SFFP statute, 0.5 ha cutoff, 1.2M KRW flat / 2.05M area-prop.]}

\section{Theoretical Framework}
\input{section3_theory}  % OR inline §3 here, see Phase 4

\section{Data} \textit{[Stub — FHES Wave 1.]}
\section{Identification Strategy} \textit{[Stub — DiD-RD §5 + parallel-trends gate.]}
\section{Results} \textit{[Stub — 4-channel headline + Ch5 supplementary.]}
\section{Robustness} \textit{[Stub — outlier ladder, Wild bootstrap, McCrary density.]}
\section{Discussion} \textit{[Stub — per-farm vs per-ha design lessons.]}
\section{Conclusion} \textit{[Stub — policy implication.]}

\bibliography{../../Bibliography_base}
\end{document}
```

### Phase 4 — §3 Theoretical Framework full content (~3h)

Structure (~5–7 compiled pages; ~3,500–4,500 words + equations):

```
§3.1 Notation (table format)
§3.2 Baseline AHM (Singh-Squire-Strauss 1986) — separability → β=0 H0
§3.3 Non-separable extension (de Janvry-Fafchamps-Sadoulet 1991)
§3.4 Channel 1 (S,s) Lumpy Investment — Caballero-Engel 1999 — MAIN
   - calibration T/s_min ≈ 2.4% (한국 농기계 ~5천만, 자가부담 ~2,500만 KRW)
   - prediction β(op_cost_ex_rent) ≤ 0; empirical: T1 -4.02M p=.055, T2 -3.22M p=.079 ✅
§3.5 Channel 2 (Sandmo 1971) — Precautionary off-farm labor
   - prediction β(off_farm_income) < 0
§3.6 Channel 3 (Blundell-Pistaferri 2003) — Consumption smoothing
   - prediction β(consumption) > 0
§3.7 Channel 4 (Tenant-Driven Land Transition) — P3b-2 core
   - Sub-model: Nash bargaining w/ landlord outside option u_L
   - Per-farm flat-rate: ∂u_L/∂T = 0 → r* ↓ (sign-flip vs Kirwan/Ciaian)
   - Per-hectare comparator: u_L proportional → r* ↑ (Kirwan +25%, Ciaian +46-55%)
   - 3 sub-channels:
     (i)   Bargaining: unit_rent ↓ — T1 pure_tenant -48 p=.059 ✅
     (ii)  Composition: A_rent ↓ monotone in -s_0 — T2 pure_tenant -1,738 m² ✅
     (iii) Land pivot: A_own ↑ | survive monotone in -s_0 — T2 pure_tenant +1,089 m² ✅
   - Decomposition: T3 2022 area_total +408 m², 96% within survivors (Ch4(iii)), 4% selection (Ch5)
§3.8 Channel 5 (Exit Deterrence) — SUPPLEMENTARY (Scenario β framing)
   - Sub-model: V_stay vs V_exit, sunk Φ_exit + identity ψ
   - Prediction β(exit) < 0
   - Empirical (P3c Phase 1): Form B sign consistent (-0.092 T2) but statistically null (p=.293)
   - Reframe: "supplementary robustness anchor confirming directional consistency at FHES Wave 1 N"
   - §7 limitations paragraph promised for finalized AJAE submission
§3.9 Unified Prediction Table — 5 channels × 4 outcomes + signs + empirical fit
§3.10 Why 5 Channels (Not Fragmentation) — common AHM base, 5 imperfections, per-farm policy design as unifying ID mechanism
§3.11 Limitations of theoretical structure — 1 paragraph: APCS linkage future R&R, Wave 1 N=14,474 power
```

Translation source: `master_supporting_docs/own_drafts/초안.md` §3 lines 60–189 (Korean v1) → English translation + 5-channel expansion + Scenario β framing reflecting P3c Phase 1.

Equation count: ~12-15 numbered equations (utility max, Nash bargaining FOC, prediction inequalities).

### Phase 5 — Compile + verify (~30min)

```bash
cd paper/en
latexmk -xelatex -interaction=nonstopmode main.tex 2>&1 | tail -30
# Expected: PDF produced in 2-3 passes (XeLaTeX → biber → XeLaTeX × 2)
# Manual inspect: open main.pdf and verify
#   - Title page renders cleanly
#   - §3 all subsections present with equations
#   - 11 bib refs resolve (no [?])
#   - 5-channel table renders
#   - Total pages: ~6-8 (incl bibliography)
```

If errors:
- Missing package → add to preamble_en.tex
- Undefined citation → check Bibliography_base.bib key spelling
- Unicode (Korean glyphs) → ensure all §3 text is English-only

## Verification

```bash
# 1. Files present
test -f paper/en/main.tex && test -f paper/en/preamble_en.tex && \
  test -f paper/en/main.pdf && echo "FILES OK"

# 2. Bibliography entries
grep -c "^@\(article\|book\|incollection\)" Bibliography_base.bib
# Expect ≥ 12 (11 new + maybe 1 template kept as example, OR 11 if templates removed)

# 3. §3 subsections present
grep -c "^\\\\subsection" paper/en/main.tex
# Expect ≥ 10 (§3.1 through §3.11)

# 4. Compilation success
test -f paper/en/main.pdf && echo "COMPILE OK"

# 5. PDF page count (rough scope check)
pdfinfo paper/en/main.pdf | grep "Pages:"
# Expect: 6-10 pages (1 title + 5-7 §3 + 1-2 bib + stubs)

# 6. Citation resolution
grep -c "Undefined" paper/en/main.log
# Expect: 0

# 7. Quality gate
python3 scripts/quality_score.py paper/en/main.tex
# Threshold: 80 for paper/en/*.tex per quality-gates.md
# Document any false-positive overrides

# 8. Sister plan parity
diff /Users/leedo/.claude/plans/inherited-knitting-sutton.md quality_reports/plans/2026-05-15_paper-section3-bootstrap.md
# Expect: empty diff
```

## Decision gate after this plan

1. User reviews compiled `paper/en/main.pdf` §3.
2. User reviews `Bibliography_base.bib` tentative entries — flags any incorrect attributions.
3. **Joint decision:**
   - Proceed to **§1 Introduction draft next session** (per user's stated intent).
   - OR refine §3 (additions / corrections / scenario framing adjustment).
   - OR detour to S2 hazard implementation before continuing §1.

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| Bib entries incorrect (wrong volume/issue/page) — MEMORY 11% error rate | High | All marked `% VERIFY-PRE-SUBMIT`; full pre-flight verification at submission stage. This session optimizes for content over citation precision. |
| `\usepackage{kotex}` accidentally loaded → English-only paper compile bug | Low | preamble_en.tex explicitly excludes kotex; XeLaTeX engine handles UTF-8 natively |
| `\bibliography{../../Bibliography_base}` path resolution fails in BasicTeX | Low | Use `\bibliography{../../Bibliography_base}` (no .bib extension); verify with `kpsewhich` if needed |
| §3 length exceeds 7-page budget → main.tex bloat for §1 next session | Medium | Equation-heavy compact prose; Channel 5 sub-model condensed to 1.5 pages (supplementary status); decomposition reported via table not paragraph |
| natbib + `aer.bst` not installed in BasicTeX | Medium | Fallback: `\bibliographystyle{plainnat}` (CTAN baseline). Verify after preamble write. |
| Quality gate false positives on `paper/en/*.tex` (LaTeX `\\command` patterns same as R scripts) | High | Override per [LEARN:tooling] 2026-05-14 precedent; document in commit body. paper/en/*.tex threshold is 80, may need override. |

## Approval gate

On ExitPlanMode approval:
1. Mark plan APPROVED in this file + sister.
2. Create session log + initial entry.
3. Phase 1: Bibliography_base.bib (11 §3 entries, TENTATIVE markers).
4. Phase 2: preamble_en.tex.
5. Phase 3: main.tex scaffold (§1-§9 stubs).
6. Phase 4: §3 full content with subsections + equations + Scenario β framing on §3.8 (Channel 5).
7. Phase 5: `latexmk -xelatex` compile + verify PDF.
8. Update session log with completion summary + PDF page count.
9. Present to user with §3 PDF preview + decision-gate options.
10. **NO auto-commit** (manual approval mode).

**Total wall-clock estimate: ~5h** (Phase 1 ~45min + Phase 2 ~15min + Phase 3 ~20min + Phase 4 ~3h + Phase 5 ~30min + session log ~20min).
