# Lens 1 — Abstract (Post-Phase-2, 5th Seven-Pass Review)

**Date:** 2026-05-20
**Manuscript:** `paper/en/main.tex` (506 lines)
**Abstract location:** lines 32–37
**Reviewer:** Lens 1 (abstract-focused)
**Baseline:** Phase 1.5b score 9.0/10 (no abstract edits in Phase 2)

---

## Score: **9.2 / 10** &nbsp;&nbsp; Δ from 9.0 baseline: **+0.2**

The abstract was not edited in Phase 2, but every numeric claim it carries was verified against the downstream sections that *were* edited. Net effect: all claims survive intact, and one previously soft phrase ("not individually significant after multiple-testing correction") now reads as *more* precise after §5.2 was tightened to spell out the Holm step-down on the op_cost_ex_rent T1 raw $p \approx .10$. Hence the modest +0.2 bump rather than a hold-at-9.0.

---

## Sanity Check: Phase-2 Downstream Breakage

| Abstract claim | Downstream source | Verified? |
|---|---|---|
| $N = 11{,}010$ farm-years, $2{,}776$ farms | §3.2 sample, §4 ($hh\_id$, 2,776 clusters, line 344), Table notation (line 111) | ✓ matches |
| symmetric observable-eligibility screening on both sides | §2.3 (line 86), §4 identification posture | ✓ matches |
| pure-tenant own-area $+1{,}151$ m² at T2, $p = .036$ | §5.1 (line 355), Intro ¶5 (line 58), §4 heterogeneity ¶ (line 342), §7.1 footnote (378), §6.1 (485), Conclusion (496), fuzzy-bin (393), wild bootstrap (410), HonestDiD (425) | ✓ 9 cross-locations agree |
| Four-bin gradient $+1{,}151 \to +438 \to +258 \to -52 \to 0$ | §5.1 (355), §7.1 footnote (378), §6.1 (485), Conclusion (496), Intro (58) | ✓ identical at all 5 sites |
| rent pass-through $-13.7\%$ at T1, $p<.10$ | §5.4 joint-test (372: $\hat\beta_5 = -164{,}927$), §6.2 (487), §4 SUTVA (348), Conclusion (496) | ✓ matches; §6.2 also reports $-11.7\%$ at T2 (consistent with abstract's T1 headline) |
| U.S. benchmark $+25\%$ Kirwan, EU $+46$–$55\%$ Baldoni-Ciaian | §1, §2.3 (line 88), §6.2 (487). Note §1 ¶3 reports BC range as "$9.1$–$55\%$" (long-run inclusive); abstract uses the short-run upper / long-run upper "$+46$–$55\%$." | ✓ matches §6.2 specifically; Intro range is wider but reconcilable (short-run vs. long-run upper bound) |
| op_cost_ex_rent $-3.57$ M KRW at T1, "not individually significant after multiple-testing correction" | §5.2 (366): "$-3.57$ M KRW at T1 (SE $2.19$M, raw $p \approx .10$; not significant after Holm step-down across the four-outcome primary family)" | ✓ exact match; abstract phrasing is conservative-correct |
| F1 (primary, monotone-in-tenancy gradient), F2 (auxiliary, hired-labor margin) | §3.4 predictions (289), §4.heterogeneity (342), §5.3 F2 result (370) | ✓ matches |
| Five-bin partition (abstract: "four non-pure-owner bins", $+1{,}151 \to \ldots \to 0$) | §3.3 (line 121: $\{0, (0,.33], (.33,.67], (.67,1), 1\}$); §3.4 (289) | ✓ consistent — pure_owner is the inframarginal zero reference, abstract lists the four non-pure-owner bin estimates plus the "$\to 0$" anchor. Phase-2 canonicalized this as 5-bin internally; the abstract's "four non-pure-owner bins" framing is *unchanged from baseline* and remains accurate |
| AHM separability rejection via wealth-biased liquidity, per-farm flat-rate severs landlord-capture | §5.5 headline (378), §6.2 (487), §7 Conclusion (496) | ✓ matches |

**Phase-2 changes scanned for collisions:**

- ✓ Wild bootstrap "B = 999 → B = 9,999" (§4, line 344; §6 wild bootstrap ¶ 410). Abstract does *not* mention bootstrap reps, so the upgrade is a non-event for the abstract.
- ✓ Intro restructure (¶3 "Versus X" compression; ¶4 §5-detail cut; ¶5 $\tau$ trim). Abstract↔Intro consistency reverified: every Intro magnitude in ¶5 (line 58) matches the abstract verbatim.
- ✓ §3 4-bin → 5-bin canonicalization. Abstract's "four non-pure-owner bins" language is the *output-display* version of the 5-bin partition (pure_owner is the anchor); the canonicalization is upstream of the abstract and does not require an abstract edit. No collision.
- ✓ Three new tables added in §5/§6/§7 (CCT, CJM, fuzzy-bin). None are cited in the abstract by construction; the abstract holds.

**Conclusion of sanity check:** Zero claims broken by Phase 2 downstream edits. The abstract's numerical scaffolding is now load-tested against more sources than at Phase 1.5b (9 cross-locations on the headline $+1{,}151$, vs. 5 in the Phase 1.5b draft state).

---

## Word Count

- Body of `\begin{abstract}` ... `\end{abstract}`: **213 words**
- AJAE limit: 250 words (per AJAE author guidelines)
- Headroom: 37 words (15% spare capacity)
- *Status:* well within budget; no risk of overflow.

---

## Rubric Deductions (Quality Gates — paper/en/**/*.tex)

| Severity | Issue | Deduction | Applies? |
|---|---|---|---|
| Critical | XeLaTeX compile failure | -100 | No |
| Critical | Undefined citation in abstract | -15 | No (all four cites — Kirwan2009, BaldoniCiaian2023, CarterOlinto2003, EswaranKotwal1986 — resolve in `Bibliography_base.bib`) |
| Critical | Korean policy citation error (date / amount / statute) | -15 | No (2020 launch, 1.2M KRW, 0.5 ha cutoff — all match Phase-1 verified glossary) |
| Critical | Korean-style citation leak | -15 | No (\citep style throughout) |
| Major | Numeric claim inconsistent with `_outputs/*.rds` | -10 | No (all nine locations agree internally; cross-artifact `/audit-reproducibility` already PASSed at Phase 1.5b on these cells) |
| Major | Weighting decision unjustified | -10 | N/A (abstract does not mention weighting) |
| Minor | Notation inconsistency across sections | -3 | No (abstract uses `\mathrm{m^2}` superscript convention consistent with §3 notation table) |
| Minor | Korean phrasing leak into English | -3 | No |

**Net deductions: 0.** Score derived from positive criteria below.

---

## What the Abstract Does Well (justifies 9.2)

1. **Lead with policy distinctiveness, not magnitude.** Sentence 1 frames the per-farm flat-rate as the institutional novelty against U.S./EU area-proportional benchmarks. This is the AJAE editor's hook (Lens 5 desk-review concern: "why should an AJAE editor care about Korea?").

2. **Two falsifiable predictions named explicitly (F1 primary, F2 auxiliary).** Pre-specification visibility on the first read; aligns with `replication-protocol.md` Phase 1 contract.

3. **Headline result is a gradient, not a coefficient.** "$+1{,}151 \to +438 \to +258 \to -52 \to 0$" carries more diagnostic content than a single ATT — protects against single-bin specification charges in referee review.

4. **Honest about op_cost significance.** "Not individually significant after multiple-testing correction" — the phrase is conservative-correct, matches §5.2's exact Holm step-down language, and pre-empts a referee asking "what about the p-value?"

5. **Incidence reversal stated as the second-tier finding, not the headline.** The $-13.7\%$ is positioned as a reduced-form reversal of Kirwan/Baldoni-Ciaian; the headline is the AHM separability rejection. This sequencing matches the §3.4 prediction hierarchy and the §6 discussion structure.

6. **Closing sentence is a policy-mechanism claim.** "Per-farm flat-rate payment design itself is the policy lever that severs the per-acre landlord-capture channel" — gives the editor a one-sentence quotable summary.

---

## What Could Push to 9.5+ (Optional, NOT Phase-3 Required)

These are pure polish — *not* deductions:

- **(O1, +0.1 if applied)** "$N = 11{,}010$ farm-years, $2{,}776$ farms" — consider adding "(symmetric observable-eligibility-screened panel)" parenthetical. Currently spelled out in the next clause ("applying symmetric observable-eligibility screening on both sides") but a more compact form would let a skimmer grasp the sample design without parsing the post-comma clause. *Trade-off:* costs ~6 words. Not worth it at 213/250.

- **(O2, +0.1 if applied)** F2 sentence — abstract says implicit-labor supervision "predicts a hired-labor margin response." §5.3 reports F2 is *null* (pooled $\hat\beta_4$ statistically near zero). The abstract states the prediction but does not state the *outcome* on F2. A referee could ask "did F2 fire?" The current phrasing is defensible — F2 is auxiliary and non-rejection-bearing — but a sentence like "F2 yields a null pooled hired-labor response, consistent with the EK sign-indeterminacy disclosure" would close the loop. *Trade-off:* costs ~15 words; could pair with a 5-word tightening elsewhere. Not Phase-3 mandatory.

- **(O3, +0.05 if applied)** "pass-through is $-13.7\%$ at T1 ($p < .10$)" — the `$p < .10$` is statistically softer than "$p = .036$" used immediately before. Consider reporting the exact $p$ if available (§5.4 reports $\hat\beta_5 = -164{,}927$, $p < .10$; if `_outputs/` has an exact value, swap it in). Defensible as-is.

None of O1–O3 are required for AJAE submission. The abstract is submission-ready at 9.2.

---

## Bottom Line

- **Score:** 9.2 / 10
- **Δ from 9.0 baseline:** +0.2 (downstream-Phase-2 tightening of §5.2 retroactively strengthens the abstract's "not individually significant after multiple-testing correction" framing; no other change).
- **Sanity check:** 0 abstract claims broken by Phase-2 edits. 9 cross-locations on the headline $+1{,}151$ all agree.
- **Word count:** 213 / 250 (37-word headroom).
- **Submission-readiness:** Submission-ready for AJAE. O1–O3 polish is optional, not required.
