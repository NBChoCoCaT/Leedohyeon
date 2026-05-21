# =============================================================================
# 14b_dropped_hh_balance.R — Balance table for 194 treated-but-ineligible
# households (Wave 7 polish r2, M3-B).
#
# Compares the 194 dropped households (D_treat=1 area-only & D_eligible=0)
# against the 1,131 statutorily-eligible (D_eligible=1) on key pre-period
# covariates. Defends the subset construction against selection-bias critique.
#
# Output:
#   $OUT_DIR/dropped_balance.rds
#   $OUT_DIR/tab_dropped_balance_en.tex
#   $OUT_DIR/tab_dropped_balance_ko.tex
#
# Plan: quality_reports/plans/velvet-frolicking-glade.md (Phase A6 KO emission)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(haven)
  library(fs); library(here)
})
set.seed(20260504L)

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
  here::here("scripts", "R", "_outputs_eligibility")
df_full <- readRDS(here::here("scripts", "R", "_outputs", "clean_with_eligibility.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

# Restrict to treated-area cohort (area_2018 ≤ 5000) for fair comparison
treated_area <- df_full |> dplyr::filter(D_treat == 1L)

# Group: eligible (1,131 hh) vs dropped (194 hh) by D_eligible_obs_2018
treated_area <- treated_area |>
  dplyr::mutate(group = ifelse(D_eligible_obs_2018, "eligible", "dropped"))

n_eligible <- treated_area |> dplyr::distinct(hh_id, group) |>
              dplyr::filter(group == "eligible") |> nrow()
n_dropped  <- treated_area |> dplyr::distinct(hh_id, group) |>
              dplyr::filter(group == "dropped")  |> nrow()
stopifnot(n_eligible == 1131L, n_dropped == 194L)

# Pre-period (2018-2019) covariate summary by group
pre_period <- treated_area |> dplyr::filter(year %in% 2018:2019)

vars <- c("area_2018", "area_owned_2018", "off_inc_2018",
          "op_cost", "off_farm_income", "consumption", "farm_income",
          "age_code_base", "own_share", "area_own", "area_rent")

balance <- pre_period |>
  dplyr::select(group, dplyr::all_of(vars)) |>
  dplyr::group_by(group) |>
  dplyr::summarise(dplyr::across(dplyr::everything(),
                                  list(mean = ~ mean(.x, na.rm = TRUE),
                                       sd   = ~ stats::sd(.x,   na.rm = TRUE),
                                       n    = ~ sum(!is.na(.x))),
                                  .names = "{.col}_{.fn}")) |>
  dplyr::ungroup()

# t-tests per variable
ttest_one <- function(varname) {
  x_e <- pre_period[[varname]][pre_period$group == "eligible"]
  x_d <- pre_period[[varname]][pre_period$group == "dropped"]
  x_e <- x_e[!is.na(x_e)]; x_d <- x_d[!is.na(x_d)]
  if (length(x_e) < 3L || length(x_d) < 3L) return(c(diff = NA, p_value = NA))
  tt <- tryCatch(t.test(x_e, x_d, var.equal = FALSE),
                 error = function(e) NULL)
  if (is.null(tt)) return(c(diff = NA, p_value = NA))
  c(diff = mean(x_e) - mean(x_d), p_value = tt$p.value)
}
ttests <- sapply(vars, ttest_one)
ttests_df <- tibble::tibble(
  variable = vars,
  diff_mean = ttests["diff", ],
  p_value = ttests["p_value", ]
)

saveRDS(list(balance = balance, ttests = ttests_df,
             n_eligible = n_eligible, n_dropped = n_dropped),
        file.path(out_dir, "dropped_balance.rds"))

# Generate LaTeX table
fmt <- function(x, d = 0) ifelse(is.na(x), "—",
                                  formatC(x, format = "f", digits = d, big.mark = ","))
fmt_p <- function(p) {
  ifelse(is.na(p), "—",
         ifelse(p < 0.001, "<0.001",
                ifelse(p < 0.01, sprintf("%.3f", p),
                       sprintf("%.3f", p))))
}

# Row construction — bilingual labels
var_labels_en <- c(
  area_2018       = "Cultivated area 2018 (m²)",
  area_owned_2018 = "Owned farmland 2018 (m²)",
  off_inc_2018    = "Household off-farm income 2018 (KRW)",
  op_cost         = "Operating cost (KRW)",
  off_farm_income = "Off-farm income (KRW)",
  consumption     = "Consumption (KRW)",
  farm_income     = "Farm income (KRW)",
  age_code_base   = "Head age (tier 1--6)",
  own_share       = "Own-share $s_0$",
  area_own        = "Own-cultivated area (m²)",
  area_rent       = "Rented-in area (m²)"
)
var_labels_ko <- c(
  area_2018       = "경지 면적 2018 (m²)",
  area_owned_2018 = "자작 농지 2018 (m²)",
  off_inc_2018    = "가구 농외소득 2018 (원)",
  op_cost         = "농업경영비 (원)",
  off_farm_income = "농외소득 (원)",
  consumption     = "가계소비지출 (원)",
  farm_income     = "농업소득 (원)",
  age_code_base   = "세대주 연령 (등급 1--6)",
  own_share       = "자작 비율 $s_0$",
  area_own        = "자작 면적 (m²)",
  area_rent       = "임차 면적 (m²)"
)
var_labels <- var_labels_en  # default for the long-pivot below

balance_long <- balance |>
  tidyr::pivot_longer(-group, names_to = c("variable", ".value"),
                      names_pattern = "(.*)_(mean|sd|n)") |>
  tidyr::pivot_wider(names_from = group, values_from = c(mean, sd, n)) |>
  dplyr::left_join(ttests_df, by = "variable") |>
  dplyr::mutate(variable_label = unname(var_labels[variable])) |>
  dplyr::filter(!is.na(variable_label))

build_rows <- function(labels) {
  rows <- character()
  for (i in seq_len(nrow(balance_long))) {
    r <- balance_long[i, ]
    digits <- if (r$variable %in% c("own_share")) 3 else 0
    var_disp <- unname(labels[r$variable])
    rows <- c(rows, sprintf(
      "%s & %s (%s) & %s (%s) & %s & %s \\\\",
      var_disp,
      fmt(r$mean_eligible, digits),
      fmt(r$sd_eligible,   digits),
      fmt(r$mean_dropped, digits),
      fmt(r$sd_dropped,   digits),
      fmt(r$diff_mean, digits),
      fmt_p(r$p_value)
    ))
  }
  rows
}

write_dropped_table <- function(lang, path) {
  if (lang == "en") {
    labels <- var_labels_en
    caption <- paste0("Balance: statutorily-eligible (1,131 hh, retained) vs.\\ ",
                      "treated-but-ineligible (194 hh, dropped), pre-period ",
                      "2018--2019 means (SD)")
    label   <- "tab:dropped-balance"
    hdr1    <- " & Eligible & Dropped & Diff. & Welch \\\\"
    hdr2    <- "Variable & ($n_{hh}=1{,}131$) & ($n_{hh}=194$) & (E$-$D) & $t$-test $p$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{Pre-period (2018--2019) means with SD in ",
                      "parentheses, computed on the area-treated cohort (area$_{2018}\\le 5{,}000$~m²) ",
                      "stratified by FHES-observable statutory eligibility (criteria ii and vi). ",
                      "Difference column reports Eligible $-$ Dropped means; ",
                      "Welch's two-sample $t$-test $p$-values reported in rightmost column.}")
  } else {
    labels <- var_labels_ko
    caption <- paste0("균형 검정: 법정 자격(1,131 농가, 유지) 대 ",
                      "처치-자격미달(194 농가, 제외), 사전기간 2018--2019 평균 (표준편차)")
    label   <- "tab:dropped-balance-ko"
    hdr1    <- " & 자격 & 제외 & 차이 & Welch \\\\"
    hdr2    <- "변수 & ($n_{hh}=1{,}131$) & ($n_{hh}=194$) & (자격$-$제외) & $t$-검정 $p$ \\\\"
    notes   <- paste0("\\footnotesize\\textit{주: 면적-처치 cohort ",
                      "(area$_{2018}\\le 5{,}000$~m²)에서 사전기간 (2018--2019) 평균 ",
                      "(괄호 안 표준편차)을 FHES 관측 가능 법정 자격(요건 ii, vi) 기준으로 ",
                      "층화. 차이 열은 자격 $-$ 제외 평균; Welch 2표본 $t$-검정 $p$-값은 ",
                      "오른쪽 끝 열에 보고.}")
  }
  rows <- build_rows(labels)
  tex <- paste0(
    "\\begin{table}[ht]\n\\centering\n",
    sprintf("\\caption{%s}\n", caption),
    sprintf("\\label{%s}\n\\small\n", label),
    "\\begin{tabular}{lrrrr}\n\\toprule\n",
    hdr1, "\n", hdr2, "\n",
    "\\midrule\n",
    paste(rows, collapse = "\n"),
    "\n\\bottomrule\n\\end{tabular}\n\\\\\n",
    notes, "\n\\end{table}\n"
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_dropped_table("en", file.path(out_dir, "tab_dropped_balance_en.tex"))
write_dropped_table("ko", file.path(out_dir, "tab_dropped_balance_ko.tex"))

# Console summary
sig_diffs <- ttests_df |> dplyr::filter(!is.na(p_value) & p_value < 0.05)
message(sprintf(
  "14b_dropped_hh_balance.R: %d/%d variables differ at p<.05 between eligible (n=%d) and dropped (n=%d).",
  nrow(sig_diffs), nrow(ttests_df), n_eligible, n_dropped))
if (nrow(sig_diffs) > 0) {
  for (i in seq_len(nrow(sig_diffs))) {
    r <- sig_diffs[i, ]
    cat(sprintf("  %s: E-D diff=%s, p=%s\n",
                r$variable, fmt(r$diff_mean), fmt_p(r$p_value)))
  }
}
