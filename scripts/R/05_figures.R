# =============================================================================
# 05_figures.R — Publication-grade figures (RD plot, McCrary density, event study).
#
# Status: STUB (Step 4 P3 deliverable, not P1).
#
# Expected inputs:
#   scripts/R/_outputs/clean.rds (from 01_clean.R)
#   scripts/R/_outputs/main_results.rds (from 03_did_rd.R)
#
# Expected outputs (TBC at P3 entry):
#   scripts/R/_outputs/fig_rd_<outcome>.{pdf,png}   (RD scatter w/ local-linear fit)
#   scripts/R/_outputs/fig_mccrary_density.{pdf,png}
#   scripts/R/_outputs/fig_event_study.{pdf,png}
#
# Spec contracts to apply at P3:
#   - r-code-conventions.md §13 — PDF (cairo_pdf) + PNG (transparent bg, dpi 300)
#   - r-code-conventions.md §4 — institutional palette + theme_custom
#   - INV-11 (transparent bg for slide overlay) + INV-12 (project theme)
#   - rdrobust::rdplot for headline + ggplot2 for custom panels
#
# Plan reference: TBC (Step 4 P3 plan).
# =============================================================================

stop("05_figures.R is a stub — implement in Step 4 P3.")
