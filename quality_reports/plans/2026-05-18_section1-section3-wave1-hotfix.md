# Wave 1 hot-fix (6 CRITICAL bundle from 7-pass synthesis)

**Date:** 2026-05-18
**Branch:** `feat/section1-section3-wave1-hotfix` (new, off `main` @ `7372aa2`)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 2.5 h (synthesis estimate)
**Plan sister path (post-approval):** `quality_reports/plans/2026-05-18_section1-section3-wave1-hotfix.md`

---

## Context

The 7-pass adversarial review (2026-05-18 post-PR #7 merge, `quality_reports/seven_pass_main/_SYNTHESIS.md`) returned **REVISE-MAJOR** at composite **7.16 / 10**. 14 CRITICAL issues surface across 5 of 7 lenses, **mostly introduced or revealed by PR #7's structural changes** (F2 demotion prose, magnitude calibration §3.4.1, landscape grid in §B.3, SC2.5 primitive, notation table).

Wave 1 bundles the 6 highest-leverage CRITICAL fixes — all mechanical/prose, no re-derivation, no new data analysis. Expected post-Wave-1 score lift: **7.16 → ≈8.0** (clears 6 of 14 CRITICAL). Wave 2 (theory deepening: X4, X5, X8, X9) and Wave 3+4 (empirical+polish) will be separate PRs.

The α3 framework + B.1 honest-reframe survive the integration audit. **No fundamental redesign required.**

---

## The 6 CRITICAL items (Wave 1 bundle)

| ID | Title | Lens(es) | Time |
|----|-------|----------|------|
| **X1** | F1/F2 "fires" semantics 4× inversion — unify §3.4 description + §B.3 trigger column + §1 footnote 2 | 3 (C3), 6 (C2/C3/C4) | 45 min |
| **X2** | `tab:appB-mapping` Liquidity-gradient row: replace rented-area leak with $A_{own}$ values | 4 (C1) | 15 min |
| **X3** | $\beta$ symbol collision: rename discount-factor $\beta \to \delta$ + enforce $\hat\beta_k$ in tables | 4 (C2) | 30 min |
| **X11** | Hedge §3 + abstract italic "We reject AHM separability" until §5 results lock | 6 (C1) | 10 min |
| **X6** | Rewrite §1 ¶1 opening to question-first (Cochrane canon) | 2 (C1) | 20 min |
| **X7** | Promote ADR-0001/0002 pre-spec disclosure from §1 ¶2 footnote 2 to main-text sentence | 2 (C2) | 10 min |

**Total:** 130 min ≈ 2 h 10 min (matches 2.5 h budget with buffer).

---

## Critical files to modify

| File | Edits |
|------|-------|
| `paper/en/main.tex` | X1 (§3.4 L250–256), X3 (tab:notation L104 + §3.2 L160/L165), X11 (abstract L40 + §3.1 L119), X6 (§1 ¶1 L54 rewrite), X7 (§1 ¶2 L56 footnote → main text) |
| `paper/en/online_appendix.tex` | X2 (tab:appB-mapping L452), X1 (§B.3 trigger column at L452 parallel rewrite), X3 (§B.1 derivation any $\beta$ discount-factor occurrences) |
| `paper/ko/` | **UNTOUCHED** (CLAUDE.md bilingual rule) |

---

## Implementation order

Front-load **X1 highest-leverage** (4 CRITICAL closure), then mechanical fixes (X2 → X3), then §1 prose fixes (X11 → X6 → X7).

### Phase 1 — X1: F1/F2 falsification semantics unification (~45 min, highest leverage)

**Problem.** §3.4 description block (L250–256) has 5 items with overlapping F1 labels — `[F1]`, `[F1 (load-bearing)]`, `[F1 not fired + F2 null]`, `[F1 fires]` — where "F1" is defined twice and "fires" semantics invert mid-list. §B.3 trigger column at online_appendix.tex L452 says "F1 fires if $\hat\beta_2 \le 0$ at T2 OR four-bin point estimates fail monotone-in-(1-$s_{0,i}$) ordering at T1 AND T2"; Operational column says "F1 fires if $p(\hat\beta_2 > 0) > .10$ at T2 AND four-bin point estimates not weakly monotone-decreasing in $s_{0,i}$ at T1 OR T2 (Holm-corrected)" — different boolean structure (OR vs AND inverted). §1 ¶2 footnote 2 still references "F1+F2 pre-registration" (pre-A5 symmetric framing).

**Fix.** Rewrite §3.4 falsification block as 3 items (not 5) with stable "fires = trigger condition met = REJECTION of mechanism" semantics + add explicit operational decision rule mirroring §B.3.

**§3.4 falsification block (new structure):**
```
\paragraph{Pre-registered falsification.} We pre-specify two falsification predictions
under this AHM-extension framework. We use \emph{F fires} to denote the trigger
condition being met (i.e., the prediction is rejected by the data).

\begin{description}
\item[\textbf{F1 (load-bearing rejection trigger).}] Falsifies the wealth-biased
liquidity channel. F1 fires iff (i) $p(\hat\beta_2 > 0) > .10$ at T2 (the
heterogeneity interaction is statistically zero), AND (ii) the four-bin point
estimates of $\hat\beta_1$ across $s_{0,i} \in \{0, (0,.33], (.33,.67], 1\}$
fail to be weakly monotone in $(1 - s_{0,i})$ at T2. Rejection of F1 reframes
the paper's headline as a universal income effect under separability, abandoning
the wealth-bias hypothesis.

\item[\textbf{F2 (informative, not rejecting).}] Reports on the supervision-cost
channel. F2 fires iff $p(\hat\beta_4 \ne 0) > .10$ at all three bandwidths
(T1, T2, T3). The EK-1 sign is theoretically indeterminate ex ante (transfer
relaxes both family-time scarcity favoring more off-farm labor AND cash
constraint driving supervised hiring favoring less off-farm labor; cancellation
possible at the SFFP scale). A null $\hat\beta_4$ is therefore consistent with
either (i) the supervision wedge being slack at this scale or (ii) opposing
effects exactly canceling within the eligibility window. F2 is reported as
supporting evidence on the labor-imperfection margin; F2 alone neither rejects
nor confirms the AHM-separability test.

\item[\textbf{Joint test.}] F1 alone is rejection-bearing for the AHM-extension
framing. Three reading-outcomes:
\begin{enumerate}
\item \emph{F1 does not fire + F2 fires (modal):} wealth-biased liquidity channel
supported; supervision channel not detected at SFFP scale. The headline AHM-separability
rejection rests on F1.
\item \emph{F1 does not fire + F2 does not fire:} both channels supported. Both
non-separabilities operative; strongest reading.
\item \emph{F1 fires (regardless of F2):} wealth-biased liquidity channel not
supported. Reframe as a precise null estimate, complementing
\citet{LaFaveThomas2016_markets}'s developing-country rejection with a
developed-country null.
\end{enumerate}
\end{description}
```

**§B.3 tab:appB-mapping (online_appendix.tex L452 Liquidity-gradient row):**
- Unify Falsification trigger + Operational decision rule columns with the **strict-AND boolean** structure (more conservative falsification test):
  - Trigger: "F1 fires iff $\hat\beta_2 \le 0$ at T2 AND four-bin monotonicity broken at T2"
  - Operational: "F1 fires iff $p(\hat\beta_2 > 0) > .10$ at T2 AND $\hat\beta_1$ four-bin point estimates not weakly monotone in $(1-s_{0,i})$ at T2 (Holm-corrected across the two conditions)"

**§1 ¶2 footnote 2 (main.tex L56):** Update text from "the F1+F2 pre-registration" to "the F1 (load-bearing) + F2 (supporting) pre-specifications". Post-A5 framing now consistent.

---

### Phase 2 — X2: `tab:appB-mapping` Liquidity-gradient row sign-direction leak (~15 min)

**Problem.** online_appendix.tex L452 Liquidity-gradient row shows empirical-fit cells `{pure_tenant -1738; low_owner -600; mixed -393; pure_owner 0}` — these are RENTED-area decline numbers (CLAUDE.md channel ii), NOT the $A_{own}$ four-bin gradient (which is +1,089 / +410 / +393 / 0 ref at T2 per CLAUDE.md + main.tex L62 narrative). The row's outcome label is $A_{own} \times (1-s_{0,i})$, predicted sign $> 0$; current empirical cell contradicts its own predicted sign.

**Fix.** Replace L452 T2 empirical-fit cell with the correct $A_{own}$ four-bin gradient:
- Replace `T2 monotone across bins: \{ pure_tenant $-1738$; low_owner $-600$; mixed $-393$; pure_owner $0$ ref \}`
- With `T2 monotone across bins: \{ pure_tenant $+1{,}089$ ($p\!=\!.033$); low_owner $+410$ ($p\!=\!.051$); mixed $+393$ ($p\!=\!.063$); pure_owner $0$ ref \}; T1: TBD; T3: TBD`

The original RENTED-area numbers belong in a separate row (rent\_cost / rent_area channel) which is currently ex-theory (B.1 demoted) and may surface separately under unit_rent_price or rent_cost — leave that for Wave 3.

---

### Phase 3 — X3: $\beta$ symbol collision rename (~30 min)

**Problem.** `tab:notation` L104 defines $\beta$ as discount factor: "$\beta$ & Discount factor; permanent-income-equivalent shift via $T_i/(1-\beta)$". But `tab:alpha3-predictions` + `tab:appB-mapping` use $\beta_1, \beta_2, \beta_3, \beta_4, \beta_5$ as regression coefficients. The very THEORY-referee notation-drift critique that tab:notation was supposed to fix.

**Fix.**
1. **`tab:notation` L104** — rename row to: "$\delta$ & Discount factor; permanent-income-equivalent shift via $T_i/(1-\delta)$ & (\ref{eq:CO-threshold}) \\\\"
2. **eq:CO-threshold area (main.tex L160–165)** — replace $\beta$ → $\delta$ in:
   - eq:CO-threshold L160: `$W_i + T_i/(1-\delta) \ge W^*(\mathbf{p})$`
   - Prose at L165: "$\delta$ is the discount factor" and "lowering the effective threshold $W^*$ by the amount $T_i/(1-\delta)$"
3. **§B.1 derivation** — grep online_appendix.tex for $\beta$ occurrences in §B.1 (any context where it appears as discount factor in 2-period Lagrangian / Euler equation); replace with $\delta$.
4. **Enforce $\hat\beta_k$ (with hat) for estimators across all 3 tables:**
   - `tab:alpha3-predictions` L221+ — Econ. β column header + all 5 rows: $\beta_k \to \hat\beta_k$
   - `tab:appB-mapping` L444+ — Econ. β column header + all 5 rows: $\beta_k \to \hat\beta_k$
   - `tab:notation` — add note in caption: "Throughout, $\beta_k$ (no hat) denotes the population reduced-form coefficient and $\hat\beta_k$ (with hat) denotes the corresponding DiD-RD estimator from \S\ref{sec:identification}."

---

### Phase 4 — X11: Hedge "We reject AHM separability" until §5 lock (~10 min)

**Problem.** Abstract (main.tex L40) and §3.1 (L119) both carry `\textit{We reject AHM separability for Korean small farms.}` — overclaims pre-§5 lock. §5 Results is still a TODO placeholder; the rejection is currently a forward-looking claim, not a delivered result.

**Fix.**
1. **Abstract L40** — replace `\textit{We reject AHM separability for Korean small farms.}` with `\textit{We test the AHM separability null for Korean small farms.}%\n% UNHEDGE post-§5 P3 lock: if F1 not fired (β_2 monotone), restore "We reject ..." per ADR-0002.\n`
2. **§3.1 L119** — same surgical replacement at the corresponding location (end of §3.1 first paragraph).
3. **Add LaTeX comment line** at both locations marking the unhedge condition (line above the new text).

The hedge is loss-bearing for the headline; restore after §5 results stabilize (Wave 3 or post-§5 estimation).

---

### Phase 5 — X6: Rewrite §1 ¶1 opening to question-first (~20 min)

**Problem.** §1 ¶1 (L54) opens with "Korea's 2020 Public-Interest Direct Payment Scheme (PIDPS) marked the largest restructuring of Korean farm subsidies in two decades..." — institutional context first. Question buried in the last clause: "We ask whether the SFFP transfer alters smallholder farm behavior at the 0.5~ha cutoff—equivalently, whether the AHM separability null holds in this setting—and through which mechanism it fails if it does." Fails Cochrane/McCloskey first-sentence canon.

**Fix.** Minimal swap: move the question to the FIRST sentence; institutional context shifts to second sentence. Preserve the same factual content — only reorder.

**New ¶1 structure:**
```
Does the Agricultural Household Model's separability null hold for Korean
smallholders at the 0.5~ha cutoff of a per-farm flat-rate direct payment,
and through which mechanism does it fail if rejected? Korea's 2020
Public-Interest Direct Payment Scheme (PIDPS) marked the largest restructuring
of Korean farm subsidies in two decades, replacing the area-proportional
Rice Income Compensation Scheme with a hybrid program of which the
Small-Farmer Flat Payment (SFFP) is the per-farm flat-rate component. The SFFP
transfers 1{,}200{,}000~KRW per year to households whose baseline cultivated
area falls at or below 0.5~ha ($5{,}000$ m\textsuperscript{2}); ... [rest of
existing ¶1 preserved, including the SFFP-amount footnote, budget figures,
Article 10, and the Kirwan/Baldoni-Ciaian/Zimmert-Zorn anchor mentions]
... non-supranational direct-payment scheme \citep{ZimmertZorn2022_swissrd}.
[Delete the last "We ask whether..." question sentence — now redundant with
the new first sentence.]
```

---

### Phase 6 — X7: Promote ADR-0001/0002 pre-spec to §1 ¶2 main text (~10 min)

**Problem.** §1 ¶2 footnote 2 (at main.tex L56) reads: "The $\alpha$-strict theoretical scope (ADR-0001), the outcome hierarchy realignment (ADR-0002), and the F1+F2 pre-registration all predate \S\ref{sec:results} estimation under the present framing and are archived in the replication package." This is the EMPIRICAL referee's primary α3-alpha concern (auditable-surface pre-spec disclosure). Currently in footnote — visually deprioritized. AJAE DCAS v1.0 referees scan main text first.

**Fix.** Promote footnote to main-text closing sentence of §1 ¶2 (also updates the X14 stale F1+F2 phrasing):

**Append to end of §1 ¶2 (after the current footnote's location):**
```
Per the auditable-surface pre-specification posture, the $\alpha$-strict
theoretical scope (ADR-0001), the outcome hierarchy realignment (ADR-0002),
and the F1 (load-bearing) + F2 (supporting) pre-specifications all predate
\S\ref{sec:results} estimation under the present framing and are archived
in the replication package.
```

**Delete the existing footnote 2 (the redundant one).**

---

## Decisions locked (pre-implementation)

**Q1 — F1 boolean structure (strict AND vs loose OR):** **Strict AND** (more conservative falsification test). F1 fires iff BOTH β_2 statistically zero AND four-bin monotonicity broken at T2. Rationale: the wealth-bias channel is the load-bearing F1 hypothesis; a more conservative trigger (harder to fire) biases the test against premature rejection of wealth-bias. The OR variant currently in §B.3 trigger column is too permissive; replacing both columns with AND maintains internal consistency.

**Q2 — "We reject" hedge phrasing:** **"We test the AHM separability null for Korean small farms."** Parsimonious, present tense, identical sentence structure to the italic original. Restoration to "We reject..." planned post-§5 P3 lock (Wave 3).

**Q3 — X7 promotion approach:** **Pure promotion** (footnote → main text). Delete the footnote to avoid visual repetition. The promoted sentence carries the full ADR-0001/0002 + F1/F2 disclosure inline.

**Q4 — X6 ¶1 rewrite scope:** **Minimal swap** (move question to first sentence, institutional to second). Avoid wholesale ¶1 rewrite to keep diff scope-bounded.

---

## Verification (end-to-end)

1. **Compile:** `cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex` → exit 0, 19±1 p PDF (unchanged), no new undefined citations, no Korean glyph warnings.
2. **Compile online appendix:** `latexmk -xelatex online_appendix.tex` → exit 0, 8±1 p PDF, landscape renders OK.
3. **Cross-check tables:** `tab:notation`, `tab:alpha3-predictions`, `tab:appB-mapping` all use $\hat\beta_k$ for estimators; discount factor uses $\delta$ uniformly.
4. **F1/F2 consistency:** §3.4 falsification block 3 items (not 5); §B.3 trigger + operational columns parallel boolean structure (strict AND); §1 ¶2 footnote updated to "F1 (load-bearing) + F2 (supporting)".
5. **No `paper/ko/` diff:** `git diff main paper/ko/` empty.
6. **PR #7 file count preservation:** Bibliography_base.bib untouched (no new entries; Wave 1 is paper-only).
7. **Quality score expectation:** post-Wave-1 mean lens score 8.0±0.2 / 10 (= 78–82/100); not yet 90 (Wave 2+3+4 remain).

---

## What this Wave 1 hot-fix does NOT do (out of scope, deferred to Wave 2/3/4)

- **Wave 2 (theory deepening):** X4 §B.1 Step 1 sign hand-wave (λ wedge case analysis), X5 SC2.5 → Step 3 derivation gap (bimodal $s_0$ recast), X8 §3.1 anticipation effects, X9 §3.1 McCrary density framing
- **Wave 3 (empirical):** X10 §4 FHES attrition note, Lens 1 MAJORs (abstract magnitude), Lens 2 MAJORs (¶6 split + stray `\ ` L65 + "Preliminary" hedge drop)
- **Wave 4 (polish):** Lens 3/4/5/6 MAJORs (notation table missing symbols, sentence-length copyedit, Baldoni-Ciaian upper-bound clarification, missing AJAE method cites CCT/McCrary/CGM)
- §5 Results, §6 Identification, §7 Robustness, §8 Discussion, §9 Conclusion all remain TODO placeholders
