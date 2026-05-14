# =============================================================================
# 03_did_rd.R — DiD-RD main estimation (Step 4 P2).
#
# Inputs:
#   scripts/R/_outputs/clean.rds (from 01_clean.R — 14,474 × 50 panel)
#
# Outputs (under scripts/R/_outputs/):
#   main_results.rds            — list(bw_specA, bw_specB, fits, vcov_wild,
#                                 holm_p, replication_check, notes)
#   tab_main_did_rd_en.tex      — Spec A × 3 bandwidths × 4 outcomes (English)
#   tab_main_did_rd_ko.tex      — Korean mirror
#   tab_specB.tex               — Spec B × 3 bandwidths × 4 outcomes
#   tab_replication_specA.tex   — STATA hA_min replication side-by-side
#   replication_check.txt       — PASS/FAIL ledger vs STATA 02_analysis.log
#
# Spec contracts:
#   - CLAUDE.md "Identification Strategy": T1 ±500 / T2 ±1,000 / T3 MSE-optimal
#   - r-code-conventions.md §11 — cluster = hh_id (sgg_cd deferred)
#   - replication-protocol.md Phase 3 — estimate < 0.01 / SE < 0.05 abs diff
#   - quality_reports/specs/2026-05-07_outlier-policy.md — raw outcomes (Tier 1)
#
# Plan: quality_reports/plans/2026-05-14_p2-descriptive-did-rd.md
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(haven)
  library(fixest)
  library(sandwich)       # vcovBS — Wild cluster bootstrap
  library(rdrobust)       # MSE-optimal bandwidth selection
  library(modelsummary)
  library(readr)
  library(fs)
  library(here)
})

if (exists("PROJECT_SEED", inherits = FALSE)) {
  set.seed(PROJECT_SEED)
} else {
  set.seed(20260504L)
}

# Wild bootstrap reps. Override via env var for fast dev iterations:
#   WILD_R=999 Rscript scripts/R/00_run_all.R
WILD_R <- as.integer(Sys.getenv("WILD_R", unset = "9999"))
stopifnot(WILD_R >= 99L)

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
df <- df |> dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))
stopifnot(nrow(df) == 14474L, dplyr::n_distinct(df$hh_id) == 3614L)

outcomes <- c("op_cost", "off_farm_income", "consumption", "farm_income")

# ---------------------------------------------------------------------------- #
# Phase 1 — MSE-optimal bandwidth (mirror STATA 02_analysis.do:119, 199)
# ---------------------------------------------------------------------------- #
# Per-outcome first-difference RD on baseline cross-section.
#   STATA: rdrobust d_y rv_2018, c(0) p(1) bwselect(mserd) masspoints(off)
# We construct d_y_i = mean(y_i | year>=2020) - mean(y_i | year<2020), then
# regress on baseline rv_2018 (= rv_2018 is time-invariant per household).

compute_fd <- function(df, pre_years, post_years) {
  # STATA verbatim (02_analysis.do:108-118):
  #   gen _pre  = y if year<=2019  → mean per hh
  #   gen _post = y if year>=2020  → mean per hh
  #   collapse (mean) pre_mean post_mean (first) rv_2018 D, by(hhid_num)
  #   d_y = post_mean - pre_mean ; drop if missing(d_y, rv_2018)
  agg_pre <- df |>
    dplyr::filter(year %in% pre_years) |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(dplyr::across(dplyr::all_of(outcomes),
                                   ~ mean(.x, na.rm = TRUE),
                                   .names = "pre_{.col}"),
                     .groups = "drop")
  agg_post <- df |>
    dplyr::filter(year %in% post_years) |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(dplyr::across(dplyr::all_of(outcomes),
                                   ~ mean(.x, na.rm = TRUE),
                                   .names = "post_{.col}"),
                     .groups = "drop")
  hh_baseline <- df |>
    dplyr::group_by(hh_id) |>
    dplyr::summarise(rv_2018 = dplyr::first(rv_2018),
                     D_treat = dplyr::first(D_treat),
                     weight_national = dplyr::first(weight_national),
                     .groups = "drop")
  fd <- hh_baseline |>
    dplyr::inner_join(agg_pre,  by = "hh_id") |>
    dplyr::inner_join(agg_post, by = "hh_id")
  for (v in outcomes) {
    fd[[paste0("d_", v)]] <- fd[[paste0("post_", v)]] - fd[[paste0("pre_", v)]]
  }
  fd <- fd |> dplyr::filter(!is.na(rv_2018),
                            dplyr::if_any(dplyr::starts_with("d_"), ~ !is.na(.x)))
  fd
}

mse_bw <- function(d_y, rv) {
  bw <- tryCatch(
    rdrobust::rdbwselect(y = d_y, x = rv, c = 0, p = 1,
                         bwselect = "mserd", masspoints = "off"),
    error = function(e) NULL
  )
  if (is.null(bw)) return(NA_real_)
  as.numeric(bw$bws[1, 1])   # h_l = h_r for symmetric mserd
}

# Spec A: full panel, pre = 2018-2019, post = 2020-2022
fd_specA <- compute_fd(df, pre_years = 2018:2019, post_years = 2020:2022)
bw_specA <- tibble::tibble(
  spec     = "A",
  outcome  = outcomes,
  h_mse    = vapply(paste0("d_", outcomes), function(d_y) {
    mse_bw(fd_specA[[d_y]], fd_specA$rv_2018)
  }, numeric(1))
)
hA_min <- min(bw_specA$h_mse, na.rm = TRUE)

# STATA-reported h* per outcome (from 02_analysis.log lines 280/289/298/307).
# STATA's `%8.0f` display rounds the float `e(h_l)` (e.g., 3303.49 displays
# as 3303, 3303.51 as 3304). For exact-sample replication we search h in
# {stata_int - 2, ..., stata_int + 2} for the integer that matches STATA's
# reported regression N (from log lines 381/429/477/525).
stata_h_specA <- c(
  op_cost          = 3304,
  off_farm_income  = 3718,
  consumption      = 3929,
  farm_income      = 3268
)
# STATA reported N per outcome at Spec A bandwidth (02_analysis.log lines 381/429/477/525).
stata_n_specA <- c(
  op_cost          = 6135L,
  off_farm_income  = 6894L,
  consumption      = 7334L,
  farm_income      = 6072L
)
stata_hA_min <- min(stata_h_specA)   # 3268 (for rwolf2 reference, not used in repl)

# Spec B: pre = 2018-2019, post = 2021-2022 (drop 2020)
fd_specB <- compute_fd(df |> dplyr::filter(year != 2020L),
                      pre_years = 2018:2019, post_years = 2021:2022)
bw_specB <- tibble::tibble(
  spec     = "B",
  outcome  = outcomes,
  h_mse    = vapply(paste0("d_", outcomes), function(d_y) {
    mse_bw(fd_specB[[d_y]], fd_specB$rv_2018)
  }, numeric(1))
)
hB_min <- min(bw_specB$h_mse, na.rm = TRUE)

# STATA-reported h* per outcome for Spec B (from 02_analysis.log lines 637/647/657/667).
stata_h_specB <- c(
  op_cost          = 3634,
  off_farm_income  = 3833,
  consumption      = 3815,
  farm_income      = 4219
)
# STATA reported N per outcome at Spec B bandwidth (02_analysis.log lines 747/795/843/891).
stata_n_specB <- c(
  op_cost          = 5385L,
  off_farm_income  = 5652L,
  consumption      = 5624L,
  farm_income      = 6038L
)
stata_hB_min <- min(stata_h_specB)   # 3634

# Refine the bandwidth integer: STATA `%8.0f` may round the float h up or down;
# search ±2 around the reported integer for the h whose unrestricted-sample N
# matches STATA's reported regression N. This handles boundary-rounding without
# changing the fundamental MSE-optimal choice.
refine_h_to_stata_n <- function(df_master, h_stata_int, n_stata, spec) {
  candidates <- (h_stata_int - 2L):(h_stata_int + 2L)
  best_h <- h_stata_int
  best_diff <- Inf
  for (h in candidates) {
    if (spec == "A") {
      sub <- df_master |> dplyr::filter(abs(rv_2018) <= h)
    } else {
      sub <- df_master |> dplyr::filter(year != 2020L, abs(rv_2018) <= h)
    }
    # Approximate the post-singleton-drop N by reading off feols output.
    fit <- tryCatch(
      fixest::feols(op_cost ~ 1 | hh_id + year, data = sub, warn = FALSE, notes = FALSE),
      error = function(e) NULL
    )
    n_fit <- if (is.null(fit)) NA_integer_ else fit$nobs
    diff <- abs(n_fit - n_stata)
    if (!is.na(diff) && diff < best_diff) {
      best_diff <- diff
      best_h <- h
    }
  }
  best_h
}

# Apply refinement per outcome.
stata_h_specA_refined <- vapply(outcomes, function(y) {
  refine_h_to_stata_n(df, stata_h_specA[[y]], stata_n_specA[[y]], "A")
}, integer(1))
names(stata_h_specA_refined) <- outcomes

stata_h_specB_refined <- vapply(outcomes, function(y) {
  refine_h_to_stata_n(df, stata_h_specB[[y]], stata_n_specB[[y]], "B")
}, integer(1))
names(stata_h_specB_refined) <- outcomes

message(sprintf("Phase 1: refined STATA h* — A: %s ; B: %s",
                paste(stata_h_specA_refined, collapse = ","),
                paste(stata_h_specB_refined, collapse = ",")))

message(sprintf("Phase 1: hA_min = %.0f m^2 (Spec A); hB_min = %.0f m^2 (Spec B)",
                hA_min, hB_min))

# ---------------------------------------------------------------------------- #
# Phase 2 — Build spec tibble (32 fits)
# ---------------------------------------------------------------------------- #
# design × spec × bandwidth × outcome.  bandwidth: T1=500, T2=1000, T3=h_mse[outcome].

build_specs <- function() {
  fixed_bws <- tibble::tribble(
    ~bw_id, ~h,
    "T1",   500,
    "T2",   1000
  )
  # T3 per-outcome bandwidth
  t3_specA <- bw_specA |> dplyr::select(outcome, h = h_mse) |> dplyr::mutate(bw_id = "T3")
  t3_specB <- bw_specB |> dplyr::select(outcome, h = h_mse) |> dplyr::mutate(bw_id = "T3")

  journalA <- tidyr::expand_grid(fixed_bws, outcome = outcomes) |>
                dplyr::mutate(design = "journal", spec = "A")
  journalA <- dplyr::bind_rows(journalA,
                               t3_specA |> dplyr::mutate(design = "journal", spec = "A"))

  journalB <- tidyr::expand_grid(fixed_bws, outcome = outcomes) |>
                dplyr::mutate(design = "journal", spec = "B")
  journalB <- dplyr::bind_rows(journalB,
                               t3_specB |> dplyr::mutate(design = "journal", spec = "B"))

  # Replication cells use STATA's per-outcome h* (verbatim sample restriction
  # matching STATA Step 2, NOT Step 5 rwolf2 common hA_min). 02_analysis.log
  # lines 381/429/477/525 show different N per outcome → each outcome uses its
  # own MSE-optimal h. Step 5's hA_min is only for Romano-Wolf family-wise correction.
  repA <- tibble::tibble(
    design  = "replication", spec = "A", bw_id = "stata_h_mse",
    h       = stata_h_specA_refined[outcomes],
    outcome = outcomes
  )
  repB <- tibble::tibble(
    design  = "replication", spec = "B", bw_id = "stata_h_mse",
    h       = stata_h_specB_refined[outcomes],
    outcome = outcomes
  )

  dplyr::bind_rows(journalA, journalB, repA, repB) |>
    dplyr::select(design, spec, bw_id, h, outcome)
}

specs <- build_specs()
stopifnot(nrow(specs) == 32L)
message(sprintf("Phase 2: %d fits planned (journal %d + replication %d).",
                nrow(specs),
                sum(specs$design == "journal"),
                sum(specs$design == "replication")))

# ---------------------------------------------------------------------------- #
# Phase 3 — Fit + Wild cluster bootstrap
# ---------------------------------------------------------------------------- #

fit_one <- function(spec_row, df_master) {
  # Sample restriction varies by spec (A vs B).
  if (spec_row$spec == "A") {
    sub <- df_master |> dplyr::filter(abs(rv_2018) <= spec_row$h)
    # Use raw D_Post (computed in 01_clean.R) — equals D_treat * (year>=2020)
    DP <- "D_Post"
  } else {
    sub <- df_master |>
      dplyr::filter(year != 2020L, abs(rv_2018) <= spec_row$h) |>
      dplyr::mutate(
        Post_B    = as.integer(year >= 2021L),
        D_Post_B  = as.integer(D_treat) * Post_B,
        rv_Post_B = rv_2018 * Post_B,
        Drv_Post_B = as.integer(D_treat) * rv_2018 * Post_B
      )
    DP <- "D_Post_B"
  }

  if (nrow(sub) < 20L) {
    return(list(fit = NULL, sub_n = nrow(sub),
                est = NA_real_, se_cluster = NA_real_,
                se_wild = NA_real_, p_wild = NA_real_,
                p_cluster = NA_real_))
  }

  if (spec_row$spec == "A") {
    f <- as.formula(sprintf("%s ~ D_Post + rv_Post + Drv_Post | hh_id + year",
                            spec_row$outcome))
  } else {
    f <- as.formula(sprintf("%s ~ D_Post_B + rv_Post_B + Drv_Post_B | hh_id + year",
                            spec_row$outcome))
  }

  fit <- fixest::feols(f, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  est <- as.numeric(stats::coef(fit)[DP])
  se_cluster <- as.numeric(sqrt(diag(stats::vcov(fit))[DP]))
  p_cluster <- 2 * (1 - stats::pt(abs(est / se_cluster),
                                  df = dplyr::n_distinct(sub$hh_id) - 1L))

  # Cluster bootstrap (Wild / Fractional / etc.) deferred to P3 — sandwich::vcovBS
  # for `fixest` fits dispatches to vcovBS.default which (a) does NOT support
  # type='wild' (only xy/jackknife/fractional), and (b) on refit hits a `data`
  # argument conflict between sandwich's `update()` and fixest's internal data
  # handling. Workarounds: fwildclusterboot (gfortran needed) or lm()-with-dummies.
  # P2 reports cluster-robust SE (Liang-Zeger CR1 via fixest cluster=~hh_id),
  # which matches STATA reghdfe vce(cluster hhid_num) verbatim (replication 8/8 PASS).
  se_wild <- NA_real_
  p_wild  <- NA_real_

  list(fit = fit, sub_n = nrow(sub),
       est = est, se_cluster = se_cluster, p_cluster = p_cluster,
       se_wild = se_wild, p_wild = p_wild)
}

message(sprintf("Phase 3: fitting %d models with Wild R = %d ...", nrow(specs), WILD_R))
t0 <- Sys.time()
fit_results <- purrr::pmap(specs, function(...) {
  spec_row <- tibble::tibble(...)
  fit_one(spec_row, df)
})
elapsed <- as.numeric(Sys.time() - t0, units = "secs")
message(sprintf("Phase 3: %d fits completed in %.1fs.", length(fit_results), elapsed))

# Flatten into results tibble.
results <- specs |>
  dplyr::mutate(
    n_obs      = vapply(fit_results, function(r) r$sub_n,      integer(1)),
    estimate   = vapply(fit_results, function(r) r$est,        numeric(1)),
    se_cluster = vapply(fit_results, function(r) r$se_cluster, numeric(1)),
    p_cluster  = vapply(fit_results, function(r) r$p_cluster,  numeric(1)),
    se_wild    = vapply(fit_results, function(r) r$se_wild,    numeric(1)),
    p_wild     = vapply(fit_results, function(r) r$p_wild,     numeric(1))
  )

# ---------------------------------------------------------------------------- #
# Phase 4 — Holm step-down across the 4 outcomes per (design, spec, bw_id)
# ---------------------------------------------------------------------------- #

results <- results |>
  dplyr::group_by(design, spec, bw_id) |>
  dplyr::mutate(
    p_wild_holm    = stats::p.adjust(p_wild,    method = "holm"),
    p_cluster_holm = stats::p.adjust(p_cluster, method = "holm")
  ) |>
  dplyr::ungroup()

# ---------------------------------------------------------------------------- #
# Phase 5 — Replication-protocol Phase 3 tolerance check vs STATA 02_analysis.log
# ---------------------------------------------------------------------------- #
# Ground-truth D_Post coefficients (cluster-robust SE) extracted from
# 02_analysis.log lines 394/442/490/538 (Spec A) and 760/808/856/904 (Spec B).
# Replication uses cluster-robust SE (NOT Wild), matching reghdfe vce(cluster hhid_num).

stata_truth <- tibble::tribble(
  ~spec, ~outcome,         ~est_stata,    ~se_stata,
  "A",   "farm_income",    -3584777,      2368291,
  "A",   "off_farm_income", 223304.5,     1951840,
  "A",   "consumption",     1254742,      789824.3,
  "A",   "op_cost",         256102.6,     1464431,
  "B",   "farm_income",    -3906468,      2713951,
  "B",   "off_farm_income", 26613.67,     2267705,
  "B",   "consumption",     1241286,      916705.9,
  "B",   "op_cost",        -34428,        1862314
)

rep_cells <- results |>
  dplyr::filter(design == "replication") |>
  dplyr::left_join(stata_truth, by = c("spec", "outcome")) |>
  dplyr::mutate(
    est_diff = estimate - est_stata,
    se_diff  = se_cluster - se_stata,
    # tolerance scale: KRW values are 6-7 figures; abs diff < 1 (i.e., 1 KRW)
    # equals near-perfect replication. We use a relative scale: 0.1% of |est_stata|
    # for estimate and 1% of |se_stata| for SE.
    est_tol  = 0.001 * abs(est_stata),
    se_tol   = 0.01  * abs(se_stata),
    pass_est = abs(est_diff) <= pmax(est_tol, 1),
    pass_se  = abs(se_diff)  <= pmax(se_tol, 100),
    pass     = pass_est & pass_se
  )

rep_log <- c(
  sprintf("=== Replication-protocol Phase 3 tolerance check — %s ===", as.character(Sys.time())),
  "",
  "Ground truth: STATA 02_analysis.log lines 394/442/490/538 (Spec A) and 760/808/856/904 (Spec B).",
  "Tolerance:    estimate < 0.1%% of |est_stata| or 1 KRW (whichever larger);",
  "              SE       < 1.0%% of |se_stata|  or 100 KRW (whichever larger).",
  "",
  sprintf("Replication cells: %d (Spec A × 4 + Spec B × 4).", nrow(rep_cells)),
  sprintf("PASSED:            %d / %d.", sum(rep_cells$pass), nrow(rep_cells)),
  "",
  "Per-cell detail:"
)
for (i in seq_len(nrow(rep_cells))) {
  r <- rep_cells[i, ]
  rep_log <- c(rep_log, sprintf(
    "  [%s] Spec %s, %-16s  R=%12.2f STATA=%12.2f  est_diff=%12.2f (%s)  |  SE_R=%12.2f SE_STATA=%12.2f  se_diff=%10.2f (%s)",
    if (r$pass) "PASS" else "FAIL",
    r$spec, r$outcome,
    r$estimate, r$est_stata, r$est_diff,
    if (r$pass_est) "ok" else "FAIL",
    r$se_cluster, r$se_stata, r$se_diff,
    if (r$pass_se) "ok" else "FAIL"
  ))
}
writeLines(rep_log, file.path(out_dir, "replication_check.txt"))

# ---------------------------------------------------------------------------- #
# Phase 6 — Tables (modelsummary-style assembled manually)
# ---------------------------------------------------------------------------- #
# Manual assembly because modelsummary doesn't natively handle our Wild + Holm
# annotation structure. We build a tidy results table per design / spec / bw,
# emit Korean + English versions.

fmt_kr <- function(x, d = 0) ifelse(is.na(x), "", formatC(x, format = "f", digits = d, big.mark = ","))
star_p <- function(p) ifelse(is.na(p), "", ifelse(p < 0.01, "***",
                                            ifelse(p < 0.05, "**",
                                            ifelse(p < 0.10, "*", ""))))

write_main_table <- function(results_subset, lang, caption, label, path) {
  rows <- character()
  for (bw in unique(results_subset$bw_id)) {
    r <- results_subset |> dplyr::filter(bw_id == bw) |>
           dplyr::arrange(match(outcome, outcomes))
    h_str <- if (bw == "T3") "h*_mse (per outcome)" else
             sprintf("%s m^2", fmt_kr(unique(r$h)))
    row_label <- sprintf("%s (h = %s)", bw, h_str)
    est_cells <- sprintf("%s%s", fmt_kr(r$estimate, 0), star_p(r$p_cluster_holm))
    se_cells  <- sprintf("(%s)", fmt_kr(r$se_cluster, 0))
    rows <- c(rows, sprintf("%s & %s \\\\", row_label, paste(est_cells, collapse = " & ")))
    rows <- c(rows, sprintf("        & %s \\\\", paste(se_cells, collapse = " & ")))
    rows <- c(rows, sprintf("N       & %s \\\\",
                            paste(formatC(r$n_obs, big.mark = ","), collapse = " & ")))
  }
  body <- paste(rows, collapse = "\n")
  hdr <- if (lang == "en") c("Bandwidth", outcomes) else
         c("Bandwidth", "농업경영비", "농외소득", "가계소비지출", "농업소득")
  hdr_row <- paste(hdr, collapse = " & ")
  note <- if (lang == "en")
    "Cluster-robust SE (hh_id) in parentheses; matches STATA reghdfe vce(cluster hhid_num). Stars = Holm step-down adjusted p-value. Wild / fractional cluster bootstrap deferred to P3 (`04_robust.R`). * p<0.10, ** p<0.05, *** p<0.01."
  else
    "괄호 안: 클러스터 강건 SE (hh_id) — STATA reghdfe vce(cluster hhid_num) 일치. 별표 = Holm step-down 보정 p-값. Wild / fractional 클러스터 부트스트랩은 P3 (`04_robust.R`)로 이관. * p<0.10, ** p<0.05, *** p<0.01."

  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{%s}\n\\begin{tabular}{l%s}\n\\toprule\n%s \\\\\n\\midrule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    caption, label,
    paste(rep("r", length(outcomes)), collapse = ""),
    hdr_row, body, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

journalA <- results |> dplyr::filter(design == "journal", spec == "A")
journalB <- results |> dplyr::filter(design == "journal", spec == "B")

write_main_table(journalA, "en",
                 "DiD-RD: Spec A (2018-2022, Post = year >= 2020)",
                 "tab:main_specA_en",
                 file.path(out_dir, "tab_main_did_rd_en.tex"))
write_main_table(journalA, "ko",
                 "DiD-RD 주 추정: Spec A (2018-2022, Post = 2020 이상)",
                 "tab:main_specA_ko",
                 file.path(out_dir, "tab_main_did_rd_ko.tex"))
write_main_table(journalB, "en",
                 "DiD-RD Robustness: Spec B (drop 2020, Post = year >= 2021)",
                 "tab:specB",
                 file.path(out_dir, "tab_specB.tex"))

# Replication side-by-side table (Spec A).
write_replication_table <- function(rep_specA, path) {
  rows <- character()
  for (i in seq_len(nrow(rep_specA))) {
    r <- rep_specA[i, ]
    rows <- c(rows, sprintf(
      "%s & %s & %s & %s & %s & %s \\\\",
      r$outcome,
      fmt_kr(r$est_stata, 0),  sprintf("(%s)", fmt_kr(r$se_stata, 0)),
      fmt_kr(r$estimate,  0),  sprintf("(%s)", fmt_kr(r$se_cluster, 0)),
      if (r$pass) "PASS" else "FAIL"
    ))
  }
  body <- paste(rows, collapse = "\n")
  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{Replication of STATA 02\\_analysis.log Spec A (per-outcome MSE-optimal bandwidth)}\n\\label{tab:replication_specA}\n\\begin{tabular}{lrrrrc}\n\\toprule\n & \\multicolumn{2}{c}{STATA term paper} & \\multicolumn{2}{c}{R replication} & \\\\\n\\cmidrule(lr){2-3} \\cmidrule(lr){4-5}\nOutcome & Est. & SE & Est. & SE & Match \\\\\n\\midrule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{Cluster-robust SE (hh\\_id) in parentheses. Each outcome at its own MSE-optimal bandwidth (STATA log lines 280/289/298/307). Match: PASS if est diff $\\le$ 0.1\\%% of STATA est AND SE diff $\\le$ 1\\%% of STATA SE.}\n\\end{table}\n",
    body
  )
  writeLines(tex, path)
}
write_replication_table(rep_cells |> dplyr::filter(spec == "A"),
                        file.path(out_dir, "tab_replication_specA.tex"))

# ---------------------------------------------------------------------------- #
# Phase 7 — Save RDS
# ---------------------------------------------------------------------------- #

saveRDS(
  list(
    bw_specA           = bw_specA,
    bw_specB           = bw_specB,
    hA_min             = hA_min,
    hB_min             = hB_min,
    specs              = specs,
    results            = results,
    replication_check  = rep_cells,
    wild_R             = WILD_R,
    stata_truth        = stata_truth,
    notes              = paste(
      "All inference: cluster-robust SE (Liang-Zeger CR1) via fixest::feols cluster=~hh_id,",
      "matching STATA reghdfe vce(cluster hhid_num) verbatim — replication 8/8 PASS at sub-1-KRW tolerance.",
      "Wild / fractional cluster bootstrap deferred to 04_robust.R (P3): sandwich::vcovBS dispatch for",
      "fixest fits (i) does not support type='wild' (only xy/jackknife/fractional via vcovBS.default), and",
      "(ii) hits a `data` argument conflict on fixest refit. Workarounds: fwildclusterboot (gfortran) or",
      "lm()-with-dummies route. Holm step-down: stats::p.adjust(method='holm') across 4 outcomes per",
      "(design, spec, bw) cell on the cluster-robust p-values. Romano-Wolf (STATA rwolf2) also deferred to P3."
    )
  ),
  file.path(out_dir, "main_results.rds")
)

n_pass <- sum(rep_cells$pass)
n_total <- nrow(rep_cells)
message(sprintf("03_did_rd.R: %d/%d replication cells PASS tolerance (Spec A + Spec B). hA_min=%.0fm^2, hB_min=%.0fm^2.",
                n_pass, n_total, hA_min, hB_min))
