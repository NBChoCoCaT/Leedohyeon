# Wave 2 hot-fix — theory deepening (4 CRITICAL from 7-pass synthesis)

**Date:** 2026-05-18
**Branch:** `feat/section1-section3-wave2-hotfix` (new, off `main` @ `79d37a8` post-Wave-1 + QS-1)
**Target PR:** single commit, single PR, merge to `main`
**Time budget:** 2.5 h (synthesis estimate)

---

## Context

Per the 7-pass synthesis (`quality_reports/seven_pass_main/_SYNTHESIS.md`), Wave 2 closes the **4 theory-credibility CRITICALs** that AJAE referees will hit hardest. After Wave 1 (PR #8, 6 CRITICAL closed) and QS-1 fix (PR #9, quality-gate restored), the manuscript sits at composite **≈8.0/10**. Wave 2 lifts to **≈8.5/10** by tightening §B.1 derivations (X4 + X5) and pre-empting two §3.1 robustness threats (X8 + X9).

**All edits remain in §3.1 + §B.1 + adjacent main-text equations.** No re-derivation of theorems, no new SCs introduced beyond clarifying existing ones, no changes to §1 Intro / Abstract / §5+ stubs. The Carter-Olinto theoretical core is preserved; X4 expands a hand-waved Step 1 sign argument; X5 recasts the bimodal-$s_0$ Step 3 from continuous-density to four-bin discrete claims (already aligned with the Wave 1 X1 falsification framing).

---

## The 4 CRITICAL items

| ID | Title | Lens | Time |
|----|-------|------|------|
| **X5** | Recast §B.1 Step 3 from continuous-density to four-bin discrete claims (resolves SC2.5 → ∂φ/∂s₀ ≤ 0 gap under bimodal s₀); FOSD footnote per Q2 hybrid | 3 (C2) | 75 min |
| **X4** | §B.1 Step 1 sign hand-wave: expand "(other terms)" denominator, add explicit case analysis of (λ₁/λ₂ vs R) wedge | 3 (C1) | 45 min |
| **X8** | §3.1 anticipation effects pre-emption: 2–3 sentences in "Estimand and pre-period inference" paragraph on PIDPS announcement timeline vs 2018 baseline | 5 (C1) | 30 min |
| **X9** | §3.1 McCrary density framing: 1 sentence on cutoff-density continuity test (forward-ref §7 stub +0.7pp result) | 5 (C2) | 10 min |

**Total:** 160 min ≈ 2 h 40 min (slightly over 2.5 h budget; FOSD footnote +15 min).

---

## Critical files to modify

| File | Edits |
|------|-------|
| `paper/en/online_appendix.tex` | X4 §B.1 Step 1 (L163–171); X5 §B.1 Step 3 (L189–202) + SC2.5 (L263–274) |
| `paper/en/main.tex` | X5 §3.2 eq:CO-2 + surrounding prose (L182–184); X8 + X9 §3.1 "Estimand and pre-period inference" paragraph (L155) |
| `paper/ko/` | **UNTOUCHED** (CLAUDE.md bilingual rule) |

---

## Implementation order

Front-load **X5 (highest theory-credibility leverage)**, then **X4** (chained to X5's recast since both affect §B.1 derivation chain), then **X8 + X9** (§3.1 prose). Compile after X5+X4 (theory-block coherence check), then again after X8+X9 (final).

### Phase 1 — X5: Recast Step 3 to four-bin discrete + FOSD footnote (~75 min, highest leverage)

**Problem.** Current Step 3 (online_appendix.tex L189–202) asserts $\partial \varphi(W^*)/\partial s_{0,i} \le 0$ via the SC2.5 primitive $\text{Cov}(W_i, s_{0,i}) < 0$. This implication does **not** follow under the bimodal $s_0$ distribution (CLAUDE.md notes 52% pure-owner + 12% pure-tenant + 36% mixed). Continuous monotone-density argument breaks; F1 falsification rests on this stipulated monotonicity.

**Fix.** Three-step recast:

1. **Replace SC2.5** (L263–274) with a **four-bin threshold-density primitive**:
   - New SC2.5: "Within the eligibility window $rv_{2018} \in [-h, +h]$, the four-bin baseline-tenancy partition $\{s_0=0, s_0\in(0,.33], s_0\in(.33,.67], s_0=1\}$ exhibits a weakly monotone-decreasing sub-threshold mass: $\Pr(W_i < W_i^* \mid s_{0,i} = 0) \ge \Pr(W_i < W_i^* \mid s_{0,i} \in (0, .33]) \ge \Pr(W_i < W_i^* \mid s_{0,i} \in (.33, .67]) > \Pr(W_i < W_i^* \mid s_{0,i} = 1) = 0$. Pure owner-operators are inframarginal by construction (their wealth has already exceeded $W^*$ at baseline)."
   - **FOSD footnote on SC2.5:** "The four-bin sub-threshold-mass primitive is a strict implication of the stronger first-order stochastic-dominance condition $F(W_i \mid s_{0,i} = 0) \succeq_{FOSD} F(W_i \mid s_{0,i} \in (0, .33]) \succeq_{FOSD} F(W_i \mid s_{0,i} \in (.33, .67]) \succeq_{FOSD} F(W_i \mid s_{0,i} = 1)$ within the eligibility window. We adopt the four-bin form as the primary primitive because it is the form the empirical falsification F1 in \S\ref{sec:predictions} actually tests; the FOSD form is the natural theoretical strengthening that a theory referee may prefer, and the derivations below are robust to either statement."
   - Empirical support: same FHES Wave 1 placeholder line (`% FILL post-§5 P3 run`), now reporting the four-bin sub-threshold-mass shares instead of $\text{corr}(W_i, s_{0,i})$.

2. **Rewrite §B.1 Step 3 derivation** (L189–202):
   - Drop the continuous-density mixed-partial form.
   - New form: discrete bin-wise crossing probability $\Delta P_b \equiv \Pr(\text{cross from rent to own} \mid s_{0,i} \in \text{bin } b)$ for $b \in \{\text{pure tenant, low-owner, mixed, pure owner}\}$.
   - Under SC2.5 (new): $\Delta P_{\text{pure tenant}} \ge \Delta P_{\text{low-owner}} \ge \Delta P_{\text{mixed}} > \Delta P_{\text{pure owner}} = 0$.
   - Aggregated $A_{own}$ response: $\Delta A_{own, b} = \bar a \cdot \Delta P_b > 0$ for the three non-pure-owner bins, decreasing in $s_0$ bin index.
   - Boxed eq:appB-step3 (NEW form):
     $$\boxed{\Delta A_{own, b} > \Delta A_{own, b'} > 0 \text{ for } b \prec b' \text{ in the partition order, with } \Delta A_{own, \text{pure owner}} = 0.}$$
   - One-sentence closer: "This four-bin discrete monotonicity is the empirical signature uniquely diagnostic of wealth-biased liquidity; under separability or universal-income-effect, $\Delta A_{own, b}$ would be uniform across bins. The continuous monotone-density version of this claim ($\partial \varphi(W^*)/\partial s_0 \le 0$) does not survive bimodal $s_{0,i}$ distributions and is not load-bearing here."

3. **Update main-text eq:CO-2** (main.tex L182–184) to four-bin form:
   - Current: $\partial^2 A_{own,i}/\partial T_{SFFP}\, \partial(1-s_{0,i}) > 0$ (continuous mixed partial).
   - New: $\Delta A_{own, b} > \Delta A_{own, b'} > 0$ for $b \prec b'$ in the partition order (same boxed form as eq:appB-step3).
   - Surrounding prose (L181–184): adjust to four-bin language; preserve the "monotone-in-baseline-tenancy" intuition phrasing.
   - Update `tab:alpha3-predictions` Reduced form column for the Liquidity gradient row: from `$\partial^2/\partial T_{SFFP}\, \partial(1-s_{0,i}) > 0$` to a compact four-bin notation, e.g., `$\Delta A_{own, b}$ mono decreasing in $s_{0,b}$`.

**Note: F1 trigger in §3.4 (Wave 1) already uses four-bin form** — aligns automatically. §B.3 trigger column (Wave 1) also already four-bin — aligns automatically.

### Phase 2 — X4: §B.1 Step 1 sign hand-wave expansion (~45 min)

**Problem.** Step 1 (L163–171) derivation of $\partial W^*/\partial T_i < 0$ uses "(other terms)" placeholder in the denominator (L167). The numerator-factor $(R - \lambda_1/\lambda_2)$ flips sign depending on whether the period-1 credit constraint binds ($\lambda_1/\lambda_2 > R$ in the constrained regime). Lens 3 C1: sign-by-assertion as currently written; AJAE theory referee will catch.

**Fix.** Three-part expansion:

1. **Expand the denominator** in eq:appB-step1 (L167) from `(other terms)` to the full Hessian-determinant form. The implicit function theorem applied to (eq:appB-threshold) gives:
   - Define $G(W, T) \equiv$ LHS − RHS of (eq:appB-threshold).
   - Then $\partial W^*/\partial T_i = -G_T(W^*, T_i)/G_W(W^*, T_i)$.
   - Expand $G_T$ and $G_W$ explicitly using $\rho'(W^* + T)$ and the wedge factor.
   - The denominator is $G_W$, which under SC1 ($\rho' > 0$, bounded away from zero) and SC2 (strict quasi-concavity of the indifference curve) is sign-determined positive.

2. **Add case-analysis paragraph** after the boxed eq:appB-step1 result:
   - Two regimes for the wedge: (i) **unconstrained** ($R \ge \lambda_1/\lambda_2$, patient households with non-binding period-1 budget) and (ii) **constrained** ($R < \lambda_1/\lambda_2$, period-1 credit constraint binds — the wealth-bias-active regime).
   - In regime (i): $(R - \lambda_1/\lambda_2) \ge 0$, numerator $\ge 0$ in absolute terms, leading minus gives $\partial W^*/\partial T_i \le 0$. ✓
   - In regime (ii): $(R - \lambda_1/\lambda_2) < 0$. Apparent sign flip in numerator. BUT the implicit-function denominator $G_W$ also carries this wedge with opposite sign (chain rule on $\rho(W^*+T)$ vs $(1-\rho(W^*+T))$ terms). Result: the ratio $-G_T/G_W$ remains negative in both regimes.
   - One-line conclusion: "The sign $\partial W^*/\partial T_i < 0$ holds across both regimes; the credit-constrained regime is the empirically relevant case for Korean smallholders, but the comparative static is robust to which regime binds at the threshold."

3. **Optionally add a new SC6_co** in the §B.1 SC list (between SC5 and §B.1 closing) labeling "Hessian-determinant denominator positivity" as a regularity condition. Decision deferred to Open Q1; default = NO new SC, language stays in Step 1 expansion only.

### Phase 3 — X8: §3.1 anticipation-effects pre-emption (~30 min)

**Problem.** PIDPS Act was enacted before the 2018 FHES baseline (announcement → implementation gap). The frozen-rv defense protects against post-2020 manipulation but NOT against pre-2018 strategic area reporting under anticipation. Lens 5 C1: single biggest pre-emption hole.

**Fix.** Add 2–3 sentences to the §3.1 "Estimand and pre-period inference" paragraph (currently at main.tex L155, post-X4/X5 edits will not shift this line meaningfully). Insertion point: after the existing Roth/Rambachan-Roth sentence (end of paragraph).

Drafted text:
```
We also pre-empt the anticipation-effects threat: PIDPS was enacted in 2019
and effective 2020-05-01, after the 2018 FHES baseline; pre-2018 strategic
area reporting could in principle have biased eligibility-as-determined-by-
2018-area if Korean smallholders anticipated the 0.5~ha threshold prior to
the Act's formal announcement. We argue against this concern on three
grounds: (i) the per-farm flat-rate SFFP component of PIDPS was specifically
designed after 2018 (no pre-announcement of a 0.5~ha cutoff), (ii) we test
for differential pre-period trends in $A_{2018}$ density at the cutoff via
the \citet{McCrary2008_density} test (reported in \S\ref{sec:robustness}),
and (iii) HonestDiD $\bar M$ bounds on $\hat\beta_1$ remain interpretable
under bounded pre-period anticipation per \citet{RambachanRoth2023_honestdid}.
```

**Bibliography prep:** Need to add `McCrary2008_density` to `Bibliography_base.bib`. Per CoVe report Lens 7 M2 — this was flagged as a missing AJAE-expected method cite. Bundle here.

### Phase 4 — X9: §3.1 McCrary density framing (~10 min)

**Problem.** §7 Robustness stub mentions a +0.7pp McCrary density result, but §3 framing doesn't introduce the test. Lens 5 C2: reads post-hoc if surfaced only in robustness.

**Fix.** One sentence in §3.1 "Estimand and pre-period inference" paragraph (immediately after the X8 anticipation paragraph). Single addition:
```
We verify continuity of the cutoff density (no evidence of running-variable
manipulation) via the \citet{McCrary2008_density} test, with the density
discontinuity estimate reported in \S\ref{sec:robustness}.
```

This bundles cleanly with X8 (same McCrary citation used in both); insert immediately after X8.

### Phase 5 — Verification (~10 min)

1. **Compile main.tex:** `cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex` → 19±1 p PDF, no new undefined citations, McCrary cite resolves.
2. **Compile online_appendix.tex:** → 8±1 p PDF, Step 1 + Step 3 derivations render correctly with new equations, SC list re-reads coherently.
3. **F1 trigger cross-check:** §B.3 trigger col + §3.4 falsification block continue to refer to four-bin monotone form (no breakage from X5 recast).
4. **quality_score.py:** `python3 scripts/quality_score.py paper/en/main.tex` should return ≥ 80 (now that QS-1 path is fixed; expect 80–85 range pending real long-equation warnings).
5. **paper/ko 0-diff** confirmation.

### Phase 6 — Commit + PR (~10 min)

`/commit` skill: stage edits → quality_score gate (no override expected post-QS-1) → gh pr create against main with itemized X4/X5/X8/X9 body. Manual approval gate.

---

## Decisions locked (pre-implementation)

**Q1 — X4 new SC6_co for Hessian-determinant denominator positivity?** **NO new SC.** Hessian-determinant positivity is folded into the Step 1 expansion paragraph; SC1 (ρ' > 0 bounded) + SC2 (strict quasi-concavity) already cover the regularity. Avoids SC-list bloat.

**Q2 — X5 SC2.5 wording approach: Hybrid (four-bin primary + stochastic-dominance footnote).** Main-text + boxed derivation uses four-bin sub-threshold-mass primitive (cheaper, audit-friendly, aligns with Wave 1 F1 trigger). Footnote attached to new SC2.5 notes the FOSD strengthening: $F(W_i \mid s_{0,i} = 0)$ first-order stochastically dominates $F(W_i \mid s_{0,i} \in (0, .33])$ FOSD $F(W_i \mid s_{0,i} \in (.33, .67])$ FOSD $F(W_i \mid s_{0,i} = 1)$ within the eligibility window. The four-bin derivation is a strict implication of FOSD; the FOSD form is preferred by theory referees but the four-bin form is what the empirical test in §5 actually checks. Belt-and-suspenders; +15 min for the footnote.

**Q3 — X8 McCrary citation: bundle here or defer to Wave 4?** **Bundle here.** McCrary 2008 is needed for both X8 (anticipation pre-emption) and X9 (density framing); single bib entry covers both. Defer the other Lens 7 M2 cites (CCT 2014 ECMA, CGM 2008 RESTAT) to Wave 4.

**Q4 — X8 paragraph length: tight (2–3 sentences) vs expanded (~80 words)?** **Tight 3-sentence + 3-grounds enumeration.** Pre-empts the threat without dominating the §3.1 close. Detailed McCrary test results reside in §7 robustness.

---

## Verification (end-to-end)

1. **Compile:** main.tex 19±1 p, online_appendix.tex 8±1 p; both XeLaTeX exit 0; no Korean glyph warnings; no new undefined citations.
2. **quality_score.py:** ≥ 80 on main.tex (post-QS-1 fix).
3. **F1 framework coherence:** trigger forms across §3.4 falsification (Wave 1) ↔ §B.3 grid (Wave 1) ↔ eq:CO-2 (Wave 2 X5) ↔ eq:appB-step3 (Wave 2 X5) all consistent in four-bin form.
4. **Theory-credibility checklist:**
   - eq:appB-step1 denominator no longer has `(other terms)` placeholder ✓
   - Step 1 case analysis for (R vs λ_1/λ_2) wedge present ✓
   - SC2.5 reformulated as four-bin sub-threshold-mass primitive ✓
   - Continuous monotone-density argument explicitly noted as not-load-bearing ✓
   - McCrary 2008 cite added + used in X8 + X9 ✓
   - Anticipation-effects 3-grounds pre-emption in §3.1 ✓
5. **paper/ko/ diff = 0 lines.**
6. **Bibliography_base.bib:** +1 entry (McCrary2008_density), `% VERIFY-PRE-SUBMIT` flag.

---

## Out of scope (deferred to Wave 3 / Wave 4)

**Wave 3 (~1.5 h):** X10 FHES attrition note (§4 Data), Lens 1 abstract magnitude (−11.1%, +1,089 m²), Lens 2 ¶6 split + stray `\ ` L65 + "Preliminary" hedge drop, other Lens 1/2 MAJORs.

**Wave 4 (~1 h):** tab:notation missing symbols ($A_i$, $A_{2018,i}$, $rv_{2018,i}$, $h$, $\bar a$, $\Delta K$, $\lambda/\mu$), sentence-length copyedit (~30 long sentences ≥40 words), Baldoni-Ciaian upper-bound clarification ("9–55% range" in 3 in-text loci), missing AJAE method cites (CCT 2014 ECMA, CGM 2008 RESTAT — McCrary 2008 already bundled into Wave 2 X8).

**Out of scope entirely:** §5 Results re-tabulation (option A, depends on P3b re-run data); §6 Identification Strategy STUB fill; §7 Robustness STUB fill; §8 Discussion STUB fill; §9 Conclusion STUB fill.
