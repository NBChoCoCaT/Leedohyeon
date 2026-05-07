# `scripts/R/` — PIDPS DiD-RD analysis pipeline

R pipeline for the dissertation paper "공익직불제 소농직불금이 농가 투입 행태에 미치는 효과 — DiD-RD evidence at the 0.5 ha cutoff." See `CLAUDE.md` for project context, identification strategy, and journal-submission cascade.

## Conventions

- **Run everything from `00_run_all.R`** — do not source mid-pipeline scripts individually unless debugging.
- **Paths via [`here::here()`](https://here.r-lib.org/)** — never `setwd()`. Project root = git repo root.
- **Fixed seed** set once in `00_run_all.R`: `set.seed(20260504)` (= bootstrap session date for the dissertation pipeline; matches `CLAUDE.md` *Commands* section). Change only with a recorded reason in the session log.
- **`sessionInfo()` → `scripts/R/_outputs/sessionInfo.txt`** at the end of `00_run_all.R`.
- **Outputs to `scripts/R/_outputs/`** — RDS (`clean.rds`, `*_results.rds`), tables (`tab_*.tex`), figures (`fig_*.{pdf,png}`). Directory is `.gitignore`d.
- **No hardcoded absolute paths.** Enforced by `/review-r`.
- **Variable convention** — `r-code-conventions.md §10`. Korean source labels preserved as `attr(x, "label")` from `haven::read_dta`. See `_outputs/var_dictionary.csv` after first run.
- **Outlier policy** — `quality_reports/specs/2026-05-07_outlier-policy.md` v1.1. `01_clean.R` pre-computes 16 outcome columns (raw 4 + ihs 4 + winsor99 4 + winsor995 4); estimation scripts swap LHS in identical specs.

## Pipeline

| Script | Responsibility | Status |
| --- | --- | --- |
| `00_run_all.R` | Orchestrator (graceful stub-stop at P2/P3 boundary) | ✅ |
| `_setup_packages.R` | One-time idempotent CRAN install (13 packages) | ✅ |
| `01_clean.R` | Load `panel_2018_2022.dta` → rename (§10) → derive interactions + outlier cols → save `clean.rds`, `var_dictionary.csv`, `clean_log.txt` | ✅ Step 4 P1 |
| `02_descriptive.R` | Table 1 (weighted, Solon-Haider-Wooldridge stage rule) + first-stage take-up paragraph | 🔧 Step 4 P2 (stub) |
| `03_did_rd.R` | DiD-RD main estimation: T1/T2/T3 bandwidth × 4 outcomes + Wild cluster bootstrap + Holm step-down | 🔧 Step 4 P2 (stub) |
| `04_robust.R` | Outlier robustness ladder + heterogeneity (5 dim × 4 outcome) | 🔧 Step 4 P3 (stub) |
| `05_figures.R` | RD scatter, McCrary density, event study (PDF + PNG) | 🔧 Step 4 P3 (stub) |
| `synthetic/` | AEA DCAS code-only verification generator (Step 4 P5) — independent | ✅ |

Stub scripts call `stop("... is a stub — implement in Step 4 P{2,3}.")`. `00_run_all.R` detects this and halts the pipeline gracefully (logs `STUB (P2/P3 boundary)`, still writes `sessionInfo.txt`).

## First-time setup

```bash
Rscript scripts/R/_setup_packages.R          # one-time, idempotent
```

Required (auto-installed): `haven, dplyr, tidyr, tibble, readr, DescTools, fs, here, fixest, modelsummary, sandwich, rdrobust, broom`.

**Not on CRAN (intentional omission):** `fwildclusterboot`, `wildrwolf`. Both require gfortran from source on R 4.5+. Wild cluster bootstrap uses `sandwich::vcovBS(type = "wild", cluster = ~hh_id)` instead — same procedure, no compilation. See `MEMORY.md` `[LEARN:env]` 2026-05-06.

## Run

```bash
Rscript scripts/R/00_run_all.R
```

After P1 completes, expected `scripts/R/_outputs/`:

| File | Source |
| --- | --- |
| `clean.rds` | `01_clean.R` (14,474 obs × ~50 cols) |
| `var_dictionary.csv` | `01_clean.R` (3-col Korean ↔ English lookup) |
| `clean_log.txt` | `01_clean.R` (sample-size waterfall + sanity-check ledger) |
| `sessionInfo.txt` | `00_run_all.R` |

Verify:

```r
df <- readRDS("scripts/R/_outputs/clean.rds")
stopifnot(nrow(df) == 14474, dplyr::n_distinct(df$hh_id) == 3614)
```

## Reviewing

- `/review-r scripts/R/01_clean.R` — code-quality review (R conventions, reproducibility, domain correctness)
- `/audit-reproducibility paper/en/main.tex scripts/R/_outputs/` — paper ↔ code numeric tolerance check (Phase 3 contract: estimate < 0.01, SE < 0.05)

## Plan + spec references

- Plan: `quality_reports/plans/2026-05-07_p1-clean-r.md` (sister: `memoized-herding-duckling.md`)
- Spec: `quality_reports/specs/2026-05-07_outlier-policy.md` v1.1
- Conventions: `.claude/rules/r-code-conventions.md` §6 / §10 / §11 / §12 / §13
- Replication contract: `.claude/rules/replication-protocol.md` Phase 1–3
