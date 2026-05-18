# Seven-Pass Review: paper/en/main.tex (+ online_appendix.tex)

**Date:** 2026-05-18
**Path:** `paper/en/main.tex` (319 L) + `paper/en/online_appendix.tex` (491 L)
**Context:** Post-PR #7 merge integration audit (catch §1↔§3 drift between PR #6 §1 α3 rewrite and PR #7 §3 ADDRESSABLE hot-fix)
**Target:** AJAE submission-readiness audit at 90/100 quality gate
**Out of scope:** §5 Results, §6 Identification Strategy, §7 Robustness, §8 Discussion, §9 Conclusion (all placeholder TODO blocks; flagged but not audited); paper/ko/

---

## Executive verdict

**Overall state: REVISE-MAJOR.**

**Composite score: 7.16 / 10** (mean across 7 lenses, range 6.5–8.5). CLAUDE.md quality gate for first submission is 90/100 (≈9/10); current paper sits 1.84 points below. The α3 framework and B.1 honest-reframe survive the integration audit. **14 CRITICAL issues** surface across 5 of 7 lenses; **most are introduced or revealed by PR #7's structural changes** (F2 demotion prose, magnitude calibration §3.4.1, landscape grid in §B.3, SC2.5 primitive, notation table). One pre-existing CoVe-fixed item (Paraguay attribution) holds.

**Highest-leverage fix (single edit ~30 min, cross-cuts 4 lenses):** rewrite the §3.4 falsification block to stabilize F1/F2 "fires" semantics. This alone closes 1 CRITICAL from Lens 6 (F1 label redefined twice), 1 CRITICAL from Lens 3 (F1 boolean ambiguity in §B.3 trigger column), 1 MAJOR from Lens 1 (F1+F2-null closing sentence), and 1 MAJOR from Lens 2 (footnote 2 stale post-A5).

---

## Cross-lens CRITICAL issues (14 total)

| # | Lens(es) | Issue | Recommendation |
|---|---|---|---|
| **X1** | **3, 6, 7 (cross-cuts)** | **F1/F2 "fires" semantics inversion + post-A5 stale references.** Lens 6 C2/C3: §3.4 falsification `description` block has `[F1]` and `[F1 (load-bearing)]` labels both defining F1 (different content). "F1 fires" meaning inverted mid-list. Lens 3 C3: §B.3 trigger column reads "$\hat\beta_2 \le 0$ at T2 OR (monotone fails at T1 AND T2)" but Operational column has different boolean structure. Lens 6 C4: §1 ¶2 footnote 2 still says "F1+F2 pre-registration" — pre-A5 framing. | Rewrite §3.4 falsification block as 3 items (F1 result, F2 result, joint reading) with stable semantics. Add one-sentence "fires = trigger condition met = REJECTION of mechanism" gloss on first use. Mirror to footnote 2 of §1 ¶2 and §B.3 trigger column. |
| **X2** | **4 (C1)** | **Sign-direction leak in `tab:appB-mapping` liquidity-gradient row.** Empirical-fit cell shows `{pure_tenant -1738; low_owner -600; mixed -393; pure_owner 0}` — these are the RENTED-area decline (CLAUDE.md channel ii), not the $A_{own}$ four-bin gradient (which is +1,089 / +410 / +393 / 0 ref per CLAUDE.md + main.tex L62). The row's outcome is $A_{own} \times (1-s_{0,i})$, predicted sign $>0$ — current cell contradicts its own predicted sign. Headline reviewer-catchable error. | Replace empirical-fit cell with the correct $A_{own}$ four-bin gradient `{+1{,}089 ($p=.033$); +410 ($p=.051$); +393 ($p=.063$); 0 (ref)}` at T2; T1/T3 TBD. |
| **X3** | **4 (C2)** | **$\beta$ symbol collision: discount factor vs regression coefficients.** `tab:notation` defines $\beta$ as discount factor in $T_i/(1-\beta)$; `tab:alpha3-predictions` + `tab:appB-mapping` use $\beta_1,\ldots,\beta_5$ as regression coefficients. The very THEORY-referee C2 notation-drift critique that tab:notation was supposed to fix. | Rename discount factor to $\delta$ in `tab:notation` row 11, eq:CO-threshold L162, §B.1 derivation. Enforce $\hat\beta_k$ (with hat) uniformly for estimators across all 3 tables. |
| **X4** | **3 (C1)** | **§B.1 Step 1 sign hand-wave.** L163–169 derivation of $\partial W^*/\partial T_i < 0$ uses "(other terms)" placeholder; sign actually depends on the $(\lambda_1/\lambda_2)$ vs $R$ wedge. Credit-constrained households have $\lambda_1/\lambda_2 > R$, which flips the numerator. Sign-by-assertion as currently written; theory referee will catch. | Expand "(other terms)" to the full Hessian-determinant denominator with explicit sign argument. Add SC indicating $\lambda_2/\lambda_1$ regime ensuring sign holds, or recast Step 1 with explicit case analysis. |
| **X5** | **3 (C2)** | **SC2.5 → Step 3 monotone-density derivation gap.** New PR #7 SC2.5 asserts $\text{Cov}(W_i, s_{0,i}) < 0$. This does NOT imply $\partial \varphi(W^*)/\partial s_0 \le 0$ — especially under the bimodal $s_0$ distribution flagged in CLAUDE.md (52% pure-owner + 12% pure-tenant + 36% mixed). The very shape that breaks monotone-density. F1 falsification rests on this stipulated monotonicity. | Strengthen SC2.5 to stochastic-dominance condition, OR recast Step 3 as four-bin discrete claims (pure-tenant vs pure-owner contrast, abandon continuous monotone-density). Latter is cheaper. |
| **X6** | **2 (C1)** | **§1 ¶1 opens with institutional context, not the question.** First sentence (L54) is "Korea's 2020 PIDPS marked the largest restructuring..." Question buried in last clause of ¶1. Cochrane/Varian canon: open with the question. | Rewrite L54 as one-sentence question form, e.g., "Does the Agricultural Household Model's separability property hold for Korean small farms exposed to a per-farm flat-rate direct payment at the 0.5 ha eligibility cutoff?" Move institutional context to ¶2 opener. |
| **X7** | **2 (C2)** | **ADR-0001/0002 pre-spec disclosure buried in footnote 2.** EMPIRICAL referee's primary α3-alpha concern was auditable-surface pre-spec. Currently in §1 ¶2 footnote — visually deprioritized. DCAS v1.0 referees scan main text first. | Promote pre-spec disclosure to main-text sentence in §1 ¶2 (or ¶4 contribution paragraph). One sentence: "We pre-specify outcome hierarchy (ADR-0002) and falsification triggers (ADR-0001) prior to estimation; both are archived in the replication package." |
| **X8** | **5 (C1)** | **Anticipation-effects threat unaddressed.** PIDPS Act enacted before 2018 FHES baseline; frozen-rv defense protects against post-2020 manipulation but NOT against pre-2018 strategic area reporting under anticipation. Single biggest pre-emption hole. | Add 2–3 sentences to §3.1 "Estimand and pre-period inference" paragraph (post-L149) acknowledging anticipation risk, citing the running variable's freeze at 2018 baseline relative to PIDPS announcement timeline. Cite forthcoming McCrary density test as ancillary defense. |
| **X9** | **5 (C2)** | **McCrary density framing absent from §3.** §7 stub mentions +0.7pp McCrary density result but §3 framing doesn't introduce it. Reads as post-hoc if surfaced only in robustness. | Add one sentence to §3.1 "Estimand and pre-period inference" paragraph: "We verify cutoff-density continuity (no manipulation) via the McCrary 2008 density test, reported in §7." |
| **X10** | **5 (C3)** | **FHES attrition 20% unquantified.** 3,614 farms × 5 years = 18,070 expected farm-years vs. 14,474 actual ≈ 20% imbalance. CLAUDE.md confirms `panel_2018_2022.dta` has 14,474 but no attrition decomposition. Differential attrition at cutoff untested. | Add §4 Data note on attrition counts + differential-attrition pre-test plan. Cross-reference §7 stub for HonestDiD bounds inclusive of attrition. |
| **X11** | **6 (C1)** | **Abstract + §3.1 italic "We reject AHM separability for Korean small farms" overclaims pre-§5 lock.** L40 (abstract) and L119 (§3.1) both carry the bold rejection in italic. Until §5 results are stabilized, this is a future claim — referee will flag inconsistency between assertion and empty results section. | Hedge to "we test the AHM separability null" in abstract and §3.1 until §5 ships. Restore italic after §5 P3 estimation locks. |
| **X12** | **6 (C2)** | **§3.4 falsification `description` list: 5 items with overlapping F1 labels.** Items 1–5 of the description block redefine `[F1]` twice (`[F1]` and `[F1 (load-bearing)]`). Load-bearing prose that confuses the central design lock. (See X1 for fix.) | Bundled with X1. |
| **X13** | **6 (C3)** | **"F1 fires" / "F1 not fired" semantics counter-intuitive.** Reader on first encounter cannot tell whether "fires" means trigger-condition-met (= REJECTING) or model-confirmed. (See X1 for fix.) | Bundled with X1 — add the one-sentence gloss "fires = trigger met = REJECTION." |
| **X14** | **6 (C4)** | **§1 ¶2 footnote 2 references "F1+F2 pre-registration" using pre-A5 symmetric framing.** Post-A5 F2 is informative-not-rejecting; footnote leaks the pre-A5 reading. | Bundled with X1 — update footnote 2 text to "F1 (load-bearing) + F2 (supporting) pre-specifications." |

---

## MAJOR issues (second-round, 32 total — abbreviated)

| Lens | Count | Representative issues |
|---|---|---|
| **1 — Abstract** | 4 | Method-first sentence, no quantified magnitude (−11.1%, +1,089 m² absent), "first per-farm flat-rate cutoff AHM test" contribution missing, EK supervision channel name missing |
| **2 — Intro** | 4 | ¶6 overloaded (3 contributions + Korean-prior + ex-theory + 8-section roadmap in one paragraph), stray `\ ` whitespace bug L65, findings preview hedged ("Preliminary," "forthcoming") with no magnitudes, ¶2 reads as lit-review-first |
| **3 — Methods** | 6 | Pop/individual estimand mixing eq:CO-1, 50% LTV ratio uncited (M2), HonestDiD $\bar M^*$ uncommitted, F2 EK-1 cancellation regime conflates interior cancellation w/ SC6 corner-solution slack, R-conventions §10 dangling ref in §B.3, SC4 weak-vs-strict inequality asymmetry no MDE |
| **4 — Results** | 6 | Missing symbols in `tab:notation` ($A_i, A_{2018,i}, rv_{2018,i}, h, \bar a, \beta_k, \Delta K, \lambda/\mu$ specifics), $\beta_2$ econometric mapping unspecified, F1 operational decision rule boolean precedence ambiguity (re X1), no magnitude interpretation (+1,089 m² ≈ 22% of cutoff uncontextualized), unit_rent_price mixes levels (KRW/m²) and pass-through (%), `tab:appB-mapping` caption fails to state take-away |
| **5 — Robustness** | 5 | 7.7% non-taker selection unaddressed, lower-τ=20M grazes 5–10% inaction band (no sensitivity curve), multiple-testing family undefined (15+12 tests), EK-1 cancellation regime asserted not bounded, HonestDiD $\bar M^*$ trigger uncommitted |
| **6 — Prose** | 9 | Sentence-length saturation (~30 long sentences ≥40 words; 90-word at L56; 66-word at L54/L58/L65); §3.2 "Aggregation note" italic inline label → should be `\paragraph{}`; §3.4.1 footnote (L224) + ¶2 closer (L226) each 50+ words; §4 MDIS footnote (L266) crams 4 ideas in 95 words |
| **7 — Citations** | 2 | Baldoni-Ciaian upper-bound framing recurring across 3 in-text loci (full range is 9–55%, not "46–55%"); missing AJAE-expected method cites (Calonico-Cattaneo-Titiunik 2014 ECMA, McCrary 2008 JoE, Cameron-Gelbach-Miller 2008 RESTAT) — mitigated by §4/§6 STUB but flag for pre-submission |

---

## MINOR polish (28 items, abbreviated)

- Stray `\ ` whitespace at main.tex L65 (paste artifact from PR #7)
- Benjamin 1992 grouped with LaFave-Thomas 2016 under "rejecting" verb (Benjamin himself does not reject); L155
- "wealth-bias rejection region" opaque jargon in abstract
- Needs USD conversion (≈ \$900) for SFFP scale in abstract
- "pre-register" should be "pre-specify" (no public RCT registry)
- KREI/KAMICO institutional-author rendering verbose under `plainnat` (cosmetic)
- ChoiJodlowski 2025 metadata `% VERIFY-PRE-SUBMIT` placeholder (journal field "AJAE" no vol/issue)
- ChoiMun 2025 metadata `% VERIFY-PRE-SUBMIT` placeholder
- Roth 2022 exact title to manual-verify against AEA-published version
- Rambachan-Roth 2023 vol/issue confirmed (90(5):2555–2591); page metadata to manual-verify
- §3.2 "Aggregation note" should be `\paragraph{}` block not inline italic
- "Comfortably" hedge at L226 redundant
- Per-bandwidth grid TBD entries for T1/T3 (placeholders expected; flag for §5 P3 fill)
- SC2.5 negative wealth-tenancy correlation cited as load-bearing but flagged "placeholder" (`% FILL post-§5 P3`)
- Donut RDD / kernel choice unmentioned anywhere
- ... (remainder in per-lens reports)

---

## Per-lens scorecard

| Lens | Critical | Major | Minor | Score/10 |
|---|---|---|---|---|
| 1. Abstract audit | 0 | 4 | 4 | **7.5** |
| 2. Intro structure | 2 | 4 | 2 | **7.5** |
| 3. Methods / identification | 3 | 6 | 8 | **6.8** |
| 4. Results + tables | 2 | 6 | 4 | **6.5** |
| 5. Robustness | 3 | 5 | 3 | **6.8** |
| 6. Prose quality | 4 | 9 | 5 | **6.5** |
| 7. Citation audit | 0 | 2 | 5 | **8.5** |
| **TOTAL** | **14** | **36** | **31** | **7.16 (mean)** |

---

## Revision plan (in recommended order)

**Single-pass revision target: ~6–10 h to reach 8.5–9.0 / 10 (= 85–90/100 quality gate, AJAE first-submission ready).**

### Wave 1 — Bundled high-leverage edits (~2.5 h)

1. **X1 / X12 / X13 / X14 — Rewrite §3.4 falsification block (~45 min).** 3-item structure with stable "fires" semantics + one-sentence gloss. Mirror to §1 ¶2 footnote 2 + §B.3 trigger column. Closes 4 CRITICAL across 3 lenses.

2. **X2 — Fix `tab:appB-mapping` liquidity-gradient sign-direction leak (~15 min).** Replace rented-area cells with $A_{own}$ four-bin gradient numbers. Pure mechanical edit.

3. **X3 — Rename $\beta$ discount factor → $\delta$ + enforce $\hat\beta_k$ across 3 tables (~30 min).** `tab:notation` row 11, eq:CO-threshold L162, §B.1 derivation, and all 5 prediction-table rows.

4. **X11 — Hedge §3 + abstract italic "We reject" until §5 lock (~10 min).** "We test the AHM separability null" until results ship.

5. **X6 — Rewrite §1 ¶1 opening to question-first (~20 min).** Move institutional context to ¶2 opener.

6. **X7 — Promote ADR-0001/0002 pre-spec to §1 main-text sentence (~10 min).** Mirror from footnote.

### Wave 2 — Theory-credibility deepening (~2.5 h)

7. **X4 — Expand §B.1 Step 1 sign derivation (~45 min).** Replace "(other terms)" placeholder with full Hessian-determinant denominator. Explicit $(\lambda_1/\lambda_2)$ vs $R$ wedge case analysis or new SC.

8. **X5 — Strengthen SC2.5 → Step 3 derivation (~60 min).** Two options: (a) stochastic-dominance strengthening of SC2.5, OR (b) recast Step 3 as four-bin discrete claims (cheaper, recommended). Update F1 falsification correspondingly.

9. **X8 — Add anticipation-effects pre-emption to §3.1 (~30 min).** 2–3 sentences in "Estimand and pre-period inference" paragraph.

10. **X9 — Add McCrary density framing to §3.1 (~10 min).** One sentence.

### Wave 3 — Empirical-side gaps (~1.5 h)

11. **X10 — Add §4 FHES attrition note (~30 min).** 18,070 expected vs 14,474 actual; differential-attrition pre-test plan.

12. **Lens 1 MAJORs — Abstract upgrade (~45 min).** Quantify magnitude (−11.1% rent pass-through, +1,089 m² area_own); surface "first per-farm flat-rate cutoff AHM test" contribution; name EK supervision channel; question-first sentence.

13. **Lens 2 MAJORs — Intro polish (~30 min).** Split ¶6 into contribution + roadmap; fix stray `\ ` L65; drop "Preliminary"/"forthcoming"; reorder ¶2 to context-first.

### Wave 4 — Polish (~1 h)

14. **Lens 3 MAJORs (M1–M6) — Methods tightening (~45 min).** Pop/individual estimand language, 50% LTV cite, HonestDiD $\bar M^*$ commit, EK-1 cancellation tightening, R-conventions §10 ref or remove, SC4 MDE.

15. **Lens 4 MAJORs — Table polish (~30 min).** Missing `tab:notation` symbols, magnitude interpretation in captions.

16. **Lens 5 MAJORs (M1–M5) — Robustness pre-emption (~30 min).** 7.7% non-taker, lower-τ sensitivity, multiple-testing family declaration.

17. **Lens 6 sentence-length copyedit (~45 min).** Split 30+ long sentences. Convert "Aggregation note" to `\paragraph{}`. Trim hedges.

18. **Lens 7 — Baldoni-Ciaian upper-bound clarification (~15 min, 3 in-text loci).** Add "(short-run 9–46%, long-run 11–55%)" qualifier.

**Total wall-clock:** ~7–8 h focused work. Bundle into 2 sessions: Wave 1+2 (~5 h, theory-side); Wave 3+4 (~2.5 h, empirical+polish).

---

## Contradictions between lenses

| Lens A | Says | Lens B | Says | Resolution |
|---|---|---|---|---|
| **2 (Intro)** | ¶6 is OVERLOADED — split into multiple paragraphs (MAJOR) | **1 (Abstract)** | Contribution claim MISSING from abstract — must be expanded (MAJOR M3) | No real contradiction. Abstract needs to gain the contribution sentence; §1 ¶6 needs to lose density. Different sections, opposite directions, both correct. |
| **5 (Robustness)** | F1/F2 asymmetry "well-articulated, rare in separability papers" (STRENGTH credit) | **3 (Methods)**, **6 (Prose)** | F1/F2 prose is broken (3 CRITICAL collectively) | Lens 5 evaluates the *concept* (F2 demote is the right call); Lens 3/6 evaluate the *prose execution* of the concept (broken in §3.4 description block). Both correct; X1 fix preserves the concept while fixing the prose. |
| **5 (Robustness)** | Pre-2018 anticipation effects unaddressed (CRITICAL C1) | **3 (Methods)** | §3.1 "Estimand and pre-period inference" already addresses ITT/post-2020 endogeneity (MAJOR but not CRITICAL) | Lens 3 audited what IS in the paragraph; Lens 5 audited what's MISSING. Both correct. Anticipation belongs in the same paragraph (X8 fix). |
| **4 (Results)** | `tab:appB-mapping` empirical fit cells are CRITICAL leak (C1) | **5 (Robustness)** | $\hat\beta_5$ ex-theory demotion structurally enforced (STRENGTH) | Different rows. C1 is the liquidity-gradient row; Lens 5 strength is the incidence (ex-theory) row at table bottom. Both correct. |
| **6 (Prose)** | Abstract italic "We reject" is OVERCLAIM (CRITICAL C1) | **1 (Abstract)** | Abstract rejection sentence is FACTUALLY correct against §3.5 (no CRITICAL) | Lens 1 audited factual claim-vs-body correspondence; Lens 6 audited tone-vs-results-readiness. §3 declares the test; §5 delivers results. Until §5 ships, the rejection is a forward-looking claim, not a result. Lens 6's tense-control flag is the binding constraint. |

No outright contradictions on substantive findings. The five surface contradictions all dissolve under "different lens, different criterion, same paper" decomposition.

---

## Submission-readiness verdict

| Stage | Required score | Current | Gap |
|---|---|---|---|
| Commit (per CLAUDE.md `/commit` skill) | 80/100 | 71.6/100 | −8.4 |
| First submission (AJAE) | 90/100 | 71.6/100 | −18.4 |
| R&R response | 95/100 | 71.6/100 | −23.4 |

**Recommendation:** **Do not submit to AJAE yet.** Execute Wave 1+2 (~5 h) to clear all 14 CRITICAL → expected post-Wave-2 score: 8.3–8.5 / 10. Execute Wave 3+4 (~2.5 h) to clear the highest-leverage MAJORs → expected post-Wave-4 score: 8.7–9.1 / 10 → AJAE-submission threshold reached. Then ship §5 Results + §6 Identification + §7 Robustness + §8 Discussion + §9 Conclusion (separate work stream).

**The α3 framework + B.1 honest-reframe survive the integration audit.** No fundamental redesign required. All 14 CRITICAL are presentation, prose, derivation-tightening, or pre-emption fixes — every one closable without re-deriving the model or re-running data.

**Updated AJAE acceptance probability (post-Wave-4 hypothetical):** 70–78% (up from 65–72% pre-7-pass-review baseline). The +5pp narrows the variance band — the integration audit caught 14 CRITICALs that would have shipped under a single-pass `/review-paper` and become R&R-binding.

---

## Token / time accounting

| Phase | Wall-clock | Tokens |
|---|---|---|
| Phase 0 — Pre-flight | ~1 min | — |
| Phase 1 — 7 lens subagents (parallel) | ~3 min wall-clock | Lens 1: 67k, Lens 2: 47k, Lens 3: 97k, Lens 4: 73k, Lens 5: 75k, Lens 6: 78k, Lens 7: 101k. **Total: ~539k tokens** |
| Phase 2 — Synthesis | ~5 min | (this file) |
| **Total** | **~9 min wall-clock; ~540k agent tokens** | (vs ~15k for single-pass `/review-paper` — 36× more tokens, but 7× lens coverage + integration drift detection) |

---

## Per-lens reports

```
quality_reports/seven_pass_main/
├── lens_1_abstract.md       — 7.5/10, 0 CRITICAL, 4 MAJOR
├── lens_2_intro.md          — 7.5/10, 2 CRITICAL, 4 MAJOR
├── lens_3_methods.md        — 6.8/10, 3 CRITICAL, 6 MAJOR  ⚠ AJAE-bind
├── lens_4_results.md        — 6.5/10, 2 CRITICAL, 6 MAJOR  ⚠ tab:appB-mapping leak
├── lens_5_robustness.md     — 6.8/10, 3 CRITICAL, 5 MAJOR  ⚠ anticipation+attrition
├── lens_6_prose.md          — 6.5/10, 4 CRITICAL, 9 MAJOR  ⚠ F1/F2 prose
├── lens_7_citations.md      — 8.5/10, 0 CRITICAL, 2 MAJOR  ✓ structurally clean
└── _SYNTHESIS.md            — (this file)
```
