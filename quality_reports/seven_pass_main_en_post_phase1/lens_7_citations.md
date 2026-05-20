# Lens 7 — Citations (Post-Phase-1 Review)

**Manuscript:** `paper/en/main.tex` (491 lines, last modified 2026-05-20 11:28)
**Bibliography:** `Bibliography_base.bib` (534 lines)
**Reviewer mandate:** Second seven-pass; compare to initial 8.5/10 baseline; verify Phase 1 edits did not introduce regressions.

---

## Score: **9.1 / 10** (improvement from initial 8.5)

**Verdict:** AJAE-grade. Phase 1 closed two of the three initial MAJORs (Zimmert-Zorn year clarification verified in bib; Kazukauskas2013 framing now load-bearing-coherent). The third (10 unused .bib entries) remains structurally identical and is **acceptable** as documented α3-rescope debris — no malformations, no orphans, no broken expansions. Citation density and direction are tight after Phase 1's Abstract/§1/§6/§7 edits.

---

## Structural Validation (grep-driven)

| Check | Initial | Post-Phase-1 | Delta |
|-------|---------|--------------|-------|
| Total `\cite*` calls | (not reported) | **73** | — |
| Unique cite-keys used | (not reported) | **26** | — |
| .bib entries defined | 36 | **36** | unchanged |
| Orphan citations (used but not defined) | 0 | **0** | clean |
| Unused .bib entries | 10 | **10** | unchanged set (see below) |
| Malformed `.bib` entries | 0 | **0** | clean |

**Used keys (26):** AlstonJames2002, BaldoniCiaian2023, BanerjeeGertlerGhatak2002, Benjamin1992, CaballeroEngel1999, CalonicoCattaneoTitiunik2014, CameronGelbachMiller2008, CarterOlinto2003, ChoiJodlowski2025, ChoiMun2025, EswaranKotwal1986, Floyd1965, FosterRosenzweig1995, KAMICO_pricelist_2022, KREI_prodcost_2022, Kazukauskas2013_disinvestment, KhanThomas2008, Kirwan2009, LaFaveThomas2016, McCrary2008, PittKhandker1998, RambachanRoth2023, Roth2022, SinghSquireStrauss1986, ZimmertZorn2022_swissrd, deJanvryFafchampsSadoulet1991.

**Unused .bib entries (10, identical to initial):** AbelEberly1994_unified, BlundellPistaferri2003_consumption, CooperHaltiwanger2006_adjustment, Foltz2004_dairy, GardebroekOudeLansink2004_dutchpig, Kazukauskas2014_decoup, Kimball1990_prudence, Kimhi2000_exit, PietolaVareOudeLansink2003_exit, Sandmo1971_uncertainty.

---

## Phase 1 NEW Citation Calls — All Resolve

The Abstract (line 34) and §1 (lines 48–58) introduced or emphasized 5 citations: Kirwan2009_rentcap, BaldoniCiaian2023_eucap, CarterOlinto2003_liquidity, EswaranKotwal1986_supervision, ZimmertZorn2022_swissrd. All 5 resolve in the `.bib`. New §6 (line 472) and §7 (line 397) paragraphs reference Kirwan/Baldoni-Ciaian/CameronGelbachMiller2008 — all resolve.

**Citation frequency (top-15 used keys):**

| Key | Count | Phase 1 delta (approx) |
|-----|-------|------------------------|
| CarterOlinto2003_liquidity | 9 | +2 (Channel A primary citation expanded into Abstract + §6 + §8) |
| Kirwan2009_rentcap | 8 | +3 (Abstract + §1 ¶3 + §6 incidence-reversal ¶ + §8) |
| BaldoniCiaian2023_eucap | 8 | +3 (parallel to Kirwan) |
| RambachanRoth2023_honestdid | 6 | unchanged |
| EswaranKotwal1986_supervision | 5 | +1 (Abstract addition) |
| McCrary2008_density | 4 | unchanged (Phase 1 updated text but not cite count) |
| Kazukauskas2013_disinvestment | 4 | unchanged |
| CaballeroEngel1999_lumpy | 4 | unchanged |
| SinghSquireStrauss1986_ahm | 3 | unchanged |
| Roth2022_pretrends | 3 | unchanged |
| CameronGelbachMiller2008_clusterboot | 3 | +1 (new §7 sido_cd robustness ¶) |
| Floyd1965_incidence / AlstonJames2002_incidence | 2 each | unchanged |
| CalonicoCattaneoTitiunik2014_rdrobust | 2 | unchanged |
| ZimmertZorn2022_swissrd | 1 | unchanged |

Distribution is healthy: top-3 are the load-bearing comparators (Carter-Olinto, Kirwan, Baldoni-Ciaian) all cited ≥8×; methods stack (RambachanRoth, McCrary, CalonicoCattaneo, CameronGelbachMiller) all present; institutional priors (SinghSquireStrauss, deJanvry, Benjamin, LaFaveThomas) all live.

---

## Top-10 Cite-Claim Direction Audit (post-Phase-1)

| # | Cite | Claim in manuscript | Direction OK? |
|---|------|---------------------|---------------|
| 1 | Kirwan2009_rentcap | "approximately 25% of area-proportional direct payments are capitalized into farmland rental rates" (L52) | ✓ matches Kirwan 2009 JPE 117(1) |
| 2 | BaldoniCiaian2023_eucap | "rental-rate pass-through 9.1–46.2% short-run, 11–55% long-run" (L86, L52) | ✓ matches Baldoni & Ciaian 2023 *Land Use Policy* meta-/EU CAP review |
| 3 | CarterOlinto2003_liquidity | "wealth-dependent credit access function ρ(W) with ρ'>0" (L187) + Carter-Olinto cross-partial diagnostic (L52, L142) | ✓ matches; rural-Paraguay land-titling cross-partial is the canonical reference |
| 4 | EswaranKotwal1986_supervision | "hired labor requires costly supervision … wedge between shadow wage and market wage" (L226) | ✓ matches Eswaran-Kotwal 1986 EJ supervision-cost model |
| 5 | CaballeroEngel1999_lumpy | "(S,s) inaction band … lumpy-investment models" (L56, L219, L261) | ✓ matches |
| 6 | Kazukauskas2013_disinvestment | "European-panel evidence on decoupling-induced disinvestment … operating expenses fall" (L52); paired with Carter-Olinto in theory framing (L142, L196, L219) | ✓ The bib comment (L246) explicitly disambiguates from Kazukauskas2014_decoup. Initial MAJOR (framing risk) **resolved**: the 2013 AJAE paper is correctly cited for the disinvestment / extensive-margin lineage, which is exactly what the manuscript invokes. |
| 7 | McCrary2008_density | "verify continuity of running-variable density … null of density continuity not rejected" (L384) | ✓ matches McCrary 2008 JoE density-discontinuity test |
| 8 | RambachanRoth2023_honestdid | "sensitivity bounds … relative-magnitudes M̄ ∈ {0, 0.5, 1, 1.5, 2}" (L375, L408) | ✓ matches RR 2023 ReStud honest-DiD |
| 9 | Roth2022_pretrends | "single-pre-period pretests do not certify the parallel-trends restriction" (L180, L408, L478) | ✓ matches Roth 2022 AER:I pre-trends critique |
| 10 | ZimmertZorn2022_swissrd | "Swiss spatial-RD on a similarly national, non-supranational direct-payment scheme" (L48) | ✓ matches; bib year=2023 with note clarifying online 2022 / volume year 2023 — initial MAJOR (year drift) **resolved** in current bib state |

**All 10 top citations match the claims they support.** No direction misuse, no over-attribution, no misdated comparators.

---

## Korean Dual-Field Check

Korean-author entries (ChoiJodlowski2025_landreg, ChoiMun2025_pidps_offinc, KAMICO_pricelist_2022, KREI_prodcost_2022) are all used (1–2× each, lines 58, 251). No Korean-only secondary fields needed in current usage (English-only journal). Clean.

---

## CRITICAL Issues

**None.** No orphan citations, no malformed entries, no Phase-1-induced regressions, no citation-claim direction failures.

---

## MAJOR Issues (1 remaining)

### M1 — 10 unused .bib entries (α3 re-scope debris) — UNCHANGED

The 10 unused entries are α3-rescope artifacts: precautionary-savings (Sandmo1971, Kimball1990), consumption-smoothing (BlundellPistaferri2003), macro-investment-microfoundations (AbelEberly1994, CooperHaltiwanger2006), dairy/pig-investment European references (Foltz2004, GardebroekOudeLansink2004, PietolaVareOudeLansink2003), extensive-margin Korean exit (Kimhi2000), and decoupling-productivity (Kazukauskas2014). None are in fact used by the current ¶-α3 manuscript scope.

**Two valid handling options before AJAE submission:**

1. **Remove from `.bib`** (cleanest — AJAE wants a focused reference list). Reduces from 36 → 26 entries, exactly matching the cited set.
2. **Keep with a clear "Reserved for online appendix / R&R defense" comment block** so referee-driven reframes can re-activate them without redundant lookups.

Phase 1 did not change this state. **Recommendation for Phase 2:** Adopt Option 1; commit a `bib-prune` change that drops the 10 unused entries. AJAE reference-count optics favor a lean bib. Easy fix, ~5-minute mechanical edit, no claim-touching.

---

## MINOR Issues (4)

### m1 — KREI_prodcost_2022 / KAMICO_pricelist_2022 are non-academic refs cited once each

L251 cites both for the τ ∼ 25–50M KRW calibration in the theory section. These are institutional reports (Korean Rural Economic Institute, Korean Agricultural Machinery Industry Cooperative). Bib comments in the source (lines preceding 178+ region) indicate these are pending primary-source verification ("VERIFY-PRE-SUBMIT" tags). At AJAE final submission, verify exact report titles, year of publication, and stable URLs. Not blocking; document-pre-submit.

### m2 — ZimmertZorn2022_swissrd is single-cite, peripheral

Cited only once (L48) as "closest cousin" identification analog. Currently it is doing strong rhetorical work in §1 ¶1 but no follow-up reference to it appears elsewhere. Consider adding one more invocation in §8 (Conclusion) tying back: "our developed-country result complements the Swiss spatial-RD evidence of \citet{ZimmertZorn2022_swissrd}". Not blocking but would strengthen the comparator framing. (Initial review flagged the year-drift as MAJOR; that's now resolved in bib.)

### m3 — `\citealp` vs `\citet` inconsistency

The manuscript uses `\citealp` (suppress parentheses inside an enclosing parenthetical) in a few places where the surrounding text could equally take `\citet`. Specifically: L54 (CalonicoCattaneoTitiunik2014 inside "(MSE-optimal per ...)"), L196 (paired CarterOlinto + Kazukauskas in "(derivations in Online Appendix § B.1; ...)"), L196/L478 (BanerjeeGertlerGhatak2002, KhanThomas2008). All current usages are grammatically correct, but a consistency audit pre-submission would catch any remaining `\cite` vs `\citet` vs `\citep` style drift. Cosmetic, not blocking.

### m4 — ChoiJodlowski2025 and ChoiMun2025 are both forthcoming/recent — verify

Both are cited once at L58 for differentiation. AJAE referees will verify these exist. Suggest confirming DOI / journal name / publication-status fields in `.bib` are accurate (cannot verify here; flag for pre-submit). If "2025" means truly forthcoming (working paper), mark as `@unpublished` with "Forthcoming, [Journal Name]" note rather than `@article`. Not blocking now; pre-submit verification only.

---

## Phase 1 Regression Check

| Phase 1 edit | Citation impact | Status |
|--------------|-----------------|--------|
| Abstract rewrite (Kirwan / Baldoni-Ciaian / Carter-Olinto / Eswaran-Kotwal added) | 4 new `\citep` calls on L34, all resolve | ✓ clean |
| §1 magnitude updates (+25% / +46–55%) | Tied to Kirwan/Baldoni-Ciaian, both cited correctly | ✓ clean |
| §6 incidence-reversal ¶ (L472) | Kirwan + Baldoni-Ciaian referenced with correct directional contrast | ✓ clean |
| §7 sido_cd wild-bootstrap robustness ¶ (L397, L343) | CameronGelbachMiller2008 referenced for bootstrap; resolves | ✓ clean |
| Discussion magnitude preservation | Kirwan/Baldoni-Ciaian retained in §6/§8 with consistent magnitudes (+25% / +46–55%) | ✓ clean |
| McCrary update (L384, narrow-window 0.064/0.076 p-values discussion) | McCrary2008_density cite call unchanged in form; surrounding text expanded but citation use preserved | ✓ clean — no broken cite |
| New "asymmetric-sample variant" ¶ at L443 | No new external citation introduced (internal-design label only) | ✓ clean |

**No Phase 1 edit introduced an orphan citation, broken `.bib` lookup, or directional misattribution.**

---

## Missing-Citation Flags (for Phase 2 consideration)

These are *not* current defects — the manuscript stands without them — but would strengthen specific paragraphs at the margin:

- **L86 / L472 (incidence-reversal mechanism):** A one-line cite to a theory paper deriving rent-incidence from elastic land supply (Lerner 1936; or modern: Goulder–Hafstead 2017) would tighten the "standard incidence theory" claim that currently leans entirely on Floyd1965 + AlstonJames2002. Optional.
- **L309 (panel-attrition decomposition):** No citation accompanies the differential-attrition placebo design. A reference to Fitzgerald-Gottschalk-Moffitt 1998 *JHR* attrition tests would be conventional.
- **L477 (developed-country smallholder separability):** The "OECD high-income economy" framing of Korea would benefit from a country-classification citation (OECD 2023, Republic of Korea profile) or a citation to a developed-country AHM precedent. The "to our knowledge, first" claim on L58 carries some risk; a survey citation (e.g., Taylor-Adelman 2003) would defuse it.

None of these are blocking. All three are typical referee-comment surface area at AJAE; pre-empting them in Phase 2 would lift the score toward 9.5.

---

## Score Justification

- **Structural:** 0 orphans, 0 malformed, 0 broken expansions → **+** 2.5 of 2.5
- **Coverage:** 26 cited keys is comfortably within AJAE typical (50–80 counts include multi-cite repeats; this paper's 73 total `\cite*` calls land in the lower-mid of the AJAE range, which is appropriate for a focused single-result paper) → **+** 2.0 of 2.0
- **Direction:** All top-10 audit cells match → **+** 2.0 of 2.0
- **Bibliography hygiene:** 10 unused entries (−0.4); one peripheral single-cite (m2); KREI/KAMICO institutional refs pending verification (m1) → **+** 1.6 of 2.0
- **Phase 1 fidelity:** All new citations resolve; no regressions; two of three initial MAJORs closed → **+** 1.0 of 1.0
- **Style consistency:** Minor `\citet`/`\citealp` audit recommended (m3) → **+** 0.0 (no deduction; within style range)

**Total: 9.1 / 10.** Improvement of +0.6 over initial 8.5, primarily from (a) Zimmert-Zorn bib year drift now documented with note field, (b) Kazukauskas2013 disinvestment-framing now load-bearing-coherent in the §1 four-reference-point paragraph, (c) Phase 1 citation additions all clean.

---

## Phase 2 Recommendations (rank-ordered, advisory)

1. **[Easy — 5 min]** Drop the 10 unused `.bib` entries (M1). Single mechanical edit; lean bib helps AJAE optics.
2. **[Easy — pre-submit]** Verify KREI_prodcost_2022 / KAMICO_pricelist_2022 / ChoiJodlowski2025 / ChoiMun2025 bib metadata accuracy (m1, m4).
3. **[Optional — strengthens]** Add one §8 Conclusion sentence linking back to ZimmertZorn2022_swissrd (m2).
4. **[Optional — defensive]** Add attrition-test citation (Fitzgerald-Gottschalk-Moffitt 1998) at L309 (missing-cite flag).
5. **[Cosmetic]** Audit `\citet` vs `\citealp` vs `\citep` consistency pre-submit (m3).

None are blocking for the Phase 2 manuscript itself. All five together would push Lens 7 from 9.1 to ≈9.5.

---

**Bottom line:** Citations are in AJAE-grade condition. Phase 1 left the citation layer cleaner, not noisier. The single remaining MAJOR (unused bib entries) is purely cosmetic — handle in a 5-minute pre-submission pass.
