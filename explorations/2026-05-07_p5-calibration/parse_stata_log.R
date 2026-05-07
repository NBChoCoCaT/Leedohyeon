# =============================================================================
# parse_stata_log.R — Extract D_Post coefficients from STATA reghdfe log
#
# Returns a data.frame with one row per estimate:
#   spec, bandwidth, outcome_var, outcome_label_ko, coef, se, n_obs, n_clusters
#
# Usage:
#   source("parse_stata_log.R")
#   est <- parse_d_post_estimates("path/to/02_analysis.log")
# =============================================================================

# Map Korean outcome label (from e(outcome) macro) → STATA variable name
# Source: 02_analysis.do lines 86-87 (YVARS / YLABS)
OUTCOME_KO_TO_VAR <- c(
  "농업소득"   = "y_farm_income",
  "농외소득"   = "y_off_income",
  "소비지출"   = "y_consump",
  "농업경영비" = "y_farm_cost"
)

parse_d_post_estimates <- function(log_path) {
  stopifnot(file.exists(log_path))
  L <- readLines(log_path, warn = FALSE)

  # Each estimate block in STATA log has a stable structure:
  #   ... HDFE Linear regression ...
  #   ... Number of obs   =      N_OBS
  #   ... Number of clusters (hhid_num) = N_CLUSTERS
  #   ... <var> | Coefficient std. err. ...
  #         D_Post |  COEF  SE  ...
  #   ...
  #   added macro:
  #         e(spec) : "..."
  #   added macro:
  #         e(bandwidth) : "..."
  #   added macro:
  #         e(outcome) : "..."
  #
  # Strategy: find every D_Post coefficient line; for each, scan backward for
  # n_obs / n_clusters / regression header; scan forward for the three macros.

  d_post_re   <- "^\\s*D_Post\\s*\\|\\s*(-?[0-9.]+(?:e[+-]?[0-9]+)?)\\s+([0-9.]+(?:e[+-]?[0-9]+)?)"
  nobs_re     <- "Number of obs\\s*=\\s*([0-9,]+)"
  nclust_re   <- "Number of clusters \\(hhid_num\\)\\s*=\\s*([0-9,]+)"
  spec_re     <- "e\\(spec\\)\\s*:\\s*\"([^\"]+)\""
  bw_re       <- "e\\(bandwidth\\)\\s*:\\s*\"([^\"]+)\""
  outc_re     <- "e\\(outcome\\)\\s*:\\s*\"([^\"]+)\""

  # Index of every D_Post line
  d_post_idx <- grep(d_post_re, L)

  rows <- vector("list", length(d_post_idx))
  for (k in seq_along(d_post_idx)) {
    i <- d_post_idx[k]

    # Coefficient + SE
    m <- regmatches(L[i], regexec(d_post_re, L[i]))[[1]]
    coef <- as.numeric(m[2])
    se   <- as.numeric(m[3])

    # Backward scan (up to 50 lines) for n_obs, n_clusters
    back_lo <- max(1, i - 50)
    back    <- L[back_lo:(i - 1L)]
    n_obs <- {
      hit <- regmatches(back, regexec(nobs_re, back))
      hit <- Filter(function(x) length(x) > 0, hit)
      if (length(hit) == 0) NA_integer_ else as.integer(gsub(",", "", tail(hit, 1)[[1]][2]))
    }
    n_clust <- {
      hit <- regmatches(back, regexec(nclust_re, back))
      hit <- Filter(function(x) length(x) > 0, hit)
      if (length(hit) == 0) NA_integer_ else as.integer(gsub(",", "", tail(hit, 1)[[1]][2]))
    }

    # Forward scan (up to 50 lines) for spec / bw / outcome macros
    fwd_hi  <- min(length(L), i + 50)
    fwd     <- L[(i + 1L):fwd_hi]
    spec_v <- {
      hit <- regmatches(fwd, regexec(spec_re, fwd))
      hit <- Filter(function(x) length(x) > 0, hit)
      if (length(hit) == 0) NA_character_ else hit[[1]][2]
    }
    bw_v <- {
      hit <- regmatches(fwd, regexec(bw_re, fwd))
      hit <- Filter(function(x) length(x) > 0, hit)
      if (length(hit) == 0) NA_character_ else hit[[1]][2]
    }
    outc_ko <- {
      hit <- regmatches(fwd, regexec(outc_re, fwd))
      hit <- Filter(function(x) length(x) > 0, hit)
      if (length(hit) == 0) NA_character_ else hit[[1]][2]
    }

    outc_var <- if (!is.na(outc_ko) && outc_ko %in% names(OUTCOME_KO_TO_VAR)) {
      OUTCOME_KO_TO_VAR[[outc_ko]]
    } else {
      NA_character_
    }

    rows[[k]] <- data.frame(
      spec             = spec_v,
      bandwidth        = suppressWarnings(as.numeric(bw_v)),
      outcome_var      = outc_var,
      outcome_label_ko = outc_ko,
      coef             = coef,
      se               = se,
      n_obs            = n_obs,
      n_clusters       = n_clust,
      log_line         = i,
      stringsAsFactors = FALSE
    )
  }

  do.call(rbind, rows)
}
