# =============================================================================
# 15b_attrition_placebo_full.R — Differential-attrition placebo at T1, T2, T3
# (Wave 7 polish r2, M5-G).
#
# Extends the T2-only attrition placebo in 10_alpha3_estimation.R (Phase 6)
# to all three bandwidths reported in the main analysis.
#
# Output:
#   _outputs_eligibility/attrition_placebo_full.rds
#   _outputs_eligibility/tab_attrition_placebo_full_en.tex
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tibble); library(rdrobust); library(haven)
  library(fs); library(here)
})
set.seed(20260504L)

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
  here::here("scripts", "R", "_outputs_eligibility")
panel <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

attrition_df <- panel |>
  dplyr::filter(year == 2018L) |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(
    n_years_observed = dplyr::first(n_years),
    rv_2018 = dplyr::first(rv_2018),
    .groups = "drop"
  ) |>
  dplyr::mutate(full_panel = as.integer(n_years_observed == 5L))

# T1 = ±500, T2 = ±1000, T3 = MSE-optimal (let rdrobust pick)
bandwidths <- list(T1 = 500, T2 = 1000, T3 = NULL)

run_one <- function(label, h) {
  args <- list(y = attrition_df$full_panel, x = attrition_df$rv_2018,
               cluster = attrition_df$hh_id)
  if (!is.null(h)) args$h <- h
  rd <- tryCatch(do.call(rdrobust, args), error = function(e) NULL)
  if (is.null(rd))
    return(tibble::tibble(bw_id = label, h = NA_real_, estimate = NA, se = NA,
                          p_value = NA, n_obs = NA_integer_))
  tibble::tibble(
    bw_id    = label,
    h        = as.numeric(if (!is.null(h)) h else rd$bws[1,1]),
    estimate = rd$Estimate[1L, 1L],
    se       = rd$se[1L, 1L],
    p_value  = rd$pv[1L, 1L],
    n_obs    = sum(rd$N_h)
  )
}

results <- purrr::map2_dfr(names(bandwidths), bandwidths, run_one)

saveRDS(results, file.path(out_dir, "attrition_placebo_full.rds"))

# Table
fmt <- function(x, d = 3) ifelse(is.na(x), "—",
                                  formatC(x, format = "f", digits = d))
fmt_h <- function(x) ifelse(is.na(x), "—", formatC(x, format = "f", digits = 0, big.mark = ","))
fmt_n <- function(x) ifelse(is.na(x), "—", formatC(x, format = "d", big.mark = ","))

rows <- character()
for (i in seq_len(nrow(results))) {
  r <- results[i, ]
  rows <- c(rows, sprintf(
    "%s & %s & %s & %s & %s & %s \\\\",
    r$bw_id,
    fmt_h(r$h),
    fmt(r$estimate, 3),
    fmt(r$se, 3),
    fmt(r$p_value, 3),
    fmt_n(r$n_obs)
  ))
}

tex <- paste0(
  "\\begin{table}[ht]\n\\centering\n",
  "\\caption{Differential-attrition placebo across bandwidths (Spec A)}\n",
  "\\label{tab:attrition-placebo-full}\n\\small\n",
  "\\begin{tabular}{lrrrrr}\n\\toprule\n",
  "Bandwidth & $h$ (m\\textsuperscript{2}) & Estimate & SE & $p$-value & $N$ \\\\\n",
  "\\midrule\n",
  paste(rows, collapse = "\n"),
  "\n\\bottomrule\n\\end{tabular}\n\\\\\n",
  "\\footnotesize\\textit{Coefficient on $D_i$ (statutorily-eligible) in a placebo RDD on the household-level full-panel indicator $\\mathbf{1}\\{n_{\\text{years}}=5\\}$. ",
  "T3 bandwidth selected via \\texttt{rdrobust} MSE-optimal. ",
  "Cluster-robust SE (hh\\_id). Null of equal full-panel coverage across the eligibility cutoff is not rejected at any bandwidth.}\n",
  "\\end{table}\n"
)
writeLines(tex, file.path(out_dir, "tab_attrition_placebo_full_en.tex"))

message(sprintf("15b_attrition_placebo_full.R: T1/T2/T3 attrition placebo computed."))
print(results)
