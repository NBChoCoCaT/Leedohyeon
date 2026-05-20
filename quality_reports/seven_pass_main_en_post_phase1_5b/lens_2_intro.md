# Lens 2 — Introduction (§1), Post-Phase-1.5b Sanity Check

**Manuscript:** `/Users/leedo/Research/01_dissertation_PBDP/paper/en/main.tex` (lines 46–62)
**Reviewer:** Lens 2 of FOURTH seven-pass review (post-Phase-1.5b)
**Date:** 2026-05-20
**Baseline score (Phase-1.5 review):** 5.6 / 10
**Scope of THIS pass:** Per brief — Phase 1.5b made NO intro changes. Verify §1 prose is byte-identical to the Phase-1.5 baseline, confirm score carries forward, note Phase 2 deferrals still bind.

---

## Headline Score: **5.6 / 10** (Δ = 0.0 from Phase-1.5 baseline)

---

## Sanity Check: Did §1 change between Phase-1.5 and Phase-1.5b?

**Verdict: NO. §1 is byte-identical to the Phase-1.5 baseline.**

The three commits comprising Phase 1.5b touched only §3+, §4, and figure captions:

| Commit | Subject | §1 touched? |
|---|---|---|
| `792701c` | wave8 editorial — ADR/jargon removal, section restructure, STATA log cleanup | Note: wave8 editorial pass is the Phase-1.5 baseline that lens_2 Phase-1.5 already evaluated; §1 content the same |
| `36f067d` | wave8 overfull hbox fixes | No (changes localized to hunks starting at line 202+) |
| `fed8037` | wave8 inline Table 1 descriptives into §4 + escape underscores | No (§4 only — lines 314+) |
| `9b2ee58` | wave8 regenerate figures with sanitized captions | No (PDF binary regen only) |

Verification via `git diff 792701c..HEAD -- paper/en/main.tex`: all 7 hunks target line 202 onward (§3 Theory, §4 Data, §5 Empirical Strategy). The §1 line range (46–62) is untouched.

Spot-check on the two Phase-1.5 edit anchors:

| Phase-1.5 anchor | Current state at HEAD | Match? |
|---|---|---|
| §1 line 56: `$D_i = 1 \iff rv_{2018,i} \le 0$ on the three FHES-observable criteria; the design identifies an ITT on the screened subpopulation (administrative compliance on the unobservable five criteria is imputed at the cohort-average $\approx 92\%$ receipt rate, \S\ref{sec:institutional-identification})` | Verbatim present at current line 56 | ✓ |
| §1 line 58: `supportive of the $(S,s)$ inaction reading; full magnitude calibration in \S\ref{sec:results}` | Verbatim present at current line 58 | ✓ |

Both N1 (sharp→ITT clause) and Y13 ("supportive of (S,s)" hedge) edits are preserved as expected.

---

## Phase-1.5 Findings: Carryover Status

### CRITICAL findings: None new, none introduced.

### MAJOR deferrals (still bind, NOT recounted)

| Code | Issue | Status |
|---|---|---|
| **M1** | §1 length ~1,569 words (~31% over AJAE ~1,200 upper bound) | **Deferred to Phase 2** |
| **M2** | Lit-review (¶3) placed before identification preview (¶4) and magnitude preview (¶5) — Cochrane/Varian arc inversion | **Deferred to Phase 2** |
| **M3** | Headline magnitudes first appear at ¶5 (word ~1,005), not at hook | **Deferred to Phase 2** |

### MINOR findings carryover

- **m6** (§1/§5 hedge drift — "supportive" vs. italicized "directionally consistent"): unchanged. §5 line 366 still carries the italicized hedge. Not blocking, Phase 2 polish item.
- **m7** (§1 ¶4 line 56 dense 90-word semicolon-bridged sentence): unchanged.
- **m1–m5** Phase-1 carryover MINORs: unchanged.

No new MINOR issues introduced by Phase 1.5b (because Phase 1.5b did not touch §1).

---

## Cross-Section Consistency Re-Audit (lite)

Phase 1.5 verified that §1 line 56's ITT formulation propagates verbatim across §1 ¶4, §2.3, §3 notation table, §3.5 estimand paragraph, §4 identification. Phase 1.5b's edits to §3 (lines 202, 267) and §4 (lines 314+, 325+, 362+, 382+, 420+) preserve the cross-section consistency: the wave8 changes are localized prose polish (replacing `Online Appendix \S B.1 Step 2 aggregation` → `Online Appendix \S B.1, aggregation step`; `SC2.5` → `regularity condition C5`; the Table 1 inline) and do not touch the ITT clauses, the $D_i = 1 \iff rv_{2018,i} \le 0$ definition, or the four-bin partition rule. The §1↔§2.3↔§3↔§4 ITT chain remains tight.

The §1↔§5 hedge drift (m6) likewise persists: §5 line 366 was not on the wave8 editorial pass's revision list and still carries the italicized "directionally consistent" phrase.

---

## Bottom Line

Phase 1.5b was a §3/§4/figure-caption pass with zero §1 modifications. The Phase-1.5 §1 score of **5.6/10** carries forward unchanged. The three deferred MAJORs (M1 length, M2 arc inversion, M3 magnitude lateness) remain the binding constraints on §1 quality and are explicitly Phase 2 work per the brief. The hairline §1↔§5 hedge drift (m6) flagged in Phase 1.5 remains.

No new §1 issues introduced by Phase 1.5b. No reasons to revise the score up or down.

---

**Score: 5.6 / 10** (unchanged; Phase 2 deferrals carry forward)
