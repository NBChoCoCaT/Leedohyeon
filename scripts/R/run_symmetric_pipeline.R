# =============================================================================
# run_symmetric_pipeline.R — Phase 1 Blockers (Wave 9) symmetric-screening re-run.
#
# Mirrors run_eligibility_pipeline.R but OUT_DIR points at _outputs_symmetric/.
# Sources 02–10 + 11b–15b analysis scripts via pipeline_env so each script's
# OUT_DIR injection lands on the symmetric directory.
#
# Prerequisite: 01d_symmetric_clean.R already produced
#   _outputs_symmetric/clean.rds  (11,010 obs / 2,776 hh / treated=1,131)
#
# Plan: quality_reports/plans/2026-05-20_phase1-blockers.md (Step 3)
# =============================================================================

suppressPackageStartupMessages({
  if (!requireNamespace("here", quietly = TRUE))
    stop("Install 'here' first: Rscript scripts/R/_setup_packages.R")
  library(here)
  library(fs)
})

PROJECT_SEED <- 20260504L
set.seed(PROJECT_SEED)

OUT_DIR <- here("scripts", "R", "_outputs_symmetric")
stopifnot(fs::file_exists(file.path(OUT_DIR, "clean.rds")))

# WILD_R lowered for Phase 1A fast iteration; can re-run 09 at 9999 later.
Sys.setenv(WILD_R = "999")

pipeline_env <- new.env(parent = globalenv())
pipeline_env$PROJECT_SEED       <- PROJECT_SEED
pipeline_env$OUT_DIR            <- OUT_DIR
pipeline_env$ELIGIBILITY_SUBSET <- TRUE   # downstream scripts treat sym
                                          # like the eligibility subset
pipeline_env$SYMMETRIC_SUBSET   <- TRUE   # 3-way assertion: sym checked first

# Wave 5 pipeline scripts (02–10) + Wave 5 robustness extensions (11b–15b)
pipeline <- c(
  "02_descriptive.R",
  "03_did_rd.R",
  "04_robust.R",
  "06_channels.R",
  "07_heterogeneity.R",
  "08_p3c_decomposition.R",
  "09_wild_bootstrap.R",
  "10_alpha3_estimation.R",
  "11b_multi_rv_density.R",
  "12b_forest_comparison.R",
  "13b_placebo_cutoffs.R",
  "14b_dropped_hh_balance.R",
  "15b_attrition_placebo_full.R",
  "05_figures.R"
)

timings <- numeric(0)
t_start <- Sys.time()
for (script in pipeline) {
  path <- here("scripts", "R", script)
  if (!file.exists(path)) {
    message(sprintf("  %s -> SKIPPED (file missing)", script))
    next
  }
  start <- Sys.time()
  res <- tryCatch(
    source(path, local = pipeline_env),
    error = function(e) e
  )
  elapsed <- as.numeric(Sys.time() - start, units = "secs")
  timings[script] <- elapsed
  if (inherits(res, "error")) {
    message(sprintf("  %s -> FAILED after %.2fs", script, elapsed))
    message("Error: ", conditionMessage(res))
    stop(res)
  }
  message(sprintf("  %s -> %.2fs", script, elapsed))
}

message(sprintf("\nSymmetric pipeline complete. Total time: %.1f min",
                as.numeric(Sys.time() - t_start, units = "mins")))

writeLines(
  capture.output(sessionInfo()),
  con = file.path(OUT_DIR, "sessionInfo.txt")
)
