# =============================================================================
# 04b_sido_robustness.R — sido_cd × year FE robustness (X5 fallback per FHES)
#
# Phase 1 Blockers Step 5. FHES Wave 1 does NOT release sgg_cd (sub-district);
# only sido (17 provinces) is published. Per the 2026-05-20 AskUserQuestion X5
# decision A', we substitute sido_cd × year FE absorption (provincial time
# shocks) for the originally-promised sgg_cd × Post FE.
#
# Specification (per cell):
#   y ~ D_Post + rv_Post + Drv_Post | hh_id + sido_cd^year, cluster = ~hh_id
#
# Cells: 4 primary outcomes × 3 bandwidths × 2 specs = 24
# Primary outcomes (per Step 1 swap 2026-05-20):
#   op_cost_ex_rent (lumpy-investment (S,s) — PRIMARY),
#   off_farm_income (Sandmo / precautionary labor),
#   consumption     (Blundell-Pistaferri smoothing),
#   farm_income     (omnibus)
#
# Inputs:
#   _outputs_symmetric/clean.rds (has sido_cd via 01e)
#   _outputs_symmetric/main_results.rds (only for T3 MSE comparison ref)
#
# Outputs:
#   _outputs_symmetric/sido_results.rds
#   _outputs_symmetric/tab_sido_robustness_en.tex
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(fixest)
  library(rdrobust)
  library(readr)
  library(fs)
  library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) set.seed(PROJECT_SEED) else set.seed(20260504L)

# Inputs ----------------------------------------------------------------------
out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
  here::here("scripts", "R", "_outputs_symmetric")

clean_path <- file.path(out_dir, "clean.rds")
main_path  <- file.path(out_dir, "main_results.rds")
stopifnot(fs::file_exists(clean_path), fs::file_exists(main_path))

df <- readRDS(clean_path)
df <- df |> dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled),
                                        haven::zap_labels))
stopifnot("sido_cd" %in% names(df))

main_results <- readRDS(main_path)

# Outcomes --------------------------------------------------------------------
outcomes <- c("op_cost_ex_rent", "off_farm_income", "consumption", "farm_income")

# Compute T3 MSE-optimal bandwidth per outcome (first-difference 2020-2022
# vs 2018-2019 baseline, mirroring 03_did_rd.R::compute_fd + mse_bw)
compute_fd <- function(df_master, pre_years, post_years) {
  agg_pre <- df_master |> dplyr::filter(year %in% pre_years) |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(dplyr::across(dplyr::all_of(outcomes), mean, na.rm = TRUE,
                                   .names = "pre_{.col}"),
                     .groups = "drop")
  agg_post <- df_master |> dplyr::filter(year %in% post_years) |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(dplyr::across(dplyr::all_of(outcomes), mean, na.rm = TRUE,
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

# Spec A bandwidths
fd_A <- compute_fd(df, pre_years = 2018:2019, post_years = 2020:2022)
h_mse_A <- vapply(outcomes, function(y) {
  mse_bw(fd_A[[paste0("d_", y)]], fd_A$rv_2018)
}, numeric(1))
names(h_mse_A) <- outcomes

# Spec B bandwidths (drop 2020)
fd_B <- compute_fd(df |> dplyr::filter(year != 2020L),
                   pre_years = 2018:2019, post_years = 2021:2022)
h_mse_B <- vapply(outcomes, function(y) {
  mse_bw(fd_B[[paste0("d_", y)]], fd_B$rv_2018)
}, numeric(1))
names(h_mse_B) <- outcomes

# Cell grid: 4 outcomes × 3 BW × 2 specs = 24
specs <- tidyr::expand_grid(
  spec    = c("A", "B"),
  outcome = outcomes,
  bw_id   = c("T1", "T2", "T3")
) |>
  dplyr::mutate(h = dplyr::case_when(
    bw_id == "T1" ~ 500,
    bw_id == "T2" ~ 1000,
    bw_id == "T3" & spec == "A" ~ h_mse_A[outcome],
    bw_id == "T3" & spec == "B" ~ h_mse_B[outcome]
  ))

stopifnot(nrow(specs) == 24L, all(!is.na(specs$h)))

# Fit per cell ----------------------------------------------------------------
fit_sido <- function(spec_row) {
  outc <- spec_row$outcome
  h    <- spec_row$h
  spec <- spec_row$spec

  if (spec == "A") {
    sub <- df |> dplyr::filter(abs(rv_2018) <= h)
    DP <- "D_Post"
    f  <- as.formula(sprintf(
      "%s ~ D_Post + rv_Post + Drv_Post | hh_id + sido_cd^year", outc))
  } else {
    sub <- df |>
      dplyr::filter(year != 2020L, abs(rv_2018) <= h) |>
      dplyr::mutate(
        Post_B     = as.integer(year >= 2021L),
        D_Post_B   = as.integer(D_treat) * Post_B,
        rv_Post_B  = rv_2018 * Post_B,
        Drv_Post_B = as.integer(D_treat) * rv_2018 * Post_B
      )
    DP <- "D_Post_B"
    f  <- as.formula(sprintf(
      "%s ~ D_Post_B + rv_Post_B + Drv_Post_B | hh_id + sido_cd^year", outc))
  }

  if (nrow(sub) < 20L) {
    return(list(fit = NULL, n_obs = nrow(sub), estimate = NA_real_,
                se = NA_real_, p_value = NA_real_))
  }
  fit <- tryCatch(
    fixest::feols(f, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit) || !DP %in% names(stats::coef(fit))) {
    return(list(fit = NULL, n_obs = nrow(sub), estimate = NA_real_,
                se = NA_real_, p_value = NA_real_))
  }
  est <- as.numeric(stats::coef(fit)[DP])
  se  <- as.numeric(sqrt(diag(stats::vcov(fit))[DP]))
  p   <- 2 * (1 - stats::pt(abs(est / se),
                            df = dplyr::n_distinct(sub$hh_id) - 1L))
  list(fit = fit, n_obs = fit$nobs, estimate = est, se = se, p_value = p)
}

message(sprintf(
  "04b_sido_robustness.R: fitting %d cells (sido_cd × year FE) ...",
  nrow(specs)))
t0 <- Sys.time()
fits <- purrr::pmap(specs, function(...) {
  spec_row <- tibble::tibble(...)
  fit_sido(spec_row)
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

# Compare to main DiD-RD (no sido FE) for direction/magnitude check ----------
# main_results uses op_cost (not op_cost_ex_rent) — only the 3 shared outcomes
# can be compared directly. Skip the comparison for op_cost_ex_rent.
shared <- intersect(outcomes, unique(main_results$results$outcome))
main_pivot <- main_results$results |>
  dplyr::filter(outcome %in% shared) |>
  dplyr::select(spec, outcome, bw_id,
                est_main = estimate, se_main = se_cluster,
                p_main   = p_cluster)
combined <- results |>
  dplyr::left_join(main_pivot, by = c("spec", "outcome", "bw_id")) |>
  dplyr::mutate(
    pct_delta_est = ifelse(is.na(est_main) | abs(est_main) < 1,
                           NA_real_,
                           100 * (estimate - est_main) / abs(est_main)),
    sign_flip = ifelse(is.na(est_main), NA, sign(estimate) != sign(est_main))
  )

# Save ------------------------------------------------------------------------
saveRDS(
  list(
    specs    = specs,
    results  = results,
    fits     = fits,
    combined = combined,
    h_mse_A  = h_mse_A,
    h_mse_B  = h_mse_B,
    elapsed_sec = elapsed,
    notes    = paste(
      "sido_cd × year FE absorption (X5 fallback A'); FHES Wave 1 sgg_cd",
      "unavailable. Cluster: hh_id (2,776 clusters).",
      "Primary outcome: op_cost_ex_rent (per Step 1 swap 2026-05-20)."
    )
  ),
  file.path(out_dir, "sido_results.rds")
)

# LaTeX table -----------------------------------------------------------------
fmt_num <- function(x, digits = 0) {
  ifelse(is.na(x), "", formatC(x, format = "f", big.mark = ",", digits = digits))
}

tbl <- results |>
  dplyr::arrange(spec, outcome, bw_id) |>
  dplyr::mutate(
    coef_str = paste0(fmt_num(estimate, 0), stars),
    se_str   = paste0("(", fmt_num(se, 0), ")"),
    n_str    = formatC(n_obs, format = "d", big.mark = ",")
  )

latex_block <- function(sub) {
  rows <- character()
  for (outc in outcomes) {
    sub_o <- sub |> dplyr::filter(outcome == outc) |> dplyr::arrange(bw_id)
    rows <- c(rows, sprintf("\\multicolumn{4}{l}{\\textit{%s}} \\\\",
                            gsub("_", "\\\\_", outc, fixed = TRUE)))
    for (i in seq_len(nrow(sub_o))) {
      rows <- c(rows, sprintf("%s & %s & %s & %s \\\\",
                              sub_o$bw_id[i], sub_o$coef_str[i],
                              sub_o$se_str[i], sub_o$n_str[i]))
    }
  }
  rows
}

tex_lines <- c(
  "\\begin{table}[t]",
  "\\centering",
  paste0("\\caption{Sub-national (sido) robustness: \\texttt{sido\\_cd}$\\times$",
         "\\texttt{year} FE; cluster = \\texttt{hh\\_id}.}"),
  "\\label{tab:sido_robustness_en}",
  "\\begin{tabular}{lrrr}",
  "\\toprule",
  "Bandwidth & Coef & SE & N \\\\",
  "\\midrule",
  "\\multicolumn{4}{l}{\\textbf{Spec A — full panel (Post = year $\\ge$ 2020)}} \\\\",
  latex_block(tbl |> dplyr::filter(spec == "A")),
  "\\midrule",
  "\\multicolumn{4}{l}{\\textbf{Spec B — drop 2020 (Post = year $\\ge$ 2021)}} \\\\",
  latex_block(tbl |> dplyr::filter(spec == "B")),
  "\\bottomrule",
  "\\end{tabular}",
  "\\\\",
  paste0("\\footnotesize\\textit{Province-by-year FE (\\texttt{sido\\_cd}$\\times$",
         "\\texttt{year}) absorbs province-specific time shocks. ",
         "FHES Wave 1 does not release sgg\\_cd (sub-district, ~250); sido ",
         "(17 provinces; 16 in symmetric panel) is the finest available ",
         "geography. Cluster-robust SE at \\texttt{hh\\_id} (2,776 clusters); ",
         "Wild bootstrap deferred to P3. * p$<$0.10, ** p$<$0.05, *** p$<$0.01.}"),
  "\\end{table}"
)
writeLines(tex_lines, file.path(out_dir, "tab_sido_robustness_en.tex"))

# Console summary -------------------------------------------------------------
sf <- sum(combined$sign_flip, na.rm = TRUE)
nsf <- sum(!is.na(combined$sign_flip))
message(sprintf(
  "04b_sido_robustness.R: %d cells in %.1fs. Sign-flips (shared outcomes): %d/%d.",
  nrow(results), elapsed, sf, nsf))
if (nsf > 0L) {
  med_d <- median(abs(combined$pct_delta_est), na.rm = TRUE)
  message(sprintf("  Median |%%Δ coef| vs main: %.1f%% (shared outcomes only)", med_d))
}
message(sprintf("  Output: sido_results.rds + tab_sido_robustness_en.tex"))

`%||%` <- function(a, b) if (!is.null(a)) a else b
