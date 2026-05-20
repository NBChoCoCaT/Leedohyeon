# Lens 7 — Citations (FIFTH seven-pass review, post-Phase-2)

**Manuscript:** `paper/en/main.tex` (506 lines)
**Bibliography:** `Bibliography_base.bib` (27 entries)
**Baseline:** post-Phase-1.5b 9.5/10 (0 orphans / 0 unused)
**Scope:** Verify MAFRA2019_pidps_design typing; verify split \citet calls; full orphan/unused audit.

---

## Score: 8.0 / 10  (Δ = −1.5 from 9.5 baseline)

**Verdict:** Below target ≥9.0. One CRITICAL execution defect on the Phase 2 MAFRA addition. Both split \citet calls verify clean. No undefined citations, no other orphans. The score deduction is concentrated in a single fixable Phase 2 task-completion error.

---

## 1. Bibliography entry count

| Phase | Entries | Δ |
|-------|---------|---|
| Phase 1.5b baseline | 26 | — |
| Phase 2 (expected) | 27 | +1 (MAFRA2019_pidps_design) |
| **Phase 2 (actual, this audit)** | **27** | **+1** ✓ |

Count matches the brief.

---

## 2. MAFRA2019_pidps_design — typing audit ✓ PASS

Entry at `Bibliography_base.bib:417–426`:

```bibtex
@techreport{MAFRA2019_pidps_design,
  author      = {{Ministry of Agriculture, Food and Rural Affairs}},
  author_ko   = {{농림축산식품부}},
  title       = {Public-Interest Direct Payment Scheme Implementation Plan: ...},
  title_ko    = {공익직불제 시행계획: ...},
  institution = {Republic of Korea, Sejong},
  year        = {2019},
  type        = {Government Implementation Plan},
  note        = {Act passed 2019-04; PIDPS effective 2020-05-01. The 0.5 ha cutoff
                 for Small-Farmer Flat Payment first appears in the 2019 implementation
                 plan; no pre-2018 ministerial document or National Assembly deliberation
                 referenced this specific threshold. Accessed via the Korea Ministry of
                 Government Legislation database.}
}
```

Checklist per brief:

| Requirement | Status |
|-------------|--------|
| @techreport entry-type | ✓ |
| `institution` field present | ✓ ("Republic of Korea, Sejong") |
| `year` field present | ✓ (2019) |
| `note` field present | ✓ (substantive 4-sentence anticipation-defense note) |
| Bilingual dual-field (author + author_ko, title + title_ko) | ✓ (matches CLAUDE.md bilingual citation convention) |
| `type` override ("Government Implementation Plan") | ✓ (semantic precision over default "Technical Report") |

Entry typing is exemplary — better than several existing entries.

---

## 3. CRITICAL: MAFRA2019_pidps_design is UNUSED in manuscript (Phase 2 execution defect)

**Finding:** The entry was added to `Bibliography_base.bib` but the corresponding `\citep{MAFRA2019_pidps_design}` (or `\citet{...}`) was NEVER inserted into `paper/en/main.tex`.

**Evidence:**

```
$ grep -nE "MAFRA2019|pidps_design" paper/en/main.tex
(no matches)
```

The Phase 2 brief explicitly states the entry was added to support the §3 line 181 anticipation defense. Reading line 181 (the "Estimand and pre-period inference" paragraph), the anticipation argument is structured as three grounds:

> "(i) the per-farm flat-rate SFFP component of PIDPS was specifically designed after 2018 (no pre-announcement of a 0.5~ha cutoff during the FHES baseline window), (ii) we verify continuity of the cutoff density (no evidence of running-variable manipulation) via the \citet{McCrary2008_density} density-discontinuity test ..., and (iii) HonestDiD $\bar M$ bounds on $\hat\beta_1$ remain interpretable under bounded pre-period anticipation per \citet{RambachanRoth2023_honestdid}."

Ground (i) is **precisely** the claim MAFRA2019_pidps_design was added to substantiate — the bib entry's `note` field reads "The 0.5 ha cutoff for Small-Farmer Flat Payment first appears in the 2019 implementation plan; no pre-2018 ministerial document or National Assembly deliberation referenced this specific threshold." This is exactly the empirical anchor for the parenthetical "no pre-announcement of a 0.5~ha cutoff during the FHES baseline window."

But the sentence carries NO citation. Ground (i) is currently a bald assertion. A referee will (correctly) ask: "On what source does this no-pre-announcement claim rest?" The answer exists in the bibliography but is not pointed to from the text.

**Quality-gate classification:** This is not "Undefined citation" (-15 critical per `.claude/rules/quality-gates.md`) — the citation is defined; it just isn't used. It is, however, a **Phase 2 task-completion failure**: the bib edit was completed without the paired \LaTeX{} edit. The integrity of the anticipation defense at §3 line 181 is materially weakened by the omission, because ground (i) — the strongest of the three — is now unsourced.

**Required fix (one-line):** In `paper/en/main.tex:181`, edit:

```latex
(i) the per-farm flat-rate SFFP component of PIDPS was specifically designed
after 2018 (no pre-announcement of a 0.5~ha cutoff during the FHES baseline
window),
```

to:

```latex
(i) the per-farm flat-rate SFFP component of PIDPS was specifically designed
after 2018 \citep{MAFRA2019_pidps_design}, with no pre-announcement of a
0.5~ha cutoff during the FHES baseline window,
```

(Or any equivalent placement that closes the citation gap.)

**Score impact:** −1.5 for an avoidable Phase 2 task-completion miss on a load-bearing referee-defense claim. Once the one-line fix is made, score restores to ≥9.5.

---

## 4. Split \citet calls — both verify CLEAN ✓

### 4.1  Line 144 — wealth-biased liquidity context (split)

```latex
Two AHM extensions---\textbf{wealth-biased liquidity} \citep{CarterOlinto2003_liquidity}
(extending the \citealp{Kazukauskas2013_disinvestment} decoupling-disinvestment lineage)
and \textbf{implicit-labor supervision} \citep{EswaranKotwal1986_supervision}---
yield independent margins through which separability fails.
```

The brief states this was a 2-key \citet split. The current form is `\citep{CarterOlinto2003_liquidity}` followed by a parenthetical `(extending the \citealp{Kazukauskas2013_disinvestment} ... lineage)`. Both keys resolve:

- `CarterOlinto2003_liquidity` → `@article` at Bibliography_base.bib:159 ✓
- `Kazukauskas2013_disinvestment` → `@article` at Bibliography_base.bib:173 ✓

The split is semantically meaningful (Carter–Olinto = primary theoretical anchor; Kazukauskas = lineage extension, hence the parenthetical "extending the ... lineage" framing). Better than the original 2-key citep would have read.

### 4.2  Line 220 — (S,s) lineage (split)

```latex
This adjustment-threshold logic parallels the $(S,s)$ inaction band of
\citet{CaballeroEngel1999_lumpy} cast within an AHM-internal credit constraint;
we take the predictions of \citet{CarterOlinto2003_liquidity} and
\citet{Kazukauskas2013_disinvestment} as load-bearing rather than the macro
lumpy-investment framework, which is outside our $\alpha$-strict AHM-extension scope.
```

The split is into two consecutive \citet calls. Both keys resolve:

- `CarterOlinto2003_liquidity` ✓
- `Kazukauskas2013_disinvestment` ✓

Stylistically correct — when the two cited works are being treated jointly as load-bearing, parallel \citet forms read more cleanly than the compressed \citet{X, Y}.

Both splits **execute as intended in the brief.**

---

## 5. Full orphan / unused audit

### 5.1  Method

```
bib_keys.txt  := all @ keys in Bibliography_base.bib  (27 entries)
cited_keys.txt := all keys appearing in \cite*{...} in paper/en/main.tex  (26 unique)
```

### 5.2  Undefined-in-bib citations (orphan citations)

```
$ comm -13 bib_keys.txt cited_keys.txt
(empty)
```

**0 undefined citations.** Quality-gates rule "Undefined citation (-15 critical)" — clean.

### 5.3  Defined-but-unused bib entries (orphan bib entries)

```
$ comm -23 bib_keys.txt cited_keys.txt
MAFRA2019_pidps_design
```

**1 unused bib entry** — the Phase 2 addition, as documented in §3 above. No other unused entries.

### 5.4  All 26 used entries cross-checked

| # | Key | First in-text use |
|---|-----|-------------------|
| 1 | AlstonJames2002_incidence | §3 line 301 (incidence theory) |
| 2 | BaldoniCiaian2023_eucap | §1 line 50 (EU CAP comparator) |
| 3 | BanerjeeGertlerGhatak2002_tenancy | §8 line 493 (alternative non-separability) |
| 4 | Benjamin1992_separation | §1 line 52 (separability-test lit) |
| 5 | CaballeroEngel1999_lumpy | §1 line 58 ((S,s) band) |
| 6 | CalonicoCattaneoTitiunik2014_rdrobust | §6 line 389 (rdrobust) |
| 7 | CameronGelbachMiller2008_clusterboot | §6 line 410 (wild cluster) |
| 8 | CarterOlinto2003_liquidity | §1 line 52 (Channel A primary) |
| 9 | ChoiJodlowski2025_landreg | §1 line 60 (Korean differentiation) |
| 10 | ChoiMun2025_pidps_offinc | §1 line 60 (Korean differentiation) |
| 11 | EswaranKotwal1986_supervision | §1 line 52 (Channel B auxiliary) |
| 12 | Floyd1965_incidence | §3 line 301 (classical incidence) |
| 13 | FosterRosenzweig1995_learning | §3 line 188 (credit-imperfection lit) |
| 14 | KAMICO_pricelist_2022 | §3 line 260 (τ industry anchor) |
| 15 | KREI_prodcost_2022 | §3 line 260 (τ primary anchor) |
| 16 | Kazukauskas2013_disinvestment | §3 line 144 (lineage) |
| 17 | KhanThomas2008_idiosyncratic | §8 line 493 (macro-investment comparator) |
| 18 | Kirwan2009_rentcap | §1 line 50 (U.S. comparator, headline) |
| 19 | LaFaveThomas2016_markets | §1 line 52 (separability-test lit) |
| 20 | McCrary2008_density | §3 line 181 (density continuity) |
| 21 | PittKhandker1998_credit | §3 line 188 (credit-imperfection lit) |
| 22 | RambachanRoth2023_honestdid | §3 line 181 (HonestDiD) |
| 23 | Roth2022_pretrends | §3 line 181 (single-pre-period caveat) |
| 24 | SinghSquireStrauss1986_ahm | §1 line 52 (AHM canonical) |
| 25 | ZimmertZorn2022_swissrd | §1 line 50 (Swiss cousin) |
| 26 | deJanvryFafchampsSadoulet1991_peasant | §1 line 52 (AHM canonical) |

All 26 used entries resolve. No multi-occurrence anomalies; every key cited is used in a substantively meaningful position (not "stuffed" into a single footnote).

---

## 6. Format-discipline spot-checks (English-only `paper/en/`)

Per `.claude/rules/quality-gates.md` "Bilingual Citation Format Enforcement," `paper/en/**/*.tex` requires author-year (English) form, NOT the Korean "·" form.

Spot-checked all 26 used entries — every in-text citation uses `\citet{...}` / `\citep{...}` / `\citealp{...}` (English form). No Korean-style citation leakage (e.g., no "최민영·문한필(2025)" in English text — ChoiMun2025_pidps_offinc is cited in English form at line 60). ✓ Clean.

Bilingual dual-field check on `MAFRA2019_pidps_design`: carries both `author` (English) and `author_ko` (Korean), both `title` and `title_ko`. Consistent with the 26 other entries which all have either explicit dual-field or English-only author surnames (KREI, KAMICO, MAFRA all carry Korean parallels). ✓

---

## 7. Remaining multi-key \cite* calls (audit, not findings)

The brief mentioned 2× \citet{X,Y} splits in Phase 2. Confirmed both done. Remaining multi-key calls (which are syntactically multi-key and intentional, not split candidates):

| Line | Form | Comment |
|------|------|---------|
| 34 | `\citep{Kirwan2009_rentcap, BaldoniCiaian2023_eucap}` | Abstract — U.S. + EU joint reference, semantically paired |
| 52 | `\citep{SinghSquireStrauss1986_ahm, deJanvryFafchampsSadoulet1991_peasant}` | AHM canonical pair |
| 52 | `\citep{Benjamin1992_separation, LaFaveThomas2016_markets}` | Separability-test lit pair |
| 179 | `\citep{Benjamin1992_separation, LaFaveThomas2016_markets}` | Same pair as line 52 — consistent |
| 188 | `\citep{PittKhandker1998_credit, FosterRosenzweig1995_learning}` | Credit-imperfection lit pair |
| 301 | `\citep{Floyd1965_incidence, AlstonJames2002_incidence}` | Incidence theory pair |
| 487 | `\citep{Floyd1965_incidence, AlstonJames2002_incidence}` | Same pair as line 301 — consistent |

All 7 remaining multi-key calls are semantically paired (canonical pair or domain-lineage pair), not "citation lists." No further splits warranted.

---

## 8. Score breakdown

| Item | Points | Comment |
|------|--------|---------|
| Baseline (Phase 1.5b) | 9.5 | 0 orphans / 0 unused |
| MAFRA bib entry properly typed | +0.0 | Maintained (no deduction; this is the bar, not bonus) |
| Both \citet splits resolve | +0.0 | Maintained |
| MAFRA unused in manuscript (load-bearing) | −1.5 | Phase 2 execution defect; one-line fix restores baseline+ |
| Format discipline (English-only) | +0.0 | Maintained |
| All 26 used keys resolve | +0.0 | Maintained |
| **Phase-2 score** | **8.0** | **Δ = −1.5** |

---

## 9. Action items for Phase 3

| # | Severity | Action | LOE |
|---|---------|--------|-----|
| 1 | CRITICAL | Insert `\citep{MAFRA2019_pidps_design}` at `paper/en/main.tex:181` (anticipation-defense ground (i)) | 1 line |
| 2 | None | No bib edits | — |

**Post-fix expected score:** 9.5–9.7 (restores Phase 1.5b baseline; slight uptick possible if the in-text MAFRA citation strengthens the §3 anticipation defense in a way the Lens 1 narrative reviewer rewards).

---

## 10. Bottom line

Phase 2's two \citet splits and the MAFRA bib entry's typing are clean. The single defect is a Phase 2 task-completion miss: the bib entry was added without the paired in-text \citep. The defect is mechanically fixable in one line and materially strengthens the §3 anticipation defense once fixed. No other orphan/unused/format issues.

Target ≥9.0 NOT met (8.0). One-line fix restores ≥9.5.
