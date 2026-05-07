#!/usr/bin/env Rscript
# eda.R — Outlier EDA for PIDPS DiD-RD outcome variables
# Sandbox (60/100 threshold) — feeds spec quality_reports/specs/2026-05-07_outlier-policy.md
# Author: Lee, Dohyeon (Claude assist)
# Date: 2026-05-07
#
# 5 variables: y_farm_cost, y_off_income, y_consump, y_farm_income, imputed_payment
# 14 statistics: n, n_missing, n_zero, n_negative, min, p1, p5, p25, median, p75, p95, p99, max, mean, sd
# 2 subsamples: full panel (N=14,474), cutoff-near (abs(rv_2018) <= 1000)
# Hypotheses H1-H4 answered in _outputs/findings.md

suppressPackageStartupMessages({
  library(haven)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(readr)
})

set.seed(20260504)  # r-code-conventions.md global seed

# ----- Paths --------------------------------------------------------------
DATA_PATH <- "master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta"
OUT_DIR   <- "explorations/2026-05-07_outlier-eda/_outputs"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# ----- Load ---------------------------------------------------------------
cat("[1/6] Loading", DATA_PATH, "...\n")
df <- read_dta(DATA_PATH)
cat("    rows =", nrow(df), "  cols =", ncol(df), "\n")

# Invariants (CLAUDE.md identification snapshot)
stopifnot(nrow(df) == 14474)
stopifnot(length(unique(df$hhid_num)) == 3614)
stopifnot(all(sort(unique(df$year)) == 2018:2022))
cat("    invariants OK: N=14,474 / 3,614 farms / 2018-2022\n")

# ----- Variables of interest ----------------------------------------------
VARS <- c("y_farm_cost", "y_off_income", "y_consump", "y_farm_income", "imputed_payment")
stopifnot(all(VARS %in% names(df)))

# ----- Distribution stats helper ------------------------------------------
dist_stats <- function(x) {
  x_num <- as.numeric(x)
  n_total <- length(x_num)
  n_miss  <- sum(is.na(x_num))
  x_obs   <- x_num[!is.na(x_num)]
  if (length(x_obs) == 0) return(rep(NA_real_, 15))
  qs <- stats::quantile(x_obs, probs = c(0.01, 0.05, 0.25, 0.50, 0.75, 0.95, 0.99),
                        names = FALSE, type = 7)
  c(
    n        = n_total,
    n_miss   = n_miss,
    n_zero   = sum(x_obs == 0),
    n_neg    = sum(x_obs < 0),
    min      = min(x_obs),
    p1       = qs[1], p5  = qs[2], p25 = qs[3],
    median   = qs[4],
    p75      = qs[5], p95 = qs[6], p99 = qs[7],
    max      = max(x_obs),
    mean     = mean(x_obs),
    sd       = stats::sd(x_obs)
  )
}

# ----- Compute for full panel + cutoff-near subsample ---------------------
cat("[2/6] Computing distribution stats ...\n")
full_stats   <- sapply(df[VARS], dist_stats)
near_idx     <- abs(df$rv_2018) <= 1000
near_stats   <- sapply(df[near_idx, VARS], dist_stats)
cat("    full N =", sum(!is.na(df$y_farm_cost)),
    " | cutoff-near (|rv|<=1000) N =", sum(near_idx), "\n")

# Long format for CSV
make_long <- function(stat_mat, sample_label) {
  as.data.frame(stat_mat) |>
    tibble::rownames_to_column("stat") |>
    pivot_longer(-stat, names_to = "variable", values_to = "value") |>
    mutate(sample = sample_label) |>
    select(sample, variable, stat, value)
}

stats_long <- bind_rows(
  make_long(full_stats, "full"),
  make_long(near_stats, "cutoff_near_1000")
)

write_csv(stats_long, file.path(OUT_DIR, "distribution_table.csv"))
cat("    wrote distribution_table.csv (", nrow(stats_long), "rows )\n")

# ----- Boxplot (log scale, year facet) ------------------------------------
cat("[3/6] Building boxplot ...\n")
df_long <- df |>
  select(year, all_of(VARS)) |>
  pivot_longer(-year, names_to = "variable", values_to = "value") |>
  filter(!is.na(value))

# Shift-and-log transform for visualisation only (handles 0/neg)
# log(value + 1 + |min|) so all values >= 1
shift_log <- function(x) {
  shift <- if (min(x, na.rm = TRUE) <= 0) abs(min(x, na.rm = TRUE)) + 1 else 0
  log10(x + shift + 1)
}
df_long <- df_long |>
  group_by(variable) |>
  mutate(value_logvis = shift_log(value)) |>
  ungroup()

p_box <- ggplot(df_long, aes(x = factor(year), y = value_logvis, fill = variable)) +
  geom_boxplot(outlier.size = 0.4, outlier.alpha = 0.3) +
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +
  labs(
    title    = "Outcome distribution by year (visualisation log-scale)",
    subtitle = "y-axis: log10(value + shift + 1) for display only; raw values used in stats CSV",
    x        = "year", y = "log10 transform (display)"
  ) +
  theme_minimal(base_size = 10) +
  theme(legend.position = "none",
        plot.title.position = "plot")

ggsave(file.path(OUT_DIR, "boxplot_5vars.png"), p_box,
       width = 10, height = 6, dpi = 150)
cat("    wrote boxplot_5vars.png\n")

# ----- Histogram (raw + log dual) -----------------------------------------
cat("[4/6] Building histogram ...\n")
df_long_hist <- df_long |>
  pivot_longer(c(value, value_logvis), names_to = "scale", values_to = "v") |>
  mutate(scale = recode(scale, value = "raw", value_logvis = "log10"))

p_hist <- ggplot(df_long_hist, aes(x = v, fill = variable)) +
  geom_histogram(bins = 60) +
  facet_grid(rows = vars(variable), cols = vars(scale), scales = "free") +
  labs(
    title = "Outcome histograms (raw vs log10)",
    x = NULL, y = "count"
  ) +
  theme_minimal(base_size = 9) +
  theme(legend.position = "none",
        plot.title.position = "plot",
        strip.text.y = element_text(angle = 0))

ggsave(file.path(OUT_DIR, "hist_5vars.png"), p_hist,
       width = 11, height = 9, dpi = 150)
cat("    wrote hist_5vars.png\n")

# ----- Findings (H1-H4 auto-evaluation) -----------------------------------
cat("[5/6] Evaluating hypotheses ...\n")

# H1: right-skewness  =  (mean > median) for outcomes (not imputed_payment)
skew_check <- tibble(
  variable   = VARS,
  mean       = as.numeric(full_stats["mean", VARS]),
  median     = as.numeric(full_stats["median", VARS]),
  skew_ratio = as.numeric(full_stats["mean", VARS]) /
               pmax(as.numeric(full_stats["median", VARS]), 1)
) |>
  mutate(right_skewed = mean > median)

H1_outcome_skew <- skew_check |>
  filter(variable != "imputed_payment") |>
  pull(right_skewed) |> all()

# H2: imputed_payment bimodality — n_zero (year<=2019) + flat 1.2M cluster
n_imp_zero  <- full_stats["n_zero", "imputed_payment"]
n_imp_flat  <- sum(df$imputed_payment == 1200000, na.rm = TRUE)
n_imp_total <- full_stats["n", "imputed_payment"] - full_stats["n_miss", "imputed_payment"]
H2_bimodal_evidence <- list(
  n_zero       = n_imp_zero,
  n_flat_1.2M  = n_imp_flat,
  n_proportional = n_imp_total - n_imp_zero - n_imp_flat
)

# H3: zero/negative >= 5% in any outcome
zero_neg_pct <- sapply(VARS, function(v) {
  s <- full_stats[, v]
  obs <- s["n"] - s["n_miss"]
  (s["n_zero"] + s["n_neg"]) / obs * 100
})
H3_any_5pct <- any(zero_neg_pct >= 5)
H3_per_var  <- zero_neg_pct

# H4: cutoff-near vs full distribution similarity (median ratio)
H4_median_ratio <- sapply(VARS, function(v) {
  full_stats["median", v] / pmax(near_stats["median", v], 1)
})

findings <- c(
  "# EDA findings — 2026-05-07 Outlier policy spec",
  "",
  paste0("Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
  "",
  "## H1 — Right-skewness in 4 outcomes",
  paste0("Result: **", ifelse(H1_outcome_skew, "TRUE", "FALSE"),
         "** (mean > median for all 4 outcomes)"),
  paste(capture.output(print(skew_check)), collapse = "\n"),
  "",
  "## H2 — imputed_payment bimodality (formula-induced)",
  paste0("- zero values (year ≤ 2019 + missing area_total): ", H2_bimodal_evidence$n_zero),
  paste0("- flat 1,200,000 cluster (SFFP eligibility): ", H2_bimodal_evidence$n_flat_1.2M),
  paste0("- area-proportional cluster: ", H2_bimodal_evidence$n_proportional),
  "",
  "## H3 — Zero/negative ≥ 5% in any outcome",
  paste0("Result: **", ifelse(H3_any_5pct, "TRUE", "FALSE"),
         "** (any variable ≥ 5%)"),
  "Per-variable zero+negative %:",
  paste(capture.output(print(round(H3_per_var, 2))), collapse = "\n"),
  "",
  "## H4 — Cutoff-near subsample distribution similarity",
  "Median ratio (full / cutoff-near, ratio close to 1 = similar):",
  paste(capture.output(print(round(H4_median_ratio, 3))), collapse = "\n"),
  "",
  "## Spec impact",
  paste0("- OQ-4 (Plan): Candidate B (log+1) ",
         ifelse(H3_any_5pct, "SHOULD (zero/neg ≥ 5%)", "MAY (zero/neg < 5%)")),
  "- H1 supports IHS robustness (already in term-paper).",
  "- H2 confirms imputed_payment formula bimodality — outlier handling N/A.",
  "- H4 informs cutoff RD identification stability."
)
writeLines(findings, file.path(OUT_DIR, "findings.md"))
cat("    wrote findings.md\n")

# ----- Summary ------------------------------------------------------------
cat("[6/6] DONE\n")
cat("Outputs in", OUT_DIR, ":\n")
cat("  - distribution_table.csv\n")
cat("  - boxplot_5vars.png\n")
cat("  - hist_5vars.png\n")
cat("  - findings.md\n")
