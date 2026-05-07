# =============================================================================
# 04_robust.R — Robustness ladder + heterogeneity.
#
# Status: STUB (Step 4 P3 deliverable, not P1).
#
# Expected inputs:
#   scripts/R/_outputs/clean.rds (from 01_clean.R — has 16 outcome cols)
#   scripts/R/_outputs/main_results.rds (from 03_did_rd.R)
#
# Expected outputs (TBC at P3 entry):
#   scripts/R/_outputs/tab_rob_outlier.tex      (raw / IHS / w99 / w995 ladder)
#   scripts/R/_outputs/tab_rob_bandwidth.tex    (alternative bandwidths)
#   scripts/R/_outputs/tab_heterogeneity.tex    (5 dim × 4 outcome = 20 specs)
#   scripts/R/_outputs/rob_results.rds
#
# Spec contracts to apply at P3:
#   - quality_reports/specs/2026-05-07_outlier-policy.md v1.1 §4 Decision Matrix:
#       Tier 1 (raw, baseline) — already in 03_did_rd.R
#       Tier 2 (IHS asinh + winsor99) — term-paper robustness reproduction
#       Tier 3 (winsor995) — AJAE addition
#   - Outlier-spec §6.5 — outcome columns: ihs_<o>, <o>_w99, <o>_w995 already
#     pre-computed in 01_clean.R; just swap LHS in the same DiD-RD spec.
#   - replication-protocol.md Phase 3 — STATA 06_robustness_aux.log targets.
#
# Plan reference: TBC (Step 4 P3 plan).
# =============================================================================

stop("04_robust.R is a stub — implement in Step 4 P3.")
