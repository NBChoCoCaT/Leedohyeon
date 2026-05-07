# =============================================================================
# 02_descriptive.R — Descriptive statistics + Table 1 baseline.
#
# Status: STUB (Step 4 P2 deliverable, not P1).
#
# Expected inputs:
#   scripts/R/_outputs/clean.rds (from 01_clean.R)
#
# Expected outputs (TBC at P2 entry):
#   scripts/R/_outputs/tab_descriptives.tex     (Table 1, weighted)
#   scripts/R/_outputs/tab_balance.tex          (cutoff-near balance, |rv_2018|<=h)
#   scripts/R/_outputs/desc_summary.rds
#
# Spec contracts to apply at P2:
#   - r-code-conventions.md §6 — Solon-Haider-Wooldridge 2015 stage rule:
#       weight_national MANDATORY for Table 1 descriptives via survey::svydesign().
#   - r-code-conventions.md §13 — modelsummary tab_<topic>_<lang>.tex.
#   - First-stage take-up paragraph: actual_subsidy ↔ imputed_payment × Post
#     ([LEARN:methods] 2026-05-07 — #84 mandatory).
#
# Plan reference: TBC (Step 4 P2 plan).
# =============================================================================

stop("02_descriptive.R is a stub — implement in Step 4 P2.")
