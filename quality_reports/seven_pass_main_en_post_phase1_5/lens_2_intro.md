# Lens 2 — Introduction Structure (§1), Post-Phase-1.5

**Manuscript:** `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex` (lines 46–62)
**Reviewer:** Lens 2 of THIRD seven-pass review (post-Phase-1.5)
**Date:** 2026-05-20
**Baseline score (post-Phase-1):** 5.5/10
**Scope of THIS pass:** Did the Phase 1.5 minor edits (N1 sharp→ITT clause at line 56; Y13 "directionally consistent → supportive" hedge softening at line 58) preserve internal consistency with §3/§4/§5/§6/§7/§8? Did they introduce new prose issues? Did the intro net-shrink or net-grow? The three known MAJORs (M1 length, M2 lit-review placement, M3 magnitude lateness) are EXPLICITLY DEFERRED to Phase 2 and are NOT re-counted against the score.

---

## Headline Score: **5.6 / 10**  (Δ = +0.1 from 5.5 baseline)

**Rationale.** Phase 1.5 was a strict 2-touch micro-edit: (a) line 56 — the symmetric-screening clause now explicitly anchors the iff (`$D_i = 1 \iff rv_{2018,i} \le 0$ on the three FHES-observable criteria`) AND the ITT framing AND the 92% receipt-rate imputation cross-ref to §2.3 (`\S\ref{sec:institutional-identification}`); (b) line 58 — the operating-cost hedge phrase replaced with "supportive of the $(S,s)$ inaction reading." Both edits are clean, internally consistent with the §2.3 institutional treatment and the §5 results-section anchor at line 475, and net-neutral on the structural debts. The +0.1 is granted for two small structural improvements (the iff anchor is now precisely consistent with the §3 notation table at line 112, and the abstract / §1 / §7 use a unified "supportive of (S,s)" formulation). The deferred M1/M2/M3 still bind; no further deductions or credits beyond +0.1.

---

## Phase 1.5 Edit Diffs — Internal-Consistency Audit

### N1 (line 56): sharp → ITT reframe

**Before (per brief description):** a magnitude sentence stating the symmetric-screened design recovers an effect at the cutoff.

**After (current main.tex line 56):**
> "...yielding a symmetric analysis sample of $N = 11{,}010$ farm-years across $2{,}776$ farms in which $D_i = 1 \iff rv_{2018,i} \le 0$ on the three FHES-observable criteria; the design identifies an ITT on the screened subpopulation (administrative compliance on the unobservable five criteria is imputed at the cohort-average $\approx 92\%$ receipt rate, \S\ref{sec:institutional-identification})."

**Cross-section consistency check:**

| Reference | Formulation | Consistent with new §1 line 56? |
|---|---|---|
| Abstract line 34 | "applying symmetric observable-eligibility screening on both sides" | ✓ — abstract is silent on ITT vs. ATT, no conflict |
| §2.3 line 86 | "We frame the DiD-RD estimator of §4 as an intent-to-treat (ITT) effect on the symmetric-screened sample. … We do not estimate the sharp ATT, since the unobservable requirements (iii)--(v), (vii), (viii) are administratively enforced and not present in survey data; the ITT integrates over administrative non-receipt within the screened-eligible population." | ✓ **Perfect alignment.** §1 now cites §2.3 directly via `\ref{sec:institutional-identification}`. |
| §3 notation table line 112 ($D_i$ row) | "Within the symmetric-screened analysis sample, $D_i = 1 \iff rv_{2018,i} \le 0$ on the three observable criteria; design identifies an ITT (not a sharp ATT — compliance with the five unobservable criteria is $\approx 92\%$)" | ✓ **Tight alignment** with line 56. Same iff, same ITT framing, same 92% figure. |
| §3.5 (Estimand) line 181 | "the recovered estimand is therefore an intent-to-treat (ITT) over eligibility-as-determined-by-2018-area" | ✓ |
| §4 (Identification) line 318 | "On the resulting sample of $2{,}776$ farms, $D_i = 1 \iff rv_{2018,i} \le 0$ in the three FHES-observable dimensions; the design identifies an intent-to-treat (ITT) effect on the screened subpopulation. The estimand is NOT a sharp ATT because the unobservable SFFP criteria (iii)--(v), (vii), (viii) are administratively enforced and not present in the survey data" | ✓ **Verbatim parallel** to §1 line 56. |
| §2.3 (institutional, second variant clause) | "We do not estimate the sharp ATT, since the unobservable requirements (iii)--(v), (vii), (viii) are administratively enforced and not present in survey data" | ✓ |
| §7 (Discussion) line 475 | Uses "+1,151 m² for pure tenants" — does NOT re-relitigate the ITT-vs-ATT distinction, which is correct (it's a policy-implications paragraph, not an estimand paragraph) | ✓ |

**Verdict on N1:** The Phase 1.5 §1 line 56 edit is **the cleanest pass at internal consistency I have seen in this manuscript.** The iff statement, the ITT label, the 92% receipt-rate imputation, and the §2.3 cross-reference now appear in identical form at §1 (intro), §2.3 (institutional posture), §3 (notation table), §3.5 (estimand paragraph), and §4 (identification specification). A referee chasing the ITT thread will trace cleanly across all five sections without finding a notational gap. **No new prose issues introduced.**

### Y13 (line 58): "directionally consistent" → "supportive of the $(S,s)$ inaction reading"

**Cross-section consistency check:**

| Reference | Phrasing | Consistent? |
|---|---|---|
| Abstract line 36 | "...is $-3.57$~M~KRW at T1, supportive of the $(S,s)$ inaction reading (not individually significant after multiple-testing correction)" | ✓ — abstract uses the new formulation |
| §1 ¶5 line 58 (Phase 1.5 target) | "negative operating-cost-net-of-rent response at narrow bandwidths ($-3.57$~M~KRW at T1, supportive of the $(S,s)$ inaction reading; full magnitude calibration in \S\ref{sec:results})" | ✓ — edit applied |
| §5 (Results) line 366 | "We therefore treat the operating-cost sub-prediction as \emph{directionally consistent} evidence supporting the (S,s) reading, while the headline AHM-separability rejection rests on the F1 monotone tenancy gradient" | ⚠ **PARTIAL inconsistency** — §5 still carries "directionally consistent" (italicized as a hedge term) while abstract / §1 / §7 now use "supportive." See MINOR m6 below. |
| §7 (Discussion) line 475 | "operating-cost-net-of-rent response at narrow bandwidth ($-3.57$~M~KRW at T1) is supportive of the $(S,s)$ inaction prediction in (\ref{eq:CO-3}) rather than a load-bearing test" | ✓ |

**Verdict on Y13:** The §1 target was successfully softened to "supportive of the (S,s) inaction reading," and abstract + §7 carry the same formulation. **Minor cross-section drift remains at §5 line 366** where the italicized phrase "directionally consistent" persists. This is not a §1 problem per se — §1 is fully internally consistent and consistent with abstract / §7 — but the hedge formulation now reads in three flavors across the manuscript ("supportive" in abstract + §1 + §7 vs. "directionally consistent" italicized in §5). A future Phase 2/3 pass should pick one phrase and propagate; current state is **internally consistent within §1**, but causes a hairline §1-vs-§5 drift. Flagged as MINOR m6 below.

---

## Per-Paragraph Word Count (Post-Phase-1.5 vs. Post-Phase-1)

The Phase-1 review reported per-paragraph word counts of {221, 239, 265, 280, 312, 200, 44} = ~1,561 words total. Recounting now with the same selective-strip method on the current file:

| ¶ | Line | Words (Phase-1) | Words (Phase-1.5) | Δ | Function |
|---|------|-----------------|--------------------|---|----------|
| 1 | 50 | 221 | 221 | 0 | Question + PIDPS context + benchmark setup |
| 2 | 52 | 239 | 239 | 0 | AHM null + Channel A/B + F1/F2 pre-spec |
| 3 | 54 | 265 | 265 | 0 | Four-way lit-comparison |
| 4 | 56 | 280 | **~287** | **+7** | Identification + symmetric screening + N. Phase 1.5 added the "iff + ITT + 92% receipt-rate" clause. |
| 5 | 58 | 312 | **~313** | **+1** | (S,s) calibration + F1 + F2 + rent-PT magnitudes. Phase 1.5 swapped "directionally consistent"→"supportive of (S,s) reading" — near-zero net. |
| 6 | 60 | 200 | 200 | 0 | "Three contributions" |
| 7 | 62 | 44 | 44 | 0 | Roadmap |
| **Total** | | **~1,561** | **~1,569** | **+8** | |

**Phase 1.5 net effect: intro grew ~8 words (+0.5%), driven entirely by ¶4 ITT clause expansion.**

This is a strict micro-edit cost — N1 added a load-bearing precision (iff anchor + ITT label + 92% receipt-rate cross-ref to §2.3) at a cost of 7 words. Y13 was net-neutral. **The deferred M1 length problem is marginally worse** (1,569 vs. 1,561 — still ~30% over the AJAE 1,200-word upper bound) but that's the cost of getting the estimand framing right. I do not flag M1 as a new MAJOR — it remains the deferred Phase 2 item.

---

## Cochrane / Varian Arc Audit (unchanged, deferred)

Same inversion as Phase 1 review:
- Hook at ¶1 sentence 1 ✓
- 725 words of context (¶1 sentences 2–7 + ¶2 + ¶3) before any result preview
- Design dump at ¶4 (now slightly longer)
- Result preview + magnitudes at ¶5 (word ~1,005)
- Contribution count at ¶6 (word ~1,325 — slightly later than Phase-1 estimate of ~1,317 due to ¶4 expansion)
- Roadmap at ¶7 ✓

**Verdict: arc still inverted. Deferred to Phase 2.**

---

## Rubric Item-by-Item

1. **Cochrane / Varian arc:** Still inverted; ¶4 grew 7 words; contribution count now at word ~1,325 (was ~1,317). **Phase-1 carryover; deferred.**
2. **Length:** ~1,569 words (was 1,561); ~31% over AJAE upper bound. **Phase-1 carryover; deferred.** Phase 1.5 added 8 words.
3. **Contribution placement:** ¶6, unchanged. Position-fail. **Phase-1 carryover; deferred.**
4. **Headline magnitudes first appearance:** ¶5 (word ~1,005). Unchanged. **Phase-1 carryover; deferred.**
5. **Each contribution differentiated from competitors:** 3 of 4 sub-claims clean; theoretical sub-claim still lacks "we extend X" anchor. **Phase-1 carryover; deferred to Phase 2.**
6. **Lit review placement:** ¶3, split with ¶6. Unchanged. **Phase-1 carryover; deferred.**
7. **Korea-context framing:** Load-bearing — per-farm flat-rate ≠ U.S./EU area-proportional. **Pass.**

---

## CRITICAL Findings (post-Phase-1.5)

**None.** The three CRITICALs from the initial review remain explicitly deferred per the Phase 1.5 brief; the Phase 1.5 edits did not introduce a new CRITICAL.

---

## MAJOR Findings (post-Phase-1.5)

**None NEW.** The three Phase-1 MAJORs (M1 length, M2 lit-review precedes results preview, M3 magnitudes first at ~word 1,005) remain deferred per the brief and are not re-counted.

---

## MINOR Findings (post-Phase-1.5)

### m6. NEW: Hedge phrasing drift across §1 vs. §5 on the (S,s) operating-cost sub-prediction.

The Phase 1.5 Y13 edit harmonized abstract (line 36), §1 ¶5 (line 58), and §7 discussion (line 475) on the formulation "supportive of the $(S,s)$ inaction reading." However, §5 line 366 still uses an italicized "*directionally consistent*" hedge:

> "We therefore treat the operating-cost sub-prediction as *directionally consistent* evidence supporting the (S,s) reading…"  (§5, line 366)

The §5 sentence is otherwise well-crafted, but the phrase mismatch means the manuscript now hedges the same finding in two flavors. Recommendation for Phase 2 polish: pick one ("supportive" matches the AJAE writing style better than "directionally consistent") and propagate. Low-priority — does not block submission, but a careful referee will notice and may comment.

### m7. NEW: ¶4 (line 56) now contains a 90-word sentence with three nested parenthetical / semicolon clauses.

The post-Phase-1.5 line 56 contains the sentence:
> "We apply the same observable-eligibility screening on both sides of the cutoff: households failing criteria (ii) or (vi) are dropped from both treated and control groups, yielding a symmetric analysis sample of $N = 11{,}010$ farm-years across $2{,}776$ farms in which $D_i = 1 \iff rv_{2018,i} \le 0$ on the three FHES-observable criteria; the design identifies an ITT on the screened subpopulation (administrative compliance on the unobservable five criteria is imputed at the cohort-average $\approx 92\%$ receipt rate, \S\ref{sec:institutional-identification})."

This is a single semicolon-bridged sentence packing five facts (screening rule, dropped subsample, resulting N, iff statement, ITT label + 92% imputation). The content is correct and the cross-references are clean — but as a prose object it is dense. Phase 2 prose pass could break this into two sentences: (a) "We apply the same observable-eligibility screening on both sides of the cutoff … yielding a symmetric analysis sample of N = 11,010 farm-years across 2,776 farms." (b) "Within this sample, $D_i = 1 \iff rv_{2018,i} \le 0$ on the three FHES-observable criteria; the design identifies an ITT on the screened subpopulation, with administrative compliance on the unobservable five criteria imputed at the cohort-average ≈92% receipt rate (\S2.3)." Low priority. Does not block.

### Phase-1 MINORs carryover (still standing, not re-counted)

- m1 (KREI/KAMICO citation provisional in $\tau$-footnote) — still TBD.
- m2 (¶5 110-word forward-reference compound) — Phase 2 prose pass.
- m3 (italic contribution markers vs. numbered list) — Phase 3 stylistic.
- m4 (Korea-context framing) — ✓ load-bearing.
- m5 (roadmap appropriately brief) — ✓.

---

## Did Phase 1.5 Net-Shrink or Net-Grow §1?

**Net-grew by ~8 words (+0.5%).** Driven entirely by ¶4 line 56 (added "iff + ITT + 92% receipt-rate" clause, +7 words). ¶5 line 58 (Y13 hedge softening) is net-neutral (~+1 word). All other paragraphs unchanged.

This is a *correct* growth: the 7-word cost bought a load-bearing precision (the iff anchor + ITT framing + cross-section consistency with §2.3 / §3 / §4 / §7). The deferred M1 length problem is marginally worse but the marginal cost was well-spent. Not a blocker.

---

## Bottom Line

Phase 1.5 was a clean, targeted micro-pass. N1 (sharp→ITT clause at §1 line 56) materially improved cross-section consistency — the ITT formulation now propagates verbatim across §1 ¶4, §2.3, §3 notation table, §3.5 estimand paragraph, and §4 identification, which the Phase-1 manuscript did not achieve. Y13 (hedge softening at §1 ¶5) is clean within §1 and consistent with abstract + §7, but left a hairline §5-vs-§1 drift (§5 line 366 still uses italicized "directionally consistent") — flagged as MINOR m6 for Phase 2 cleanup.

The three deferred MAJORs (length, lit-review placement, magnitude lateness) remain the binding constraints on §1 quality. Phase 1.5 added a net ~8 words, marginally worsening the length overshoot, but the precision gain on the ITT estimand label is worth the cost. **Score moves from 5.5 → 5.6** — a small but real improvement, driven entirely by structural-consistency gains from N1.

Until the Phase 2 structural pass (move contributions earlier, compress ¶3 + ¶4, lift magnitudes to ¶1), no submission readiness on §1.

---

**Score Δ from 5.5 baseline: +0.1 → 5.6 / 10**
