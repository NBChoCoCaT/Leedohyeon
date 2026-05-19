# =============================================================================
# 11b_multi_rv_density.R — Triple eligibility margin manipulation test
# Wave 7 Phase 1D. Tests density continuity at all three FHES-observable
# SFFP eligibility thresholds:
#   (1) area_2018           cutoff 5,000     m²     — primary RD running variable
#   (2) area_owned_2018     cutoff 15,500    m²     — req #2
#   (3) off_farm_income_2018 cutoff 45,000,000 KRW  — req #6
# Output: _outputs_eligibility/multi_rv_density.rds + fig_mccrary_multi_rv_en.{pdf,png}
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(ggplot2); library(rddensity); library(gridExtra)
  library(fs); library(here)
})
set.seed(20260504L)

out_dir <- here::here("scripts", "R", "_outputs_eligibility")
df <- readRDS(file.path(out_dir, "clean.rds"))

# Baseline cross-section (2018) for density tests
df18 <- df |> dplyr::filter(year == 2018L)

# Three centered running variables
df18 <- df18 |> dplyr::mutate(
  rv_area     = area_2018 - 5000,                    # m² centered
  rv_owned    = area_owned_2018 - 15500,             # m² centered
  rv_offinc   = off_inc_2018 - 45e6                  # KRW centered
)

run_mccrary <- function(x, name, scale = 1) {
  x <- x[!is.na(x)]
  if (length(x) < 50) return(NULL)
  rd <- tryCatch(rddensity::rddensity(X = x, c = 0, vce = "jackknife"),
                 error = function(e) NULL)
  if (is.null(rd)) return(NULL)
  list(
    name      = name,
    n         = length(x),
    est       = as.numeric(rd$hat$diff),
    t_stat    = as.numeric(rd$test$t_jk),
    p_value   = as.numeric(rd$test$p_jk),
    pass      = abs(as.numeric(rd$test$t_jk)) < 1.96,
    x_scale   = scale
  )
}

results <- list(
  area      = run_mccrary(df18$rv_area,   "area_2018 (cutoff 5,000 m²)",     scale = 1),
  owned     = run_mccrary(df18$rv_owned,  "area_owned_2018 (cutoff 15,500 m²)", scale = 1),
  offinc    = run_mccrary(df18$rv_offinc, "off_farm_income_2018 (cutoff 45M KRW)", scale = 1e6)
)

# Print summary
log_lines <- c(
  paste0("=== 11b_multi_rv_density.R — ", as.character(Sys.time()), " ==="),
  "",
  sprintf("%-45s %8s %10s %10s %8s %8s",
          "Running variable", "N", "t-stat", "p-value", "|t|<1.96", "PASS"),
  strrep("-", 92)
)
for (r in results) {
  if (is.null(r)) next
  log_lines <- c(log_lines, sprintf(
    "%-45s %8d %10.4f %10.4f %8s %8s",
    r$name, r$n, r$t_stat, r$p_value,
    if (abs(r$t_stat) < 1.96) "YES" else "NO",
    if (r$pass) "PASS" else "FAIL"
  ))
}
log_lines <- c(log_lines, "",
  "Interpretation: |t|<1.96 ↔ density-discontinuity null is NOT rejected at α=0.05.",
  "PASS = no evidence of manipulation at the eligibility margin.")
writeLines(log_lines, file.path(out_dir, "multi_rv_density.txt"))
cat(paste(log_lines, collapse = "\n"), "\n")

saveRDS(results, file.path(out_dir, "multi_rv_density.rds"))

# Figure: three-panel density plot with cutoff lines and Q7 raw-x-axis convention
mk_density_panel <- function(x, cutoff, title, x_lab, x_lims = NULL) {
  d <- data.frame(x = x[!is.na(x)])
  p <- ggplot(d, aes(x = x)) +
    geom_histogram(aes(y = ..density..), bins = 40, fill = "grey80", color = "grey50") +
    geom_density(linewidth = 0.8, color = "#012169") +
    geom_vline(xintercept = cutoff, color = "#b91c1c", linetype = "dashed", linewidth = 0.7) +
    labs(title = title, x = x_lab, y = "Density") +
    theme_minimal(base_size = 11) +
    theme(plot.title = element_text(size = 11, face = "bold"))
  if (!is.null(x_lims)) p <- p + coord_cartesian(xlim = x_lims)
  p
}

p1 <- mk_density_panel(
  df18$area_2018, cutoff = 5000,
  title = sprintf("(a) Cultivated area (cutoff 5,000 m²); t=%.2f, p=%.3f",
                  results$area$t_stat, results$area$p_value),
  x_lab = "Baseline cultivated area A_2018 (m²)",
  x_lims = c(0, 10000)
)
p2 <- mk_density_panel(
  df18$area_owned_2018, cutoff = 15500,
  title = sprintf("(b) Owned farmland (cutoff 15,500 m²); t=%.2f, p=%.3f",
                  results$owned$t_stat, results$owned$p_value),
  x_lab = "Baseline owned farmland (m²)",
  x_lims = c(0, 30000)
)
p3 <- mk_density_panel(
  df18$off_inc_2018, cutoff = 45e6,
  title = sprintf("(c) Off-farm income (cutoff 45M KRW); t=%.2f, p=%.3f",
                  results$offinc$t_stat, results$offinc$p_value),
  x_lab = "Baseline household off-farm income (KRW)",
  x_lims = c(0, 90e6)
)

combined <- gridExtra::arrangeGrob(p1, p2, p3, ncol = 1)
# Use base pdf() device to avoid cairo dependency
pdf(file.path(out_dir, "fig_mccrary_multi_rv_en.pdf"), width = 7, height = 9)
grid::grid.draw(combined); dev.off()
ggsave(file.path(out_dir, "fig_mccrary_multi_rv_en.png"),
       combined, width = 7, height = 9, dpi = 300, bg = "transparent")

message("11b_multi_rv_density.R: density tests + figure saved.")
