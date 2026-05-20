# =============================================================================
# 12b_forest_comparison.R — Forest plot: D_treat (Wave 5) vs D_eligible (Wave 7)
# Wave 7 Phase 1D. Combines journal-cell results from both definitions and
# produces (i) side-by-side comparison table; (ii) forest plot figure.
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(ggplot2)
  library(fs); library(here)
})
set.seed(20260504L)

out_orig <- here::here("scripts", "R", "_outputs")
out_elig <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
  here::here("scripts", "R", "_outputs_eligibility")
mr_orig <- readRDS(file.path(out_orig, "main_results.rds"))
mr_elig <- readRDS(file.path(out_elig, "main_results.rds"))

orig <- mr_orig$results |>
  dplyr::filter(design == "journal") |>
  dplyr::select(spec, bw_id, h, outcome,
                n_orig = n_obs, est_orig = estimate,
                se_orig = se_cluster, p_orig = p_cluster)

elig <- mr_elig$results |>
  dplyr::filter(design == "journal") |>
  dplyr::select(spec, bw_id, h, outcome,
                n_elig = n_obs, est_elig = estimate,
                se_elig = se_cluster, p_elig = p_cluster)

cmp <- orig |>
  dplyr::left_join(elig, by = c("spec", "bw_id", "outcome"),
                   suffix = c("_o", "_e")) |>
  dplyr::mutate(
    delta_est   = est_elig - est_orig,
    pct_change  = ifelse(est_orig != 0, 100 * delta_est / abs(est_orig), NA),
    sign_flip   = sign(est_elig) != sign(est_orig) &
                  !is.na(est_elig) & !is.na(est_orig),
    cross_05    = (p_orig < 0.05) != (p_elig < 0.05),
    cross_10    = (p_orig < 0.10) != (p_elig < 0.10),
    ci_lo_orig  = est_orig - 1.96 * se_orig,
    ci_hi_orig  = est_orig + 1.96 * se_orig,
    ci_lo_elig  = est_elig - 1.96 * se_elig,
    ci_hi_elig  = est_elig + 1.96 * se_elig
  )

saveRDS(cmp, file.path(out_elig, "treatment_definition_comparison.rds"))

# --- Comparison table (markdown) ---
fmt_e <- function(x) formatC(x, format = "f", digits = 0, big.mark = ",")
star_p <- function(p) ifelse(is.na(p), "",
                             ifelse(p < 0.01, "***",
                                    ifelse(p < 0.05, "**",
                                           ifelse(p < 0.10, "*", ""))))
md <- c(
  "# Treatment-definition comparison: D_treat (area-only) vs D_eligible (statutory)",
  "",
  "Subset: 14.6% treated-but-ineligible dropped (785 obs / 194 hh).",
  "Bandwidth, specs, covariates, clustering all identical across columns.",
  ""
)

for (sp in c("A", "B")) {
  md <- c(md, sprintf("## Spec %s", sp), "",
    "| BW | Outcome | h | D_treat est (SE) [p] | D_eligible est (SE) [p] | %Δ | Sig change |",
    "|---|---|---:|---:|---:|---:|---|")
  sub <- cmp |> dplyr::filter(spec == sp) |>
                dplyr::arrange(match(bw_id, c("T1","T2","T3")),
                               match(outcome, c("op_cost","off_farm_income","consumption","farm_income")))
  for (i in seq_len(nrow(sub))) {
    r <- sub[i, ]
    sig <- if (isTRUE(r$sign_flip)) "**SIGN FLIP**" else
           if (isTRUE(r$cross_05))  "crosses 0.05"  else
           if (isTRUE(r$cross_10))  "crosses 0.10"  else ""
    md <- c(md, sprintf(
      "| %s | %s | %s | %s%s (%s) [%.3f] | %s%s (%s) [%.3f] | %s%% | %s |",
      r$bw_id, r$outcome, fmt_e(r$h_o %||% r$h_e %||% NA),
      fmt_e(r$est_orig), star_p(r$p_orig), fmt_e(r$se_orig), r$p_orig,
      fmt_e(r$est_elig), star_p(r$p_elig), fmt_e(r$se_elig), r$p_elig,
      if (is.na(r$pct_change)) "NA" else sprintf("%+.1f", r$pct_change),
      sig
    ))
  }
  md <- c(md, "")
}

md <- c(md,
  "## Summary",
  sprintf("- Sign flips: **%d / %d**", sum(cmp$sign_flip, na.rm = TRUE), nrow(cmp)),
  sprintf("- Crossing α=0.05: **%d / %d**", sum(cmp$cross_05, na.rm = TRUE), nrow(cmp)),
  sprintf("- Crossing α=0.10: **%d / %d**", sum(cmp$cross_10, na.rm = TRUE), nrow(cmp)),
  sprintf("- Median |%%Δ|: **%.1f%%**", stats::median(abs(cmp$pct_change), na.rm = TRUE)),
  sprintf("- Max |%%Δ|: **%.1f%%**", max(abs(cmp$pct_change), na.rm = TRUE)),
  ""
)
writeLines(md, file.path(out_elig, "treatment_definition_comparison.md"))

# --- Forest plot ---
fp <- cmp |>
  dplyr::select(spec, bw_id, outcome,
                est_orig, ci_lo_orig, ci_hi_orig,
                est_elig, ci_lo_elig, ci_hi_elig) |>
  tidyr::pivot_longer(
    cols = -c(spec, bw_id, outcome),
    names_to = c(".value", "definition"),
    names_pattern = "(est|ci_lo|ci_hi)_(.+)"
  ) |>
  dplyr::mutate(
    definition = factor(definition,
                        levels = c("orig", "elig"),
                        labels = c("D_treat (area-only)", "D_eligible (statutory)")),
    cell = sprintf("%s/%s/%s", spec, bw_id, outcome),
    cell = factor(cell, levels = rev(unique(cell)))
  )

p <- ggplot(fp, aes(x = est, y = cell, color = definition)) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "gray60") +
  geom_errorbarh(aes(xmin = ci_lo, xmax = ci_hi),
                 height = 0.3, position = position_dodge(width = 0.5)) +
  geom_point(position = position_dodge(width = 0.5), size = 2) +
  scale_color_manual(values = c("D_treat (area-only)" = "#012169",
                                "D_eligible (statutory)" = "#b91c1c")) +
  labs(x = "Coefficient (with 95% CI)", y = NULL, color = NULL,
       title = "DiD-RD: D_treat vs D_eligible (24 journal cells)",
       subtitle = "Spec/Bandwidth/Outcome cells; bandwidths held fixed for comparison") +
  theme_minimal(base_size = 9) +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold"))

pdf(file.path(out_elig, "fig_forest_treatment_definitions_en.pdf"),
    width = 8, height = 10)
print(p); dev.off()
ggsave(file.path(out_elig, "fig_forest_treatment_definitions_en.png"),
       p, width = 8, height = 10, dpi = 300, bg = "transparent")

message("12b_forest_comparison.R: comparison + forest plot saved.")
message(sprintf("  Sign flips: %d / %d | Crossing 0.05: %d | 0.10: %d | Median |%%Δ| = %.1f%%",
                sum(cmp$sign_flip, na.rm = TRUE), nrow(cmp),
                sum(cmp$cross_05, na.rm = TRUE),
                sum(cmp$cross_10, na.rm = TRUE),
                stats::median(abs(cmp$pct_change), na.rm = TRUE)))

# Small infix helper if not loaded
`%||%` <- function(a, b) if (!is.null(a) && !is.na(a)) a else b
