# Seven-Pass Review: paper/en/main.tex (Wave 7 post-audit)

**Date:** 2026-05-19
**Path:** /Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex
**Length:** 39 pages, 9 sections (Abstract + §1–§9)
**Status:** Post-PR #15 (Wave 7 main) + PR #16 (follow-up A) + 4 audit-reproducibility fixes (2026-05-19)

## Executive verdict

**Overall state:** **REVISE-MINOR-TO-MAJOR** (one CRITICAL is universal across 4 lenses + 4-7 more MAJORs per lens)

**Composite score: 7.2 / 10** (target for AJAE first submission: ≥ 8.5)

## Cross-lens CRITICAL issues (≥ 2 lenses agree → BLOCKER)

| # | Lenses flagging | Issue | Recommended fix |
|---|---|---|---|
| **C1** | **1, 3, 4, 6, 7** | **Wave 5 vs Wave 7 magnitude drift across paper.** §5 (L350) / §6 (L367 footnote) / §8 Conclusion (L447) / §2 (L94 area pass-through) inconsistent: Wave 5 numbers (+1,089 m² p=.033, -4.18M p=.047, -11.1%) coexist with Wave 7 numbers (+1,122 m² p=.041, -3.98M p=.057, -12.0%). Will trigger desk-rejection. | Sweep §6 footnote L367, §8 Conclusion L447, §2 L94, F1 italicized headline duplicates (L42, L152, L367). Lock Wave 7 numbers throughout. |
| **C2** | **3, 5** | **Wild bootstrap B=999 vs paper claim B=9,999** at L341 (Identification) — execution used B=999 (env-var fast iteration). | Either rerun `09_wild_bootstrap.R` with WILD_R=9999 OR change L341/L387 to "$B=999$ in current draft; $B=9{,}999$ at submission-release stage". |
| **C3** | **5** | **HonestDiD $\bar M^*$ breakdown bound promised in text but not numerically stated** at L398 / L403. | Extract from `alpha3_results.rds$honestdid_results` and insert numeric value. |
| **C4** | **4** | **Figure `fig_f1_fourbin_gradient_T2_en.png` title clipped** at right edge — headline diagnostic figure has `m²)` cut off. | Adjust ggsave width / increase margin in 10_alpha3_estimation.R figure code. |
| **C5** | **4** | **§6 ¶3 claim "off_farm_income statistically near zero across bandwidths"** contradicted by tab_alpha3_results cell-level estimates of -13.9M to +14.3M at p<.001. | Reword: cell-level estimates differ in spec; pooled spec is null. |
| **C6** | **5** | **No placebo cutoffs at non-policy thresholds** (e.g., 0.3, 0.4, 0.6, 0.7 ha) — AJAE-standard RDD robustness. | Add 4-cutoff placebo block to §7 OR explicit defense of why omitted. |

## MAJOR issues (second-round; recommend fixing before submission)

### From Lens 1 (Abstract)
- M1-A: Length ~370-394 words vs AJAE norm 100-150
- M1-B: Abstract sentence 1 verbatim duplicate of §1 sentence 1 (L40 = L56)
- M1-C: Conditional counterfactual at L42 ("A joint F1–F2 null would have been...") doesn't belong in abstract
- M1-D: -12.0% pass-through is statistically null (p=.133); abstract omits p-value
- M1-E: -3.98M op_cost T3 attenuation to ~0; abstract sells as robust

### From Lens 2 (Intro)
- M2-A: L58 "auditable-surface pre-specification posture" leaks ADR-0001/ADR-0002 into intro — demote to footnote
- M2-B: Rental-incidence "ex-theory" disclosure duplicated (L58 + L66) — reads defensive
- M2-C: P4 (L62) overloads paragraph with running variable + bandwidths + inference + sample + outcomes
- M2-D: ITT framing at L62 not yet motivated (5 unobservable criteria deferred to §2.3)
- M2-E: F1/F2 jargon used 3 times before §6 payoff

### From Lens 3 (Methods)
- M3-A: SUTVA never discussed (-12% rent pass-through implies cross-cutoff equilibrium spillover)
- M3-B: Selection from dropping 194 hh asserted-not-proven (need F1 gradient on full sample + balance table)
- M3-C: T3 bandwidth reported in name only — no T3 F1 numbers in §6 prose
- M3-D: F1 strict-AND + Holm step-down is category error (Holm is for OR-families)
- M3-E: Notation slippage β₁ vs β₂ between §3 L296 and §5 L339
- M3-F: McCrary alone has low power; add Cattaneo-Jansson-Ma 2020 rddensity

### From Lens 4 (Results)
- M4-A: T3 bandwidth ambiguity — different per outcome (3,300 for area_own; 1,710 for op_cost); not signposted
- M4-B: Rent pass-through p=.133 (insignificant) but Discussion/Conclusion treat as headline
- M4-C: fig_mccrary_density_full legend "Series 1 / Series 2" — should be "Below cutoff / Above cutoff"
- M4-D: fig_honestdid y-axis renders `m^2` raw caret instead of `m²`
- M4-E: fig_event_study uses scientific notation `4e+06` instead of millions
- M4-F: §6 op_cost result lacks magnitude anchor (no "% of mean" or "× SFFP transfer")
- M4-G: Spec B replication-tolerance claim (L407) is conceptually wrong
- M4-H: F1 trigger "does not fire = AHM rejected" inversion confuses readers

### From Lens 5 (Robustness)
- M5-A: Spec B coefficients deferred to replication package (should be in §7 main text)
- M5-B: Holm inference family unstated
- M5-C: Monotonicity test informal (not Romano-Wolf)
- M5-D: Missing donut / kernel sensitivity
- M5-E: §7.1 area-only framing presents Wave-5-main as virtue-robustness — sharp referee will detect from replication package
- M5-F: §7.2 multi-RV tests marginals, not joint 3D density
- M5-G: Attrition placebo at 1 bandwidth only (should be all 3)

### From Lens 6 (Prose)
- M6-A: Terminology seam ($D_i$ / "treatment dummy" / "statutorily-eligible indicator") — pin one
- M6-B: 290+ word abstract / 75-word intro sentence / 220-word §4 paragraph
- M6-C: "We reject AHM separability" appears 3× (L42, L152, L367) — keep one
- M6-D: L436 over-claim "result generalizes beyond Korea to any small-farm direct-payment design"
- M6-E: "the present framing" appears 5× — reads defensive

### From Lens 7 (Citations)
- M7-A: -11.1% vs -12.0% inconsistency in citation-contrast sentences (L94 vs L40/L308/L363/L434)
- M7-B: Eswaran-Kotwal 1986 EJ used for supervision wedge (1985 AER more canonical)

## MINOR polish (~ 30 items aggregated; defer to pre-submission polish pass)

- Bib VERIFY-PRE-SUBMIT flags ready to clear (Roth 2022, Rambachan-Roth 2023, McCrary 2008, CCT 2014, CGM 2008)
- Zimmert-Zorn cite-key 2022 vs bib year 2023 mismatch
- Unused `Kazukauskas2014_decoup` bib entry — prune
- Various sentence-trimming and tense polishing
- Etc.

## Per-lens scorecard

| Lens | Critical | Major | Minor | Score/10 |
|---|---|---|---|---|
| 1. Abstract | 1 | 4 | 3 | 6.5 |
| 2. Intro | 0 | 5 | 7 | 8.0 |
| 3. Methods | 1 | 6 | 9 | 7.0 |
| 4. Results | 3 | 8 | several | 7.0 |
| 5. Robustness | 3 | 8 | — | 7.0 |
| 6. Prose | 2 | 5 | 1 tic | 6.5 |
| 7. Citations | 0 | 1 | 3 | 8.5 |
| **Composite** | **6 unique** | **~30** | **30+** | **7.2** |

## Revision plan (recommended order)

| Priority | Item | Time | Why first |
|---|---|---|---|
| **P1** | **Fix C1 magnitude drift** (Wave 5 → Wave 7 sweep at §2 L94, §3 L152, §6 L367 footnote, §8 Conclusion L447) | 30 min | Universal flag; desk-reject risk |
| **P2** | Insert HonestDiD M̄* number (C3) | 10 min | Trivial; promised in text |
| **P3** | Reword §6 ¶3 off_farm_income claim (C5) | 10 min | Contradicts table |
| **P4** | Fix figure clipping + legends (C4 + M4-C/D/E) | 30 min | Visual issues |
| **P5** | Trim duplicate "we reject" italicized headline (3 → 1) | 5 min | Stylistic |
| **P6** | Decide on Wild bootstrap (C2): rerun B=9,999 OR hedge text | 30 min (hedge) / 15 min (rerun) | Submission honesty |
| **P7** | Add placebo cutoffs §7 (C6) OR explicit defense | 60 min | Standard AJAE robustness |
| **P8** | Trim abstract to ~200 words (M1) | 20 min | AJAE house norm |
| **P9** | SUTVA paragraph in §3 or §5 (M3-A) | 30 min | Referee-defense |
| **P10** | T3 F1 numbers in §6 prose (M3-C / M4-A) | 15 min | Promise made at L337 |
| **P11** | Notation β₁/β₂ unification (M3-E) | 10 min | Internal consistency |
| **P12+** | Remaining MAJORs (deferable for pre-submission polish pass) | ~2-3h | — |

**Estimated total to lift to 8.5+/10:** ~5-7 hours focused work (excluding any new estimation if Wild bootstrap is rerun).

## Contradictions between lenses

None found. The 7 lenses agree on the central pathology (Wave 5/7 magnitude drift across paper sections) and otherwise complement each other.

## Recommendation

**Apply P1–P6 (CRITICALs + low-effort MAJORs) in this session** before any commit. The remaining MAJORs (P7–P12+) can be a second submission-polish pass; they are individually small but cumulatively shift the composite from 7.2 to 8.5+.
