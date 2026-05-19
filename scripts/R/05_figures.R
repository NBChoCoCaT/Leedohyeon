# =============================================================================
# 05_figures.R — McCrary density + RD scatter + Event-study (Step 4 P3a Tier 1).
#
# Inputs:
#   scripts/R/_outputs/clean.rds          (16 outcome cols + IDs)
#   scripts/R/_outputs/main_results.rds   (P2 fits)
#   scripts/R/_outputs/mccrary_test.rds   (P3a 04_robust.R)
#
# Outputs (under scripts/R/_outputs/, gitignored):
#   fig_mccrary_density_{full,pm500}_{en,ko}.{pdf,png}     (2 × 2 × 2 = 8)
#   fig_rd_<outcome>_spec_{A,B}_{en,ko}.{pdf,png}          (4 × 2 × 2 × 2 = 32)
#   fig_event_study_<outcome>_T{1,2,3}_{en,ko}.{pdf,png}   (4 × 3 × 2 × 2 = 48)
#   Total: 88 figure files (Korean + English mirrors).
#
# Spec contracts:
#   - r-code-conventions.md §4 (palette + theme template), §13 (PDF cairo / PNG transparent)
#   - content-invariants.md INV-11 (bg=transparent for slides), INV-12 (project theme)
#   - STATA 02_analysis.do lines 130-140 (rdplot pattern) + 07_eventstudy.do (event-study)
#
# Plan: quality_reports/plans/2026-05-15_p3a-tier1-robust-figures.md
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tibble); library(purrr); library(broom); library(stringr)
  library(haven); library(fixest); library(rdrobust); library(rddensity)
  library(ggplot2); library(fs); library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) {
  set.seed(PROJECT_SEED)
} else {
  set.seed(20260504L)
}

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
              here::here("scripts", "R", "_outputs")
stopifnot(fs::file_exists(file.path(out_dir, "clean.rds")),
          fs::file_exists(file.path(out_dir, "mccrary_test.rds")))

df <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))
mc <- readRDS(file.path(out_dir, "mccrary_test.rds"))

outcomes <- c("op_cost", "off_farm_income", "consumption", "farm_income")
labels_en <- c(op_cost = "Operating Cost (KRW)",
               off_farm_income = "Off-Farm Income (KRW)",
               consumption = "Consumption (KRW)",
               farm_income = "Farm Income (KRW)")
labels_ko <- c(op_cost = "농업경영비 (원)",
               off_farm_income = "농외소득 (원)",
               consumption = "가계 소비지출 (원)",
               farm_income = "농업소득 (원)")

# ---------------------------------------------------------------------------- #
# Phase 0 — Project theme (r-code-conventions §4 instantiation)
# ---------------------------------------------------------------------------- #

PIDPS_PALETTE <- c(primary_blue   = "#0E4D92",
                   primary_gold   = "#D6A656",
                   accent_gray    = "#6E6E6E",
                   positive_green = "#1E8449",
                   negative_red   = "#C0392B")

theme_pidps_custom <- function() {
  ggplot2::theme_minimal(base_size = 11, base_family = "sans") %+replace%
    ggplot2::theme(
      plot.title       = ggplot2::element_text(color = PIDPS_PALETTE[["primary_blue"]],
                                                face = "bold", size = 12,
                                                margin = ggplot2::margin(b = 6)),
      plot.subtitle    = ggplot2::element_text(color = PIDPS_PALETTE[["accent_gray"]],
                                                size = 10,
                                                margin = ggplot2::margin(b = 8)),
      plot.caption     = ggplot2::element_text(color = PIDPS_PALETTE[["accent_gray"]],
                                                size  = 8, hjust = 0),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(color = "gray90", linewidth = 0.3),
      legend.position  = "bottom",
      plot.background  = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA)
    )
}

# Helper: save PDF (English only — base pdf device handles ASCII cleanly)
# + PNG (both Korean + English — PNG raster renders system fonts including Korean).
# Per §13 + INV-11. macOS R 4.5.3 lacks cairo DLL (cairo_pdf fails); base pdf()
# emits "mbcsToSbcs conversion failure" on Korean glyphs. Korean PDF generation
# requires `showtext` package setup — deferred to P3b.
save_dual <- function(plot, basename, w = 6.5, h = 4.5) {
  # PNG always — raster, transparent bg for slide overlay (INV-11).
  ggplot2::ggsave(file.path(out_dir, paste0(basename, ".png")),
                  plot = plot, width = w, height = h,
                  dpi = 300, bg = "transparent")
  # PDF only for English-tagged basenames (paper/en canonical per project goal).
  if (grepl("_en$", basename)) {
    ggplot2::ggsave(file.path(out_dir, paste0(basename, ".pdf")),
                    plot = plot, width = w, height = h,
                    device = "pdf", bg = "white")
  }
}

# ---------------------------------------------------------------------------- #
# Phase 1 — McCrary density plots (full + ±500 window)
# ---------------------------------------------------------------------------- #

plot_mccrary <- function(rdd_obj, range_lo, range_hi, x_vals, lang) {
  grDevices::pdf(NULL)            # suppress side-effect plot
  pp <- rddensity::rdplotdensity(
    rdd = rdd_obj, X = x_vals,
    plotRange = if (is.null(range_lo)) NULL else c(range_lo, range_hi),
    type = "both"
  )
  grDevices::dev.off()

  ttl <- if (lang == "en") {
    if (is.null(range_lo)) "McCrary Density Test at Cutoff (rv_2018 = 0)"
    else sprintf("McCrary Density Test — Window: %d to %d m²",
                 as.integer(range_lo), as.integer(range_hi))
  } else {
    if (is.null(range_lo)) "McCrary 밀도 검정 (cutoff rv_2018 = 0)"
    else sprintf("McCrary 밀도 검정 — 윈도우: %d to %d m²",
                 as.integer(range_lo), as.integer(range_hi))
  }
  sub <- sprintf("Robust T = %.4f, p = %.4f, N = %d",
                 rdd_obj$test$t_jk, rdd_obj$test$p_jk, rdd_obj$N$full)
  cap <- if (lang == "en")
    "Vertical bars: confidence bands. Smooth lines: estimated densities. STATA anchor: T=1.4495 (04_robustness.log line 145)."
  else
    "수직 바: 신뢰구간. 곡선: 추정 밀도. STATA 앵커: T=1.4495 (04_robustness.log line 145)."

  pp$Estplot +
    ggplot2::labs(title = ttl, subtitle = sub, caption = cap,
                  x = "Running variable: A₂₀₁₈ − 5000 m²",
                  y = if (lang == "en") "Density" else "밀도") +
    theme_pidps_custom()
}

df18 <- df |> dplyr::filter(year == 2018L)
for (lg in c("en", "ko")) {
  save_dual(plot_mccrary(mc$full,  NULL, NULL, df18$rv_2018, lg),
            sprintf("fig_mccrary_density_full_%s", lg),  w = 7, h = 4.5)
  save_dual(plot_mccrary(mc$pm500, -500, 500,
                          df18$rv_2018[abs(df18$rv_2018) <= 500], lg),
            sprintf("fig_mccrary_density_pm500_%s", lg), w = 7, h = 4.5)
}
message("Phase 1: McCrary density plots (2 × 2 langs × 2 fmts = 8 files) saved.")

# ---------------------------------------------------------------------------- #
# Phase 2 — RD scatter (first-difference DiD-RD): mirror STATA rdplot
# ---------------------------------------------------------------------------- #

compute_fd <- function(df_full, pre_years, post_years) {
  pre  <- df_full |> dplyr::filter(year %in% pre_years)  |>
            dplyr::group_by(hh_id) |>
            dplyr::summarise(dplyr::across(dplyr::all_of(outcomes),
                                           ~ mean(.x, na.rm = TRUE),
                                           .names = "pre_{.col}"), .groups = "drop")
  post <- df_full |> dplyr::filter(year %in% post_years) |>
            dplyr::group_by(hh_id) |>
            dplyr::summarise(dplyr::across(dplyr::all_of(outcomes),
                                           ~ mean(.x, na.rm = TRUE),
                                           .names = "post_{.col}"), .groups = "drop")
  hh <- df_full |> dplyr::group_by(hh_id) |>
          dplyr::summarise(rv_2018 = dplyr::first(rv_2018), .groups = "drop")
  fd <- hh |> dplyr::inner_join(pre, by = "hh_id") |> dplyr::inner_join(post, by = "hh_id")
  for (v in outcomes) {
    fd[[paste0("d_", v)]] <- fd[[paste0("post_", v)]] - fd[[paste0("pre_", v)]]
  }
  fd
}
fd_specA <- compute_fd(df,                                 pre_years = 2018:2019, post_years = 2020:2022)
fd_specB <- compute_fd(df |> dplyr::filter(year != 2020L), pre_years = 2018:2019, post_years = 2021:2022)

plot_rd_scatter <- function(fd, y_var, spec, lang) {
  d_y <- fd[[paste0("d_", y_var)]]
  rv  <- fd$rv_2018
  keep <- !is.na(d_y) & !is.na(rv)
  d_y <- d_y[keep]; rv <- rv[keep]

  grDevices::pdf(NULL)
  rp <- rdrobust::rdplot(y = d_y, x = rv, c = 0, p = 1,
                          binselect = "esmv", masspoints = "off",
                          hide = TRUE)
  grDevices::dev.off()

  g <- rp$rdplot

  ttl <- if (lang == "en")
    sprintf("First-Difference DiD-RD: %s (Spec %s)", labels_en[[y_var]], spec)
  else
    sprintf("First-Difference DiD-RD: %s (Spec %s)", labels_ko[[y_var]], spec)
  sub <- if (lang == "en") {
    if (spec == "A") "Pre = 2018-19 mean; Post = 2020-22 mean"
    else             "Pre = 2018-19 mean; Post = 2021-22 mean (2020 dropped)"
  } else {
    if (spec == "A") "Pre = 2018-19 평균; Post = 2020-22 평균"
    else             "Pre = 2018-19 평균; Post = 2021-22 평균 (2020 제외)"
  }
  cap <- if (lang == "en")
    sprintf("Cutoff at rv_2018 = 0 (= 0.5 ha). Local linear fit on either side. N = %d.", length(d_y))
  else
    sprintf("컷오프 rv_2018 = 0 (= 0.5 ha). 양측 local linear fit. N = %d.", length(d_y))

  g +
    ggplot2::geom_vline(xintercept = 0, color = PIDPS_PALETTE[["negative_red"]],
                        linetype = "dashed", linewidth = 0.5) +
    ggplot2::labs(title = ttl, subtitle = sub, caption = cap,
                  x = "Running variable: A₂₀₁₈ − 5000 m²",
                  y = if (lang == "en")
                        sprintf("Δ %s (Post − Pre)", labels_en[[y_var]])
                      else
                        sprintf("Δ %s (Post − Pre)", labels_ko[[y_var]])) +
    theme_pidps_custom()
}

for (lg in c("en", "ko")) {
  for (y in outcomes) {
    for (sp in c("A", "B")) {
      fd <- if (sp == "A") fd_specA else fd_specB
      save_dual(plot_rd_scatter(fd, y, sp, lg),
                sprintf("fig_rd_%s_spec_%s_%s", y, sp, lg),
                w = 6.5, h = 4.5)
    }
  }
}
message("Phase 2: RD scatter (4 × 2 × 2 × 2 = 32 files) saved.")

# ---------------------------------------------------------------------------- #
# Phase 3 — Event-study (parallel trends visualization)
# ---------------------------------------------------------------------------- #
# STATA 07_eventstudy.do: base year 2019, lags 2018, leads 2020-22. R port via
# fixest::i() interaction syntax.

bw_grid <- c(T1 = 500L, T2 = 1000L, T3 = 3300L)

plot_event_study <- function(y_var, bw_label, lang) {
  h <- bw_grid[[bw_label]]
  sub <- df |> dplyr::filter(abs(rv_2018) <= h)
  fml <- as.formula(sprintf("%s ~ i(year, D_treat, ref = 2019) | hh_id + year", y_var))
  fit <- fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)

  tidy_event <- broom::tidy(fit, conf.int = TRUE) |>
    dplyr::mutate(year = as.integer(stringr::str_extract(term, "(?<=year::)\\d{4}"))) |>
    dplyr::filter(!is.na(year))
  ref_row <- tibble::tibble(term = "year::2019:D_treat=1", estimate = 0,
                            std.error = 0, statistic = NA_real_, p.value = NA_real_,
                            conf.low = 0, conf.high = 0, year = 2019L)
  tidy_event <- dplyr::bind_rows(tidy_event, ref_row) |> dplyr::arrange(year)

  ttl <- if (lang == "en")
    sprintf("Event Study: %s (h = %d m²)", labels_en[[y_var]], h)
  else
    sprintf("이벤트 연구: %s (h = %d m²)", labels_ko[[y_var]], h)
  sub_text <- if (lang == "en")
    "Coefficients on year × D_treat (base year 2019, omitted). Policy effective 2020."
  else
    "year × D_treat 계수 (기준연도 2019, 생략). 정책 시행 2020년."
  cap <- if (lang == "en")
    sprintf("Cluster-robust 95%% CI (hh_id). N = %d. STATA anchor: 07_eventstudy.log lines 85-89.", fit$nobs)
  else
    sprintf("클러스터 강건 95%% CI (hh_id). N = %d. STATA 앵커: 07_eventstudy.log lines 85-89.", fit$nobs)

  # Format y-axis in millions (KRW) for readability instead of scientific notation
  fmt_millions <- function(x) {
    ifelse(abs(x) < 1e6, sprintf("%.1f", x / 1e6),
           sprintf("%.0fM", x / 1e6))
  }

  ggplot2::ggplot(tidy_event, ggplot2::aes(x = year, y = estimate)) +
    ggplot2::geom_hline(yintercept = 0, color = PIDPS_PALETTE[["negative_red"]],
                        linetype = "dashed", linewidth = 0.5) +
    ggplot2::geom_vline(xintercept = 2019.5, color = PIDPS_PALETTE[["accent_gray"]],
                        linetype = "solid", linewidth = 0.4, alpha = 0.5) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = conf.low, ymax = conf.high),
                            width = 0.15, color = PIDPS_PALETTE[["primary_blue"]]) +
    ggplot2::geom_point(color = PIDPS_PALETTE[["primary_blue"]], size = 2.5) +
    ggplot2::scale_x_continuous(breaks = 2018:2022) +
    ggplot2::scale_y_continuous(labels = fmt_millions) +
    ggplot2::labs(title = ttl, subtitle = sub_text, caption = cap,
                  x = if (lang == "en") "Year" else "연도",
                  y = if (lang == "en") "Coefficient (million KRW)" else "계수 (백만 원)") +
    theme_pidps_custom()
}

for (lg in c("en", "ko")) {
  for (y in outcomes) {
    for (bwl in names(bw_grid)) {
      save_dual(plot_event_study(y, bwl, lg),
                sprintf("fig_event_study_%s_%s_%s", y, bwl, lg),
                w = 6.5, h = 4.5)
    }
  }
}
message("Phase 3: Event-study plots (4 × 3 × 2 × 2 = 48 files) saved.")

# ---------------------------------------------------------------------------- #
# Final stdout summary
# ---------------------------------------------------------------------------- #

n_files <- length(list.files(out_dir, pattern = "^fig_.*\\.(pdf|png)$"))
message(sprintf("05_figures.R: %d figure files generated (target: 88).", n_files))
