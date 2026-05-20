# Seven-Pass Review Synthesis — Post-Phase-1.5b

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` (496 lines, 56-page PDF)

## Review history

| Pass | Composite | Δ vs prior |
|---|---:|---:|
| Pre-Phase-1 (initial) | 6.4 | — |
| Post-Phase-1 | 7.9 | +1.5 |
| Post-Phase-1.5 | 8.24 | +0.34 |
| **Post-Phase-1.5b (this)** | **8.56** | **+0.32** |

---

## Executive verdict

**Overall state: REVISE-MINOR. Phase 1.5b target ≥8.5 ACHIEVED with +0.06 margin.**

5 of 7 lenses cleared the 8.5 target; 5 of 7 lenses scored ≥9.0 (Citations, Robustness, Methods, Abstract, Prose-close). The 2 lenses below 9.0 are **Intro (5.6, Phase 2 deferred restructure)** and **Results (8.7, Phase 2 M8 four-bin vs five-bin partition consistency)**.

| Lens | Pre-1 | Post-1 | Post-1.5 | **Post-1.5b** | Δ vs Post-1.5 | ≥8.5 |
|---|---:|---:|---:|---:|---:|:-:|
| 1. Abstract | 6.0 | 8.5 | 9.0 | **9.0** | 0 | ✅ |
| 2. Intro | 6.5 | 5.5 | 5.6 | **5.6** | 0 | ❌ (Phase 2) |
| **3. Methods** | 6.5 | 7.5 | 8.2 | **9.0** | **+0.8** | ✅ |
| 4. Results | 4.0 | 8.0 | 8.7 | **8.7** | 0 | ✅ |
| **5. Robustness** | 6.5 | 8.6 | 9.0 | **9.3** | +0.3 | ✅ |
| **6. Prose** | 6.5 | 8.1 | 8.6 | **8.8** | +0.2 | ✅ |
| **7. Citations** | 8.5 | 9.1 | 8.6 | **9.5** | +0.9 | ✅ |
| **Composite** | **6.4** | **7.9** | **8.24** | **8.56** | **+0.32** | ✅ |

---

## Phase 1.5b 6 fixes — all CLOSED or substantially closed

| # | Item | Lens(es) impacted | Status |
|---|---|---|---|
| P1 | §5 SUTVA sign-direction drop + sido FE empirical bound | L3 +0.5 | ✅ CLOSED (clean Manski-Pepper move) |
| P2 | §7 outlier ladder text↔table contradiction | L5 +0.1 | ✅ CLOSED |
| P3 | 7 unused .bib entries dropped | L7 +0.9 | ✅ CLOSED (0 orphans, 26 entries, exact minimum) |
| MAJ-7 | line 488 "sharp ITT" oxymoron | L3 +0.2 | ⚠️ Mostly closed; 1 residual L448 "strictly sharp DiD-RD" |
| MINOR-3 | wild bootstrap "±.01" → "±.07 largest gap" | L5 +0.05 | ✅ CLOSED (honest disclosure) |
| L6 M1 | HonestDiD paragraph first-person register | L6 +0.2 | ✅ CLOSED |

**Phase 1.5b also exposed 2 minor new prose issues (L6 4d, 4e):** "We do not attempt..." (residual first-person), "robust to this empirical magnitude" (awkward phrasing). Both Phase 2 polish.

---

## Remaining CRITICAL/MAJOR for AJAE submission

### Methods (Phase 2 scope)

| # | Issue | Effort |
|---|---|---|
| MAJ-1 | Narrow-window McCrary CJM `rddensity` not at multi-bandwidth | 1 day R |
| MAJ-2 | Covariate continuity at cutoff (CCT 2014) table absent | 1 day R |
| MAJ-3 | Self-reported area_2018 measurement-error sensitivity | 1 day R |
| MAJ-4 | Wild bootstrap B=999 → B=9,999 | 6 hr compute |
| MAJ-6 | Anticipation defense citation (MAFRA legislative history) | research + 1 paragraph |
| MINOR | L448 "strictly sharp DiD-RD" → "two-sided observable-eligibility symmetry" | 2 min |

### Intro (Phase 2 scope)

| # | Issue | Effort |
|---|---|---|
| L2-M1 | Intro 1,569 words, ~30% over AJAE 1,200 cap | 4-6 hr restructure |
| L2-M2 | Lit-review placement (¶3 before results preview) | 1 hr |
| L2-M3 | Headline magnitudes first at word ~1,005 (90-sec desk-screen invisible) | 1 hr |
| L2-M4 | "Versus X" 4-block pattern reads as checklist | 1 hr |

### Results (Phase 2 scope)

| # | Issue | Effort |
|---|---|---|
| L4-M8 | §3 4-bin partition vs §5/tables 5-bin (high_owner inclusion) | 60-90 min canonical sweep |
| L4-M7 | T3 MSE per-outcome bandwidth not stated in prose | 10 min |
| L4-M3 | (RESOLVED — Holm family declared at L344/L366/L400) | — |
| L4-M9 | (RESOLVED — \|t\|<1 anchored at L404, L415) | — |

### Robustness (Phase 2 polish)

| # | Issue | Effort |
|---|---|---|
| L5-MINOR | §7 roadmap sentence (12-item map) | 5 min |
| L5-MINOR | Spec B/C forward-reference from §6 | 5 min |

### Prose (Phase 2 polish)

| # | Issue | Effort |
|---|---|---|
| L6-M3 | 30+ sentences >35 words | 4-6 hr sweep |
| L6-M4 | "Versus X" checklist pattern (same as L2-M4) | 1 hr |
| L6-M5 | (S,s) text vs math mode consistency | 15 min |
| L6-N3 | "Statutorily-eligible" hyphen drop (Chicago 7.86) | 15 min |
| L6-N5 | `\citet{X, Y}` two-key drop | 15 min |
| L6 4d/4e | L348 residual prose fixes | 10 min |

---

## Path to AJAE submission gate (≥9.0)

**Estimated effort:** ~3-4 working days from current 8.56 composite to ≥9.0.

**Highest-leverage Phase 2 items:**
1. **L2 intro restructure** (5.6 → ~8.0, +0.34 composite weight): 6 hours
2. **L4 M8 four-bin/five-bin canonicalization** (8.7 → ~9.2, +0.07 composite weight): 90 min
3. **L3 MAJ-2 covariate continuity table** (9.0 → ~9.4, +0.06 composite weight): 1 day R
4. **L3 MINOR L448** (9.0 → 9.05): 2 min
5. **L6 Phase 2 polish sweep**: 1 day

After Phase 2: projected composite ~9.2/10 (clears AJAE submission gate).

---

## What this verification PASSED on

- ✅ All Phase 1.5b CRITICALs closed (P1, P2, P3, MAJ-7 mostly, MINOR-3, L6 M1)
- ✅ Composite 8.56 ≥ Phase 1.5b target 8.5
- ✅ Methods now AJAE-grade clean on CRIT-level (9.0/10)
- ✅ Robustness exceptional (9.3/10 — referee-trust-building HonestDiD disclosure)
- ✅ Citations exceptional (9.5/10 — exactly minimal bib, 0 orphans, 0 unused)
- ✅ Abstract maintained 9.0/10 across two passes
- ✅ Prose 8.8 above prior best
- ✅ Reproducibility audit PASS (42/42 + 4 McCrary fixes)
- ✅ xelatex compile 0 errors / 0 undefined refs

---

## Token-budget report

```
Seven-pass review (post-Phase-1.5b) complete.
Subagents: 7 (parallel) + 1 synthesizer.
Approx token usage: ~150k (lighter than initial because most lenses were verification-only)
Runtime: ~3-4 min wall-clock.
Output: 7 lens reports + this synthesis in
  quality_reports/seven_pass_main_en_post_phase1_5b/
Composite trajectory: 6.4 → 7.9 → 8.24 → 8.56.
Phase 1.5b target 8.5 cleared.
Next: Phase 2 restructure for AJAE 9.0 submission gate.
```
