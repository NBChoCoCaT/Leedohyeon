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
  "broom",

  # P2 additions
  "survey",       # svydesign — Solon-Haider-Wooldridge weighted Table 1 (§6)
  "purrr",        # pmap — 32-cell spec tibble in 03_did_rd.R

  # P3a additions (Tier 1 mandatory)
  "rddensity",    # Cattaneo-Jansson-Ma McCrary density test (04_robust.R)
  "ggplot2"       # plot composition + theme_pidps_custom (05_figures.R) — usually present but explicit
)

# Optional packages — install-on-best-effort; absence triggers documented
# fallback paths. Install failures here are warnings, not errors.
optional <- c(
  "fwildclusterboot",  # true Wild cluster bootstrap for fixest fits;
                       # fallback: sandwich::vcovBS.lm() with factor() dummies
                       # ([LEARN:env] 2026-05-14 sandwich × fixest incompat).
  "wildrwolf"          # Wild Romano-Wolf for fixest; rwolf2 STATA equivalent.
                       # STATA term paper itself fell back to Wild + Holm
                       # ([LEARN:methods] P3a Phase 1) so absence is acceptable.
)

installed <- rownames(installed.packages())
to_install <- setdiff(required, installed)

if (length(to_install) == 0L) {
  message("[setup] All ", length(required), " required packages already installed.")
} else {
  message("[setup] Installing ", length(to_install), " required package(s): ",
          paste(to_install, collapse = ", "))
  install.packages(to_install, repos = "https://cloud.r-project.org")
}

# Optional packages — best-effort install (gfortran-dependent on R 4.5+).
opt_to_install <- setdiff(optional, installed)
if (length(opt_to_install) > 0L) {
  message("[setup] Attempting optional packages (fallback exists on failure): ",
          paste(opt_to_install, collapse = ", "))
  for (p in opt_to_install) {
    tryCatch(
      install.packages(p, repos = "https://cloud.r-project.org"),
      error = function(e) message("[setup] OPTIONAL ", p, " install failed: ",
                                  conditionMessage(e))
    )
  }
}

# Sanity: confirm each REQUIRED loads (without attaching).
ok <- vapply(required, function(p) requireNamespace(p, quietly = TRUE), logical(1))
opt_ok <- vapply(optional, function(p) requireNamespace(p, quietly = TRUE), logical(1))

if (any(!ok)) {
  warning("[setup] Failed to load REQUIRED: ", paste(required[!ok], collapse = ", "),
          ". Install manually with install.packages() and re-run this script.")
} else {
  message("[setup] All ", length(required), " required packages load successfully.")
}
message("[setup] Optional packages available: ",
        if (any(opt_ok)) paste(optional[opt_ok], collapse = ", ") else "none",
        if (any(!opt_ok)) paste0(" (missing: ", paste(optional[!opt_ok], collapse = ", "),
                                 " — fallback paths active)") else "")

invisible(list(required = required, optional = optional,
               installed_now = c(to_install, opt_to_install),
               ok = ok, opt_ok = opt_ok))
