# Lens 2: Introduction Structure (Cochrane / Varian / Bellemare)

**Manuscript:** `paper/en/main.tex` (Wave 7, Post-merge `6b9c35d`)
**Section reviewed:** §1 Introduction (L52–68), §2 Institutional Context for narrative continuity (L70–96)
**Target:** AJAE first submission

---

## Verdict: **PASS with MAJOR polish needed** (8.0 / 10)

The intro hits the structural marks: question-first opening, post-hook literature placement, enumerated three-contribution close, quantitative preview, and customized roadmap. The architecture is AJAE-credible. What drags the score: paragraphs L56 and L58 carry too much institutional/methodological scaffolding (the "auditable-surface pre-specification posture" sentence at L58 is unreadable on first pass), and the 6-paragraph intro pushes the upper edge of AJAE's preferred 3–5-page envelope.

---

## Diagnostic Against the Eight Tests

| # | Criterion | Status | Note |
|---|---|---|---|
| 1 | Opens with the question (not lit) | **PASS** | L56: "Does the Agricultural Household Model's separability null hold..." — model Cochrane opening. |
| 2 | Hook → RQ → contribution → roadmap | **PASS** | P1 hook + RQ, P2 theory framing, P3 lit positioning, P4 design, P5 magnitudes + findings preview, P6 contributions, L68 roadmap. Order is correct. |
| 3 | Lit review AFTER the hook | **PASS** | L56 (Kirwan / Baldoni-Ciaian / Zimmert-Zorn) appear after the question; deep literature comparison reserved for P3 (L60). |
| 4 | Contributions enumerated | **PASS** | L66 explicitly: "three contributions. *Methodologically*... *Theoretically*... *Empirically*..." Bellemare-compliant. |
| 5 | Preview of findings quantitative | **PASS** | L64 closes with: pure-tenant +1,122 m² at T2, p=.041; op_cost −3.98M KRW at T1, p=.057; abstract gives −12.0% pass-through. Magnitudes, not "we find significant effects." |
| 6 | "Statutorily-eligible ITT" framing clear | **PARTIAL PASS** | L62 introduces $D_i$ as the conjunction of three FHES-observable criteria, and the 14.6% drop is stated. But the term "intent-to-treat (ITT) effect of statutory SFFP eligibility" is dropped into L62 without defining why it's ITT-not-ATT until the reader hits §2.3. The Wave 7 framing pivot deserves a sharper one-sentence justification in P4. |
| 7 | Contribution-vs-Kirwan / Baldoni-Ciaian / Choi-Jodlowski / Choi-Mun crisp | **PASS** | L60 dedicates one *emphasized clause* per benchmark (Kirwan, Baldoni-Ciaian, Kazukauskas, Carter-Olinto); L66 handles Choi-Jodlowski and Choi-Mun in one sentence each. Distinctions land. |
| 8 | Length appropriate for AJAE (3–5 pp) | **AT UPPER BOUND** | 6 paragraphs, ~2,400 words rendered. Reads as ~4.5 pages double-spaced. Within tolerance but no slack. |
| 9 | Roadmap short and customized | **PASS** | L68: one sentence per section, customized labels ("AHM-extension theoretical framework", "headline results"). Not generic. |

---

## Issues

### CRITICAL (none)

No structural failure. Question-first is preserved, lit is post-hook, contributions are enumerated, findings preview is quantitative. AJAE editors will not desk-reject on intro structure.

### MAJOR

**M1. L58 prose-density wall.** The sentence beginning "Per the auditable-surface pre-specification posture, the $\alpha$-strict theoretical scope (ADR-0001), the outcome hierarchy realignment (ADR-0002)..." piles four internal-governance references (ADR-0001, ADR-0002, F1, F2) into one sentence. This is an internal-replication-package detail leaking into the intro. AJAE referees will read this as defensive over-specification. Demote to a footnote or to §3.

**M2. L58 "ex-theory aggregate-equilibrium implication" phrasing.** The deliberate scope-narrowing on rental incidence is methodologically important but reads as throat-clearing. The triple-confirmation footnote ("three independent confirmations") at L66 again feels like authorial defensiveness rather than reader benefit. Trust the reader once.

**M3. P4 (L62) overloads the design paragraph.** Running variable definition, the 14.6% drop, the three bandwidths, wild cluster bootstrap, Holm correction, primary outcomes #1/#2 — all in one paragraph. Bellemare's rule: the intro design paragraph signals the strategy, not the implementation. Push half of this to §5 (Identification).

**M4. ITT framing motivation thin.** L62 calls the estimand ITT but does not state *why* the choice was made (administrative non-receipt on the 5 unobservable criteria). Reader has to wait until §2.3 (L92). One clause in P4 would close the loop: "...integrated over the 85.4% receipt margin we observe, because the remaining five statutory criteria are administered through MAFRA/NAQS records unobserved in survey data."

**M5. F1/F2 jargon introduced before payoff.** L58 introduces "F1 (load-bearing) + F2 (supporting)" labels that only pay off in §6. The reader sees the labels three times (P2, P5, abstract) before learning what they buy. Either define them more crisply on first use (one parenthetical phrase: "F1: the monotone tenancy gradient predicted by Channel A; F2: the off-farm income response predicted by Channel B") or hold them until §3.

### MINOR

**m1. L56 institutional detail (1M farms, 2.3T KRW budget, 20% SFFP share, MAFRA Article 10 dual-objective quote).** Useful for context but consumes ~80 words. Could move the budget-share sentence and the Article 10 quote to §2; intro retains only the 1.2M-KRW-per-household scale.

**m2. L56 footnote on 2025 amount increase (1.3M).** Not load-bearing for the 2018–2022 analysis; move to §2 footnote.

**m3. L60 word "demoted" appears twice in the intro (L58, L66) describing the rental-incidence margin.** Tonally apologetic. One mention suffices.

**m4. L62 "$\bar D = 0.312$" mean is unusual to surface in an intro.** Belongs in the data section.

**m5. L64 magnitude-calibration footnote spans 4 lines on $\tau$ and KAMICO/KREI citation pending.** Reader does not need this granularity at the intro layer; move to §3.4 calibration.

**m6. L66 "to our knowledge" hedge is fine but stacked twice in the abstract + L66.** Use once.

**m7. L68 roadmap "headline results" — substitute the canonical noun phrase ("estimation results" or "main findings") for register consistency with AJAE convention.**

---

## Narrative Continuity with §2

§2 (L70–96) does the institutional work that the intro punted. The handoff is clean:
- L62 invokes the 14.6% non-compliance figure; §2.2 (L87) substantiates it (1.8% owned-area + 12.8% off-farm-income).
- L66 invokes ITT framing; §2.3 (L92) formalizes the ITT-vs-ATT choice.
- The Wave 7 main treatment definition (`D_eligible_obs_2018`) is consistent across intro and §2.

**One narrative-continuity gap:** the intro at L58 commits to two AHM extensions as the contribution core, but §2 spends two paragraphs on the U.S./EU/Korea institutional contrast and the rental-incidence sub-claim. A reader emerging from §2 expects the rental-incidence margin to be the empirical headline; §3+ then has to walk that back. Consider trimming §2.3 paragraph 2 (L94 Kirwan/Baldoni-Ciaian recap) since the intro already did this work at L60.

---

## Specific Line-Numbered Suggestions

- **L56:** Trim institutional-context sentences 3–4 (budget share, Article 10 quote, 2025 amount footnote) — move to §2.1.
- **L58:** Demote "auditable-surface pre-specification posture" sentence to a footnote OR move to §3 opening; keep only the substantive content (two AHM extensions, F1/F2 named).
- **L58 / L66:** Pick one occurrence of the rental-incidence "ex-theory" disclosure; the second is redundant.
- **L60:** Strong as-is. Possibly tighten the Kazukauskas paragraph (the disinvestment-literature framing reads cleanest of the four).
- **L62:** Split into two paragraphs — one for design (cutoff, running variable, bandwidths, inference), one for sample and outcome hierarchy. OR move half to §5.
- **L62:** Add a 10-word ITT-not-ATT motivation clause (per M4 above).
- **L64:** Move the $\tau$ calibration footnote to §3.4.
- **L66:** Keep enumeration; consider trimming "three independent confirmations" footnote.
- **L68:** Roadmap is well-formed; consider one-word substitution per m7.

---

## Score: 8.0 / 10

| Component | Score |
|---|---|
| Opening (question-first, hook) | 9.5 |
| Lit placement and engagement | 8.5 |
| Contribution enumeration | 9.0 |
| Findings preview (quantitative) | 9.0 |
| ITT framing introduction | 7.0 |
| Length / pacing | 7.0 |
| Roadmap | 9.0 |
| Prose density / readability | 6.5 |

**Bottom line:** Structurally AJAE-ready. The 2.0-point deduction is concentrated in (i) L58 prose density and replication-package leakage into the intro, (ii) L62 overloaded design paragraph, (iii) under-motivated ITT pivot. None blocks first submission; all should be cleaned before sending. Recommend one tightening pass targeting L58 and L62 specifically before the seven-pass synthesis ships.
