# =============================================================================
# 02_descriptive.R — Table 1 + Balance + First-Stage Take-up (Step 4 P2).
#
# Inputs:
#   scripts/R/_outputs/clean.rds (from 01_clean.R — 14,474 × 50 panel)
#
# Outputs (under scripts/R/_outputs/):
#   tab_descriptives_en.tex   — Weighted Table 1 by treatment (English)
#   tab_descriptives_ko.tex   — Korean mirror
#   tab_balance.tex           — Near-cutoff covariate balance (|rv_2018| <= 1000)
#   tab_first_stage.tex       — ITT first-stage take-up (#84 actual_subsidy)
#   desc_summary.rds          — list(table1, balance, first_stage, take_up_rate)
#
# Spec contracts:
#   - r-code-conventions.md §6 — Solon-Haider-Wooldridge weighted Table 1 (mandatory)
#   - r-code-conventions.md §11 — cluster = hh_id
#   - r-code-conventions.md §13 — tab_<topic>_{en,ko}.tex output convention
#   - MEMORY [LEARN:methods] 2026-05-07 — actual_subsidy (#84) first-stage mandatory
#
# Plan: quality_reports/plans/2026-05-14_p2-descriptive-did-rd.md
# =============================================================================

suppressPackageStartupMessages({
  library(haven)         # for zap_labels when needed
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(survey)        # svydesign — Solon-Haider-Wooldridge §6
  library(fixest)        # feols
  library(modelsummary)  # msummary, datasummary
  library(knitr)         # kable for Table 1 LaTeX assembly
  library(purrr)         # map_dfr for per-variable Table 1 assembly
  library(readr)
  library(fs)
  library(here)
})

# Inherit seed from 00_run_all.R or set locally for direct invocation.
if (exists("PROJECT_SEED", inherits = FALSE)) {
  set.seed(PROJECT_SEED)
} else {
  set.seed(20260504L)
}

# ---------------------------------------------------------------------------- #
# Phase 0 — Load + guard
# ---------------------------------------------------------------------------- #

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) {
  OUT_DIR
} else {
  here::here("scripts", "R", "_outputs")
}
clean_path <- file.path(out_dir, "clean.rds")
stopifnot(fs::file_exists(clean_path))

df <- readRDS(clean_path)
stopifnot(nrow(df) == 14474L, dplyr::n_distinct(df$hh_id) == 3614L)

# `haven` keeps labelled vectors; coerce to plain numeric so modelsummary /
# survey don't trip on labelled() class while still preserving Korean labels
# we may want for table headers.
ko_labels <- list(
  op_cost          = attr(df$op_cost,          "label"),
  off_farm_income  = attr(df$off_farm_income,  "label"),
  consumption      = attr(df$consumption,      "label"),
  farm_income      = attr(df$farm_income,      "label"),
  area_2018        = attr(df$area_2018,        "label"),
  area_own         = attr(df$area_own,         "label"),
  imputed_payment  = attr(df$imputed_payment,  "label"),
  actual_subsidy   = attr(df$actual_subsidy,   "label")
)

# Strip haven labels for compute-side; modelsummary handles them inconsistently.
df_num <- df |> dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

# ---------------------------------------------------------------------------- #
# Phase 1 — Table 1: weighted descriptives at baseline (year == 2018)
# ---------------------------------------------------------------------------- #
# Solon-Haider-Wooldridge 2015 §6: descriptives MUST be weighted for population
# representativeness. Use FHES national weight via survey::svydesign().

df18 <- df_num |> dplyr::filter(year == 2018L)
# Panel is unbalanced: 2,823 farms observed in 2018 (out of 3,614 ever in panel).
# Late entrants (joined 2019+) are NOT in baseline Table 1 by design — Table 1
# reports pre-policy 2018 cross-section, period.
stopifnot(nrow(df18) == 2823L,
          dplyr::n_distinct(df18$hh_id) == 2823L)

svy18 <- survey::svydesign(
  ids     = ~hh_id,
  weights = ~weight_national,
  data    = df18
)

# Variables for Table 1.
t1_vars_continuous <- c("op_cost", "off_farm_income", "consumption", "farm_income",
                        "area_2018", "area_own", "imputed_payment")
t1_vars_factor     <- c("type_fulltime", "sex_code", "edu_code")   # categorical proxies

# Compute weighted means + SDs per D_treat group + difference test.
t1_continuous <- purrr::map_dfr(t1_vars_continuous, function(v) {
  f_mean <- as.formula(paste0("~", v))
  by     <- as.formula("~D_treat")
  m_by   <- survey::svyby(f_mean, by, svy18, survey::svymean, na.rm = TRUE)
  # m_by columns when single variable: D_treat, <v>, se
  m0 <- m_by[m_by$D_treat == 0, v]
  m1 <- m_by[m_by$D_treat == 1, v]
  se0 <- m_by[m_by$D_treat == 0, "se"]
  se1 <- m_by[m_by$D_treat == 1, "se"]
  v0  <- as.numeric(survey::svyvar(f_mean, subset(svy18, D_treat == 0), na.rm = TRUE)[1])
  v1  <- as.numeric(survey::svyvar(f_mean, subset(svy18, D_treat == 1), na.rm = TRUE)[1])
  ttest <- survey::svyttest(as.formula(paste0(v, " ~ D_treat")), svy18)
  tibble::tibble(
    variable  = v,
    label_ko  = ko_labels[[v]] %||% v,
    mean_ctrl = m0, sd_ctrl = sqrt(v0),
    mean_trt  = m1, sd_trt  = sqrt(v1),
    diff      = m1 - m0,
    se_diff   = sqrt(se0^2 + se1^2),
    p_value   = ttest$p.value
  )
})

# Counts: unweighted N per group at baseline.
n_ctrl <- sum(df18$D_treat == 0L)
n_trt  <- sum(df18$D_treat == 1L)

# Factor-style frequencies for type_fulltime / sex_code / edu_code.
t1_factor <- purrr::map_dfr(t1_vars_factor, function(v) {
  tab <- df18 |>
    dplyr::group_by(D_treat) |>
    dplyr::summarise(
      mode_val = names(sort(table(.data[[v]]), decreasing = TRUE))[1],
      .groups  = "drop"
    )
  tibble::tibble(
    variable  = v,
    label_ko  = ko_labels[[v]] %||% v,
    mode_ctrl = tab$mode_val[tab$D_treat == 0L],
    mode_trt  = tab$mode_val[tab$D_treat == 1L]
  )
})

# Build LaTeX (Table 1).
write_table1_tex <- function(continuous, factor_modes, n_ctrl, n_trt, lang, path) {
  fmt_num <- function(x) ifelse(is.na(x), "",
                         formatC(x, format = "fg", digits = 4, big.mark = ","))
  fmt_p   <- function(p) ifelse(is.na(p), "",
                         ifelse(p < 0.001, "<0.001", formatC(p, format = "f", digits = 3)))

  hdr_var   <- if (lang == "en") "Variable"   else "변수"
  hdr_ctrl  <- if (lang == "en") "Control (D=0)" else "통제 (D=0)"
  hdr_trt   <- if (lang == "en") "Treated (D=1)" else "처치 (D=1)"
  hdr_diff  <- if (lang == "en") "Diff (T-C)"   else "차이 (T-C)"
  hdr_p     <- if (lang == "en") "p-value"      else "p-값"
  hdr_n     <- if (lang == "en") "N (baseline)" else "관측치 (기준연도)"
  note      <- if (lang == "en")
    "Note: Weighted means (SD in parentheses) using FHES national weight. p-values from survey-weighted t-test. Baseline = 2018 cross-section."
  else
    "주: FHES 전국 가중값 적용. 가중 평균 (괄호 안 표준편차). p-값은 가중 t-검정. 기준연도 = 2018 단면."

  rows <- character()
  for (i in seq_len(nrow(continuous))) {
    r <- continuous[i, ]
    label <- if (lang == "en") r$variable else r$label_ko
    rows <- c(rows, sprintf(
      "%s & %s (%s) & %s (%s) & %s & %s \\\\",
      label,
      fmt_num(r$mean_ctrl), fmt_num(r$sd_ctrl),
      fmt_num(r$mean_trt),  fmt_num(r$sd_trt),
      fmt_num(r$diff),
      fmt_p(r$p_value)
    ))
  }
  for (i in seq_len(nrow(factor_modes))) {
    r <- factor_modes[i, ]
    label <- if (lang == "en") r$variable else r$label_ko
    rows <- c(rows, sprintf(
      "%s (mode) & %s & %s & --- & --- \\\\",
      label, as.character(r$mode_ctrl), as.character(r$mode_trt)
    ))
  }
  rows <- c(rows, sprintf("%s & %s & %s & --- & --- \\\\",
                          hdr_n, formatC(n_ctrl, big.mark = ","),
                          formatC(n_trt, big.mark = ",")))

  body <- paste(rows, collapse = "\n")
  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{tab:descriptives_%s}\n\\begin{tabular}{lrrrr}\n\\toprule\n%s & %s & %s & %s & %s \\\\\n\\midrule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    if (lang == "en") "Descriptive Statistics by Treatment Status" else "처치 상태별 기술통계",
    lang,
    hdr_var, hdr_ctrl, hdr_trt, hdr_diff, hdr_p,
    body,
    note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
  invisible(path)
}

write_table1_tex(t1_continuous, t1_factor, n_ctrl, n_trt, "en",
                 file.path(out_dir, "tab_descriptives_en.tex"))
write_table1_tex(t1_continuous, t1_factor, n_ctrl, n_trt, "ko",
                 file.path(out_dir, "tab_descriptives_ko.tex"))

# ---------------------------------------------------------------------------- #
# Phase 2 — Balance table near cutoff (|rv_2018| <= 1000), unweighted
# ---------------------------------------------------------------------------- #
# RD validity: at the cutoff, treated and control should differ only in D_treat
# (the running variable is the only systematic discontinuity).

df_balance <- df18 |> dplyr::filter(abs(rv_2018) <= 1000)
stopifnot(nrow(df_balance) > 0)

# Drop `imputed_payment` — constant 0 in 2018 by construction (PIDPS effective 2020).
balance_vars <- setdiff(c(t1_vars_continuous, t1_vars_factor), "imputed_payment")
balance_fits <- lapply(balance_vars, function(v) {
  fixest::feols(as.formula(paste0(v, " ~ D_treat")),
                data = df_balance, cluster = ~hh_id, warn = FALSE,
                notes = FALSE)
})
names(balance_fits) <- balance_vars

# Write a compact balance .tex via modelsummary.
modelsummary::msummary(
  balance_fits,
  output    = file.path(out_dir, "tab_balance.tex"),
  coef_omit = "Intercept",
  gof_map   = c("nobs", "r.squared"),
  stars     = c("*" = 0.10, "**" = 0.05, "***" = 0.01),
  title     = sprintf("Covariate Balance Near Cutoff (|rv_2018| <= 1000 m^2, N = %d at baseline)",
                      nrow(df_balance))
)

# ---------------------------------------------------------------------------- #
# Phase 3 — First-Stage Take-up ([LEARN:methods] 2026-05-07: #84 mandatory)
# ---------------------------------------------------------------------------- #
# (a) actual_subsidy on D_Post (ITT first stage with RD slope)
# (b) imputed_payment on D_Post (formula-derived comparison)
# (c) take-up rate among treated post-2020

fs_a <- fixest::feols(
  actual_subsidy ~ D_Post + rv_Post + Drv_Post | hh_id + year,
  data    = df_num,
  cluster = ~hh_id,
  warn    = FALSE, notes = FALSE
)

fs_b <- fixest::feols(
  imputed_payment ~ D_Post + rv_Post + Drv_Post | hh_id + year,
  data    = df_num,
  cluster = ~hh_id,
  warn    = FALSE, notes = FALSE
)

take_up_rate <- df_num |>
  dplyr::filter(D_treat == 1L, year >= 2020L) |>
  dplyr::summarise(
    n_obs        = dplyr::n(),
    n_received   = sum(actual_subsidy > 0, na.rm = TRUE),
    rate         = mean(actual_subsidy > 0, na.rm = TRUE),
    mean_amount  = mean(actual_subsidy[actual_subsidy > 0], na.rm = TRUE),
    median_amount = stats::median(actual_subsidy[actual_subsidy > 0], na.rm = TRUE)
  )

modelsummary::msummary(
  list(`actual_subsidy (received)` = fs_a,
       `imputed_payment (formula)` = fs_b),
  output    = file.path(out_dir, "tab_first_stage.tex"),
  coef_map  = c("D_Post" = "D × Post", "rv_Post" = "rv × Post", "Drv_Post" = "D × rv × Post"),
  gof_map   = c("nobs", "r.squared"),
  stars     = c("*" = 0.10, "**" = 0.05, "***" = 0.01),
  title     = "First-Stage Take-up: actual_subsidy (FHES #84) vs imputed_payment (formula)",
  notes     = sprintf("Take-up rate among treated post-2020: %.3f (%d of %d). Median received amount when > 0: %s KRW.",
                      take_up_rate$rate, take_up_rate$n_received, take_up_rate$n_obs,
                      formatC(take_up_rate$median_amount, format = "fg", big.mark = ","))
)

# ---------------------------------------------------------------------------- #
# Phase 4 — Save RDS + done
# ---------------------------------------------------------------------------- #

saveRDS(
  list(
    table1       = list(continuous = t1_continuous, factor = t1_factor,
                        n_ctrl = n_ctrl, n_trt = n_trt),
    balance      = list(fits = balance_fits, n_balance = nrow(df_balance)),
    first_stage  = list(fit_actual = fs_a, fit_imputed = fs_b,
                        take_up_rate = take_up_rate),
    spec_notes   = paste0("Table 1 weighted via survey::svydesign (Solon-Haider-Wooldridge §6); ",
                          "balance unweighted near cutoff; first-stage on actual_subsidy ",
                          "([LEARN:methods] 2026-05-07 #84 mandatory).")
  ),
  file.path(out_dir, "desc_summary.rds")
)

message(sprintf("02_descriptive.R: Table 1 (N=%d), Balance (N=%d near cutoff), First-stage take-up = %.1f%%",
                nrow(df18), nrow(df_balance), 100 * take_up_rate$rate))
