# Lens 6: Prose Quality
**Date:** 2026-05-20
**Score:** 6.5/10
**Phase:** Review-only (Phase 1 of proofreading-protocol.md)
**Manuscript:** `paper/en/main.tex`

## Executive summary

Prose is technically competent and reads as written by a careful non-native speaker. The dominant problems are (a) chronic sentence-length overruns (many 50–90-word sentences), (b) heavy reliance on em-dash parentheticals stacked 3+ deep, (c) terminology drift on the load-bearing concept "operating cost net of rent" / "op_cost_ex_rent" / "operating cost" / "op_cost", and (d) inconsistent citation style for parenthetical year-only references. No outright Korean-English calques, but several "definite-article" misuses. Active voice dominates; passive usage is reasonable. Hedging is generally proportionate and occasionally under-hedged (the abstract's final sentence is a near-definitive causal claim).

## CRITICAL findings (publication blockers)

### C-1. Abstract closing sentence: under-hedged for observational ITT.
- **Line 34:** "We reject the AHM separability null for Korean small farms via the wealth-biased liquidity channel."
- Duplicated at line 143 and line 367. Stating it three times verbatim, with no scope qualifier ("at the 0.5 ha cutoff", "via F1"), invites a referee to flag it as overclaiming.
- **Proposed:** "We reject the AHM separability null at the 0.5 ha eligibility cutoff via the wealth-biased liquidity channel: F1 does not fire ($\hat\beta_{1,\text{tenant}} = +1{,}122$ m² at T2, $p=.041$), with monotone-decreasing response across four non-pure-owner bins."

### C-2. Abstract is one 250+ word paragraph with three sentences > 60 words.
- AJAE abstract conventions prefer 150–200 words with discrete topic-load-bearing sentences.
- **Proposed:** Split sentence 3 ("We estimate the intent-to-treat effect…2018–2022") into two — separate (a) ITT definition + sample restriction from (b) DiD-RD design + panel description.

### C-3. Terminology drift: "operating cost net of rent" (load-bearing outcome name).
The variable appears in **at least five distinct surface forms**:
- `op\_cost\_ex\_rent`: lines 56, 180, 216, 261, 267, 276
- "operating cost net of rent": lines 54, 333, 359, 446, 457
- "operating-cost-net-of-rent" (hyphenated): lines 34, 56
- "operating cost" alone: lines 315, 359, 389, 394, 411
- `op\_cost` (no suffix): lines 315, 394

**Severity:** High. A referee reading "operating cost" at line 315 and "operating cost net of rent" at line 333 (same paragraph) will ask which is estimated. The data section (line 315) explicitly says the primary outcome is `op_cost` (full operating cost), but abstract/§5 say `op_cost_ex_rent`. **This is not a notation tic — it is a possible specification mismatch.**

**Recommendation:** Pick one canonical name. Line 315 must be reconciled with §5.

### C-4. Citation style drift on parenthetical year-only refs.
- Line 178: `\citet{Benjamin1992_separation, LaFaveThomas2016_markets} has established` — two-key `\citet` produces grammatically awkward output + subject-verb (has → have).
- Line 219: `\citet{CarterOlinto2003_liquidity, Kazukauskas2013_disinvestment}` inside a sentence reads grammatically odd.
- **Fix:** Use `\citet{X}` and `\citet{Y}` separately, or `\citep` if parenthetical.

## MAJOR findings (referee will notice)

### M-1. Sentence length: extensive overruns (see ledger below).
Approximately **30+ sentences exceed 35 words**, with several over 60 words.

### M-2. Em-dash overuse / stacked parentheticals.
Throughout the introduction and §3 the prose stacks em-dash clauses inside parentheses inside em-dashes. **Recommendation:** No more than one em-dash pair per sentence.

### M-3. "Versus X" comparative pattern (line 52) reads like a literature-review checklist, not prose.
Four consecutive `\emph{Versus \citet{...}}:` blocks form a single 350-word paragraph. Consider splitting into four short paragraphs OR converting to a `description` environment.

### M-4. Definite article errors / Korean-English tells.
- Line 48: "the closest cousin a Swiss spatial-RD" — missing "is": "the closest cousin **is** a Swiss spatial-RD…"
- Line 56: "restoring sharp DiD-RD" → "restoring **a** sharp DiD-RD design"
- Line 142: "the \citet{SinghSquireStrauss1986_ahm} Agricultural Household Model" — possessive-author construction; AHM is not Singh-Squire-Strauss's property. Read as "the Agricultural Household Model (AHM), as formalized by \citet{...}".
- Line 187: "to finance land purchase" → "to finance **a** land purchase" or "land **purchases**".
- Line 452: "the AHM-separability null" → "the AHM separability null" (compound modifier-noun awkward).

### M-5. Inconsistent hyphenation of "AHM-separability" / "AHM separability".
- "AHM separability null": lines 34, 50, 52, 142, 167, 290, 367, 459 (no hyphen)
- "AHM-separability rejection": lines 290, 294, 295, 363 (hyphen)
- **Recommendation:** Open compound when noun ("the AHM separability null"); hyphenated when modifier-before-noun ("AHM-separability test").

### M-6. Inconsistent capitalization / spacing of "(S,s) inaction band" / "$(S,s)$".
- "(S,s)" (text): lines 219, 389, 394, 446
- "$(S,s)$" (math): lines 34, 56, 261
- **Recommendation:** Use math mode `$(S,s)$` uniformly.

### M-7. F1/F2 inconsistency: "fires" vs "does not fire" vs "fired".
- Line 363: "F1 not-fired + F2 null" — hyphenated past participle reads informal/jargon
- **Recommendation:** Standardize on "F1 fires / does not fire" (present tense).

### M-8. "Statutorily-eligible" vs "statutorily eligible" inconsistency.
Modern English prefers no hyphen on adverb+adjective compounds when the adverb ends in -ly (Chicago Manual 7.86): **"statutorily eligible"** in all positions. Currently hyphenated 16+ times.

### M-9. Under-hedged causal language in policy implications.
- Line 446: "indicating that a $1.2$ million KRW annual transfer **is sufficient to shift** the rental–ownership margin"
- "is sufficient" is a structural-mechanism claim, not a reduced-form ITT claim.
- **Proposed:** "is associated with a shift in" or "is associated with an own-area pivot of magnitude consistent with".

### M-10. Mathematical sentences run on inside `\textbf{Closed-form predictions}` blocks.
Lines 196 and 233 use bold-label-then-equation pattern with two `\citealp` calls — consolidate into `\citep{X, Y}`.

## MINOR findings (polish)

### m-1. "approximately" + "roughly" within same paragraph (line 48). Pick one.
### m-2. Spell out vs. numerals: "twenty percent" (line 48) vs "$14.6\%$" (line 79). Use numerals throughout.
### m-3. "First/Second/Third" enumeration without parallel structure (line 180). Recast as parallel.
### m-4. Em-dash for parenthetical citation insertion at line 52. Pick one format.
### m-5. Footnote on line 48: "and held throughout" — missing "was".
### m-6. "Reconcile" (line 259 footnote) → "are reconciled" (intransitive issue).
### m-7. `\paragraph{}` header punctuation drift: "F1 result: ... ." vs "Operating-cost sub-prediction." — pick one.
### m-8. "Holm step-down correction" (line 56) vs "Holm step-down adjustment" (line 387). Pick one.
### m-9. Footnote anchoring: line 48 footnote describes amount but is anchored to the area cutoff. Move to after "1,200,000 KRW per year".

## Long-sentence ledger (>35 words)

| Line | ~Len | Opening | Action |
|---|---|---|---|
| 34 | 76 | "We estimate the intent-to-treat effect on the statutorily-eligible subset..." | Split into 2 |
| 48 | 66 | "Korea's 2020 Public-Interest Direct Payment Scheme..." | Split after SFFP definition |
| 48 | 56 | "The per-farm flat-rate design is institutionally distinctive..." | Split into 3 |
| 50 | 47 | "The Agricultural Household Model (AHM) separability null states..." | Split |
| 50 | 62 | "Our framework formalizes two AHM extensions..." | OK |
| 52 | 49–63 | Four "Versus X" blocks chained | Convert to description list |
| 54 | 67 | "Treatment status is the statutorily-eligible indicator $D_i$..." | Split |
| 54 | 80 | "Under the $\alpha$3 framework's outcome hierarchy..." | Split into 3 |
| 56 | 95 | "F1 predicts a monotone-in-baseline-tenancy gradient..." | Convert to description |
| 56 | 73 | "The \S\ref{sec:results} estimates document..." | Split |
| 58 | 79 | "We further restore methodological purity..." | Split into 3 |
| 86 | 53 | "\citet{BaldoniCiaian2023_eucap} reports rental-rate pass-through..." | OK |
| 180 | 84 | "Throughout \S\ref{sec:theory}..." | Split |
| 180 | 105 | "We argue against this concern on three grounds..." | Convert to numbered list |
| 317 | 78 | "We apply the \texttt{weight\_national} sampling weight..." | Split into 3 |
| 333 | 64 | "The function $f_k(rv_{2018,i})$ is a local-linear polynomial..." | Split |
| 343 | 105 | "Korean rural-rental markets clear at the village-or-district level..." | Split before "so" |
| 350 | 110 | "Under the strict-AND F1 trigger..." | Split |
| 359 | 102 | "The T1 magnitude corresponds to a $-29\%$ change..." | Split |
| 363 | 85 | "Separately, the rent-cost reduced-form pass-through..." | Split into 2-3 |
| 411 | 64 | "The dropped households differ on the variables..." | Restructure |
| 423 | 80 | "The 24 journal-cell coefficient comparison..." | OK |
| 423 | 80 | "The headline coefficients' robustness..." | OK |
| 448 | 100 | "The mechanism behind the incidence reversal..." | OK |
| 450 | 95 | "The credit-constrained smallholder cohort..." | Split |
| 454 | 60 | "The F2 supervision-channel coefficient $\hat\beta_4$..." | OK |
| 454 | 73 | "The 0.5~ha cutoff is institutionally unique..." | Simplify |
| 457 | 72 | "The pure-tenant own-cultivated-area response..." | OK |
| 461 | 95 | "Four directions remain open for future work..." | Convert to description |

## Korean-English translation tells

| Line | Current | Proposed |
|---|---|---|
| 48 | "the closest cousin a Swiss spatial-RD" | "the closest cousin **is** a Swiss spatial-RD" |
| 56 | "restoring sharp DiD-RD" | "restoring **a** sharp DiD-RD design" |
| 84 | "We frame the DiD-RD estimator as an intent-to-treat (ITT) effect" | "We interpret the DiD-RD estimator as identifying an ITT effect" |
| 142 | "We test the \citet{SSS1986} Agricultural Household Model (AHM) separability null" | "We test the AHM separability null, as formalized by \citet{SSS1986}," |
| 142 | "We reject AHM separability for Korean small farms" | "We reject the AHM separability null for..." |
| 187 | "to finance land purchase" | "to finance **a** land purchase" |
| 219 | "we take the predictions of \citet{X, Y} as load-bearing" | "we take the predictions of \citet{X} and \citet{Y} as load-bearing" |
| 261 | "the larger-$\tau$ endpoint deepens the (S,s) inaction implication" | "deepens the $(S,s)$ inaction band" |
| 454 | "a one-line reference to alternative non-separability literatures is offered as out-of-scope but related comparators" | "We note alternative non-separability literatures as out-of-scope but related comparators" |

## Terminology consistency audit

| Concept | Variants | Canonical |
|---|---|---|
| Operating cost variable | `op_cost`, `op_cost_ex_rent`, "operating cost", "operating cost net of rent" | **HIGH-PRIORITY**: Reconcile line 315 (says `op_cost`) with §5 (`op_cost_ex_rent`). Pick one. |
| AHM separability | with/without hyphen | Open compound when noun; hyphenated when modifier |
| Wealth-biased liquidity | various | "wealth-biased liquidity channel (Channel A)" on first use, then "wealth-bias channel" |
| Statutorily eligible | hyphenated 16×, open 2× | Drop hyphen throughout (Chicago 7.86) |
| (S,s) | text vs math | math mode `$(S,s)$` |
| F1 trigger | "fires", "does not fire", "not-fired" | "fires" / "does not fire" present tense |
| Multiple testing | "Holm step-down correction" vs "adjustment" | "correction" |

## Citation-style drift

| Line | Current | Should be |
|---|---|---|
| 178 | `\citet{X, Y} has established` | `\citet{X}` and `\citet{Y}` **have** established (verb + grammar) |
| 196 | `\citealp{X}; \citealp{Y}` (consecutive) | `\citep{X, Y}` |
| 219 | `\citet{X, Y}` | Separate `\citet` calls |

## Overall recommendations (priority order)

1. **Resolve `op_cost` vs `op_cost_ex_rent` discrepancy** (line 315 vs §5). Possible reading-of-the-paper bug.
2. **Drop hyphen from "statutorily-eligible"** throughout (16+ instances).
3. **Tighten abstract** to ≤200 words.
4. **Split ~15 sentences > 50 words** flagged above.
5. **Replace two-key `\citet{X, Y}`** at lines 178, 219.
6. **Standardize F1 "fires / does not fire"** present-tense.
7. **Make `(S,s)` math-mode** consistently.
8. **Soften "is sufficient to shift"** at line 446.
9. **Convert long enumerations** (line 180, 461) to description environments.
10. **Verify "and held throughout"** at footnote line 48.

**Bottom line:** Publishable with revision but currently a dense, sentence-heavy first draft. Highest-impact intervention: breaking the 15+ long sentences and resolving the op_cost terminology drift.
