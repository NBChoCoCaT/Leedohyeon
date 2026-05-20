# =============================================================================
# 03d_specC.R — Spec C: covariate-rich DiD-RD (farm_type × Post + age × Post)
#
# Phase 1 Blockers Step 6. Per the 2026-05-20 X10/Spec-B-C user decision (Option C),
# Spec C is reported as a separate covariate-richness robustness alongside Spec B
# (temporal restriction).
#
# Specification:
#   y ~ D_Post + rv_Post + Drv_Post
#       + i(farm_type, Post) + i(age_code_base, Post)
#       | hh_id + year, cluster = ~hh_id
#
#   - Time-invariant covariates (farm_type, age_code_base) absorbed by hh_id FE.
#   - Covariate × Post interactions allow heterogeneous post-period responses by
#     farm type (paddy / upland / livestock / orchard / etc.) and age cohort
#     (30s / 40s / 50s / 60s / 70+). Identifies the treatment effect off
#     within-(stratum, time) variation.
#
# Note on the original "education tier" plan: edu_tier (교육정도코드) is
# in the raw 가구원현황 CSV but NOT aggregated into panel_2018_2022.dta. Adding
# it would require a household-head extraction merge from raw data — deferred
# to Phase 2. Spec C as implemented uses farm_type + age_code_base, which are
# already in clean.rds and capture the cross-section sources of heterogeneity
# that "education tier" would have proxied (sectoral + cohort variation).
#
# Cells: 4 primary outcomes × 3 bandwidths = 12 (Spec C is a single-spec
# variant, not a 2-spec ladder).
# Primary outcomes (per Step 1 swap): op_cost_ex_rent, off_farm_income,
# consumption, farm_income.
#
# Inputs:
#   _outputs_symmetric/clean.rds
#   _outputs_symmetric/main_results.rds (for T3 MSE bandwidths)
#
# Outputs:
#   _outputs_symmetric/specC_results.rds
#   _outputs_symmetric/tab_specC.tex
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(fixest)
  library(rdrobust)
  library(fs)
  library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) set.seed(PROJECT_SEED) else set.seed(20260504L)

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
  here::here("scripts", "R", "_outputs_symmetric")

clean_path <- file.path(out_dir, "clean.rds")
stopifnot(fs::file_exists(clean_path))
df <- readRDS(clean_path)
df <- df |> dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled),
                                        haven::zap_labels))
stopifnot(all(c("farm_type", "age_code_base") %in% names(df)))

outcomes <- c("op_cost_ex_rent", "off_farm_income", "consumption", "farm_income")

# T3 MSE-optimal bandwidth per outcome (mirror 03_did_rd.R) -------------------
compute_fd <- function(df_master, pre_years, post_years) {
  agg_pre <- df_master |> dplyr::filter(year %in% pre_years) |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(dplyr::across(dplyr::all_of(outcomes),
                                   \(x) mean(x, na.rm = TRUE),
                                   .names = "pre_{.col}"),
                     .groups = "drop")
  agg_post <- df_master |> dplyr::filter(year %in% post_years) |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(dplyr::across(dplyr::all_of(outcomes),
                                   \(x) mean(x, na.rm = TRUE),
                                   .names = "post_{.col}"),
                     .groups = "drop")
  hh_baseline <- df_master |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(rv_2018 = dplyr::first(rv_2018), .groups = "drop")
  fd <- hh_baseline |>
    dplyr::inner_join(agg_pre,  by = "hh_id") |>
    dplyr::inner_join(agg_post, by = "hh_id")
  for (v in outcomes) {
    fd[[paste0("d_", v)]] <- fd[[paste0("post_", v)]] - fd[[paste0("pre_", v)]]
  }
  fd |> dplyr::filter(!is.na(rv_2018))
}

mse_bw <- function(d_y, rv) {
  bw <- tryCatch(
    rdrobust::rdbwselect(y = d_y, x = rv, c = 0, p = 1,
                         bwselect = "mserd", masspoints = "off"),
    error = function(e) NULL
  )
  if (is.null(bw)) return(NA_real_)
  as.numeric(bw$bws[1, 1])
}

fd_A <- compute_fd(df, pre_years = 2018:2019, post_years = 2020:2022)
h_mse <- vapply(outcomes, function(y) {
  mse_bw(fd_A[[paste0("d_", y)]], fd_A$rv_2018)
}, numeric(1))
names(h_mse) <- outcomes

specs <- tidyr::expand_grid(
  outcome = outcomes,
  bw_id   = c("T1", "T2", "T3")
) |>
  dplyr::mutate(h = dplyr::case_when(
    bw_id == "T1" ~ 500,
    bw_id == "T2" ~ 1000,
    bw_id == "T3" ~ h_mse[outcome]
  ))

stopifnot(nrow(specs) == 12L, all(!is.na(specs$h)))

# Fit Spec C per cell ---------------------------------------------------------
fit_specC <- function(spec_row) {
  outc <- spec_row$outcome
  h    <- spec_row$h
  sub  <- df |> dplyr::filter(abs(rv_2018) <= h)

  if (nrow(sub) < 50L) {
    return(list(fit = NULL, n_obs = nrow(sub), estimate = NA_real_,
                se = NA_real_, p_value = NA_real_))
  }

  f <- as.formula(sprintf(
    "%s ~ D_Post + rv_Post + Drv_Post + i(farm_type, Post) + i(age_code_base, Post) | hh_id + year",
    outc))

  fit <- tryCatch(
    fixest::feols(f, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit) || !"D_Post" %in% names(stats::coef(fit))) {
    return(list(fit = NULL, n_obs = nrow(sub), estimate = NA_real_,
                se = NA_real_, p_value = NA_real_))
  }
  est <- as.numeric(stats::coef(fit)["D_Post"])
  se  <- as.numeric(sqrt(diag(stats::vcov(fit))["D_Post"]))
  p   <- 2 * (1 - stats::pt(abs(est / se),
                            df = dplyr::n_distinct(sub$hh_id) - 1L))
  list(fit = fit, n_obs = fit$nobs, estimate = est, se = se, p_value = p)
}

message(sprintf("03d_specC.R: fitting %d Spec C cells (farm_type × Post + age × Post)...",
                nrow(specs)))
t0 <- Sys.time()
fits <- purrr::pmap(specs, function(...) {
  fit_specC(tibble::tibble(...))
})
elapsed <- as.numeric(Sys.time() - t0, units = "secs")

results <- specs |>
  dplyr::mutate(
    n_obs    = vapply(fits, function(r) as.integer(r$n_obs %||% NA_integer_),
                     integer(1)),
    estimate = vapply(fits, function(r) r$estimate, numeric(1)),
    se       = vapply(fits, function(r) r$se,       numeric(1)),
    p_value  = vapply(fits, function(r) r$p_value,  numeric(1)),
    stars = dplyr::case_when(
      is.na(p_value) ~ "",
      p_value < 0.01 ~ "***",
      p_value < 0.05 ~ "**",
      p_value < 0.10 ~ "*",
      TRUE ~ ""
    )
  )

saveRDS(
  list(
    specs = specs, results = results, fits = fits,
    h_mse = h_mse, elapsed_sec = elapsed,
    notes = paste(
      "Spec C: farm_type × Post + age_code_base × Post interactions.",
      "edu_tier deferred (requires raw 가구원현황 merge — Phase 2).",
      "All other settings match Spec A (cluster=~hh_id, hh_id + year FE)."
    )
  ),
  file.path(out_dir, "specC_results.rds")
)

# LaTeX -----------------------------------------------------------------------
fmt_num <- function(x, digits = 0) {
  ifelse(is.na(x), "", formatC(x, format = "f", big.mark = ",", digits = digits))
}

tbl <- results |>
  dplyr::arrange(outcome, bw_id) |>
  dplyr::mutate(
    coef_str = paste0(fmt_num(estimate, 0), stars),
    se_str   = paste0("(", fmt_num(se, 0), ")"),
    n_str    = formatC(n_obs, format = "d", big.mark = ",")
  )

latex_rows <- character()
for (outc in outcomes) {
  sub_o <- tbl |> dplyr::filter(outcome == outc) |> dplyr::arrange(bw_id)
  latex_rows <- c(latex_rows, sprintf("\\multicolumn{4}{l}{\\textit{%s}} \\\\",
                                       gsub("_", "\\\\_", outc, fixed = TRUE)))
  for (i in seq_len(nrow(sub_o))) {
    latex_rows <- c(latex_rows, sprintf("%s & %s & %s & %s \\\\",
                                         sub_o$bw_id[i], sub_o$coef_str[i],
                                         sub_o$se_str[i], sub_o$n_str[i]))
  }
}

tex_lines <- c(
  "\\begin{table}[t]",
  "\\centering",
  paste0("\\caption{Spec C — covariate-rich robustness: farm\\_type$\\times$Post + ",
         "age\\_code\\_base$\\times$Post interactions. Cluster = \\texttt{hh\\_id}.}"),
  "\\label{tab:specC}",
  "\\begin{tabular}{lrrr}",
  "\\toprule",
  "Bandwidth & Coef & SE & N \\\\",
  "\\midrule",
  latex_rows,
  "\\bottomrule",
  "\\end{tabular}",
  "\\\\",
  paste0("\\footnotesize\\textit{Spec C adds farm\\_type$\\times$Post (9 farm-",
         "type levels) and age\\_code\\_base$\\times$Post (5 age-cohort levels) ",
         "interactions to Spec A, identifying the treatment effect off within-",
         "(stratum, time) variation. Cluster-robust SE at \\texttt{hh\\_id}; ",
         "hh\\_id + year FE absorbs household-level time-invariant traits and ",
         "common time shocks. edu\\_tier merge deferred to Phase 2. ",
         "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.}"),
  "\\end{table}"
)
writeLines(tex_lines, file.path(out_dir, "tab_specC.tex"))

message(sprintf("03d_specC.R: %d cells in %.1fs.", nrow(results), elapsed))
message(sprintf("  Output: specC_results.rds + tab_specC.tex"))

`%||%` <- function(a, b) if (!is.null(a)) a else b
