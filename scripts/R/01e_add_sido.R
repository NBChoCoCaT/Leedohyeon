# =============================================================================
# 01e_add_sido.R — Append sido_cd (행정구역시도코드) to symmetric clean.rds
#
# Phase 1 Blockers Step 5 prerequisite. FHES Wave 1 MDIS does NOT release
# sgg_cd (시군구, ~250 sub-districts); only `행정구역시도코드` (시도, 17 provinces)
# is published. We pull sido_cd from raw 원부_토지 CSV (2018 baseline) and
# attach as a household-level time-invariant covariate so 04b can run
# sido_cd × Post FE robustness.
#
# A small fraction of households may report parcels in multiple sido (cross-
# province ownership). We resolve to the modal sido per household-year.
#
# Inputs:
#   _outputs_symmetric/clean.rds (from 01d)
#   master_supporting_docs/own_drafts/rawdata/2018_원부_토지_*.csv
#
# Outputs:
#   _outputs_symmetric/clean.rds (overwritten — sido_cd column added)
#   _outputs_symmetric/sido_merge_log.txt
#
# Plan: quality_reports/plans/2026-05-20_phase1-blockers.md (Step 5 prereq)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(fs)
  library(here)
})
set.seed(20260504L)

# Inputs ----------------------------------------------------------------------
clean_path <- here::here("scripts", "R", "_outputs_symmetric", "clean.rds")
stopifnot(fs::file_exists(clean_path))
df <- readRDS(clean_path)

land_files <- here::here(
  "master_supporting_docs", "own_drafts", "rawdata",
  sprintf("%d_원부_토지_20260407_82677.csv", 2018:2022)
)
stopifnot(all(fs::file_exists(land_files)))

# Read raw 원부_토지 CSV (all 5 years; sido pulled from earliest observation per hh)
read_land_year <- function(path) {
  readr::read_csv(
    path,
    locale = readr::locale(encoding = "UTF-8"),
    col_types = readr::cols(
      `조사연도`       = readr::col_integer(),
      `행정구역시도코드` = readr::col_character(),
      `지목코드`       = readr::col_integer(),
      `소유구분코드`   = readr::col_integer(),
      `토지면적`       = readr::col_double(),
      `천원단위평가금액` = readr::col_double(),
      `집계코드`       = readr::col_character(),
      `원시자료제공키값` = readr::col_character()
    ),
    progress = FALSE
  ) |>
    dplyr::rename(
      year    = `조사연도`,
      sido_cd = `행정구역시도코드`,
      hhid    = `원시자료제공키값`,
      area_raw = `토지면적`
    ) |>
    dplyr::select(hhid, year, sido_cd, area_raw)
}

df_land <- purrr::map_dfr(land_files, read_land_year)

# Modal sido per household across 2018-2022 (area-weighted; cross-province
# ownership is rare, but resolve to the largest parcel-area province)
df_sido <- df_land |>
  dplyr::filter(!is.na(sido_cd), !is.na(hhid)) |>
  dplyr::group_by(hhid, sido_cd) |>
  dplyr::summarise(area_total = sum(area_raw, na.rm = TRUE), .groups = "drop") |>
  dplyr::group_by(hhid) |>
  dplyr::slice_max(area_total, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::select(hhid, sido_cd)

# Merge to panel --------------------------------------------------------------
n_before <- nrow(df)
df <- df |> dplyr::left_join(df_sido, by = "hhid")
stopifnot(nrow(df) == n_before)

# Linkage diagnostics ---------------------------------------------------------
linkage_rate <- mean(!is.na(df$sido_cd))
sido_distinct <- dplyr::n_distinct(df$sido_cd, na.rm = TRUE)
sido_hh <- df |>
  dplyr::distinct(hh_id, sido_cd) |>
  dplyr::count(sido_cd, sort = TRUE)

# Sanity: linkage should be > 99%; expect 16-17 distinct sido (Korea has 17)
stopifnot(linkage_rate > 0.99,
          sido_distinct >= 10L,
          sido_distinct <= 18L)

# Save ------------------------------------------------------------------------
saveRDS(df, clean_path)

log_lines <- c(
  paste0("=== 01e_add_sido.R log -- ", as.character(Sys.time()), " ==="),
  "",
  sprintf("Input  panel:    %s (%d obs / %d hh)",
          clean_path, nrow(df), dplyr::n_distinct(df$hh_id)),
  sprintf("Source CSVs:     %s (2018-2022)", basename(land_files[1])),
  "",
  sprintf("Linkage rate:    %.4f (sido_cd non-NA / total)", linkage_rate),
  sprintf("Distinct sido:   %d (Korea has 17)", sido_distinct),
  "",
  "Top sido (household counts):"
)
top_sido <- utils::capture.output(print(sido_hh, n = Inf))
log_lines <- c(log_lines, top_sido)

writeLines(log_lines, file.path(dirname(clean_path), "sido_merge_log.txt"))
message(sprintf(
  "01e_add_sido.R: sido_cd appended (%.2f%% linkage; %d distinct sido).",
  100 * linkage_rate, sido_distinct
))
