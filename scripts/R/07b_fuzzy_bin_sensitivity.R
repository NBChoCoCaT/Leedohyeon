# =============================================================================
# 07b_fuzzy_bin_sensitivity.R — Measurement-error sensitivity on s0 bin boundaries
#
# Phase 2 Step 3 (L3 MAJ-3). FHES area is self-reported; bin boundaries at
# s_0 = 0.33 and 0.67 are exactly where the F1 monotone gradient is read off.
# This script reports the F1 monotone-gradient claim under three alternative
# bin treatments to bound the measurement-error sensitivity:
#
#   1. STRICT (baseline; matches 07_heterogeneity.R):
#      {0, (0, 0.3], (0.3, 0.7], (0.7, 1), 1}
#   2. DONUT: drop households with s0 in [0.27, 0.33] ∪ [0.67, 0.73] —
#      the "uncertainty zones" around the bin boundaries
#   3. ROBUST BIN: shift cutpoints to s0 = 0.25 / 0.75 (more conservative bins)
#
# The fully nonparametric continuous-s0 specification is reported separately
# as a visual (fig_continuous_s0_gradient_T2_en) for the AJAE robustness §7.
#
# Inputs:
#   _outputs_symmetric/clean.rds
#
# Outputs:
#   _outputs_symmetric/fuzzy_bin_results.rds
#   _outputs_symmetric/tab_fuzzy_bin_sensitivity_en.tex
#   _outputs_symmetric/tab_fuzzy_bin_sensitivity_ko.tex
#
# Plan: quality_reports/plans/graceful-percolating-dragonfly.md (Step 3)
#       quality_reports/plans/velvet-frolicking-glade.md (Phase A3 KO emission)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(fixest)
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

# Build s0 from 2018 baseline (matches 07_heterogeneity.R + 08_p3c_decomposition.R)
df <- df |>
  dplyr::group_by(hh_id) |>
  dplyr::mutate(s0 = mean(own_share[year == 2018L], na.rm = TRUE)) |>
  dplyr::ungroup()

bin_strict <- function(s0) {
  dplyr::case_when(
    is.nan(s0) | is.na(s0) ~ NA_character_,
    s0 == 0             ~ "1_pure_tenant",
    s0 <  0.3           ~ "2_low_owner",
    s0 <  0.7           ~ "3_mixed",
    s0 <  1             ~ "4_high_owner",
    s0 == 1             ~ "5_pure_owner"
  )
}

bin_robust25 <- function(s0) {
  dplyr::case_when(
    is.nan(s0) | is.na(s0) ~ NA_character_,
    s0 == 0             ~ "1_pure_tenant",
    s0 <  0.25          ~ "2_low_owner",
    s0 <  0.75          ~ "3_mixed",
    s0 <  1             ~ "4_high_owner",
    s0 == 1             ~ "5_pure_owner"
  )
}

donut_drop <- function(s0) {
  # TRUE = drop (in uncertainty zone)
  (s0 > 0.27 & s0 < 0.33) | (s0 > 0.67 & s0 < 0.73)
}

# Run F1 four-bin gradient on T2 (h=1000) per spec
fit_f1 <- function(df_use, bin_fn, label, bw = 1000) {
  sub <- df_use |>
    dplyr::filter(abs(rv_2018) <= bw) |>
    dplyr::mutate(own_bin = factor(bin_fn(s0),
                                   levels = c("5_pure_owner", "1_pure_tenant",
                                              "2_low_owner", "3_mixed",
                                              "4_high_owner"))) |>
    dplyr::filter(!is.na(own_bin))

  if (nrow(sub) < 50L) return(NULL)

  f <- area_own ~ i(own_bin, D_Post, ref = "5_pure_owner") + rv_Post + Drv_Post | hh_id + year
  fit <- tryCatch(
    fixest::feols(f, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit)) return(NULL)
  cf <- stats::coef(fit)
  se <- sqrt(diag(stats::vcov(fit)))
  bins <- c("1_pure_tenant", "2_low_owner", "3_mixed", "4_high_owner")
  out <- purrr::map_dfr(bins, function(b) {
    nm <- paste0("own_bin::", b, ":D_Post")
    if (!nm %in% names(cf)) return(tibble::tibble(spec = label, bin = b,
                                                  est = NA, se = NA, p = NA, n_obs = nrow(sub)))
    est <- as.numeric(cf[nm])
    s   <- as.numeric(se[nm])
    pv  <- 2 * (1 - stats::pt(abs(est / s),
                              df = dplyr::n_distinct(sub$hh_id) - 1L))
    tibble::tibble(spec = label, bin = b, est = est, se = s, p = pv, n_obs = nrow(sub))
  })
  out
}

# Spec 1 — Strict (baseline)
r_strict <- fit_f1(df, bin_strict, "Strict (baseline)")

# Spec 2 — Donut (drop uncertainty zones)
df_donut <- df |> dplyr::filter(!donut_drop(s0))
r_donut <- fit_f1(df_donut, bin_strict, "Donut [.27,.33]∪[.67,.73]")

# Spec 3 — Robust 25/75 cutpoints
r_rob25 <- fit_f1(df, bin_robust25, "Robust 25/75 bins")

results <- dplyr::bind_rows(r_strict, r_donut, r_rob25)

# Sanity check headline
strict_tenant_p <- (r_strict |> dplyr::filter(bin == "1_pure_tenant") |> dplyr::pull(p))[1]
strict_tenant_e <- (r_strict |> dplyr::filter(bin == "1_pure_tenant") |> dplyr::pull(est))[1]
message(sprintf("F1 sensitivity (T2, area_own):"))
message(sprintf("  Strict baseline: pure_tenant β = %s, p = %s",
                round(strict_tenant_e, 1), round(strict_tenant_p, 4)))

donut_tenant_e <- (r_donut |> dplyr::filter(bin == "1_pure_tenant") |> dplyr::pull(est))[1]
donut_tenant_p <- (r_donut |> dplyr::filter(bin == "1_pure_tenant") |> dplyr::pull(p))[1]
message(sprintf("  Donut:           pure_tenant β = %s, p = %s",
                round(donut_tenant_e, 1), round(donut_tenant_p, 4)))

rob_tenant_e <- (r_rob25 |> dplyr::filter(bin == "1_pure_tenant") |> dplyr::pull(est))[1]
rob_tenant_p <- (r_rob25 |> dplyr::filter(bin == "1_pure_tenant") |> dplyr::pull(p))[1]
message(sprintf("  Robust 25/75:    pure_tenant β = %s, p = %s",
                round(rob_tenant_e, 1), round(rob_tenant_p, 4)))

# Save
saveRDS(
  list(
    results = results,
    notes = paste(
      "F1 monotone-gradient sensitivity to s_0 bin-boundary measurement error.",
      "Three alternative bin treatments compared at T2 (h=1000):",
      "(1) Strict baseline {0,.3,.7,1} cutpoints (matches 07_heterogeneity.R)",
      "(2) Donut: drop hh with s_0 in [.27,.33] or [.67,.73] uncertainty zones",
      "(3) Robust 25/75 bins: cutpoints at .25 / .75 instead of .3 / .7.",
      "Reference category: pure_owner (s_0 = 1)."
    )
  ),
  file.path(out_dir, "fuzzy_bin_results.rds")
)

# LaTeX
fmt_num <- function(x, digits = 0) {
  ifelse(is.na(x), "", formatC(x, format = "f", big.mark = ",", digits = digits))
}
star <- function(p) {
  ifelse(is.na(p), "",
         ifelse(p < 0.01, "***",
                ifelse(p < 0.05, "**",
                       ifelse(p < 0.10, "*", ""))))
}

# Bilingual spec / column labels
spec_label_ko <- c(
  "Strict (baseline)"           = "엄격 (기준안)",
  "Donut [.27,.33]∪[.67,.73]"   = "도넛 [.27,.33]∪[.67,.73]",
  "Robust 25/75 bins"           = "강건 25/75 bin"
)
bin_cols_en <- c("Pure tenant", "Low owner", "Mixed", "High owner")
bin_cols_ko <- c("순임차", "저소유", "혼합", "고소유")

write_fuzzy_table <- function(lang, path) {
  tex_rows <- character()
  for (sp in c("Strict (baseline)", "Donut [.27,.33]∪[.67,.73]", "Robust 25/75 bins")) {
    sub_s <- results |> dplyr::filter(spec == sp)
    sp_disp <- if (lang == "ko") spec_label_ko[[sp]] else sp
    tex_rows <- c(tex_rows,
                  sprintf("\\multicolumn{5}{l}{\\textit{%s} ($N = %s$)} \\\\",
                          gsub("∪", "$\\cup$", sp_disp, fixed = TRUE),
                          formatC(sub_s$n_obs[1], format = "d", big.mark = ",")))
    vals <- character(4)
    pvals <- character(4)
    for (i in seq_along(c("1_pure_tenant","2_low_owner","3_mixed","4_high_owner"))) {
      b <- c("1_pure_tenant","2_low_owner","3_mixed","4_high_owner")[i]
      r <- sub_s |> dplyr::filter(bin == b)
      if (nrow(r) == 0L || is.na(r$est[1])) {
        vals[i] <- ""; pvals[i] <- ""
      } else {
        vals[i]  <- paste0(fmt_num(r$est[1], 0), star(r$p[1]))
        pvals[i] <- paste0("(", fmt_num(r$se[1], 0), ")")
      }
    }
    coef_label <- if (lang == "ko") "계수" else "Coef"
    tex_rows <- c(tex_rows,
                  sprintf("%s & %s & %s & %s & %s \\\\",
                          coef_label, vals[1], vals[2], vals[3], vals[4]))
    tex_rows <- c(tex_rows,
                  sprintf("SE & %s & %s & %s & %s \\\\",
                          pvals[1], pvals[2], pvals[3], pvals[4]))
  }

  if (lang == "en") {
    caption <- paste0("F1 monotone-gradient sensitivity to $s_0$ bin-boundary ",
                      "measurement error. Three alternative bin treatments at T2 ",
                      "($h = 1{,}000$); reference category pure\\_owner ($s_0 = 1$, ",
                      "coefficient $\\equiv 0$).")
    label   <- "tab:fuzzy_bin_sensitivity_en"
    header  <- sprintf("Spec & %s & %s & %s & %s \\\\",
                       bin_cols_en[1], bin_cols_en[2], bin_cols_en[3], bin_cols_en[4])
    notes   <- paste0("\\footnotesize\\textit{Coefficients on \\texttt{own\\_bin}$\\times$",
                      "\\texttt{D\\_treat} interactions in the symmetric-screened panel, ",
                      "T2 bandwidth. SE in parentheses, cluster-robust at \\texttt{hh\\_id}. ",
                      "Donut drops 2018 households whose $s_0$ falls in the bin-boundary ",
                      "uncertainty zones $[.27, .33]$ or $[.67, .73]$ ",
                      "(\\citealp{Roth2022_pretrends} measurement-error logic). ",
                      "Robust 25/75 bins shift cutpoints to $0.25$ and $0.75$. ",
                      "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.}")
  } else {
    caption <- paste0("$s_0$ bin 경계 측정오차에 대한 F1 단조구배 민감도. ",
                      "T2 ($h = 1{,}000$)에서 3개 대안 bin 처리; ",
                      "기준 범주 pure\\_owner ($s_0 = 1$, 계수 $\\equiv 0$).")
    label   <- "tab:fuzzy_bin_sensitivity_ko"
    header  <- sprintf("Spec & %s & %s & %s & %s \\\\",
                       bin_cols_ko[1], bin_cols_ko[2], bin_cols_ko[3], bin_cols_ko[4])
    notes   <- paste0("\\footnotesize\\textit{주: 대칭 스크리닝 패널에서 ",
                      "\\texttt{own\\_bin}$\\times$\\texttt{D\\_treat} 상호작용 계수, ",
                      "T2 bandwidth. 괄호 안 클러스터 강건 SE (\\texttt{hh\\_id}). ",
                      "도넛은 $s_0$가 bin 경계 불확실성 구간 $[.27, .33]$ 또는 ",
                      "$[.67, .73]$에 속하는 2018년 가구를 제외 ",
                      "(\\citealp{Roth2022_pretrends} 측정오차 논리). ",
                      "강건 25/75 bin은 cutpoint를 $0.25$, $0.75$로 이동. ",
                      "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.}")
  }

  tex <- c(
    "\\begin{table}[t]",
    "\\centering",
    sprintf("\\caption{%s}", caption),
    sprintf("\\label{%s}", label),
    "\\begin{tabular}{lrrrr}",
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

write_fuzzy_table("en", file.path(out_dir, "tab_fuzzy_bin_sensitivity_en.tex"))
write_fuzzy_table("ko", file.path(out_dir, "tab_fuzzy_bin_sensitivity_ko.tex"))

message(sprintf("07b_fuzzy_bin_sensitivity.R: 3 specs × 4 bins = 12 cells fit."))
message(sprintf("  Output: fuzzy_bin_results.rds + tab_fuzzy_bin_sensitivity_{en,ko}.tex"))

# STOP CONDITION 3: F1 sign on pure_tenant should be preserved (positive) across all 3 specs
signs <- c(strict_tenant_e > 0, donut_tenant_e > 0, rob_tenant_e > 0)
if (!all(signs, na.rm = TRUE)) {
  message("  WARNING: STOP CONDITION 3 — F1 pure_tenant sign NOT preserved across all 3 sensitivity specs.")
}
