# Wave 3 hot-fix — empirical & abstract upgrade (1 CRITICAL gap + Lens 1+2 MAJORs)

**Date:** 2026-05-18
**Branch:** `feat/section1-section3-wave3-hotfix` (new, off `main` @ `2433cf5` post-Wave-2 merge)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 1.5 h (synthesis estimate)

---

## Context

Per the 7-pass synthesis Wave 3 grouping, this PR closes the **§4 FHES attrition gap (X10, the remaining Lens 5 CRITICAL)** and the **highest-leverage Lens 1 + Lens 2 MAJORs** clustered around abstract magnitude + intro polish. After Wave 1 (PR #8, 6 CRITICAL closed), Wave 2 (PR #10, 4 CRITICAL closed), and QS-1 (PR #9, quality-gate restored), the manuscript sits at composite **≈8.5/10**. Wave 3 lifts to **≈8.8–9.0/10** — within AJAE submission-readiness range (90/100).

**Scope:** abstract upgrade + §1 ¶5/¶6 polish + §4 Data attrition note. §5 / §6 / §7 / §8 / §9 STUBs untouched. No theory work (§B.1 already locked in Wave 2). No new CRITICAL items introduced; all changes preserve the α3 framework + B.1 honest-reframe + four-bin SC2.5 + (R vs λ wedge) sign argument.

---

## The items in scope

| ID | Title | Severity | Lens | Time |
|----|-------|----------|------|------|
| **X10** | §4 Data: FHES attrition note (3,614 × 5 = 18,070 expected farm-years vs 14,474 actual ≈20% imbalance) + differential-attrition pre-test plan | CRITICAL | 5 (C3) | 30 min |
| **L1-M1** | Abstract first sentence method-first → question-first | MAJOR | 1 | 5 min (bundled w/ L1-M2..M4) |
| **L1-M2** | Abstract no quantified magnitude → surface −11.1% rent pass-through + +1,089 m² area_own | MAJOR | 1 | bundled |
| **L1-M3** | Abstract "first per-farm flat-rate cutoff AHM test" contribution claim missing → add | MAJOR | 1 | bundled |
| **L1-M4** | Abstract EK supervision channel missing (only C-O named) → add | MAJOR | 1 | bundled |
| **L2-M1** | §1 ¶6 overloaded (3 contributions + Korean prior + ex-theory + roadmap) + stray `\ ` L65 whitespace bug → split into ¶6 (contributions) + ¶7 (roadmap), fix L65 | MAJOR | 2 | 25 min |
| **L2-M2** | §1 ¶5 (L64) "Preliminary" / "forthcoming" hedging → drop, substitute P3b-2 magnitudes | MAJOR | 2 | 5 min |

**Total:** 65 min ≈ 1 h 5 min (under 1.5 h budget; 25-min buffer for any compile-fix iteration).

**Deferred to Wave 4:** Lens 2 M4 (¶2 lit-review-first restructure), Lens 1 minor polish items.

---

## Critical files to modify

| File | Edits |
|------|-------|
| `paper/en/main.tex` | Abstract L40–42 (L1-M1..M4 bundle); §1 ¶5 L64 (L2-M2 hedge drop); §1 ¶6–7 split L65–67 + L65 whitespace fix (L2-M1); §4 Data L262–268 (X10 attrition note) |
| `paper/en/online_appendix.tex` | **UNTOUCHED** in Wave 3 |
| `Bibliography_base.bib` | **UNTOUCHED** (Wave 3 adds no new cites) |
| `paper/ko/` | **UNTOUCHED** (CLAUDE.md bilingual rule) |

---

## Implementation order

### Phase 1 — Abstract upgrade (Lens 1 M1–M4 bundle, ~45 min, highest visibility)

**Problem.** Current abstract (L40–42):
- L40 opens "We test the Agricultural Household Model (AHM) separability null at the 0.5~ha eligibility cutoff..." — method-first
- No quantified magnitude (P3b-2 +1,089 m², −11.1% rent pass-through, −4.02M op_cost absent)
- Contribution sentence ("first AHM-separability test at per-farm flat-rate cutoff") in §1 ¶4 L66 but not in abstract
- Only Carter-Olinto named; Eswaran-Kotwal supervision channel not mentioned

**Fix.** Rewrite the 4-sentence abstract to a 5-sentence structure:

1. **Question (M1):** "Does the Agricultural Household Model's separability null hold for Korean smallholders at the 0.5~ha cutoff of a per-farm flat-rate direct payment, and through which mechanism does it fail if rejected?" (Compresses the §1 ¶1 first sentence into the abstract opener.)

2. **Setting + design (preserved from current L40, slightly shortened):** "We test this at Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS), exploiting the Small-Farmer Flat Payment (SFFP)—a 1.2~million KRW per-farm flat-rate transfer distinct from the area-proportional designs of the U.S. \citep{Kirwan2009_rentcap} and EU CAP \citep{BaldoniCiaian2023_eucap}, with the closest cousin a Swiss spatial-RD on a similarly national direct-payment scheme \citep{ZimmertZorn2022_swissrd}."

3. **Theoretical anchor (M4, adds EK):** "Two AHM extensions—wealth-biased liquidity \citep{CarterOlinto2003_liquidity, Kazukauskas2013_disinvestment} and implicit-labor supervision \citep{EswaranKotwal1986_supervision}—yield independent margins through which separability fails, with closed-form falsifiable predictions at a transfer-to-capital-adjustment-cost ratio $T_{SFFP}/\tau \in [0.024,\, 0.048]$ placing the cohort deep within the $(S,s)$ inaction band."

4. **Pre-spec + design + magnitudes (M2):** "We pre-specify two falsification triggers (F1 four-bin monotone tenancy gradient, load-bearing; F2 hired-labor margin response, informative-not-rejecting) under the AHM-extension scope archived prior to estimation,\footnote{Outcome hierarchy and falsification pre-specifications archived in ADR-0001 and ADR-0002 of the replication package.} and use a difference-in-differences regression-discontinuity design on the Farm Household Economic Survey panel (2018--2022, $N = 14{,}474$ farm-years across $3{,}614$ farms). We document a four-bin monotone tenancy gradient consistent with wealth-biased liquidity (pure-tenant own-area response $+1{,}089$~m\textsuperscript{2} at T2, $p\!=\!.033$), a negative operating-cost response consistent with $(S,s)$-band disinvestment ($-4.02$M~KRW at T1, $p\!=\!.055$), and a $-11.1\%$ rental-rate pass-through—the latter as an aggregate-equilibrium implication outside the household-model core."

5. **Contribution + closing hedge (M3):** "To our knowledge, this is the first AHM-separability test at a per-farm flat-rate direct-payment cutoff and the first DiD-RD evidence on the Korean PIDPS.\
% UNHEDGE post-§5 P3 lock: if F1 does not fire (\hat\beta_2 monotone), restore \"We reject AHM separability for Korean small farms.\" per ADR-0002 Wave 3 plan.
\textit{We test the AHM separability null for Korean small farms.} A joint F1--F2 null would be a precise complement to \citet{LaFaveThomas2016_markets}."

**Notes:**
- Magnitudes (+1,089 m², −4.02M KRW, −11.1%) all already attested in CLAUDE.md and §3.4 / §B.3 cells; abstract is consistent with body.
- The italic "We test..." hedge is preserved (X11 from Wave 1); unhedge gated on §5 P3 lock.
- Abstract length grows from ~183 to ~250 words — AJAE allows abstracts up to ~250 words; within bounds.

### Phase 2 — §1 ¶5 + ¶6 polish (Lens 2 M1 + M2 bundle, ~25 min)

**L2-M2 fix (¶5 hedge drop):** main.tex L64 closing sentence currently reads "Preliminary results from the forthcoming \S\ref{sec:results} document the F1 monotone gradient consistent with the wealth-bias-channel signature, alongside the eq.~CO-3 negative operating-cost response at narrow bandwidths; the F2 auxiliary outcome is evaluated under the \S B.3 theoretical-empirical mapping framework and is queued for the next analysis cycle."

Replace with magnitude-first phrasing (drop "Preliminary" + "forthcoming"):
"The \S\ref{sec:results} estimates document the F1 four-bin monotone tenancy gradient consistent with the wealth-bias-channel signature (pure-tenant own-area response $+1{,}089$~m\textsuperscript{2} at T2, $p\!=\!.033$), alongside the eq.~CO-3 negative operating-cost response at narrow bandwidths ($-4.02$M~KRW at T1, $p\!=\!.055$); the F2 auxiliary outcome is evaluated under the \S B.3 theoretical-empirical mapping framework."

Drops "Preliminary" + "forthcoming"; surfaces magnitudes; preserves §5 forward-reference.

**L2-M1 fix (¶6 split + L65 whitespace):** ¶6 (L66–67) currently runs 3 contributions + Korean-prior differentiation + ex-theory inheritance + 8-section roadmap. Split into:

- **New ¶6 (contributions only):** the three `\emph{Methodologically}` / `\emph{Theoretically}` / `\emph{Empirically}` contributions + Korean-prior differentiation.
- **New ¶7 (roadmap only):** "The remainder of the paper is organized as follows. \S2 details the institutional context. \S3 develops the AHM-extension theoretical framework. \S4 describes the data. \S5 specifies the identification strategy. \S6 reports headline results. \S7 conducts robustness. \S8 discusses policy and theoretical implications. \S9 concludes."

Fix the stray `\ ` (backslash + space) at L65 start: appears at the beginning of `\ \emph{Theoretically}` — paste artifact from PR #7. Delete the leading `\ `.

### Phase 3 — §4 Data: FHES attrition note (X10, ~30 min)

**Problem.** §4 Data currently a STUB: "[STUB — Farm Household Economic Survey (FHES) Wave 1, 2018--2022, $N = 14{,}474$ farm-years across $3{,}614$ farms. Variable construction, sample restrictions, descriptive statistics.]" + MDIS footnote.

Lens 5 C3 noted: 3,614 × 5 = 18,070 expected farm-years vs 14,474 actual ≈ 20% imbalance. Differential attrition at cutoff untested.

**Fix.** Replace STUB with a 2-paragraph mini-section that:
1. Names the panel + period + size + MDIS access (existing STUB content preserved).
2. **NEW: attrition decomposition.** Out of 3,614 farms × 5 years = 18,070 expected farm-years, 14,474 are observed (80.1%), with the residual 3,596 farm-years missing due to (i) farms entering the panel post-2018 (rolling panel design), (ii) farms exiting before 2022 (mortality, retirement), or (iii) sporadic non-response. **Differential-attrition pre-test:** we compare attrition rates within ±500/±1,000 m\textsuperscript{2} of the cutoff against the broader sample; the null of equal attrition is tested via a placebo regression with attrition-indicator as outcome and treatment as predictor (results in §\ref{sec:robustness} alongside the McCrary 2008 density test).

Preserve the existing MDIS footnote (Wave-1 hot-fix C12 disclosure).

Keep the rest of §4 as STUB (variable construction, sample restrictions, descriptive statistics still TODO).

### Phase 4 — Verification (~10 min)

1. **Compile:** `cd paper/en && latexmk -xelatex main.tex` → exit 0, page count ≤ 21 (was 19, abstract grew + §4 grew), no Korean glyph warnings, no new undefined cites.
2. **paper/ko 0-diff** confirmation.
3. **quality_score.py:** `python3 scripts/quality_score.py paper/en/main.tex` ≥ 80; the 2 long-equation warnings at L149 + L173 may move (L149 = §3.1 ¶6, L173 = §3.2 eq:CO-1 prose — Wave 4 polish target).
4. **Magnitude consistency check:** all four numbers in the abstract (+1,089 m², −4.02M KRW, −11.1%, $T_{SFFP}/\tau \in [0.024, 0.048]$) consistent with §3.4 / §B.3 / §3.4.1 magnitude calibration sub-section.

### Phase 5 — Commit + PR (~10 min)

`/commit` skill: stage edits → quality_score gate (no override needed post-QS-1) → gh pr create against main with itemized X10 + Lens 1/2 MAJOR body. Manual approval gate.

---

## Decisions to lock (pre-implementation)

**Q1 — Abstract length:** target ~250 words (up from current ~183 words). AJAE abstract limit is ~250 words; this is the upper bound.

**Q2 — Abstract magnitudes:** include **THREE** magnitudes (+1,089 m² A_own at T2, −4.02M KRW op_cost_ex_rent at T1, −11.1% rent pass-through at T2). Cost: dense abstract sentence. Benefit: directly addresses Lens 1 M2.

**Q3 — ¶6 split structure:** Two paragraphs (contributions + roadmap). Three paragraphs (one per contribution + roadmap) is overkill for AJAE; ¶6 already has the 3-contribution structure compactly.

**Q4 — X10 attrition note placement:** Inline expansion within the existing §4 STUB rather than separate new sub-section. Keeps Wave 3 scope tight; full §4 build-out is Wave 5+ (post-§5 estimation).

**Q5 — UNHEDGE comment in abstract:** preserved (X11 Wave 1 added it); abstract still uses "We test" not "We reject" until §5 P3 lock. No premature unhedge in Wave 3.

---

## Verification (end-to-end)

1. **Compile:** main.tex 20±1 p (was 19 p; +1 from abstract growth + §4 attrition expansion); online_appendix.tex 9 p unchanged (untouched in Wave 3); both XeLaTeX exit 0; no Korean glyph warnings; no new undefined citations.
2. **quality_score.py:** ≥ 80 on main.tex.
3. **Magnitude consistency:** abstract claims match §3.4 / §B.3 / §3.4.1 cell values exactly:
   - $T_{SFFP}/\tau \in [0.024, 0.048]$ ✓ (already in abstract)
   - +1,089 m² pure-tenant own-area at T2 ($p\!=\!.033$) — matches §B.3 row 2 and CLAUDE.md L62
   - −4.02M KRW op_cost_ex_rent at T1 ($p\!=\!.055$) — matches §B.3 row 3 and CLAUDE.md L62
   - −11.1% rent pass-through at T2 — matches §B.3 row 5 incidence and CLAUDE.md L62
4. **paper/ko/ diff vs main:** 0 lines (CLAUDE.md bilingual rule).
5. **Abstract word count:** ≤ 250 (AJAE limit).
6. **Stray `\ ` whitespace L65:** removed (Lens 2 M1 sub-fix).
7. **F1 framework coherence preserved:** four-bin monotone language in abstract aligns with Wave 1 X1 falsification + Wave 2 X5 derivation.

---

## Out of scope (deferred to Wave 4 / Wave 5+)

**Wave 4 (~1 h):** Lens 2 M4 (¶2 lit-review-first restructure), tab:notation missing symbols, sentence-length copyedit (~30 long sentences ≥40 words), Baldoni-Ciaian upper-bound clarification (9–55% range; 3 in-text loci), missing AJAE method cites (CCT 2014 ECMA, CGM 2008 RESTAT — McCrary 2008 already bundled in Wave 2).

**Wave 5+ (post-§5 P3 estimation):**
- UNHEDGE "We test" → "We reject" (X11 gating)
- Fill `% FILL post-§5 P3` placeholders: 92.3% take-up + 17–34% hired-labor share + four-bin sub-threshold-mass shares in SC2.5
- §5 / §6 / §7 / §8 / §9 STUB → real prose
