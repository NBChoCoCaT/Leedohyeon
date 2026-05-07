# Plan: P0 — Correct `rv_2018` Centering Convention Across Active Spec Files

**Status:** COMPLETED (local commit) — push pending user auth (2026-05-06)
**Commit hash:** `9d384b0415c04b448fd6709d84ad2ebe84374437`
**Date:** 2026-05-06
**Branch:** main
**Sentinel filename:** `1-velvety-lynx.md` (post-approval sister: `2026-05-06_p0-fix-rv2018-centering.md`, identical content per `MEMORY.md` [LEARN:harness])
**Working machine:** idoui-Macmini

---

## Context

CLAUDE.md identification snapshot (line 27) and `.claude/rules/r-code-conventions.md` §10 (line 144) both state `D_treat = 1 if rv_2018 ≤ 5000`. **R-side sanity check on `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` (option A, 2026-05-06) shows this literal is wrong:** `rv_2018 = area_2018 − 5000` is **centered at the 0.5 ha cutoff**, so the eligibility cutoff is `rv_2018 ≤ 0`, not `≤ 5000`. Without this fix, the next R script (`scripts/R/01_clean.R`, soon to be ported from `master_supporting_docs/own_drafts/stata_analysis/01_cleaning.do`) would silently miscompute treatment status — Phase-3 tolerance would flag the bug only after wrong tables are produced.

**Empirical evidence (n = 14,474 obs / 3,614 farms / 2018–2022):**
- `rv_2018` observed range = −4,986 to +521,696 ㎡ (negative values are impossible for raw area → confirms centering).
- `rv_2018 = area_2018 − 5000` exactly: max diff and min diff both 5,000 ㎡.
- `D == (rv_2018 ≤ 0)` matches **14,474 / 14,474** obs (0 mismatches); equivalently `D == (area_2018 ≤ 5000)` 14,474 / 14,474.
- `D` is time-invariant per household: **0 / 3,614** households change `D` across years (confirms 2018-baseline anchoring blocks manipulation).
- `imputed_payment` median = **1,200,000 KRW** for treated post-2020 obs (matches SFFP 정액).
- Mean `D` = **0.349** (35.0% treated farm-year obs).

**Bug provenance (replication audit-trail).** Origin: `quality_reports/plans/2026-05-04_step3-1_3-2_rules_customize.md` lines 65 and 311 introduced the `rv_2018 ≤ 5000` literal in the draft variable-mapping table. Propagation 1: `.claude/rules/r-code-conventions.md` §10 line 144 inherited it during step 3-1 execution. Propagation 2: `CLAUDE.md` line 27 inherited it during identification-snapshot drafting. Catch: 2026-05-06 R-side data sanity check, 2 days after origin. Resolution (this plan): active spec files corrected; historical plan files preserved as append-only audit trail (replication-protocol).

---

## Scope

**Files modified (3):**

1. `CLAUDE.md` — Identification Strategy section (lines 24–33). Five non-contiguous line edits (running variable, cutoff, treatment dummy, primary outcomes, data). Per `summary-parity.md`, this is a summary paragraph: edited as a whole, not surgically.
2. `.claude/rules/r-code-conventions.md` — §10 variable mapping table, **line 144 only** (1-line fix to the Notes column).
3. `MEMORY.md` — append `[LEARN:methods]` entry between line 158 (end of `[LEARN:cross-artifact]` paragraph) and line 160 (`## macOS Cross-Machine Setup` subsection header).

**Files NOT modified (verified correct, no action):**

- `.claude/agents/domain-reviewer.md` — D-2 (line 130) already says `D_treat = (rv_2018 <= 0)` correctly; D-NEW-1 (line 145) intentionally documents the `D → D_treat` rename per §10.
- `quality_reports/specs/step-3-3-prep.md` — line 494 correctly states centered-vs-raw equivalence; line 501 correctly uses `5000` raw cutoff in a `# NEVER do this` counter-example warning against time-varying contamination.
- `quality_reports/plans/2026-05-04_step3-1_3-2_rules_customize.md` — preserved as historical audit trail (replication-protocol append-only history; bug provenance recorded in MEMORY.md `[LEARN:methods]` entry).

---

## Detailed Changes

### 1. `CLAUDE.md` — Identification Strategy (lines 24, 25, 27, 30, 33)

**Line 24 — Running variable (make centering explicit):**

```diff
- - **Running variable:** 경지면적 (cultivated land area, ㎡), measured in **2018 (pre-policy)** to block manipulation.
+ - **Running variable:** `rv_2018 = area_2018 − 5000` — 2018 baseline cultivated area (㎡) **centered at the 0.5 ha cutoff** (observed range −4,986 to +521,696 ㎡; pre-policy measurement blocks manipulation).
```

**Line 25 — Cutoff (link centered and raw forms):**

```diff
- - **Cutoff:** 0.5 ha = 5,000 ㎡ — eligibility threshold for Small-Farmer Flat Payment (SFFP, 소농직불금).
+ - **Cutoff:** 0.5 ha = 5,000 ㎡ raw area, equivalently `rv_2018 = 0` centered — eligibility threshold for Small-Farmer Flat Payment (SFFP, 소농직불금, 1,200,000 KRW/year flat).
```

**Line 27 — Treatment dummy (PRIMARY FIX — correct cutoff value + raw-vs-rename names):**

```diff
- - **Treatment dummy:** `D_treat = 1` if `rv_2018 ≤ 5000` — fixed at 2018 baseline.
+ - **Treatment dummy:** `D = 1` if `rv_2018 ≤ 0` ↔ `area_2018 ≤ 5000` — fixed at 2018 baseline. Raw-data variable is **`D`** (R-conventions standardizes to `D_treat` via rename in `01_clean.R`; see `r-code-conventions.md` §10). Verified on `panel_2018_2022.dta` (2026-05-06): 14,474/14,474 obs match; `D` time-invariant per household (0/3,614 change across years); mean `D` = 0.349.
```

**Line 30 — Primary outcomes (exact raw-data names + R-conventions rename map + auxiliary):**

```diff
- - **Primary outcomes:** farm operating cost (lumpy investment), off-farm income (precautionary labor), consumption (smoothing), farm income (omnibus).
+ - **Primary outcomes (raw-data names → R-conventions names):** `y_farm_cost → op_cost` (농업경영비 전체, lumpy investment, primary), `y_off_income → off_farm_income` (농외소득, precautionary labor), `y_consump → consumption` (가계소비지출, smoothing), `y_farm_income → farm_income` (농가소득, omnibus). Auxiliary for robustness: `y_farm_cost_ex_rent`, `y_rent_cost` (임차료 controls; reserved for Kirwan channel decomposition). Renames defined in `r-code-conventions.md` §10.
```

**Line 33 — Data (verification reference):**

```diff
- - **Data:** Statistics Korea MDIS, Farm Household Economic Survey (FHES) Wave 1, 2018–2022 (3,614 farms, 14,474 farm-years). APCS linkage TBD.
+ - **Data:** Statistics Korea MDIS, Farm Household Economic Survey (FHES) Wave 1, 2018–2022 (3,614 farms, 14,474 farm-years; verified on `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` 2026-05-06). APCS linkage TBD.
```

### 2. `.claude/rules/r-code-conventions.md` §10 line 144 (1-line fix)

```diff
- | 처치 더미 | `D_treat` | logical | `rv_2018 ≤ 5000` |
+ | 처치 더미 | `D_treat` | logical | `rv_2018 ≤ 0` (raw col `D`; centered) |
```

(Three facts in one cell — cutoff value, raw column name, centering note. Aligned with table-row aesthetic of other entries in §10.)

### 3. `MEMORY.md` — append `[LEARN:methods]` entry between line 158 and line 160

Single paragraph, lettered subsections (project style, matching `[LEARN:cross-artifact]` and `[LEARN:citation-verification]` patterns):

```
[LEARN:methods] **PIDPS DiD-RD raw-data variable mapping verified on `panel_2018_2022.dta` (2026-05-06, idoui-Macmini, 14,474 obs / 3,614 farms / 2018-2022).** **(a) Spec.** Running variable `rv_2018 = area_2018 − 5000` is centered at the 0.5 ha cutoff; cutoff is `0`, NOT `5,000` (observed range −4,986 to +521,696 m², matches `area_2018` shifted by −5,000 exactly). Treatment dummy raw column is `D` (R-conventions §10 standardizes to `D_treat` via rename in `01_clean.R`); `D == (rv_2018 ≤ 0)` matches 14,474/14,474 obs (0 mismatches), `D == (area_2018 ≤ 5000)` also 14,474/14,474. `D` time-invariant per household (0/3,614 households change across 2018-2022). `imputed_payment` median = 1,200,000 KRW for treated post-2020 obs (matches SFFP 정액). **(b) Variable mapping (memo → raw data).** `D_treat → D`, `y_farm_co~nt → y_farm_cost_ex_rent` (Stata 8-char truncation artifact), `y_off_inc → y_off_income`, `y_consum → y_consump`, `y_farm_inc → y_farm_income`. Primary lumpy-investment outcome is `y_farm_cost` (전체 경영비), NOT `y_farm_cost_ex_rent` (rent-net auxiliary, reserved for Kirwan channel decomposition). **(c) Bug provenance (audit trail).** Origin: `quality_reports/plans/2026-05-04_step3-1_3-2_rules_customize.md` lines 65 + 311 introduced `rv_2018 ≤ 5000` in the draft variable-mapping table. Propagation 1: `.claude/rules/r-code-conventions.md` §10 line 144 (step 3-1 execution). Propagation 2: `CLAUDE.md` line 27 (identification-snapshot drafting). Catch: 2026-05-06 R-side data sanity check (2 days after origin) — single Rscript computed `D == (rv_2018 ≤ 0)` cross-check, 14,474/14,474 match contradicted documented `≤ 5000`. Resolution: active bugs corrected (CLAUDE.md, r-code-conventions.md §10); plan files preserved as historical audit-trail (replication-protocol append-only history). **(d) Lesson.** Same-day or next-day data sanity check on every spec literal pays back ~5 min R code → 2 active bug catches before R porting begins; without it, Phase-3 tolerance flags the bug only after wrong tables are produced. **(e) Apply where.** Any future PIDPS DiD-RD reference; any plan-driven infra change introducing literal numeric thresholds; any Stata→R variable mapping table.
```

---

## Verification Steps (post-edit, before commit)

1. **Active-bug grep clears:** `grep -rn "rv_2018.*5000\|5000.*rv_2018\|D_treat.*5000\|5000.*D_treat" CLAUDE.md .claude/ quality_reports/specs/step-3-3-prep.md quality_reports/plans/ MEMORY.md` → expect **5 hits** (down from 7): 0 active bugs in CLAUDE.md/r-code-conventions.md, 3 false positives preserved (domain-reviewer.md:128 counter-example, step-3-3-prep.md:494 equivalence statement, step-3-3-prep.md:501 NEVER-do-this counter-example), 2 historical plan-record hits preserved (plans/2026-05-04_step3-1_3-2_rules_customize.md:65, 311).

2. **MEMORY.md size cap:** `wc -l MEMORY.md` → expect ~167-170 lines (current 166 + 1 new paragraph entry). Below 200-line cap.

3. **Domain-reviewer cross-reference re-verify:** `grep -n "rv_2018" .claude/agents/domain-reviewer.md` → expect lines 64, 128, 130 unchanged. Line 130 must still read `D_treat = (rv_2018 <= 0)`.

4. **Plan sister file diff:** copy plan content to `quality_reports/plans/2026-05-06_p0-fix-rv2018-centering.md` (per `[LEARN:harness]`), then `diff 1-velvety-lynx.md 2026-05-06_p0-fix-rv2018-centering.md` → 0 differences.

5. **Git diff stat:** `git diff --stat` → expect 3 source files changed + 1 plan file added.

---

## Commit Message (option B — detailed, replication audit-trail)

```
fix(spec): correct rv_2018 centering across CLAUDE.md and r-code-conventions §10

Verified on master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta
(14,474 obs / 3,614 farms / 2018-2022; idoui-Macmini, 2026-05-06):

- rv_2018 = area_2018 - 5000 (centered at the 0.5 ha cutoff;
  observed range -4,986 to +521,696 m²); cutoff is 0, NOT 5,000.
- Raw treatment dummy is `D` (NOT `D_treat`; D_treat is the R-side
  standardized rename per r-code-conventions.md §10).
- D == (rv_2018 ≤ 0) matches 14,474/14,474 obs (0 mismatches);
  equivalently D == (area_2018 ≤ 5000) — both definitions exact.
- D is time-invariant per household (0/3,614 households change across
  2018-2022), confirming 2018-baseline anchoring blocks manipulation.
- imputed_payment median = 1,200,000 KRW for treated post-2020 obs
  (matches SFFP 정액).
- Primary outcomes (raw-data names): y_farm_cost (NOT y_farm_cost_ex_rent
  — the latter is rent-net auxiliary for Kirwan channel decomposition),
  y_off_income, y_consump, y_farm_income.

Files corrected:
- CLAUDE.md (Identification Strategy section: 5 lines reflowed)
- .claude/rules/r-code-conventions.md §10 (variable mapping table line
  144, 1-line fix)
- MEMORY.md (+1 paragraph, [LEARN:methods] entry under PIDPS Dissertation
  Plan-Cycle Lessons section, with bug provenance audit trail)

Provenance (replication audit-trail):
- Origin: quality_reports/plans/2026-05-04_step3-1_3-2_rules_customize.md
  (lines 65, 311) — `rv_2018 ≤ 5000` literal in draft variable-mapping
  table.
- Propagation: r-code-conventions.md §10 line 144 (step 3-1 execution),
  then CLAUDE.md line 27 (identification snapshot drafting).
- Catch: 2026-05-06 R-side data sanity check on panel_2018_2022.dta
  (option A; 2 days after origin).
- Resolution: active spec files corrected; historical plan files
  preserved as replication append-only audit trail.

Domain-reviewer.md D-2 (line 130) and D-NEW-1 (line 145) verified
correct (rv_2018 <= 0 already; D → D_treat rename intentional per §10).
step-3-3-prep.md lines 494 and 501 verified correct (equivalence
statement and intentional counter-example, respectively).

This unblocks STATA → R porting in scripts/R/01_clean.R and ensures
replication-protocol Phase 3 tolerance checks (estimate < 0.01,
SE < 0.05) reference correct variable definitions.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

---

## Post-Approval Execution Order

1. Mark this plan **APPROVED** (status header in plan file).
2. Apply 3 Edit operations:
   a. CLAUDE.md identification snapshot (5 line edits per §1 above).
   b. r-code-conventions.md §10 line 144 (1-line fix per §2).
   c. MEMORY.md append `[LEARN:methods]` entry (per §3).
3. Run all 5 verification steps. Halt and report if any fails.
4. Create sister plan file `quality_reports/plans/2026-05-06_p0-fix-rv2018-centering.md` via `cp` of this plan, then `diff` to confirm identical (per `[LEARN:harness]`).
5. `git add CLAUDE.md .claude/rules/r-code-conventions.md MEMORY.md quality_reports/plans/2026-05-06_p0-fix-rv2018-centering.md`.
6. `git commit` with the message above.
7. `git push origin main`.
8. `git log -1 --format=%H` → record new commit hash; `git status` → confirm clean.
9. Update plan-file status to **COMPLETED** + record commit hash.

---

## Files Cross-Reference

- **CLAUDE.md** lines 22–33 — identification snapshot (canonical spec)
- **`.claude/rules/r-code-conventions.md`** §10 (lines 129–146) — Stata→R variable rename table
- **`.claude/agents/domain-reviewer.md`** D-2 (line 130), D-NEW-1 (lines 140–151) — already-correct cross-references
- **MEMORY.md** lines 150–158 — PIDPS Dissertation Plan-Cycle Lessons (insertion point)
- **`master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta`** — verification source (option A sanity check)
- **`master_supporting_docs/own_drafts/rawdata/codebook_panel.txt`** — independent variable-definition source
