# =============================================================================
# run_eligibility_pipeline.R — Wave 7 Phase 1B re-run on subset panel.
#
# Mirrors 00_run_all.R pattern: builds a pipeline_env with OUT_DIR pointing at
# _outputs_eligibility/ and sources each Wave 5 analysis script with
#   source(path, local = pipeline_env)
# so each script's `exists("OUT_DIR", inherits = FALSE)` check finds the
# overridden OUT_DIR. 01_clean.R is skipped (clean.rds already produced by
# 01c_subset_clean.R).
# =============================================================================

suppressPackageStartupMessages({
  if (!requireNamespace("here", quietly = TRUE))
    stop("Install 'here' first: Rscript scripts/R/_setup_packages.R")
  library(here)
  library(fs)
})

PROJECT_SEED <- 20260504L
set.seed(PROJECT_SEED)

OUT_DIR <- here("scripts", "R", "_outputs_eligibility")
stopifnot(fs::file_exists(file.path(OUT_DIR, "clean.rds")))

# WILD_R lowered for Phase 1B fast iteration; 09 can be re-run at 9999 later.
Sys.setenv(WILD_R = "999")

pipeline_env <- new.env(parent = globalenv())
pipeline_env$PROJECT_SEED      <- PROJECT_SEED
pipeline_env$OUT_DIR           <- OUT_DIR
pipeline_env$ELIGIBILITY_SUBSET <- TRUE

# Order: figures (05) deferred to after mccrary_test.rds (04) and rest.
pipeline <- c(
  "02_descriptive.R",
  "03_did_rd.R",
  "04_robust.R",
  "06_channels.R",
  "07_heterogeneity.R",
  "08_p3c_decomposition.R",
  "09_wild_bootstrap.R",
  "10_alpha3_estimation.R",
  "05_figures.R"
)

timings <- numeric(0)
t_start <- Sys.time()
for (script in pipeline) {
  path <- here("scripts", "R", script)
  stopifnot(file.exists(path))
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

message(sprintf("\nPipeline complete. Total time: %.1f min",
                as.numeric(Sys.time() - t_start, units = "mins")))

writeLines(
  capture.output(sessionInfo()),
  con = file.path(OUT_DIR, "sessionInfo.txt")
)
