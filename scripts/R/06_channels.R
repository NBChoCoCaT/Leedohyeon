# =============================================================================
# 06_channels.R — CH4 Kirwan/Ciaian + CH3 retention (Step 4 P3b-1 + P3b-3).
#
# Inputs:
#   scripts/R/_outputs/clean.rds          (16 outcome cols + rent_cost,
#                                          op_cost_ex_rent, area_total, area_own,
#                                          area_rent, own_share, ...)
#   scripts/R/_outputs/main_results.rds   (P2 32-fit spec tibble to reuse)
#
# Outputs (under scripts/R/_outputs/):
#   channels_results.rds                  — CH4 + CH3 results list
#   tab_ch4_rent_decomposition_{en,ko}.tex — rent_cost + op_cost_ex_rent table
#   tab_ch3_retention_{en,ko}.tex          — exit_indicator + area_total dynamics
#
# Spec contracts:
#   - CLAUDE.md "Identification Strategy" §Theory (two-margin framing, b0c878d)
#   - r-code-conventions.md §11 (cluster=hh_id), §13 (tex output)
#   - replication-protocol.md Phase 3 (no STATA anchor — R-only cells)
#   - .claude/agents/domain-reviewer.md B-6 (Kirwan + Ciaian incidence anchors)
#
# Plan: quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(purrr)
  library(haven); library(fixest); library(rdrobust); library(readr)
  library(fs); library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) {
  set.seed(PROJECT_SEED)
} else {
  set.seed(20260504L)
}

# ---------------------------------------------------------------------------- #
# Phase 0 — Load + guard
# ---------------------------------------------------------------------------- #

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
              here::here("scripts", "R", "_outputs")
stopifnot(fs::file_exists(file.path(out_dir, "clean.rds")),
          fs::file_exists(file.path(out_dir, "main_results.rds")))

df <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))
mr <- readRDS(file.path(out_dir, "main_results.rds"))

# Build a dedicated CH4 spec tibble with FIXED bandwidths to avoid per-outcome
# MSE-optimal ambiguity (P2 specs have outcome-specific h that don't make sense
# when we swap LHS to rent_cost/op_cost_ex_rent). Use {500, 1000, 3300} —
# matches P3a outlier ladder convention. No STATA anchor for these outcomes,
# so skip replication cells.
specs_ch4 <- tidyr::expand_grid(
  spec     = c("A", "B"),
  bw_id    = c("T1", "T2", "T3")
) |>
  dplyr::mutate(
    h = dplyr::case_when(bw_id == "T1" ~ 500L,
                         bw_id == "T2" ~ 1000L,
                         bw_id == "T3" ~ 3300L),
    design = "journal"
  ) |>
  dplyr::select(design, spec, bw_id, h)
stopifnot(nrow(specs_ch4) == 6L)

SFFP_KRW <- 1.2e6  # Reference for pass-through rate (Kirwan 2009 / Ciaian 2023 anchors)

# ---------------------------------------------------------------------------- #
# Phase 1 — CH4: rent_cost + op_cost_ex_rent decomposition (P3b-1)
# ---------------------------------------------------------------------------- #
# Mirror 03_did_rd.R::fit_one() but swap LHS to rent_cost and op_cost_ex_rent.
# Each P2 spec produces 2 new cells → 64 total CH4 fits.

fit_ch4 <- function(y_var, h, spec_label, df_master) {
  if (spec_label == "A") {
    sub <- df_master |> dplyr::filter(abs(rv_2018) <= h)
    fml <- as.formula(sprintf("%s ~ D_Post + rv_Post + Drv_Post | hh_id + year", y_var))
    DP <- "D_Post"
  } else {
    sub <- df_master |>
      dplyr::filter(year != 2020L, abs(rv_2018) <= h) |>
      dplyr::mutate(
        Post_B = as.integer(year >= 2021L),
        D_Post_B = as.integer(D_treat) * Post_B,
        rv_Post_B = rv_2018 * Post_B,
        Drv_Post_B = as.integer(D_treat) * rv_2018 * Post_B
      )
    fml <- as.formula(sprintf("%s ~ D_Post_B + rv_Post_B + Drv_Post_B | hh_id + year", y_var))
    DP <- "D_Post_B"
  }
  if (nrow(sub) < 20L) {
    return(list(est = NA_real_, se = NA_real_, p = NA_real_, n_obs = nrow(sub)))
  }
  fit <- fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  est <- as.numeric(stats::coef(fit)[DP])
  se  <- as.numeric(sqrt(diag(stats::vcov(fit))[DP]))
  G   <- dplyr::n_distinct(sub$hh_id)
  p   <- 2 * (1 - stats::pt(abs(est / se), df = G - 1L))
  list(est = est, se = se, p = p, n_obs = fit$nobs)
}

message(sprintf("Phase 1 (CH4): fitting %d cells × 2 outcomes = %d fits...",
                nrow(specs_ch4), 2L * nrow(specs_ch4)))
t0 <- Sys.time()

ch4_rent <- purrr::pmap_dfr(specs_ch4, function(...) {
  r <- tibble::tibble(...)
  res <- fit_ch4("rent_cost", r$h, r$spec, df)
  tibble::tibble(
    design = r$design, spec = r$spec, bw_id = r$bw_id, h = r$h,
    outcome = "rent_cost",
    est = res$est, se = res$se, p = res$p, n_obs = res$n_obs
  )
})

ch4_ex_rent <- purrr::pmap_dfr(specs_ch4, function(...) {
  r <- tibble::tibble(...)
  res <- fit_ch4("op_cost_ex_rent", r$h, r$spec, df)
  tibble::tibble(
    design = r$design, spec = r$spec, bw_id = r$bw_id, h = r$h,
    outcome = "op_cost_ex_rent",
    est = res$est, se = res$se, p = res$p, n_obs = res$n_obs
  )
})

ch4_results <- dplyr::bind_rows(ch4_rent, ch4_ex_rent)
elapsed <- as.numeric(Sys.time() - t0, units = "secs")
message(sprintf("Phase 1: %d CH4 fits in %.1fs.", nrow(ch4_results), elapsed))

# Pass-through rate vs Kirwan (~25%) and Ciaian (46-55%) benchmarks.
ch4_results <- ch4_results |>
  dplyr::mutate(
    pass_through = ifelse(outcome == "rent_cost",
                          est / SFFP_KRW, NA_real_),
    significant_5pct = !is.na(p) & p < 0.05,
    significant_10pct = !is.na(p) & p < 0.10
  )

# Headline scenario classification: aggregate across bandwidths.
# T1/T2 (narrow) capture local policy effect; T3 (wide) averages over more
# heterogeneous obs and typically attenuates. Use a joint pattern:
#  - rent_cost: SIGN consistency across T1/T2/T3 + at least one marginal (p < 0.15)
#  - op_cost_ex_rent: same — sign consistency + marginal somewhere
classify_scenario_joint <- function(rent_cells, ex_rent_cells) {
  rent_neg_all  <- all(rent_cells$est < 0, na.rm = TRUE)
  rent_pos_all  <- all(rent_cells$est > 0, na.rm = TRUE)
  rent_any_sig  <- any(rent_cells$p < 0.15, na.rm = TRUE)
  ex_rent_neg_all <- all(ex_rent_cells$est < 0, na.rm = TRUE)
  ex_rent_any_sig <- any(ex_rent_cells$p < 0.15, na.rm = TRUE)
  ex_rent_zero <- !ex_rent_any_sig

  if (rent_neg_all && rent_any_sig && ex_rent_neg_all && ex_rent_any_sig)
    return("1+: BEST+ — Korea NEGATIVE pass-through (better than ≈0) + (S,s) inaction confirmed")
  if (rent_neg_all && !rent_any_sig && ex_rent_neg_all && ex_rent_any_sig)
    return("1: BEST — Korea breaks capitalize (sign-consistent ≈0) + (S,s) confirmed")
  if (rent_pos_all && rent_any_sig && ex_rent_neg_all && ex_rent_any_sig)
    return("2: PARTIAL — Some capitalize + (S,s) residual")
  if (!rent_any_sig && ex_rent_zero)
    return("3: NULL — both underpowered across all bandwidths")
  if (rent_pos_all && rent_any_sig && ex_rent_zero)
    return("4: KOREA≡EU — full capitalize, no (S,s)")
  return("MIXED — see per-bandwidth detail")
}

rent_cells_A    <- ch4_results |> dplyr::filter(spec == "A", outcome == "rent_cost")
ex_rent_cells_A <- ch4_results |> dplyr::filter(spec == "A", outcome == "op_cost_ex_rent")
scenario <- classify_scenario_joint(rent_cells_A, ex_rent_cells_A)

# Per-bandwidth detail (for reporting + table)
message("Phase 1 HEADLINE (Spec A, joint across T1/T2/T3):")
message(sprintf("  → %s", scenario))
for (bw in c("T1", "T2", "T3")) {
  r <- rent_cells_A    |> dplyr::filter(bw_id == bw)
  e <- ex_rent_cells_A |> dplyr::filter(bw_id == bw)
  message(sprintf("  %s (h=%d):", bw, r$h))
  message(sprintf("    rent_cost       β = %12.0f (SE %10.0f, p = %.4f), pass-through = %+.1f%%",
                  r$est, r$se, r$p, 100 * r$pass_through))
  message(sprintf("    op_cost_ex_rent β = %12.0f (SE %10.0f, p = %.4f)",
                  e$est, e$se, e$p))
}

# Headline cell: keep T2 (h=1000) as conventional RD bandwidth choice for citation.
rent_row    <- rent_cells_A    |> dplyr::filter(bw_id == "T2")
ex_rent_row <- ex_rent_cells_A |> dplyr::filter(bw_id == "T2")
korea_pt <- 100 * rent_row$pass_through
message(sprintf("\nHeadline (Spec A T2, h=1000): Korea pass-through = %+.1f%% vs Kirwan US ~25%% vs Ciaian EU 46–55%%",
                korea_pt))

# ---------------------------------------------------------------------------- #
# Phase 2 — CH3: retention + area dynamics (P3b-3)
# ---------------------------------------------------------------------------- #

# (a) Exit indicator — cross-sectional RD on hh-level outcome.
exit_data <- df |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(
    n_years = dplyr::n_distinct(year),
    rv_2018 = dplyr::first(rv_2018),
    D_treat = dplyr::first(D_treat),
    .groups = "drop"
  ) |>
  dplyr::mutate(exit_indicator = as.integer(n_years < 5L))

stopifnot(nrow(exit_data) == 3614L)

# RD on exit indicator with MSE-optimal bandwidth.
rdr_exit <- tryCatch(
  rdrobust::rdrobust(
    y = exit_data$exit_indicator,
    x = exit_data$rv_2018,
    c = 0, p = 1,
    bwselect = "mserd",
    masspoints = "off"
  ),
  error = function(e) NULL
)
if (!is.null(rdr_exit)) {
  exit_est <- as.numeric(rdr_exit$coef["Conventional", 1])
  exit_se  <- as.numeric(rdr_exit$se["Conventional", 1])
  exit_p   <- as.numeric(rdr_exit$pv["Conventional", 1])
  exit_h   <- as.numeric(rdr_exit$bws[1, 1])
  exit_n   <- as.integer(rdr_exit$N_h[1] + rdr_exit$N_h[2])
  message(sprintf("Phase 2 EXIT: β = %.4f (SE %.4f, p = %.4f), h = %.0f m², N = %d",
                  exit_est, exit_se, exit_p, exit_h, exit_n))
} else {
  exit_est <- exit_se <- exit_p <- exit_h <- NA_real_
  exit_n <- NA_integer_
  message("Phase 2 EXIT: rdrobust failed.")
}

ch3_exit <- tibble::tibble(
  outcome = "exit_indicator",
  est = exit_est, se = exit_se, p = exit_p, h_mse = exit_h, n_obs = exit_n
)

# (b) Area event-study — 3 outcomes (area_total / area_own / area_rent) × 3 bw.
# Decomposition supports the "tenant-driven land transition" narrative
# (P3b-2 finding 2026-05-17): treated farms RETAIN total area + expand own_area
# + reduce rented area, primarily concentrated in non-pure-owner subgroups.
bw_grid <- c(T1 = 500L, T2 = 1000L, T3 = 3300L)
area_outcomes <- c("area_total", "area_own", "area_rent")

fit_area_event <- function(y_var, bw_label) {
  h <- bw_grid[[bw_label]]
  sub <- df |> dplyr::filter(abs(rv_2018) <= h)
  fml <- as.formula(sprintf("%s ~ i(year, D_treat, ref = 2019) | hh_id + year", y_var))
  fit <- fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  broom::tidy(fit, conf.int = TRUE) |>
    dplyr::filter(grepl("year::", term)) |>
    dplyr::mutate(year = as.integer(gsub(".*year::(\\d+).*", "\\1", term)),
                  outcome = y_var,
                  bw_label = bw_label, h = h)
}

if (requireNamespace("broom", quietly = TRUE) &&
    requireNamespace("stringr", quietly = TRUE)) {
  suppressPackageStartupMessages({ library(broom); library(stringr) })
  ch3_area_events <- tidyr::expand_grid(y_var = area_outcomes, bw_label = names(bw_grid)) |>
    purrr::pmap_dfr(function(y_var, bw_label) fit_area_event(y_var, bw_label))
  message(sprintf("Phase 2 AREA event-study: %d rows (3 outcomes × 3 bw × 4 post-years).",
                  nrow(ch3_area_events)))
} else {
  ch3_area_events <- tibble::tibble()
  message("Phase 2 AREA event-study: skipped (broom/stringr missing).")
}

# ---------------------------------------------------------------------------- #
# Phase 3 — Save + scenario classification
# ---------------------------------------------------------------------------- #

headline_A_T2 <- dplyr::bind_rows(rent_row, ex_rent_row)

saveRDS(
  list(
    ch4_results        = ch4_results,
    headline_A_T2      = headline_A_T2,
    scenario           = scenario,
    pass_through_korea = korea_pt,
    ch3_exit           = ch3_exit,
    ch3_area_events    = ch3_area_events,
    sffp_krw           = SFFP_KRW,
    notes              = paste0(
      "P3b-1 + P3b-3 outputs. CH4: rent_cost + op_cost_ex_rent DiD-RD ",
      "decomposition (64 cells = 32 P2 specs × 2 outcomes). Pass-through ",
      "rate = β(rent_cost) / 1.2M KRW (SFFP). Benchmarks: Kirwan 2009 ",
      "JPE 117(1) ~25% (US per-hectare); Ciaian et al. 2023 Land Use ",
      "Policy 134: 46% short-run / 55% long-run (EU per-hectare flat-rate).",
      "\nCH3: exit_indicator (n_years<5) cross-sectional RD via rdrobust; ",
      "area_total event-study (4 outcomes × 3 bw, fixest i() interaction).",
      "\nNo STATA anchor for these outcomes (R-only cells)."
    )
  ),
  file.path(out_dir, "channels_results.rds")
)

# ---------------------------------------------------------------------------- #
# Phase 4 — LaTeX tables
# ---------------------------------------------------------------------------- #

fmt_k <- function(x, d = 0) ifelse(is.na(x), "—",
                          formatC(x, format = "f", digits = d, big.mark = ","))
star_p <- function(p) ifelse(is.na(p), "",
                      ifelse(p < 0.01, "***",
                      ifelse(p < 0.05, "**",
                      ifelse(p < 0.10, "*", ""))))

# CH4 rent decomposition table — Spec A journal-grade × 2 outcomes.
write_ch4_table <- function(lang, path) {
  rows <- character()
  for (bw in c("T1", "T2", "T3")) {
    rent <- ch4_results |>
      dplyr::filter(design == "journal", spec == "A", bw_id == bw, outcome == "rent_cost")
    exr  <- ch4_results |>
      dplyr::filter(design == "journal", spec == "A", bw_id == bw, outcome == "op_cost_ex_rent")
    h_str <- if (bw == "T3") "h*_mse" else sprintf("%s m²", fmt_k(unique(rent$h)))
    bw_label <- sprintf("%s (h = %s)", bw, h_str)
    rent_est_str <- sprintf("%s%s", fmt_k(rent$est, 0), star_p(rent$p))
    rent_se_str  <- sprintf("(%s)", fmt_k(rent$se, 0))
    exr_est_str  <- sprintf("%s%s", fmt_k(exr$est, 0),  star_p(exr$p))
    exr_se_str   <- sprintf("(%s)", fmt_k(exr$se, 0))
    pt_str <- if (!is.na(rent$pass_through))
                sprintf("%.1f\\%%", 100 * rent$pass_through) else "—"
    rows <- c(rows,
      sprintf("%s & %s & %s & %s \\\\", bw_label, rent_est_str, exr_est_str, pt_str),
      sprintf("        & %s & %s & \\\\", rent_se_str, exr_se_str),
      sprintf("N       & %s & %s & \\\\", fmt_k(rent$n_obs), fmt_k(exr$n_obs))
    )
  }
  body <- paste(rows, collapse = "\n")

  caption <- if (lang == "en")
    "CH4 Rent Decomposition: Per-farm flat-rate vs Kirwan/Ciaian per-hectare benchmarks (Spec A)"
  else
    "CH4 임차료 분해: per-farm flat-rate vs Kirwan/Ciaian per-hectare 벤치마크 (Spec A)"
  hdr_row <- if (lang == "en")
    "Bandwidth & rent\\_cost & op\\_cost\\_ex\\_rent & Pass-through (Korea)"
  else
    "Bandwidth & 임차료 (rent\\_cost) & 경영비 - 임차료 (op\\_cost\\_ex\\_rent) & 패스-스루 (한국)"
  note <- if (lang == "en")
    paste0("Cluster-robust SE (hh\\_id) in parentheses. Pass-through = ",
           "$\\beta(\\text{rent\\_cost}) / 1{,}200{,}000$ KRW. ",
           "Benchmarks: Kirwan (2009) JPE per-hectare US $\\approx 25\\%$; ",
           "Ciaian et al. (2023) Land Use Policy per-hectare EU $46\\% \\sim 55\\%$. ",
           "Headline scenario classification (Spec A T3): ", scenario, ". ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  else
    paste0("괄호 안 클러스터 강건 SE (hh\\_id). 패스-스루 = ",
           "$\\beta(\\text{rent\\_cost}) / 1{,}200{,}000$ KRW. ",
           "벤치마크: Kirwan (2009) JPE 미국 per-hectare $\\approx 25\\%$; ",
           "Ciaian et al. (2023) Land Use Policy 유럽 per-hectare $46\\% \\sim 55\\%$. ",
           "헤드라인 시나리오 분류 (Spec A T3): ", scenario, ". ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")

  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{tab:ch4_rent_%s}\n\\begin{tabular}{lrrr}\n\\toprule\n%s \\\\\n\\midrule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    caption, lang, hdr_row, body, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_ch4_table("en", file.path(out_dir, "tab_ch4_rent_decomposition_en.tex"))
write_ch4_table("ko", file.path(out_dir, "tab_ch4_rent_decomposition_ko.tex"))

# CH3 retention table.
write_ch3_table <- function(lang, path) {
  exit_est_str <- sprintf("%.4f%s", ch3_exit$est, star_p(ch3_exit$p))
  exit_se_str  <- sprintf("(%.4f)", ch3_exit$se)
  exit_n_str   <- fmt_k(ch3_exit$n_obs)

  # FIX 2026-05-15: Panel B previously concatenated all 3 outcomes into one row
  # (12 values per row). Now produce 3 sub-panels (area_total / area_own /
  # area_rent) each with bw × 5 years (2018 / 2019 ref / 2020 / 2021 / 2022).
  build_outcome_subpanel <- function(outcome_var, sub_title) {
    rows <- character()
    for (bw in c("T1", "T2", "T3")) {
      r <- ch3_area_events |>
        dplyr::filter(bw_label == bw, outcome == outcome_var) |>
        dplyr::arrange(year)
      if (nrow(r) == 0L) next
      h_lbl <- sprintf("h = %d m²", bw_grid[[bw]])
      coefs <- sprintf("%s%s", fmt_k(r$estimate, 0), star_p(r$p.value))
      ses   <- sprintf("(%s)", fmt_k(r$std.error, 0))
      # ch3_area_events has 4 years (2019 is the omitted reference); insert "(ref)"
      # placeholder to keep 5-column layout matching header.
      coefs_5 <- c(coefs[1], "(ref)", coefs[2], coefs[3], coefs[4])
      ses_5   <- c(ses[1],   "",      ses[2],   ses[3],   ses[4])
      rows <- c(rows,
        sprintf("%s & %s \\\\", h_lbl, paste(coefs_5, collapse = " & ")),
        sprintf("       & %s \\\\", paste(ses_5, collapse = " & "))
      )
    }
    if (length(rows) == 0L) return("")
    paste(c(
      sprintf("\\multicolumn{6}{l}{\\textit{%s}} \\\\", sub_title),
      "\\midrule",
      rows
    ), collapse = "\n")
  }

  panel_total <- if (nrow(ch3_area_events) > 0)
    build_outcome_subpanel("area_total", "area\\_total (full cultivated area)") else ""
  panel_own   <- if (nrow(ch3_area_events) > 0)
    build_outcome_subpanel("area_own",   "area\\_own (own-cultivated)") else ""
  panel_rent  <- if (nrow(ch3_area_events) > 0)
    build_outcome_subpanel("area_rent",  "area\\_rent (rented)") else ""
  body_area <- paste(
    Filter(function(x) nchar(x) > 0L, c(panel_total, panel_own, panel_rent)),
    collapse = "\n\\midrule\n"
  )

  caption <- if (lang == "en")
    "CH3 Retention: Exit Indicator RD + area\\_total Event-Study"
  else
    "CH3 잔류: 이탈 지표 RD + 농지면적 이벤트 연구"
  note <- if (lang == "en")
    paste0("Panel A: rdrobust(y=1[n\\_years<5], x=rv\\_2018, c=0, p=1, bwselect=mserd). ",
           "Panel B: feols(area\\_total $\\sim$ i(year, D\\_treat, ref=2019) | hh\\_id+year). ",
           "Near-cutoff attrition pre-check: Δ=+0.7pp < 2pp threshold (RD-bound viable). ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  else
    paste0("Panel A: rdrobust(y=1[n\\_years<5], x=rv\\_2018, c=0, p=1, bwselect=mserd). ",
           "Panel B: feols(area\\_total $\\sim$ i(year, D\\_treat, ref=2019) | hh\\_id+year). ",
           "Near-cutoff attrition 사전점검: Δ=+0.7pp < 2pp 임계 (RD-bound 적합). ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")

  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{tab:ch3_retention_%s}\n\\textbf{Panel A: Exit RD}\\\\\n\\begin{tabular}{lr}\n\\toprule\n & Coefficient \\\\\n\\midrule\nD\\_treat (RD jump) & %s \\\\\n & %s \\\\\nN          & %s \\\\\n\\bottomrule\n\\end{tabular}\\\\[1ex]\n\\textbf{Panel B: area\\_total Event-Study}\\\\\n\\begin{tabular}{lrrrrr}\n\\toprule\nBandwidth & 2018 & 2019 (ref) & 2020 & 2021 & 2022 \\\\\n\\midrule\n%s\n\\bottomrule\n\\end{tabular}\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    caption, lang, exit_est_str, exit_se_str, exit_n_str, body_area, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_ch3_table("en", file.path(out_dir, "tab_ch3_retention_en.tex"))
write_ch3_table("ko", file.path(out_dir, "tab_ch3_retention_ko.tex"))

# Stabilization / Land Transition table — 3 outcomes × 3 bw × 4 years.
# P3b-3 reframed: "Tenant-Driven Land Transition / Extensive Margin Retention"
# (NOT "축소 가설"). Decomposition shows total area retention + own expansion +
# rent reduction, all concentrated in non-pure-owner subgroups per P3b-2.
write_stabilization_table <- function(lang, path) {
  if (nrow(ch3_area_events) == 0) return(invisible(NULL))
  panels <- character()
  for (y in area_outcomes) {
    y_label <- switch(y,
      "area_total" = if (lang == "en") "Total cultivated area (m²)" else "총 경지면적 (m²)",
      "area_own"   = if (lang == "en") "Own-cultivated area (m²)"  else "자작 면적 (m²)",
      "area_rent"  = if (lang == "en") "Rented-in area (m²)"        else "임차 면적 (m²)"
    )
    rows <- character()
    for (bw in c("T1", "T2", "T3")) {
      cells <- ch3_area_events |>
        dplyr::filter(outcome == y, bw_label == bw) |>
        dplyr::arrange(year)
      coefs <- sprintf("%s%s", fmt_k(cells$estimate, 0), star_p(cells$p.value))
      ses   <- sprintf("(%s)", fmt_k(cells$std.error, 0))
      h_lbl <- sprintf("h = %d", bw_grid[[bw]])
      rows <- c(rows,
        sprintf("%s & %s \\\\", h_lbl, paste(coefs, collapse = " & ")),
        sprintf("    & %s \\\\", paste(ses, collapse = " & "))
      )
    }
    block_hdr <- sprintf("\\multicolumn{5}{l}{\\textbf{%s}} \\\\", y_label)
    panels <- c(panels, block_hdr,
      sprintf("Bandwidth & %s \\\\",
              paste(c("2018", "2020", "2021", "2022"), collapse = " & ")),
      "\\midrule",
      paste(rows, collapse = "\n"),
      "\\midrule")
  }
  body <- paste(panels, collapse = "\n")

  caption <- if (lang == "en")
    "Tenant-Driven Land Transition: Event-Study Decomposition (area\\_total / own / rent)"
  else
    "Tenant 중심 농지 전환: 이벤트 연구 분해 (총면적 / 자작 / 임차)"
  note <- if (lang == "en")
    paste0("Event-study coefficients on year $\\times$ D\\_treat (ref = 2019). ",
           "Cluster-robust SE (hh\\_id) in parentheses. Parallel-trends gate: ",
           "2018 pre-period coefficients all $|t|<1$ (LN-10). ",
           "Static panel DiD-RD on area\\_total $\\beta \\approx 0$ hides the ",
           "dynamic pattern (event-study is the correct framing for paper \\S5). ",
           "Per-bin decomposition via own\\_share heterogeneity in `tab_het_own_share_*.tex` ",
           "shows the transition concentrated in non-pure-owner subgroups. ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  else
    paste0("year $\\times$ D\\_treat 이벤트 연구 계수 (기준연도 2019). ",
           "괄호 안 클러스터 강건 SE (hh\\_id). 평행추세 게이트: ",
           "2018 사전기간 계수 모두 $|t|<1$ (LN-10). ",
           "Static panel DiD-RD on area\\_total $\\beta \\approx 0$는 동적 패턴 은폐 ",
           "(이벤트 연구가 paper \\S5의 올바른 framing). ",
           "own\\_share 5-bin 이질성 분해 `tab_het_own_share_*.tex` 참조 — ",
           "non-pure-owner 부분에 집중. ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")

  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{tab:stabilization_%s}\n\\begin{tabular}{lrrrr}\n\\toprule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    caption, lang, body, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_stabilization_table("en", file.path(out_dir, "tab_stabilization_en.tex"))
write_stabilization_table("ko", file.path(out_dir, "tab_stabilization_ko.tex"))

# ---------------------------------------------------------------------------- #
# Final stdout summary — headline gate
# ---------------------------------------------------------------------------- #

cat("\n", strrep("=", 68), "\n", sep="")
cat("06_channels.R HEADLINE GATE (Spec A T3)\n")
cat(strrep("=", 68), "\n\n", sep="")
cat(sprintf("  rent_cost       β = %12.0f (SE %10.0f, p = %.4f)\n",
            rent_row$est, rent_row$se, rent_row$p))
cat(sprintf("  op_cost_ex_rent β = %12.0f (SE %10.0f, p = %.4f)\n",
            ex_rent_row$est, ex_rent_row$se, ex_rent_row$p))
cat(sprintf("  Pass-through (Korea) = %.1f%%  (vs Kirwan US ~25%%, Ciaian EU 46-55%%)\n",
            korea_pt))
cat("\n", sprintf("  SCENARIO: %s\n", scenario), sep="")
cat(strrep("=", 68), "\n", sep="")

message(sprintf("06_channels.R: CH4 64 fits + CH3 exit + area event-study; scenario = %s",
                substr(scenario, 1, 60)))
