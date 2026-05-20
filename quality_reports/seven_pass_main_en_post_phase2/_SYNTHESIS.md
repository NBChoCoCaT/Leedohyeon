# Seven-Pass Review Synthesis — Post-Phase-2

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` (506 lines, 57-page PDF)

## Review history

| Pass | Composite |
|---|---:|
| Initial | 6.4 |
| Post-Phase-1 | 7.9 |
| Post-Phase-1.5 | 8.24 |
| Post-Phase-1.5b | 8.56 |
| **Post-Phase-2 (this)** | **8.84** |

---

## Executive verdict

**REVISE-MINOR.** Composite **8.84/10** (Δ +0.28 from 8.56) — just **−0.16 below AJAE 9.0 gate**. Three CRITICAL items + one HIGH-severity prose issue block 9.0; all are surgical 1-2 minute fixes totaling ~10 minutes (Phase 2.5 mop-up).

| Lens | Pre-Phase-2 | **Post-Phase-2** | Δ | ≥9.0 |
|---|---:|---:|---:|:-:|
| 1. Abstract | 9.0 | **9.2** | +0.2 | ✅ |
| 2. Intro | 5.6 | **8.2** | +2.6 | ❌ (8.2 < 9.0; phase 3 polish) |
| 3. Methods | 9.0 | **9.1** | +0.1 | ✅ (MAJ-6α residual) |
| 4. Results | 8.7 | **9.2** | +0.5 | ✅ |
| 5. Robustness | 9.3 | **9.4** | +0.1 | ✅ (Wild bootstrap claim overstated) |
| 6. Prose | 8.6 | **8.8** | +0.2 | ❌ (Unicode em-dash regression + L181 HIGH) |
| **7. Citations** | 9.5 | **8.0** | **−1.5** | ❌ (MAFRA bib added but not cited) |
| **Composite** | **8.56** | **8.84** | **+0.28** | **❌ −0.16** |

5 of 7 lenses ≥9.0. The 2 misses (Intro 8.2, Prose 8.8) plus Citations regression (8.0) explain the shortfall.

---

## CRITICAL / HIGH issues (Phase 2.5 mop-up — ~10 min total)

| # | Lens(es) | Issue | Effort |
|---|---|---|---|
| **Q1** | **L3 MAJ-6α + L7 CRITICAL** | **MAFRA2019_pidps_design bib added but never cited inline.** §3 L181 ground (i) "(no pre-announcement of a 0.5 ha cutoff during the FHES baseline window)" lacks `\citep{MAFRA2019_pidps_design}`. Dangling bib + load-bearing claim uncited. Earlier Phase 2 edit must have been reverted. | 2 min |
| **Q2** | **L6 Issue 14 (HIGH) + L3 MIN** | **L181 anticipation defense ↔ §6.5 contradiction.** Ground (iii) claims HonestDiD bounds "remain interpretable under bounded pre-period anticipation"; §6.5 reports M̄* = 0 (bounds breakdown). Internal contradiction visible to any referee. | 3 min |
| **Q3** | **L5 MAJOR P2b-M1+M2** | **§7 wild bootstrap "agree on 13 of 14 cells within ±.02" overstatement.** Actual count from `tab_wild_bootstrap_en.tex`: 9 of 14 within ±.02; 5 cells exceed. Trailing sentence claims "pure-tenant area\_own T2 wild p consistent with .036" but area\_own cells aren't in the wild bootstrap table (only op_cost / off_farm / consumption / farm_income / rent_cost / op_cost_ex_rent). | 5 min |
| **Q4** | **L6 Issue 4 + 5 (regression)** | **Unicode em-dashes at L56 (3 instances in one sentence).** Phase 2 intro restructure introduced Unicode `—` instead of LaTeX `---`. Typesetting regression. | 2 min |
| **Q5** | **L6 Issue 1 (missed sweep)** | **L112 "Statutorily-eligible" capitalized form** — Phase 2 lowercase sweep missed the Table 1 notation row. | 1 min |
| **Q6** | **L3 MIN-L448** | **L458 "strictly sharp DiD-RD" oxymoron** — Phase 2 fix targeted L488 conclusion (closed) but L458 asymmetric-variant paragraph still has the same phrase. | 1 min |

After Q1–Q6 fixes: estimated composite ≈ **9.1** (clears AJAE gate).

---

## MAJOR remaining (Phase 3 polish, NOT blocking)

| # | Lens | Issue |
|---|---|---|
| Y1 | L2 M-int-1 | ¶3 Kazukauskas–Carter-Olinto sentence ~75w, 4 nested clauses — split into two |
| Y2 | L2 M-int-2 | ¶4 cites 92% compliance without cross-ref — point to §2.2 |
| Y3 | L4 M7 | T3 MSE per-outcome bandwidth not stated in §5 prose (only "≈3,300 m²" given) |
| Y4 | L4 m1-m5 | New minors: figure caption Carter--Olinto en-dash drift, table footer "γ scenario/H3" stale labels, imputed_payment row in Table 1 misleading |
| Y5 | L5 MINOR | §7 roadmap sentence (18-item map) still missing |
| Y6 | L5 MINOR | Spec B/C forward-reference from §6 still missing |
| Y7 | L6 Issue 6 | ¶3 compressed but still 110-word run-on with 5 em-dashes — break into list |
| Y8 | L6 Issue 13 | ¶5 "three contributions" italic-tagging in single 250+ word paragraph — split into 3 paragraphs |
| Y9 | L6 Issue 12 | L52 F1/F2 parenthetical asymmetry |
| Y10 | L6 Issues 7+8 | (S,s) text vs math mode inconsistency (Phase 3) |
| Y11 | L6 Issue 19 | "primary/auxiliary" (abstract) vs "load-bearing/informative" (intro) terminology drift |
| Y12 | L6 Issue 23 | L181 comma splice |
| Y13 | L6 Issues 17+18 | Unicode `§` sign vs `\S` |

Total Phase 3 effort: ~3-4 hours. Brings composite to ~9.3.

---

## What Phase 2 closed cleanly (positive findings)

1. **L2 Intro restructure** (5.6 → 8.2, +2.6): biggest single-lens gain in any phase. ¶3 "Versus X" 4-block compressed, ¶4 §5-strategy cut 60%, ¶5 tau-trim. Cochrane arc preserved.
2. **L3 Methods 5 MAJOR closures** (MAJ-1 CJM density, MAJ-2 CCT covariate, MAJ-3 measurement error, MAJ-4 Wild B=9,999, L488 sharp ITT) — methods section now at AJAE-grade.
3. **L4 M3/M8/M9 closures** — Holm family declared, 4-bin→5-bin canonical, |t|<1 anchored.
4. **L7 MAFRA bib entry**: techreport correctly typed with bilingual fields + substantive note (only the inline cite is missing — Q1).
5. **Wild bootstrap B=9,999** result: op_cost_ex_rent T1 p_wild=0.048 (vs analytic 0.105) honestly disclosed as small-cluster CR1 bias evidence.
6. **Phase 1.5b mop-up L6 M1 (HonestDiD register)** holds — no defensive first-person reverted.

---

## Phase 2.5 priority order

| Order | Item | Lens(es) | Score gain |
|---|---|---|---|
| 1 | **Q1**: Add `\citep{MAFRA2019_pidps_design}` to L181 ground (i) | L7 +1.5, L3 +0.2 | +0.24 composite |
| 2 | **Q2**: Soften L181 ground (iii) HonestDiD "remain interpretable" → "quantify" | L6 +0.1, L3 +0.05 | +0.02 composite |
| 3 | **Q3**: Recount wild bootstrap gap (5/14 not 1/14) + drop unsupported area_own claim | L5 +0.1 | +0.01 composite |
| 4 | **Q4**: Replace 3 Unicode em-dashes at L56 with LaTeX `---` | L6 +0.05 | +0.01 composite |
| 5 | **Q5**: L112 "Statutorily-eligible" → "Statutorily eligible" | L6 +0.05 | +0.01 composite |
| 6 | **Q6**: L458 "strictly sharp DiD-RD" → "two-sided observable-eligibility symmetry" | L3 +0.05 | +0.01 composite |

Total composite gain: ~+0.30 → **post-2.5 composite ~9.14** (AJAE gate cleared).

---

## Token-budget report

```
Seven-pass review (post-Phase-2) complete.
Subagents: 7 (parallel) + 1 synthesizer.
Composite trajectory: 6.4 → 7.9 → 8.24 → 8.56 → 8.84.
Phase 2.5 mop-up (~10 min): expected 8.84 → ~9.14.
AJAE 9.0 submission gate: −0.16 below; cleared after Phase 2.5.
```
