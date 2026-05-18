# Lens 7 (Citation audit) — Seven-Pass Review

**Manuscript:** `paper/en/main.tex` + `paper/en/online_appendix.tex` (post-PR #7 merge, 2026-05-18)
**Bib:** `Bibliography_base.bib` (33 entries; 27 pre-existing + 6 new in PR #7)
**Cited keys (unique):** 23 / 33 bib entries (10 uncited, all explicitly flagged in bib as "NOT cited in §3 / α3 framework" — by design)

**Score:** 8.5 / 10

The structural integrity is clean: zero orphan cites, zero Korean-form leaks, zero key-name violations, top-10 cite-claim direction is sound, and the PR #7 metadata is sane modulo two pre-flight verification items. The 1.5-point deduction is split between (i) one minor framing-precision issue on `BaldoniCiaian2023_eucap` (upper-bound numbers without lower-bound disclosure), (ii) two PR #7 institutional-author entries that will render awkwardly under natbib until the bibstyle override is finalized, and (iii) one missing contemporary work an AJAE referee will plausibly request (Calonico-Cattaneo-Titiunik 2014 `rdrobust`).

---

## CRITICAL issues

**None.**

- All 23 cited keys resolve in `Bibliography_base.bib`. No orphan cites.
- C5 lock holds: `CarterOlinto2003_liquidity` consistently described as **Paraguay** (main.tex L58: "rural-Paraguay evidence on wealth-biased liquidity used a land-titling intervention"). No Honduras leak.
- C9 lock holds: `ZimmertZorn2022_swissrd` key reflects 2022 online-first; `year = {2023}` and `note` field documents the online-first/volume-year reconciliation; in-text cite at main.tex L54 reads as a "Swiss spatial-RD ... closest cousin" — direction consistent with source.
- `Kazukauskas2013_disinvestment` (with Clancy in author list, AJAE 95(5):1068–1087, DOI `10.1093/ajae/aat048`) is correctly disambiguated from the 2014 Ag Econ productivity paper `Kazukauskas2014_decoup` (no Clancy); both keys exist; only the 2013 paper is cited in §3, consistent with the bib comment "α3 framework ... NOT cited in §3" for the 2014 entry.
- `EswaranKotwal1986_supervision` is the 1986 EJ 96(382) "Access to Capital and Agrarian Production Organisation" paper, NOT the 1985 AER "Theory of Contractual Structure in Agriculture" — bib comment explicitly notes the disambiguation.

---

## MAJOR issues

**M1. `BaldoniCiaian2023_eucap` upper-bound framing (CoVe-flagged minor, but recurs).** The bib comment records the full range "SR 9.1–46.2%, LR 11–55%." The manuscript cites only the upper-bound numerals at three loci (main.tex L40, L58, L259), as "46–55%" or "up to 46% ... 55%". A referee comparing against the published abstract will see the lower bounds (9%, 11%) suppressed. Recommendation: change one instance — the L58 *Versus BaldoniCiaian* sentence — to "pass-through ranging from 9 to 46% in the short run and 11 to 55% in the long run." The "up to" hedge in L58 is technically defensible but reads as cherry-picking when the range spans an order of magnitude. This is exactly the kind of detail an AJAE Pillar I-literate referee will flag.

**M2. Missing `rdrobust` / DiD-RD methodological citations.** The manuscript invokes "MSE-optimal" bandwidth (T3), "wild cluster bootstrap," and "McCrary density test" (main.tex L60, L273, L291) but cites no methodological source. For AJAE submission an RD paper without **Calonico, Cattaneo, and Titiunik (2014, ECMA 82(6):2295–2326)** — the canonical `rdrobust` MSE-optimal-bandwidth + robust-bias-corrected-inference reference — is unusual. Pair with **Cattaneo, Idrobo, and Titiunik (2019/2020, *A Practical Introduction to Regression Discontinuity Designs*, Cambridge Elements)** for the DiD-RD specifics. Also missing: **Cameron, Gelbach, and Miller (2008, RESTAT)** or **MacKinnon and Webb (2018, JAE)** for the wild cluster bootstrap; **McCrary (2008, JoE)** for the density test. These are stub-section gaps (§4–§6 are STUB), so this is a flagged-for-completion issue rather than a manuscript-as-shipped defect — but the lens-7 audit logs it.

**M3. PR #7 institutional-author rendering (KREI / KAMICO).** `\citep{KREI_prodcost_2022}` and `\citep{KAMICO_pricelist_2022}` are used at main.tex L224. The `author` field uses double-brace protection (`{{Korea Rural Economic Institute (KREI)}}`) so natbib will render the full institutional name verbatim, producing in-text output approximately "(Korea Rural Economic Institute (KREI) 2022)" — readable but verbose. Under `plainnat` the citation will not abbreviate; the bibstyle override TODO in the bib header is the right place to handle this (define a short label or use `key` field). MINOR pending bibstyle landing.

---

## MINOR polish

**P1. PR #7 `% VERIFY-PRE-SUBMIT` flags (6 entries).** All 6 new PR #7 entries carry the flag; expected pre-AJAE-submission cleanup items. No ding.
- `Roth2022_pretrends`: metadata is exactly right per the AER:I-published version — vol 4, no 3, pp 305–322, DOI `10.1257/aeri.20210236`. PASS pending the manual check the bib comment requests.
- `RambachanRoth2023_honestdid`: metadata RES 90(5):2555–2591, DOI `10.1093/restud/rdad018` is correct (RES 2023, October issue). PASS pending manual check.
- `ChoiJodlowski2025_landreg`: `journal = AJAE` without volume/issue/pages — pre-submission verification correctly flagged as "could be working paper." Renders in §1 ¶6 (main.tex L64) as `\citet{...}` style → "Choi and Jodlowski (2025)"; cleanly handled by natbib.
- `ChoiMun2025_pidps_offinc`: Korean characters are confined to `*_ko` fields (`author_ko`, `title_ko`, `journal_ko`). Primary `author`/`title`/`journal` fields are English. natbib will render "Choi and Mun (2025)" — no Korean leak into the compiled paper/en PDF. Local convention override is documented in the bib note (L470–473).
- `KREI_prodcost_2022` / `KAMICO_pricelist_2022`: see M3 above.

**P2. Key naming convention.** All 33 keys conform to `AuthorYear_keyword`. Two stylistic variants:
- Institutional-author keys (`KREI_prodcost_2022`, `KAMICO_pricelist_2022`) substitute the institution acronym for "Author" — a sensible adaptation, internally consistent.
- `deJanvryFafchampsSadoulet1991_peasant` uses the lowercase nobiliary particle "de" — natbib will alphabetize under "J" or "D" depending on style; consider `DeJanvryFafchampsSadoulet1991_peasant` if rendering inconsistency surfaces during compile. NON-BLOCKING.

**P3. Dual-form Korean entries audit.**
- `KREI_prodcost_2022`: ENG primary (`author`, `title`, `institution`) + KO backup (`title_ko`). CONFORMS to local override.
- `KAMICO_pricelist_2022`: same structure. CONFORMS.
- `ChoiMun2025_pidps_offinc`: ENG primary (`author`, `title`, `journal`) + KO backup (`author_ko`, `title_ko`, `journal_ko`). CONFORMS; the bib note correctly cross-references the global header rule it overrides.

**P4. Format check (Korean-form leaks).** Zero leaks. Every in-text citation in `paper/en/` is `\citet`/`\citep`/`\citealp` author-year English form. No 김태화·양승룡-style strings appear anywhere in `main.tex` or `online_appendix.tex`.

---

## Bib audit: all 33 entries

| Key | Type | Cited in body? | Notes |
|---|---|---|---|
| SinghSquireStrauss1986_ahm | book | YES (3×) | §3 baseline AHM anchor |
| deJanvryFafchampsSadoulet1991_peasant | article | YES (2×) | §3 sources of separability failure |
| CaballeroEngel1999_lumpy | article | YES (4×) | §3.4 (S,s) inaction band; main.tex + appendix |
| Sandmo1971_uncertainty | article | NO | bib note: "α3: NOT cited in §3" — intentional |
| Kimball1990_prudence | article | NO | bib note: "α3: NOT cited in §3" — intentional |
| BlundellPistaferri2003_consumption | article | NO | bib note: "α3: NOT cited in §3" — intentional |
| Kirwan2009_rentcap | article | YES (4×) | §1 + §3.4 capitalization comparator |
| BaldoniCiaian2023_eucap | article | YES (4×) | §1 + §3.4 EU CAP comparator; see M1 |
| Kimhi2000_exit | article | NO | exit-margin entry, not cited under α3 |
| PietolaVareOudeLansink2003_exit | article | NO | exit-margin entry, not cited under α3 |
| Foltz2004_dairy | article | NO | exit-margin entry, not cited under α3 |
| Kazukauskas2014_decoup | article | NO | bib note: "α3 primary is the 2013 paper, not this 2014" |
| BanerjeeGertlerGhatak2002_tenancy | article | YES (1×) | §6 Discussion TODO (out-of-scope marker) |
| Floyd1965_incidence | article | YES (3×) | §3.4 rent caveat + appendix |
| AlstonJames2002_incidence | incollection | YES (3×) | §3.4 rent caveat + appendix |
| CarterOlinto2003_liquidity | article | YES (11×) | PRIMARY citation; Paraguay (C5 lock) |
| Kazukauskas2013_disinvestment | article | YES (7×) | §3.4 disinvestment primary |
| AbelEberly1994_unified | article | NO | Step 5 overlay entry; out-of-scope under α3 |
| CooperHaltiwanger2006_adjustment | article | NO | Step 5 overlay entry; out-of-scope under α3 |
| KhanThomas2008_idiosyncratic | article | YES (1×) | §6 Discussion TODO (out-of-scope marker) |
| GardebroekOudeLansink2004_dutchpig | article | NO | Step 5 overlay entry; out-of-scope under α3 |
| EswaranKotwal1986_supervision | article | YES (6×) | Channel B primary; 1986 EJ (not 1985 AER) |
| Benjamin1992_separation | article | YES (4×) | separability-test literature |
| LaFaveThomas2016_markets | article | YES (7×) | separability-test updated evidence |
| PittKhandker1998_credit | article | YES (2×) | §3.2 + appendix B.1 |
| FosterRosenzweig1995_learning | article | YES (1×) | §3.2 |
| ZimmertZorn2022_swissrd | article | YES (1×) | §1 ¶1 closest-cousin (C9 lock) |
| Roth2022_pretrends | article | YES (1×) | PR #7; §3.1 ITT/PT caveat |
| RambachanRoth2023_honestdid | article | YES (1×) | PR #7; §3.1 HonestDiD bounds |
| KREI_prodcost_2022 | techreport | YES (1×) | PR #7; §3.4.1 τ calibration primary |
| KAMICO_pricelist_2022 | techreport | YES (1×) | PR #7; §3.4.1 τ corroborating |
| ChoiJodlowski2025_landreg | article | YES (1×) | PR #7; §1 ¶6 differentiation |
| ChoiMun2025_pidps_offinc | article | YES (1×) | PR #7; §1 ¶6 parallel work |

**Orphan cites:** 0. **Uncited bib entries:** 10, all flagged in bib comments as intentionally NOT cited under the α3 framework (preserved for §6 / robustness / future). No silent dead entries.

---

## Top-10 cite-claim direction check

| Key | In-text claim | Source actually says | Match? |
|---|---|---|---|
| `CarterOlinto2003_liquidity` (11×) | "rural-Paraguay evidence on wealth-biased liquidity used a land-titling intervention; ... the monotone-in-baseline-tenancy cross-partial is the diagnostic both papers share" (L58); also "wealth-biased liquidity" channel anchor | AJAE 85(1):173–186 — Paraguay land-titling experiment, finds property-rights effect on investment is wealth-biased (households below a wealth threshold do not respond). C5-locked country attribution. | YES |
| `LaFaveThomas2016_markets` (7×) | "demographic shocks as instruments ... rejects recursive form"; "developed-country complement to the demographic-instrument null estimates in" | Ecma 84(5):1917–1960 — Indonesia/Central Java, demographic instruments reject AHM separability (recursive factorization). | YES |
| `Kazukauskas2013_disinvestment` (7×) | "European-panel evidence on decoupling-induced disinvestment"; "(S,s) inaction band deepens and operating expenses fall" | AJAE 95(5):1068–1087 — Ireland/Denmark/Netherlands; decoupling reduces gross investment / accelerates farm exit. Direction correct. Authors: Kazukauskas, Newman, Clancy, Sauer (includes Clancy, distinguishing from 2014 paper). | YES |
| `EswaranKotwal1986_supervision` (6×) | "Labor-market completeness fails when hired labor requires costly supervision"; supervision wedge $w_f = w_m + m$ | EJ 96(382):482–498 — capital-access drives the choice between owner-cultivation (own + family labor) vs. capitalist cultivation (hired + supervised labor); supervision cost is the friction. Title in bib ("Access to Capital and Agrarian Production Organisation") confirms 1986 EJ — NOT the 1985 AER. | YES |
| `Kirwan2009_rentcap` (4×) | "approximately 25% of area-proportional direct payments are capitalized into farmland rental rates" | JPE 117(1):138–164 — finds farmers capture ~75%, landowners ~25% of US direct payments. The 25% landowner-share framing is correct. | YES |
| `CaballeroEngel1999_lumpy` (4×) | "(S,s)-type lumpy investment"; "5–10% inaction band" | Ecma 67(4):783–826 — generalized (S,s) approach to US manufacturing investment dynamics; classic lumpy-investment reference. | YES |
| `Benjamin1992_separation` (4×) | "demographic shocks as instruments for rejecting" the null | Ecma 60(2):287–322 — Indonesian household-composition test, fails to reject separation (note: the canonical reading is that Benjamin 1992 *did not reject* — LaFave-Thomas 2016 later does with better data). Manuscript phrasing "the separability-test literature ... has established demographic shocks as instruments for rejecting" is loosely accurate at the *literature*-level (LaFave-Thomas rejects) but is slightly misleading about Benjamin 1992 specifically. MINOR framing flag. | YES (literature-level); MINOR (Benjamin himself does not reject) |
| `BaldoniCiaian2023_eucap` (4×) | "up to 46% in the short run and 55% in the long run" | Land Use Policy 134:106900 — SR 9.1–46.2%, LR 11–55% across regions. Upper-bound only; lower bound suppressed. See M1. | PARTIAL (upper-bound only) |
| `SinghSquireStrauss1986_ahm` (3×) | "recursive factorization theorem under complete markets" | Johns Hopkins Univ Press / World Bank book — canonical AHM recursive-factorization reference. | YES |
| `Roth2022_pretrends` (1×, NEW PR #7) | "single-pre-period pretests do not certify the parallel-trends restriction" | AER:I 4(3):305–322 — exact match. Pretests have low power and induce selection on pretest pass; manuscript framing is correct. | YES |
| `RambachanRoth2023_honestdid` (1×, NEW PR #7) | "sensitivity bounds (HonestDiD $\bar M$)" | RES 90(5):2555–2591 — bounds on post-treatment violations of PT scaled by max pre-period violation $\bar M$. Correct. | YES |

---

## PR #7 new entries audit

| Key | Metadata complete? | Rendering OK? | Notes |
|---|---|---|---|
| `Roth2022_pretrends` | YES (author, title, journal, vol, issue, pages, year, doi) | YES — `\citet{}` → "Roth (2022)" | `% VERIFY-PRE-SUBMIT` flag pending manual cross-check; metadata matches published AER:I version. |
| `RambachanRoth2023_honestdid` | YES (all fields) | YES — "Rambachan and Roth (2023)" | Flag pending manual cross-check; metadata matches RES 90(5). |
| `KREI_prodcost_2022` | PARTIAL — `number = {R-series}` placeholder, no specific report ID/page anchor | VERBOSE — natbib will render full institutional name (see M3) | Pre-submission TODO is correctly flagged; verify specific KREI R-series report and machinery-cost table page. |
| `KAMICO_pricelist_2022` | PARTIAL — no URL, no specific edition confirmation (2021/2022/2023 ambiguity flagged) | VERBOSE — same as KREI | Pre-submission TODO is correctly flagged; secondary-cite acceptable. |
| `ChoiJodlowski2025_landreg` | PARTIAL — journal = AJAE but no vol/issue/pages; could be working paper | YES — `\citet{}` → "Choi and Jodlowski (2025)" | §1 ¶6 (main.tex L64) renders cleanly. Verify journal placement before submission. |
| `ChoiMun2025_pidps_offinc` | PARTIAL — vol/issue/pages missing; journal title may be slightly different in canonical form (`한국농경제학회보` vs `농촌경제`) | YES — Korean confined to `*_ko` fields; natbib will render "Choi and Mun (2025)"; no Korean glyph leak under lmroman12 | Local convention override is documented (bib L470–473); restore to global dual-form once fontspec/custom-bibstyle lands. |

---

## Missing literature (suggested adds)

| Suggested cite | Justification |
|---|---|
| Calonico, Cattaneo, Titiunik (2014, *Econometrica* 82(6):2295–2326) | Canonical robust-bias-corrected RD inference + MSE-optimal bandwidth (`rdrobust` R package). Manuscript invokes "T3 (MSE-optimal)" (L60) and "rdrobust" (CLAUDE.md identification strategy) without citing the methodology paper — AJAE referee will flag immediately. |
| Cattaneo, Idrobo, Titiunik (2019/2020, *Practical Introduction to RDD*, Cambridge Elements, 2 vols) | Companion methodological monographs covering DiD-RD-style designs; widely cited in AJAE RD papers. |
| McCrary (2008, *J. Econometrics* 142(2):698–714) | Density manipulation test — manuscript mentions "McCrary density test" (L273, L291) without citation. CRITICAL pre-submission addition once §4 / §6 are drafted. |
| Cameron, Gelbach, Miller (2008, *RESTAT* 90(3):414–427) **or** MacKinnon and Webb (2018, *J. Applied Econometrics* 33(2):233–248) | Wild cluster bootstrap — manuscript uses this inference at the household level (L60, L273) without citing. |
| Boucher, Barham, Carter (2005, *World Development* 33(1):107–128) | Honduras land-titling-and-credit study; natural extension of the Carter-Olinto 2003 Paraguay reference. Strengthens the "wealth-biased liquidity" literature thread that the manuscript leans on heavily. C5 lock distinguishes this from CO 2003 (which is Paraguay, not Honduras). |
| Carter and Barrett (2006, *J. Development Studies* 42(2):178–199) | Asset-based approach to poverty traps — the theoretical scaffolding behind the Carter-Olinto wealth-threshold logic. Optional for §3.2 framing. |
| Brady, Kallas, Olper (2017, *Eur Rev Ag Econ* 44(5):790–828) **or** Ciaian, Kancs, Espinosa (2018, *Annual Rev Resource Econ* 10:611–632) | Post-Kazukauskas 2013 decoupling-literature update for §1 / §6. AJAE referee may flag the absence of 2015+ work in the EU decoupling stream. |
| Lence and Mishra (2003, *J Agric Resource Econ*) **or** Goodwin and Mishra (2006, *AJAE* 88(1):73–89) | US-side capitalization debate companions to Kirwan 2009 — Goodwin-Mishra in particular is widely-cited and reports lower capitalization rates; would balance the Kirwan-only US-side framing. |

---

## Score rationale

**Base: 10.0.** Zero orphan cites; zero Korean-form leaks in `paper/en/`; zero key-naming-convention violations; all 33 bib entries either cited or explicitly flagged as intentionally uncited under the α3 framework; PR #7 metadata for the two AER:I/RES entries is canonical-correct; C5 (Paraguay) and C9 (Zimmert-Zorn 2023-volume-year) locks both hold across all in-text mentions; dual-form Korean-entry convention is honored with the local-override note correctly documenting the deviation from the bib-header rule.

**Deductions:**
- **−0.5** for M1 — `BaldoniCiaian2023_eucap` upper-bound framing without lower-bound disclosure (suppression of the 9–11% lower bound across 3 in-text loci). Editorially trivial to fix but referee-flag risk.
- **−0.5** for M2 — methodological stub-citation gaps (`rdrobust` / McCrary / wild-cluster-bootstrap). Mitigated by §4/§6 STUB status; will be re-checked when those sections draft, but logged at this lens.
- **−0.3** for M3 — institutional-author rendering verbosity under `plainnat` pending bibstyle override (KREI / KAMICO will print full names in-text).
- **−0.2** for the Benjamin 1992 phrasing (literature-level claim "rejecting" attaches loosely to a 1992 paper that itself does not reject); easily fixed by attaching the verb to "LaFave and Thomas 2016" rather than the joint Benjamin/LaFave-Thomas citation cluster.

**Final: 8.5 / 10.** Strong citation hygiene for a pre-submission draft. The deductions are all cosmetic/precision items, not factual or structural. No CRITICAL or unambiguous MAJOR issues that would derail submission. All flags map to concrete pre-AJAE-submission TODOs already partially queued in PR #7 `% VERIFY-PRE-SUBMIT` markers.
