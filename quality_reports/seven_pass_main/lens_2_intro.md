# Lens 2 (Intro structure) — Seven-Pass Review

**Score:** 7.5/10

The §1 (lines 54–65, 6 paragraphs) is competently structured and substantively dense, but it leads with institutional description rather than with the research question, and the contribution paragraph (¶6) is overloaded. Strong on 4-anchor positioning, weak on the Cochrane-style hook, and the pre-spec disclosure (a key α3 alpha-test referee concern) is buried in footnotes rather than surfaced in the main text.

## CRITICAL issues

1. **Opening is institutional, not a question.** The first sentence (line 54) is "Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS) marked the largest restructuring of Korean farm subsidies in two decades..." This is a policy-context sentence, not a hook. Cochrane's "Writing Tips for Ph.D. Students" and Varian's "How to Build an Economic Model in Your Spare Time" both insist the opening sentence must state the *question* or *puzzle*. The actual research question — "We ask whether the SFFP transfer alters smallholder farm behavior at the 0.5~ha cutoff" — does not appear until the final sentence of ¶1. For an AJAE direct submission against the Kirwan/Baldoni-Ciaian benchmark, this is a desk-review risk: editors skim the first 3 sentences.

2. **Pre-spec disclosure is footnoted, not surfaced.** The ADR-0001/0002 pre-registration is acknowledged only in footnote on line 56 ("...all predate \S\ref{sec:results} estimation under the present framing and are archived in the replication package"). The EMPIRICAL referee in the α3 alpha test flagged pre-spec credibility as a primary concern. A reader who does not read footnotes (most do not, on first pass) will not learn that F1/F2 are pre-registered. This belongs in main text — one sentence in ¶2 or ¶4.

## MAJOR issues

3. **¶6 (contribution + roadmap) is overloaded.** Lines 64–65 fold three contributions, the Choi-Jodlowski / 최민영·문한필 Korean-prior differentiation, the ex-theory disclosure inheritance, and the full 8-section roadmap into a single paragraph. Standard AJAE practice is to separate the contribution paragraph from the roadmap paragraph. The Korean-prior differentiation (good content, added in PR #7) gets compressed into two sentences when it deserves its own placement.

4. **Findings preview is hedged.** ¶5 (line 62) previews findings with "Preliminary results from the forthcoming \S\ref{sec:results} document the F1 monotone gradient..." The word "Preliminary" and "forthcoming" signal incompleteness to an editor reading the §1 in isolation. Per CLAUDE.md, the §5 results are placeholder/stub, so this is honest — but the framing could be tightened to "Section 5 documents..." without "preliminary." Magnitudes (the −11.1% pass-through, the +408 m² area expansion, T1/T2 figures from CLAUDE.md P3b-2) are absent from the preview; the abstract has them but §1 does not.

5. **Hook structure inverted within ¶1.** ¶1 runs: institutional context → SFFP magnitude → Article 10 statute → comparison to Kirwan/Baldoni-Ciaian/Swiss → question. The Cochrane / Varian arc would be: question → why it matters → context. The institutional details (Article 10, 2.3 trillion KRW budget) could move to §2 (Institutional Context) without loss.

6. **Lit review placement borderline.** Citations Kirwan, Baldoni-Ciaian, Swiss appear in ¶1; Singh-Squire-Strauss, de Janvry-Fafchamps-Sadoulet, Benjamin, LaFave-Thomas, Carter-Olinto, Eswaran-Kotwal all in ¶2. This is *after* the hook attempt (good), but ¶2 reads as a literature review paragraph with the framework grafted on, rather than the framework paragraph with literature in support. Reordering: framework sentence first, then the supporting citations.

## MINOR polish

7. Line 65 has a stray `\` and `\emph{Theoretically}` opens with whitespace that breaks paragraph flow — looks like a paragraph break was almost-but-not-quite made between contributions 1 and 2/3. Either commit to one paragraph or commit to three.
8. ¶3 (line 58) is excellent but very long — 4 anchors × ~60 words each = ~280 words. Consider micro-paragraph breaks per anchor for scannability.
9. "We ask whether..." (line 54 final clause) is conversational/strong but the parenthetical "equivalently, whether the AHM separability null holds in this setting" feels like a translation of the question into formal language — should be the *primary* phrasing.
10. ¶4 (line 60) opens with "We exploit the 0.5~ha SFFP eligibility cutoff..." — this is a methods sentence. Reasonable to keep in §1 but could compress.

## Paragraph-by-paragraph audit

| ¶ | Topic | Strength | Weakness |
|---|---|---|---|
| 1 (54) | Institution + SFFP design + question | Comprehensive policy context; clear comparison to Kirwan/Baldoni-Ciaian/Zimmert-Zorn | Buries question to last clause; opens with institutional history not puzzle |
| 2 (56) | AHM null + extensions + falsification | Channel A/B taxonomy is crisp; F1/F2 triggers stated | Pre-spec disclosure in footnote only; reads as lit-review-first |
| 3 (58) | 4-anchor positioning | All four anchors explicit + LaFave-Thomas graceful-failure clause; differentiation per anchor; Carter-Olinto correctly "rural-Paraguay" (CoVe fix landed) | Long; lacks micro-breaks; each anchor 60+ words |
| 4 (60) | Design (DiD-RD + bandwidths + data) | T1/T2/T3 parallel, outcome hierarchy referenced (ADR-0002), N=14,474 / 3,614 farms match CLAUDE.md | Methods-heavy for §1; could compress |
| 5 (62) | Magnitude calibration + findings preview | Explicit T/τ ∈ [0.024, 0.048] interval; CO-3 sub-prediction stated | "Preliminary" hedge; no magnitudes from P3b-2 (e.g., −11.1%, +408 m²) |
| 6 (64–65) | Contribution + Korean priors + roadmap | All three contributions present; Choi-Jodlowski + 최민영·문한필 differentiation lands cleanly (PR #7); full §2–§9 roadmap | Single overloaded paragraph; stray `\ ` and weird whitespace on line 65; pre-spec discipline mentioned only via "three independent confirmations" inheritance |

## 4-anchor positioning check

| Anchor | Cited in §1? | Differentiation clear? |
|---|---|---|
| Kirwan 2009 JPE (US +25% rent capitalization) | Yes (¶1 line 54, ¶3 line 58) | Yes — "SFFP is per-farm flat-rate, not area-proportional," incidence outside model |
| Baldoni & Ciaian 2023 LUP (EU CAP 46–55%) | Yes (¶1 line 54, ¶3 line 58) | Yes — "national and per-farm flat-rate, structurally distinct" |
| Kazukauskas 2013 AJAE (decoupling-disinvestment) | Yes (¶3 line 58) | Yes — "closest theoretical lineage... we extend by formalizing the wealth-bias signature" |
| Carter & Olinto 2003 AJAE (Paraguay) | Yes (¶2 line 56, ¶3 line 58) | Yes — "rural-Paraguay evidence on wealth-biased liquidity used a land-titling intervention; we use a developed-country direct-payment cutoff." **Honduras → Paraguay CoVe fix has landed** (verified line 58) |
| LaFave & Thomas 2016 ECMA (graceful-failure) | Yes (¶3 line 58) | Yes — "If both F1 and F2 fail to fire, we read the joint null as a precise complement to LaFave-Thomas" |
| Choi-Jodlowski 2025 (Korean prior) | Yes (¶6 line 64) | Yes — "land-ownership regulation in Korea but not the SFFP subsidy at a cutoff" (PR #7) |
| 최민영·문한필 2025 (Korean prior) | Yes (¶6 line 64) | Yes — "off-farm-income RDD at the same 0.5 ha threshold but do not combine the DiD-RD design with an AHM-separability test" (PR #7) |

All 4 + 1 + 2 anchors land with differentiation. The Carter-Olinto Paraguay-not-Honduras fix is verified in main text. Korean-prior differentiation is concrete (RDD vs DiD-RD; subsidy vs ownership regulation), not boilerplate.

## Score rationale

- **+3.0 (baseline structure):** 6-paragraph arc covers hook attempt → framework → positioning → design → magnitudes → contribution+roadmap. All necessary components present.
- **+2.0 (4-anchor positioning):** All four AJAE anchors + LaFave-Thomas + two Korean priors cited with concrete differentiation. CoVe Paraguay fix verified. This is the strongest dimension of §1.
- **+1.5 (substantive content):** N=14,474 / 3,614 farms, T/τ ∈ [0.024, 0.048], ADR-0001/0002 references, primary outcome hierarchy, F1/F2 pre-registration — all the substantive load is there.
- **+1.0 (roadmap):** Full §2–§9 section listing present at line 65.
- **−1.0 (opening with question):** §1 fails the Cochrane/Varian first-sentence test. Hook is institutional, question deferred 8 sentences.
- **−1.0 (pre-spec disclosure in footnote):** ADR pre-registration buried in footnote despite being the α3 alpha-test EMPIRICAL referee's primary concern. Belongs in main text.
- **−0.5 (¶6 overload):** Contribution + Korean priors + ex-theory + roadmap in one paragraph; layout bug on line 65; should be 2–3 paragraphs.
- **−0.5 (findings preview hedged + no magnitudes):** "Preliminary," "forthcoming," and missing P3b-2 numbers (−11.1%, +408 m²) weaken the preview.

**Net: 7.5/10.** AJAE-publishable with a one-pass restructure of ¶1 opening + ¶6 split + main-text pre-spec sentence. The substantive content is already at submission grade; the issue is sequencing and surface.

## Recommended one-pass fix (≤45 min)

1. **Rewrite ¶1 opening sentence** to lead with the question: e.g., *"Does a per-farm flat-rate direct-payment transfer alter smallholder production behavior at an eligibility cutoff? We test the Agricultural Household Model separability null at the 0.5~ha threshold of Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS), exploiting the Small-Farmer Flat Payment (SFFP) — a design distinct from the area-proportional U.S. and EU CAP programs that have dominated the direct-payment incidence literature."* Then institutional details (Article 10, 2.3 trillion KRW) follow.
2. **Promote pre-spec disclosure to main text** — add one sentence in ¶2 or ¶4: *"The α-strict scope (ADR-0001), the outcome hierarchy (ADR-0002), and the F1+F2 falsification triggers were archived in the replication package prior to estimation."*
3. **Split ¶6 into two paragraphs** — (a) three numbered contributions + Korean-prior differentiation; (b) roadmap. Fix the line-65 stray `\ ` whitespace.
4. **Drop "Preliminary" and "forthcoming"** in ¶5 line 62; substitute one quantitative magnitude from P3b-2 (e.g., the −11.1% rent-cost change or the +408 m² area expansion).

These four edits would lift the lens to ~8.5–9.0/10 without disturbing the substantive content that PR #6/#7 established.
