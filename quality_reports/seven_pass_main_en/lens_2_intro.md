# Lens 2: Intro Structure
**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` §1 (lines 44–60)
**Reviewer scope:** Cochrane / Varian framework — opener-hook-context-contribution-roadmap arc, lit placement, sharpness of contribution paragraph, preview of magnitudes, length discipline, Korea-framing load-bearing.

**Score:** 6.5/10

The intro is sophisticated and substantively complete — every Cochrane "must-have" is present, the contribution paragraph is genuinely numbered, headline magnitudes ARE previewed with numbers (rare for first drafts), and the Korea-vs-US-vs-EU contrast is institutionally specific rather than bolted-on. But the arc is buried under syntactic density. ¶1 is a 221-word block that opens with the right question and then drowns it in budget statistics and footnotes before the reader can absorb the question. ¶3 (lit review) is in the right *position* but runs 265 words of citation-versus-citation comparison that interrupts the hook→theory→contribution flow. ¶4 (empirical strategy) is 278 words and is essentially §5 prose dropped into §1. A reader who quits at the bottom of page 2 has not yet seen the contribution paragraph. The intro is structurally inverted: contribution paragraph (¶6) should be reached by line ~52, not line ~58.

---

## CRITICAL findings

- **C1. Opening sentence buries the question with a footnote-laden second sentence.** Line 48 (¶1) opens correctly: *"Does the Agricultural Household Model's separability null hold for Korean smallholders at the 0.5~ha cutoff of a per-farm flat-rate direct payment, and through which mechanism does it fail if rejected?"* — this is a textbook Cochrane opener, in interrogative form, naming both the test and the mechanism question. **But** the very next sentence pivots immediately to *"Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS) marked the largest restructuring of Korean farm subsidies in two decades, replacing the area-proportional Rice Income Compensation Scheme..."* — and from there ¶1 spends ~180 words on budget figures (2.3 trillion KRW, 1.2 million KRW, Article 10), a footnote about the 2025 increase, and a comparative-RD citation. The reader does not learn until ¶2 (line 50) what the AHM null actually says or why we should care. **The question is asked, then abandoned for institutional throat-clearing.** Fix: cut ¶1 to ~120 words; defer the budget figures, Article 10 quotation, and the 1.3M-KRW 2025 footnote to §2.1; the per-farm-vs-area-proportional distinction belongs in ¶1 because it IS the hook, but compressed.

- **C2. Contribution paragraph appears at line 58 — far too late.** This is the latest position the contribution paragraph should occupy minus the roadmap. By the structural map below, contribution is **¶6 of 7**. AJAE intros conventionally place the contribution paragraph by ¶3–¶4 so a busy editor doing a 90-second desk-screen sees the claims. Currently a desk-editor must wade through 1,000+ words (¶1+¶2+¶3+¶4+¶5) before the "we contribute three things" sentence. The contribution material is also *split* across ¶3 (lit-comparison contribution) and ¶6 (formal three-bullet contribution) — the same claims appear twice in different forms, padding the intro without sharpening it.

- **C3. ¶4 (empirical strategy at line 54, 278 words) is misplaced — it is §5 prose in §1.** It contains: running-variable definition with formula, the eligibility-conjunction logic, the 14.6% non-compliance drop with cross-references to §2, three bandwidth labels with cite to Calonico-Cattaneo-Titiunik, wild cluster bootstrap with Cameron-Gelbach-Miller, Holm step-down, sample size, $\bar D$. **This is the methods section.** Intros need 2–3 sentences of strategy, not a method-section précis. Recommend cutting to: *"We exploit the 0.5 ha cutoff in a DiD-RD on the FHES panel ($N{=}13{,}689$ farm-years, $3{,}420$ farms, 2018–2022), report three bandwidths in parallel, and cluster-bootstrap inference at the household level. Treatment is the conjunction of the three FHES-observable SFFP criteria, fixed at 2018."* — ~50 words instead of 278.

---

## MAJOR findings

- **M1. Lit-review paragraph (¶3, line 52) is in the right position but reads as four mini-comparisons rather than a synthesis.** Each *"Versus X..."* clause runs 50–70 words; cumulative effect is that the reader is asked to internalize four nearest-neighbor distinctions before reaching the contribution paragraph. The Cochrane rule is *"locate yourself in the literature with the minimum citations needed to do the work."* Recommend collapsing Kirwan + Baldoni-Ciaian into a single "developed-country area-proportional pass-through estimates (25% US, 9–55% EU)" clause; keep Kazukauskas and Carter-Olinto as the two theoretical lineages; defer the structural comparison to §2.3 (which already does this work on line 86).

- **M2. Headline magnitudes ARE previewed (good) but are quarantined in ¶5.** Line 56 contains *"the F1 four-bin monotone tenancy gradient... (pure-tenant own-area response $+1{,}122$~m² at T2, $p\!=\!.041$), alongside the negative operating-cost-net-of-rent response at narrow bandwidths ($-3.98$M~KRW at T1, $p\!=\!.057$)"*. These numbers should appear in ¶1 or ¶2 — they ARE the hook. Currently the reader sees them after ~1,000 words of setup. The first-sentence-of-¶1 ideal would be: *"At Korea's 0.5 ha SFFP cutoff, pure-tenant smallholders expand own-cultivated area by 1,122 m² ($p{=}.041$) and reduce operating cost ex-rent by 3.98 M KRW ($p{=}.057$) — a monotone-in-baseline-tenancy gradient consistent with wealth-biased liquidity, rejecting the Agricultural Household Model separability null."* The current intro structure withholds this for five paragraphs.

- **M3. The (S,s) calibration paragraph (¶5, 273 words) double-counts what the contribution paragraph (¶6) and §3 already say.** Line 56 introduces $T/\tau \in [0.024, 0.048]$ with a 100-word footnote about Korean tractor-combine machinery, the four-bin tenancy rule footnote, and then announces the results. This is a chimera of theory section + results section + magnitude calibration. The four-bin partition definition (footnote at line 56) belongs in §3 or §4, not §1. Cut ¶5 by 60%.

- **M4. ¶2 (line 50, AHM theory paragraph, 239 words) over-explains the separability null for an AJAE audience.** Sentences like *"The Agricultural Household Model (AHM) separability null states that, under complete markets, smallholder production decisions---land tenure, capital investment, labor allocation---are recursively factorizable from consumption decisions..."* are correct but pedagogical — AJAE referees know what AHM separability means. The Channel A / Channel B framing is the load-bearing content of ¶2; the textbook restatement of AHM separability should be one sentence (*"The AHM separability null states that lump-sum transfers should not affect production decisions under complete markets (Singh-Squire-Strauss 1986)"*) and then move to the extension.

- **M5. F1/F2 are introduced inline (¶2, lines 50 & 56) but the falsification-trigger framing is stronger than the intro currently lets it land.** The pre-specification footnote at line 50 (*"The theoretical scope, outcome hierarchy, and F1/F2 pre-specifications were fixed prior to estimation..."*) is buried at the end of ¶2 — this is a credibility-revolution move (pre-registration of falsification triggers) and deserves a sentence in the main text of the contribution paragraph, not a footnote.

- **M6. Length: 1,520 words ≈ 5 pages double-spaced. At the upper bound of AJAE convention but not bloated *if* the structure were tight.** The problem is not length — it is density. Cutting C1 + C3 + M3 yields ~1,000 words and 4 paragraphs that hit the Cochrane arc cleanly. Don't shorten by trimming; shorten by *moving paragraphs out of §1*.

---

## MINOR findings

- **m1. Footnote density.** Six footnotes in §1 (lines 48 ×1, 50 ×1, 54 ×0, 56 ×2, 58 ×0... and 56 footnote runs ~100 words on its own). Intros should carry at most 2–3 footnotes. Footnotes on the 2025 SFFP increase, the four-bin partition rule, and the tractor-combine calibration all belong outside §1.

- **m2. "Versus X" formatting in ¶3.** The `\emph{Versus \citet{...}:}` four-times-in-a-row formatting is visually arresting but creates a list-in-prose feel. Either turn into an itemize block (which AJAE allows for contributions) or smooth into narrative.

- **m3. Roadmap paragraph (¶7, line 60, 44 words) is the right length — keep as is.** Standard format, doesn't need fixing.

- **m4. "Three contributions" announced as Methodological / Theoretical / Empirical — these labels are clean and falsifiable, but the *Methodological* claim is two contributions packed into one sentence (first AHM-separability test at per-farm flat-rate cutoff AND first DiD-RD on Korean PIDPS).** Split or pick the load-bearing one.

- **m5. The title sells "AHM separability" but the intro's first paragraph sells "PIDPS reform."** Misalignment between title and ¶1 opener. The opener interrogative does name AHM separability, so the misalignment is mild — but the budget-and-Article-10 narrative in lines 48–49 reads like a Korea-policy paper, not an AHM-test paper. Pick a lane in ¶1.

- **m6. Korean institutional names are uppercase-heavy (PIDPS, SFFP, NAQS, FHES, MAFRA, KAMICO, ABP) — by ¶5 the reader has six abbreviations in active memory.** Defer NAQS, MAFRA, KAMICO, ABP, aT to §2. Keep PIDPS, SFFP, FHES in §1.

- **m7. Choi & Jodlowski (2025) and 최민영·문한필 / Choi & Mun (2025) are correctly cited in ¶6 as differentiation points (good).** The intro does the differentiation work the CLAUDE.md requires.

---

## Structural map

| ¶ | Function (intended) | Line | Words | Verdict |
|---|---|---|---|---|
| ¶1 | Opener / hook (the question) | L48 | 221 | **Question stated then buried.** Lines 1–2 are correct opener; lines 3–end pivot into PIDPS budget exposition. Cut to ~120 words, defer Article 10 / budget / 2025-amount footnote. |
| ¶2 | AHM theory + Channel A/B + F1/F2 pre-spec | L50 | 239 | Right *function*, ~50% too long. Compress AHM-separability textbook content; promote pre-specification claim to main text. |
| ¶3 | Literature placement (Kirwan, Baldoni-Ciaian, Kazukauskas, Carter-Olinto) | L52 | 265 | **Position correct (after hook).** Content over-comparative — four "Versus X" clauses read like a literature subsection. Compress and merge first two clauses. |
| ¶4 | Empirical strategy (DiD-RD, ITT, bandwidths, inference) | L54 | 278 | **Misplaced — this is §5 prose.** Cut to 50 words; move RV formula, eligibility conjunction, $\bar D = 0.312$, bandwidth definitions, CGM/Holm to §5. |
| ¶5 | (S,s) calibration + headline magnitudes | L56 | 273 | **Triple-purpose — theory + results + magnitude calibration.** Headline magnitudes should be hoisted into ¶1/¶2. Calibration belongs in §3. Four-bin partition footnote belongs in §3 or §4. |
| ¶6 | Numbered contribution paragraph (3 contributions) | L58 | 200 | Right function, **arrives at word ~1,275 — too late.** Move to position ¶3 or ¶4 so a desk-editor sees it on page 2. Split "Methodological" into two if both load-bearing. |
| ¶7 | Roadmap | L60 | 44 | Clean. No change needed. |

**Computed length:** ~1,520 words (excluding section header and label) ≈ 5 double-spaced pages — within AJAE convention but density is the issue, not length.

---

## Contribution sharpness audit

| # | Stated contribution | Sharp? | Falsifiable? | Vs. nearest competitor |
|---|---|---|---|---|
| 1 (M.1) | "First AHM separability test at a per-farm flat-rate direct-payment cutoff" | **Yes** | Yes — uniqueness claim, checkable in lit | vs. Benjamin (1992), LaFave-Thomas (2016): they use demographic IVs in developing countries; we use a developed-country policy cutoff. Differentiation explicit in ¶3. |
| 1 (M.2) | "First DiD-RD evidence on Korean PIDPS" | **Yes** but generic | Yes | vs. Choi & Mun (2025) off-farm-income RDD: same threshold, no DiD-RD + AHM combination. Stated in ¶6. **Split from M.1 — these are two contributions packed as one.** |
| 1 (M.3) | "Restore methodological purity by aligning empirical treatment with policy definition (3-criterion conjunction + 14.6% drop)" | **Mostly** — but this is more of a robustness exercise than a contribution claim | Partly | No direct competitor cited. Risk: reviewer reads this as a robustness check, not a contribution. Consider demoting. |
| 2 (Theoretical) | "AHM-extension framework with two non-separabilities (wealth-bias + supervision) yielding closed-form falsifiable predictions" | **Yes** | Yes — F1 + F2 pre-specified | vs. Carter-Olinto (2003): they document wealth-biased liquidity in rural Paraguay via land-titling; we provide the cross-partial diagnostic at a developed-country direct-payment cutoff. Sharp. |
| 3 (Empirical) | "Monotone-in-tenancy gradient in own-cultivated area + (S,s) operating-cost response in a setting where Kirwan-Baldoni-Ciaian capitalization is muted" | **Yes** | Yes | vs. Kirwan (2009), Baldoni-Ciaian (2023): per-farm flat-rate eliminates per-acre capitalization channel by construction; our $-12\%$ rent-cost pass-through at T2 is institutionally consistent. |

**Overall sharpness verdict:** Contributions are above AJAE-floor in falsifiability. Differentiation from Kirwan / Baldoni-Ciaian / Choi-Jodlowski / Choi-Mun is **explicit and correct**. The defects are **placement** (too late) and **density** (M.1 packs two contributions into one sentence; M.3 is a robustness check sold as contribution).

---

## Recommended structural moves

1. **Hoist headline magnitudes into ¶1.** Insert after the opening question, before any institutional exposition: *"We document that pure-tenant smallholders expand own-cultivated area by 1,122 m² at the policy cutoff ($p{=}.041$), with a monotone gradient in baseline tenancy share, alongside a 3.98 M KRW reduction in operating cost net of rent ($p{=}.057$). The wealth-biased liquidity channel rejects the AHM separability null; the implicit-labor supervision channel does not fire."* This is the Cochrane "tell them the punchline" move.

2. **Compress ¶1 to ~120 words.** Defer Article 10, budget figures, 2.3-trillion-KRW number, 2025 SFFP increase to §2.1. Keep ¶1: opener question → 1-sentence policy summary (per-farm flat-rate, 1.2M KRW at 0.5 ha cutoff) → "distinct from US area-proportional and EU CAP per-hectare" → headline magnitudes → ¶2.

3. **Move ¶4 (empirical strategy) almost entirely to §5.** Keep in §1 only: design name (DiD-RD), sample size ($N{=}13{,}689$, $3{,}420$ farms, 2018–2022), treatment-definition gist ("conjunction of three FHES-observable SFFP criteria"). Everything else (RV formula, three bandwidth labels with citations, CGM, Holm, $\bar D$) belongs in §5. Result: ¶4 collapses from 278 words to ~50.

4. **Promote ¶6 (contribution paragraph) to position ¶4.** New order: opener-hook (¶1) → AHM theory + F1/F2 (¶2) → literature comparison condensed (¶3) → contributions (¶6, promoted) → strategy + headline magnitudes (combined from ¶4+¶5, compressed) → roadmap (¶7).

5. **Cut ¶5 (S,s calibration) by 60%.** Keep one sentence: *"At $T_{SFFP}/\tau \in [0.024, 0.048]$ the SFFP transfer falls deep within the (S,s) inaction band, motivating the operating-cost-disinvestment prediction."* Move the 100-word tractor-combine footnote, the four-bin partition definition footnote, and the robustness-range parenthetical to §3.

6. **Split contribution M.1 into two contributions.** "First AHM separability test at a per-farm flat-rate cutoff" (methodological) and "First DiD-RD on Korean PIDPS" (empirical/setting) are independent — packing them into one sentence reads as padding. Either separate them or pick the load-bearing one (recommend: lead with the AHM-separability-at-policy-cutoff framing, demote the Korean-PIDPS-first claim to a sub-clause).

7. **Demote M.3 ("treatment-indicator alignment with policy definition")** from contribution-list to a sentence inside the strategy paragraph. It is a credibility/identification refinement, not a contribution to the literature.

8. **Promote the pre-specification claim from footnote at line 50 into main text.** The fact that F1/F2 and the outcome hierarchy were pinned before estimation is a credibility-revolution signal that AJAE referees actively look for. Don't bury it.

9. **Cut footnote count from 6 to 2 in §1.** Move the 2025-SFFP-increase footnote, the four-bin partition footnote, the tractor-combine calibration footnote, the household-pooling footnote, and the pre-specification footnote to §2 or §3 (or main text, for the pre-spec).

10. **Target word counts post-revision:** ¶1 ≈ 120, ¶2 ≈ 150, ¶3 ≈ 140, ¶4 (promoted contribution) ≈ 180, ¶5 (compressed strategy + magnitudes) ≈ 130, ¶6 (one-line (S,s) calibration if kept) ≈ 60, ¶7 (roadmap) ≈ 45. **Total ≈ 825 words ≈ 3 double-spaced pages — comfortably inside AJAE convention with the Cochrane arc clean.**

---

## Korea-context framing verdict (rubric item 7)

**Pass with one reservation.** The per-farm-flat-rate-versus-per-hectare contrast IS load-bearing — it appears in ¶1 (line 48: *"not the area-proportional structure of U.S. crop subsidies... or the EU Common Agricultural Policy Pillar I"*), is the explicit framing of ¶3's lit comparison, and underlies the "Kirwan-Baldoni-Ciaian capitalization channel muted" claim in ¶6. The Swiss spatial-RD reference (Zimmert-Zorn 2022) as "closest cousin" is the right move and shows lit awareness. **Reservation:** the contrast is sometimes overstated — "per-farm flat-rate" by itself does not eliminate the rental-incidence channel (general-equilibrium rent could still shift), and the intro's claim that it does so "by construction" at line 86 (§2.3) is mildly stronger than what the model delivers. The ex-theory disclosure in ¶2 (line 50: *"the bargaining and rental-incidence margin... enters the analysis as a reduced-form aggregate-equilibrium implication outside the household-model core"*) is the right hedge, but the intro should not also assert that the channel is muted "by construction" — pick one framing.
