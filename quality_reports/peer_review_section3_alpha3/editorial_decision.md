# Editorial Decision: PIDPS / SFFP — AHM-Extension Separability Test at the 0.5 ha Cutoff (α3 §3 + Online Appendix B alpha-test)

**Calibrated to:** American Journal of Agricultural Economics (AJAE)
**Date:** 2026-05-18
**Decision:** **Major Revision**
**Paper:** `paper/en/main.tex` §3 (L79–210) + `paper/en/online_appendix.tex` §B.1–B.3 (L77–437)
**Scope:** α3 alpha test of §3 + Online Appendix B only. Title/Abstract/§1/§5/§6 are explicit TODO placeholders and were not evaluated.

---

## One-paragraph editor's assessment

The α3 rewrite has done the work the desk review asked it to do: the AHM-extension framing is theoretically defensible, the Carter-Olinto B.1 derivation is genuinely contribution-grade, and both referees independently confirmed that the B.1 demotion of the bargaining/incidence margin to an ex-theory aggregate-equilibrium implication is an **honest reframe**, not a post-hoc rescue. The paper clears the AJAE bar in *kind* — what remains is calibration in *degree*. Ten concrete MAJOR concerns were raised across the two reports, every one of them ADDRESSABLE in one revision pass without re-derivation: notation harmonization (T-C2), an individual-vs-population acknowledgment at eq. CO-1 (T-C1), an SC-list distinction between sufficient and necessary plus one missing primitive on the threshold-density monotonicity (T-C3), a sourced $\tau$ calibration with reconciliation of the 25M / 50M project-memory discrepancy (T-C4 ≡ E-C3), an F2 falsification-asymmetry tightening (T-C5), auditable pre-locking of the $s_0$ binning rule (E-C1), in-manuscript disclosure of the ADR-0002 outcome-hierarchy reorder timing (E-C2), an ITT-vs-post-2020 + Roth-2022 parallel-trends paragraph (E-C4), and a per-bandwidth falsification grid for §B.3 (E-C5). None of these touches the theoretical core; all are presentation, citation, and disclosure fixes. The pre-specification posture is the most fragile dimension and is the one most likely to bind at AJAE under DCAS v1.0 — the author should treat ADR archival and the §3 timing footnote as load-bearing fixes, not cosmetic ones. **Estimated AJAE acceptance probability after a clean R&R addressing all ten: 65–72%, up modestly from the pre-simulation 60–65% range.**

---

## Referee summary

- **Referee A (THEORY — Singh-Squire-Strauss / Carter-Olinto / Eswaran-Kotwal expert):** composite **82.5/100**, upper-Major-Rev band. Verdict: the Carter-Olinto derivation is the strongest part of the paper; three substantive defects (eq. CO-1 individual-vs-aggregate, $\tau$ source citation, SC-list typology) keep it below first-submission grade but are all closable in one revision. Independent confirmation of the desk-review reading on B.1: **honest reframe**.
- **Referee B (CREDIBILITY+MEASUREMENT — DiD-RD at policy cutoffs, AJAE empirical Q-bar, DCAS v1.0):** composite **73.3/100**, mid-Major-Rev band. Verdict: theoretically tight closed-form predictions, but the empirical pre-specification posture is fragile in five auditable places. The §B.3 mapping table cannot bear the weight the framework places on it until the binning rule, the ADR-0002 timing, and the $\tau$ provenance are made visible to a DCAS v1.0 referee. Pre-spec verdict: "moving target on auditable surface." Magnitude-calibration verdict: Partial.

Both referees recommend **Major Revision**; the composite spread (73.3 vs 82.5) reflects disposition lens (CREDIBILITY+MEASUREMENT is harder on auditable-surface gaps than THEORY is) rather than disagreement on the underlying paper.

---

## Concern classification

### FATAL

| Concern | From | Why fatal |
|---|---|---|

**None.** No concern across either report meets the FATAL threshold (contribution unsupportable / math wrong / data cannot deliver headline). The closest candidate — the cross-referee $\tau$ calibration convergence (T-C4 ≡ E-C3) with the 25M/50M factor-of-two project-memory discrepancy — was evaluated and classified ADDRESSABLE (see "Editor's $\tau$ verdict" below).

### ADDRESSABLE

| # | Concern | From | Suggested path |
|---|---|---|---|
| A1 | **Eq. CO-1 main-text sign claim is a population aggregate written as an individual partial derivative.** Main text claims an individual-$i$ FOC sign that the appendix delivers as a population-level threshold-crossing aggregate. The empirical specification implied differs: hazard/discrete-choice vs continuous DiD-RD coefficient. | THEORY C1 | Rewrite (\ref{eq:CO-1}) LHS as $\partial \mathbb{E}[A_{own} \mid \text{eligibility window}]/\partial T_{SFFP}$, OR add a one-paragraph bridge between §3.2 L138 and L141 acknowledging the population-aggregate nature of $\varphi(W^*)$. One short paragraph. |
| A2 | **Notation drift: static §3.1 partial vs two-period §B.1 stock derivative; $T_i$/$T_{SFFP}$/$T_{SFFP}\cdot D_i$ alternation across §3.1/§3.2/§B.1; $\rho(W) \in [0,1]$ semantics not surfaced in main text; $s_0$ cosmetic asymmetry.** | THEORY C2 (critical peeve hit) | (i) Add notation table at head of §3 (already a constructive-peeve ask); (ii) one-paragraph bridge before (\ref{eq:CO-1}) stating period-1-flow / period-2-stock formulation is the operational form of (\ref{eq:null}); (iii) harmonize $T_i = T_{SFFP} \cdot D_i$ everywhere. Concrete, mechanical. |
| A3 | **SC1–SC5 are mixed necessary/sufficient/regularity/identification conditions framed uniformly as "sufficient"; $\partial \varphi(W^*)/\partial s_0 \le 0$ is stipulated, not derived from primitives.** F1 falsification rests on this stipulated monotonicity. | THEORY C3 | (i) Add SC2.5: "baseline wealth $W_i$ and baseline own-share $s_{0,i}$ are negatively correlated within the eligibility window," with a one-line FHES Wave 1 correlation coefficient as empirical support; (ii) relabel SC list into four typed buckets (sufficient-for-sign / regularity / identification / interior-solution). |
| A4 | **$\tau \approx 25$M KRW calibration drives (\ref{eq:CO-3}) but is uncited; CLAUDE.md project memory cites 50M, manuscript cites 25M — factor-of-two unreconciled; $T/\tau = 0.048$ sits at the Caballero-Engel 5–10% boundary.** Both referees raised independently. | THEORY C4 ∩ EMPIRICAL C3 | Add a sourced citation for $\tau$ (Rural Development Administration / KAMICO / KAEA-KREI machinery cost survey). Reconcile 25M-down-payment vs 50M-purchase-price explicitly in a footnote. Add a robustness statement that (\ref{eq:CO-3}) sign holds for $\tau \in [20\text{M}, 40\text{M}]$ KRW. Lift the magnitude-calibration paragraph from appendix to main-text §3.4 (or new §3.4.1). |
| A5 | **F2 falsification is logically asymmetric to F1.** Sign-indeterminate EK-1 means $\hat\beta_4 = 0$ can reflect (mechanism inoperative) OR (mechanism operative + opposing effects exactly cancel at the SFFP scale). Current framing presents F2 as symmetric to F1 in rejection force. | THEORY C5 | Either (i) tighten F2 to a *conditional* rejection with an auxiliary cancellation test (e.g., heterogeneity in $\hat\beta_4$ by hired-labor share), or (ii) demote F2 to "informative-but-not-rejecting" in the F1+F2 joint logic so the LaFave-Thomas 2016 reframe rests on F1 alone with F2 as supporting evidence. Either fix is a framing paragraph. |
| A6 | **$s_0$ quintile cutpoints and pure-tenant/pure-owner anchors not auditably pre-locked.** Four-bin vs quintile choice changes Bayes factor on F1; with four bins prior $p \approx 0.04$ under null, with quintiles $p \approx 0.008$. | EMPIRICAL C1 (critical peeve hit) | Add footnote in §3.2 or paragraph in §B.1 Step 3 (after \ref{eq:appB-step3}) committing to the partition rule (quintiles vs four-bin {pure_tenant: $s_0=0$; low_owner: $0<s_0\le 0.33$; mixed: $0.33<s_0\le 0.67$; pure_owner: $s_0=1$}) and citing the ADR / pre-registration timestamp. Cross-link R-conventions §10. |
| A7 | **Outcome-hierarchy reorder (ADR-0002, 2026-05-18) post-dates P3b-2 results but §3 does not disclose timing to the reader.** To a referee inspecting only the manuscript (the AJAE-DCAS audit target), the framing reads as ex ante; the asymmetry between project-internal ADR record and manuscript framing is the honesty issue. | EMPIRICAL C2 | (i) Footnote at L88 or at §3.4 outcome-table (L181–199) disclosing the hierarchy is the realignment under α-strict scope adopted prior to §5 estimation under the present framing, with explicit reference to ADR-0001/ADR-0002. (ii) Public archival of ADRs in replication package (cross-link from `scripts/R/synthetic/README.md`) so referee can independently verify the timestamp. |
| A8 | **§3 over-commits §5 to clean DiD-RD without acknowledging ITT-on-Channel-A vs post-2020 endogeneity, or Roth (2022) parallel-trends limits with one effective pre-period.** | EMPIRICAL C4 | ~80-word paragraph at the close of §3.1 (after L118): "The DiD-RD design exploits the 2018-baseline frozen cutoff at 5,000 m²; the recovered estimand is therefore an ITT over eligibility-as-determined-by-2018-area; we caveat $\partial A_{own,i}/\partial T_{SFFP}$ as the eligibility-induced effect on post-period own area, robust to post-2020 threshold-crossings being endogenous. Parallel-trends inference rests on the 2018–2019 pre-period gap; we report HonestDiD bounds (Rambachan-Roth 2023) in the robustness appendix." Cheap, protective. |
| A9 | **§B.3 mapping table mixes T1/T2/T3 magnitudes within rows; "$\hat\beta_1 = 0$ uniformly" falsification rule is operationally underspecified.** | EMPIRICAL C5 | Expand §B.3 to per-bandwidth grid (T1/T2/T3 × $\beta_1$–$\beta_5$). Operationalize falsification triggers as concrete decision rules (e.g., "F1 fires if $p(\hat\beta_2 > 0) > .10$ at T2 *and* the four-bin point estimates fail to be monotone in the predicted direction"). Tie to R-conventions §10 bandwidth grid. |
| A10 | **Annual-flow vs lump-sum interpretation of $T_{SFFP}$, FHES Wave-table cross-references missing (92.3% take-up, 17–34% hired-labor share), $s_{0,i}$ measurement error.** | EMPIRICAL minor 1–4 promoted to ADDRESSABLE because they cluster around the same calibration audit | Bundle with A4 magnitude-calibration paragraph: cite annual-flow vs lump-sum interpretation in §3.1 L100; add specific FHES Wave 1 table cells for 92.3% and 17–34%; one-line footnote on $s_0$ measurement-error attenuation + four-bin discreteness robustness argument. |

**Count: 10 ADDRESSABLE, 0 FATAL.**

### TASTE (author may push back)

| Concern | From | Editor's view |
|---|---|---|
| Strauss 1986 chapter alongside Singh-Squire-Strauss volume at §3.1 L88 | THEORY minor | Reasonable ask, low cost. Editor's view: include it — the Strauss chapter is the standard recursive-factorization cite. |
| Pitt-Rosenzweig 1986 JPE at §3.3 or §B.2 | THEORY minor | Editor's view: nice-to-have, but the EK-channel lineage is intact without it. Author may push back if word budget is tight. |
| Ghatak-Mookherjee 2024 NBER w31932 in §3.3 | THEORY minor (desk review flagged) | Editor's view: include it — recent revisit of the supervision-tenancy literature post-dating §3 bibliography window. One sentence. |
| Cite a specific paper that could deliver the equilibrium closure (Sotelo 2020 JPE / Costinot-Donaldson 2016 AER) at §B.1 L257 | THEORY minor | Editor's view: TASTE — current "future work" framing is fine; specific citation makes it operational but isn't load-bearing. Author may push back. |
| Cross-link main-text §3.4 L208 equilibrium-rent caveat to §B.1 closing paragraph (which reads more measured) | EMPIRICAL minor 6 | Editor's view: minor presentation polish, do it. |
| AEA DCAS v1.0 synthetic-generator footnote at §3 | EMPIRICAL minor 8 | Editor's view: SHOULD-do for AJAE under DCAS v1.0; a single footnote previews the replication package and reduces editorial friction at submission. |
| (\ref{eq:appB-step1}) "(other terms)" hand-wave; full Hessian-determinant denominator | THEORY minor | Editor's view: TASTE — sign holds under standard regularity; a footnote is courteous but not required. |

---

## Where referees disagreed

The two referees largely complemented rather than disagreed; the score spread (73.3 vs 82.5) reflects disposition lens, not substantive contradiction. Three explicit disagreement/asymmetry points:

1. **Pre-specification posture (EMPIRICAL C1, C2, C5 vs THEORY silence).** The THEORY referee did not raise the pre-specification "moving target on auditable surface" issue — this is a disposition artifact (CREDIBILITY+MEASUREMENT lens) rather than evidence the issue is absent. The editor concurs with EMPIRICAL that ADR-0002 timing, $s_0$ binning rule, and the per-bandwidth falsification grid are real auditable-surface gaps. THEORY's silence does not weaken the empirical critique; it confirms that pre-spec is outside the theory lens.

2. **Closed-form derivation review (THEORY C1, C2, C3 vs EMPIRICAL silence).** The EMPIRICAL referee did not independently re-derive eq. CO-1 / CO-2 / CO-3 / EK-1. The EMPIRICAL "Positive observation 7" ("Lagrangian derivations in §B.1 and §B.2 are rigorous; a theory referee will find no derivation gaps") was an explicit *deferral* to the THEORY referee, not an independent endorsement. The combined verdict — THEORY finds the derivations defensible modulo C1/C3 corrections, EMPIRICAL accepts the math on the THEORY referee's authority — is the correct division of labor and the math is not a load-bearing concern.

3. **B.1 honest-reframe verdict (THEORY explicit, EMPIRICAL concurring, editor independently flagged at desk).** THEORY referee independently confirmed the B.1 ex-theory demotion is an honest reframe ("the methodologically correct demotion. I would have flagged a problem if the B.1 closing paragraph claimed 'we derive a negative equilibrium-rent response,' because that derivation does not appear in B.1 and would require an aggregation-and-supply-elasticity argument the model lacks. The author has not made that mistake."). EMPIRICAL referee concurred in the affirmative ("Positive observation 2: the reframe survives audit"). The editor flagged the same reading at desk review. **Three independent honest-reframe verdicts lock this in as a paper strength, not a concern.**

4. **Cross-referee convergence: $\tau$ calibration (THEORY C4 ≡ EMPIRICAL C3).** Both referees raised $\tau$ calibration as a major concern, surfaced from different angles: THEORY from "uncited load-bearing magnitude," EMPIRICAL from "uncited + Caballero-Engel boundary + factor-of-two project-memory discrepancy unreconciled." The editor's classification (ADDRESSABLE) is below.

---

## Editor's $\tau$ verdict: ADDRESSABLE (not FATAL)

The cross-referee convergence on $\tau \approx 25$M KRW deserves an explicit ruling. The classification turns on three sub-questions:

1. **Is the 25M figure wrong?** No — EMPIRICAL minor #7 already provides the most likely reconciliation: 50M (CLAUDE.md project memory) is total purchase price; 25M (§B.1) is down-payment-equivalent. Both can be true. The §B.1 text already says "down-payment-equivalent" — the reconciliation is a footnote, not a re-derivation.

2. **Does the Caballero-Engel boundary kill the prediction?** No — $T/\tau = 0.048$ sits inside the 5–10% range (technically just below); under the reconciled 50M interpretation $T/\tau = 0.024$, which is comfortably *inside* the inaction region and *strengthens* the (\ref{eq:CO-3}) sub-prediction. A robustness statement that $\beta_3 \le 0$ holds for $\tau \in [20\text{M}, 40\text{M}]$ KRW closes the sensitivity question.

3. **Does eq. CO-3 + SC4 collapse if true $\tau = 50$M?** No — the qualitative prediction strengthens (smaller ratio means deeper into inaction band, more confidence in $\beta_3 \le 0$). The prediction would only collapse if $\tau$ were *smaller* than ~12M KRW (driving the ratio above 10% and out of the inaction region), which is implausible for tractor/combine down-payment-equivalent calibration in Korean small-farm context.

**Verdict: ADDRESSABLE.** The fix is a one-paragraph magnitude-calibration sub-section in main-text §3.4 (or §3.4.1) with: (i) sourced $\tau$ citation, (ii) 25M-down-payment vs 50M-purchase-price reconciliation, (iii) robustness range $\tau \in [20\text{M}, 40\text{M}]$, (iv) the 92.3% take-up and 17–34% hired-labor-share FHES wave-table cells, (v) means against which the area_own and op_cost_ex_rent magnitudes should be read. ~250 words. This is the single highest-leverage revision in the paper.

---

## Response-planning block (for the author)

**MUST address (ADDRESSABLE — all 10):**
- A1: eq. CO-1 individual-vs-population aggregate acknowledgment
- A2: notation table + harmonization of $T_i = T_{SFFP} \cdot D_i$ + period-1-flow / period-2-stock bridge
- A3: SC list typology + SC2.5 ($W, s_0$ negative correlation primitive with FHES support)
- A4: **sourced $\tau$ + 25M/50M reconciliation + robustness range + magnitude-calibration sub-section** (highest leverage)
- A5: F2 falsification asymmetry tightening or demotion
- A6: $s_0$ partition rule pre-lock + ADR cross-reference
- A7: ADR-0002 timing disclosure footnote + public ADR archival
- A8: ITT / Roth-2022 / HonestDiD paragraph at §3.1 close
- A9: per-bandwidth §B.3 grid + operationalized falsification triggers
- A10: annual-flow vs lump-sum interpretation + FHES wave-table cross-refs + $s_0$ measurement-error footnote

**SHOULD address (TASTE editor finds reasonable):**
- Strauss 1986 chapter cite at §3.1 L88
- Ghatak-Mookherjee 2024 NBER w31932 cite in §3.3 (desk review also flagged)
- Cross-link main-text §3.4 L208 to §B.1 closing paragraph for tone consistency
- AEA DCAS v1.0 synthetic-generator footnote (single line, previews replication package)

**MAY push back (TASTE the author can defend):**
- Pitt-Rosenzweig 1986 JPE at §3.3 (EK lineage is intact without it; defensible if word budget tight)
- Sotelo 2020 / Costinot-Donaldson 2016 specific cite at §B.1 L257 "future work" closure (current generic framing is fine)
- (\ref{eq:appB-step1}) "(other terms)" hand-wave Hessian footnote (sign holds under standard regularity; courtesy not requirement)

**Revision time estimate:** 1–2 weeks of writing, no re-derivation, no new data analysis. The Carter-Olinto theoretical core is untouched. A clean R&R after one cycle is realistic.

---

## Revised AJAE acceptance probability

| Scenario | Probability | Rationale |
|---|---|---|
| Pre-simulation (per CLAUDE.md / prior memory under α3) | **60–65%** | Editor's prior estimate before referee evidence. |
| **Post-simulation, after clean R&R addressing all 10 ADDRESSABLE concerns** | **65–72%** | **Modest upward revision (+5 pp).** |
| Post-simulation, if R&R is uneven (e.g., $\tau$ calibration left unsourced or ADR-0002 timing left undisclosed) | 45–55% | Downward — DCAS v1.0 referees will hit the same pre-spec issues at submission. |
| Post-simulation, if §1 / Abstract / §5 / §6 (out-of-scope here) come in weak under α3 framing | 50–60% | Out of this review's scope; depends on Phase 4 §1 rewrite. |

**Rationale for the +5 pp upward revision:**
- **Positive signal:** Three independent honest-reframe verdicts on B.1 (editor desk + THEORY + EMPIRICAL concurrence) lock in the most consequential α3 change as a strength. This was the biggest pre-referee uncertainty and it resolved in the paper's favor.
- **Positive signal:** Both referees converged on Major Revision with all concerns ADDRESSABLE in one pass; neither floated a Reject-and-Resubmit or a fundamental-design-flaw flag. The paper is genuinely in the revision band, not the borderline-reject band.
- **Positive signal:** THEORY composite 82.5/100 is upper-Major-Rev; the Carter-Olinto derivation is contribution-grade per a THEORY referee whose disposition is the discriminating lens for an AJAE separability paper.
- **Negative signal (offsetting):** EMPIRICAL composite 73.3/100 is mid-band, and the pre-specification concerns (s₀ binning, ADR-0002 timing, $\tau$ provenance, per-bandwidth grid) are the kind of auditable-surface gaps that DCAS v1.0 referees will hit again at the second-round review if the R&R is incomplete. The five auditable-surface fixes are not all equally cheap — ADR archival in particular requires public-package commitment.
- **Net:** +5 pp upward (60–65% → 65–72%) assuming a clean R&R. The variance is dominated by §1/Abstract framing under α3 (Phase 4 work, not this review's scope) and by whether the magnitude-calibration sub-section actually lands with sourced citations.

---

## Top 3 concerns to address in §1 Abstract + Introduction rewrite

The author's next session is rewriting §1 under α3 (option A). These three concerns should be baked into the §1 framing — not just the §3 revision — because they're contribution-positioning issues that the abstract and intro must signal honestly to AJAE editors and referees before the paper is even sent out for review.

### 1. **Honest pre-specification disclosure language in §1**

The §1 contribution paragraph must acknowledge that the outcome hierarchy (area_own primary #1, op_cost_ex_rent primary #2, off_farm_income auxiliary, unit_rent_price/rent_cost ex-theory) is the α-strict realignment, distinct from the P3b-2 three-channel framing, and that the F1+F2 falsification triggers were locked under ADR-0001/ADR-0002 prior to §5 estimation. Concretely: include language such as "We pre-register two falsification triggers (F1 monotone-tenancy gradient; F2 supervision-margin sign) following the AHM-extension scope adopted in [ADR-0002, archived in replication package]." This costs one sentence and protects the framing against the "post-hoc reorder" reading that EMPIRICAL C2 surfaced. **Without this, AJAE referees in round 2 will hit the same audit gap.**

### 2. **Anchor positioning vs Kirwan / Ciaian / Kazukauskas / Carter-Olinto upfront — and the LaFave-Thomas 2016 graceful-failure clause**

The §1 contribution statement must position the paper against all four AJAE anchors *in the intro*, not just in §3:
- vs **Kirwan 2009 JPE** and **Ciaian 2023 LUP**: the −11.1% pass-through reversal of the US +25% / EU +46–55% consensus is a developed-country incidence finding — but framed as an aggregate-equilibrium implication (consistent with B.1 demotion), not as the household-model prediction;
- vs **Kazukauskas 2013 AJAE**: the (\ref{eq:CO-3}) op_cost_ex_rent sub-prediction is the developed-country decoupling-disinvestment lineage;
- vs **Carter-Olinto 2003 AJAE**: the cross-partial signature (\ref{eq:CO-2}) is the wealth-bias signature uniquely diagnostic of liquidity, not of universal income effect;
- vs **LaFave-Thomas 2016 ECMA** and **Benjamin 1992 ECMA**: the developed-country smallholder setting and the "precise null estimate complementing LaFave-Thomas" graceful-failure clause if F1+F2 both fire.

Carry the four-anchor positioning into the abstract's third sentence. **The novelty probes (desk review) returned Clear on the joint claim — the §1 has to land this positioning, not assert generic novelty.**

### 3. **Magnitude calibration in the abstract: $T_{SFFP}/\tau$ ratio and the 0.5 ha cutoff stated upfront**

The abstract should state the SFFP transfer scale (₩1.2M/year), the cutoff (0.5 ha = 5,000 m² baseline cultivated area), and the calibrated $T_{SFFP}/\tau$ ratio (0.048 under 25M down-payment-equivalent / 0.024 under 50M purchase-price) — *with* the reconciliation between the two. The reader at the abstract level should not be confused about whether this is a small or large policy intervention; making the ratio explicit signals that the closed-form predictions are derived under a known, sourced regime, not under an asserted calibration. **This is the single highest-leverage abstract-level concession to the methods referee's magnitude-calibration peeve.** A single sentence: "At a small-farmer flat-payment scale of ₩1.2M/year relative to the ~₩25M (down-payment) / ~₩50M (purchase-price) Korean small-farm capital adjustment cost — i.e., a 2.4–4.8% transfer-to-adjustment-cost ratio — the (S,s) inaction-band logic predicts $\beta_3 \le 0$ on operating costs net of rent."

---

## Decision rationale (editor's log, per editor.md rule #6)

- **Decision rule applied:** 0 FATAL + 10 ADDRESSABLE → "0 FATAL, 4+ ADDRESSABLE → Major revision" (editor.md L141–145).
- **Why not Minor Revision:** Ten ADDRESSABLE concerns (decision table threshold for Major is 4+).
- **Why not Reject:** No FATAL concern. The Carter-Olinto theoretical core is contribution-grade per THEORY composite 82.5/100; the B.1 honest-reframe verdict is triply confirmed; the empirical pre-spec gaps are auditable-surface fixes, not design flaws.
- **Why not "Reject and Resubmit":** All ten concerns are fixable in one revision pass without re-derivation, new data, or contribution reframing. Both referees explicitly land on Major Rev (not R&R-as-new-paper).
- **τ classification (ADDRESSABLE not FATAL):** The 25M/50M discrepancy is a down-payment vs purchase-price reconciliation gap, not a numerical error; the qualitative prediction sign holds across $\tau \in [20\text{M}, 40\text{M}]$ KRW; if anything the 50M reading strengthens (\ref{eq:CO-3}).
- **B.1 honest-reframe verdict:** Three independent confirmations (editor desk + THEORY + EMPIRICAL) lock this in as a paper strength. Not re-litigated.
- **Cross-artifact:** N/A — `--no-cross-artifact` for this alpha test; §5 results not yet executed under α3.
- **Out-of-scope (correctly):** Title / Abstract / §1 / §5 / §6 are TODO placeholders and were not evaluated by either referee per the desk-review scope instructions. The "Top 3 concerns for §1 rewrite" section above carries forward the actionable items that the author's next session needs to bake into §1 framing.

---

**Editor's last word.** The α3 rewrite landed. The B.1 honest demotion was the load-bearing test of the framing change, and it survives audit at three independent reads. What remains is calibration discipline — sourced $\tau$, ADR archival, $s_0$ binning rule, per-bandwidth falsification grid, ITT/Roth caveats. These are the auditable-surface fixes a DCAS v1.0 referee will hit at AJAE if not preempted in the R&R. Get them right and the paper is at 65–72% AJAE acceptance probability under α3 — a modest but real improvement on the pre-simulation 60–65% estimate. Get them wrong and the paper falls to the JAE → Food Policy fallback in the cascade. The next-session §1 rewrite is the place to signal that calibration discipline is taken seriously; the three §1 concerns above are the operational ask.
