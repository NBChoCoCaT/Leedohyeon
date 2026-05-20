# =============================================================================
# 10_alpha3_estimation.R — α3 outcome hierarchy + Wave 5 deliverables.
#
# Wave 5 deliverables (per quality_reports/plans/2026-05-18_wave5-section5-alpha3-results.md):
#   W5-1  α3 outcome hierarchy re-aggregation (area_own primary #1, op_cost_ex_rent
#         primary #2, off_farm_income aux, unit_rent_price + rent_cost ex-theory)
#   W5-2  T1/T3 4-bin cells for area_own (already in heterogeneity_results;
#         extract + reformat)
#   W5-3  F2: off_farm_income 4-bin × 3-bandwidth (NEW estimation)
#   W5-4  SC2.5 sub-threshold-mass cross-tab — wealth proxy = farm_income_2018
#         - debt_total_2018 (clean.rds-only; full net-worth deferred)
#   W5-5  HonestDiD M̄ sensitivity bounds on β_1 (area_own) + β_3 (op_cost_ex_rent)
#   W5-6  Differential-attrition placebo: rdrobust(1[n_years==5] ~ rv_2018)
#   W5-7  Take-up rate + hired-labor share descriptive
#
# Inputs:
#   _outputs/clean.rds                  — 14,474 × 50 panel
#   _outputs/main_results.rds           — DiD-RD main (4 outcomes × 8 specs)
#   _outputs/heterogeneity_results.rds  — 4-bin × 3-bw × 4 outcomes grid
#   _outputs/channels_results.rds       — channel decomposition + pass-through
#
# Outputs (all under scripts/R/_outputs/):
#   alpha3_results.rds                  — mega-file (10 named components)
#   tab_alpha3_results_{en,ko}.tex      — §5 main results table
#   fig_f1_fourbin_gradient_T2_en.{pdf,png}
#   fig_honestdid_sensitivity_b1_en.{pdf,png}
#   replication_check.txt               — UPDATED with α3 cells
#   alpha3_log.txt                      — per-phase verification log
#
# Spec contracts (r-code-conventions.md):
#   §1  set.seed(20260504L) at top
#   §10 cluster = hh_id (primary), sgg_cd (robustness reserved)
#   §11 figures: pdf for paper, png for slides (transparent bg)
#   §12 sessionInfo() write at end
#   §13 modelsummary bilingual tex
#
# Plan: quality_reports/plans/2026-05-18_wave5-section5-alpha3-results.md
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(tibble); library(purrr); library(stringr)
  library(haven); library(fixest); library(rdrobust); library(sandwich); library(broom)
  library(modelsummary); library(ggplot2)
  library(HonestDiD)
  library(readr); library(fs); library(here)
})

set.seed(20260504L)

out_dir <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else
              here::here("scripts", "R", "_outputs")
log_path <- file.path(out_dir, "alpha3_log.txt")
log_lines <- character()
log_msg <- function(...) {
  msg <- sprintf("[%s] %s", format(Sys.time(), "%H:%M:%S"), paste0(..., collapse = ""))
  cat(msg, "\n")
  log_lines <<- c(log_lines, msg)
}

log_msg("====================  10_alpha3_estimation.R START  ====================")
log_msg("R version: ", R.version$version.string)

# ---------------------------------------------------------------------------- #
# Phase 0 — Load inputs                                                        #
# ---------------------------------------------------------------------------- #

clean_panel <- readRDS(file.path(out_dir, "clean.rds")) |>
  mutate(across(where(haven::is.labelled), haven::zap_labels))
main_res <- readRDS(file.path(out_dir, "main_results.rds"))
het_res  <- readRDS(file.path(out_dir, "heterogeneity_results.rds"))
chan_res <- readRDS(file.path(out_dir, "channels_results.rds"))

log_msg(sprintf("Phase 0: loaded inputs. panel %d rows × %d cols.",
                nrow(clean_panel), ncol(clean_panel)))

# Construct own_bin from 2018 baseline (mirrors 07_heterogeneity.R Phase 1).
own_bin_baseline <- clean_panel |>
  filter(year == 2018L) |>
  transmute(
    hh_id,
    own_bin = case_when(
      own_share == 0   ~ "1_pure_tenant",
      own_share < 0.3  ~ "2_low_owner",
      own_share < 0.7  ~ "3_mixed",
      own_share < 1    ~ "4_high_owner",
      own_share == 1   ~ "5_pure_owner",
      TRUE             ~ NA_character_
    ),
    farm_income_2018 = farm_income,
    debt_total_2018  = debt_total
  )
panel <- clean_panel |>
  left_join(own_bin_baseline, by = "hh_id") |>
  mutate(own_bin = factor(own_bin, levels = c(
    "1_pure_tenant", "2_low_owner", "3_mixed", "4_high_owner", "5_pure_owner"
  )))

# ---------------------------------------------------------------------------- #
# Phase 1 (W5-1 + W5-2) — α3 outcome hierarchy re-aggregation                  #
# ---------------------------------------------------------------------------- #
# area_own primary #1: extract from het_results (already 4-bin × 3-bw).        #
# op_cost_ex_rent primary #2: in main_results POOLED; needs 4-bin extension    #
# (Phase 3). For now record pooled cells.                                      #
# Ex-theory: unit_rent_price, rent_cost from het_results.                      #
# ---------------------------------------------------------------------------- #

area_own_grid <- het_res$het_results |>
  filter(outcome == "area_own", spec == "A") |>
  select(own_bin, bw_id, h, estimate, std.error, p.value, n_obs)

log_msg(sprintf("Phase 1: area_own 4-bin × T1/T2/T3 grid extracted (%d rows).",
                nrow(area_own_grid)))

op_cost_pooled <- main_res$results |>
  filter(outcome == "op_cost", spec == "A") |>
  select(bw_id, h, n_obs, estimate, se_cluster, p_cluster, se_wild, p_wild)

unit_rent_grid <- het_res$het_results |>
  filter(outcome == "unit_rent_price", spec == "A") |>
  select(own_bin, bw_id, h, estimate, std.error, p.value, n_obs)

rent_cost_grid <- het_res$het_results |>
  filter(outcome == "rent_cost", spec == "A") |>
  select(own_bin, bw_id, h, estimate, std.error, p.value, n_obs)

# ---------------------------------------------------------------------------- #
# Phase 2 (W5-3) — F2 off_farm_income 4-bin × 3-bandwidth (NEW estimation)     #
# ---------------------------------------------------------------------------- #
# rdrobust at h ∈ {500, 1000, MSE} for each own_bin.                            #
# Cluster via fixest with cluster=~hh_id; wild bootstrap deferred to robustness#
# (sandwich::vcovBS path mirroring 09_wild_bootstrap.R).                       #
# ---------------------------------------------------------------------------- #

bw_grid <- tribble(
  ~bw_id, ~h_value,
  "T1",   500,
  "T2",   1000,
  "T3",   NA_real_   # MSE-optimal via rdrobust(bwselect="mserd")
)

estimate_offfarm_cell <- function(bin_label, bw_label, h_value, df) {
  sub <- df |> filter(own_bin == bin_label, !is.na(off_farm_income), !is.na(rv_2018))
  if (nrow(sub) < 50L) {
    return(tibble(own_bin = bin_label, bw_id = bw_label, h = h_value,
                  estimate = NA_real_, std.error = NA_real_, p.value = NA_real_,
                  n_obs = nrow(sub), note = "n<50, skipped"))
  }
  fit <- tryCatch({
    if (is.na(h_value)) {
      rdrobust(y = sub$off_farm_income, x = sub$rv_2018, cluster = sub$hh_id,
               bwselect = "mserd")
    } else {
      rdrobust(y = sub$off_farm_income, x = sub$rv_2018, cluster = sub$hh_id,
               h = h_value)
    }
  }, error = function(e) NULL)
  if (is.null(fit)) {
    return(tibble(own_bin = bin_label, bw_id = bw_label, h = h_value,
                  estimate = NA_real_, std.error = NA_real_, p.value = NA_real_,
                  n_obs = nrow(sub), note = "rdrobust error"))
  }
  tibble(
    own_bin = bin_label, bw_id = bw_label,
    h = ifelse(is.na(h_value), fit$bws[1L,1L], h_value),
    estimate = fit$Estimate[1L,1L],
    std.error = fit$se[1L,1L],
    p.value = fit$pv[1L,1L],
    n_obs = sum(fit$N_h),
    note = ""
  )
}

bin_levels <- levels(panel$own_bin)
offfarm_grid <- expand_grid(
  own_bin = bin_levels,
  bw_id   = bw_grid$bw_id
) |>
  left_join(bw_grid, by = "bw_id") |>
  pmap_dfr(function(own_bin, bw_id, h_value) {
    estimate_offfarm_cell(own_bin, bw_id, h_value, panel)
  })

log_msg(sprintf("Phase 2 (W5-3): off_farm_income 4-bin × 3-bw grid estimated (%d cells, %d with valid estimates).",
                nrow(offfarm_grid), sum(!is.na(offfarm_grid$estimate))))

# ---------------------------------------------------------------------------- #
# Phase 3 — op_cost_ex_rent 4-bin × 3-bw (NEW estimation; supplements W5-1)     #
# ---------------------------------------------------------------------------- #
# main_results has op_cost (with rent) pooled; we need op_cost_ex_rent 4-bin.  #
# Same estimation pattern as offfarm.                                          #
# ---------------------------------------------------------------------------- #

estimate_opcost_cell <- function(bin_label, bw_label, h_value, df) {
  sub <- df |> filter(own_bin == bin_label, !is.na(op_cost_ex_rent), !is.na(rv_2018))
  if (nrow(sub) < 50L) {
    return(tibble(own_bin = bin_label, bw_id = bw_label, h = h_value,
                  estimate = NA_real_, std.error = NA_real_, p.value = NA_real_,
                  n_obs = nrow(sub), note = "n<50, skipped"))
  }
  fit <- tryCatch({
    if (is.na(h_value)) {
      rdrobust(y = sub$op_cost_ex_rent, x = sub$rv_2018, cluster = sub$hh_id,
               bwselect = "mserd")
    } else {
      rdrobust(y = sub$op_cost_ex_rent, x = sub$rv_2018, cluster = sub$hh_id,
               h = h_value)
    }
  }, error = function(e) NULL)
  if (is.null(fit)) {
    return(tibble(own_bin = bin_label, bw_id = bw_label, h = h_value,
                  estimate = NA_real_, std.error = NA_real_, p.value = NA_real_,
                  n_obs = nrow(sub), note = "rdrobust error"))
  }
  tibble(
    own_bin = bin_label, bw_id = bw_label,
    h = ifelse(is.na(h_value), fit$bws[1L,1L], h_value),
    estimate = fit$Estimate[1L,1L],
    std.error = fit$se[1L,1L],
    p.value = fit$pv[1L,1L],
    n_obs = sum(fit$N_h),
    note = ""
  )
}

opcost_grid <- expand_grid(
  own_bin = bin_levels,
  bw_id   = bw_grid$bw_id
) |>
  left_join(bw_grid, by = "bw_id") |>
  pmap_dfr(function(own_bin, bw_id, h_value) {
    estimate_opcost_cell(own_bin, bw_id, h_value, panel)
  })

log_msg(sprintf("Phase 3: op_cost_ex_rent 4-bin × 3-bw grid estimated (%d cells, %d valid).",
                nrow(opcost_grid), sum(!is.na(opcost_grid$estimate))))

# ---------------------------------------------------------------------------- #
# Phase 4 (W5-4) — SC2.5 sub-threshold-mass cross-tab                           #
# ---------------------------------------------------------------------------- #
# Wealth proxy W_i = farm_income_2018 - debt_total_2018 (clean.rds-only).      #
# W_i* threshold: empirical median wealth among treated pure-tenant households #
# at the eligibility margin (proxy for the indifference-condition wealth       #
# threshold from §B.1 eq:appB-threshold).                                      #
# Cross-tab Pr(W_i < W_i^* | own_bin ∈ k) for 4 bins × 2 bandwidths {500, 1000}#
# ---------------------------------------------------------------------------- #

baseline_wealth <- panel |>
  filter(year == 2018L) |>
  mutate(W_i = farm_income_2018 - debt_total_2018) |>
  select(hh_id, own_bin, W_i, rv_2018)

# W_i* = median wealth among pure-tenant treated households within h=1000 m².
W_star <- baseline_wealth |>
  filter(own_bin == "1_pure_tenant", abs(rv_2018) <= 1000, W_i > 0) |>
  pull(W_i) |>
  median(na.rm = TRUE)
log_msg(sprintf("Phase 4 (W5-4): W_i* threshold (pure-tenant median wealth at |rv|<=1000) = %.0f KRW",
                W_star))

sc25_mass <- expand_grid(
  own_bin = bin_levels,
  bw_h    = c(500, 1000)
) |>
  pmap_dfr(function(own_bin, bw_h) {
    bin_label <- own_bin
    sub <- baseline_wealth |>
      filter(own_bin == bin_label, abs(rv_2018) <= bw_h)
    tibble(
      own_bin = bin_label, bandwidth_h = bw_h,
      n = nrow(sub),
      n_below_threshold = sum(sub$W_i < W_star, na.rm = TRUE),
      p_below = mean(sub$W_i < W_star, na.rm = TRUE),
      mean_W = mean(sub$W_i, na.rm = TRUE),
      median_W = median(sub$W_i, na.rm = TRUE)
    )
  })

log_msg(sprintf("Phase 4 (W5-4): SC2.5 cross-tab (%d rows). Monotonicity check at h=1000: %s",
                nrow(sc25_mass),
                paste(round(sc25_mass$p_below[sc25_mass$bandwidth_h == 1000L], 3),
                      collapse = " > ")))

# ---------------------------------------------------------------------------- #
# Phase 5 (W5-5) — HonestDiD M̄ sensitivity bounds on β_1, β_3                  #
# ---------------------------------------------------------------------------- #
# Approach: extract DiD coefficients on (Post × D_treat) at T2 spec A for      #
# area_own (β_1 proxy via heterogeneity_results pooled estimate) and op_cost_  #
# ex_rent (β_3 proxy). Construct event-study pre-periods (2018 baseline, 2019  #
# pre-trend) and run HonestDiD::createSensitivityResults_relativeMagnitudes.   #
# Output: M̄* (breakdown M̄ at which 95% CI for β_k stops containing 0).         #
# Note: with only 1 effective pre-period (2018 → 2019), HonestDiD bounds are   #
# conservative; we report bounds at Mbar ∈ {0.5, 1, 1.5, 2}.                    #
# ---------------------------------------------------------------------------- #

# Build event-study coefficients for area_own at T2 (h=1000) via fixest.
# Specification: feols(area_own ~ i(year, D_treat, ref=2019) | hh_id + year,
#                       data, cluster=~hh_id, subset = |rv_2018|<=1000)
log_msg("Phase 5 (W5-5): HonestDiD event-study setup for β_1 (area_own) and β_3 (op_cost_ex_rent).")

honestdid_results <- list()
for (outcome_var in c("area_own", "op_cost_ex_rent")) {
  formula_str <- sprintf("%s ~ i(year, D_treat, ref=2019) | hh_id + year", outcome_var)
  es_fit <- tryCatch(
    fixest::feols(as.formula(formula_str),
                  data = panel |> filter(abs(rv_2018) <= 1000),
                  cluster = ~hh_id),
    error = function(e) NULL
  )
  if (is.null(es_fit)) {
    log_msg("  ", outcome_var, ": event-study fit FAILED, skipping HonestDiD")
    honestdid_results[[outcome_var]] <- NULL
    next
  }
  # Extract coefficients: pre-periods (2018) and post-periods (2020-2022) treatment effects
  coef_full <- coef(es_fit)
  vcov_full <- vcov(es_fit, cluster = ~hh_id)
  # Identify which entries correspond to year×D_treat interactions
  beta_idx <- grep("year::.*:D_treat", names(coef_full))
  if (length(beta_idx) < 3L) {
    log_msg("  ", outcome_var, ": too few event-time coefs (", length(beta_idx), "), skipping HonestDiD")
    honestdid_results[[outcome_var]] <- NULL
    next
  }
  betahat <- coef_full[beta_idx]
  sigma   <- vcov_full[beta_idx, beta_idx]
  # Identify periods (relative to 2019 ref). 2018 = -1 pre, 2020/2021/2022 = +1/+2/+3 post.
  years_in_fit <- as.integer(stringr::str_extract(names(betahat), "[0-9]+"))
  pre_periods  <- which(years_in_fit < 2019L)
  post_periods <- which(years_in_fit > 2019L)
  if (length(pre_periods) < 1L || length(post_periods) < 1L) {
    log_msg("  ", outcome_var, ": pre/post split failed, skipping HonestDiD")
    honestdid_results[[outcome_var]] <- NULL
    next
  }
  numPrePeriods <- length(pre_periods)
  numPostPeriods <- length(post_periods)
  # HonestDiD sensitivity bounds via relative-magnitudes approach
  hdid_bounds <- tryCatch(
    HonestDiD::createSensitivityResults_relativeMagnitudes(
      betahat = betahat,
      sigma   = sigma,
      numPrePeriods = numPrePeriods,
      numPostPeriods = numPostPeriods,
      Mbarvec = c(0, 0.5, 1, 1.5, 2),
      method  = "C-LF"   # C-LF (preferred for relative-magnitudes; FLCI is for absolute-bounds)
    ),
    error = function(e) {log_msg("    HonestDiD error: ", conditionMessage(e)); NULL}
  )
  honestdid_results[[outcome_var]] <- list(
    es_coefs   = betahat,
    es_vcov    = sigma,
    hdid       = hdid_bounds,
    numPrePeriods = numPrePeriods,
    numPostPeriods = numPostPeriods
  )
  if (!is.null(hdid_bounds)) {
    log_msg(sprintf("  %s: HonestDiD bounds computed (%d pre + %d post periods)",
                    outcome_var, numPrePeriods, numPostPeriods))
  }
}

# ---------------------------------------------------------------------------- #
# Phase 6 (W5-6) — Differential-attrition placebo                              #
# ---------------------------------------------------------------------------- #
# Build full-panel flag at the household level (n_years==5).                   #
# rdrobust(full_panel ~ rv_2018) — null is no discontinuity at cutoff.         #
# ---------------------------------------------------------------------------- #

attrition_df <- panel |>
  filter(year == 2018L) |>
  group_by(hh_id) |>
  summarise(
    n_years_observed = first(n_years),
    rv_2018 = first(rv_2018),
    .groups = "drop"
  ) |>
  mutate(full_panel = as.integer(n_years_observed == 5L))

attrition_rdrobust <- tryCatch(
  rdrobust(y = attrition_df$full_panel, x = attrition_df$rv_2018,
           cluster = attrition_df$hh_id, h = 1000),
  error = function(e) {log_msg("Phase 6: attrition rdrobust error: ", conditionMessage(e)); NULL}
)

attrition_placebo <- if (!is.null(attrition_rdrobust)) {
  tibble(
    estimate = attrition_rdrobust$Estimate[1L,1L],
    std.error = attrition_rdrobust$se[1L,1L],
    p.value = attrition_rdrobust$pv[1L,1L],
    n_obs = sum(attrition_rdrobust$N_h),
    bandwidth_h = 1000
  )
} else {
  tibble(estimate=NA_real_, std.error=NA_real_, p.value=NA_real_, n_obs=NA_integer_, bandwidth_h=1000)
}

log_msg(sprintf("Phase 6 (W5-6): attrition placebo — estimate %.4f (p=%.3f, n=%d)",
                attrition_placebo$estimate, attrition_placebo$p.value, attrition_placebo$n_obs))

# ---------------------------------------------------------------------------- #
# Phase 7 (W5-7) — Take-up rate + hired-labor share descriptives                #
# ---------------------------------------------------------------------------- #
# Take-up: among treated (D_treat==1) and post-period, share with imputed_     #
# payment > 0 (proxies actual SFFP receipt; CLAUDE.md cites 92.3%).             #
# Hired-labor share: not directly in clean.rds; reported in §3.4.1 as 17–34%   #
# from FHES Wave 1. Use placeholder unless raw CSV inspection reveals it.      #
# ---------------------------------------------------------------------------- #

take_up <- panel |>
  filter(D_treat == 1L, Post == 1L) |>
  summarise(
    take_up_rate = mean(imputed_payment > 0, na.rm = TRUE),
    n = sum(imputed_payment > 0, na.rm = TRUE),
    n_eligible = n()
  )
log_msg(sprintf("Phase 7 (W5-7): take_up_rate = %.3f (%.1f%%) among D_treat==1 & Post==1 (n_eligible=%d)",
                take_up$take_up_rate, 100 * take_up$take_up_rate, take_up$n_eligible))

# Hired-labor share: not present in clean.rds Wave 5 scope; defer to §3.4.1 footnote
# documenting that the 17–34% range is taken from FHES Wave 1 raw 농가수지 reporting
# and currently a placeholder pending CSV-merge extension.
hired_labor <- tibble(
  note = "Placeholder: 17-34% range from FHES Wave 1 raw 농가수지; CSV-merge deferred to post-Wave-5 build-out."
)

# ---------------------------------------------------------------------------- #
# Phase 8 — F1 monotonicity check + headline-gating decision                   #
# ---------------------------------------------------------------------------- #
# F1 fires iff (i) p(β_2 > 0) > .10 at T2 AND (ii) four-bin monotone broken at #
# T2. Operationalize using area_own at T2.                                     #
# ---------------------------------------------------------------------------- #

area_own_T2 <- area_own_grid |>
  filter(bw_id == "T2") |>
  arrange(own_bin)

# Check (i): pure_tenant estimate significantly positive at T2 (proxy for β_2)
p_pure_tenant_T2 <- area_own_T2 |> filter(own_bin == "1_pure_tenant") |> pull(p.value)
# Check (ii): monotone-decreasing in own_bin (1 > 2 > 3 > 4 > 5)
est_T2 <- area_own_T2$estimate
monotone_T2 <- all(diff(est_T2) <= 0)

F1_fires <- (p_pure_tenant_T2 > 0.10) && !monotone_T2  # strict-AND boolean trigger
log_msg(sprintf("Phase 8 F1 check at T2: p_pure_tenant=%.4f, monotone=%s → F1_fires=%s",
                p_pure_tenant_T2, monotone_T2, F1_fires))

# ---------------------------------------------------------------------------- #
# Phase 9 — Save alpha3_results.rds mega-file                                  #
# ---------------------------------------------------------------------------- #

alpha3_results <- list(
  # W5-1 + W5-2: extracted 4-bin × 3-bw grids
  area_own_grid       = area_own_grid,
  unit_rent_grid      = unit_rent_grid,
  rent_cost_grid      = rent_cost_grid,
  op_cost_pooled      = op_cost_pooled,
  # W5-3: F2 off_farm_income (new estimation)
  offfarm_grid        = offfarm_grid,
  # Phase 3 supplement: op_cost_ex_rent 4-bin × 3-bw
  opcost_exrent_grid  = opcost_grid,
  # W5-4: SC2.5 sub-threshold-mass + W_i* threshold
  sc25_mass           = sc25_mass,
  W_star              = W_star,
  # W5-5: HonestDiD
  honestdid_results   = honestdid_results,
  # W5-6: attrition placebo
  attrition_placebo   = attrition_placebo,
  attrition_panel     = attrition_df,
  # W5-7: take-up + hired-labor
  take_up             = take_up,
  hired_labor         = hired_labor,
  # Phase 8 F1 trigger
  F1_status = list(
    F1_fires = F1_fires,
    p_pure_tenant_T2 = p_pure_tenant_T2,
    monotone_T2 = monotone_T2,
    area_own_T2_estimates = est_T2
  ),
  # Provenance
  notes = list(
    framework = "α3 AHM-extension",
    seed = 20260504L,
    wealth_proxy_formula = "W_i = farm_income_2018 - debt_total_2018 (clean.rds-only; full net-worth deferred)",
    own_bin_breakpoints = "0 / 0.3 / 0.7 / 1 (5 bins; per 07_heterogeneity.R Phase 1)",
    F1_decision_rule = "strict-AND: (p_pure_tenant > .10 at T2) AND (monotone broken at T2)",
    script = "10_alpha3_estimation.R",
    plan = "quality_reports/plans/2026-05-18_wave5-section5-alpha3-results.md"
  )
)

saveRDS(alpha3_results, file.path(out_dir, "alpha3_results.rds"))
log_msg("Phase 9: alpha3_results.rds saved.")

# ---------------------------------------------------------------------------- #
# Phase 10 — Figures                                                            #
# ---------------------------------------------------------------------------- #
# fig_f1_fourbin_gradient_T2_en.{pdf,png}                                       #
# fig_honestdid_sensitivity_b1_en.{pdf,png}                                     #
# ---------------------------------------------------------------------------- #

primary_blue  <- "#012169"
primary_gold  <- "#f2a900"
accent_gray   <- "#525252"
negative_red  <- "#b91c1c"

theme_pidps <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", color = primary_blue),
      legend.position = "bottom",
      panel.grid.minor = element_blank()
    )
}

# Figure 1: F1 four-bin gradient at T2 (bar chart with 95% CI)
fig_data <- area_own_T2 |>
  mutate(
    own_bin_label = factor(own_bin, levels = bin_levels,
                           labels = c("Pure\ntenant\n(s=0)", "Low\nowner\n(0<s<.3)",
                                      "Mixed\n(.3<=s<.7)", "High\nowner\n(.7<=s<1)",
                                      "Pure\nowner\n(s=1)")),
    ci_lo = estimate - 1.96 * std.error,
    ci_hi = estimate + 1.96 * std.error,
    is_significant = p.value < 0.10
  )
fig_f1 <- ggplot(fig_data, aes(x = own_bin_label, y = estimate, fill = is_significant)) +
  geom_col(width = 0.7) +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0.2) +
  geom_hline(yintercept = 0, color = accent_gray, linewidth = 0.4) +
  scale_fill_manual(values = c("TRUE" = primary_blue, "FALSE" = accent_gray),
                    labels = c("TRUE" = "p < .10", "FALSE" = "p >= .10"),
                    name = NULL) +
  labs(
    title = "F1: Four-bin tenancy gradient on own-cultivated area",
    subtitle = "T2 bandwidth (h = 1,000 m²)",
    x = NULL,
    y = expression(hat(beta)[1]~"  (m²)"),
    caption = "Source: FHES Wave 1, 2018-2022. Bars are 95% CIs from cluster-robust SE (hh_id)."
  ) +
  theme_pidps() +
  theme(plot.subtitle = element_text(color = "#525252"))

ggsave(file.path(out_dir, "fig_f1_fourbin_gradient_T2_en.pdf"),
       plot = fig_f1, width = 7.5, height = 4.5, bg = "white")
ggsave(file.path(out_dir, "fig_f1_fourbin_gradient_T2_en.png"),
       plot = fig_f1, width = 7.5, height = 4.5, dpi = 300, bg = "transparent")
log_msg("Phase 10: fig_f1_fourbin_gradient_T2_en.{pdf,png} saved.")

# Figure 2: HonestDiD sensitivity for β_1 (area_own)
if (!is.null(honestdid_results$area_own$hdid)) {
  hdid_b1 <- honestdid_results$area_own$hdid
  fig_hdid <- ggplot(hdid_b1, aes(x = Mbar, y = lb, ymin = lb, ymax = ub)) +
    geom_errorbar(width = 0.05, color = primary_blue) +
    geom_point(aes(y = (lb + ub) / 2), color = primary_blue, size = 1.5) +
    geom_hline(yintercept = 0, color = negative_red, linewidth = 0.4, linetype = "dashed") +
    labs(
      title = expression("HonestDiD "~bar(M)~" sensitivity bounds: "~beta[1]~" (area_own, T2)"),
      x = expression(bar(M)~"  (linear-trend bias bound)"),
      y = expression("95% CI for "~beta[1]~"  (m"^2*")"),
      caption = expression("Rambachan & Roth (2023). "~bar(M)~" = 0 is original DiD; "~bar(M)~"* is breakdown bound where CI excludes 0.")
    ) +
    theme_pidps()
  ggsave(file.path(out_dir, "fig_honestdid_sensitivity_b1_en.pdf"),
         plot = fig_hdid, width = 7.5, height = 4.5, bg = "white")
  ggsave(file.path(out_dir, "fig_honestdid_sensitivity_b1_en.png"),
         plot = fig_hdid, width = 7.5, height = 4.5, dpi = 300, bg = "transparent")
  log_msg("Phase 10: fig_honestdid_sensitivity_b1_en.{pdf,png} saved.")
} else {
  log_msg("Phase 10: HonestDiD area_own bounds unavailable; figure skipped.")
}

# ---------------------------------------------------------------------------- #
# Phase 11 — Main results table (modelsummary or manual tex)                   #
# ---------------------------------------------------------------------------- #

# Combine area_own + op_cost_ex_rent + off_farm_income 4-bin × T1/T2/T3 into
# a single paper-grade table.
combined_grid <- bind_rows(
  area_own_grid       |> mutate(outcome = "area_own"),
  opcost_grid         |> mutate(outcome = "op_cost_ex_rent") |>
                         select(own_bin, bw_id, h, estimate, std.error, p.value, n_obs, outcome),
  offfarm_grid        |> mutate(outcome = "off_farm_income") |>
                         select(own_bin, bw_id, h, estimate, std.error, p.value, n_obs, outcome)
) |>
  select(outcome, own_bin, bw_id, h, estimate, std.error, p.value, n_obs)

# Write a simple tex table manually (modelsummary not optimal for this grid shape).
# Bilingual: lang ∈ {"en", "ko"} — outcome / bin labels translated for KO; codes
# (area_own, op_cost_ex_rent) stay English for cross-reference with R variable names.
outcome_label_ko <- c(
  area_own         = "자작 면적 (m\\textsuperscript{2})",
  op_cost_ex_rent  = "농업경영비 (임차료 제외, 원)",
  off_farm_income  = "농외소득 (원)"
)
bin_label_ko <- c(
  "1_pure_tenant" = "1\\_순임차",
  "2_low_owner"   = "2\\_저소유",
  "3_mixed"       = "3\\_혼합",
  "4_high_owner"  = "4\\_고소유",
  "5_pure_owner"  = "5\\_순소유"
)

write_alpha3_table <- function(grid, lang, path) {
  con <- file(path, "w")
  on.exit(close(con))
  cat("% Auto-generated by 10_alpha3_estimation.R — do not edit by hand.\n", file = con)
  cat("% Wave 5 α3 outcome hierarchy: 3 outcomes × 5 bins × 3 bandwidths.\n", file = con)
  cat("\\begin{tabular}{lllrrr}\n", file = con)
  cat("\\toprule\n", file = con)
  header <- if (lang == "ko") "결과변수 & Bin & BW & 추정치 & SE & p \\\\\n"
            else              "Outcome & Bin & BW & Estimate & SE & p \\\\\n"
  cat(header, file = con)
  cat("\\midrule\n", file = con)
  for (i in seq_len(nrow(grid))) {
    row <- grid[i, ]
    outcome_disp <- if (lang == "ko" && !is.null(outcome_label_ko[[row$outcome]]))
                       outcome_label_ko[[row$outcome]]
                    else gsub("_", "\\\\_", row$outcome)
    bin_disp <- if (lang == "ko" && !is.null(bin_label_ko[[row$own_bin]]))
                   bin_label_ko[[row$own_bin]]
                else gsub("_", "\\\\_", row$own_bin)
    line <- sprintf("%s & %s & %s & %.2f & %.2f & %.3f \\\\\n",
                    outcome_disp, bin_disp, row$bw_id,
                    row$estimate, row$std.error, row$p.value)
    cat(line, file = con)
  }
  cat("\\bottomrule\n", file = con)
  cat("\\end{tabular}\n", file = con)
}

write_alpha3_table(combined_grid, "en", file.path(out_dir, "tab_alpha3_results_en.tex"))
write_alpha3_table(combined_grid, "ko", file.path(out_dir, "tab_alpha3_results_ko.tex"))
log_msg("Phase 11: tab_alpha3_results_{en,ko}.tex saved.")

# ---------------------------------------------------------------------------- #
# Phase 12 — Replication check update                                          #
# ---------------------------------------------------------------------------- #
# Add α3 cells to replication_check.txt: cross-validate area_own pure_tenant   #
# T2 against the +1,089 m² (p=.033) headline benchmark (area-only baseline).   #
# ---------------------------------------------------------------------------- #

ledger_lines <- c(
  "",
  "================================================================================",
  paste0("[α3 cross-check] ", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
  "Source: 10_alpha3_estimation.R; comparison vs area-only baseline headline.",
  "================================================================================"
)
hdr_pure_tenant_T2 <- area_own_T2 |> filter(own_bin == "1_pure_tenant")
stata_truth <- list(est = 1089, p = 0.033)
diff_est <- abs(hdr_pure_tenant_T2$estimate - stata_truth$est)
diff_p   <- abs(hdr_pure_tenant_T2$p.value - stata_truth$p)
ledger_lines <- c(
  ledger_lines,
  sprintf("[CHECK 1] area_own × pure_tenant × T2:"),
  sprintf("  Current R: estimate = %.2f, p = %.4f", hdr_pure_tenant_T2$estimate, hdr_pure_tenant_T2$p.value),
  sprintf("  Area-only baseline (benchmark): estimate = %.2f, p = %.4f", stata_truth$est, stata_truth$p),
  sprintf("  |diff_est| = %.4f (tol < 1.00); |diff_p| = %.4f (tol < 0.05)", diff_est, diff_p),
  sprintf("  STATUS: %s",
          if (diff_est < 1.0 && diff_p < 0.05) "PASS" else "INVESTIGATE")
)
writeLines(c(readLines(file.path(out_dir, "replication_check.txt")), ledger_lines),
           file.path(out_dir, "replication_check.txt"))
log_msg("Phase 12: replication_check.txt updated.")

# ---------------------------------------------------------------------------- #
# Phase 13 — sessionInfo + log dump                                            #
# ---------------------------------------------------------------------------- #

writeLines(capture.output(sessionInfo()), file.path(out_dir, "sessionInfo.txt"))
log_msg("====================  10_alpha3_estimation.R DONE  ====================")
writeLines(log_lines, log_path)
