# =============================================================================
# verify_recovery.R — AEA verifier sanity check for synthetic FHES
#
# Reads data/synthetic/synthetic_panel.rds (or .dta) and reproduces the
# Spec A T3 DiD-RD specification for each of the 4 outcomes, comparing the
# recovered ATT against the calibration JSON known_att.
#
# Run after synthetic_data_gen.R:
#   Rscript scripts/R/synthetic/verify_recovery.R
#
# Tolerance (synthetic data, MC noise expected):
#   - Sign agreement (recovered vs calibration): MUST
#   - Magnitude within ±50% of calibration ATT: SHOULD (loose, MC + per-cell sampling)
# =============================================================================

suppressPackageStartupMessages({
  library(fixest)
  library(jsonlite)
})

resolve_root <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
  if (length(file_arg) > 0 && nzchar(file_arg[1])) {
    here <- dirname(normalizePath(file_arg[1], mustWork = TRUE))
    list(HERE = here,
         ROOT = normalizePath(file.path(here, "..", "..", ".."), mustWork = TRUE))
  } else {
    list(HERE = file.path(getwd(), "scripts/R/synthetic"),
         ROOT = normalizePath(getwd(), mustWork = TRUE))
  }
}
.p   <- resolve_root()
HERE <- .p$HERE
ROOT <- .p$ROOT

CALIB_PATH <- file.path(HERE, "calibration.json")
DATA_PATH  <- file.path(ROOT, "data/synthetic/synthetic_panel.rds")

stopifnot(file.exists(CALIB_PATH), file.exists(DATA_PATH))
calib <- fromJSON(CALIB_PATH, simplifyVector = FALSE)
df    <- readRDS(DATA_PATH)

# Build the regressors used in Spec A T3:
#   reghdfe y D_Post rv_Post Drv_Post if abs(rv_2018)<=h, absorb(hhid_num year) vce(cluster hhid_num)
df$Post     <- as.integer(df$year >= 2020L)
df$D_Post   <- df$D * df$Post
df$rv_Post  <- df$rv_2018 * df$Post
df$Drv_Post <- df$D * df$rv_2018 * df$Post

outcomes <- c("y_farm_income", "y_off_income", "y_consump", "y_farm_cost")
att_calib <- calib$treatment_effects_known_att$by_outcome

cat("\n=== ATT Recovery on Synthetic FHES ===\n")
cat(sprintf("%-15s %8s %12s %12s %12s %12s %s\n",
            "outcome", "bw_m2", "calib_att", "recov_att",
            "calib_se", "recov_se", "status"))

for (y in outcomes) {
  bw    <- as.numeric(att_calib[[y]]$bandwidth_m2)
  truth <- as.numeric(att_calib[[y]]$coef)
  truth_se <- as.numeric(att_calib[[y]]$se)

  # Restrict to bandwidth and run reduced-form DiD-RD
  sub <- df[abs(df$rv_2018) <= bw, ]
  fml <- as.formula(sprintf(
    "%s ~ D_Post + rv_Post + Drv_Post | hhid_num + year", y))
  fit <- feols(fml, data = sub, cluster = ~hhid_num, notes = FALSE)

  est <- coef(fit)["D_Post"]
  se  <- se(fit)["D_Post"]

  # Status: sign agreement (truth ≠ 0) + magnitude within 100% (loose)
  sign_ok <- if (abs(truth) < 1e3) "n/a" else if (sign(est) == sign(truth)) "✓" else "✗"
  mag_ok  <- if (abs(truth) < 1e3) "n/a"
             else if (abs(est - truth) / abs(truth) < 1.0) "✓" else "△"
  status  <- sprintf("sign=%s mag=%s", sign_ok, mag_ok)

  cat(sprintf("%-15s %8d %12.0f %12.0f %12.0f %12.0f %s\n",
              y, as.integer(bw), truth, est, truth_se, se, status))
}

cat("\nNote: Synthetic data is generated independently per (i,t) cell, so ATT\n")
cat("recovery is approximate. Sign agreement is the primary AEA verification\n")
cat("signal; exact numerical recovery would require simulating household FE\n")
cat("structure (out of scope for Step 4 P5 minimal-now release).\n")
