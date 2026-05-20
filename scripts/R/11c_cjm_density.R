# =============================================================================
# 11c_cjm_density.R — Cattaneo-Jansson-Ma 2020 density-discontinuity test
#                     at multiple bandwidths (Phase 2 Step 2, L3 MAJ-1)
#
# Purpose: replace ad-hoc narrow-window McCrary defense with the modern CJM
# density test (rddensity package), reporting conventional + bias-corrected +
# robust p-values at full sample, ±500, ±1000, and ±3300 (≈ T3 MSE) bandwidths.
#
# The Phase-1.5 paper text already cites the McCrary result on the symmetric
# sample (t = 0.68, p = .50 full; p = .064 / .076 / .36 at narrow / T2 / T3).
# Lens 3 MAJ-1 noted that the "narrow-window p ≈ .07 reflects noisy local-
# window estimation rather than manipulation" defense is verbal, not
# falsifiable. CJM is the modern replacement: it uses local-polynomial density
# estimation and reports bias-corrected p-values that correct the local-window
# small-sample bias McCrary is known to suffer from.
#
# Inputs:
#   _outputs_symmetric/clean.rds
#
# Outputs:
#   _outputs_symmetric/cjm_density_test.rds
#   _outputs_symmetric/tab_cjm_density_en.tex
#   _outputs_symmetric/tab_cjm_density_ko.tex
#
# Plan: quality_reports/plans/graceful-percolating-dragonfly.md (Step 2)
#       quality_reports/plans/velvet-frolicking-glade.md (Phase A2 KO emission)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(fs)
  library(here)
})
set.seed(20260504L)

out_dir <- here::here("scripts", "R", "_outputs_symmetric")
rds_path <- file.path(out_dir, "cjm_density_test.rds")

# Cache-aware: re-run the rddensity computation only when the package is
# available AND --force flag is set (or the cache RDS is missing). This lets
# the script regenerate the bilingual LaTeX tables from the cached results
# in environments where rddensity is not installed (e.g., a follow-up KO
# emission session without env reset). The Wave 10 .rds is the cached truth.
have_rddensity <- requireNamespace("rddensity", quietly = TRUE)
force_recompute <- nzchar(Sys.getenv("CJM_FORCE_RECOMPUTE", ""))
use_cache <- fs::file_exists(rds_path) && (!have_rddensity || !force_recompute)

if (use_cache) {
  message("11c_cjm_density.R: using cached results (",
          ifelse(have_rddensity, "force flag not set", "rddensity not available"),
          "); writing LaTeX tables only.")
  results_df <- readRDS(rds_path)$results
} else {
  if (!have_rddensity) {
    stop("rddensity not installed and no cached results at: ", rds_path)
  }
  clean_path <- file.path(out_dir, "clean.rds")
  stopifnot(fs::file_exists(clean_path))
  df <- readRDS(clean_path)
  df <- df |> dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled),
                                          haven::zap_labels))
  d18 <- df |> dplyr::filter(year == 2018L)
  stopifnot(nrow(d18) == 2178L)

  # Bandwidth grid
  windows <- tibble::tibble(
    name = c("full", "T1 (±500)", "T2 (±1,000)", "T3 (≈MSE 3,300)"),
    h    = c(Inf, 500, 1000, 3300)
  )

  run_cjm_full <- function(name, h) {
    rv <- d18$rv_2018
    if (is.finite(h)) rv <- rv[abs(rv) <= h]
    if (length(rv) < 50L) return(NULL)
    fit <- tryCatch(
      rddensity::rddensity(X = rv, c = 0),
      error = function(e) NULL
    )
    if (is.null(fit)) return(NULL)
    list(
      window    = name, h = h, n = length(rv),
      coef_diff = as.numeric(fit$hat$diff),
      t_conv    = if (!is.null(fit$test$t_asy)) as.numeric(fit$test$t_asy) else NA_real_,
      p_conv    = if (!is.null(fit$test$p_asy)) as.numeric(fit$test$p_asy) else NA_real_,
      t_jk      = as.numeric(fit$test$t_jk),
      p_jk      = as.numeric(fit$test$p_jk)
    )
  }

  message(sprintf("11c_cjm_density.R: fitting %d window CJM density tests ...",
                  nrow(windows)))
  results <- purrr::map2(windows$name, windows$h, run_cjm_full)

  results_df <- purrr::map_dfr(results, function(r) {
    if (is.null(r)) return(tibble::tibble())
    tibble::tibble(
      window = r$window, h = r$h, n = r$n,
      coef_diff = r$coef_diff,
      t_conv = r$t_conv, p_conv = r$p_conv,
      t_jk = r$t_jk, p_jk = r$p_jk
    )
  })

  saveRDS(
    list(
      results = results_df,
      notes = paste(
        "Cattaneo-Jansson-Ma 2020 (rddensity package) density-discontinuity",
        "test at the 0.5 ha cutoff. Symmetric-screened 2018 baseline (n=2,178).",
        "p_conv = asymptotic (conventional); p_jk = jackknife (robust-to-",
        "bandwidth-choice). The jackknife p is the closest analog to the",
        "CJM 2020 robust p-value and is the preferred headline."
      )
    ),
    rds_path
  )
}  # end of recompute branch

# LaTeX
fmt_num <- function(x, digits = 3) {
  ifelse(is.na(x), "", formatC(x, format = "f", digits = digits))
}
fmt_int <- function(x) {
  ifelse(is.na(x) | is.infinite(x), "all", formatC(round(x), format = "d", big.mark = ","))
}
star <- function(p) {
  ifelse(is.na(p), "",
         ifelse(p < 0.01, "***",
                ifelse(p < 0.05, "**",
                       ifelse(p < 0.10, "*", ""))))
}

rows <- results_df |>
  dplyr::mutate(
    h_str       = fmt_int(h),
    n_str       = formatC(n, format = "d", big.mark = ","),
    coef_str    = fmt_num(coef_diff, 6),
    t_jk_str    = fmt_num(t_jk, 3),
    p_jk_str    = paste0(fmt_num(p_jk, 3), star(p_jk))
  )

# Bilingual window labels (KO uses the same Tk codes, only the "full" word changes)
window_ko <- c("full" = "전체", "T1 (±500)" = "T1 (±500)",
               "T2 (±1,000)" = "T2 (±1,000)",
               "T3 (≈MSE 3,300)" = "T3 (≈MSE 3,300)")

write_cjm_table <- function(lang, path) {
  tex_rows <- character()
  for (i in seq_len(nrow(rows))) {
    win_disp <- if (lang == "ko") window_ko[[rows$window[i]]]
                else rows$window[i]
    tex_rows <- c(tex_rows,
                  sprintf("%s & %s & %s & %s & %s \\\\",
                          win_disp, rows$h_str[i], rows$n_str[i],
                          rows$t_jk_str[i], rows$p_jk_str[i]))
  }

  if (lang == "en") {
    caption <- paste0("Cattaneo-Jansson-Ma (2020) density-discontinuity test ",
                      "at the 0.5\\,ha cutoff (\\texttt{rddensity} package, jackknife ",
                      "variance). Symmetric-screened 2018 baseline.")
    label   <- "tab:cjm_density_en"
    header  <- "Window & $h$ (m\\textsuperscript{2}) & $N$ & $t_{jk}$ & $p_{jk}$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{Jackknife-variance density-discontinuity ",
                      "test of \\citet{CalonicoCattaneoTitiunik2014_rdrobust}-style ",
                      "local-polynomial density estimation. The full sample, $\\pm500$, ",
                      "$\\pm 1{,}000$, and $\\pm 3{,}300$ windows are reported in ",
                      "parallel. Jackknife p-value is robust to bandwidth choice and ",
                      "preferred over McCrary (2008) for narrow-window inference. ",
                      "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.}")
  } else {
    caption <- paste0("0.5\\,ha 컷오프에서 Cattaneo-Jansson-Ma (2020) ",
                      "밀도 불연속 검정 (\\texttt{rddensity} 패키지, jackknife ",
                      "분산). 대칭 스크리닝 2018년 기준연도 단면.")
    label   <- "tab:cjm_density_ko"
    header  <- "Window & $h$ (m\\textsuperscript{2}) & $N$ & $t_{jk}$ & $p_{jk}$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{주: \\citet{CalonicoCattaneoTitiunik2014_rdrobust} ",
                      "방식의 국소 다항 밀도 추정에 기반한 jackknife 분산 ",
                      "밀도 불연속 검정. 전체 표본, $\\pm 500$, $\\pm 1{,}000$, ",
                      "$\\pm 3{,}300$ 윈도우를 병렬 보고. Jackknife p-값은 ",
                      "bandwidth 선택에 강건하며 좁은 윈도우 추론에서 ",
                      "McCrary (2008)보다 권장됨. * p$<$0.10, ** p$<$0.05, *** p$<$0.01.}")
  }

  tex <- c(
    "\\begin{table}[t]",
    "\\centering",
    sprintf("\\caption{%s}", caption),
    sprintf("\\label{%s}", label),
    "\\begin{tabular}{llrrr}",
    "\\toprule",
    header,
    "\\midrule",
    tex_rows,
    "\\bottomrule",
    "\\end{tabular}",
    "\\\\",
    notes,
    "\\end{table}"
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_cjm_table("en", file.path(out_dir, "tab_cjm_density_en.tex"))
write_cjm_table("ko", file.path(out_dir, "tab_cjm_density_ko.tex"))

# Console summary
sig5 <- sum(!is.na(results_df$p_jk) & results_df$p_jk < 0.05)
sig10 <- sum(!is.na(results_df$p_jk) & results_df$p_jk < 0.10)
message(sprintf("11c_cjm_density.R: %d cells fit. p_jk < .05: %d/%d, < .10: %d/%d",
                nrow(results_df), sig5, nrow(results_df), sig10, nrow(results_df)))
print(results_df)
if (sig5 > 0L) {
  message("  WARNING: STOP CONDITION 2 — CJM bias-corrected narrow-window p<.05.")
}
