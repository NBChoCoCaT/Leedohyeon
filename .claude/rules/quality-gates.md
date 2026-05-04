---
paths:
  - "Slides/**/*.tex"
  - "Quarto/**/*.qmd"
  - "scripts/**/*.R"
  - "paper/**/*.tex"
---

# Quality Review & Scoring Rubrics

> **Framing:** Thresholds are **advisory at the harness level**. The `/commit` skill runs `quality_score.py` and halts on failure until the user fixes or explicitly overrides. There is no git pre-commit hook that blocks a direct `git commit` — if you bypass the skill, you bypass the review. "Gate" in this file means "checkpoint enforced by a specific skill," not "repo-wide block."

## Thresholds (synced with CLAUDE.md)

| Score | Stage | Meaning |
|-------|-------|---------|
| 80 | Commit | Replication-protocol Phase 3 tolerance holds for every numeric claim |
| 90 | First submission | Passes `/seven-pass-review` and `/audit-reproducibility`; ready to send to AJAE/Food Policy/JAE |
| 95 | R&R response | Referee concerns systematically resolved via `/respond-to-referees` |

Each deduction table below carries a **Stage-blocking** column indicating which stage(s) the issue blocks. Items listed only as `90` or `95` are advisory at commit time but blocking at submission/R&R.

## Quarto Slides (.qmd)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | Compilation failure | -100 | 80 / 90 / 95 |
| Critical | Equation overflow | -20 | 80 / 90 / 95 |
| Critical | Broken citation | -15 | 80 / 90 / 95 |
| Critical | Typo in equation | -10 | 80 / 90 / 95 |
| Major | Text overflow | -5 | **90** / 95 |
| Major | TikZ label overlap | -5 | **90** / 95 |
| Major | Notation inconsistency | -3 | **90** / 95 |
| Minor | Font size reduction | -1 per slide | 95 |
| Minor | Long lines (>100 chars) | -1 (EXCEPT documented math formulas) | 95 |

## R Scripts (.R)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | Syntax errors | -100 | 80 / 90 / 95 |
| Critical | Domain-specific bugs | -30 | 80 / 90 / 95 |
| Critical | Hardcoded absolute paths | -20 | 80 / 90 / 95 |
| Major | Missing set.seed() | -10 | 80 / 90 / 95 |
| Major | Missing figure generation | -5 | **90** / 95 |

## Beamer Slides (.tex)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | XeLaTeX compilation failure | -100 | 80 / 90 / 95 |
| Critical | Undefined citation | -15 | 80 / 90 / 95 |
| Critical | Overfull hbox > 10pt | -10 | **90** / 95 |

## English Manuscript (paper/en/**/*.tex)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | XeLaTeX compile failure | -100 | 80 / 90 / 95 |
| Critical | Undefined citation | -15 | 80 / 90 / 95 |
| Critical | Korean policy citation error (date / amount / statute) | -15 | 80 / 90 / 95 |
| Critical | Korean-style citation format leaked into paper/en | -15 | **90** / 95 (paper/en strictly English-style) |
| Major | Numeric claim inconsistent with `_outputs/*.rds` | -10 | 80 / 90 / 95 |
| Major | Weighting decision unjustified or inconsistent across tables (per Solon-Haider-Wooldridge 2015 stage rule in r-code-conventions §6) | -10 | 80 / 90 / 95 |
| Major | Missing robustness check (cluster=`sgg_cd`, MSE-bandwidth) | -5 | **90** / 95 |
| Minor | Notation inconsistency across sections | -3 | 95 |
| Minor | Korean phrasing leaked into English text | -3 | **90** / 95 |

## Korean Manuscript (paper/ko/**/*.tex)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | XeLaTeX (with fontspec) compile failure | -100 | 80 / 90 / 95 |
| Critical | Undefined citation | -15 | 80 / 90 / 95 |
| Critical | Korean policy citation error (date / amount / statute) | -15 | 80 / 90 / 95 |
| Major | English-form citation forced into paper/ko (should use Korean form) | -10 | 80 / 90 / 95 |
| Major | Numeric claim inconsistent with `_outputs/*.rds` | -10 | 80 / 90 / 95 |

**Note:** `paper/ko` is the upstream draft; numeric claims must match `_outputs/*.rds` BEFORE translation begins. Translation drift is checked separately at the `/translate-paper-ko-en` stage (Step 4).

## Enforcement (by the /commit skill only)

- **Score < 80:** Halt within `/commit`. List blocking issues. User may override with an explicit natural-language signal ("commit anyway" / "skip quality gate") and a reason — the override is logged in the commit body.
- **Score < 90:** Allow commit within `/commit`, warn. List recommendations.
- **Direct `git commit`** (bypassing the skill): no enforcement. For hard enforcement, install a git pre-commit hook that wraps `quality_score.py`.

## Quality Reports

Generated **only at merge time**. Use `templates/quality-report.md` for format.
Save to `quality_reports/merges/YYYY-MM-DD_[branch-name].md`.

## Korean Policy Citation Accuracy

Every claim about PIDPS / Small-Farmer Flat Payment / Korean agricultural law must match the canonical reference data in `.claude/references/policy-glossary-ko-en.md` (created in Step 5):

| Claim type | Source of truth | Deduction if wrong |
|------------|-----------------|---------------------|
| Statute article (예: 법령 제10조) | `policy-glossary-ko-en.md` | -15 (Critical) |
| Effective date (2020-05-01) | Same | -15 (Critical) |
| Subsidy amount (1,200,000 KRW/year flat) | Same | -15 (Critical) |
| Institution English name (e.g., **Public-Interest Direct Payment Scheme**, **Small-Farmer Flat Payment**) | Same | -5 (Minor) |

CoVe (`/verify-claims`) auto-checks all four claim types against `policy-glossary-ko-en.md` before any commit on `paper/{ko,en}/**`.

## Bilingual Citation Format Enforcement

Citation format is **directory-scoped**:

| Directory | Required format | Example |
|-----------|-----------------|---------|
| `paper/ko/**/*.tex` | Korean form | 김태화·양승룡(2021) |
| `paper/en/**/*.tex` | Author-year (English) | Kim and Yang (2021) |

`Bibliography_base.bib` MUST carry both forms in dual fields per entry (`author` + `author_en`, `title` + `title_en`). See the dual-field convention block at the top of `Bibliography_base.bib`. `/validate-bib` (extended in Step 4) detects format mismatch by file path; until then, manual + CoVe enforcement.

## Tolerance Thresholds (Research)

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| Point estimates (replication) | < 0.01 | Display rounding in source paper |
| Standard errors (replication) | < 0.05 | Bootstrap/clustering MC variance |
| Coefficient ratios (own results) | < 1e-6 | Numerical precision |
| Wild bootstrap p-values | ± 0.005 across reps | B = 9,999 reps; seed-pinned |
| Coverage rates (simulation) | ± 0.01 | MC error at 1,000 reps |
