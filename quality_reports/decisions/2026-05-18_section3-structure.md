# ADR-0003: §3 Structure (S1) + Derivation Depth (D2) + Online Appendix Layout

**Status:** ACCEPTED
**Date:** 2026-05-18
**Context:** `/interview-me` session — concrete structural layout of the revised §3 theoretical framework, given the α-strict scope (ADR-0001) and outcome hierarchy (ADR-0002).

## Problem

Decide (a) how many subsections §3 carries, (b) how deep the in-main-text derivations go, and (c) where the full Lagrangian + comparative-statics derivations live. Constraints: AJAE main-text budget ≤ 50 pages double-spaced; §3 should occupy roughly 3–4 pages without crowding §1 Intro, §4 Identification, §5 Results.

## Options considered

### Option A: S1 (Lean, 4 subsections, ~3–4p) + D2 (closed-form in main, derivation in Appendix)

```
§3.1 Baseline AHM and the Separability Null
§3.2 Extension: Wealth-Biased Liquidity Relaxation (Carter-Olinto + Kazukauskas)
§3.3 Auxiliary: Implicit Labor Market with Supervision (Eswaran-Kotwal)
§3.4 Unified Predictions Table and Equilibrium Rent Caveat
```
Main text shows closed-form FOC results; full Lagrangian + comparative-statics in `paper/en/online_appendix.tex`.

**Pro:** Compact, reader-friendly, matches AJAE convention; theory-empirics mapping is visible in one table.
**Con:** Requires online appendix maintenance; separate compile pipeline.

### Option B: S2 (Integrated single model, 3 subsections, ~3p) + D2

```
§3.1 Setup and Separability Null
§3.2 Integrated Two-Failure Model (Foster-Rosenzweig 1995 JPE style)
§3.3 Predictions
```
Single Lagrangian incorporating both liquidity and supervision-cost simultaneously.

**Pro:** Most elegant; one model, two predictions.
**Con:** Requires deriving an integrated model that may not exist cleanly in the literature; risk of original-modeling burden the paper isn't trying to carry.

### Option C: S3 (Detailed, 5–6 subsections, ~5p) + D2 or D3

```
§3.1 Notation
§3.2 Baseline AHM
§3.3 Separability null and test design
§3.4 Liquidity extension
§3.5 Labor extension
§3.6 Unified predictions + Equilibrium rent caveat
```

**Pro:** Maximum exposition; no reader pacing risk.
**Con:** §3 budget exceeds 4p; squeezes other sections under AJAE 50p limit.

### Sub-decision: Derivation depth (D1 / D2 / D3)

- **D1** — Sign predictions only in main text, all derivation in Appendix.
- **D2** — Closed-form FOC results in main, full Lagrangian + comparative statics in Appendix.
- **D3** — Full derivation in main text.

### Sub-decision: Appendix file layout

- **Inline** — `\appendix` block at the end of `paper/en/main.tex`.
- **Separate file** — `paper/en/online_appendix.tex` compiles to its own PDF.

## Decision

**Chose:** Option **A (S1)** + **D2** + **Separate online appendix file** (`paper/en/online_appendix.tex`).

**Rationale:**
- **S1 vs S2:** S2's integrated two-failure model would require either citing a non-existent integration (originality burden the paper isn't claiming) or constructing one ourselves (out-of-scope for a single-author empirical-with-theory paper). S1 keeps the two extensions as separate subsections, each cited cleanly to its 1-tier source.
- **S1 vs S3:** S3 exceeds the §3 page budget. The clarity-vs-budget trade favors S1.
- **D2 vs D1 / D3:** D1 (sign only) underdelivers given that the AJAE referees expect to see at least the FOC. D3 (full derivation in main) blows the page budget and re-creates the box-fatigue problem of the previous 5-channel version. D2 is the standard AJAE empirical-with-theory presentation.
- **Separate online appendix file** (vs inline `\appendix`): AJAE submission convention prefers separated online appendix at first submission; avoids main.tex bloat; separate latexmk pipeline is a manageable cost; ADR-0003 decision applies cleanly even if the eventual editor requests reattachment.

## Consequences

- **§3 final layout** (4 subsections, ~3–4p):
  ```
  §3.1 Baseline AHM and the Separability Null
  §3.2 Extension: Wealth-Biased Liquidity Relaxation (Carter-Olinto + Kazukauskas)
  §3.3 Auxiliary: Implicit Labor Market with Supervision (Eswaran-Kotwal)
  §3.4 Unified Predictions Table and Equilibrium Rent Caveat
  ```
- **Online appendix file:** `paper/en/online_appendix.tex` — separate documentclass, references `../../Bibliography_base.bib`. Three subsections corresponding to the three extensions + the predictions mapping:
  ```
  §A.1 Wealth-Biased Liquidity: Lagrangian, FOC, Comparative Statics (Carter-Olinto + Kazukauskas)
  §A.2 Implicit-Labor Supervision: Shadow-Wage Divergence Derivation (Eswaran-Kotwal)
  §A.3 Reduced-Form-to-Econometric-β Mapping Table
  ```
- **Predecessor plan supersession:** the prior plan's "Appendix A.4 Nash bargaining" and "A.7 (S,s) inaction" subsections are **deleted** from the appendix layout (they belonged to the β scope). Tasks #3 (Phase 2 Inline Appendix A.4 + A.7) and #4 (Phase 3 separate online appendix with A.1–A.9) are marked deleted; new tasks reflect the α3 appendix structure.
- **Compile pipeline:** `latexmk -xelatex paper/en/main.tex` and `latexmk -xelatex paper/en/online_appendix.tex` both run. Cross-reference between main and online appendix uses `\href{online_appendix.pdf#section.A.1}{...}` or plain prose reference `Online Appendix §A.1`.
- **paper/ko/main.tex:** NOT touched in this round (per CLAUDE.md "Never simultaneous bilingual edits"). Future plan handles paper/ko re-sync once paper/en is stable.

## Rejected alternatives — why not

- **S2 (integrated model).** Foster-Rosenzweig 1995-style integration is elegant but not the precedent we are building on (we are building on Carter-Olinto + Eswaran-Kotwal separately). Originality burden not justified.
- **S3 (detailed).** Page budget violation under AJAE 50p.
- **D1 (sign only).** Underdelivers; modern empirical-with-theory papers show the FOC.
- **D3 (full derivation in main).** Page budget violation; box-fatigue risk reappears.
- **Inline `\appendix`.** Inline was the prior plan's choice but the online appendix file is the AJAE convention and was already decided 2026-05-15 (`Phase 3 — Separate online appendix file`); we preserve that decision because it survives the α3 reframing.
