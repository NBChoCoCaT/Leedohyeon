# =============================================================================
# 03_did_rd.R — DiD-RD main estimation.
#
# Status: STUB (Step 4 P2 deliverable, not P1).
#
# Expected inputs:
#   scripts/R/_outputs/clean.rds (from 01_clean.R)
#
# Expected outputs (TBC at P2 entry):
#   scripts/R/_outputs/main_results.rds         (T1/T2/T3 × 4 outcomes)
#   scripts/R/_outputs/tab_main_did_rd_en.tex   (modelsummary)
#   scripts/R/_outputs/tab_main_did_rd_ko.tex
#
# Spec contracts to apply at P2:
#   - CLAUDE.md "Identification Strategy":
#       T1 ±500 / T2 ±1,000 / T3 MSE-optimal (rdrobust)
#       Wild cluster bootstrap at hh_id (sandwich::vcovBS, B = 9,999 seed-pinned)
#       Holm step-down across 4 primary outcomes
#   - r-code-conventions.md §11 — primary cluster hh_id (NOT sgg_cd: not in .dta)
#   - replication-protocol.md Phase 3 tolerance:
#       estimate < 0.01 vs STATA D_Post coefs in 02_analysis.log
#       SE < 0.05 vs STATA cluster-robust SE
#
# Spec used:
#   feols(<outcome> ~ D_Post + rv_Post + Drv_Post | hh_id + year,
#         data = subset, cluster = ~hh_id)
#   subset = df |> filter(abs(rv_2018) <= h)  for h ∈ {500, 1000, T3}
#
# Plan reference: TBC (Step 4 P2 plan).
# =============================================================================

stop("03_did_rd.R is a stub — implement in Step 4 P2.")
