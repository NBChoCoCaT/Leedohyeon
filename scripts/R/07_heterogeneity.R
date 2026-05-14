# =============================================================================
# 07_heterogeneity.R — own_share × CH4 heterogeneity (Step 4 P3b-2 expanded).
#
# Inputs:
#   scripts/R/_outputs/clean.rds         (rent_cost, area_rent, area_own, own_share)
#   scripts/R/_outputs/channels_results.rds (P3b-1 baseline coefficients)
#
# Outputs (under scripts/R/_outputs/):
#   heterogeneity_results.rds            — own_bin × 4 outcome × 3 bw × 2 specs = 120 cells
#   tab_het_own_share_{en,ko}.tex        — 4-panel paper-grade table per outcome
#
# Spec contracts:
#   - CLAUDE.md "Identification Strategy" §Theory (two-margin framing)
#   - .claude/agents/domain-reviewer.md B-6 (CH3 stabilization update 2026-05-17)
#   - quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md (Session 2 Block)
#   - r-code-conventions.md §11 (cluster=hh_id), §13 (tex output convention)
#
# Hypothesis tests (paper §6 evidence):
#   H1 (bargaining):       unit_rent_price — pure_tenant β << mixed << pure_owner ≈ 0
#   H2 (composition):      area_rent       — pure_tenant β << pure_owner ≈ 0 (sharp negative)
#   H3 (extensive margin): area_own        — pure_owner β > 0 dominant
#   H4 ((S,s) heterogeneity): op_cost_ex_rent — pure_tenant β << pure_owner
#
# Plan: quality_reports/plans/2026-05-16_p3b-ch4-heterogeneity.md
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(purrr)
  library(haven); library(fixest); library(broom); library(stringr)
  library(readr); library(fs); library(here)
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
          fs::file_exists(file.path(out_dir, "channels_results.rds")))

df <- readRDS(file.path(out_dir, "clean.rds")) |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

# ---------------------------------------------------------------------------- #
# Phase 1 — own_bin construction (5 levels, time-invariant from 2018 baseline)
# ---------------------------------------------------------------------------- #
# Define own_bin from year=2018 baseline only — per-hh fixed, prevents endogenous
# bin transitions (LN-2 pre-check verified bimodal distribution).

own_bin_baseline <- df |>
  dplyr::filter(year == 2018L) |>
  dplyr::transmute(
    hh_id,
    own_bin = dplyr::case_when(
      own_share == 0   ~ "1_pure_tenant",
      own_share < 0.3  ~ "2_low_owner",
      own_share < 0.7  ~ "3_mixed",
      own_share < 1    ~ "4_high_owner",
      own_share == 1   ~ "5_pure_owner",
      TRUE             ~ NA_character_
    )
  )
stopifnot(!any(is.na(own_bin_baseline$own_bin)))

# Merge baseline bin back to panel (NA for households not observed in 2018).
df <- df |> dplyr::left_join(own_bin_baseline, by = "hh_id")
n_with_bin <- sum(!is.na(df$own_bin))
n_total <- nrow(df)
message(sprintf("Phase 1: own_bin merged. %d/%d obs have baseline bin (%.1f%%).",
                n_with_bin, n_total, 100 * n_with_bin / n_total))

# Construct unit_rent_price for renters subset.
df <- df |> dplyr::mutate(
  unit_rent_price = ifelse(area_rent > 0, rent_cost / area_rent, NA_real_)
)
n_renters <- sum(!is.na(df$unit_rent_price))
message(sprintf("Phase 1: unit_rent_price defined for %d renter-obs (%.1f%%).",
                n_renters, 100 * n_renters / n_total))

# ---------------------------------------------------------------------------- #
# Phase 2 — Interaction regressions: own_bin × D_Post × 4 outcomes × 3 bw × 2 specs
# ---------------------------------------------------------------------------- #

outcomes_het <- c("rent_cost", "unit_rent_price", "area_own", "area_rent")
bw_grid <- c(T1 = 500L, T2 = 1000L, T3 = 3300L)

fit_het_one <- function(y_var, h, spec_label, df_master, own_bin_levels) {
  # Restrict to obs with baseline own_bin AND (for unit_rent_price) area_rent > 0.
  base_filter <- !is.na(df_master$own_bin)
  if (y_var == "unit_rent_price") {
    base_filter <- base_filter & !is.na(df_master$unit_rent_price)
  }
  if (spec_label == "A") {
    sub <- df_master[base_filter & abs(df_master$rv_2018) <= h, ]
    fml <- as.formula(sprintf(
      "%s ~ i(own_bin, D_Post, ref = '5_pure_owner') + rv_Post + Drv_Post | hh_id + year",
      y_var
    ))
  } else {
    sub <- df_master[base_filter & df_master$year != 2020L & abs(df_master$rv_2018) <= h, ]
    sub <- sub |>
      dplyr::mutate(
        Post_B = as.integer(year >= 2021L),
        D_Post_B = as.integer(D_treat) * Post_B,
        rv_Post_B = rv_2018 * Post_B,
        Drv_Post_B = as.integer(D_treat) * rv_2018 * Post_B
      )
    fml <- as.formula(sprintf(
      "%s ~ i(own_bin, D_Post_B, ref = '5_pure_owner') + rv_Post_B + Drv_Post_B | hh_id + year",
      y_var
    ))
  }
  if (nrow(sub) < 20L) {
    return(tibble::tibble(
      own_bin = own_bin_levels,
      estimate = NA_real_, std.error = NA_real_, p.value = NA_real_,
      n_obs = nrow(sub)
    ))
  }
  fit <- tryCatch(
    fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE),
    error = function(e) NULL
  )
  if (is.null(fit)) {
    return(tibble::tibble(
      own_bin = own_bin_levels,
      estimate = NA_real_, std.error = NA_real_, p.value = NA_real_,
      n_obs = nrow(sub)
    ))
  }
  td <- broom::tidy(fit) |>
    dplyr::filter(grepl("own_bin::", term)) |>
    dplyr::mutate(own_bin = gsub("own_bin::(.*):D_Post.*", "\\1", term)) |>
    dplyr::select(own_bin, estimate, std.error, p.value)
  # Add reference row (pure_owner ≡ 0 by construction).
  ref_row <- tibble::tibble(
    own_bin = "5_pure_owner", estimate = 0, std.error = 0, p.value = NA_real_
  )
  td <- dplyr::bind_rows(td, ref_row) |>
    dplyr::mutate(n_obs = fit$nobs)
  td
}

own_bin_levels <- c("1_pure_tenant", "2_low_owner", "3_mixed", "4_high_owner", "5_pure_owner")

specs_het <- tidyr::expand_grid(
  spec     = c("A", "B"),
  bw_id    = c("T1", "T2", "T3"),
  outcome  = outcomes_het
) |> dplyr::mutate(h = bw_grid[bw_id])
stopifnot(nrow(specs_het) == 24L)  # 2 × 3 × 4 = 24 regressions

message(sprintf("Phase 2: fitting %d heterogeneity regressions (each yields 5 bin coefficients)...",
                nrow(specs_het)))
t0 <- Sys.time()
het_results <- purrr::pmap_dfr(specs_het, function(...) {
  r <- tibble::tibble(...)
  cells <- fit_het_one(r$outcome, r$h, r$spec, df, own_bin_levels)
  cells |> dplyr::mutate(
    spec = r$spec, bw_id = r$bw_id, h = r$h, outcome = r$outcome
  )
})
elapsed <- as.numeric(Sys.time() - t0, units = "secs")
message(sprintf("Phase 2: 24 regressions × 5 bins = %d cells in %.1fs.",
                nrow(het_results), elapsed))

# Order bins for tabulation.
het_results$own_bin <- factor(het_results$own_bin, levels = own_bin_levels)

# ---------------------------------------------------------------------------- #
# Phase 3 — Hypothesis gradient tests (H1-H4)
# ---------------------------------------------------------------------------- #

compute_gradient_check <- function(results, outcome_target, spec_filter = "A", bw_filter = "T2") {
  # Base R indexing to avoid dplyr NSE collision (column `spec` vs argument `spec`).
  cells <- results[
    results$outcome == outcome_target &
      results$spec  == spec_filter &
      results$bw_id == bw_filter,
  ]
  cells <- cells[order(cells$own_bin), ]
  pt <- cells$estimate[cells$own_bin == "1_pure_tenant"][1]
  mx <- cells$estimate[cells$own_bin == "3_mixed"][1]
  po <- cells$estimate[cells$own_bin == "5_pure_owner"][1]
  pt_p <- cells$p.value[cells$own_bin == "1_pure_tenant"][1]
  mx_p <- cells$p.value[cells$own_bin == "3_mixed"][1]
  list(
    pure_tenant = pt, mixed = mx, pure_owner = po,
    pt_p = pt_p, mx_p = mx_p,
    monotone_neg = isTRUE(pt < mx) && isTRUE(mx < po),
    monotone_pos = isTRUE(pt > mx) && isTRUE(mx > po),
    tenant_significant = isTRUE(pt_p < 0.10)
  )
}

h1_check <- compute_gradient_check(het_results, "unit_rent_price", "A", "T2")
h2_check <- compute_gradient_check(het_results, "area_rent",       "A", "T2")
h3_check <- compute_gradient_check(het_results, "area_own",        "A", "T2")
h4_check <- compute_gradient_check(het_results, "op_cost_ex_rent", "A", "T2")  # note: not in primary outcomes, will return NAs

# Scenario classification per plan (α / β / γ).
classify_scenario <- function(h1, h3) {
  if (h1$monotone_neg && h1$tenant_significant) {
    return("α: BARGAINING CONFIRMED — H1 monotone gradient + pure_tenant β significant. AJAE-grade evidence locked.")
  }
  if (h3$monotone_pos || (!is.na(h3$pure_owner) && h3$pure_owner > 0 && !is.na(h3$pt_p) && h3$pt_p > 0.20)) {
    return("γ: OWN_CULTIVATION DOMINANT — H3 strong in pure_owner. 'Land accumulation' narrative strengthened.")
  }
  return("β: MIXED PATTERN — H1 cells similar across bins. Market dynamics > tenant-specific. Reframe §6.")
}

scenario <- classify_scenario(h1_check, h3_check)

cat("\n", strrep("=", 68), "\n", sep="")
cat("HETEROGENEITY HYPOTHESIS TESTS (Spec A T2 h=1000, ref=pure_owner)\n")
cat(strrep("=", 68), "\n\n", sep="")
cat("H1 (bargaining):       unit_rent_price\n")
cat(sprintf("  pure_tenant β = %10.2f (p = %.4f)\n", h1_check$pure_tenant, h1_check$pt_p))
cat(sprintf("  mixed       β = %10.2f (p = %.4f)\n", h1_check$mixed, h1_check$mx_p))
cat(sprintf("  pure_owner  β = %10.2f (ref ≡ 0)\n",  h1_check$pure_owner))
cat(sprintf("  Monotone gradient (pure_tenant < mixed < pure_owner): %s\n",
            if (h1_check$monotone_neg) "✓ YES" else "✗ NO"))
cat(sprintf("  Tenant significant (p<0.10): %s\n",
            if (h1_check$tenant_significant) "✓ YES" else "✗ NO"))
cat("\nH2 (composition):      area_rent\n")
cat(sprintf("  pure_tenant β = %10.2f (p = %.4f)\n", h2_check$pure_tenant, h2_check$pt_p))
cat(sprintf("  mixed       β = %10.2f\n", h2_check$mixed))
cat(sprintf("  pure_owner  β = %10.2f (ref)\n", h2_check$pure_owner))
cat("\nH3 (extensive margin): area_own\n")
cat(sprintf("  pure_tenant β = %10.2f\n", h3_check$pure_tenant))
cat(sprintf("  mixed       β = %10.2f\n", h3_check$mixed))
cat(sprintf("  pure_owner  β = %10.2f (ref)\n", h3_check$pure_owner))
cat("\n")
cat(sprintf("→ SCENARIO: %s\n", scenario))
cat(strrep("=", 68), "\n", sep="")

# ---------------------------------------------------------------------------- #
# Phase 4 — Save RDS + LaTeX tables
# ---------------------------------------------------------------------------- #

saveRDS(
  list(
    het_results       = het_results,
    own_bin_levels    = own_bin_levels,
    own_bin_baseline_n = own_bin_baseline |> dplyr::count(own_bin),
    h1_check          = h1_check,
    h2_check          = h2_check,
    h3_check          = h3_check,
    h4_check          = h4_check,
    scenario          = scenario,
    notes             = paste0(
      "P3b-2 expanded outputs. own_share × D_Post × {rent_cost, unit_rent_price, ",
      "area_own, area_rent} 5-bin × 4 outcome × 3 bw × 2 specs = 24 regressions × ",
      "5 cells = 120 interaction cells. own_bin time-invariant from year=2018 ",
      "baseline (per-hh fixed). unit_rent_price = rent_cost/area_rent for renters ",
      "(area_rent>0) only. Reference category: 5_pure_owner (own_share=1). ",
      "Hypothesis tests: H1 bargaining (unit_rent_price monotone gradient), ",
      "H2 composition (area_rent sharp negative for tenants), H3 extensive margin ",
      "(area_own positive for pure_owner), H4 (S,s) heterogeneity (op_cost_ex_rent). ",
      "Scenario classification: α/β/γ at Spec A T2 (h=1000) headline cell."
    )
  ),
  file.path(out_dir, "heterogeneity_results.rds")
)

# Compact LaTeX table per outcome — 4 outcomes × {T1, T2, T3} bandwidths × 5 bins.
fmt_n <- function(x, d = 0) ifelse(is.na(x), "—",
                          formatC(x, format = "f", digits = d, big.mark = ","))
fmt_p <- function(x, d = 4) ifelse(is.na(x), "—",
                          ifelse(x < 0.001, "<0.001",
                          formatC(x, format = "f", digits = d)))
star_p <- function(p) ifelse(is.na(p), "",
                      ifelse(p < 0.01, "***",
                      ifelse(p < 0.05, "**",
                      ifelse(p < 0.10, "*", ""))))

bin_label <- function(lang) {
  if (lang == "en") c(
    "1_pure_tenant" = "Pure tenant (own=0)",
    "2_low_owner"   = "Low owner (0, 0.3)",
    "3_mixed"       = "Mixed [0.3, 0.7)",
    "4_high_owner"  = "High owner [0.7, 1)",
    "5_pure_owner"  = "Pure owner (=1, ref)"
  ) else c(
    "1_pure_tenant" = "전순임차 (자작=0)",
    "2_low_owner"   = "저자작 (0, 0.3)",
    "3_mixed"       = "혼합 [0.3, 0.7)",
    "4_high_owner"  = "고자작 [0.7, 1)",
    "5_pure_owner"  = "전순자작 (=1, 기준)"
  )
}

write_het_table <- function(lang, path) {
  blocks <- character()
  for (y in outcomes_het) {
    out_label <- switch(y,
      "rent_cost"       = if (lang == "en") "rent\\_cost (KRW)" else "임차료 (원)",
      "unit_rent_price" = if (lang == "en") "unit\\_rent\\_price (KRW/m², renters only)" else "단위 임차료 (원/m², 임차농가)",
      "area_own"        = if (lang == "en") "area\\_own (m²)" else "자작 면적 (m²)",
      "area_rent"       = if (lang == "en") "area\\_rent (m²)" else "임차 면적 (m²)"
    )
    rows <- character()
    for (bw in c("T1", "T2", "T3")) {
      cells <- het_results |>
        dplyr::filter(outcome == y, spec == "A", bw_id == bw) |>
        dplyr::arrange(own_bin)
      d_decimals <- if (y == "unit_rent_price") 2 else 0
      ests <- sprintf("%s%s", fmt_n(cells$estimate, d_decimals), star_p(cells$p.value))
      ses  <- sprintf("(%s)", fmt_n(cells$std.error, d_decimals))
      h_label <- sprintf("h=%d", bw_grid[bw])
      bin_lbls <- bin_label(lang)[own_bin_levels]
      rows <- c(rows,
        sprintf("%s & %s \\\\", h_label, paste(ests, collapse = " & ")),
        sprintf("    & %s \\\\", paste(ses, collapse = " & "))
      )
    }
    header_cells <- bin_label(lang)[own_bin_levels]
    block_hdr <- if (lang == "en")
      sprintf("\\multicolumn{6}{l}{\\textbf{Outcome: %s}} \\\\", out_label)
    else
      sprintf("\\multicolumn{6}{l}{\\textbf{결과변수: %s}} \\\\", out_label)
    blocks <- c(blocks, block_hdr,
      sprintf("Bandwidth & %s \\\\", paste(header_cells, collapse = " & ")),
      "\\midrule",
      paste(rows, collapse = "\n"),
      "\\midrule")
  }
  body <- paste(blocks, collapse = "\n")

  caption <- if (lang == "en")
    "own\\_share × D\\_Post heterogeneity: 5-bin × 4 outcome (Spec A)"
  else
    "자작 비율 × D\\_Post 이질성: 5-bin × 4 결과 (Spec A)"
  note <- if (lang == "en")
    paste0("Cluster-robust SE (hh\\_id) in parentheses. Reference category: ",
           "pure\\_owner (own\\_share=1, $\\beta \\equiv 0$). own\\_bin fixed at 2018 baseline ",
           "(time-invariant per-hh). unit\\_rent\\_price defined only for renter-obs ",
           "(area\\_rent$>0$). Scenario classification: ", scenario, ". ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")
  else
    paste0("괄호 안 클러스터 강건 SE (hh\\_id). 기준 카테고리: ",
           "전순자작 (own\\_share=1, $\\beta \\equiv 0$). own\\_bin은 2018 기준연도 고정 ",
           "(가구별 시간불변). 단위 임차료는 임차농가 ",
           "(area\\_rent$>0$) 한정. 시나리오 분류: ", scenario, ". ",
           "* p$<$0.10, ** p$<$0.05, *** p$<$0.01.")

  tex <- sprintf(
    "\\begin{table}[t]\n\\centering\n\\caption{%s}\n\\label{tab:het_own_share_%s}\n\\begin{tabular}{lrrrrr}\n\\toprule\n%s\n\\bottomrule\n\\end{tabular}\n\\\\\n\\footnotesize\\textit{%s}\n\\end{table}\n",
    caption, lang, body, note
  )
  writeLines(tex, path, useBytes = (lang == "ko"))
}

write_het_table("en", file.path(out_dir, "tab_het_own_share_en.tex"))
write_het_table("ko", file.path(out_dir, "tab_het_own_share_ko.tex"))

message(sprintf("07_heterogeneity.R: %d cells (4 outcomes × 5 bins × 3 bw × 2 specs); scenario = %s",
                nrow(het_results), substr(scenario, 1, 50)))
