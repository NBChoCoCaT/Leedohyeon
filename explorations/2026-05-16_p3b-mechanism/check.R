# P3b-1 mechanism deepening: composition vs bargaining vs market dynamics
# Three hypotheses for the −11.1% rent_cost pass-through:
#   A. Composition: area_rent ↓ → rent_cost ↓ (mechanical)
#   B. Bargaining: rent_cost / area_rent ↓ (unit price effect)
#   C. Market: external shock to 0.5ha rental market
# Plus: area_total +343-408 m² expansion finding — own vs rent decomposition

suppressPackageStartupMessages({
  library(dplyr); library(haven); library(fixest); library(broom); library(stringr)
})
df <- readRDS("scripts/R/_outputs/clean.rds") |>
  dplyr::mutate(dplyr::across(dplyr::where(haven::is.labelled), haven::zap_labels))

sep <- function() cat(strrep("=", 68), "\n", sep="")
hdr <- function(t) { sep(); cat(t, "\n"); sep(); cat("\n") }

run_did_rd <- function(y, h, df_master, spec = "A") {
  if (spec == "A") {
    sub <- df_master |> dplyr::filter(abs(rv_2018) <= h)
    fml <- as.formula(sprintf("%s ~ D_Post + rv_Post + Drv_Post | hh_id + year", y))
    DP <- "D_Post"
  }
  fit <- fixest::feols(fml, data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE)
  est <- as.numeric(coef(fit)[DP])
  se  <- as.numeric(sqrt(diag(vcov(fit)))[DP])
  G   <- dplyr::n_distinct(sub$hh_id)
  p   <- 2 * (1 - pt(abs(est / se), df = G - 1))
  tibble::tibble(y = y, h = h, est = est, se = se, p = p, n_obs = fit$nobs)
}

hdr("MECHANISM A — Composition (area_rent change)")
# area_rent: rented area in m²
res_a <- dplyr::bind_rows(
  run_did_rd("area_rent", 500, df),
  run_did_rd("area_rent", 1000, df),
  run_did_rd("area_rent", 3300, df)
)
print(res_a)
cat("\nInterpretation: area_rent β < 0 → composition (mechanical) dominates;\n")
cat("                area_rent β ≈ 0 → composition rejected, bargaining/market needed.\n\n")

hdr("MECHANISM B — Bargaining (unit rental price)")
# Construct unit price = rent_cost / area_rent (only for renters; conditional sample)
df_renters <- df |>
  dplyr::filter(area_rent > 0) |>
  dplyr::mutate(unit_rent_price = rent_cost / area_rent)
cat(sprintf("Renter-only sample N = %d obs (%d hh)\n",
            nrow(df_renters), dplyr::n_distinct(df_renters$hh_id)))
res_b <- dplyr::bind_rows(
  run_did_rd("unit_rent_price", 500, df_renters),
  run_did_rd("unit_rent_price", 1000, df_renters),
  run_did_rd("unit_rent_price", 3300, df_renters)
)
print(res_b)
cat("\nInterpretation: unit_rent_price β < 0 → bargaining hypothesis ✓\n")
cat("                Caveat: conditional sample (renters only); D-induced selection possible.\n\n")

hdr("AREA EXPANSION DECOMPOSITION (CH3 finding follow-up)")
# area_total +343-408 m² (2021-2022 events) — own vs rent?
res_total <- dplyr::bind_rows(
  run_did_rd("area_total", 500, df),
  run_did_rd("area_total", 1000, df),
  run_did_rd("area_total", 3300, df)
)
res_own <- dplyr::bind_rows(
  run_did_rd("area_own", 500, df),
  run_did_rd("area_own", 1000, df),
  run_did_rd("area_own", 3300, df)
)
res_rent_area <- res_a  # alias for clarity
cat("area_total:\n"); print(res_total)
cat("\narea_own (cultivated by self):\n"); print(res_own)
cat("\narea_rent (rented in):\n"); print(res_rent_area)

cat("\n--- Decomposition check (T3 h=3300) ---\n")
t3_total <- res_total |> dplyr::filter(h == 3300)
t3_own   <- res_own   |> dplyr::filter(h == 3300)
t3_rent  <- res_rent_area |> dplyr::filter(h == 3300)
cat(sprintf("area_total β = %.0f = area_own β (%.0f) + area_rent β (%.0f) ?\n",
            t3_total$est, t3_own$est, t3_rent$est))
cat(sprintf("Sum check: %.0f vs total %.0f (diff %.0f)\n",
            t3_own$est + t3_rent$est, t3_total$est,
            t3_total$est - (t3_own$est + t3_rent$est)))

hdr("EVENT-STUDY: area_rent + area_own + rent_cost over time (T3 only)")
# Verify whether the 2021-2022 expansion is own (자작) or rent (임차)
ev_one <- function(y) {
  sub <- df |> dplyr::filter(abs(rv_2018) <= 3300)
  fit <- fixest::feols(
    as.formula(sprintf("%s ~ i(year, D_treat, ref = 2019) | hh_id + year", y)),
    data = sub, cluster = ~hh_id, warn = FALSE, notes = FALSE
  )
  broom::tidy(fit, conf.int = TRUE) |>
    dplyr::mutate(year = as.integer(gsub(".*year::(\\d+).*", "\\1", term)),
                  y = y) |>
    dplyr::filter(!is.na(year)) |>
    dplyr::select(y, year, estimate, std.error, p.value)
}
ev_results <- dplyr::bind_rows(
  ev_one("area_total"),
  ev_one("area_own"),
  ev_one("area_rent"),
  ev_one("rent_cost")
)
for (v in c("area_total", "area_own", "area_rent", "rent_cost")) {
  cat(sprintf("\n--- %s event-study (T3 h=3300) ---\n", v))
  print(ev_results |> dplyr::filter(y == v) |> dplyr::arrange(year))
}

hdr("PRE-TRENDS CHECK (parallel trends, 2018 pre-period)")
pre_trends <- ev_results |> dplyr::filter(year == 2018)
print(pre_trends)
cat("\nParallel-trends gate: all 2018 (pre) coefficients should have |t| < 2.0\n")
cat("If 2018 coefficient |t| > 2, parallel trends violated → Roth-Rambachan sensitivity needed.\n")
