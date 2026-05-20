# Lens 7 — Citations (Third Seven-Pass Review, Post-Phase-1.5)

**Manuscript:** `paper/en/main.tex` (496 lines)
**Appendix:** `paper/en/online_appendix.tex` (580 lines)
**Bibliography:** `Bibliography_base.bib` (33 entries; was 36 pre-Y17)
**Date:** 2026-05-20
**Reviewer:** Lens 7

---

## Score: **8.6 / 10**  ( Δ = −0.5 vs post-Phase-1 baseline 9.1 )

The lens is still the strongest of the seven, but the post-Phase-1.5 audit surfaces one MAJOR structural finding that did not exist at the post-Phase-1 review: **the Y17 retention rationale was factually incorrect.** All seven "kept" entries are in fact unused in both `main.tex` and `online_appendix.tex`.

---

## Rubric Results

### 1. Structural validation — orphan citations? unused .bib entries?

- **Orphans (cited but not in bib): 0** ✓
- **Unused .bib entries: 7** ✗

Unused (post-Phase-1.5):
```
BlundellPistaferri2003_consumption
Foltz2004_dairy
Kazukauskas2014_decoup
Kimball1990_prudence
Kimhi2000_exit
PietolaVareOudeLansink2003_exit
Sandmo1971_uncertainty
```

Verified via `grep -n` against both `main.tex` and `online_appendix.tex` — **zero occurrences for any of the seven keys**. The Phase 1.5 grep-verification claim in the brief is contradicted by direct inspection.

### 2. Bib entry count: 36 → 33 after Y17 cut?

- `grep -c "^@" Bibliography_base.bib` = **33** ✓
- Y17 removals confirmed absent: `AbelEberly1994`, `CooperHaltiwanger2006`, `GardebroekOudeLansink2004` all return zero matches in the bib file. ✓
- However: the cut should have been **36 → 26** (drop all 10 unused), not 36 → 33. Three were dropped; seven remain orphaned in the bibliography.

### 3. Any new citations introduced by Phase 1.5 edits?

- Total unique citation keys across `main.tex` + `online_appendix.tex` = **26** (26 in main, 8 in appendix, all 8 appendix keys are subset of main).
- No new keys appear that weren't in the post-Phase-1 set. ✓
- Citation density: 37 `\citeX{}` commands in main, 14 in appendix.

### 4. Top-10 cite-claim direction audit

All directional claims spot-checked against bib entries and inline prose:

| Claim in text | Cited as | Direction correct? |
|---|---|---|
| US +25% rent capitalization | `Kirwan2009_rentcap` | ✓ |
| EU CAP +9.1–46.2% SR / +11–55% LR pass-through | `BaldoniCiaian2023_eucap` | ✓ |
| (S,s) inaction band 5–10% | `CaballeroEngel1999_lumpy` | ✓ |
| Wealth-biased liquidity (rural Paraguay, land titling) | `CarterOlinto2003_liquidity` | ✓ |
| European-panel decoupling-induced disinvestment | `Kazukauskas2013_disinvestment` | ✓ |
| AHM separability foundational | `SinghSquireStrauss1986_ahm`; `deJanvryFafchampsSadoulet1991_peasant` | ✓ |
| Separability-test literature (demographic IV in LMICs) | `Benjamin1992_separation`; `LaFaveThomas2016_markets` | ✓ |
| Implicit-labor supervision | `EswaranKotwal1986_supervision` | ✓ |
| Swiss spatial-RD precedent | `ZimmertZorn2022_swissrd` | ✓ |
| Standard incidence theory mapping reduced demand → rent | `Floyd1965_incidence`; `AlstonJames2002_incidence` | ✓ |

All ten top citations are directionally accurate; no sign flips, no mis-attributed magnitudes, no overstated claims. The contrast pairs (Kirwan US +25% vs SFFP −13.7%; Baldoni-Ciaian EU +46–55% vs SFFP −13.7%) are sharp and correctly framed as "reversal" rather than "extension."

### 5. Online appendix: did the 7 retained entries actually appear there?

**No.** This is the lens's MAJOR finding.

The brief stated the seven entries (`Sandmo`, `Kimball`, `BlundellPistaferri`, `Kimhi`, `PietolaVareOudeLansink`, `Foltz`, `Kazukauskas2014`) "are actually used in online_appendix.tex per grep verification." Direct verification:

```bash
for key in BlundellPistaferri2003_consumption Foltz2004_dairy \
          Kazukauskas2014_decoup Kimball1990_prudence Kimhi2000_exit \
          PietolaVareOudeLansink2003_exit Sandmo1971_uncertainty; do
  grep -n "$key" paper/en/main.tex paper/en/online_appendix.tex
done
# → all seven return NOT FOUND
```

Both files share the same `\bibliography{../../Bibliography_base}` line (main.tex:494, online_appendix.tex:578) — there is no alternative bib path that could be hiding these citations. The seven entries are orphaned in the bib file.

---

## Findings

### CRITICAL
None.

### MAJOR
**M1.** Seven unused `.bib` entries remain after Y17 (`BlundellPistaferri2003_consumption`, `Foltz2004_dairy`, `Kazukauskas2014_decoup`, `Kimball1990_prudence`, `Kimhi2000_exit`, `PietolaVareOudeLansink2003_exit`, `Sandmo1971_uncertainty`). The Phase 1.5 retention rationale ("used in online_appendix.tex per grep verification") is factually incorrect — `grep` confirms zero occurrences across both `main.tex` and `online_appendix.tex`. AJAE submission packages should have a clean bib (no unused entries) for the AEA DCAS replication standard. **Fix:** either (a) drop all seven from `Bibliography_base.bib`, or (b) restore the auxiliary-channel discussion (Sandmo precautionary labor, Blundell-Pistaferri consumption smoothing, Kimball prudence) that originally cited them in the online appendix robustness section, consistent with the CLAUDE.md description of "Auxiliary channels (Sandmo precautionary labor, Blundell-Pistaferri consumption smoothing) treated as robustness."

### MINOR
**m1.** `KAMICO_pricelist_2022` and `KREI_prodcost_2022` are non-academic data-source citations (calibration). They are correctly cited inline at the τ-calibration section and represent the only non-peer-reviewed entries in the bib — flag for a `@misc` / `@techreport` consistency check at final formatting pass, but no action required for AJAE submission.

**m2.** `Roth2022_pretrends` and `RambachanRoth2023_honestdid` are cited in main.tex but the actual sensitivity-analysis robustness implementation may live only in the appendix — confirm at next compile that the cite-and-deliver loop closes (i.e., that the cited methods are actually applied somewhere visible to the referee).

---

## Bottom Line

The citation set is **directionally clean and academically accurate** — the AJAE-relevant comparisons (Kirwan, Baldoni-Ciaian, Carter-Olinto, Kazukauskas, Caballero-Engel) are all attributed correctly with sharp magnitude contrasts. The score drop from 9.1 → 8.6 reflects one mechanical hygiene failure: the bib carries seven orphans whose Phase 1.5 retention was justified on a verifiable grep claim that does not in fact verify. This is a one-commit fix — either drop the seven or restore the appendix passages that should cite them.

**Versus baseline (9.1):** Δ = −0.5 (still ≥ 9.0 target if M1 is fixed; **8.6 as observed**).

**Recommendation:** address M1 before the next `/seven-pass-review` rerun; target post-fix score = 9.3.
