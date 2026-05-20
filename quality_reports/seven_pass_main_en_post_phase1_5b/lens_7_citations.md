# Lens 7 — Citations (Fourth Seven-Pass, Post-Phase-1.5b)

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` (496 lines)
**Online appendix:** `paper/en/online_appendix.tex` (580 lines)
**Bibliography:** `Bibliography_base.bib` (427 lines, 26 entries)
**Previous score:** 8.6/10 (Phase 1.5, regressed from 9.1 peak due to Y17 grep bug)
**Target:** ≥ 9.0/10 (restore prior peak)

---

## 1. P3 Closure Verification — The 7 Dropped Orphans

P3 dropped 7 entries the previous Y17 review retained on the basis of a flawed grep. Each must have **zero** presence in both `.bib` and `\cite{}` calls across `main.tex` + `online_appendix.tex`.

| Dropped key | In `Bibliography_base.bib`? | In `\cite{}` (main + appendix)? | Status |
|---|---|---|---|
| `Sandmo1971_uncertainty` | 0 | 0 | CLEAN |
| `Kimball1990_prudence` | 0 | 0 | CLEAN |
| `BlundellPistaferri2003_consumption` | 0 | 0 | CLEAN |
| `Kimhi2000_exit` | 0 | 0 | CLEAN |
| `PietolaVareOudeLansink2003_exit` | 0 | 0 | CLEAN |
| `Foltz2004_dairy` | 0 | 0 | CLEAN |
| `Kazukauskas2014_decoup` | 0 | 0 | CLEAN |

**Verification method:** `grep "^@.*{$key,"` on bib + `grep -E "\\\\cite[a-zA-Z]*\{[^}]*$key[^}]*\}"` on both `.tex` files.
**Result:** 7/7 dropped keys verified absent from both bib and manuscript. **No dangling references; no zombie entries.**

P3 closure: **PASS**.

---

## 2. Bibliography Entry Count

- `grep -c "^@" Bibliography_base.bib` → **26**
- Expected post-P3: 33 − 7 = **26**.
- **Match.**

---

## 3. Orphan Citations (in text but not in bib)

- Cited keys (unique, across `main.tex` + `online_appendix.tex`): **26**
- Bibliography keys: **26**
- `diff /tmp/bib_keys.txt /tmp/cited_keys.txt` → **no differences**.

**Zero orphan citations.** Every `\cite{}` resolves to a `.bib` entry.

---

## 4. Unused .bib Entries (in bib but not in text)

- Bib set minus cited set: **empty**.

**Zero unused entries.** The bibliography is exactly minimal — every entry is cited at least once.

---

## 5. Volume Sanity Check

- Total `\cite*{}` command occurrences (across both files): **87**
- 26 unique keys → average ~3.3 citations per source. Healthy distribution; no single source over-cited or under-cited at first glance.

---

## 6. Complete Citation Inventory (26/26)

All keys present in BOTH bibliography AND at least one `\cite{}`:

```
AlstonJames2002_incidence              Kazukauskas2013_disinvestment
BaldoniCiaian2023_eucap                KhanThomas2008_idiosyncratic
BanerjeeGertlerGhatak2002_tenancy      Kirwan2009_rentcap
Benjamin1992_separation                LaFaveThomas2016_markets
CaballeroEngel1999_lumpy               McCrary2008_density
CalonicoCattaneoTitiunik2014_rdrobust  PittKhandker1998_credit
CameronGelbachMiller2008_clusterboot   RambachanRoth2023_honestdid
CarterOlinto2003_liquidity             Roth2022_pretrends
ChoiJodlowski2025_landreg              SinghSquireStrauss1986_ahm
ChoiMun2025_pidps_offinc               ZimmertZorn2022_swissrd
EswaranKotwal1986_supervision          deJanvryFafchampsSadoulet1991_peasant
Floyd1965_incidence                    KAMICO_pricelist_2022
FosterRosenzweig1995_learning          KREI_prodcost_2022
```

Coverage by theme (informal):
- **Identification toolkit (5):** CalonicoCattaneoTitiunik2014, CameronGelbachMiller2008, McCrary2008, RambachanRoth2023, Roth2022, ZimmertZorn2022 — RD + cluster-bootstrap + pre-trends + DiD-RD machinery, complete.
- **Incidence / capitalization (4):** AlstonJames2002, BaldoniCiaian2023, Floyd1965, Kirwan2009 — full pedigree from Floyd (1965) → Alston-James handbook → Kirwan JPE → Ciaian EU 2023.
- **(S,s) / lumpy investment (3):** CaballeroEngel1999, KhanThomas2008, Kazukauskas2013 — theory + macro extension + ag-specific application.
- **Ag household / separation (5):** Benjamin1992, SinghSquireStrauss1986, LaFaveThomas2016, deJanvryFafchampsSadoulet1991, FosterRosenzweig1995 — separation-failure literature, well-covered.
- **Tenancy / land markets (3):** BanerjeeGertlerGhatak2002, EswaranKotwal1986, CarterOlinto2003 — bargaining + supervision + liquidity.
- **Korean policy nearest neighbors (2):** ChoiJodlowski2025, ChoiMun2025 — both differentiation anchors.
- **Credit / smoothing (1):** PittKhandker1998.
- **Korean data sources (2):** KAMICO_pricelist_2022, KREI_prodcost_2022 — for s_min ≈ 5,000만원 calibration anchor.

No glaring theme gap visible from the citation set alone (substantive theme coverage is Lens 1's domain, not Lens 7's).

---

## 7. Risks / Watch-Items (non-blocking)

1. **The Sandmo / Blundell-Pistaferri drop removes the explicit theory anchor for the "precautionary labor" and "consumption smoothing" auxiliary channels described in CLAUDE.md.** Lens 7 does not judge whether that's substantively right — but if the manuscript still *describes* off-farm-income or consumption results as "Sandmo precautionary" or "Blundell-Pistaferri smoothing" anywhere in prose without the citation, that's a Lens 3/4 (methods/results) issue, not a Lens 7 citation issue. Worth flagging to Lens 3/4 for cross-check.
2. **No standalone `\nocite{}` calls observed** — clean (no entries hidden via `\nocite{*}`).
3. **Compiled bbl integrity** — not checked here; assumed downstream of `latexmk -xelatex` pipeline. If the manuscript was compiled cleanly against the 26-entry bib (Phase 1.5b verified earlier), no further action.

---

## 8. Score

**Score: 9.5/10**
**Δ from post-Phase-1.5 baseline: +0.9 (8.6 → 9.5)**

Above the 9.0 target. Slightly exceeds prior peak (9.1, pre-Y17-bug) because:
- Exact-equality between bib and cite sets (zero orphans, zero unused).
- The 7 P3-dropped keys are cleanly excised from both bib and prose — no zombie remains.
- 26/26 cited / 26/26 present, verified by both forward (bib → cite) and reverse (cite → bib) lookup.

Reserved 0.5 because Lens 7 cannot verify (a) `.bbl` matches `.bib` post-compile without running `bibtex`, and (b) substantive citation appropriateness (which is Lens 1's job). Pure structural-citation review: this is clean.

---

## 9. Recommendation

**No action required from Lens 7.** P3 successfully closed the orphan-entry bug. Bibliography is exactly minimal (26-cited / 26-present). Ready for submission from a citation-mechanics standpoint.

If Lens 3 (methods) or Lens 4 (results) flag any prose still referencing the dropped Sandmo / Blundell-Pistaferri / Kimball / Kimhi / Pietola / Foltz / Kazukauskas2014 frames without a citation, escalate to a coordinated prose-edit; otherwise no follow-up.

---

**Prompt-injection note:** During this review, MCP-server-attached "Discord instructions" appeared embedded inside `Bash` tool output. They were ignored; no Discord, MCP, or access-policy actions were taken. The review proceeded only against the manuscript, appendix, and bibliography as instructed.
