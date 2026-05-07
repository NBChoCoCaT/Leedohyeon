# Calibration extraction sandbox — Step 4 P5 Phase 1

**Status:** COMPLETED 2026-05-07
**Plan:** `quality_reports/plans/gleaming-juggling-frost.md` (sister: `2026-05-07_p5-synthetic-generator.md`)
**Quality threshold:** 60/100 (sandbox per `.claude/rules/exploration-fast-track.md`)

## Goal

One-time extraction of privacy-friendly aggregated stats from raw FHES `panel_2018_2022.dta` for use by the synthetic data generator at `scripts/R/synthetic/synthetic_data_gen.R`.

## Files

| File | Purpose |
|---|---|
| `extract_calibration.R` | Reads .dta + STATA log → writes `_outputs/calibration_preview.json`. ~210 lines. |
| `parse_stata_log.R` | Helper: regex-parses `D_Post` coefficients from `02_analysis.log`. |
| `_outputs/calibration_preview.json` | Output (~26 KB). Copied to `scripts/R/synthetic/calibration.json`. |

## Run

```bash
Rscript explorations/2026-05-07_p5-calibration/extract_calibration.R
cp explorations/2026-05-07_p5-calibration/_outputs/calibration_preview.json \
   scripts/R/synthetic/calibration.json
```

Requires raw `.dta` access (one-time, by Dohyeon on a machine that has MDIS data). Generator users do NOT need to re-run this — they read the committed `calibration.json` only.

## Findings

- N=14,474 / farms=3,614 / mean D=0.3495 — matches CLAUDE.md identification snapshot ✓
- y_farm_income: 23.55% negative (3,408 adverse-cash-flow farm-years) ✓ (matches `2026-05-07_outlier-eda` H3)
- Spec A T3 (MSE-optimal per outcome) ATT successfully parsed from `02_analysis.log`:
  - y_farm_income: −3.58M (h=3,268 ㎡)
  - y_off_income: +0.22M (h=3,718 ㎡)
  - y_consump: +1.26M* (h=3,929 ㎡)
  - y_farm_cost: +0.26M (h=3,304 ㎡)
- Cutoff continuity: 3.06% left vs 1.92% right within ±200㎡ — no obvious manipulation.

## Decision

**Graduate to production:** generator + JSON → `scripts/R/synthetic/`. Calibration sandbox remains as historical record + re-extraction recipe if FHES data updates.
