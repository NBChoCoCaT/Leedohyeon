# Requirements Specification: P3c — Channel 4 vs Channel 5 Empirical Decomposition

**Date:** 2026-05-15
**Status:** APPROVED (Dohyeon, 2026-05-15; Plan A — Empirics-first, advisor consultation ~2026-07-24)
**Plan:** `quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md` (sister: `~/.claude/plans/inherited-knitting-sutton.md`)
**Pre-validation evidence:** `explorations/2026-05-15_p3c-precheck/findings.md` (Phase 0 completed 2026-05-15)
**Predecessor:** P3b-1/P3b-2 channel decomposition (`c296ff9`, 2026-05-18, origin/main sync)
**Author:** Lee, Dohyeon (Claude assist)
**Mode:** manual approval, plan-first

---

## 1. Objective

Lock in the empirical specification that separates **Channel 4 (Tenant-Driven Extensive Margin Land Transition within survivors)** from **Channel 5 (Exit Deterrence selection)** in the AHM-based 5-channel framework, before option A (paper §3 LaTeX draft) entry. The spec resolves the sign-flip risk on the existing P3b-1 exit coefficient (`ch3_exit` β = +0.1517, p = 0.039 — opposite of Channel 5 prediction β(exit) < 0) by introducing a **multi-definition robustness ladder** (4 exit definitions) + **scenario α/β/γ decision tree** (theory confirmed / mixed / falsified), with pre-trend control DiD specifications that net out baseline small-farm attrition.

**Success endpoint:** spec APPROVED + 4-definition R estimation results + scenario classification → paper §3.6bis (Channel 5 sub-model) is either retained, qualified with limitations, or rewritten with alternative narrative. Phase 1 (full estimation) is a **separate plan-mode entry**; this spec is the contract for that work.

---

## 2. Theoretical Anchor

### 2.1 5-Channel AHM (this session, conversation §3 sketch)

```
Singh–Squire–Strauss (1986) AHM baseline
   │   completeness → separability → β = 0 (H₀)
   ▼
de Janvry–Fafchamps–Sadoulet (1991) non-separable extension
   │   one or more market imperfections bite
   ▼
┌── Intensive margin ─────────────────────────────────────┐
│ Ch1 (Main): (S,s) lumpy investment   Caballero–Engel 99 │
│ Ch2 (Aux):  Precautionary off-farm    Sandmo 1971       │
│ Ch3 (Aux):  Consumption smoothing     Blundell–P. 2003  │
└─────────────────────────────────────────────────────────┘
┌── Extensive margin & land tenure ───────────────────────┐
│ Ch4 (P3b-2 core): Tenant-Driven Land Transition         │
│   (i) Bargaining     unit_rent ↓                        │
│   (ii) Composition   A_rent ↓, mono in −s_0             │
│   (iii) Land pivot   A_own ↑ | survive, mono in −s_0    │
│ Ch5 (P3c core):  Exit Deterrence                        │
│   (a) exit_indicator ↓, mono in −s_0                    │
│   (b) A_total ↑ uncond = (iii) + selection bias         │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Channel 5 Sub-Model Recap (§3.6bis of paper)

Discrete choice each period:
- $V_{stay}(T) = E_t \sum \beta^\tau U(C_{t+\tau}, L_{\ell,t+\tau}) + \sum \beta^\tau T \mathbf{1}[D_i=1]$ (SFFP eligibility flow contingent on continued farming)
- $V_{exit} = p_{land} A_{own} + W_{nonfarm} - \Phi_{exit} - \psi_i$ (sunk transaction cost + identity loss, $\psi_i \sim G$)
- Key: $\partial V_{stay}/\partial T > 0$, $\partial V_{exit}/\partial T = 0$ (T forfeited on exit)
- **Prediction P5:** $\beta(\text{exit}) < 0$, monotone in $-s_0$ (pure tenants larger retention effect)

### 2.3 Channel 4 vs Channel 5 Identification Problem

`area_total` unconditional event-study (P3b-2: +408 m² at 2022, p=0.003) is a **composite**:
$$
\hat\lambda_{2022}^{uncond} = \underbrace{\hat\lambda_{2022}^{cond} \cdot \Pr(\text{survive})}_{\text{Channel 4(iii)}} + \underbrace{[E[A | \text{survive, treated}] - E[A | \text{survive, control}]] \cdot \Delta\Pr(\text{survive})}_{\text{Channel 5 selection}}
$$

To separate: (a) re-estimate area_total event-study **conditional on survival** (`n_years == 5L`) → Channel 4(iii) pure; (b) estimate exit DiD → Channel 5 effect; (c) decompose unconditional headline into the two.

---

## 3. Requirements

### 3.1 MUST Have (Non-Negotiable)

- [ ] **M1** — **Multi-definition exit DiD (Step 1).** Run DiD-RD on **4 exit definitions** × **3 bandwidths (T1/T2/T3)** × **2 specs (A/B)** = **24 cells** per outcome. Outcome = `exit_indicator` (cross-section per definition). RHS includes pre-period dummy + treatment × pre-period interaction to net out baseline attrition tendency (Flag 1 in `findings.md` §5). Specifically the DiD form:

  ```
  exit_i = α + β₁ D_i + β₂ Post + β₃ (D_i × Post) + γ rv_i + δ (rv_i × Post)
         + θ (D_i × rv_i × Post) + ε_i
  ```
  However exit_i is cross-sectional (per farm), so Post becomes the **last_year encoded** period and a different parameterization is needed — see §7.1 for the full specification.

- [ ] **M2** — **Conditional area_total event-study (Step 2).** Re-estimate `area_total ~ i(year, D_treat, ref=2019) | hh_id + year` **restricted to farms with `n_years == 5L`** (completers only, N = 2,217). Provides Channel 4(iii) pure extensive-margin coefficient (no selection contamination). Compare to unconditional P3b-2 estimate to quantify selection contribution to +408 m².

- [ ] **M3** — **Scenario classification α/β/γ.** After Phase 1 estimation, classify results into:
  - **α (Channel 5 confirmed):** all 4 def + Spec A T1/T2/T3 yield β(exit) < 0 with p < 0.10
  - **β (mixed evidence):** at least 1 spec yields β < 0 (p < 0.10) AND at least 1 yields β ≥ 0 (p > 0.10), OR all specs yield indistinguishable-from-zero estimates
  - **γ (Channel 5 prediction rejected):** all 4 def + Spec A yield β(exit) > 0 (any significance) OR β > 0 with p < 0.10 in headline
- [ ] **M4** — **P3b-1 reconciliation (Step 4).** Existing `ch3_exit` β = +0.1517 reframed as **Definition #1 baseline** (n_years < 5). Document that:
  - The +0.1517 absorbs pre-policy attrition contamination + late-entrant noise (per `findings.md` §2-3)
  - Headline shifts to **Definition #2′ (corrected policy-era exit, last_year ∈ {2020, 2021}, N=221)**
  - Bandwidth-tier expansion: previously MSE-only; now T1/T2/T3 parallel reporting required
- [ ] **M5** — **Pre-policy attrition profiling (Step 5).** Embed Phase 0 evidence (`findings.md`) in spec §8: 2018-only n=239, treated share +7.7 pp over overall; pre-2020 exit treated skew +10.2 pp; policy-era (2020-2021) skew +9.0 pp. Establishes that any unconditional exit estimate inherits a baseline differential that DiD with pre-trend control must net out.

### 3.2 SHOULD Have (Preferred)

- [ ] **S1** — **own_share × exit 5-bin heterogeneity (Step 1b).** Per `06_channels.R` Phase 1 convention + P3b-2 own_bin construction (pure_tenant / low_owner / mixed / high_owner / pure_owner, ref = pure_owner). Interaction spec:
  ```
  exit ~ i(own_bin, D_Post, ref="5_pure_owner") + rv_Post + Drv_Post | hh_id + year
  ```
  Predicted: pure_tenant β most negative; pure_owner ≈ 0 (Channel 5 §3.6bis.5 monotone-in-$s_0$ prediction). 5 bins × headline spec (Def 2′, Spec A, T2) = 5 cells minimum; expand to 4 definitions × 5 bins = 20 cells for robustness.
- [ ] **S2** — **Discrete-time hazard model.** Cox / cloglog on year-by-year exit panel:
  ```
  cloglog: h_it = Pr(exit_t | survive to t−1) = Λ(β_h D_i × Post_t + γ X_i + ...)
  ```
  Restrict risk set to farms with `first_year == 2018` (forces all farms to be at risk from 2018), avoiding the late-entrant contamination noted in `findings.md` §1. Demoted to SHOULD per data thinness (Flag 3 in findings.md: 221 events over 2 years → wide SE).
- [ ] **S3** — **Treated × control attrition rate difference balance test (Step 5b).** Formalize the year-by-year attrition rate gap as a balance test artifact, reportable in paper online appendix.

### 3.3 MAY Have (Optional, If Time)

- [ ] **A1** — Sub-district `sgg_cd` cluster robustness on exit DiD. Currently DEFERRED per MEMORY [LEARN:cross-artifact] (APCS linkage pending). Note presence in spec for future R&R; do NOT block Phase 1 on this.
- [ ] **A2** — **Triple interaction Ch4 × Ch5.** `area_own × (D × Post × exit_def2')` triple interaction within survivors-only subset. Tests whether Channel 4(iii) extensive margin is itself heterogeneous by exit-vulnerability status. Higher-order, defer to advisor consultation.
- [ ] **A3** — Demographics × exit (age, type_fulltime) heterogeneity. Aligned with P3b-4 (5×4 demographic heterogeneity) — share infrastructure with that script; not Phase 1 critical.

### 3.4 REJECTED (with reason)

- [ ] **R1** — **`post_exit_it` as outcome variable.** Construction `post_exit_it = 1 if year > last_observed_year & last_observed_year < 2022` is **mechanically NA after exit** — outcomes (y_it) undefined for years a farm did not appear. Logically invalid as DV; would generate NaN rows that confuse interpretation. Per Explore Agent 2 Option C analysis (this session).
- [ ] **R2** — **Unbalanced full-panel `exit = 1[n_years < 5]` as sole headline (i.e., the existing P3b-1 spec retained).** Sub-claim: keep ch3_exit β = +0.1517 as the paper headline. **Rejected** because:
  - 730/1397 (52%) of incomplete farms are **late entrants** (last_year=2022, n<5), not exiters (per `findings.md` §2)
  - Pre-policy attrition (446 farms) absorbed without correction → baseline-attrition bias
  - Bandwidth specification was MSE-only; no T1/T2/T3 parallel reporting → inconsistent with project standard
  - Cross-sectional RD on collapsed per-farm summary ignores DiD pre-trend identification
  - Replaced by Def 2′ as headline + Defs 1/2-raw/3/4 as robustness ladder per M1.

---

## 4. Clarity Status

| Aspect | Status | Notes |
|---|---|---|
| 4 exit definitions inventory | CLEAR | Def 1/2/2′/3/4 specified in §6 |
| Def 2′ correction (exclude late entrants) | CLEAR | Sanity-check surfaced; user-locked B+C framing accommodates |
| Scenario α/β/γ thresholds | CLEAR (revised) | M3 explicit p<0.10 & sign criteria |
| Headline definition | CLEAR | Def 2′ per `findings.md` §4 + plan §"Sanity check" |
| Conditional event-study sample | CLEAR | `n_years == 5L` filter, N=2,217 |
| own_share bin construction | CLEAR (reuse P3b-2) | 5 bins, ref = pure_owner, 2018-baseline fixed |
| Pre-trend DiD parameterization | ASSUMED | §7.1 sketch; user can override exact spec at Phase 1 |
| Late entrant treatment | CLEAR | Excluded from all 4 def by construction (Def 2′ corrects raw Def 2) |
| Hazard model risk-set restriction | CLEAR | `first_year == 2018` only (avoid late entrants in hazard) |
| Channel 4 vs Channel 5 algebraic decomposition | CLEAR | §2.3 formula |
| Cluster level | CLEAR | `~hh_id`; sgg_cd deferred (A1) |
| Wild bootstrap on exit | ASSUMED — DEFER to S1 of Phase 2 | not in Phase 1 scope; CR1 SE primary |
| Phase 1 invocation timing | CLEAR | After spec sign-off; new plan-mode entry |
| Result interpretation for Scenario β | ASSUMED | Paper §3.6bis qualified with limitations §7; spec §9 frames expected paper edits |
| Theoretical recovery if Scenario γ | CLEAR (Option C in user framing) | "per-farm flat-rate fails to deter exit" alternative narrative; §3.6bis rewrite required |

**No BLOCKED entries.**

---

## 5. Decision Matrix

### 5.1 Cell Map (Phase 1 estimation universe)

| Definition | Spec A | Spec B | T1 (h=500) | T2 (h=1000) | T3 (MSE) | Headline cell |
|---|:--:|:--:|:--:|:--:|:--:|:--:|
| Def 1 (n<5 baseline) | ✓ | ✓ | ✓ | ✓ | ✓ | A T2 (reconcile w/ existing ch3_exit) |
| **Def 2′ (policy-era exit corrected)** | ✓ | ✓ | ✓ | ✓ | ✓ | **A T2 ← HEADLINE** |
| Def 2 raw (last_year ≥ 2020) | ✓ | ✗ | ✓ | ✓ | ✓ | sensitivity only |
| Def 3 (dynamic hazard, cloglog) | ✓ | ✗ | ✗ | ✗ | ✗ | hazard model, no bandwidth tier |
| Def 4 (completer, complement of Def 1) | ✓ | ✓ | ✓ | ✓ | ✓ | A T2 (mirror Def 1 with opposite sign) |

**Total Phase 1 cell count:** 4 × 2 × 3 = 24 (DiD bandwidth tiers) + 1 hazard model + 5×4 = 20 heterogeneity (S1) = **45 cells** plus 1 conditional event-study (M2).

### 5.2 Scenario × Paper Implication

| Scenario | Spec output pattern | Paper §3.6bis status | Paper §7 limitations | Submission impact |
|---|---|---|---|:--:|
| **α (confirmed)** | All Def, Spec A, T1/T2/T3 yield β(exit) < 0 with p<0.10 | Retain as-is | Standard caveats (FHES survey churn ≠ administrative exit) | AJAE direct unchanged |
| **β (mixed)** | At least 1 def β < 0 (p<0.10) AND at least 1 β ≥ 0 (p>0.10) | Qualify: "Effect detected in headline Def 2′ T2 but not robust across all attrition definitions; sensitivity reported in appendix" | Add paragraph: "The +0.1517 cross-sectional estimate (Def 1) absorbs baseline survey attrition; DiD with pre-trend control isolates policy effect at [magnitude]" | AJAE-attemptable but R&R likely on this point |
| **γ (rejected)** | All Def, Spec A yield β(exit) > 0 with p<0.10 | **Rewrite §3.6bis** as "per-farm flat-rate fails to deter exit" — alternative AHM channel 5: SFFP eligibility imposes net compliance burden on small farms exceeding the 1.2M KRW transfer value | Add paragraph: "Contrary to theoretical prediction, treated farms exhibit higher exit rates. We interpret this through the lens of compliance cost (Δ): for small farms with high subsistence component, SFFP eligibility requirements (income reporting, area documentation, residency declarations) impose effort cost exceeding T_SFFP, generating selection on exit. Public-finance literature parallel: Saez (2002), Currie (2006)." | Still AJAE-attemptable — honest negative result with substantive policy implication; possibly stronger Food Policy fit |

---

## 6. Variable Construction (R verbatim)

All constructions are LOCAL to Phase 1 analysis script (`scripts/R/06_channels.R` Phase 2 EXTENSION). **No edits to `01_clean.R`**; no new columns pushed to `clean.rds` yet.

### 6.1 Per-farm summary

```r
farm <- df |>
  group_by(hh_id) |>
  summarise(
    n_years     = dplyr::n(),
    first_year  = min(year),
    last_year   = max(year),
    D_treat     = first(D_treat),
    rv_2018     = first(rv_2018),
    own_share_0 = mean(own_share[year == 2018L], na.rm = TRUE),
    area_2018   = first(area_2018),
    .groups     = "drop"
  )
```

### 6.2 Four exit definitions

```r
farm <- farm |>
  mutate(
    # Def 1 — baseline: ever incomplete (existing ch3_exit definition)
    exit_def1 = as.integer(n_years < 5L),

    # Def 2 raw — original plan: incomplete with last obs in policy era (INCLUDES late entrants)
    exit_def2_raw = as.integer(n_years < 5L & last_year >= 2020L),

    # Def 2′ — corrected: dropped DURING policy era (excludes late entrants with last_year=2022)
    exit_def2_corrected = as.integer(n_years < 5L & last_year %in% c(2020L, 2021L)),

    # Def 3 — dynamic last_year for hazard model
    exit_def3_last_year = last_year,

    # Def 4 — completer (complement of Def 1, for symmetric reporting)
    exit_def4_completer = as.integer(n_years == 5L)
  )
```

### 6.3 own_bin (reuse P3b-2 construction)

```r
farm <- farm |>
  mutate(
    own_bin = case_when(
      own_share_0 == 0     ~ "1_pure_tenant",
      own_share_0 <  0.3   ~ "2_low_owner",
      own_share_0 <  0.7   ~ "3_mixed",
      own_share_0 <  1     ~ "4_high_owner",
      own_share_0 == 1     ~ "5_pure_owner",
      TRUE                  ~ NA_character_
    ) |> factor(levels = c("1_pure_tenant","2_low_owner","3_mixed","4_high_owner","5_pure_owner"))
  )
```

### 6.4 Hazard panel (for Def 3 / S2)

```r
hazard_panel <- df |>
  filter(hh_id %in% farm$hh_id[farm$first_year == 2018L]) |>   # risk-set restriction
  group_by(hh_id) |>
  arrange(year) |>
  mutate(
    next_year_observed = lead(year, default = NA_integer_),
    exit_event = as.integer(is.na(next_year_observed) & year < 2022L)
  ) |>
  ungroup() |>
  filter(!is.na(exit_event))
```

---

## 7. R Spec Mapping

### 7.1 Step 1 — Cross-section exit DiD (M1)

Since `exit_def*` is per-farm cross-sectional, the "DiD" form uses 2018-baseline-fixed treatment + per-definition exit. Two estimation forms (use both, report side-by-side):

**Form A — RDD on per-farm exit indicator (parallel to existing ch3_exit, with bandwidth tiers):**
```r
# Per (def × spec × bandwidth):
sub <- farm |> filter(abs(rv_2018) <= h)
rd_fit <- rdrobust::rdrobust(
  y = sub[[exit_def_col]], x = sub$rv_2018, c = 0, p = 1,
  h = c(h, h), masspoints = "off"
)
# Report: est, se, p, n_obs, h_l
```

**Form B — DiD-style with pre/post split using last_year decomposition (Def 1 + Def 2′ only):**

Define `pre_exit_i = 1[last_year < 2020 & n_years < 5]` (pre-policy attrition) and `post_exit_i = exit_def2_corrected` (policy-era exit). Then:
```r
# Stack pre/post as a 2-period mini-panel per farm
df_did <- bind_rows(
  farm |> transmute(hh_id, rv_2018, D_treat, period = "pre",  exit = pre_exit_i),
  farm |> transmute(hh_id, rv_2018, D_treat, period = "post", exit = post_exit_i)
)
fit <- feols(exit ~ D_treat * (period == "post") + rv_2018 * (period == "post"),
             data = df_did |> filter(abs(rv_2018) <= h), cluster = ~hh_id)
# Coefficient on D_treat:periodpost = differential policy-era exit net of pre-policy baseline
```

Form B is the **headline causal estimate**; Form A provides direct comparability to the existing ch3_exit. Report both in paper §6.

### 7.2 Step 1b — own_share × exit heterogeneity (S1)

```r
# Per (def × bandwidth), use Form A with own_bin interaction:
sub <- farm |> filter(abs(rv_2018) <= h, !is.na(own_bin))
# rdrobust does not support interaction directly; use feols cross-section with rv linear
fit_het <- feols(
  exit_def2_corrected ~ i(own_bin, D_treat, ref = "5_pure_owner") + rv_2018,
  data = sub, cluster = ~hh_id
)
# 5 own_bin × β coefficients; test pure_tenant β < pure_owner β monotone-in-(-s_0)
```

### 7.3 Step 2 — Conditional area_total event-study (M2)

```r
# Restrict to completers (Def 4 = 1)
df_cond <- df |> filter(hh_id %in% farm$hh_id[farm$exit_def4_completer == 1L])

# Per bandwidth h ∈ {500, 1000, 3300}:
sub <- df_cond |> filter(abs(rv_2018) <= h)
fit_event <- feols(
  area_total ~ i(year, D_treat, ref = 2019) | hh_id + year,
  data = sub, cluster = ~hh_id
)
# Extract: λ_2018, λ_2020, λ_2021, λ_2022 + SE per bw
# Compare to existing unconditional ch3_area_events for the same cells
```

**Decomposition reporting (§3.6.6 paper-level):**
```r
lambda_2022_uncond <- ch_area_events |> filter(year == 2022L, bw == "T3") |> pull(est)  # = +408
lambda_2022_cond   <- fit_event_T3$coefficients["year::2022:D_treat"]
selection_share    <- 1 - (lambda_2022_cond / lambda_2022_uncond)
# Report: conditional λ + selection share
```

### 7.4 Step 3 — Hazard model (S2)

```r
# Pooled cloglog discrete-time hazard
library(survival)
fit_cox <- coxph(Surv(year - 2018, exit_event) ~ D_treat * (year >= 2020L) + rv_2018,
                 data = hazard_panel, cluster = hh_id)
summary(fit_cox)
# OR cloglog:
fit_cloglog <- glm(exit_event ~ D_treat * (year >= 2020L) + rv_2018 + factor(year),
                   family = binomial(link = "cloglog"), data = hazard_panel)
```

### 7.5 Step 4 — P3b-1 reconciliation (M4)

```r
# Recompute the existing ch3_exit β=+0.1517 with new bandwidth tiers
# Display side-by-side with Def 2′ headline:
reconcile_tbl <- tibble(
  spec = c("Existing ch3_exit (MSE)", "Def 1 T1", "Def 1 T2", "Def 1 T3",
           "Def 2′ T1", "Def 2′ T2 [HEADLINE]", "Def 2′ T3"),
  est  = c(0.1517, NA, NA, NA, NA, NA, NA),   # NA filled by Phase 1 run
  se   = c(0.0736, NA, NA, NA, NA, NA, NA),
  p    = c(0.0394, NA, NA, NA, NA, NA, NA),
  n    = c(900,    NA, NA, NA, NA, NA, NA)
)
```

### 7.6 No STATA verbatim mapping

Channels 5 is R-only — no STATA term-paper precedent. Replication-protocol Phase 3 anchor is **internal R-only consistency** (re-run gives same numbers per `set.seed(20260504)`). Document as R-only cells in `replication_check.txt`.

---

## 8. Pre-Validation Evidence

Source: `explorations/2026-05-15_p3c-precheck/findings.md` (Phase 0 sanity check, `check.R` runtime ≈ 10s, 2026-05-15).

### 8.1 Definition feasibility (key counts)

| Definition | N | Treated share | Δ vs overall (36.7%) |
|---|---:|---:|---:|
| Def 1 baseline | 1,397 | 42.1% | +5.4 pp |
| **Def 2′ corrected** | **221** | **45.7%** | **+9.0 pp** |
| Def 2 raw (incl. late entrants) | 951 | 39.9% | +3.2 pp |
| Def 4 completer | 2,217 | 33.2% | −3.5 pp |

### 8.2 Attrition timing signature (Form B pre/post split)

| Period | n | Treated share | Note |
|---|---:|---:|---|
| Pre-2020 exit (2018-2019) | 446 | 46.9% | **Baseline +10.2 pp skew** |
| Policy-era exit (2020-2021) | 221 | 45.7% | **+9.0 pp skew, similar to baseline** |
| Late entrants (last=2022, n<5) | 730 | 38.1% | +1.4 pp (balanced; excluded from Def 2′) |

### 8.3 2018-only farm profile

n = 239; share_treated = 44.4% (vs overall 36.7%); mean own_share = 0.62; mean area = 12,078 m² (weighted by control farms); 50.6% full-time. **Signature: small, part-time, low-engagement farms drop FHES early for non-policy reasons.**

### 8.4 Interpretation — flag for paper §3.6bis

**Most likely Phase 1 scenario: β (mixed evidence).** Treated-control attrition skew is **similar magnitude pre-policy (+10.2 pp) and policy-era (+9.0 pp)**. DiD difference-in-difference coefficient on `D × Post` (Form B in §7.1) is therefore expected to be **small and possibly statistically insignificant**, in either direction. Neither α (confirmed) nor γ (rejected) is the likely outcome.

**Spec §9 success criteria therefore prioritize the β path** as most likely, while preserving α/γ paths for completeness.

---

## 9. Success Criteria

### 9.1 Spec sign-off (this artifact)

- [ ] User reviews §3 requirements and explicitly approves MUST M1-M5
- [ ] User reviews §5 decision matrix and confirms scenario thresholds
- [ ] User reviews §8 pre-validation findings and accepts Def 2′ as headline
- [ ] Spec status → APPROVED in §11

### 9.2 Phase 1 deliverables (next plan-mode entry, after sign-off)

- [ ] All 24 Step 1 cells estimated, results in `channels_results.rds$ch5_exit_did`
- [ ] Step 1b heterogeneity 20 cells in `channels_results.rds$ch5_exit_het`
- [ ] Step 2 conditional event-study in `channels_results.rds$ch4_area_conditional` with selection decomposition
- [ ] Step 3 hazard (S2) in `channels_results.rds$ch5_hazard` IF S2 elected; ELSE flag as deferred
- [ ] Step 4 reconciliation table in `tab_ch5_reconciliation_{en,ko}.tex`
- [ ] Scenario α/β/γ classification documented in commit message

### 9.3 Paper §3.6bis status post-Phase 1

- **α path:** §3.6bis retained verbatim from sketch
- **β path:** §3.6bis retained + §7 limitations paragraph added; §6 results section reports headline + ladder
- **γ path:** §3.6bis rewritten with alternative narrative (compliance cost mechanism); option A timeline extended +5–7 days for theory rewrite

### 9.4 Decision endpoint

After Phase 1: user + (optional) advisor consultation locks paper §3 narrative shape. Option A (paper §3 LaTeX) entry conditional on this lock.

---

## 10. Cross-References

- **Plan:** `quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md` (sister: `/Users/leedo/.claude/plans/inherited-knitting-sutton.md`)
- **Pre-validation:** `explorations/2026-05-15_p3c-precheck/check.R`, `findings.md`, `_outputs/*.csv`
- **Session log:** `quality_reports/session_logs/2026-05-15_p3c-spec.md`
- **Existing implementation:** `scripts/R/06_channels.R` Phase 2 (lines 191–266); outputs `channels_results.rds$ch3_exit` + `ch3_area_events`; tables `tab_ch3_retention_{en,ko}.tex`
- **Predecessor plan:** `quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md` (P3b series)
- **Theory anchors:** Singh-Squire-Strauss (1986) AHM; de Janvry-Fafchamps-Sadoulet (1991); Kimhi (2000) AJAE 82(1); Pietola, Vare, Oude Lansink (2003) ERAE 30(1); Foltz (2004) AJAE 86(3); Kazukauskas, Newman, Sauer (2013); Mishra (2010) — exit literature; Kang (2025) — Korean smallholder retention (user-requested addition)
- **Channel 5 sub-model:** conversation §3.6bis sketch this session (2026-05-15)
- **R conventions:** `.claude/rules/r-code-conventions.md` §10 (rename map), §11 (cluster = hh_id), §12 (figure output)
- **Replication protocol:** `.claude/rules/replication-protocol.md` Phase 3 (R-only cells; no STATA anchor for Ch5)
- **Quality gates:** `.claude/rules/quality-gates.md` (Phase 1 commit gate 80; first submission 90)
- **MEMORY.md:** [LEARN:harness] 2026-05-06 (sister-file pattern); [LEARN:cross-artifact] 2026-05-06 (sgg_cd APCS deferral); [LEARN:methods] 2026-05-06 (variable mapping panel_2018_2022.dta verification)

---

## 11. Approval

- **Drafted:** 2026-05-15 (Claude assist, plan-first workflow + AskUserQuestion clarifications + Phase 0 sanity check)
- **Reviewed:** Lee, Dohyeon — Plan A (Empirics-first, 10–12주); advisor consultation deferred to ~2026-07-24 post paper-draft.
- **Status:** **APPROVED** (Dohyeon, 2026-05-15)
- **Next gate:** Phase 1 (full multi-definition estimation) — new plan-mode entry this session.

[x] User approved (date): 2026-05-15
[x] Phase 1 plan-mode entry (date): 2026-05-15

---

## Appendix A — Open Questions Resolution Trail

| OQ | Question | Resolution | Source |
|---|---|---|---|
| Q1 | Exit framing single vs robustness ladder | B + C hybrid (4 defs ladder + α/β/γ tree) | User answer, this session |
| Q2 | Pre-validation scope | Minimal sanity check, no regression | User answer, this session |
| Q3 | Heterogeneity in spec | Step 1b, separate from headline Step 1 | User answer, this session |
| Q4 | Sign-flip on existing ch3_exit +0.1517 | Pre-policy contamination + late entrants → not directly comparable to theory; new Def 2′ headline | Phase 0 sanity check, this session |
| Q5 | 382 vs 239 2018-only farms | Verified: 239 (Phase 0); prior 382 estimate was wrong | check.R output, this session |
| Q6 | Def 2 raw inclusion of late entrants | Confirmed: 730/951 are late entrants, not exiters → Def 2′ correction | findings.md §1 + §2 |
| Q7 | Hazard model feasibility (Def 3) | 221 events / 2 policy years → feasible but wide SE; demoted SHOULD | findings.md Flag 3 |
| Q8 | Cluster level (hh_id vs sgg_cd) | hh_id primary; sgg_cd deferred per MEMORY [LEARN:cross-artifact] | MAY A1 |
| Q9 | Pre-trend DiD parameterization (Form A vs Form B) | Both reported; Form B = headline causal | §7.1 |

## Appendix B — File Coverage

| File | Lines | Purpose |
|---|---|---|
| `scripts/R/06_channels.R` (Phase 2) | 191-266 | Existing retention block to EXTEND (Phase 1, separate plan-mode) |
| `scripts/R/_outputs/channels_results.rds` | — | Add `ch5_exit_did`, `ch5_exit_het`, `ch4_area_conditional`, `ch5_hazard` |
| `scripts/R/_outputs/tab_ch5_reconciliation_{en,ko}.tex` | — | NEW (Phase 1) |
| `paper/en/main.tex` §3.6bis | — | Depends on scenario classification (α/β/γ) outcome of Phase 1 |
| `explorations/2026-05-15_p3c-precheck/` | — | Phase 0 evidence (this spec §8) |
