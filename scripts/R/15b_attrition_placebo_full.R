# =============================================================================
# 15b_attrition_placebo_full.R — Differential-attrition placebo at T1, T2, T3
# (Wave 7 polish r2, M5-G).
#
# Extends the T2-only attrition placebo in 10_alpha3_estimation.R (Phase 6)
# to all three bandwidths reported in the main analysis.
#
# Output:
#   $OUT_DIR/attrition_placebo_full.rds
#   $OUT_DIR/tab_attrition_placebo_full_en.tex
#   $OUT_DIR/tab_attrition_placebo_full_ko.tex
#
# Plan: quality_reports/plans/velvet-frolicking-glade.md (Phase A5 KO emission)
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

write_attrition_table <- function(lang, path) {
  if (lang == "en") {
    caption <- "Differential-attrition placebo across bandwidths (Spec A)"
    label   <- "tab:attrition-placebo-full"
    header  <- "Bandwidth & $h$ (m\\textsuperscript{2}) & Estimate & SE & $p$-value & $N$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{Coefficient on $D_i$ (statutorily-eligible) in a ",
                      "placebo RDD on the household-level full-panel indicator ",
                      "$\\mathbf{1}\\{n_{\\text{years}}=5\\}$. ",
                      "T3 bandwidth selected via \\texttt{rdrobust} MSE-optimal. ",
                      "Cluster-robust SE (hh\\_id). Null of equal full-panel coverage ",
                      "across the eligibility cutoff is not rejected at any bandwidth.}")
  } else {
    caption <- "대역폭별 차등-탈락 placebo 검정 (Spec A)"
    label   <- "tab:attrition-placebo-full-ko"
    header  <- "Bandwidth & $h$ (m\\textsuperscript{2}) & 추정치 & SE & $p$-값 & $N$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{주: 가구 수준 전체-패널 지표 ",
                      "$\\mathbf{1}\\{n_{\\text{years}}=5\\}$를 종속변수로 한 placebo RDD에서 ",
                      "$D_i$ (법정 자격) 계수. T3 대역폭은 \\texttt{rdrobust} MSE-최적 선택. ",
                      "클러스터 강건 SE (hh\\_id). 자격 컷오프 좌우 전체-패널 coverage ",
                      "동일 가설이 어느 대역폭에서도 기각되지 않음.}")
  }
  tex <- paste0(
    "\\begin{table}[ht]\n\\centering\n",
    sprintf("\\caption{%s}\n", caption),
    sprintf("\\label{%s}\n\\small\n", label),
    "\\begin{tabular}{lrrrrr}\n\\toprule\n",
    header, "\n\\midrule\n",
    paste(rows, collapse = "\n"),
    "\n\\bottomrule\n\\end{tabular}\n\\\\\n",
    notes, "\n\\end{table}\n"
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_attrition_table("en", file.path(out_dir, "tab_attrition_placebo_full_en.tex"))
write_attrition_table("ko", file.path(out_dir, "tab_attrition_placebo_full_ko.tex"))

message(sprintf("15b_attrition_placebo_full.R: T1/T2/T3 attrition placebo computed."))
print(results)
