# P3c Pre-Validation Findings (Phase 0)

**Date:** 2026-05-15
**Script:** `check.R` (this directory)
**Outputs:** `_outputs/{exit_def_distributions, attrition_by_year, profile_2018only}.csv`
**Plan:** `../../quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md`
**Spec target:** `../../quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md`

---

## 1. Definition feasibility (N per def)

| Definition | Logic | N (farms) | Treated | Control | Treated share | Δ vs overall (36.7%) |
|---|---|---:|---:|---:|---:|---:|
| **Def 1 — baseline** | `n_years < 5` | 1,397 | 588 | 809 | 42.1% | +5.4 pp |
| **Def 2 — policy-era exit (raw)** | `n_years < 5 & last_year ≥ 2020` | 951 | 379 | 572 | 39.9% | +3.2 pp |
| **Def 2′ — policy-era exit (corrected)** | `n_years < 5 & last_year ∈ {2020, 2021}` (excludes late entrants) | 221 | 101 | 120 | 45.7% | **+9.0 pp** |
| Def 3 — dynamic last_year | year of last obs, hazard | 1,397 (events) | — | — | — | — |
| Def 4 — completer | `n_years == 5` | 2,217 | 737 | 1,480 | 33.2% | −3.5 pp |

**Overall treated rate:** 36.7% (1,326 / 3,614).

> **Critical correction surfaced by this check:** Def 2 raw (last_year ≥ 2020) was the original plan formulation but **mostly captures late entrants, not exiters**. The attrition_by_year table reveals 730 of 951 farms with `n_years < 5 & last_year = 2022` are **incomplete observations starting LATER than 2018**, not exits. The corrected **Def 2′** restricts `last_year ∈ {2020, 2021}` to isolate true policy-era exiters (observed at least once during 2020-2021 then dropped before 2022). Spec §6 should adopt Def 2′ as the headline policy-era exit definition.

---

## 2. Attrition timing (treated vs control)

| last_year | n (control) | n (treated) | Total | Treated share | Phase |
|---:|---:|---:|---:|---:|---|
| 2018 | 133 | 106 | 239 | 44.4% | Pre-policy attrition (2018-only) |
| 2019 | 104 | 103 | 207 | 49.8% | Pre-policy attrition |
| 2020 | 68 | 60 | 128 | 46.9% | Policy-era exit (yr 1) |
| 2021 | 52 | 41 | 93 | 44.1% | Policy-era exit (yr 2) |
| 2022 | 452 | 278 | 730 | 38.1% | **Late entrants** (n<5 but last=2022 → started after 2018) |
| **Pre-2020 exit (2018-2019)** | **237** | **209** | **446** | **46.9%** | **Treated +10.2 pp vs overall** |
| **Policy-era exit (2020-2021)** | **120** | **101** | **221** | **45.7%** | **Treated +9.0 pp vs overall** |

**Interpretation:**

- Pre-2020 treated attrition skew is **+10.2 pp** (consistent with hypothesis: small farms drop FHES surveys at higher rates for non-policy reasons — subsistence farmers, elderly, low-engagement).
- Policy-era (2020-2021) treated attrition skew is **+9.0 pp** — **similar magnitude to pre-2020**. This is the key finding for spec framing.
- Late-entrant skew (last_year=2022, n<5) is **+1.4 pp** — essentially balanced. These farms are NOT exiters; they should be excluded from any exit_indicator definition.

**Implication for the existing P3b-1 result (β = +0.1517 in `ch3_exit`):** The baseline exit indicator (Def 1) lumps together pre-policy attrition (446 farms, mostly contamination), late entrants (730 farms, NOT exits), and policy-era exit (221 farms). The +0.1517 is therefore a **composite that mostly reflects late-entrant noise + baseline small-farm survey churn**, not policy-induced exit.

---

## 3. 2018-only farm profile

| Statistic | Value | Compare to |
|---|---:|---|
| n_total | 239 | 6.6% of 3,614 farms |
| n_treated | 106 | — |
| share_treated | 44.4% | Overall 36.7% → **+7.7 pp over-representation** |
| mean own_share (2018) | 0.623 | Sample overall ~0.70 (per P3b-2 own_share distribution) |
| mean area_2018 (m²) | 12,078 | Treated must be ≤ 5,000 by construction; weighted average pulled up by 56% control farms with larger areas |
| share full-time (type_fulltime==1) | 50.6% | Below typical full-time rate ~65% — 2018-only farms are **disproportionately part-time / subsistence** |

**Interpretation:** 2018-only attriters are systematically:

- More treated (small) than overall (44.4% vs 36.7%)
- Slightly lower own_share than typical
- Less likely to be full-time farmers

This is the **signature of pre-policy panel churn driven by survey-engagement attrition, not policy response**. None of these 239 farms were exposed to PIDPS-SFFP, so any treated-control imbalance among them is by construction unrelated to policy effect.

> **Note on prior estimate:** A previous exploration hypothesized "382 farms 2018 only." Actual count from this sanity check is **239**. The discrepancy was an estimation error in the earlier text; this number (239) is the verified value to use going forward.

---

## 4. Definition recommendation for spec

**Headline (Def 2′):** Policy-era exit = `n_years < 5 & last_year ∈ {2020, 2021}`. N = 221 (101 treated, 120 control).

- Pro: isolates farms observed during policy era then dropped — true "exit response"
- Pro: excludes 730 late entrants (last_year=2022, n<5) which are NOT exits
- Con: N = 221 → moderate power for narrow-bandwidth (T1) RD; sufficient for T2/T3

**Sensitivity ladder (Defs 1, 2 raw, 4):** Report all four alongside Def 2′ for transparency. Each tests a different attrition definition.

**Def 3 (dynamic hazard, optional SHOULD):** Discrete-time hazard panel feasible since all 1,397 attriters have known last_year. Cox or cloglog model can include time-varying covariates. However, the late-entrant contamination (730 farms) requires careful sample restriction in the hazard model too (e.g., only farms with `first_year == 2018` enter the risk set from year 2018). Demote to S2 (SHOULD, not MUST).

---

## 5. Risk flags for Phase 1 (full estimation)

### Flag 1 (MEDIUM-HIGH) — Pre-2020 attrition contamination confirmed

Treated farms drop FHES surveys at +10.2 pp higher rate than control even **before** any policy exposure. Any unconditional exit estimate (Def 1) will include this baseline imbalance.

**Mitigation in spec:** DiD specification compares pre/post change in attrition rates by treatment status. The differential pre-trend (treated +10.2 pp baseline drop) must be netted out. If DiD post-period coefficient β < pre-period baseline → policy-era effect distinct from baseline; if β ≈ pre-baseline → no additional policy effect on exit. Spec §7 should require both period dummies AND interaction estimable.

### Flag 2 (MEDIUM) — Def 2 raw mostly captures late entrants

730 of 951 Def 2 raw farms are late entrants (last_year=2022, n<5), not exiters. **Adopt Def 2′ (last_year ∈ {2020, 2021}) as headline.** Update spec §6 to reflect this correction.

### Flag 3 (LOW) — Hazard model thin tails (Def 3)

221 policy-era events distributed over 2 years means ~110 events per discrete-time period. For Cox model with several covariates, this is feasible but SE will be wide. Spec demotes hazard to S2 SHOULD.

### Flag 4 (LOW) — Survey-engagement vs farm-dissolution measurement

FHES attrition could be (a) genuine farm exit (closure), (b) survey refusal / non-response, (c) ineligibility (e.g., farm size changes). The data cannot distinguish. **Spec §9 limitations paragraph must note this.** A future robustness using APCS land-transaction registers (currently deferred per MEMORY [LEARN:cross-artifact]) could pin down (a).

### Flag 5 (HIGH-INFORMATIONAL) — Scenario classification implications

Given +9.0 pp policy-era skew is similar magnitude to +10.2 pp pre-policy skew, **Scenario β (mixed evidence) is the most likely outcome** for Phase 1 full estimation:

- If DiD pre-period coefficient ≈ +0.10, post-period coefficient ≈ +0.10 → **no additional policy effect**, +0.1517 is baseline attrition tendency → **Channel 5 prediction effectively null, not falsified, not confirmed.** Paper §3.6bis can frame this honestly as "per-farm flat-rate does not measurably alter exit hazard above baseline survey churn." Distinct from "policy increases exit."
- Scenario α (β(exit) < 0 across all defs) appears unlikely given the data signature.
- Scenario γ (β(exit) > 0 across all defs even after pre-trend correction) requires post-period to exceed pre-period systematically — current data does not yet rule this in or out.

**Bottom line:** Phase 1 DiD specification with pre-trend control is required to distinguish baseline attrition from policy effect. The spec already requires this (M1 explicitly mentions "baseline gap 분리").

---

## Cross-refs

- Spec (DRAFT): `../../quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md` §8 cites this file
- Plan: `../../quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md`
- Existing P3b-1 result: `../../scripts/R/_outputs/channels_results.rds$ch3_exit` (β = +0.1517, p = 0.039)
- Channel 5 sub-model: conversation §3.6bis sketch (this session)
