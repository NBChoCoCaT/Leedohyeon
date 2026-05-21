# =============================================================================
# 13b_placebo_cutoffs.R — Placebo cutoff DiD-RD (Wave 7 polish, P7)
#
# Standard RDD robustness: re-estimate the DiD-RD at fake non-policy cutoffs
# and verify no significant "effect" appears. Failure (significant β at fake
# cutoff) would suggest a spurious-cutoff issue at the true 0.5 ha threshold.
#
# Fake cutoffs: 0.3, 0.4, 0.6, 0.7 ha (= 3000, 4000, 6000, 7000 m²).
# Bandwidth: T1 (±500 m²) and T2 (±1,000 m²) per fake cutoff.
# Outcomes: 4 primary (op_cost, off_farm_income, consumption, farm_income).
# Spec: A (2018-2022, Post=year≥2020) only.
#
# Output:
#   $OUT_DIR/placebo_cutoffs.rds
#   $OUT_DIR/tab_placebo_cutoffs_en.tex
#   $OUT_DIR/tab_placebo_cutoffs_ko.tex
#
# Plan: quality_reports/plans/velvet-frolicking-glade.md (Phase A7 KO emission)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(fixest)
  library(haven); library(fs); library(here)
})
set.seed(20260504L)

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
  here::here("scripts", "R", "_outputs_eligibility")
df <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

outcomes <- c("op_cost", "off_farm_income", "consumption", "farm_income")

# Fake cutoffs (m²)
fake_cutoffs <- c(3000, 4000, 6000, 7000)
bandwidths <- c(T1 = 500, T2 = 1000)

# Build placebo DiD-RD fits
fit_placebo <- function(df, cutoff, h, outcome) {
  sub <- df |>
    dplyr::mutate(
      rv_fake   = area_2018 - cutoff,
      D_fake    = as.integer(rv_fake <= 0),
      DPost_fake    = D_fake * Post,
      rvPost_fake   = rv_fake * Post,
      DrvPost_fake  = D_fake * rv_fake * Post
    ) |>
    dplyr::filter(abs(rv_fake) <= h)
  if (nrow(sub) < 20L || dplyr::n_distinct(sub$D_fake) < 2L)
    return(list(estimate = NA_real_, se = NA_real_, p = NA_real_, n_obs = nrow(sub)))
  f <- as.formula(sprintf(
    "%s ~ DPost_fake + rvPost_fake + DrvPost_fake | hh_id + year", outcome))
  fit <- tryCatch(
    fixest::feols(f, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit)) return(list(estimate = NA_real_, se = NA_real_, p = NA_real_, n_obs = nrow(sub)))
  est <- as.numeric(stats::coef(fit)["DPost_fake"])
  se  <- as.numeric(sqrt(diag(stats::vcov(fit))["DPost_fake"]))
  p   <- 2 * (1 - stats::pt(abs(est / se), df = dplyr::n_distinct(sub$hh_id) - 1L))
  list(estimate = est, se = se, p = p, n_obs = nrow(sub))
}

# Grid: 4 cutoffs × 2 bandwidths × 4 outcomes = 32 cells
grid <- tidyr::expand_grid(
  cutoff = fake_cutoffs,
  bw_id = names(bandwidths),
  outcome = outcomes
) |>
  dplyr::mutate(h = unname(bandwidths[bw_id]))

results <- grid |>
  dplyr::rowwise() |>
  dplyr::mutate(
    fit = list(fit_placebo(df, cutoff, h, outcome)),
    estimate = fit$estimate,
    se = fit$se,
    p_value = fit$p,
    n_obs = fit$n_obs
  ) |>
  dplyr::ungroup() |>
  dplyr::select(-fit)

# Compare to TRUE cutoff (5000) at same bandwidths
true_results <- tibble::tibble(
  cutoff = rep(5000L, length(bandwidths) * length(outcomes)),
  bw_id  = rep(names(bandwidths), each = length(outcomes)),
  h      = rep(unname(bandwidths), each = length(outcomes)),
  outcome = rep(outcomes, times = length(bandwidths))
) |>
  dplyr::rowwise() |>
  dplyr::mutate(
    fit = list(fit_placebo(df, cutoff, h, outcome)),
    estimate = fit$estimate,
    se = fit$se,
    p_value = fit$p,
    n_obs = fit$n_obs
  ) |>
  dplyr::ungroup() |>
  dplyr::select(-fit)

all_results <- dplyr::bind_rows(
  results |> dplyr::mutate(type = "placebo"),
  true_results |> dplyr::mutate(type = "true")
)
saveRDS(all_results, file.path(out_dir, "placebo_cutoffs.rds"))

# Generate LaTeX table
fmt_e <- function(x) ifelse(is.na(x), "—", formatC(x, format = "f", digits = 0, big.mark = ","))
star_p <- function(p) ifelse(is.na(p), "", ifelse(p < 0.01, "***",
                                                  ifelse(p < 0.05, "**",
                                                         ifelse(p < 0.10, "*", ""))))

# Per-outcome table at T2 (h=1000) for clean presentation
t2_table <- all_results |>
  dplyr::filter(bw_id == "T2") |>
  dplyr::select(cutoff, outcome, estimate, se, p_value) |>
  dplyr::mutate(
    cell = sprintf("%s%s (%s)", fmt_e(estimate), star_p(p_value), fmt_e(se))
  ) |>
  dplyr::select(cutoff, outcome, cell) |>
  tidyr::pivot_wider(names_from = outcome, values_from = cell) |>
  dplyr::arrange(cutoff) |>
  dplyr::mutate(
    cutoff_lbl = sprintf("%.1f~ha (%s m\\textsuperscript{2})%s",
                         cutoff / 10000,
                         fmt_e(cutoff),
                         ifelse(cutoff == 5000, " \\textbf{[true]}", ""))
  ) |>
  dplyr::select(cutoff_lbl, op_cost, off_farm_income, consumption, farm_income)

rows <- character()
for (i in seq_len(nrow(t2_table))) {
  r <- t2_table[i, ]
  rows <- c(rows, sprintf("%s & %s & %s & %s & %s \\\\",
                          r$cutoff_lbl, r$op_cost, r$off_farm_income,
                          r$consumption, r$farm_income))
}
# Replace the EN "[true]" marker with Korean for the KO table.
rows_ko <- gsub("\\textbf{[true]}", "\\textbf{[실제]}", rows, fixed = TRUE)

write_placebo_table <- function(lang, path, body) {
  if (lang == "en") {
    caption <- "Placebo cutoffs: DiD-RD at non-policy thresholds (Spec A, T2 bandwidth $h=1{,}000$~m\\textsuperscript{2})"
    label   <- "tab:placebo-cutoffs"
    header  <- "Cutoff & op\\_cost & off\\_farm\\_income & consumption & farm\\_income \\\\"
    notes   <- paste0("\\footnotesize\\textit{Coefficient on $D_{\\text{fake}} \\times \\text{Post}$ ",
                      "(KRW for income/cost; m\\textsuperscript{2} for area). ",
                      "Cluster-robust SE (hh\\_id) in parentheses; * p<.10, ** p<.05, *** p<.01. ",
                      "Placebo cutoffs (0.3/0.4/0.6/0.7 ha) test whether the DiD-RD detects ",
                      "spurious effects at non-policy thresholds; the 0.5 ha row is the true ",
                      "SFFP cutoff for comparison.}")
  } else {
    caption <- "위약(placebo) 컷오프: 비정책 임계값에서의 DiD-RD (Spec A, T2 대역폭 $h=1{,}000$~m\\textsuperscript{2})"
    label   <- "tab:placebo-cutoffs-ko"
    header  <- "컷오프 & op\\_cost & off\\_farm\\_income & consumption & farm\\_income \\\\"
    notes   <- paste0("\\footnotesize\\textit{주: $D_{\\text{fake}} \\times \\text{Post}$ 계수 ",
                      "(소득/비용은 원, 면적은 m\\textsuperscript{2}). 괄호 안 클러스터-강건 SE ",
                      "(hh\\_id); * p<.10, ** p<.05, *** p<.01. 위약 컷오프 ",
                      "(0.3/0.4/0.6/0.7 ha)는 비정책 임계값에서 DiD-RD가 허위 효과를 탐지하는지 ",
                      "검증; 0.5 ha 행은 비교용 실제 소농직불금 컷오프.}")
  }
  tex <- paste0(
    "\\begin{table}[ht]\n\\centering\n",
    sprintf("\\caption{%s}\n", caption),
    sprintf("\\label{%s}\n\\small\n", label),
    "\\begin{tabular}{lrrrr}\n\\toprule\n",
    header, "\n\\midrule\n",
    paste(body, collapse = "\n"),
    "\n\\bottomrule\n\\end{tabular}\n\\\\\n",
    notes, "\n\\end{table}\n"
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_placebo_table("en", file.path(out_dir, "tab_placebo_cutoffs_en.tex"), rows)
write_placebo_table("ko", file.path(out_dir, "tab_placebo_cutoffs_ko.tex"), rows_ko)

# Summary log
log_lines <- c(
  paste0("=== 13b_placebo_cutoffs.R — ", as.character(Sys.time()), " ==="),
  "",
  sprintf("Placebo cutoffs tested: %s m^2 (= 0.3/0.4/0.6/0.7 ha)",
          paste(fake_cutoffs, collapse = ", ")),
  sprintf("True cutoff: 5000 m^2 (= 0.5 ha)"),
  sprintf("Bandwidths: T1 (h=500), T2 (h=1000); Spec A only"),
  "",
  "Significant placebo coefficients (p<.10) flagged below:",
  ""
)
sig_rows <- results |> dplyr::filter(!is.na(p_value) & p_value < 0.10)
if (nrow(sig_rows) == 0) {
  log_lines <- c(log_lines, "  NONE — all placebo cells p >= .10. PASS.")
} else {
  for (i in seq_len(nrow(sig_rows))) {
    r <- sig_rows[i, ]
    log_lines <- c(log_lines, sprintf(
      "  cutoff=%d (%.1f ha), %s, %s: est=%s (SE %s), p=%.3f, n=%d",
      r$cutoff, r$cutoff/10000, r$bw_id, r$outcome,
      fmt_e(r$estimate), fmt_e(r$se), r$p_value, r$n_obs))
  }
}
writeLines(log_lines, file.path(out_dir, "placebo_cutoffs.txt"))

message(sprintf(
  "13b_placebo_cutoffs.R: 32 placebo cells + 8 true-cutoff cells fit. Placebo significant: %d/32 at p<.10, %d at p<.05.",
  sum(results$p_value < 0.10, na.rm = TRUE),
  sum(results$p_value < 0.05, na.rm = TRUE)
))
