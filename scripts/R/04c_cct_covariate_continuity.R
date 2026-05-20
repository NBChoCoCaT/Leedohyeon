# =============================================================================
# 04c_cct_covariate_continuity.R — CCT 2014 covariate-continuity test at cutoff
#
# Phase 2 Step 1 (L3 MAJ-2 from post-Phase-1.5b synthesis). Standard RD
# diagnostic: verify that pre-determined household covariates are continuous
# across the 0.5-ha cutoff in the symmetric-screened analysis sample. Absent
# in Wave 9 v1; only the dropped-balance table (between sub-populations) was
# reported.
#
# Specification per covariate:
#   rdrobust(y = covariate_i, x = rv_2018_i, c = 0, p = 1,
#            bwselect = "mserd", kernel = "triangular",
#            cluster = hh_id)
#
# Reported per cell: robust coef + robust SE + robust p-value + bandwidth +
# N (effective sample at chosen bandwidth).
#
# 6 covariates × 3 bandwidths (T1 ±500, T2 ±1000, T3 MSE-optimal) = 18 cells.
#
# Sample: 2018 baseline cross-section of the symmetric-screened panel
# (2,178 households).
#
# Inputs:
#   _outputs_symmetric/clean.rds
#
# Outputs:
#   _outputs_symmetric/cct_covariate_results.rds
#   _outputs_symmetric/tab_cct_covariate_continuity_en.tex
#   _outputs_symmetric/tab_cct_covariate_continuity_ko.tex
#
# Plan: quality_reports/plans/graceful-percolating-dragonfly.md (Step 1)
#       quality_reports/plans/velvet-frolicking-glade.md (Phase A1 KO emission)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(rdrobust)
  library(fs)
  library(here)
})
set.seed(20260504L)

out_dir <- here::here("scripts", "R", "_outputs_symmetric")
clean_path <- file.path(out_dir, "clean.rds")
stopifnot(fs::file_exists(clean_path))

df <- readRDS(clean_path)
df <- df |> dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled),
                                        haven::zap_labels))
d18 <- df |> dplyr::filter(year == 2018L)
stopifnot(nrow(d18) == 2178L)

covariates <- c("age_code_base", "farm_type", "type_fulltime",
                "own_share_pre", "area_owned_2018", "off_inc_2018")
bandwidths <- c(T1 = 500, T2 = 1000, T3 = NA_real_)  # T3 = MSE-optimal

run_cell <- function(cov, bw_id, h) {
  if (is.na(h)) {
    # MSE-optimal via rdrobust default
    fit <- tryCatch(
      rdrobust::rdrobust(y = d18[[cov]], x = d18$rv_2018, c = 0, p = 1,
                         bwselect = "mserd", kernel = "triangular",
                         cluster = d18$hh_id),
      error = function(e) NULL
    )
  } else {
    fit <- tryCatch(
      rdrobust::rdrobust(y = d18[[cov]], x = d18$rv_2018, c = 0, p = 1,
                         h = h, kernel = "triangular",
                         cluster = d18$hh_id),
      error = function(e) NULL
    )
  }
  if (is.null(fit)) {
    return(tibble::tibble(covariate = cov, bw_id = bw_id, h = NA_real_,
                          coef = NA_real_, se = NA_real_, p_value = NA_real_,
                          n_left = NA_integer_, n_right = NA_integer_))
  }
  tibble::tibble(
    covariate = cov,
    bw_id     = bw_id,
    h         = as.numeric(fit$bws[1, 1]),
    coef      = as.numeric(fit$coef["Robust", 1]),
    se        = as.numeric(fit$se["Robust", 1]),
    p_value   = as.numeric(fit$pv["Robust", 1]),
    n_left    = as.integer(fit$N_h[1]),
    n_right   = as.integer(fit$N_h[2])
  )
}

message(sprintf("04c_cct_covariate_continuity.R: %d covariates × %d bw = %d cells",
                length(covariates), length(bandwidths),
                length(covariates) * length(bandwidths)))
t0 <- Sys.time()
results <- purrr::map_dfr(covariates, function(cov) {
  purrr::imap_dfr(bandwidths, function(h, bw_id) {
    run_cell(cov, bw_id, h)
  })
})
elapsed <- as.numeric(Sys.time() - t0, units = "secs")

results <- results |>
  dplyr::mutate(
    stars = dplyr::case_when(
      is.na(p_value) ~ "",
      p_value < 0.01 ~ "***",
      p_value < 0.05 ~ "**",
      p_value < 0.10 ~ "*",
      TRUE ~ ""
    )
  )

# Save
saveRDS(
  list(
    results = results,
    elapsed_sec = elapsed,
    notes = paste(
      "CCT 2014 covariate-continuity test (rdrobust default mserd).",
      "Standard RD diagnostic: verifies pre-determined covariates are",
      "continuous at the 0.5 ha cutoff in the symmetric-screened 2018",
      "baseline cross-section. Cluster: hh_id."
    )
  ),
  file.path(out_dir, "cct_covariate_results.rds")
)

# LaTeX table
fmt_num <- function(x, digits = 3) {
  ifelse(is.na(x), "", formatC(x, format = "f", digits = digits, big.mark = ","))
}
fmt_int <- function(x) {
  ifelse(is.na(x), "", formatC(x, format = "d", big.mark = ","))
}

tbl <- results |>
  dplyr::arrange(covariate, bw_id) |>
  dplyr::mutate(
    coef_str = paste0(fmt_num(coef, 3), stars),
    se_str   = paste0("(", fmt_num(se, 3), ")"),
    h_str    = fmt_int(round(h)),
    n_str    = fmt_int(n_left + n_right)
  )

# Bilingual covariate labels for KO row blocks. EN keeps the snake_case code id.
cov_label_ko <- c(
  age_code_base   = "세대주 연령 등급",
  farm_type       = "영농 유형",
  type_fulltime   = "전\\textperiodcentered{}겸업 구분",
  own_share_pre   = "기준연도 자작 비율 ($s_{0,i}$)",
  area_owned_2018 = "기준연도 자작 면적",
  off_inc_2018    = "기준연도 농외소득"
)

write_cct_table <- function(lang, path) {
  rows <- character()
  for (cov in covariates) {
    sub_c <- tbl |> dplyr::filter(covariate == cov) |> dplyr::arrange(bw_id)
    cov_disp <- if (lang == "ko") cov_label_ko[[cov]]
                else gsub("_", "\\\\_", cov, fixed = TRUE)
    rows <- c(rows,
              sprintf("\\multicolumn{4}{l}{\\textit{%s}} \\\\", cov_disp))
    for (i in seq_len(nrow(sub_c))) {
      rows <- c(rows,
                sprintf("%s ($h=%s$) & %s & %s & %s \\\\",
                        sub_c$bw_id[i], sub_c$h_str[i],
                        sub_c$coef_str[i], sub_c$se_str[i],
                        sub_c$n_str[i]))
    }
  }

  if (lang == "en") {
    caption <- paste0("Covariate continuity at the 0.5\\,ha cutoff ",
                      "(CCT 2014 \\texttt{rdrobust}, triangular kernel, cluster = ",
                      "\\texttt{hh\\_id}). 2018 baseline cross-section.")
    label   <- "tab:cct_covariate_continuity_en"
    header  <- "Bandwidth & Coef (robust) & SE & $N$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{Robust bias-corrected coefficient ",
                      "(\\citealp{CalonicoCattaneoTitiunik2014_rdrobust}) on each ",
                      "pre-determined household covariate evaluated at $rv_{2018,i} = 0$. ",
                      "$N$ is the effective sample within the chosen bandwidth ",
                      "(left + right of cutoff). T3 = MSE-optimal per outcome. ",
                      "Cluster-robust SE at \\texttt{hh\\_id}. * p$<$0.10, ** p$<$0.05, ",
                      "*** p$<$0.01.}")
  } else {  # ko
    caption <- paste0("0.5\\,ha 컷오프에서 사전결정 공변량의 연속성 검정 ",
                      "(CCT 2014 \\texttt{rdrobust}, 삼각 커널, 클러스터 = ",
                      "\\texttt{hh\\_id}). 2018년 기준연도 단면.")
    label   <- "tab:cct_covariate_continuity_ko"
    header  <- "Bandwidth & 계수 (robust) & SE & $N$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{주: 각 사전결정 공변량을 ",
                      "$rv_{2018,i} = 0$에서 평가한 robust 편향보정 계수 ",
                      "(\\citealp{CalonicoCattaneoTitiunik2014_rdrobust}). ",
                      "$N$은 선택된 bandwidth 내 유효 표본 (컷오프 좌우 합). ",
                      "T3 = 결과변수별 MSE 최적. 클러스터-강건 SE는 ",
                      "\\texttt{hh\\_id} 기준. * p$<$0.10, ** p$<$0.05, *** p$<$0.01.}")
  }

  tex <- c(
    "\\begin{table}[t]",
    "\\centering",
    sprintf("\\caption{%s}", caption),
    sprintf("\\label{%s}", label),
    "\\begin{tabular}{lrrr}",
    "\\toprule",
    header,
    "\\midrule",
    rows,
    "\\bottomrule",
    "\\end{tabular}",
    "\\\\",
    notes,
    "\\end{table}"
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_cct_table("en", file.path(out_dir, "tab_cct_covariate_continuity_en.tex"))
write_cct_table("ko", file.path(out_dir, "tab_cct_covariate_continuity_ko.tex"))

# Summary
sig5 <- sum(!is.na(results$p_value) & results$p_value < 0.05)
sig10 <- sum(!is.na(results$p_value) & results$p_value < 0.10)
message(sprintf("04c_cct_covariate_continuity.R: %d cells fit in %.1fs.",
                nrow(results), elapsed))
message(sprintf("  Significant at p<.05: %d / %d cells", sig5, nrow(results)))
message(sprintf("  Significant at p<.10: %d / %d cells", sig10, nrow(results)))
message(sprintf("  Output: cct_covariate_results.rds + tab_cct_covariate_continuity_{en,ko}.tex"))

# STOP CONDITION 1: if any p<.05 → escalate (paper §7 needs covariate-conditional reframe)
if (sig5 > 0L) {
  message("  WARNING: STOP CONDITION 1 — covariate imbalance at cutoff. Review needed.")
  print(results |> dplyr::filter(p_value < 0.05))
}
