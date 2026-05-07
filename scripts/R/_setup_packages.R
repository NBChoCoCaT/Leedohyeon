# =============================================================================
# _setup_packages.R — Idempotent CRAN install for PIDPS R pipeline.
#
# Run ONCE manually before scripts/R/00_run_all.R:
#
#   Rscript scripts/R/_setup_packages.R
#
# Re-running is safe — already-installed packages are skipped.
#
# Note: fwildclusterboot / wildrwolf are intentionally OMITTED. Both require
# gfortran from source on R 4.5+; sandwich::vcovBS provides the same Wild
# cluster bootstrap procedure for our specs ([LEARN:env] 2026-05-06).
# =============================================================================

required <- c(
  # tidyverse load + manipulate
  "haven",        # read_dta — preserves Korean labels as attributes
  "dplyr",        # mutate, rename, across, group_by, summarise
  "tidyr",        # reserved for downstream pivot ops
  "tibble",       # tribble for var_dictionary
  "readr",        # write_csv

  # outlier policy
  "DescTools",    # Winsorize

  # paths
  "fs",
  "here",

  # estimation + Wild bootstrap fallback (used by P2/P3)
  "fixest",
  "modelsummary",
  "sandwich",     # vcovBS — Wild cluster bootstrap
  "rdrobust",     # MSE-optimal bandwidth (T3)
  "broom"
)

installed <- rownames(installed.packages())
to_install <- setdiff(required, installed)

if (length(to_install) == 0L) {
  message("[setup] All ", length(required), " required packages already installed.")
} else {
  message("[setup] Installing ", length(to_install), " package(s): ",
          paste(to_install, collapse = ", "))
  install.packages(to_install, repos = "https://cloud.r-project.org")
}

# Sanity: confirm each loads (without attaching)
ok <- vapply(required, function(p) requireNamespace(p, quietly = TRUE), logical(1))

if (any(!ok)) {
  warning("[setup] Failed to load: ", paste(required[!ok], collapse = ", "),
          ". Install manually with install.packages() and re-run this script.")
} else {
  message("[setup] All ", length(required), " packages load successfully.")
}

invisible(list(required = required, installed_now = to_install, ok = ok))
