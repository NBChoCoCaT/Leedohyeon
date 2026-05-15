# Post-Flight Verification — paper/en/main.tex §3

**Date:** 2026-05-15
**Skill:** `/verify-claims paper/en/main.tex`
**Method:** Chain-of-Verification (CoVe) per Dhuliawala et al. 2023 (arxiv.org/abs/2309.11495); forked claim-verifier agent, fresh context
**Claims extracted:** 7 (§3 citations + magnitudes)
**Outcome:** **PARTIAL** (5 SUPPORTED, 1 CONTRADICTED, 1 sharpening recommended)

---

## Supported (5)

| ID | Claim | Evidence |
|---|---|---|
| C1 | Kirwan (2009 JPE 117(1):138-164) reports US capitalization ~25% | NBER WP w16693 + JPE abstract confirm "renters capture 75%, landowners 25%" |
| C2 | Baldoni & Ciaian (2023 LUP 134:106900) report EU CAP magnitudes (sharpening below) | ScienceDirect record + RePEc abstract confirm SR 9.1–46.2% / LR 11–55% |
| C3 | Caballero-Engel (1999 Econometrica) generalized (S,s) | Verified |
| C5 | Kimhi (2000 AJAE 82(1)) part-time as exit transition | Verified |
| C7 | Singh-Squire-Strauss (1986) canonical AHM + separability | Verified |

## Contradicted (1) — CRITICAL

### C4: Sandmo 1971 attribution for "prudence (U''' > 0)" is WRONG

**Draft (incorrect):**
> "Under prudence ($U''' > 0$), households respond by supplying additional off-farm labor as a precautionary buffer \citep{Sandmo1971_uncertainty}."

**Evidence:** Sandmo (1971, *AER* 61(1):65-73, "On the Theory of the Competitive Firm under Price Uncertainty") derives risk-averse under-production via concave utility ($U'' < 0$). The paper does NOT invoke prudence ($U''' > 0$) or derive a precautionary motive.

**Canonical attributions for $U''' > 0$ / prudence / precautionary motive:**
- Leland (1968, *QJE* 82(3):465-473) — original precautionary saving result
- **Sandmo (1970, *Review of Economic Studies* 37(3):353-360)** — saving under uncertainty (DIFFERENT Sandmo paper)
- **Kimball (1990, *Econometrica* 58(1):53-73)** — coined the term "prudence", canonical $U''' > 0$ reference

**Recommended fix:** Cite Kimball (1990) as the canonical prudence reference. Optionally keep Sandmo (1971) as the broader risk-uncertainty framework citation. The original Korean draft (`master_supporting_docs/own_drafts/초안.md` §3.3) already cited both, so this restores fidelity to the original framing.

## Sharpening (1) — informational

### C2: Baldoni-Ciaian magnitude range is wider than "46-55%"

**Draft:**
> "consistent with the $\\sim$25\\% US estimate \\citep{Kirwan2009_rentcap} and the 46--55\\% EU range \\citep{Ciaian2023_eucap}."

**Evidence (direct quote from Baldoni-Ciaian 2023 abstract):**
> "the short-run (long-run) capitalization rate of DDPs into land rents vary between 9.1% and 46.2% (11% and 55%)."

The "46–55%" range in the draft reports only the upper bounds. Two precise alternatives:

**Option A (broader range, faithful to abstract):**
> "consistent with the ~25% US estimate \citep{Kirwan2009_rentcap} and the EU short-run range of 9.1–46.2% and long-run range of 11–55% reported by \citet{BaldoniCiaian2023_eucap}."

**Option B (upper-bound emphasis, more compact):**
> "consistent with the ~25% US estimate \citep{Kirwan2009_rentcap} and the EU long-run estimate of up to 55% \citep{BaldoniCiaian2023_eucap}."

Either preserves the headline contrast (Korea −11.1% vs US +25% vs EU positive). Option A is more rigorous.

---

## Next Steps (apply in Phase 1c)

1. **Bibliography_base.bib:**
   - Add `Kimball1990_prudence` (Econometrica 58(1):53-73)
   - Replace `Ciaian2023_eucap` → `BaldoniCiaian2023_eucap` (per `/validate-bib` finding)
   - Fix `BlundellPistaferri2003_consumption` DOI to `10.2307/3558980`

2. **paper/en/main.tex §3.5 (Channel 2):**
   - Change `\citep{Sandmo1971_uncertainty}` after "prudence" → `\citep{Kimball1990_prudence}` (or `\citep{Kimball1990_prudence, Sandmo1971_uncertainty}` to keep both)

3. **paper/en/main.tex §3.7.1 (Channel 4 Nash bargaining sub-model):**
   - Update `\citet{Ciaian2023_eucap}` → `\citet{BaldoniCiaian2023_eucap}` (2 occurrences in §3.7 + 1 in table)
   - Sharpen the magnitude phrasing per Option A (precise) or Option B (compact)
   - Author attribution "Ciaian et al." → "Baldoni and Ciaian"

4. **paper/ko/main.tex:** mirror all corrections (Phase 3 retranslation will cover this).

## Cross-references

- `quality_reports/bib_audit_semantic.md` — /validate-bib output (this report's structural sibling)
- `master_supporting_docs/own_drafts/초안.md` §3.3 — original Korean draft already cited Kimball 1990 alongside Sandmo 1971
- MEMORY `[LEARN:citation-verification]` 2026-05-06 — 11% term-paper error rate precedent
