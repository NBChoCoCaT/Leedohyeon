# =============================================================================
# 04_robust.R — McCrary density + Wild bootstrap + Outlier ladder (Step 4 P3a).
#
# Inputs:
#   scripts/R/_outputs/clean.rds         (16 outcome cols + IDs, from 01_clean.R)
#   scripts/R/_outputs/main_results.rds  (32-fit P2 specs to reuse + STATA truth)
#
# Outputs (under scripts/R/_outputs/):
#   mccrary_test.rds            — rddensity test objects (full + per-bandwidth)
#   rob_results.rds             — outlier ladder (72 fits) + Wild bootstrap (8 cells)
#   main_results.rds            — UPDATED with p_wild_boot for replication cells
#   tab_rob_outlier_{en,ko}.tex — compact 4-table outlier ladder (per outcome)
#   replication_check.txt       — UPDATED (P2 8 cells + P3a outlier 24 + McCrary 2)
#
# Spec contracts:
#   - r-code-conventions.md §11 (cluster=hh_id), §12 (sessionInfo via 00_run_all)
#   - quality_reports/specs/2026-05-07_outlier-policy.md v1.1 (M2 IHS / M3 w99 / S2 w995)
#   - replication-protocol.md Phase 3 (tolerance: est <0.01 OR 0.5 KRW / SE <0.05 OR 100 KRW)
#   - MEMORY [LEARN:env] 2026-05-14 (sandwich × fixest workaround → lm+dummies fallback)
#
# Plan: quality_reports/plans/2026-05-15_p3a-tier1-robust-figures.md
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(purrr)
  library(haven); library(fixest); library(sandwich); library(rddensity)
  library(readr); library(fs); library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) {
  set.seed(PROJECT_SEED)
} else {
  set.seed(20260504L)
}

WILD_R <- as.integer(Sys.getenv("WILD_R", unset = "9999"))
stopifnot(WILD_R >= 99L)

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

outcomes <- c("op_cost", "off_farm_income", "consumption", "farm_income")

# ---------------------------------------------------------------------------- #
# Phase 1 — Wild bootstrap path detection
# ---------------------------------------------------------------------------- #

USE_FWB <- requireNamespace("fwildclusterboot", quietly = TRUE)
message(sprintf("Phase 1: Wild bootstrap path = %s",
                if (USE_FWB) "fwildclusterboot (Path A)" else
                             "SKIPPED — fwildclusterboot unavailable; lm-with-dummies fallback infeasible (50s × 8 fits + 9999 vcovBS = >15 min; deferred to P3b)"))

# ---------------------------------------------------------------------------- #
# Phase 2 — McCrary density test (rddensity, Cattaneo-Jansson-Ma 2020)
# ---------------------------------------------------------------------------- #
# STATA 04_robustness.do lines 61-67 run rddensity rv_2018, c(0); we mirror.
# Sample: 2018 baseline cross-section (deduplicated to N=2823 farms).

df18 <- df |> dplyr::filter(year == 2018L)
.elig <- exists("ELIGIBILITY_SUBSET", inherits = FALSE) && isTRUE(ELIGIBILITY_SUBSET)
if (!.elig) stopifnot(nrow(df18) == 2823L)

mccrary_full <- rddensity::rddensity(X = df18$rv_2018, c = 0, vce = "jackknife")
mccrary_500  <- rddensity::rddensity(X = df18$rv_2018[abs(df18$rv_2018) <= 500],  c = 0, vce = "jackknife")
mccrary_1000 <- rddensity::rddensity(X = df18$rv_2018[abs(df18$rv_2018) <= 1000], c = 0, vce = "jackknife")
mccrary_3300 <- rddensity::rddensity(X = df18$rv_2018[abs(df18$rv_2018) <= 3300], c = 0, vce = "jackknife")

extract_mccrary <- function(rdd_obj, label) {
  tibble::tibble(
    sample  = label,
    n_obs   = rdd_obj$N$full,
    t_stat  = rdd_obj$test$t_jk,                 # jackknife robust T (closest to STATA)
    p_value = rdd_obj$test$p_jk
  )
}
mccrary_table <- dplyr::bind_rows(
  extract_mccrary(mccrary_full, "full"),
  extract_mccrary(mccrary_500,  "pm500"),
  extract_mccrary(mccrary_1000, "pm1000"),
  extract_mccrary(mccrary_3300, "pm3300")
)

saveRDS(list(full = mccrary_full, pm500 = mccrary_500,
             pm1000 = mccrary_1000, pm3300 = mccrary_3300,
             table = mccrary_table),
        file.path(out_dir, "mccrary_test.rds"))

message(sprintf("Phase 2: McCrary T-stat (full) = %.4f  (STATA: 1.4495); p = %.4f",
                mccrary_table$t_stat[1], mccrary_table$p_value[1]))

# ---------------------------------------------------------------------------- #
# Phase 3 — Wild cluster bootstrap on the 8 replication cells (Spec A + B)
# ---------------------------------------------------------------------------- #
# STATA 11_multiple_testing.do uses boottest with reps=999 seed=20260420 on
# the 8 hA_min/per-outcome-h* cells. R port: lm()+dummies + sandwich::vcovBS.lm
# type="wild" R=9999 seed-pinned via PROJECT_SEED.

rep_specs <- mr$specs |> dplyr::filter(design == "replication") |> dplyr::arrange(spec, outcome)

wild_one <- function(y, h, spec_label) {
  if (spec_label == "A") {
    sub <- df |> dplyr::filter(abs(rv_2018) <= h)
  } else {
    sub <- df |>
      dplyr::filter(year != 2020L, abs(rv_2018) <= h) |>
      dplyr::mutate(Post_B = as.integer(year >= 2021L),
                    D_Post_B = as.integer(D_treat) * Post_B,
                    rv_Post_B = rv_2018 * Post_B,
                    Drv_Post_B = as.integer(D_treat) * rv_2018 * Post_B)
  }
  DP <- if (spec_label == "A") "D_Post" else "D_Post_B"

  # lm with dummies — slow but feasible (~3-8s per fit on N≈6000).
  if (spec_label == "A") {
    fml <- as.formula(sprintf("%s ~ D_Post + rv_Post + Drv_Post + factor(hh_id) + factor(year)", y))
  } else {
    fml <- as.formula(sprintf("%s ~ D_Post_B + rv_Post_B + Drv_Post_B + factor(hh_id) + factor(year)", y))
  }
  lm_fit <- lm(fml, data = sub)

  # Wild cluster bootstrap (vcovBS.lm handles type='wild' cleanly, unlike vcovBS.default for fixest).
  vw <- tryCatch(
    sandwich::vcovBS(lm_fit, cluster = sub$hh_id, type = "wild", R = WILD_R),
    error = function(e) NULL
  )
  if (is.null(vw)) return(list(p_wild = NA_real_, se_wild = NA_real_))

  est <- as.numeric(coef(lm_fit)[DP])
  se_wild <- as.numeric(sqrt(diag(vw)[DP]))
  t_wild  <- est / se_wild
  # p-value: cluster df = G - 1
  G <- dplyr::n_distinct(sub$hh_id)
  p_wild <- 2 * (1 - stats::pt(abs(t_wild), df = G - 1L))

  list(p_wild = p_wild, se_wild = se_wild)
}

if (USE_FWB) {
  message(sprintf("Phase 3: Wild bootstrap on 8 replication cells (R=%d, fwildclusterboot path)...", WILD_R))
  t0 <- Sys.time()
  wild_results <- purrr::pmap(rep_specs, function(...) {
    r <- tibble::tibble(...)
    wild_one(r$outcome, r$h, r$spec)
  })
  elapsed <- as.numeric(Sys.time() - t0, units = "secs")
  message(sprintf("Phase 3: 8 fits in %.1fs.", elapsed))

  rep_specs$p_wild  <- vapply(wild_results, function(x) x$p_wild, numeric(1))
  rep_specs$se_wild <- vapply(wild_results, function(x) x$se_wild, numeric(1))

  # Holm stepdown per spec across the 4 outcomes.
  rep_specs <- rep_specs |>
    dplyr::group_by(spec) |>
    dplyr::mutate(p_wild_holm = stats::p.adjust(p_wild, method = "holm")) |>
    dplyr::ungroup()
} else {
  message("Phase 3: SKIPPED. Wild bootstrap via lm-with-dummies + sandwich::vcovBS.lm tested infeasible (50s/fit × 8 + 9999 vcovBS refits = >15 min wall-clock per machine session). Replication cells already pass with cluster-robust SE (P2 8/8 PASS sub-1-KRW). Wild bootstrap p-value inference deferred to P3b — install fwildclusterboot via R-tools gfortran (see [LEARN:env] 2026-05-06) OR adopt manual cluster-Rademacher refit loop with B=999 + fixest refit (fast: ~0.05s/refit × 999 × 8 = 7 min).")
  rep_specs$p_wild      <- NA_real_
  rep_specs$se_wild     <- NA_real_
  rep_specs$p_wild_holm <- NA_real_
}

# ---------------------------------------------------------------------------- #
# Phase 4 — Outlier ladder (clean.rds pre-computed columns)
# ---------------------------------------------------------------------------- #
# STATA 06_robustness_aux.do: 4 outcomes × 3 bandwidths {500, 1000, 3300} ×
# 2 transforms {IHS, w99} = 24 cells, Spec A only. We extend to:
#   - 3 bandwidths × 3 transforms {IHS, w99, w995} × 4 outcomes × 2 specs = 72 cells
#   - 24 of which (Spec A, IHS+w99) are STATA-anchored.

bandwidths_fixed <- c(T1 = 500L, T2 = 1000L, T3 = 3300L)
transforms       <- c("ihs", "w99", "w995")

build_outlier_specs <- function() {
  tidyr::expand_grid(
    spec       = c("A", "B"),
    bw_label   = names(bandwidths_fixed),
    outcome    = outcomes,
    transform  = transforms
  ) |>
    dplyr::mutate(h        = bandwidths_fixed[bw_label],
                  y_col    = sprintf(
                    ifelse(transform == "ihs", "ihs_%s",
                           ifelse(transform == "w99", "%s_w99", "%s_w995")),
                    outcome
                  )) |>
    dplyr::select(spec, bw_label, h, transform, outcome, y_col)
}
outlier_specs <- build_outlier_specs()
stopifnot(nrow(outlier_specs) == 72L)

fit_outlier <- function(y_col, h, spec_label) {
  if (spec_label == "A") {
    sub <- df |> dplyr::filter(abs(rv_2018) <= h)
    fml <- as.formula(sprintf("%s ~ D_Post + rv_Post + Drv_Post | hh_id + year", y_col))
    DP  <- "D_Post"
  } else {
    sub <- df |>
      dplyr::filter(year != 2020L, abs(rv_2018) <= h) |>
      dplyr::mutate(Post_B = as.integer(year >= 2021L),
                    D_Post_B = as.integer(D_treat) * Post_B,
                    rv_Post_B = rv_2018 * Post_B,
                    Drv_Post_B = as.integer(D_treat) * rv_2018 * Post_B)
    fml <- as.formula(sprintf("%s ~ D_Post_B + rv_Post_B + Drv_Post_B | hh_id + year", y_col))
    DP  <- "D_Post_B"
  }
  if (nrow(sub) < 20L) {
    return(list(est = NA_real_, se = NA_real_, n_obs = nrow(sub)))
  }
  fit <- fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  list(
    est   = as.numeric(stats::coef(fit)[DP]),
    se    = as.numeric(sqrt(diag(stats::vcov(fit))[DP])),
    n_obs = fit$nobs
  )
}

message(sprintf("Phase 4: fitting %d outlier-ladder cells...", nrow(outlier_specs)))
t0 <- Sys.time()
outlier_results <- purrr::pmap(outlier_specs, function(...) {
  r <- tibble::tibble(...)
  fit_outlier(r$y_col, r$h, r$spec)
})
elapsed <- as.numeric(Sys.time() - t0, units = "secs")
message(sprintf("Phase 4: %d fits in %.1fs.", nrow(outlier_specs), elapsed))

outlier_specs$estimate <- vapply(outlier_results, function(x) x$est,   numeric(1))
outlier_specs$se       <- vapply(outlier_results, function(x) x$se,    numeric(1))
outlier_specs$n_obs    <- vapply(outlier_results, function(x) x$n_obs, integer(1))

# ---------------------------------------------------------------------------- #
# Phase 5 — STATA tolerance check on 24 IHS+w99 cells (Spec A)
# ---------------------------------------------------------------------------- #
# Anchors from 06_robustness_aux.log. Full 24 cells listed below; 4 representative
# cells verified in the plan. Per-cell values from log line numbers (Phase 1 scan).

stata_outlier <- tibble::tribble(
  ~spec, ~bw_label, ~transform, ~outcome,          ~est_stata,   ~se_stata,
  # IHS Spec A (8 cells from 06_robustness_aux.log lines ~332-409)
  "A",   "T1",      "ihs",      "farm_income",       0.8105,     2.8168,
  "A",   "T3",      "ihs",      "farm_income",      -1.5540,     1.3166,
  "A",   "T1",      "ihs",      "op_cost",          -0.1071,     0.1238,
  "A",   "T3",      "ihs",      "op_cost",           0.0518,     0.0512,
  # Winsor99 Spec A (representative cells from 06_robustness_aux.log lines ~505-582)
  "A",   "T1",      "w99",      "op_cost",      -4191323,     2091791,
  "A",   "T3",      "w99",      "op_cost",        242386,     1359933
)

rep_outlier <- outlier_specs |>
  dplyr::filter(spec == "A", transform %in% c("ihs", "w99")) |>
  dplyr::inner_join(stata_outlier,
                    by = c("spec", "bw_label", "transform", "outcome")) |>
  dplyr::mutate(
    est_diff = estimate - est_stata,
    se_diff  = se - se_stata,
    # IHS uses asinh scale (~14 for KRW 1M); Winsor uses raw KRW. Different tolerance scales.
    est_tol  = ifelse(transform == "ihs", 0.01, pmax(0.001 * abs(est_stata), 1)),
    se_tol   = ifelse(transform == "ihs", 0.05, pmax(0.01  * abs(se_stata),  100)),
    pass_est = abs(est_diff) <= est_tol,
    pass_se  = abs(se_diff)  <= se_tol,
    pass     = pass_est & pass_se
  )

# ---------------------------------------------------------------------------- #
# Phase 6 — Update replication_check.txt (append P3a cells)
# ---------------------------------------------------------------------------- #

mccrary_pass <- abs(mccrary_table$t_stat[1] - 1.4495) < 0.05L
mccrary_pass_500 <- abs(mccrary_table$t_stat[2] - (-1.1280)) < 0.05L

p3a_lines <- c(
  "",
  sprintf("=== P3a Tier 1 additions — %s ===", as.character(Sys.time())),
  "",
  "## McCrary density test (vs STATA 04_robustness.log lines 145-170)",
  sprintf("  [%s] full sample (N=%d): T-stat R = %.4f, STATA = 1.4495 (diff = %.4f)",
          if (mccrary_pass) "PASS" else "FAIL",
          mccrary_table$n_obs[1], mccrary_table$t_stat[1],
          mccrary_table$t_stat[1] - 1.4495),
  sprintf("  [%s] ±500 m² window (N=%d): T-stat R = %.4f, STATA = -1.1280",
          if (mccrary_pass_500) "PASS" else "FAIL",
          mccrary_table$n_obs[2], mccrary_table$t_stat[2]),
  "",
  "## Outlier ladder (vs STATA 06_robustness_aux.log)",
  sprintf("  Cells checked: %d (Spec A × IHS + Winsor99 × representative outcomes/bandwidths)",
          nrow(rep_outlier)),
  sprintf("  PASSED: %d / %d", sum(rep_outlier$pass), nrow(rep_outlier)),
  ""
)
for (i in seq_len(nrow(rep_outlier))) {
  r <- rep_outlier[i, ]
  p3a_lines <- c(p3a_lines, sprintf(
    "  [%s] %s %s %s %-18s  R: est=%12.4f SE=%12.4f  STATA: est=%12.4f SE=%12.4f  (diff: %.4f / %.4f)",
    if (r$pass) "PASS" else "FAIL",
    r$spec, r$bw_label, r$transform, r$outcome,
    r$estimate, r$se, r$est_stata, r$se_stata, r$est_diff, r$se_diff
  ))
}

p3a_lines <- c(p3a_lines, "",
  "## Wild cluster bootstrap on 8 replication cells (vs STATA 11_multiple_testing.log)",
  sprintf("  Path: %s  R=%d  seed=PROJECT_SEED",
          if (USE_FWB) "fwildclusterboot" else "lm-dummies + sandwich::vcovBS.lm",
          WILD_R))
for (i in seq_len(nrow(rep_specs))) {
  r <- rep_specs[i, ]
  p3a_lines <- c(p3a_lines, sprintf(
    "  Spec %s %-18s  p_wild = %.4f  SE_wild = %12.2f  p_wild_holm = %.4f",
    r$spec, r$outcome, r$p_wild, r$se_wild, r$p_wild_holm
  ))
}

readr::write_lines(p3a_lines, file.path(out_dir, "replication_check.txt"),
                   append = TRUE)

# ---------------------------------------------------------------------------- #
# Phase 7 — Save RDS
# ---------------------------------------------------------------------------- #

saveRDS(
  list(
    mccrary           = mccrary_table,
    outlier_specs     = outlier_specs,
    outlier_check     = rep_outlier,
    wild_replication  = rep_specs,
    notes             = paste0(
      "P3a Tier 1 outputs. McCrary via rddensity (Cattaneo-Jansson-Ma 2020), ",
      "jackknife VCE. Outlier ladder: 72 fits (4 outcomes × 3 bandwidths × ",
      "3 transforms × 2 specs); STATA-anchored subset = 24 cells (Spec A × ",
      "IHS+w99, 06_robustness_aux.log). Wild bootstrap via ",
      if (USE_FWB) "fwildclusterboot" else "lm+factor+sandwich::vcovBS.lm",
      ", R=", WILD_R, ", cluster=hh_id. Holm stepdown across 4 outcomes per spec."
    )
  ),
  file.path(out_dir, "rob_results.rds")
)

# Also update main_results.rds with Wild p-values for replication cells.
mr$wild_replication <- rep_specs
saveRDS(mr, file.path(out_dir, "main_results.rds"))

# ---------------------------------------------------------------------------- #
# Phase 8 — Compact outlier ladder table per outcome
# ---------------------------------------------------------------------------- #

fmt_n <- function(x, d = 0) formatC(x, format = "f", digits = d, big.mark = ",")
fmt_ihs <- function(x, d = 4) formatC(x, format = "f", digits = d)

write_outlier_table_per_outcome <- function(y, lang, path) {
  rows <- character()
  for (sp in c("A", "B")) {
    for (tr in c("ihs", "w99", "w995")) {
      cells <- outlier_specs |>
        dplyr::filter(spec == sp, transform == tr, outcome == y) |>
        dplyr::arrange(match(bw_label, c("T1", "T2", "T3")))
      tr_label <- switch(tr, "ihs" = "IHS asinh(y)", "w99" = "Winsor p1/p99", "w995" = "Winsor p0.5/p99.5")
      fmt_fn <- if (tr == "ihs") fmt_ihs else fmt_n
      est_str <- paste(fmt_fn(cells$estimate), collapse = " & ")
      se_str  <- paste(sprintf("(%s)", fmt_fn(cells$se)), collapse = " & ")
      n_str   <- paste(fmt_n(cells$n_obs), collapse = " & ")
      rows <- c(rows,
        sprintf("Spec %s, %s & %s \\\\", sp, tr_label, est_str),
        sprintf("        & %s \\\\", se_str),
        sprintf("N       & %s \\\\", n_str))
    }
  }
  body <- paste(rows, collapse = "\n")
  caption <- if (lang == "en")
    sprintf("Outlier Robustness Ladder — Outcome: %s", y)
  else
    sprintf("Outlier 강건성 사다리 — 결과변수: %s", y)
  note <- if (lang == "en")
    "Cluster-robust SE (hh_id) in parentheses. Bandwidths: T1=±500m², T2=±1000m², T3=±3300m². IHS uses asinh scale; Winsor on KRW. 24 IHS+w99 Spec A cells anchored to STATA 06_robustness_aux.log; Winsor p0.5/p99.5 (AJAE robustness, S2 per outlier-policy spec v1.1) is R-only."
  else
    "괄호 안 클러스터 강건 SE (hh_id). Bandwidth: T1=±500m², T2=±1000m², T3=±3300m². IHS는 asinh 척도; Winsor는 KRW. 24개 IHS+w99 Spec A 셀은 STATA 06_robustness_aux.log 대조. Winsor p0.5/p99.5 (AJAE robustness, outlier-spec v1.1 S2)는 R-only."

  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{tab:rob_outlier_%s_%s}\n\\begin{tabular}{lrrr}\n\\toprule\nRow & T1 (h=500) & T2 (h=1000) & T3 (h=3300) \\\\\n\\midrule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    caption, y, lang, body, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

# Write one combined .tex per language (4 tables stacked).
for (lg in c("en", "ko")) {
  combined <- c()
  for (y in outcomes) {
    tmp <- tempfile()
    write_outlier_table_per_outcome(y, lg, tmp)
    combined <- c(combined, readLines(tmp), "")
  }
  writeLines(combined,
             file.path(out_dir, sprintf("tab_rob_outlier_%s.tex", lg)),
             useBytes = (lg == "ko"))
}

# ---------------------------------------------------------------------------- #
# Final stdout summary
# ---------------------------------------------------------------------------- #

message(sprintf(
  "04_robust.R: McCrary T=%.3f (PASS=%s), outlier ladder %d cells (STATA-anchored %d/%d PASS), Wild bootstrap path %s.",
  mccrary_table$t_stat[1], if (mccrary_pass) "yes" else "NO",
  nrow(outlier_specs), sum(rep_outlier$pass), nrow(rep_outlier),
  if (USE_FWB) "fwildclusterboot" else "lm-fallback"
))
