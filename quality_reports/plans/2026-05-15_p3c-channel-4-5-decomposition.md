# Plan — P3c Spec: Channel 4 vs Channel 5 Empirical Decomposition (+ Minimal Sanity Check)

**Status:** APPROVED (Dohyeon, 2026-05-15)
**Date:** 2026-05-15
**Author:** Lee Dohyeon (Claude assist)
**Sister (post-approval):** `01_dissertation_PBDP/quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md` (identical content per [LEARN:harness] 2026-05-06)

---

## Context

P3b series complete (`c296ff9`, 2026-05-18, origin/main sync). Theory side extended this session from (S,s) single anchor to **AHM-based 5-channel model** (Channels 1–4 + new Channel 5 exit deterrence). Channel 5 sub-model sketched in conversation; user approved framing and the work order **C → A → D → B** (this plan covers **C**).

**Critical exploration finding (this session, both Explore agents):**

1. Existing `06_channels.R` Phase 2 already constructs `exit_indicator = 1[n_years < 5]` and saves `ch3_exit` to `channels_results.rds` with β = +0.1517 (SE 0.0736, p = 0.0394, h_mse = 1,955.79, N = 900). **Interpretation: treated farms exit MORE — OPPOSITE sign from Channel 5 prediction β(exit) < 0.**
2. Of 3,596 missing farm-years (19.9% of 18,070 = 3,614 × 5), the vast majority are **pre-policy attrition** (382 farms observed in 2018 only). Only ~165 farms exit in the policy era (2020–2022). The +0.1517 is plausibly contaminated by survey-design / early-FHES dropout that has no causal relationship to PIDPS-SFFP.
3. `ch3_area_events` event-study (`area_total` +408 m² at 2022) is currently **unconditional on survival** — N stable across years per Phase 2 comment. So the +408 m² is a **composite of Channel 4(iii) extensive margin within survivors + Channel 5 retention selection**. Decomposition required.

Without P3c, the user cannot enter option A (LaTeX paper draft, §3 theory section) confident that Channel 5 prediction holds. If +0.1517 reflects truth (not contamination), §3.6bis must be rewritten — better to discover this BEFORE committing the paper narrative.

## User-locked spec framing (resolved via AskUserQuestion this session)

- **Framing: B + C hybrid** — multi-definition robustness ladder (4 exit definitions × DiD) + scenario α/β/γ decision tree (theory holds / mixed / falsified).
- **Pre-validation scope: minimal sanity check only** — construct definitions, report N + distributions; **no regression yet** (full estimation = Phase 1 of a separate later plan-mode entry).
- **Heterogeneity: included but separated as Step 1b** (own_share × exit, 5 bins).

## Deliverables (~3.5h total)

| # | Path | Action | Lines | Time |
|---|---|---|---|---|
| 1 | `01_dissertation_PBDP/quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md` | **CREATE** | ~600 | 2.0h |
| 2 | `01_dissertation_PBDP/explorations/2026-05-15_p3c-precheck/check.R` | **CREATE** | ~50 | 0.5h |
| 3 | `01_dissertation_PBDP/explorations/2026-05-15_p3c-precheck/findings.md` | **CREATE (post Rscript run)** | ~80 | 0.5h |
| 4 | `01_dissertation_PBDP/explorations/2026-05-15_p3c-precheck/_outputs/*.csv` | **CREATE (runtime)** | data | runs in #2 |
| 5 | `01_dissertation_PBDP/quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md` | **CREATE (sister)** | identical to this plan | 0.1h |
| 6 | `01_dissertation_PBDP/quality_reports/session_logs/2026-05-15_p3c-spec.md` | **CREATE** | grows during work | 0.4h |

**Explicitly NOT in scope** (defer to later plan-mode entries):

- `scripts/R/06_channels.R` Phase 1 work (full multi-definition estimation, conditional event-study) → next plan-mode after spec approval.
- `scripts/R/01_clean.R` edits (no `policy_era_exit` variable added to clean.rds yet; sanity check uses local mutation in `check.R`).
- `CLAUDE.md` / `MEMORY.md` updates (defer until P3c results lock framing).
- Paper §3 LaTeX (option A; gated by P3c outcome).

## Spec structure (`2026-05-15_p3c-channel-4-5-decomposition.md`)

Follows `templates/requirements-spec.md` + `2026-05-07_outlier-policy.md` precedent (10–11 sections, MUST/SHOULD/MAY + Clarity Status + Decision Matrix + R Spec + Success Criteria + Approval).

```
§1 Objective
§2 Theoretical Anchor (AHM 5-channel; Ch4 vs Ch5 separation logic; user-locked Channel 5 sub-model recap)
§3 Requirements
   MUST:
     M1 — Multi-definition exit DiD (4 defs × 3 bw × 2 specs = 24 cells) [Step 1]
     M2 — Conditional area_total event-study (survival-restricted Channel 4(iii) pure) [Step 2]
     M3 — Scenario classification α/β/γ with explicit thresholds [Decision Gate]
     M4 — P3b-1 reconciliation block (existing +0.1517 reframed as Definition #1 baseline) [Step 4]
     M5 — Pre-policy attrition profiling embedded (Phase 0 evidence) [Step 5 / §8]
   SHOULD:
     S1 — own_share × exit 5-bin heterogeneity (Step 1b)
     S2 — Discrete-time hazard model (Cox / cloglog)
     S3 — Treated × control attrition rate difference by year (balance test)
   MAY:
     A1 — Sub-district sgg_cd cluster robustness (APCS deferred per MEMORY [LEARN:cross-artifact])
     A2 — Triple interaction Ch4 × Ch5 (own_share × exit × outcome)
     A3 — Demographics (age / type_fulltime) × exit interaction
   REJECTED (with reason):
     R1 — `post_exit_it` as outcome (mechanically NA after exit; logically invalid per Explore Agent 2 Option C)
     R2 — Unbalanced full-panel without attrition correction (current +0.1517 unfiltered; replaced by Definition #2 policy-era as headline)
§4 Clarity Status (CLEAR / ASSUMED / BLOCKED table)
§5 Decision Matrix
   - 4 definitions × Spec A/B × T1/T2/T3 cell map
   - Scenario α/β/γ paper-implication table
§6 Variable Construction (4 exit definitions, R code verbatim — local to `check.R` only, NOT pushed to clean.rds)
§7 R Spec Mapping
   - feols(D_treat × Post + RDD interactions | hh_id + year, cluster = ~hh_id)
   - Conditional sample: dplyr::filter(n_years == 5L)
   - i(own_bin, D_Post, ref="5_pure_owner") for Step 1b
§8 Pre-Validation Evidence (sanity-check output summary; cross-reference to `explorations/.../findings.md`)
§9 Success Criteria
   - α path: paper §3.6bis intact
   - β path: limitations §7 paragraph
   - γ path: §3.6bis rewrite + alternative narrative ("per-farm flat-rate fails to deter exit" — still publishable)
§10 Cross-References
§11 Approval
```

## Sanity check scope (`explorations/2026-05-15_p3c-precheck/check.R`, ~50 lines)

**ONLY:**

```r
# Phase 0 — Pre-validation (NO regression)
library(dplyr); library(readr)
df <- readRDS("scripts/R/_outputs/clean.rds")

# Per-farm summary
farm <- df |> group_by(hh_id) |> summarise(
  n_years     = n(),
  first_year  = min(year),
  last_year   = max(year),
  D_treat     = first(D_treat),
  own_share_0 = first(own_share[year == 2018]),
  area_2018   = first(area_2018),
  age_2018    = first(age_code_base[year == 2018]),
  fulltime    = first(type_fulltime[year == 2018])
) |> ungroup()

# 4 exit definitions
farm <- farm |> mutate(
  exit_def1_baseline    = as.integer(n_years < 5L),
  exit_def2_policy_era  = as.integer(n_years < 5L & last_year >= 2020L),
  exit_def3_dynamic     = last_year,    # for hazard model (year of last obs)
  exit_def4_balanced    = as.integer(n_years == 5L)  # complement: "completer flag"
)

# Output #1 — definition cross-tab
exit_xt <- farm |> count(exit_def1_baseline, exit_def2_policy_era, D_treat)
write_csv(exit_xt, "_outputs/exit_def_distributions.csv")

# Output #2 — attrition by year (treated vs control)
attr_by_year <- farm |> filter(n_years < 5) |>
  count(last_year, D_treat) |>
  group_by(D_treat) |> mutate(share_within_treated = n / sum(n)) |> ungroup()
write_csv(attr_by_year, "_outputs/attrition_by_year.csv")

# Output #3 — 2018-only farms profile (potential pre-policy attrition signature)
profile_2018only <- farm |> filter(n_years == 1L & first_year == 2018L) |>
  summarise(
    n_total    = n(),
    n_treated  = sum(D_treat, na.rm=TRUE),
    share_treated   = mean(D_treat, na.rm=TRUE),
    mean_own_share  = mean(own_share_0, na.rm=TRUE),
    mean_area_2018  = mean(area_2018, na.rm=TRUE),
    p_fulltime      = mean(fulltime == 1L, na.rm=TRUE)
  )
write_csv(profile_2018only, "_outputs/profile_2018only.csv")

# Console summary
cat("== Definition feasibility ==\n")
cat("Def 1 (baseline n<5):       ", sum(farm$exit_def1_baseline),   "\n")
cat("Def 2 (policy-era):         ", sum(farm$exit_def2_policy_era), "\n")
cat("Def 3 (dynamic last_year):  ", "365-cell hazard panel feasible\n")
cat("Def 4 (balanced completer): ", sum(farm$exit_def4_balanced),   "\n")
cat("Treated rate among 2018-only:", profile_2018only$share_treated, "\n")
```

**NOT included:**

- No `rdrobust` / `feols` regression
- No SE / p-value computation
- No bootstrap
- No figure rendering
- No write to `clean.rds`

Runtime ~10s. Output: 3 CSV + console summary.

## `findings.md` content scope (~80 lines, ~0.5h)

After Rscript run, write narrative summary:

```
# P3c Pre-Validation Findings (Phase 0)

## 1. Exit definition feasibility (N per def)
[table from _outputs/exit_def_distributions.csv]

## 2. Attrition timing (treated vs control)
[table from _outputs/attrition_by_year.csv + interpretation:
 - if treated > control attrition pre-2020 → +0.1517 contamination plausible
 - if balanced pre-2020 → +0.1517 may be real exit response]

## 3. 2018-only farms profile
[table from _outputs/profile_2018only.csv + interpretation:
 - if 2018-only treated share > overall treated rate (34.9%) → selection
 - if own_share / fulltime differ systematically → confound character]

## 4. Definition recommendation
- Headline: Definition #2 (policy-era exit) per user-locked framing
- Sensitivity: Definitions #1, #3, #4 for robustness ladder
- Hazard: feasible if n_post_policy_exit ≥ 100 (verified from #2)

## 5. Risk flags for Phase 1 (full estimation)
- [flag if any treated×control imbalance detected]
- [flag if N < 100 for any definition]
- [flag if 2018-only profile suggests systematic differences]
```

## Verification (after all deliverables)

```bash
# 1. Spec well-formed (section count + frontmatter)
grep -c "^## " 01_dissertation_PBDP/quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md
# Expect ≥ 11

grep "^**Status:**" 01_dissertation_PBDP/quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md
# Expect: DRAFT (changes to APPROVED on user sign-off)

# 2. Sanity check runs cleanly
cd 01_dissertation_PBDP/explorations/2026-05-15_p3c-precheck && Rscript check.R
# Expect: 3 CSV produced, console summary printed, exit 0

ls _outputs/
# Expect: exit_def_distributions.csv attrition_by_year.csv profile_2018only.csv

# 3. findings.md cross-refs spec §8
grep -c "exit_def_distributions" 01_dissertation_PBDP/explorations/2026-05-15_p3c-precheck/findings.md
grep -c "explorations/2026-05-15_p3c-precheck" 01_dissertation_PBDP/quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md
# Both ≥ 1

# 4. Sister plan identical to harness plan
diff /Users/leedo/.claude/plans/inherited-knitting-sutton.md 01_dissertation_PBDP/quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md
# Expect: identical (0 lines diff)

# 5. Session log present
test -f 01_dissertation_PBDP/quality_reports/session_logs/2026-05-15_p3c-spec.md && echo "log OK"
```

## Decision gate after this plan

After deliverables (1)–(6) complete:

1. User reviews spec (~30min) — approves DRAFT → APPROVED in §11, OR requests refinement.
2. User reviews `findings.md` (~10min) — assesses scenario implications.
3. **Joint decision: enter Phase 1 (full multi-definition estimation) as a separate plan-mode entry, OR refine spec, OR pause for advisor consultation (이상현 교수님).**

If user defers Phase 1 to consult advisor — that is a clean checkpoint. Spec + findings.md are sufficient artifacts to present to advisor.

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| 382 pre-policy farms have systematic treated/control imbalance → Definition #2 also confounded | Medium | Sanity check explicitly tests this (output #2 + #3); spec §8 flags if pre-2020 attrition diff > 2pp |
| Definition #3 (dynamic hazard) has N < 100 in policy era → SE inflation | Low | Already known ~165 farms; spec demotes to SHOULD (S2), not headline |
| Scenario γ (theory falsified) materializes → §3.6bis full rewrite | Medium | Spec §5 explicitly defines γ-path per user Option C. NOT a project-killer — "per-farm flat-rate fails to deter exit" remains publishable as honest negative result |
| Spec writing exceeds 2h budget → cuts into sanity check time | Low | Spec template (outlier-policy.md) is well-established; structural choices already locked by user answers; expected 1.5–2h |
| User wants pre-validation results inline in spec body (not separate findings.md) | Low | Easy refactor at spec review; current plan separates for cleanliness |
| Sanity check `check.R` fails due to missing column (e.g., `age_code_base` not in clean.rds) | Low | Will catch in run; column verification done by Explore Agent 2 (all columns confirmed present in 50-col schema) |
| `D_treat` baseline split inside 2018-only farms ≠ overall 34.9% → exit_indicator is itself confounded | High informational value | This is exactly what sanity check measures; if confirmed, spec §8 flags as **CRITICAL limitation** for Phase 1 framing |

## Approval gate

On ExitPlanMode approval:

1. Mark plan status DRAFT → APPROVED in this file + sister copy at `01_dissertation_PBDP/quality_reports/plans/2026-05-15_p3c-channel-4-5-decomposition.md`.
2. Create `session_logs/2026-05-15_p3c-spec.md` (initial entry: goal + key context).
3. Create `explorations/2026-05-15_p3c-precheck/` directory + `check.R`.
4. Run `check.R`, verify CSV outputs.
5. Write `findings.md` from CSV output narrative.
6. Write spec markdown `quality_reports/specs/2026-05-15_p3c-channel-4-5-decomposition.md` with §8 referencing findings.md.
7. Update session log with completion summary.
8. Present to user — DO NOT auto-commit (manual approval mode). User invokes `/commit` separately if approved.
9. Pause at decision gate; await user direction for Phase 1 (separate plan-mode entry).

**Total wall-clock: ~3.5h. Quality gate target: spec ≥ 80/100 (advisory, enforced inside `/commit`).**
