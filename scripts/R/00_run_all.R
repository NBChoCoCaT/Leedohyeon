# =============================================================================
# 00_run_all.R — PIDPS DiD-RD pipeline orchestrator.
#
# Run this, not the individual scripts. First-time setup: run
#   Rscript scripts/R/_setup_packages.R
# once to install the CRAN dependencies, then this orchestrator any number
# of times.
#
# Reproducibility contract (enforced by /review-r and /audit-reproducibility):
#   - Fixed seed (PROJECT_SEED below).
#   - Project root resolved via here::here() — no setwd().
#   - Outputs written to scripts/R/_outputs/.
#   - sessionInfo() captured so reviewers can verify the environment.
#   - Stub stops are graceful (P2/P3 boundary), not pipeline failures.
# =============================================================================

# ---- Bootstrap -------------------------------------------------------------
suppressPackageStartupMessages({
  if (!requireNamespace("here", quietly = TRUE)) {
    stop("Install 'here' first: Rscript scripts/R/_setup_packages.R")
  }
  library(here)
})

# Seed applies to everything downstream. Change ONLY with a reason in the
# session log — this is load-bearing for identical numerical outputs.
# 20260504 = bootstrap session date for the dissertation pipeline (CLAUDE.md).
PROJECT_SEED <- 20260504L
set.seed(PROJECT_SEED)

# Output directory (create if missing; treat as ephemeral).
OUT_DIR <- here("scripts", "R", "_outputs")
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# ---- Pipeline --------------------------------------------------------------
# Scripts share state through a single shared environment. Parent is
# globalenv() so standard R functions (rnorm, ggplot2 exports loaded by the
# user, etc.) resolve normally. Cross-run contamination is prevented by each
# script using `exists("varname", inherits = FALSE)` to check ONLY the
# pipeline env, never the user's global state.
#
# 01_clean.R produces clean.rds; 02_descriptive.R / 03_did_rd.R / 04_robust.R /
# 05_figures.R each read from clean.rds and write their own RDS + tex / pdf.
pipeline_env <- new.env(parent = globalenv())
pipeline_env$PROJECT_SEED <- PROJECT_SEED
pipeline_env$OUT_DIR      <- OUT_DIR

pipeline <- c(
  "01_clean.R",          # P1 — implemented
  "02_descriptive.R",    # P2 — implemented
  "03_did_rd.R",         # P2 — implemented
  "04_robust.R",         # P3a — implemented (Wild bootstrap deferred to 09)
  "05_figures.R",        # P3a — implemented (Korean PDF deferred to P3b)
  "06_channels.R",       # P3b-1 + P3b-3 — CH4 + CH3 channel decomposition
  "07_heterogeneity.R",  # P3b-2 expanded — own_share × 4 outcomes × 5 bins
  "09_wild_bootstrap.R"  # P3b-6 — Wild bootstrap on 14 headline cells
  # 08_iv.R — P3b-5 (NEXT SESSION, optional)
)

message("Running PIDPS DiD-RD pipeline with seed ", PROJECT_SEED, "...")

# Stub stops are intentional boundary signals (P1 → P2 → P3), not failures.
# Detect them by message prefix and continue gracefully so sessionInfo still
# gets captured and the user sees a summary of what ran.
is_stub_stop <- function(cond) {
  grepl("is a stub", conditionMessage(cond), fixed = TRUE)
}

timings <- numeric(0)
hit_stub <- FALSE
stub_at  <- NA_character_

for (script in pipeline) {
  path <- here("scripts", "R", script)
  if (!file.exists(path)) {
    stop("Missing pipeline script: ", path)
  }
  start <- Sys.time()
  res <- tryCatch(
    source(path, local = pipeline_env),
    error = function(e) e
  )
  elapsed <- as.numeric(Sys.time() - start, units = "secs")
  timings[script] <- elapsed

  if (inherits(res, "error")) {
    if (is_stub_stop(res)) {
      message(sprintf("  %s -> STUB (P2/P3 boundary)", script))
      hit_stub <- TRUE
      stub_at  <- script
      break
    }
    message(sprintf("  %s -> FAILED after %.2fs", script, elapsed))
    stop(res)
  }
  message(sprintf("  %s -> %.2fs", script, elapsed))
}

# ---- Session capture -------------------------------------------------------
writeLines(
  capture.output(sessionInfo()),
  con = file.path(OUT_DIR, "sessionInfo.txt")
)

# ---- Report ----------------------------------------------------------------
outputs <- list.files(OUT_DIR, full.names = FALSE)
message("")
if (hit_stub) {
  message("Pipeline halted at stub: ", stub_at, " (expected — Step 4 P2/P3 boundary).")
} else {
  message("Pipeline complete. Total time: ", sprintf("%.2fs", sum(timings)))
}
message("Outputs in ", OUT_DIR, ":")
for (f in outputs) message("  - ", f)

invisible(list(timings = timings, outputs = outputs,
               hit_stub = hit_stub, stub_at = stub_at))
