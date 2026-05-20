# Phase 2 — AJAE Submission Gate (Wave 10)

**Date:** 2026-05-20
**Status:** DRAFT (pending approval)
**Branch:** `feat/wave10-phase2-ajae-gate` (created off main @ `d742060` post-Phase-1.5b merge)
**Cross-reference:** `quality_reports/seven_pass_main_en_post_phase1_5b/_SYNTHESIS.md` (composite 8.56)
**Estimated time:** 5-6 working days
**Composite target:** 8.56 → ≥9.0 (AJAE first-submission gate per `quality-gates.md`)

---

## Context

Phase 1 + 1.5 + 1.5b closed all 10 X-blockers + 6 mop-up CRITICALs (composite 6.4 → 8.56, PR #26 merged 2026-05-20). Five of seven lenses now ≥9.0; two lenses below target are **Intro (5.6/10, deferred restructure)** and **Results (8.7/10, M8 partition consistency)**, with Methods at 9.0 having 5 remaining MAJORs awaiting analytic work.

Phase 2 scope (per user decision Tier C, 2026-05-20): full AJAE submission-ready, all 9 Phase 2 items. Expected composite ≈9.3 after completion. After Phase 2 the paper is ready for the AJAE direct-submission cascade per CLAUDE.md (AJAE → JAE → Food Policy → KAEA).

---

## Phase 2A — Methods Analytic Work (~3 days R-side)

### Step 1 — L3 MAJ-2: CCT 2014 covariate continuity at the cutoff (1 day)

**Purpose:** Standard RD diagnostic — verify pre-determined covariates are continuous at the cutoff. Currently absent; only dropped-balance table (between sub-populations, not at cutoff) exists.

**File:** `scripts/R/04c_cct_covariate_continuity.R` (NEW)

**Specification:**
```r
library(rdrobust)
covariates <- c("age_code_base", "farm_type", "type_fulltime", "own_share_pre",
                "area_owned_2018", "off_inc_2018")
# 6 pre-determined covariates × 3 bandwidths (T1/T2/T3 MSE per covariate)
# 2018 cross-section (one row per hh) for each covariate
for (cov in covariates) {
  fit <- rdrobust::rdrobust(y = df18[[cov]], x = df18$rv_2018, c = 0, p = 1,
                            bwselect = "mserd", kernel = "triangular",
                            cluster = df18$hh_id)
  # Save coef, robust SE, robust p, bandwidth
}
```

**Outputs:**
- `_outputs_symmetric/tab_cct_covariate_continuity_en.tex` — 18-cell table (6 cov × 3 BW)
- `_outputs_symmetric/cct_covariate_results.rds`

**Paper §7 insertion:** New `\paragraph{Covariate continuity at the cutoff.}` after the McCrary section, with `\input{}` of the table. Headline claim: "No covariate is significant at $p < .05$ at any bandwidth" (target — verify empirically).

### Step 2 — L3 MAJ-1: CJM rddensity multi-bandwidth (1 day)

**Purpose:** Replace ad-hoc narrow-window McCrary defense with Cattaneo-Jansson-Ma (2020) modern density-discontinuity test, reporting at full + ±500 + ±1000 + ±3300 windows. Verify the narrow-window p ≈ .07 finding is not driven by McCrary's known bias at small N.

**File:** `scripts/R/11c_cjm_density.R` (NEW; extends 11b_multi_rv_density.R pattern)

**Specification:**
```r
library(rddensity)
for (window in list(full = Inf, narrow1 = 500, narrow2 = 1000, mse = 3300)) {
  rd <- rddensity::rddensity(X = df18$rv_2018[abs(df18$rv_2018) <= window],
                             c = 0, vce = "jackknife")
  # Extract conventional + bias-corrected + robust p-values
}
```

**Outputs:**
- `_outputs_symmetric/cjm_density_test.rds`
- `_outputs_symmetric/tab_cjm_density_en.tex` — 4-row table (full + 3 bandwidths × {conventional, bias-corrected, robust} p)

**Paper §7 update:** Insert before the existing McCrary paragraph; reframe McCrary as the older convention and CJM as the headline test. The narrow-window p ≈ .07 concern is either confirmed (note in robustness as residual concern) or refuted (clean pass).

### Step 3 — L3 MAJ-3: Measurement error sensitivity in $s_{0,i}$ + self-reported $A_{2018}$ (1 day)

**Purpose:** FHES area is self-reported; bin boundaries at $s_0 = 0.33$ and $s_0 = 0.67$ are exactly where F1 monotone gradient is read off. Cite Pei-Shen (2017) on RD measurement-error sensitivity. Run fuzzy-bin-boundary analysis.

**File:** `scripts/R/07b_fuzzy_bin_sensitivity.R` (NEW; extends 07_heterogeneity.R)

**Specifications (3 alternatives reported side-by-side):**
1. **Strict bins (baseline):** {0, (0, 0.33], (0.33, 0.67], (0.67, 1), 1}
2. **Donut:** Drop households with $s_0 \in [0.30, 0.36]$ and $[0.64, 0.70]$ (boundary uncertainty zones)
3. **Continuous $s_0$:** Local-polynomial $\hat\beta_1(s_{0,i})$ as a nonparametric function of $s_0$, then test monotonicity via the integrated gradient $\int_0^1 \hat\beta_1'(s_0) ds_0$

**Outputs:**
- `_outputs_symmetric/tab_fuzzy_bin_sensitivity_en.tex` — 3-panel comparison
- `_outputs_symmetric/fig_continuous_s0_gradient_T2_en.{pdf,png}` — nonparametric curve

**Paper §7 insertion:** `\paragraph{Measurement-error sensitivity in baseline tenancy.}` Reference Pei-Shen (2017); state headline robustness.

### Step 4 — L3 MAJ-4: Wild cluster bootstrap B=9,999 (6 hr compute)

**Purpose:** Replace current B=999 with replication-release-grade B=9,999. Pin seed for determinism.

**File:** Re-run `scripts/R/09_wild_bootstrap.R` with `WILD_R=9999` env override on the symmetric pipeline.

**Specification:**
```bash
WILD_R=9999 Rscript -e '
PROJECT_SEED <- 20260504L; set.seed(PROJECT_SEED)
OUT_DIR <- here::here("scripts","R","_outputs_symmetric")
ELIGIBILITY_SUBSET <- TRUE; SYMMETRIC_SUBSET <- TRUE
source(here::here("scripts","R","09_wild_bootstrap.R"), local = environment())
'
```

**Outputs:**
- `_outputs_symmetric/tab_wild_bootstrap_en.tex` regenerated with B=9,999
- The largest analytic-vs-wild gap on op_cost_ex_rent T1 (currently .105 vs .041) should tighten with higher B; verify whether the result clears Holm correction at B=9,999.

**Paper §5 + §7 update:** Drop "B = 999 in current draft / B = 9,999 at replication-release stage" language; declare definitive B = 9,999 inference.

### Step 5 — L3 MAJ-6: Anticipation defense citation (~2 hours research)

**Purpose:** §3 line 180 prong (i) "the per-farm flat-rate SFFP component of PIDPS was specifically designed after 2018" lacks citation. Need MAFRA legislative-history reference showing pre-2018 PIDPS deliberation did not include 0.5-ha cutoff.

**Sources to check:**
- 농림축산식품부 (MAFRA) 보도자료 archive 2018-2019 for "공익직불제" timeline
- 한국농촌경제연구원 (KREI) PIDPS-design working papers
- Possible substitute: cite Choi-Mun (2025) or Choi-Jodlowski (2025) institutional sections

**Files to modify:**
- `Bibliography_base.bib` — add 1 entry (likely a MAFRA technical report or KREI working paper)
- `paper/en/main.tex` line 180 — add citation

---

## Phase 2B — Paper Restructure (~2 days)

### Step 6 — L2 Intro Restructure (6 hours)

**Purpose:** Current intro 1,569 words is ~30% over AJAE 1,200 upper bound. Per L2 review's 10-move recommendation: (a) lift headline magnitudes to ¶1, (b) move contribution paragraph from ¶6/7 to ¶3, (c) cut ¶4 (§5 strategy detail dropped into intro) by 60%, (d) compress ¶3 lit-comparison from 4-block "Versus X" to integrated prose.

**File:** `paper/en/main.tex` lines 44–60.

**Target structure (Cochrane arc, ~1,150 words):**

| ¶ | Function | Target words | Current ¶ |
|---|---|---:|---|
| 1 | **Opener (the question)** + headline magnitudes preview | 200 | ¶1 (221w) cut + ¶5 magnitudes lifted |
| 2 | **Korea/PIDPS context** (institutional contrast load-bearing) | 200 | ¶2 (239w) trim |
| 3 | **Contribution paragraph** (4 differentiated contributions) | 250 | ¶6 (200w) promoted from position 6 → 3, expand to 4 contributions |
| 4 | **AHM extensions + falsifiable predictions** (theory hook) | 200 | ¶2-partial (AHM material) + ¶5 trimmed |
| 5 | **Identification (one sentence, not a full §5 dump)** | 150 | ¶4 (280w) cut 60% |
| 6 | **Roadmap** | 50 | ¶7 (44w) preserve |

**Cuts to make:**
- Drop §5 strategy detail from ¶4 (RV formula, CGM citation, three bandwidths in detail) — referee reads §5
- Drop $\tau$ calibration footnote and (S,s) ratio derivation from ¶5 — §3.4 covers
- Compress "Versus Kirwan / Versus Baldoni-Ciaian / Versus Kazukauskas / Versus Carter-Olinto" 4-block pattern from ¶3 to integrated 1-paragraph synthesis

### Step 7 — L4 M8: 4-bin vs 5-bin partition canonicalization (90 min)

**Purpose:** §3 (line 121, 213, 276, 289) describes a 4-bin partition (pure_tenant / low_owner / mixed / pure_owner); §5/§6/tables/figures uniformly use 5 bins with separate high_owner. The F1 trigger definition at line 289 references a 4-element set; line 354 evaluates against 5 bins. Pre-specification narrative inconsistent.

**Decision:** Canonicalize to 5-bin everywhere (more granular; preserves empirical structure already in tables/figures). Edit §3 references.

**Files to modify:**
- `paper/en/main.tex` — §3 lines 121, 213, 276, 289 (trigger definition + 4-bin → 5-bin)
- Update Notation Table 1 line 121 to list 5 bins
- F1 trigger at line 289: update conjunct to reference 5-element set $\{pure\_tenant, low\_owner, mixed, high\_owner, pure\_owner\}$ with $pure\_owner \equiv 0$ as reference

### Step 8 — L3 MINOR: L448 "strictly sharp DiD-RD" (2 min)

**File:** `paper/en/main.tex` line 448 (Asymmetric-sample variant paragraph)

**Change:** "does not yield a strictly sharp DiD-RD because eligibility-conditioning is one-sided" → "does not yield two-sided observable-eligibility symmetry because eligibility-conditioning is one-sided"

### Step 9 — L6 Phase 2 polish sweep (1 day)

**Purpose:** Address deferred Phase 2 prose items from initial L6 review:

a) **Sentence length:** Split 30+ sentences > 35 words. Use Lens 6 ledger as input (lines 48, 50, 52, 54, 56, 58, 180, 317, 333, 343, 350, 359, 363, 423, 448, 450, 454, 457, 461).

b) **Em-dash overuse:** Replace stacked em-dash parentheticals (lines 48, 52, 56, 86, 219, etc.) with parenthetical commas or split sentences.

c) **"Versus X" pattern (Phase 1B-2 partial deferred):** §1 ¶3 "Versus Kirwan / Versus Ciaian / Versus Kazukauskas / Versus Carter-Olinto" 4-block → integrated synthesis paragraph (also part of Step 6 intro restructure).

d) **"Statutorily-eligible" hyphen:** Chicago Manual 7.86 — drop hyphen on -ly adverb compounds. ~16 instances.

e) **"AHM-extension" hyphen consistency:** Open compound when noun ("AHM separability null"); hyphenated when modifier-before-noun ("AHM-extension framework").

f) **`(S,s)` math mode:** Force `$(S,s)$` everywhere instead of mixed text/math.

g) **`\citet{X, Y}` two-key drop:** Split into two `\citet` calls (lines 178, 219).

h) **Phase 1.5b residuals:** L348 "We do not attempt..." → objective register; "robust to this empirical magnitude" → "survives this empirical shift".

i) **AHM-rejection italics consistency:** Lines 377, 481 — pick italics or not, apply uniformly.

---

## Phase 2C — Verification + Submission Prep (~1 day)

### Step 10 — Compile + audit + seven-pass gate

```bash
# Run modified R scripts
Rscript scripts/R/04c_cct_covariate_continuity.R
Rscript scripts/R/11c_cjm_density.R
Rscript scripts/R/07b_fuzzy_bin_sensitivity.R
WILD_R=9999 Rscript -e '...09_wild_bootstrap.R...' # ~5 hr compute

# Compile
cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex

# Audit + review
/audit-reproducibility paper/en/main.tex scripts/R/_outputs_symmetric/
/seven-pass-review paper/en/main.tex
```

**Pass criteria:**
- xelatex 0 errors, ≤ 2 overfull hbox
- audit: 0 FAILs
- seven-pass composite ≥ 9.0 (AJAE first-submission gate)
- main.pdf within AJAE 50-page double-spaced cap (current 56 pages may need formatting adjustment)

### Step 11 — Pre-submission AEA DCAS replication-package readiness

- Verify `scripts/R/_outputs_symmetric/sessionInfo.txt` captures package versions
- Update README with replication instructions
- Verify `scripts/R/synthetic/` (AEA DCAS code-only verification) still passes against Wave 9 calibration JSON

---

## Files to modify

**R scripts (3 new, 1 patched):**
- `scripts/R/04c_cct_covariate_continuity.R` (NEW)
- `scripts/R/11c_cjm_density.R` (NEW)
- `scripts/R/07b_fuzzy_bin_sensitivity.R` (NEW)
- `scripts/R/09_wild_bootstrap.R` (re-run with WILD_R=9999, no code change)

**Bibliography:**
- `Bibliography_base.bib` — 1 entry added (MAFRA legislative history)

**Paper text (one large file, many sites):**
- `paper/en/main.tex` — Steps 6 (intro restructure §1 lines 44-60), 7 (§3 4-bin → 5-bin lines 121/213/276/289), 8 (L448), 9 (sentence-length + hyphens + math-mode + citations across §1/§3/§5/§6/§7/§8 — many sites), and Phase 2A insertions in §7 (CCT, CJM, fuzzy-bin paragraphs + table \input{}s)

**Outputs regenerated:**
- `_outputs_symmetric/` — adds tab_cct_covariate_continuity_en.tex, tab_cjm_density_en.tex, tab_fuzzy_bin_sensitivity_en.tex, fig_continuous_s0_gradient_T2_en.{pdf,png}; updates tab_wild_bootstrap_en.tex with B=9,999

---

## Quality-gate exit criteria

| Gate | Threshold | Where enforced |
|---|---|---|
| R scripts exit 0 | All scripts | Step 10 |
| Audit-reproducibility | 0 FAILs on full numeric set | Step 10 |
| xelatex compile | 0 errors, ≤2 overfull | Step 10 |
| Composite quality score | **≥ 9.0** (AJAE submission gate) | Step 10 `/seven-pass-review` |
| PDF page count | ≤ 50 (double-spaced AJAE) | Step 10 (may require margin/line-spacing config) |

---

## Verification — end-to-end test

1. `Rscript scripts/R/04c_cct_covariate_continuity.R` — produces 18-cell table, no covariate significant at p<.05 (target outcome)
2. `Rscript scripts/R/11c_cjm_density.R` — produces 4-row table; bias-corrected p > .10 at all bandwidths (target)
3. `Rscript scripts/R/07b_fuzzy_bin_sensitivity.R` — produces 3-panel comparison; F1 sign preserved under donut + continuous-$s_0$
4. `WILD_R=9999 Rscript ... 09_wild_bootstrap.R` — produces tightened p-values; verify op_cost_ex_rent T1 wild p resolution
5. `latexmk -xelatex paper/en/main.tex` — exit 0, ≤2 overfull
6. `/audit-reproducibility ...` — 0 FAILs
7. `/seven-pass-review ...` — composite ≥ 9.0
8. (Optional) `python3 scripts/quality_score.py paper/en/main.tex` — Phase 2 should also fix the equation-overflow regex false-positive

---

## Stop conditions

1. **Step 1 (CCT):** Any covariate significant at p<.05 at any bandwidth → reframe F1 conditional on the imbalanced covariate. Stop and re-plan.
2. **Step 2 (CJM):** Bias-corrected narrow-window p<.05 → manipulation concern escalates from MINOR to MAJOR; need additional triangulation.
3. **Step 3 (measurement error):** F1 monotone gradient does NOT survive donut or continuous-$s_0$ → headline reframe.
4. **Step 4 (B=9,999):** Wild bootstrap shifts op_cost_ex_rent T1 across Holm threshold either direction → narrative adjustment needed.
5. **Step 6 (intro restructure):** Word count target ≤1,200 not achievable without losing content → re-scope ¶1-2 only.
6. **Step 10 (post-revision seven-pass):** Composite < 8.8 → diagnose which step under-delivered; do NOT proceed to commit.

---

## What this plan does NOT cover (future work)

- Korean `paper/ko/main.tex` synchronization (deferred until paper/en final-form per CLAUDE.md primary-track rule)
- AEA Data Editor full submission package (Phase 3, post-acceptance)
- KAEA conference presentation derivation from paper/en
- Choi-Jodlowski / Choi-Mun citation verification beyond Wave 7 PR #21
