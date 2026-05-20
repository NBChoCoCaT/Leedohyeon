# Lens 7: Citation Audit
**Date:** 2026-05-20
**Scope:** `paper/en/main.tex` (canonical English manuscript) + `Bibliography_base.bib`
**Auditor:** Lens 7 of `/seven-pass-review` (citations focus)
**Score:** 8.5 / 10

Summary: The bibliography is clean structurally — **zero orphan citations**, zero malformed journal-article entries, all volume/issue/page metadata present and recently verified (Wave 7 PR #21 + 2026-05-19 in-bib annotations). The 26 unique citation keys in main.tex span the AHM core (SSS, dJFS, Benjamin, LaFave-Thomas), the AHM-extension primary literature (Carter-Olinto, Eswaran-Kotwal, Kazukauskas 2013), the incidence comparators (Kirwan, Baldoni-Ciaian, Floyd, Alston-James), the methodological apparatus (CCT, CGM, McCrary, Roth, Rambachan-Roth), and the Korean differentiation set (Choi-Jodlowski, Choi-Mun, Zimmert-Zorn). Direction-of-effect for the four load-bearing comparators (Kirwan +25%, Baldoni-Ciaian 9-55%, Carter-Olinto wealth-biased threshold, Kazukauskas 2013 disinvestment) all match published findings to my training-data knowledge.

**No CRITICAL findings.** Audit yields 3 MAJOR concerns and 5 MINOR concerns, plus 10 unused entries that should be either (i) deliberately cut prior to submission, or (ii) reincorporated.

---

## CRITICAL findings (will trigger desk-reject on inspection)

*None.* All previously-flagged hallucinations (Kimhi 1994 AJAE, Kirchweger 2022, Gardebroek-Lansink 2004 JAE — per 2026-05-06 [LEARN:citation-verification]) have been remediated. Recent additions (Roth 2022, Rambachan-Roth 2023, McCrary 2008, CCT 2014, CGM 2008, Choi-Jodlowski 2025, Choi-Mun 2025) all carry explicit `% VERIFIED 2026-05-19` annotations in the .bib.

---

## MAJOR findings

### M1. Ten unused .bib entries — declare intent before submission.

The bibliography contains 36 entries; main.tex + online_appendix.tex jointly cite 28. **Ten entries are present in `Bibliography_base.bib` but never `\cite`d in either file:**

| Unused key | Likely status per α3 framework re-scoping (2026-05-18) |
|---|---|
| `AbelEberly1994_unified` | Step-5 overlay; α3 framework deprioritized macro lumpy-investment lineage |
| `BlundellPistaferri2003_consumption` | α3 framework explicitly removed consumption-smoothing channel |
| `CooperHaltiwanger2006_adjustment` | Step-5 overlay; same as Abel-Eberly |
| `Foltz2004_dairy` | §3.8 Channel 5 exit margin — channel cut from α3 |
| `GardebroekOudeLansink2004_dutchpig` | Step-5 (S,s) ag application — overlay cut from α3 |
| `Kazukauskas2014_decoup` | Productivity paper; α3 selected the 2013 disinvestment paper instead |
| `Kimball1990_prudence` | α3 explicitly removed prudence channel |
| `Kimhi2000_exit` | §3.8 exit channel — cut from α3 |
| `PietolaVareOudeLansink2003_exit` | §3.8 exit channel — cut from α3 |
| `Sandmo1971_uncertainty` | α3 explicitly removed risk-uncertainty channel |

The .bib comments are honest about this (each unused entry carries an "α3 framework: NOT cited" comment block), but referees who diff the .bib against the manuscript may flag the asymmetry as evidence of unfinished scope decisions. **Recommendation:** Before AJAE submission, either (a) move these to a separate `Bibliography_unused_alpha3-deprecated.bib` not loaded by main.tex, or (b) add one or two of them as one-line discussion comparators in §7 (e.g., `Sandmo1971_uncertainty` + `Kimhi2000_exit` would be natural in the §7 Limitations one-liner that already cites BGG 2002 and Khan-Thomas 2008). Leaving 10 unused entries in the submitted .bib is not desk-reject material but is sloppy at AJAE submission grade.

### M2. Kazukauskas (2013) cited as both "primary" lineage (text) and source for the operating-cost prediction in Table 2 — direction check note.

Lines 142, 196, 219, 276: `Kazukauskas2013_disinvestment` is cited in the *operating-cost / (S,s) sub-prediction* context, paired with Caballero-Engel 1999. The paper's actual title (`Disinvestment, Farm Size, and Gradual Farm Exit: The Impact of Subsidy Decoupling in a European Context`, AJAE 95(5):1068-1087, 2013) studies **decoupling-induced disinvestment across Ireland, Denmark, and the Netherlands**. The manuscript's framing — that decoupled lump-sum payments below the lumpy-adjustment threshold induce ≤0 operating-cost responses through (S,s) inaction — is a *plausible reading* of Kazukauskas et al.'s disinvestment finding, but it is **not directly stated in their abstract**. Their headline is decoupling → disinvestment in capital stock; the (S,s)-inaction-band micro-mechanism is the manuscript's own theoretical bridge (Caballero-Engel 1999 supplies the macro lumpy intuition, Carter-Olinto 2003 supplies the AHM-internal credit constraint). **Direction match: yes, plausibly** — both papers predict ↓ in farm-side investment/operating cost following decoupled lump-sum transfer. **Needs human verification** that the manuscript does not over-claim the Kazukauskas paper as a (S,s) inaction-band paper specifically (it is a disinvestment-from-decoupling paper that the authors *embed* into an (S,s) reading).

### M3. Zimmert-Zorn (2022) year/citation-key drift between text and .bib.

`Bibliography_base.bib` line 380-390: key is `ZimmertZorn2022_swissrd`, `year = {2023}`, with explicit `note = {Published online 29 August 2022; volume year 2023 per Oxford Academic / DOAJ citation convention}`. Main.tex line 48 cites this as `\citep{ZimmertZorn2022_swissrd}` and refers to "a Swiss spatial-RD" without naming the year. The natbib output will render this as "(Zimmert and Zorn, 2023)" because the `year` field overrides the key suffix. **The text never displays the year inline outside the bibliography, so no inconsistency leaks**, but a careful referee diffing against the .bib will notice. **Recommendation:** Either change the .bib key to `ZimmertZorn2023_swissrd` to match the volume-year (3(3):qoac024, 2023) and the rendered citation year, or accept the current state as the publication-vs-print-issue convention. Low risk; flag pre-submission.

---

## MINOR findings

### m1. Pitt-Khandker (1998) and Foster-Rosenzweig (1995) cited as supporting evidence for credit imperfection in Korean smallholder context — relevance stretch.

Line 187: "This imperfection is binding empirically in the developing- and lower-middle-income agricultural literature \citep{PittKhandker1998_credit, FosterRosenzweig1995_learning}, and—we argue—in the Korean smallholder context…". Both cited papers are *developing-country* settings (Bangladesh microcredit; rural India learning). The .bib metadata is correct (Pitt-Khandker JPE 106(5):958-996, 1998; Foster-Rosenzweig JPE 103(6):1176-1209, 1995), but **using them to motivate credit-constraint binding in an OECD high-income economy (Korea) is a stretch**. The manuscript acknowledges this with "we argue—in the Korean smallholder context", but a referee may push back on whether the Korean smallholder credit market is comparable to Bangladesh group-lending or 1990s rural India. **Recommendation:** Consider adding one developed-country / OECD-smallholder credit-constraint reference (e.g., a German or Polish ag-econ paper) as a bridge — Kazukauskas-Newman-Sauer 2014 (currently unused, see M1) or Foltz 2004 (currently unused) would be candidates.

### m2. Cite-density: 82 calls in main.tex is AJAE-appropriate; appendix is sparse.

82 `\cite*` calls in main.tex across 26 unique keys is within AJAE norm (~50–100 calls / 30–50 unique keys typical for AJAE empirical papers); not bloated. Online appendix has 15 calls × 8 unique keys, which is reasonable for a theory-derivations appendix. No action.

### m3. McCrary (2008) used 4× in text but author is given as just "McCrary 2008" in 3 of 4 calls; consistent format check.

All four uses (lines 180, 309, 365, 374, plus the figure caption on line 379) format as `\citet{McCrary2008_density}` or `\citep{McCrary2008_density}` with the noun "the McCrary test" appearing in body text. Format is internally consistent. No action.

### m4. Korean entries — `author` field shadow check.

The .bib comment block at the top states the bilingual dual-field convention (`author` = Korean form, `author_en` = English for paper/en), but **ChoiMun2025_pidps_offinc** at line 522 reverses this convention with an explicit `% LOCAL CONVENTION OVERRIDE (2026-05-18)` comment: `author = {Choi, Min-young and Mun, Han-pil}` (English form primary), `author_ko = {최민영 and 문한필}` (Korean as secondary). The rationale (paper/en uses Latin Modern without Korean glyph support, and natbib reads `author` directly into PDF) is sound for paper/en submission. **However**: KREI_prodcost_2022 (line 429) and KAMICO_pricelist_2022 (line 447) follow the same local-override convention. ChoiJodlowski2025_landreg has English-only authors so no dual-field issue. **Pre-submission action:** When paper/ko revives (post-stabilization per CLAUDE.md), the override convention must be reversed via custom bibstyle or fontspec switch; flag for the paper/ko porting step. No action needed for AJAE submission. The convention is properly documented in-bib.

### m5. Singh-Squire-Strauss (1986) cited as `@book` without ISBN or chapter — minor metadata gap.

Line 31-37: the AHM founding text is cited via @book with author, title, publisher, year. No ISBN, no chapter, no specific page range. For a foundational reference cited only as a framework attribution (not for a specific result), this is acceptable AJAE practice. No action.

---

## Structural validation

- **Orphan citations** (in text, not in .bib): **(none)**
- **Unused .bib entries:** 10 (see M1 above)
- **Malformed entries** (missing year / journal / volume / pages for @article): **(none)**
- **Total `\cite*` calls in main.tex:** 82
- **Unique keys in main.tex:** 26
- **Total `\cite*` calls in online_appendix.tex:** 15
- **Unique keys in online_appendix.tex:** 8
- **Total .bib entries:** 36
- **Cite-density assessment:** AJAE-appropriate (82 calls / 26 unique keys; AJAE empirical norm is ~50–100 calls / 30–50 unique keys)

---

## Top-10 cite-claim direction audit

| .bib key | Claim in text (line + quote) | Paper's actual finding | Match? |
|---|---|---|---|
| `Kirwan2009_rentcap` | line 48, 52, 86, 300, 448, 457: "approximately 25\% of area-proportional direct payments are capitalized into farmland rental rates" | Kirwan (2009) JPE 117(1):138-164 estimates landlords capture ~25% of US Direct and Counter-Cyclical Program payments via rental rates | **YES** (direction + magnitude both correct) |
| `BaldoniCiaian2023_eucap` | line 48, 52, 86, 300, 448, 457: "9.1--46.2\% in the short run and 11--55\% in the long run" | Baldoni & Ciaian (2023) Land Use Policy 134:106900 report SR 9.1-46.2% and LR 11-55% capitalization of CAP Pillar I into EU farmland prices | **YES** (per 2026-05-15 /validate-bib --semantic confirmation in-bib comment) |
| `CaballeroEngel1999_lumpy` | line 52, 219, 261, 365: (S,s) lumpy-investment inaction band; T/τ ∈ [0.024, 0.048] inside 5-10% inaction range | Caballero & Engel (1999) Econometrica 67(4):783-826 — generalized (S,s) model with inaction region around frictionless target; the 5-10% inaction band threshold is the canonical calibration in this literature | **YES** (model-fit claim — needs human verification of "5-10%" specific magnitude claim from the original paper, but the (S,s) inaction-band framing is correct) |
| `Kazukauskas2013_disinvestment` | line 52, 142, 196, 219, 276, 542: AJAE 95(5):1068-1087, "European-panel evidence on decoupling-induced disinvestment" used as primary lineage for (S,s) op-cost prediction | Kazukauskas, Newman, Clancy, Sauer (2013) AJAE 95(5):1068-1087, "Disinvestment, Farm Size, and Gradual Farm Exit: The Impact of Subsidy Decoupling in a European Context" — finds decoupling → disinvestment in Ireland/Denmark/Netherlands | **YES, with caveat** — direction matches (decoupling → ↓ investment/op-cost); the (S,s)-inaction-band micro-bridge is the manuscript's own contribution, not Kazukauskas's framing. See M2 above. |
| `CarterOlinto2003_liquidity` | line 50, 52, 142, 187, 196, 219, 287, 363 (9× total): wealth-biased credit-access rule; rural Paraguay land-titling intervention; "cross-partial both papers share" | Carter & Olinto (2003) AJAE 85(1):173-186 — finds wealth-biased liquidity effects on investment composition under Paraguayan land-titling | **YES** (direction + mechanism both correct) |
| `EswaranKotwal1986_supervision` | line 50, 142, 226, 290, 543: supervision-cost wedge between family and hired labor; EJ 96(382):482-498 | Eswaran & Kotwal (1986) Economic Journal 96(382):482-498, "Access to Capital and Agrarian Production Organisation" — supervision/credit-access basis of contractual structure | **YES** (in-bib comment explicitly distinguishes from 1985 AER "Theory of Contractual Structure" 75(3)) |
| `Sandmo1971_uncertainty` | NOT CITED in paper (unused entry, M1) | n/a | — |
| `BlundellPistaferri2003_consumption` | NOT CITED in paper (unused entry, M1) | n/a | — |
| `ChoiJodlowski2025_landreg` | line 58 (only): "study land-ownership regulation in Korea but not the SFFP subsidy at a cutoff" | Choi & Jodlowski (2025) Land Economics 101(3):374-397 — Korean farmland ownership regulation; verified by PDF in `master_supporting_docs/supporting_papers/` | **YES** (differentiation claim is correct per Wave 7 PR #21 verification) |
| `ChoiMun2025_pidps_offinc` | line 58 (only): "apply an off-farm-income RDD at the same 0.5~ha threshold but do not combine the DiD-RD design with an AHM-separability test" | Choi & Mun (2025) Journal of Korean Rural Planning 31(4):139-150 — RDD on off-farm-income cap criterion only; verified by PDF in `master_supporting_docs/supporting_papers/KCI_FI003274049.pdf` | **YES** (differentiation claim is correct per Wave 7 PR #21 verification) |

Additional methodology-citation audit (not in original "top 10" but high-frequency):

| .bib key | Claim | Match? |
|---|---|---|
| `McCrary2008_density` | line 180, 309, 365, 374, 437: density-discontinuity test for RD running variable manipulation; JoE 142(2):698-714, 2008 | **YES** (verified 2026-05-19 in-bib) |
| `CalonicoCattaneoTitiunik2014_rdrobust` | line 54, 335: MSE-optimal bandwidth + robust bias-corrected RD inference; Econometrica 82(6):2295-2326, 2014 | **YES** (verified 2026-05-19 in-bib) |
| `CameronGelbachMiller2008_clusterboot` | line 54, 339, 387: wild cluster bootstrap with few clusters; RESTAT 90(3):414-427, 2008 | **YES** (verified 2026-05-19 in-bib) |
| `Roth2022_pretrends` | line 180, 398, 454: single-pre-period pretest underpowering warning; AER:Insights 4(3):305-322, 2022 | **YES** (verified 2026-05-19 in-bib) |
| `RambachanRoth2023_honestdid` | line 180, 365, 398, 403, 454 (6× total): HonestDiD M̄ relative-magnitudes sensitivity; ReStud 90(5):2555-2591, 2023 | **YES** (verified 2026-05-19 in-bib) |
| `LaFaveThomas2016_markets` | line 50, 52, 178, 296, 452, 459 (6× total): ECMA 84(5):1917-1960, 2016; market-completeness separability test | **YES** (the comparative-null reading on line 52 — "joint null would be evidence that separability survives in developed-country settings where labor and credit markets approach completeness" — is consistent with the LaFave-Thomas finding of separability failure in their Indonesian / Mexican household-data settings; the manuscript reads the null as a "complement" not a contradiction. Match.) |
| `Benjamin1992_separation` | line 50, 178, 296, 452, 459 (4× total): ECMA 60(2):287-322, 1992; demographic-shock separability test | **YES** (classic separability test using household-composition as instrument; manuscript correctly characterizes it as the demographic-instrument approach we depart from) |
| `Floyd1965_incidence` | line 280, 300, 363, 448: JPE 73(2):148-158, 1965; reduced rental-demand → ↓ equilibrium rent | **YES** (canonical incidence theory) |
| `AlstonJames2002_incidence` | line 280, 300, 363, 448: Handbook of Ag Econ Vol 2B Ch 33; multi-factor incidence handbook chapter | **YES** (correct chapter and volume per .bib; verified Wave 7) |
| `BanerjeeGertlerGhatak2002_tenancy` | line 454: one-line reference in Limitations to "alternative tenancy-contract design"; JPE 110(2):239-280, 2002 | **YES** (West Bengal tenancy reform paper; reference is precise) |
| `KhanThomas2008_idiosyncratic` | line 454: one-line reference to "macro-investment heterogeneity"; ECMA 76(2):395-436, 2008 | **YES** (idiosyncratic-shock lumpy-investment paper) |

---

## Korean dual-field check

| .bib key | Korean field present | Romanized field present | OK for paper/en? |
|---|---|---|---|
| `ChoiMun2025_pidps_offinc` | `author_ko = {최민영 and 문한필}`, `title_ko = {농외소득 상한기준을 활용한 공익직불금의 생산 비연계 검증}`, `journal_ko = {농촌계획}` | `author = {Choi, Min-young and Mun, Han-pil}`, `title = {Validating Production Decoupling…}`, `journal = {Journal of Korean Rural Planning}` | **YES** — local override convention (`author` field carries English form for natbib resolution under paper/en font config) is documented in-bib |
| `KREI_prodcost_2022` | `title_ko = {농산물 생산비조사: 농기계 자본비용 부속표}` | `author = {Korea Rural Economic Institute (KREI)}`, `title = {Annual Agricultural Production-Cost Survey: …}` (English primary) | **YES** — institutional name carries English form; Korean title preserved in title_ko |
| `KAMICO_pricelist_2022` | `title_ko = {농기계 가격조사 연보}` | `author = {Korea Agricultural Machinery Industry Cooperative (KAMICO)}`, `title = {Annual Agricultural Machinery Price Survey}` | **YES** — same convention as KREI |
| `ChoiJodlowski2025_landreg` | n/a (English-only authors and English-language journal) | English-only entry | **YES** (no Korean fields needed) |

**No pure-Hangul-without-Romanization entries.** The dual-field convention is consistently respected; AJAE-compatible.

---

## Missing-citation flags

Conspicuous omissions to consider for inclusion (recent 2020-2025 works on direct-payment incidence, Korean ag policy, or RDD methodology):

1. **Direct-payment incidence (2020–2025) — covered.** Baldoni-Ciaian 2023 is the most recent EU-incidence comparator; Kirwan 2009 remains the canonical US comparator. No conspicuous gap.

2. **Korean ag policy evaluation (2020–2025) — covered for differentiation but light on positive evidence.** Choi-Jodlowski 2025 and Choi-Mun 2025 cover the direct comparators. Consider adding:
   - **김태완·박정현 or similar Korean ag-econ papers on PIDPS** (if any KAEA-published 2021–2024 evaluations exist in `master_supporting_docs/supporting_papers/`). Not strictly needed for AJAE submission but would strengthen the §2 institutional-context discussion. **Needs human verification.**
   - **임소영 et al.** (KREI direct-payment policy evaluations) — would be natural in §2.1 (the PIDPS reform paragraph) as a domestic-evaluation reference. **Needs human verification.**

3. **RDD methodology — covered.** McCrary 2008 + CCT 2014 + CGM 2008 form the standard methodology trio. The HonestDiD apparatus (Roth 2022 + Rambachan-Roth 2023) is a recent and appropriate addition. No gap.

4. **AHM separability tests (2010–2025) — adequately covered.** LaFave-Thomas 2016 is the most recent canonical separability-test paper; Benjamin 1992 anchors the literature. The manuscript would benefit from one additional 2015–2020 separability-test paper if one exists in the AJAE pipeline (e.g., recent African or Latin American smallholder separability tests), but this is not a desk-reject concern. **Optional addition.**

5. **The (S,s) lumpy investment literature in agriculture — light coverage.** Caballero-Engel 1999 + Kazukauskas 2013 + Carter-Olinto 2003 anchor the framework. The unused entries `AbelEberly1994_unified`, `CooperHaltiwanger2006_adjustment`, `KhanThomas2008_idiosyncratic`, and `GardebroekOudeLansink2004_dutchpig` are all available in-bib for one-line inclusion in the §3.4 calibration footnote or §7 Limitations. See M1.

6. **Korean labor markets / off-farm-income context** — the F2 supervision-channel claim (line 226+) cites only Eswaran-Kotwal 1986 (a 1980s contract-theory paper). A recent Korean labor-economics paper on rural off-farm labor supply would strengthen the F2 framing. **Needs human verification of available KCI-indexed candidates.**

---

## Lens 7 verdict

**Score: 8.5 / 10.** No CRITICAL findings, no orphans, no malformed entries, no hallucinated journal references (verified history of three prior corrections in 2026-05-06 [LEARN]). The three MAJOR findings (10 unused entries, Kazukauskas 2013 framing stretch, Zimmert-Zorn 2022/2023 year drift) are all *pre-submission housekeeping*, not load-bearing-claim defects. The cite-claim direction audit confirms all top-12 most-frequently-cited papers match the in-text claims to my training-data knowledge.

**Pre-submission action items, ranked:**

1. (M1) Decide on the 10 unused entries: cut from .bib or reintegrate as one-line comparators. **Required for AJAE submission grade.**
2. (M3) Resolve Zimmert-Zorn 2022 vs 2023 year convention. **Required for clean .bib diff.**
3. (M2) Verify that the Kazukauskas 2013 → (S,s) inaction bridge is presented as the manuscript's own theoretical contribution, not as a Kazukauskas finding. **Required for citation integrity.**
4. (m1) Consider adding one OECD-smallholder credit-constraint reference. **Recommended; not blocking.**
5. (m4) Document the Korean dual-field local-override convention in the README / replication-package notes so referees / replicators understand. **Recommended.**

**Items NOT flagged** (already clean): orphan citations (0), malformed @article entries (0), pure-Hangul-without-Romanization (0), citation density (82 calls / 26 unique keys — within AJAE norm), critical hallucinations (0, history of 3 corrected).

---

**Files reviewed:**
- `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex` (467 lines, 82 cite calls, 26 unique keys)
- `/Users/leedo/Research/01_dissertation_PBDP/paper/en/online_appendix.tex` (580 lines, 15 cite calls, 8 unique keys)
- `/Users/leedo/Research/01_dissertation_PBDP/Bibliography_base.bib` (534 lines, 36 entries)
