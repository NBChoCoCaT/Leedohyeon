# P3b pre-check: CH4 (tenancy) + CH3 (attrition) + n_years + own_share
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(haven)
})
df <- readRDS("scripts/R/_outputs/clean.rds") |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

sep <- function() cat(strrep("=", 68), "\n", sep="")
hdr <- function(t) { sep(); cat(t, "\n"); sep(); cat("\n") }

hdr("PRE-CHECK 1: CH4 VIABILITY (tenancy rates)")
df18 <- df |> dplyr::filter(year == 2018L)
n_trt <- sum(df18$D_treat == 1L); n_ctrl <- sum(df18$D_treat == 0L)
cat(sprintf("Baseline (2018) sample: N=%d (treated=%d, control=%d)\n\n",
            nrow(df18), n_trt, n_ctrl))

trt_arearent <- mean(df18$area_rent[df18$D_treat == 1L] > 0, na.rm = TRUE)
trt_ownshare <- mean(df18$own_share[df18$D_treat == 1L] < 1, na.rm = TRUE)
trt_owner    <- mean(df18$own_share[df18$D_treat == 1L] == 1, na.rm = TRUE)
trt_tenant   <- mean(df18$own_share[df18$D_treat == 1L] == 0, na.rm = TRUE)
n_rent_pos   <- sum(df18$area_rent[df18$D_treat == 1L] > 0, na.rm = TRUE)

cat("--- TREATED (D=1, ≤0.5ha, N=", n_trt, ") ---\n", sep="")
cat(sprintf("  area_rent > 0       : %.3f (%d / %d)\n", trt_arearent, n_rent_pos, n_trt))
cat(sprintf("  own_share < 1       : %.3f (any tenancy)\n", trt_ownshare))
cat(sprintf("  own_share == 1      : %.3f (pure owner)\n", trt_owner))
cat(sprintf("  own_share == 0      : %.3f (pure tenant)\n", trt_tenant))

ctrl_arearent <- mean(df18$area_rent[df18$D_treat == 0L] > 0, na.rm = TRUE)
ctrl_ownshare <- mean(df18$own_share[df18$D_treat == 0L] < 1, na.rm = TRUE)
cat("\n--- CONTROL (D=0, >0.5ha, N=", n_ctrl, ") ---\n", sep="")
cat(sprintf("  area_rent > 0       : %.3f\n", ctrl_arearent))
cat(sprintf("  own_share < 1       : %.3f\n", ctrl_ownshare))

df_near <- df18 |> dplyr::filter(abs(rv_2018) <= 1000)
nt <- mean(df_near$area_rent[df_near$D_treat == 1L] > 0, na.rm = TRUE)
nc <- mean(df_near$area_rent[df_near$D_treat == 0L] > 0, na.rm = TRUE)
cat("\n--- NEAR CUTOFF (|rv| ≤ 1000m², N=", nrow(df_near), ") ---\n", sep="")
cat(sprintf("  Overall             : %.3f\n", mean(df_near$area_rent > 0, na.rm = TRUE)))
cat(sprintf("  Treated  (N=%d)      : %.3f\n", sum(df_near$D_treat == 1L), nt))
cat(sprintf("  Control  (N=%d)      : %.3f\n", sum(df_near$D_treat == 0L), nc))

trt_renters <- df18 |> dplyr::filter(D_treat == 1L, area_rent > 0)
cat("\n--- rent_cost AMONG TREATED RENTERS (N=", nrow(trt_renters), ") ---\n", sep="")
if (nrow(trt_renters) > 0) {
  cat(sprintf("  mean   = %s KRW\n", formatC(mean(trt_renters$rent_cost, na.rm=TRUE), big.mark=",")))
  cat(sprintf("  median = %s KRW\n", formatC(median(trt_renters$rent_cost, na.rm=TRUE), big.mark=",")))
  cat(sprintf("  max    = %s KRW\n", formatC(max(trt_renters$rent_cost, na.rm=TRUE), big.mark=",")))
}

cat("\n--- CH4 VERDICT ---\n")
ch4_ok <- trt_arearent >= 0.10
if (ch4_ok) {
  cat(sprintf("  ✓ VIABLE: %.1f%% ≥ 10%%\n", 100*trt_arearent))
} else {
  cat(sprintf("  ✗ NOT VIABLE: %.1f%% < 10%%\n", 100*trt_arearent))
}

hdr("PRE-CHECK 2: CH3 VIABILITY (placebo attrition 2018-2019)")
attrition_pre <- df |>
  dplyr::filter(year %in% 2018:2019) |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(n_pre = dplyr::n(), D_treat = dplyr::first(D_treat),
                   .groups = "drop")
att <- attrition_pre |>
  dplyr::group_by(D_treat) |>
  dplyr::summarise(n_farms = dplyr::n(),
                   mean_n_pre = mean(n_pre),
                   pct_both = mean(n_pre == 2),
                   pct_one  = mean(n_pre == 1),
                   .groups = "drop")
print(att)

trt_both  <- att$pct_both[att$D_treat == 1L]
ctrl_both <- att$pct_both[att$D_treat == 0L]
diff_pp   <- (trt_both - ctrl_both) * 100
cat(sprintf("\nBoth 2018+2019 observed: Trt %.1f%% vs Ctrl %.1f%% (diff %.2f pp)\n",
            100*trt_both, 100*ctrl_both, diff_pp))

cat("\n--- CH3 VERDICT ---\n")
ch3_ok <- abs(diff_pp) < 2
if (ch3_ok) {
  cat(sprintf("  ✓ VIABLE: |diff| = %.2f pp < 2 pp\n", abs(diff_pp)))
} else {
  cat(sprintf("  ⚠ CAUTIOUS: |diff| = %.2f pp ≥ 2 pp (need Lee bounds)\n", abs(diff_pp)))
}

near_att <- df |>
  dplyr::filter(year %in% 2018:2019, abs(rv_2018) <= 1000) |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(n_pre = dplyr::n(), D_treat = dplyr::first(D_treat), .groups = "drop") |>
  dplyr::group_by(D_treat) |>
  dplyr::summarise(n_farms = dplyr::n(), pct_both = mean(n_pre == 2), .groups = "drop")
cat("\nNear-cutoff attrition:\n")
print(near_att)

hdr("PRE-CHECK 3: n_years DISTRIBUTION (exit indicator)")
ny <- df |>
  dplyr::group_by(hh_id) |>
  dplyr::summarise(n_years = dplyr::n_distinct(year),
                   D_treat = dplyr::first(D_treat), .groups = "drop")
ny_tab <- ny |>
  dplyr::group_by(D_treat, n_years) |>
  dplyr::summarise(n = dplyr::n(), .groups = "drop") |>
  tidyr::pivot_wider(names_from = D_treat, values_from = n,
                     names_prefix = "D=", values_fill = 0L)
print(ny_tab)

cat(sprintf("\nExit (n_years<5): %d / %d (%.1f%%)\n",
            sum(ny$n_years < 5), nrow(ny), 100*mean(ny$n_years < 5)))

exit_by_D <- ny |>
  dplyr::group_by(D_treat) |>
  dplyr::summarise(exit_rate = mean(n_years < 5), n_total = dplyr::n(), .groups = "drop")
cat("\nExit rate by D:\n")
print(exit_by_D)

hdr("PRE-CHECK 4: own_share DISTRIBUTION (heterogeneity dimension)")
cat("Treated (D=1, baseline 2018) own_share summary:\n")
print(summary(df18$own_share[df18$D_treat == 1L]))

own_bins <- df18 |>
  dplyr::filter(D_treat == 1L) |>
  dplyr::mutate(bin = dplyr::case_when(
    own_share == 0   ~ "1. pure tenant (=0)",
    own_share < 0.3  ~ "2. (0, 0.3)",
    own_share < 0.7  ~ "3. [0.3, 0.7)",
    own_share < 1    ~ "4. [0.7, 1)",
    own_share == 1   ~ "5. pure owner (=1)",
    TRUE             ~ NA_character_
  )) |>
  dplyr::count(bin)
cat("\nDiscretized own_share bins (Treated):\n")
print(own_bins)

hdr("SCENARIO MAPPING")
if (ch4_ok && ch3_ok) {
  cat("→ SCENARIO 1 (CH4 ✓ + CH3 ✓): AJAE/JAE framework\n")
  cat("   P3b: CH4 → CH3 → heterogeneity → Wild bootstrap\n")
} else if (ch4_ok && !ch3_ok) {
  cat("→ SCENARIO 2 (CH4 ✓ + CH3 ✗): ERAE/AEPP framework\n")
  cat("   P3b: CH4 deep dive only\n")
} else if (!ch4_ok && ch3_ok) {
  cat("→ SCENARIO 3 (CH4 ✗ + CH3 ✓): Food Policy framework\n")
  cat("   P3b: CH3 retention narrative\n")
} else {
  cat("→ SCENARIO 4 (CH4 ✗ + CH3 ✗): Reframing required\n")
  cat("   CH2 + CH1 reinterpretation → KR journal + thesis chapter\n")
}
