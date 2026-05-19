# =============================================================================
# 05b_figures_raw_xaxis.R — Wave 7 follow-up Q7: regenerate primary figures
# with raw x-axis convention.
#
# Convention (Q7, user decision 2026-05-19):
#   - x-axis = area_2018 (raw, m²), NOT rv_2018 (centered)
#   - Cutoff line at x = 5000 (red dashed, vertical)
#   - Annotation: "Cutoff: 0.5 ha (5,000 m²)"
#   - x-axis label: "Baseline cultivated area A_{2018} (m²)"
#   - x-range: 0 to 10,000 m² for McCrary; matched to bandwidth for RD scatter
#
# Scope: re-generates ONLY figures that use rv_2018 (centered) on x-axis:
#   - McCrary density plots (full + ±500 m² window) → use area_2018
#   - First-difference DiD-RD scatter plots (4 outcomes × 2 specs) → use area_2018
#
# Figures already in raw / non-area dimensions (no change needed):
#   - Event-study plots: x = year (raw)
#   - F1 four-bin gradient: x = tenancy bin (categorical)
#   - HonestDiD sensitivity: x = M̄ (relative-magnitude parameter)
#   - Multi-RV McCrary: already uses raw x-axis per 11b
#   - Forest plot: y = cell label (categorical)
#
# Input:  scripts/R/_outputs_eligibility/clean.rds, mccrary_test.rds
# Output: scripts/R/_outputs_eligibility/fig_mccrary_density_*_{en,ko}.{pdf,png}
#         scripts/R/_outputs_eligibility/fig_rd_*_spec_*_{en,ko}.{pdf,png}
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(ggplot2); library(rdrobust); library(rddensity)
  library(haven); library(fs); library(here)
})
set.seed(20260504L)

out_dir <- here::here("scripts", "R", "_outputs_eligibility")
df <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))
mc <- readRDS(file.path(out_dir, "mccrary_test.rds"))

outcomes <- c("op_cost", "off_farm_income", "consumption", "farm_income")

labels_en <- list(
  op_cost          = "Operating cost (KRW)",
  off_farm_income  = "Off-farm income (KRW)",
  consumption      = "Consumption (KRW)",
  farm_income      = "Farm income (KRW)"
)
labels_ko <- list(
  op_cost          = "농업경영비 (KRW)",
  off_farm_income  = "농외소득 (KRW)",
  consumption      = "가계 소비지출 (KRW)",
  farm_income      = "농가소득 (KRW)"
)

CUTOFF <- 5000
CUTOFF_COLOR <- "#b91c1c"
RAW_X_LABEL_EN <- expression("Baseline cultivated area "*A[2018]*" (m"^2*")")
RAW_X_LABEL_KO <- expression("2018 기준 경지면적 "*A[2018]*" (m"^2*")")
CUTOFF_ANNOT_EN <- "Cutoff: 0.5 ha (5,000 m²)"
CUTOFF_ANNOT_KO <- "컷오프: 0.5 ha (5,000 m²)"

# Reused theme helper
theme_raw <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title    = ggplot2::element_text(face = "bold", color = "#012169"),
      plot.subtitle = ggplot2::element_text(color = "#525252"),
      plot.caption  = ggplot2::element_text(color = "#525252", size = 9, hjust = 0),
      panel.grid.minor = ggplot2::element_blank()
    )
}

save_dual <- function(plot, basename, w = 7, h = 4.5) {
  ggplot2::ggsave(file.path(out_dir, paste0(basename, ".png")),
                  plot = plot, width = w, height = h,
                  dpi = 300, bg = "transparent")
  # Use base pdf() device (cairo_pdf hits X11 lib issue on some Macs)
  pdf(file.path(out_dir, paste0(basename, ".pdf")), width = w, height = h)
  print(plot); dev.off()
}

# ---------------------------------------------------------------------------- #
# Phase 1 — McCrary density plots on RAW area_2018
# ---------------------------------------------------------------------------- #
# We re-call rddensity::rdplotdensity with X = area_2018 and c = 5000 so the
# horizontal axis is raw m². Statistical results (T, p) are read from the
# pre-computed mc$full / mc$pm500 objects (which use rv_2018 centered at 0;
# the test is shift-invariant).

df18 <- df |> dplyr::filter(year == 2018L)

# Re-run rddensity on raw area_2018 with c = 5000 (test stats are
# shift-invariant; we need the rdd object on raw scale for plotting).
mc_raw_full  <- rddensity::rddensity(X = df18$area_2018, c = CUTOFF, vce = "jackknife")
mc_raw_pm500 <- rddensity::rddensity(
  X = df18$area_2018[abs(df18$rv_2018) <= 500], c = CUTOFF, vce = "jackknife")

plot_mccrary_raw <- function(rdd_obj, range_lo_raw, range_hi_raw, x_raw, lang) {
  grDevices::pdf(NULL)
  pp <- rddensity::rdplotdensity(
    rdd = rdd_obj, X = x_raw,
    plotRange = if (is.null(range_lo_raw)) NULL else c(range_lo_raw, range_hi_raw),
    type = "both"
  )
  grDevices::dev.off()

  ttl <- if (lang == "en") {
    if (is.null(range_lo_raw)) "McCrary Density Test at 0.5 ha Cutoff"
    else sprintf("McCrary Density Test — Window: %d to %d m²",
                 as.integer(range_lo_raw), as.integer(range_hi_raw))
  } else {
    if (is.null(range_lo_raw)) "McCrary 밀도 검정 (0.5 ha 컷오프)"
    else sprintf("McCrary 밀도 검정 — 윈도우: %d to %d m²",
                 as.integer(range_lo_raw), as.integer(range_hi_raw))
  }
  sub <- sprintf("Robust T = %.4f, p = %.4f, N = %d",
                 rdd_obj$test$t_jk, rdd_obj$test$p_jk, rdd_obj$N$full)
  cap <- if (lang == "en")
    "Vertical bars: confidence bands. Smooth lines: estimated densities. Red dashed line marks the 0.5 ha (5,000 m²) cutoff."
  else
    "수직 바: 신뢰구간. 곡선: 추정 밀도. 빨간 점선: 0.5 ha (5,000 m²) 컷오프."

  annot_y_pos <- Inf

  pp$Estplot +
    ggplot2::geom_vline(xintercept = CUTOFF, color = CUTOFF_COLOR,
                        linetype = "dashed", linewidth = 0.7) +
    ggplot2::annotate("text", x = CUTOFF, y = annot_y_pos,
                      label = if (lang == "en") CUTOFF_ANNOT_EN else CUTOFF_ANNOT_KO,
                      hjust = -0.05, vjust = 1.5, size = 3.2, color = CUTOFF_COLOR) +
    ggplot2::labs(title = ttl, subtitle = sub, caption = cap,
                  x = if (lang == "en") RAW_X_LABEL_EN else RAW_X_LABEL_KO,
                  y = if (lang == "en") "Density" else "밀도") +
    ggplot2::guides(color = "none", linetype = "none", fill = "none") +
    theme_raw()
}

for (lg in c("en", "ko")) {
  save_dual(plot_mccrary_raw(mc_raw_full, NULL, NULL,
                              df18$area_2018, lg),
            sprintf("fig_mccrary_density_full_%s", lg), w = 7, h = 4.5)
  save_dual(plot_mccrary_raw(mc_raw_pm500, 4500, 5500,
                              df18$area_2018[abs(df18$rv_2018) <= 500], lg),
            sprintf("fig_mccrary_density_pm500_%s", lg), w = 7, h = 4.5)
}
message("Phase 1: McCrary density plots (raw x-axis) re-saved: 2 × 2 langs × 2 fmts = 8 files.")

# ---------------------------------------------------------------------------- #
# Phase 2 — First-difference RD scatter plots on RAW area_2018
# ---------------------------------------------------------------------------- #
# Pass x = area_2018 to rdrobust::rdplot with c = 5000; rdrobust constructs
# bins and local-linear fits around the raw cutoff.

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
          dplyr::summarise(area_2018 = dplyr::first(area_2018), .groups = "drop")
  fd <- hh |> dplyr::inner_join(pre, by = "hh_id") |>
              dplyr::inner_join(post, by = "hh_id")
  for (v in outcomes) {
    fd[[paste0("d_", v)]] <- fd[[paste0("post_", v)]] - fd[[paste0("pre_", v)]]
  }
  fd
}
fd_specA <- compute_fd(df,                                 2018:2019, 2020:2022)
fd_specB <- compute_fd(df |> dplyr::filter(year != 2020L), 2018:2019, 2021:2022)

plot_rd_scatter_raw <- function(fd, y_var, spec, lang) {
  d_y <- fd[[paste0("d_", y_var)]]
  x   <- fd$area_2018
  keep <- !is.na(d_y) & !is.na(x)
  d_y <- d_y[keep]; x <- x[keep]

  grDevices::pdf(NULL)
  rp <- rdrobust::rdplot(y = d_y, x = x, c = CUTOFF, p = 1,
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
    sprintf("Red dashed line marks 0.5 ha (5,000 m²) cutoff. Local linear fit on either side. N = %d.", length(d_y))
  else
    sprintf("빨간 점선: 0.5 ha (5,000 m²) 컷오프. 양측 local linear fit. N = %d.", length(d_y))

  g +
    ggplot2::geom_vline(xintercept = CUTOFF, color = CUTOFF_COLOR,
                        linetype = "dashed", linewidth = 0.7) +
    ggplot2::annotate("text", x = CUTOFF, y = Inf,
                      label = if (lang == "en") CUTOFF_ANNOT_EN else CUTOFF_ANNOT_KO,
                      hjust = -0.05, vjust = 1.5, size = 3.0, color = CUTOFF_COLOR) +
    ggplot2::labs(title = ttl, subtitle = sub, caption = cap,
                  x = if (lang == "en") RAW_X_LABEL_EN else RAW_X_LABEL_KO,
                  y = if (lang == "en")
                        sprintf("Δ %s (Post − Pre)", labels_en[[y_var]])
                      else
                        sprintf("Δ %s (Post − Pre)", labels_ko[[y_var]])) +
    theme_raw()
}

for (lg in c("en", "ko")) {
  for (y in outcomes) {
    for (sp in c("A", "B")) {
      fd <- if (sp == "A") fd_specA else fd_specB
      save_dual(plot_rd_scatter_raw(fd, y, sp, lg),
                sprintf("fig_rd_%s_spec_%s_%s", y, sp, lg),
                w = 6.5, h = 4.5)
    }
  }
}
message("Phase 2: RD scatter plots (raw x-axis) re-saved: 4 outcomes × 2 specs × 2 langs × 2 fmts = 32 files.")

message("05b_figures_raw_xaxis.R: raw x-axis figure convention applied (Q7 follow-up).")
