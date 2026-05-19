# =============================================================================
# 03b_did_rd_eligibility.R — DiD-RD re-estimation with D_eligible_obs_2018
#
# Option B (per 2026-05-19 session): re-estimate the journal cells of 03_did_rd.R
# using D_eligible_obs_2018 (요건 1+2+6) as the treatment indicator, on the
# subset that drops treated-but-ineligible households (785 obs / 194 hh).
# This restores sharpness at the area cutoff within the subset, isolating the
# treatment-definition change from sample / bandwidth changes.
#
# Inputs:
#   _outputs/clean_with_eligibility.rds (from 01b_eligibility.R)
#   _outputs/main_results.rds           (from 03_did_rd.R — for side-by-side)
#
# Outputs:
#   _outputs/main_results_eligibility.rds   — list(specs, results, sample_info)
#   _outputs/eligibility_estimation_compare.{txt,md}
#
# Comparison axis: Same bandwidths (T1=500, T2=1000, T3=h_mse from 03_did_rd.R)
# and same specs (A: 2018-2022, B: drop 2020). Only the treatment indicator
# and sample (drop treated-but-ineligible) change.
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(fixest)
  library(fs)
  library(here)
})
set.seed(20260504L)

# ---------------------------------------------------------------------------- #
# Phase 0 — Load
# ---------------------------------------------------------------------------- #

out_dir <- here::here("scripts", "R", "_outputs")
df_path <- file.path(out_dir, "clean_with_eligibility.rds")
mr_path <- file.path(out_dir, "main_results.rds")
stopifnot(fs::file_exists(df_path), fs::file_exists(mr_path))

df_full <- readRDS(df_path) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))
main_results <- readRDS(mr_path)

stopifnot(nrow(df_full) == 14474L,
          "D_eligible_obs_2018" %in% names(df_full))

outcomes <- c("op_cost", "off_farm_income", "consumption", "farm_income")

# ---------------------------------------------------------------------------- #
# Phase 1 — Subset (drop treated-but-ineligible) + build new interactions
# ---------------------------------------------------------------------------- #
# Subset: keep observations where the new treatment status is unambiguous —
#   (a) D_eligible_obs_2018 == TRUE  (treated under new definition)
#   (b) D_treat == FALSE             (control, untouched)
# Drop: D_treat==TRUE & D_eligible_obs_2018==FALSE (194 hh, ~785 obs — failed
# requirement #2 or #6 despite passing the area cutoff). Within this subset
# the new treatment is sharp at rv_2018 = 0.

df <- df_full |>
  dplyr::filter(D_eligible_obs_2018 == TRUE | D_treat == FALSE) |>
  dplyr::mutate(
    D_elig         = as.integer(D_eligible_obs_2018 & !is.na(D_eligible_obs_2018)),
    D_elig_Post    = D_elig * Post,
    Drv_Post_elig  = D_elig * rv_2018 * Post
  )

# Sample-size waterfall
n_obs_full <- nrow(df_full)
n_obs_sub  <- nrow(df)
n_hh_full  <- dplyr::n_distinct(df_full$hh_id)
n_hh_sub   <- dplyr::n_distinct(df$hh_id)
n_drop_obs <- n_obs_full - n_obs_sub
n_drop_hh  <- n_hh_full  - n_hh_sub

# Verify subset has sharp cutoff (within subset, D_elig == (rv_2018 <= 0))
sub_sharp <- with(df, all(D_elig == as.integer(rv_2018 <= 0)))
stopifnot(sub_sharp)

# ---------------------------------------------------------------------------- #
# Phase 2 — Re-use bandwidths from 03_did_rd.R for apples-to-apples comparison
# ---------------------------------------------------------------------------- #

orig_specs <- main_results$specs |>
  dplyr::filter(design == "journal") |>
  dplyr::select(spec, bw_id, h, outcome)

stopifnot(nrow(orig_specs) == 24L)   # 2 specs × 3 bws × 4 outcomes

# ---------------------------------------------------------------------------- #
# Phase 3 — Fit (mirrors fit_one in 03_did_rd.R, with D_elig instead of D_treat)
# ---------------------------------------------------------------------------- #

fit_one_elig <- function(spec_row, df_master) {
  if (spec_row$spec == "A") {
    sub <- df_master |> dplyr::filter(abs(rv_2018) <= spec_row$h)
    f <- as.formula(sprintf(
      "%s ~ D_elig_Post + rv_Post + Drv_Post_elig | hh_id + year",
      spec_row$outcome
    ))
    DP <- "D_elig_Post"
  } else {
    sub <- df_master |>
      dplyr::filter(year != 2020L, abs(rv_2018) <= spec_row$h) |>
      dplyr::mutate(
        Post_B          = as.integer(year >= 2021L),
        D_elig_Post_B   = D_elig * Post_B,
        rv_Post_B       = rv_2018 * Post_B,
        Drv_Post_B_elig = D_elig * rv_2018 * Post_B
      )
    f <- as.formula(sprintf(
      "%s ~ D_elig_Post_B + rv_Post_B + Drv_Post_B_elig | hh_id + year",
      spec_row$outcome
    ))
    DP <- "D_elig_Post_B"
  }

  if (nrow(sub) < 20L) {
    return(list(fit = NULL, sub_n = nrow(sub),
                est = NA_real_, se_cluster = NA_real_, p_cluster = NA_real_))
  }

  fit <- fixest::feols(f, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  est <- as.numeric(stats::coef(fit)[DP])
  se  <- as.numeric(sqrt(diag(stats::vcov(fit))[DP]))
  p   <- 2 * (1 - stats::pt(abs(est / se),
                            df = dplyr::n_distinct(sub$hh_id) - 1L))
  list(fit = fit, sub_n = nrow(sub), est = est,
       se_cluster = se, p_cluster = p)
}

message(sprintf("Phase 3: fitting %d journal cells on subset (n_obs=%d, n_hh=%d)...",
                nrow(orig_specs), n_obs_sub, n_hh_sub))

t0 <- Sys.time()
fit_results <- purrr::pmap(orig_specs, function(...) {
  fit_one_elig(tibble::tibble(...), df)
})
elapsed <- as.numeric(Sys.time() - t0, units = "secs")
message(sprintf("Phase 3: completed in %.1fs.", elapsed))

results_elig <- orig_specs |>
  dplyr::mutate(
    n_obs      = vapply(fit_results, function(r) r$sub_n,      integer(1)),
    estimate   = vapply(fit_results, function(r) r$est,        numeric(1)),
    se_cluster = vapply(fit_results, function(r) r$se_cluster, numeric(1)),
    p_cluster  = vapply(fit_results, function(r) r$p_cluster,  numeric(1))
  ) |>
  dplyr::group_by(spec, bw_id) |>
  dplyr::mutate(p_cluster_holm = stats::p.adjust(p_cluster, method = "holm")) |>
  dplyr::ungroup()

# ---------------------------------------------------------------------------- #
# Phase 4 — Side-by-side comparison vs 03_did_rd.R original (D_treat)
# ---------------------------------------------------------------------------- #

orig_results <- main_results$results |>
  dplyr::filter(design == "journal") |>
  dplyr::select(spec, bw_id, outcome,
                n_obs_orig   = n_obs,
                est_orig     = estimate,
                se_orig      = se_cluster,
                p_orig       = p_cluster,
                p_orig_holm  = p_cluster_holm)

cmp <- results_elig |>
  dplyr::select(spec, bw_id, outcome, h,
                n_obs_new   = n_obs,
                est_new     = estimate,
                se_new      = se_cluster,
                p_new       = p_cluster,
                p_new_holm  = p_cluster_holm) |>
  dplyr::left_join(orig_results, by = c("spec", "bw_id", "outcome")) |>
  dplyr::mutate(
    delta_est  = est_new - est_orig,
    pct_change = ifelse(est_orig != 0,
                        100 * (est_new - est_orig) / abs(est_orig),
                        NA_real_),
    sign_flip  = sign(est_new) != sign(est_orig) & !is.na(est_new) & !is.na(est_orig),
    crosses_sig_10 = (p_orig < 0.10) != (p_new < 0.10),
    crosses_sig_05 = (p_orig < 0.05) != (p_new < 0.05)
  )

# ---------------------------------------------------------------------------- #
# Phase 5 — Save outputs
# ---------------------------------------------------------------------------- #

saveRDS(
  list(
    specs       = orig_specs,
    results     = results_elig,
    sample_info = list(
      n_obs_full = n_obs_full, n_obs_sub = n_obs_sub,
      n_hh_full  = n_hh_full,  n_hh_sub  = n_hh_sub,
      n_drop_obs = n_drop_obs, n_drop_hh = n_drop_hh,
      cutoff_sharp = sub_sharp
    ),
    comparison  = cmp,
    notes       = paste(
      "Option B: Sample subset (drop treated-but-ineligible) + D_eligible_obs_2018",
      "as treatment. Bandwidths held fixed at 03_did_rd.R values (T1=500, T2=1000,",
      "T3=h_mse per outcome from 03_did_rd.R) to isolate the definition change.",
      "Inference: cluster-robust SE (hh_id), matches 03_did_rd.R."
    )
  ),
  file.path(out_dir, "main_results_eligibility.rds")
)

# --- Plain-text comparison log ---
fmt_n <- function(x) formatC(x, format = "d", big.mark = ",")
fmt_e <- function(x) formatC(x, format = "f", digits = 0, big.mark = ",")
star_p <- function(p) {
  ifelse(is.na(p), "",
         ifelse(p < 0.01, "***",
                ifelse(p < 0.05, "**",
                       ifelse(p < 0.10, "*", ""))))
}

log_lines <- c(
  paste0("=== 03b_did_rd_eligibility.R log -- ", as.character(Sys.time()), " ==="),
  "",
  "Sample subset (Option B):",
  sprintf("  Full panel:   %s obs / %s hh", fmt_n(n_obs_full), fmt_n(n_hh_full)),
  sprintf("  Eligibility subset: %s obs / %s hh  (drop %s obs / %s hh treated-but-ineligible)",
          fmt_n(n_obs_sub), fmt_n(n_hh_sub), fmt_n(n_drop_obs), fmt_n(n_drop_hh)),
  sprintf("  Sharp cutoff on subset (D_elig == 1[rv_2018<=0]): %s",
          if (sub_sharp) "TRUE" else "FALSE — investigate"),
  "",
  "Treatment definition:",
  "  Original (03_did_rd.R): D_treat = (area_2018 <= 5000)   — req #1 only",
  "  New     (this script):  D_eligible_obs_2018 = D_treat & (area_owned_total_2018 < 15,500) & (off_farm_income_2018 < 45,000,000)",
  "",
  "Bandwidths: held fixed at 03_did_rd.R values for apples-to-apples comparison.",
  "",
  paste(rep("=", 100), collapse = ""),
  "Side-by-side: original D_treat vs new D_eligible_obs_2018 (cluster-robust SE)",
  paste(rep("=", 100), collapse = ""),
  ""
)

for (sp in c("A", "B")) {
  log_lines <- c(log_lines,
    sprintf(">>> Spec %s (%s)",
            sp,
            if (sp == "A") "2018-2022, Post=year>=2020" else "drop 2020, Post=year>=2021"),
    "")
  for (bw in c("T1", "T2", "T3")) {
    h_val <- cmp |> dplyr::filter(spec == sp, bw_id == bw) |>
                    dplyr::pull(h) |> unique()
    h_str <- if (length(h_val) == 1) sprintf("h=%s", fmt_e(h_val)) else
             sprintf("h=%s..%s", fmt_e(min(h_val)), fmt_e(max(h_val)))
    log_lines <- c(log_lines,
      sprintf("  %s (%s):", bw, h_str),
      sprintf("    %-16s %22s %22s %12s %10s %s",
              "outcome", "original (D_treat)", "new (D_eligible)",
              "Δ", "%Δ", "sig change?"),
      sprintf("    %s", strrep("-", 100)))
    sub <- cmp |> dplyr::filter(spec == sp, bw_id == bw) |>
                  dplyr::arrange(match(outcome, outcomes))
    for (i in seq_len(nrow(sub))) {
      r <- sub[i, ]
      sig_change <- if (isTRUE(r$sign_flip)) "SIGN FLIP" else
                    if (isTRUE(r$crosses_sig_05)) "crosses 0.05" else
                    if (isTRUE(r$crosses_sig_10)) "crosses 0.10" else ""
      log_lines <- c(log_lines, sprintf(
        "    %-16s   %12s%-3s (%10s)   %12s%-3s (%10s) %12s %9s%% %s",
        r$outcome,
        fmt_e(r$est_orig), star_p(r$p_orig), fmt_e(r$se_orig),
        fmt_e(r$est_new),  star_p(r$p_new),  fmt_e(r$se_new),
        fmt_e(r$delta_est),
        if (is.na(r$pct_change)) "NA" else sprintf("%+.1f", r$pct_change),
        sig_change
      ))
    }
    log_lines <- c(log_lines, "")
  }
}

log_lines <- c(log_lines,
  "Stars: * p<0.10 ** p<0.05 *** p<0.01 (cluster-robust, unadjusted).",
  "Signature comparison uses unadjusted p-values; Holm step-down stored in RDS.",
  ""
)
writeLines(log_lines, file.path(out_dir, "eligibility_estimation_compare.txt"),
           useBytes = FALSE)

# --- Markdown comparison table ---
md_lines <- c(
  "# Estimation comparison: D_treat vs D_eligible_obs_2018",
  "",
  sprintf("_Generated by `scripts/R/03b_did_rd_eligibility.R` on %s._",
          format(Sys.Date(), "%Y-%m-%d")),
  "",
  sprintf("**Subset:** drop treated-but-ineligible (n=%s hh, %s obs); resulting sample: %s hh / %s obs.",
          fmt_n(n_drop_hh), fmt_n(n_drop_obs), fmt_n(n_hh_sub), fmt_n(n_obs_sub)),
  "",
  "**Bandwidths held fixed** at 03_did_rd.R values for definition-change isolation.",
  ""
)

for (sp in c("A", "B")) {
  spec_lbl <- if (sp == "A") "Spec A (2018-2022, Post=year>=2020)" else
              "Spec B (drop 2020, Post=year>=2021)"
  md_lines <- c(md_lines,
    sprintf("## %s", spec_lbl),
    "",
    "| BW | Outcome | h (m²) | Original est. (SE) [p] | New est. (SE) [p] | Δ | %Δ | Sig change |",
    "|---|---|---:|---:|---:|---:|---:|---|"
  )
  sub <- cmp |> dplyr::filter(spec == sp) |>
                dplyr::arrange(match(bw_id, c("T1", "T2", "T3")),
                               match(outcome, outcomes))
  for (i in seq_len(nrow(sub))) {
    r <- sub[i, ]
    sig_change <- if (isTRUE(r$sign_flip)) "**SIGN FLIP**" else
                  if (isTRUE(r$crosses_sig_05)) "crosses 0.05" else
                  if (isTRUE(r$crosses_sig_10)) "crosses 0.10" else ""
    md_lines <- c(md_lines, sprintf(
      "| %s | %s | %s | %s%s (%s) [%.3f] | %s%s (%s) [%.3f] | %s | %s%% | %s |",
      r$bw_id, r$outcome,
      if (r$bw_id == "T3") sprintf("%s (T3)", fmt_e(r$h)) else fmt_e(r$h),
      fmt_e(r$est_orig), star_p(r$p_orig), fmt_e(r$se_orig), r$p_orig,
      fmt_e(r$est_new),  star_p(r$p_new),  fmt_e(r$se_new),  r$p_new,
      fmt_e(r$delta_est),
      if (is.na(r$pct_change)) "NA" else sprintf("%+.1f", r$pct_change),
      sig_change
    ))
  }
  md_lines <- c(md_lines, "")
}

md_lines <- c(md_lines,
  "## Summary of differences",
  "",
  sprintf("- Cells with sign flip:        **%d / %d**",
          sum(cmp$sign_flip, na.rm = TRUE), nrow(cmp)),
  sprintf("- Cells crossing α=0.05:       **%d / %d**",
          sum(cmp$crosses_sig_05, na.rm = TRUE), nrow(cmp)),
  sprintf("- Cells crossing α=0.10:       **%d / %d**",
          sum(cmp$crosses_sig_10, na.rm = TRUE), nrow(cmp)),
  sprintf("- Median |%%Δ| in coefficient:   **%.1f%%**",
          stats::median(abs(cmp$pct_change), na.rm = TRUE)),
  sprintf("- Max  |%%Δ| in coefficient:   **%.1f%%**",
          max(abs(cmp$pct_change), na.rm = TRUE)),
  "",
  "Stars: `*` p<0.10  `**` p<0.05  `***` p<0.01 (cluster-robust SE, hh_id).",
  ""
)
writeLines(md_lines, file.path(out_dir, "eligibility_estimation_compare.md"),
           useBytes = FALSE)

# Final stdout signal
message(sprintf(
  "03b: %d cells fit; %d sign flips, %d crosses α=0.05, %d crosses α=0.10 (vs D_treat).",
  nrow(cmp),
  sum(cmp$sign_flip, na.rm = TRUE),
  sum(cmp$crosses_sig_05, na.rm = TRUE),
  sum(cmp$crosses_sig_10, na.rm = TRUE)
))
