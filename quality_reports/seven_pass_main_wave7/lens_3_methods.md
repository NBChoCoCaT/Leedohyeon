# Lens 3 — Methods / Identification Credibility

**Manuscript:** `paper/en/main.tex` (457 lines, Wave 7)
**Sections audited:** §2 Institutional Context (L70–96), §3 Theory (L99–308), §4 Data (L311–321), §5 Identification (L323–343)
**Reviewer posture:** Sharp AJAE referee, methods focus
**Verdict:** **NEEDS WORK** — design is fundamentally sound and well-disclosed but has 4 MAJOR gaps a careful AJAE referee will flag; 1 borderline-CRITICAL load-bearing inconsistency.

**Score: 7.0/10**

---

## CRITICAL

### C1. Headline numbers contradict between §5/§6 and §8 Conclusion (load-bearing).
**L350** (Results): pure-tenant T2 = **+1,122 m²**, p = **.041**; T1 p = **.053**.
**L367** (Headline footnote 4): pure-tenant T2 p = **.033** (Wave-5 vestige?).
**L447** (Conclusion): pure-tenant T2 = **+1,089 m²**, p = **.033**; op_cost T1 = **−4.18M**, p = **.047** (these are the Wave-5 *area-only* numbers per L359 and the conclusion mixes them with the Wave-7 framing); also Conclusion gradient given as "1,089→410→393→−101→0" which is neither Wave-5 nor Wave-7 as reported elsewhere.
**L351** (Results, separate from F1 trigger evaluation): "$p < .05$ in T2 and T3 ($p = .053$ in T1)" — but the F1 trigger uses T2 only (L296) so this is fine, *but* the T3 p-value is never given numerically anywhere — see M3 below.

An AJAE referee will read the Conclusion's contradictory numbers as either (a) a stale copy-paste from Wave-5, or (b) evidence the F1 strict-AND condition was evaluated on numbers that changed during revision. This is exactly the kind of inconsistency `/audit-reproducibility` should have caught. **Reconcile to a single set of Wave-7 numbers throughout, or footnote that Conclusion reports the area-only baseline.**

---

## MAJOR

### M1. SUTVA / spillovers across the cutoff are never discussed.
**Where missing:** §2.3 (L89–96) and §5 (L323–343).
The DiD-RD design assumes no spillover from treated to control households within the bandwidth. Plausible violations:
- **Rental-market spillover:** if treated tenants substitute toward owned land (your headline mechanism, L350), the *control* households (just above the cutoff) face a thinner rental-supply pool. Rent moves at L308 (−12% pass-through) are *evidence of equilibrium spillover*, which mechanically violates SUTVA on β₅ and contaminates β₁ for control units near the cutoff.
- **Local-labor-market spillover:** off-farm income (β₄, L361) is null partly because both sides of the cutoff share the same local labor market.
The paper acknowledges aggregate-equilibrium effects (L308, L434) but never frames this as a SUTVA threat to RD identification. Add a paragraph in §5 explicitly addressing: (i) treatment-control geographic separation (are sgg-level clusters mostly one-sided?); (ii) bound on rental-market spillover magnitude; (iii) defense of LATE-at-cutoff interpretation under the documented equilibrium effects.

### M2. Selection bias from dropping 194 households is asserted-not-proven.
**L92, L319:** "the headline operating-cost coefficient moves by no more than 2.2\%" under the subset restriction. But the *Wave-5 → Wave-7* comparison (L359, L409) is moving in one direction only: it shows that adding 194 area-eligible-but-statutorily-ineligible households doesn't change the answer. The relevant counterfactual concern is the opposite: those 194 households are systematically *higher-off-farm-income* (12.8% of the 14.6% margin) — which means the retained subset is a non-random selection on a key household-level covariate. The §7.1 robustness establishes that the two definitions produce similar β's, but does NOT establish that selection on off-farm-income doesn't bias the *F1 tenancy gradient* (which is the load-bearing finding). I would want to see:
  - The F1 four-bin tenancy gradient re-estimated on the full area-eligible cohort (Wave-5 sample) — does the gradient survive?
  - A balance table of the 194 dropped households vs. the 1,131 retained, on covariates that *predict tenancy s_0* (age, education, paddy-share, sgg).

Without this, the sharp-RD-restoration argument (L62, L319) reads as a definitional fix rather than an identification-bias defense.

### M3. T3 (MSE-optimal) is reported in name only.
**L337** promises T3 as one of three parallel bandwidths. But:
- **L350** gives T3 only as $h \approx 3{,}300$ m² with no point estimate or p-value for the pure-tenant cell.
- **L351** asserts "$p < .05$ in T2 and T3" but no T3 number is given.
- **L359** says "at T3 ... point estimate attenuates to approximately zero ($p > .50$)" for β₃ — a complete contradiction with the F1 reading at T3.
- **L361** says β₄ is small at all bandwidths with no T3 specifics.

Parallel reporting requires *parallel numbers*. The current text reads as if T3 was reported only when it agreed with the headline. AJAE referees will read this as cherry-picking even if it isn't. **Fix:** add a table (or extend Table for tab:appB-mapping) reporting all 5 bins × 3 bandwidths × 4 outcomes = full grid. Reference §6.x of the replication package if space-constrained.

### M4. F1 strict-AND trigger logic is asymmetric and under-justified.
**L296:** F1 fires iff (i) $p(\hat\beta_2 > 0) > .10$ at T2 **AND** (ii) four-bin monotone broken at T2. This is a *very high bar* to reject — both conjuncts must fail for the wealth-bias channel to be rejected. The defense is one sentence ("strict-AND boolean; Holm-corrected across the two conditions"). Issues:
- **Statistical logic:** strict-AND minimizes Type-I but maximizes Type-II error on the *rejection direction*. Since the paper's contribution is the *rejection of separability via wealth-bias*, the design is constructed to favor the maintained hypothesis. A skeptical referee will read this as a pre-specification that makes the null nearly unrejectable.
- **Conjunct (i) is on β₂ (the interaction), L350 reports F1 evaluation on β₁ at the pure-tenant cell** (L339: "the bin-1 pure-tenant coefficient $\hat\beta_{1,\text{tenant}}$"). The trigger text in §3.5 (L296) says β₂ — these are different objects. **Reconcile.**
- **Holm correction across two conditions** of a strict-AND boolean is a category error — Holm controls FWER across a *family* of independent tests being combined by OR, not AND. The AND combination is automatically conservative without correction. Either drop "Holm-corrected across the two conditions" or restate the combination rule.
- **Pre-registration date:** §1 (L58, L62, L66) claims the F1/F2 specs "predate §5 estimation" and are "archived in the replication package" (footnote 2 / ADR-0001 + ADR-0002 + ADR-0003). For a referee, this is a verifiable claim — the ADRs need to be in the replication package with a verifiable git-commit timestamp predating any results file. Currently the manuscript references but does not externalize this.

### M5. McCrary test is the only manipulation test, but the test has known low power.
**L374:** McCrary 2008 t = 1.34, p = .18, n = 2,680. With n = 2,680 and the running variable in 100-m² bins (cultivated area), the McCrary test has *very* low power against smooth-but-asymmetric manipulation. Recommend adding **Cattaneo-Jansson-Ma (2020)** local-polynomial density test as a higher-powered complement. Single-page robustness; standard at AJAE/QE in 2025+.

---

## MINOR

### m1. Eq. (\ref{eq:didrd-main}) at L332 is an interaction-on-pooled-panel spec, not a textbook DiD-RD.
The specification omits unit and time fixed effects (just $D_i$, $\text{Post}_t$, $f(rv)$, $x_{i,t}$). For DiD on panel data, this is non-standard — the typical spec absorbs $\alpha_i + \delta_t$ and identifies off $D_i \cdot \text{Post}_t$ within-unit-within-time. The paper's spec recovers a between-and-within estimate that is consistent under parallel trends but not standard. Either: (a) absorb hh fixed effects + year fixed effects and report; (b) justify the cross-sectional levels formulation explicitly (e.g., 2018-baseline freeze makes $D_i$ time-invariant by construction so the FE absorbs nothing). I suspect (b) is the answer — *say it*.

### m2. The pre-period for parallel-trends is 2018–2019 (L62) but L189 frames the gap as "2018–2019" (one gap, two years). With single pre-period observation per unit (Roth 2022 explicitly applies), the HonestDiD bounds are doing all the work. The paper cites Roth 2022 (L189) and reports $\bar M$ bounds (L398). Adequate, but state explicitly in §5 that "single-pre-period inference is acknowledged as Roth-2022-limited; HonestDiD breakdown $\bar M^*$ is the headline robustness number" — currently buried in §6.

### m3. Take-up imputation is 100% by construction (L271: "100\% appear with positive imputed payment ... imputed SFFP = 1.2M · 1[D_i = 1, Post]"). The ITT framing makes this defensible (the imputation IS the eligibility indicator), but the prose at L271 conflates "imputed" with "actual administrative receipt at 92.3%" in a way that will confuse a referee. **Re-word:** "We do not use administrative receipt data; the ITT estimand uses statutorily-defined eligibility as the binary treatment, which by construction has 100% take-up in the ITT sense. The 92.3% administrative receipt rate among eligibles is reported only as an external-validity benchmark."

### m4. L341 (clustering): "wild cluster bootstrap p-values follow Cameron-Gelbach-Miller 2008 with B = 9,999 Rademacher refits per cell." But L387 (Robustness) says "manual cluster-Rademacher refits with $B = 999$ following CGM; full $B = 9{,}999$ at the replication-release stage." **Contradiction.** Reconcile: the *paper* should report the B = 9,999 numbers, not B = 999 with a promise.

### m5. Anticipation defense at L189 invokes three points (i)/(ii)/(iii) but point (i) — "the per-farm flat-rate SFFP component was specifically designed after 2018" — needs a citation to a MAFRA timeline / Act drafting history. Currently asserted without source.

### m6. Notation: $\beta_k$ for $k \in \{1,2,3,4,5\}$ is defined in Table 1 (L113) and used uniformly, but at L296 the F1 trigger uses $\hat\beta_2$ (the heterogeneity interaction), and at L339 the test is on $\hat\beta_{1,\text{tenant}}$ (the bin-1 coefficient). These are different estimators. **Sync the F1 trigger statement with the actual test reported in §6.**

### m7. L62 / L92 / L319 all repeat the 14.6% / 194 / 1,131 figures verbatim. Pick one canonical statement (§2.2 L87) and reference it.

### m8. L321 reports raw mean differences ($-27.5$ M KRW operating cost, $-3.1$ M off-farm) but does NOT note that these are huge baseline imbalances that the RD design must overcome via local-linear smoothing. Add one sentence: "These pooled-mean differences reflect non-comparability away from the cutoff; the DiD-RD design exploits only local variation within the bandwidth (Table X reports local means at the cutoff)."

### m9. L302–305 (Joint reading enumeration) lists three outcomes; the realized outcome is "F1 not fire + F2 not fire (F2 null)" which corresponds to *outcome 2* ("both channels operative — strongest reading"). But L361, L363 read the realized outcome as "F2 null" via the EK-1 sign-indeterminacy carve-out. The paper splits the difference — claims wealth-bias supported (outcome 2-flavored) but doesn't claim supervision channel operative (outcome 1-flavored). Refine the enumeration at L302 to include this "F2 null under sign-indeterminacy" subcase explicitly.

---

## Targeted edits (line-numbered)

| Line | Issue | Action |
|------|-------|--------|
| L296 | F1 trigger uses β₂; tests run on β₁ | Restate trigger in terms of the bin-coefficient estimator actually used |
| L296 | "Holm-corrected across the two conditions" of AND | Drop or restate |
| L319 | Sharp-RD restoration claim | Add balance table for 194 dropped households |
| L323–343 | SUTVA never mentioned | Add ¶ "Stable Unit Treatment Value Assumption" addressing rental-market spillover |
| L337 | T3 bandwidth | Report all T3 numbers; add full grid in appendix |
| L341 | B = 9,999 | Reconcile with L387 B = 999 |
| L350 | β at T2 = 1,122 m² | Reconcile with L367 (.033), L447 (1,089 m²) — pick one set |
| L367 | Footnote 4 p = .033 | Update to Wave-7 numbers or footnote the source |
| L374 | McCrary only | Add Cattaneo-Jansson-Ma 2020 density test |
| L447–449 | Conclusion numbers | Match §6 exactly |

---

## Summary table

| Lens-3 dimension | Verdict |
|---|---|
| 1. Identifying assumptions stated? | YES (parallel trends, McCrary, anticipation) — but SUTVA missing (M1) |
| 2. Identification one-liner clear? | YES — frozen 2018 RV + 2020 DiD switch is well-stated (L62, L328) |
| 3. SUTVA handling? | **NO** (M1) |
| 4. Selection-into-subset defense? | PARTIAL — robustness exists but goes the wrong direction (M2) |
| 5. Reverse causality / anticipation? | YES — adequately handled (L189) |
| 6. ITT vs LATE / take-up imputation? | MOSTLY — needs prose cleanup (m3) |
| 7. Bandwidth parallel reporting? | NO — T3 reported in name only (M3) |
| 8. Clustering | OK at primary (hh_id); sgg_cd robustness promised in §6 |
| 9. F1 strict-AND defense | WEAK — asymmetric, mis-described (M4) |

**Recommendation:** PASS to revise. The four MAJOR issues are all *fixable in 1–2 days* without re-estimation:
- M1 (SUTVA paragraph): write it
- M2 (balance table + full-cohort F1 re-estimation): tractable from `_outputs/clean.rds`
- M3 (T3 full grid): already in `_outputs_eligibility/` — surface it
- M4 (F1 trigger restatement): editorial

The CRITICAL number-consistency issue (C1) is the highest priority and a 30-min fix. Address C1+M1–M4 and the methods section moves to 8.5+/10 and clears the AJAE methods bar.
