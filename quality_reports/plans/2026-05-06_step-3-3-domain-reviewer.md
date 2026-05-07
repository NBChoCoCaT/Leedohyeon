---
date: 2026-05-06
branch: main
status: COMPLETED
sentinel: quality_reports/plans/steady-dancing-locket.md
sister: quality_reports/plans/2026-05-06_step-3-3-domain-reviewer.md (created post-approval, identical content)
predecessor: quality_reports/plans/floofy-soaring-harbor.md (Step 1 + 2 + 3-1 + 3-2 COMPLETED, lock-noted)
spec: quality_reports/specs/step-3-3-prep.md (731 lines)
checkpoint: quality_reports/checkpoints/2026-05-04_step-3-1-3-2-completed.md
session-log: quality_reports/session_logs/2026-05-06_step-3-3-plan.md (incremental, append-only)
---

# Plan — Step 3-3: Domain-Reviewer 5-Lens Customization for PIDPS DiD-RD

## Context

The Pedro Sant'Anna lecture-slide template ships `.claude/agents/domain-reviewer.md` as a **field-agnostic stub** (202 lines, AUTO-DETECT-TEMPLATE-MARKER) with two illustrative customizations (Econ DiD/IV/RD; Poli-sci AJPS conjoint). The current PIDPS DiD-RD project needs **substantive PIDPS-specific** review rules — not generic methods checks — to catch (i) the 11% citation error rate found in the term paper, (ii) FHES variable mapping drift between text and code, (iii) STATA → R migration tolerance gaps, (iv) reghdfe-vs-feols spec drift, and (v) auxiliary-vs-primary outcome confusion in the Holm family.

The step-3-3-prep.md spec (731 lines) auto-drafted in the prior session provides the raw 5-Lens content (27 citations + 6 Lens-1 assumption checks + 5 Lens-2 derivations + 5 Lens-4 code-theory items + 7 Lens-5 logic-chain items, of which 3 remain TBD placeholders). Sample STATA log inspection (2026-05-06) confirmed 4 specifications and 2 bonus findings that further sharpen the Lens 4 rules. This plan converts those raw findings into **agent-executable verification rules** that read source files (paper + code + logs) and emit Critical/Major/Minor flags.

This step is the last of the rules+agents customization track. After approval, Step 4 (analysis skills + R migration) and Step 5 (policy glossary) follow.

## Goal (one sentence)

Customize `.claude/agents/domain-reviewer.md` from a 202-line generic template into a 250-350-line PIDPS DiD-RD-aware 5-Lens reviewer, integrating step-3-3-prep.md content, the 4 Critical Citation Findings, the 6 codebook variable rename pairs, the reghdfe-↔-feols mapping, and the 11_multiple_testing.log ground-truth designation.

---

## Lock Notes (immutable; from prior steps and sample inspection)

[LOCK Step 1] Template clone + research project re-skin. ✅ COMPLETED prior session.

[LOCK Step 2] CLAUDE.md rewrite — 133 lines, identification snapshot lines 22-35, AJAE/Food Policy/JAE target. ✅ COMPLETED — commit 514554b on `main`, ahead of `origin`.

[LOCK Step 3-1] `.claude/rules/r-code-conventions.md` — 206 lines, §10 12-row FHES variable mapping, §6 Solon-Haider-Wooldridge stage rule. ✅ COMPLETED — commit 41be7ec.

[LOCK Step 3-2] `.claude/rules/quality-gates.md` — 124 lines, 5 deduction tables incl. §English Manuscript, §Korean Manuscript, §Korean Policy Citation Accuracy. ✅ COMPLETED — same commit 41be7ec.

[LOCK Step 3-3 prep] `quality_reports/specs/step-3-3-prep.md` — 731 lines, 27 citations cross-checked, 4 Critical Citation findings, 5-Lens content. ✅ COMPLETED — current spec ready as plan input. 3 placeholders ((b)-6, (e)-6, (e)-7) remain — 도현님 input deferred.

[LOCK Sample inspection 2026-05-06] STATA grep performed on 02_analysis.do/log + 04_robustness.do + all 18 .do files. Confirmed:
- (a) `op_cost = y_farm_cost` (전체 경영비, NOT `y_farm_co~nt` 임차 제외). 텀페이퍼 §6: y_farm_income/y_off_income are **primary**, y_consump/y_farm_cost are **secondary**, but **all 4 share Holm family**.
- (b) Cluster spec: `vce(cluster hhid_num)` 단독 across all 18 .do files. `sgg_cd`/시군구/region/district appears 0 times. **텀페이퍼 미사용**.
- (c) Model spec: `reghdfe y D_Post rv_Post Drv_Post if abs(rv_2018)<=h, absorb(hhid_num year) vce(cluster hhid_num)`. R 등가: `feols(y ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = subset(df, abs(rv_2018) <= h), cluster = ~hh_id)`.
- (d) `08_rwolf_final.do` is **deprecated** (per 11_multiple_testing.do header: "이전 시도(08_rwolf_final.do)에서 reghdfe 호환 문제로 실패한 Wild cluster bootstrap + Romano-Wolf 보정을 우회 방식으로 재시도"). **11_multiple_testing.log = single source of truth for Romano-Wolf**.

[LOCK Codebook cross-check 2026-05-06] `master_supporting_docs/own_drafts/rawdata/codebook_panel.txt` (4KB, panel.dta companion). Sample size 14,474 / 3,614 farms ✅ matches CLAUDE.md. **6 rename pairs needed**: `hhid_num→hh_id`, `D→D_treat`, `area_total→area_t`, `y_farm_cost→op_cost`, `y_off_income→off_farm_income`, `y_consump→consumption`, `y_farm_income→farm_income`. **§10 supplement candidates (7)**: `area_2018`, `imputed_payment`, `y_rent_cost` (Kirwan 2009 outcome), `y_ag_subsidy` (APCS proxy), `weight_single`, heterogeneity covariates (`farm_type`/`age_code_baseline`/`sex_code`), `debt_total`. **`sgg_cd` 부재** — § 11 robustness as dissertation extension only.

---

## Approach

### Phase 1: Pedro template baseline read (Read-only, ~3 min) ✅ DONE in plan mode

`.claude/agents/domain-reviewer.md` (202 lines) inspected. Structure:
- YAML frontmatter (name, description, tools=Read/Grep/Glob, model: inherit) — **preserve verbatim shape, update description text**
- AUTO-DETECT-TEMPLATE-MARKER block — **remove (file is being customized)**
- 5 Lens checkboxes (generic) — **replace content with PIDPS-specific assertions**
- Cross-Lecture Consistency section — **repurpose as Cross-Artifact Consistency** (paper + R + STATA log + codebook)
- Report Format (Critical/Major/Minor) — **keep, add STATA→R tolerance fields**
- Important Rules (7 items, NEVER edit etc.) — **keep, add 1 PIDPS-specific rule**

### Phase 2: Draft customized agent (Edit, ~30-45 min)

Target structure for `.claude/agents/domain-reviewer.md` (250-350 lines):

```
[YAML frontmatter — updated description ~150 chars, name/tools/model unchanged]

# Domain Reviewer Agent — PIDPS DiD-RD Research

## Role (1 paragraph)
Read-only substantive review of paper drafts (paper/ko/, paper/en/), R scripts (scripts/R/),
slides (Slides/, Quarto/, dormant), and STATA migration artifacts (master_supporting_docs/own_drafts/
stata_analysis/) against 5 Lenses calibrated to the PIDPS Public-Interest Direct Payment Scheme
DiD-RD identification at the 0.5-ha (5,000 ㎡) cutoff.

## When to invoke (4 bullets)
- After paper section drafted (esp. §1, §3, §5, §6, §8 — identification + theory + results + interpretation)
- After R script drafted/modified (esp. 03_did_rd.R, 04_robust.R)
- Before commit if substantive change to identification / citation / theory derivation
- When user invokes /seven-pass-review or /slide-excellence (this agent is one of the lenses)

## Critical Citation Auto-Flag Rules (4 hard fails — checked BEFORE Lens 3 walk)

[Auto-flag B11 Kimhi 1994 — paper non-existent]
- Trigger: any cite of "Kimhi (1994). Optimal Timing of Farm Exit under Uncertainty. AJAE 76(4):874-880"
- Action: CRITICAL — paper does not exist. Per step-3-3-prep.md (Tier 3 cut), use Weiss (1999) alone.

[Auto-flag C4 Kirchweger et al. 2022 — wrong attribution]
- Trigger: any cite of "Q Open 2(1), qoac007"
- Action: CRITICAL — that ID is Zamani et al. (Ghana poultry). Enforce: Q Open 3(3), qoac024,
  "Direct payments and on-farm employment: Evidence from a spatial regression discontinuity design".

[Auto-flag C2 Gardebroek-Oude Lansink 2004 — wrong journal + body text]
- Trigger 1: any cite of "ERAE 31(1):81-104" for Gardebroek-Oude Lansink
- Trigger 2: any body text saying "낙농" (dairy) or "dairy" attached to Gardebroek-Oude Lansink
- Action: CRITICAL (provisional, pending 도현님 review) — enforce JAE 55(1):3-24,
  "Farm-specific Adjustment Costs in Dutch Pig Farming". Body text MUST say "Dutch pig" / "양돈" / "돼지".

[Auto-flag B10 Kirwan 2009 — title shortened]
- Trigger: cite of "The Incidence of U.S. Farm Programs"
- Action: MINOR — published title is "The Incidence of U.S. Agricultural Subsidies on Farmland Rental Rates".
  JPE 117(1):138-164, DOI 10.1086/598688.

## Lens 1: Identification Assumption Verification (6 items)

[B-1 DiD parallel trends — 2-period pre-window]
[B-2 RD continuity at 0.5 ha cutoff (McCrary + Cattaneo-Jansson-Ma)]
[B-3 Covariate continuity at the cutoff]
[B-4 Donut RD robustness]
[B-5 Manipulation absence (2018 baseline freeze)]
[B-6 (S,s) regularity for Korean small farms — TBD placeholder]

Each formatted: name → what to check → violation criterion → robustness/test → relevant citations.
B-6 marked "TBD: see step-3-3-prep.md (b)-6 — 도현님 input pending (2026-05-XX session)".

## Lens 2: Derivation Verification (5 items)

[C-1 Eq (1) DiD-RD spec ↔ Caballero-Engel reduced form]
[C-2 β decomposition: level effect (17.5만원 차등) vs structural effect (lump-sum vs area-proportional)]
[C-3 Wild cluster bootstrap algorithm (Rademacher, B=9999)]
[C-4 Holm stepdown over 4 primary outcomes]
[C-5 rdrobust MSE-optimal bandwidth p=1 polynomial order]

Each formatted: equation → theoretical counterpart → verification chain → key citations.

## Lens 3: Citation Fidelity (27 entries, grouped by Tier)

### Tier A — PDF on disk (8)
[A1a SinghSquireStrauss1986_book / A1b SinghSquireStrauss1986_WBER / A2 deJanvryFafchampsSadoulet1991_EJ /
 A3 Chetty2008_JPE / A4 AhearnElOstaDewbre2006_AJAE / A5 GoodwinMishra2006_AJAE /
 A6 ChoiJodlowski2025_LandEcon / A7 ChoiMoon2025_KSRP / A8 KimYang2021_KAEA]

For each: BibTeX key, full attribution, DOI, "Cite caution" verbatim phrases (must NOT be paraphrased),
dissertation use section.

### Tier B — WebSearch verified (11)
[B1 Caballero-Engel 1999 / B2 Sandmo 1971 / B3 Blundell-Pistaferri 2003 (JHR not JPE) /
 B4 Grembi-Nannicini-Troiano 2016 / B5 Callaway-Sant'Anna 2021 / B6 Roth et al 2023 /
 B7 Hahn-Todd-vanderKlaauw 2001 / B8 Calonico-Cattaneo-Titiunik 2014 / B9 Cattaneo-Jansson-Ma 2020 /
 B10 Kirwan 2009 (title 정정) / B11 Kimhi 1994 → CUT]

### Tier B+ — text ground truth (7)
[C1 Abel-Eberly 1994 / C2 Gardebroek-Oude Lansink 2004 (정정) /
 C3 McCrary 2008 (subtitle "A Density Test" added) / C4 Kirchweger 2022 (정정) /
 C5 Kimball 1990 / C6 Aiyagari 1994 / C7 Romano-Wolf 2005]

For Korean papers (A7, A8): dual-field convention — `author` (Korean) + `author_en`,
`title` (Korean) + `title_en`. Per quality-gates.md §Bilingual Citation Format Enforcement.

## Lens 4: Code-Theory Alignment (10 items)

[D-1 Sample restriction in code matches text exactly (rv_2018 centered, |rv_2018|<=h)]
[D-2 D_treat 2018 baseline enforcement — never use area_t time-varying]
[D-3 Holm correction over 4 primary outcomes only (NOT robustness specs)]
[D-4 Wild bootstrap deterministic seed]
[D-5 modelsummary coef_map Korean-English consistency (numeric content byte-identical)]

NEW from sample inspection (2026-05-06):
[D-NEW-1 Variable rename mapping consistency — codebook ↔ §10 (6 pairs):
   hhid_num→hh_id, D→D_treat, area_total→area_t, y_farm_cost→op_cost,
   y_off_income→off_farm_income, y_consump→consumption, y_farm_income→farm_income]
[D-NEW-2 op_cost = y_farm_cost (전체 경영비). Primary outcomes: y_farm_income, y_off_income.
   Secondary outcomes: y_consump, y_farm_cost. **All 4 enter Holm family**.
   Flag if R code uses y_farm_cost_net (임차 제외) for main spec.]
[D-NEW-3 Cluster spec — 텀페이퍼 baseline = hhid_num 단독.
   sgg_cd = 박사논문 확장 신규 (raw CSV merge / APCS linkage at Step 4). 
   Flag if R code claims sgg_cd robustness without referencing Step-4 source.]
[D-NEW-4 STATA → R tolerance check — when R reports an estimate matching a STATA-reported number,
   verify within tolerance (estimate <0.01 abs diff, SE <0.05 abs diff per replication-protocol.md).
   Ground-truth STATA logs:
     • 02_analysis.log — main DiD-RD T1/T2/T3 coefficients
     • 11_multiple_testing.log — Romano-Wolf and Wild bootstrap p-values (NOT 08_rwolf_final.log — deprecated)
     • 03_bandwidth_check.log — MSE-optimal bandwidth h*
     • 07_eventstudy.log — pre-trends β_2018
     • 13_weighted_and_fuzzy.log — fuzzy 2SLS / weighted spec
     • 16_descriptive_stats.log — sample N, descriptive table
   Deprecated (do NOT use as ground truth): 08_rwolf_final.log.
   Pending re-run (Step 4): 14_mde_power.log, 15_sdid.log.]
[D-NEW-5 reghdfe ↔ feols spec mapping — reference spec MUST match:
     Stata: `reghdfe y_X D_Post rv_Post Drv_Post if abs(rv_2018)<=h, absorb(hhid_num year) vce(cluster hhid_num)`
     R:     `feols(y ~ D_Post + rv_Post + Drv_Post | hh_id + year, data = subset(df, abs(rv_2018) <= h), cluster = ~hh_id)`
   Flag if R uses `D_treat * Post` shorthand without confirming D_Post/rv_Post/Drv_Post mathematical equivalence,
   or if absorb-set differs (must include both hh_id and year).]

## Lens 5: Logical Chain Coherence (7 items)

[E-1 문제제기 → 식별 선택 (왜 DiD-RD over DiD-only or RD-only)]
[E-2 식별 → 추정 (every parameter ↔ identifying assumption mapping)]
[E-3 추정 → 결과 (every numeric claim → _outputs/*.rds + STATA log cross-ref)]
[E-4 결과 → 해석 (β sign+magnitude ↔ which channel — 4-channel consistency check)]
[E-5 해석 → 정책함의 (단가 인상 vs 재투자 조건부 — channel-policy 정합)]
[E-6 박사논문 심사위원 perspective — TBD placeholder (도현님 input pending)]
[E-7 한국농업경제학회 referee perspective — TBD placeholder (도현님 input pending)]

## STATA → R Migration Verification (mapping per Dohyeon answer #2, with 08 exclusion)

[Mapping table — 18 .do → 5 .R:
 01_clean.R         ← 01_cleaning.do (1-to-1)
 02_descriptive.R   ← 16_descriptive_stats.do + 17_desc_by_tier.do + 18_desc_supplement.do (3-to-1)
 03_did_rd.R        ← 02_analysis.do + 02b_narrow_primary.do + 03_bandwidth_check.do (3-to-1, T1/T2/T3)
 04_robust.R        ← 04_robustness.do + 06_robustness_aux.do + 07_eventstudy.do + 09_scale_check.do
                    + 10_highvalue_checks.do + 11_multiple_testing.do + 13_weighted_and_fuzzy.do (7-to-1, 08 EXCLUDED)
 05_extension.R     ← 05_extension.do + 12_real_labor_cost.do + 14_mde_power.do + 15_sdid.do (4-to-1, dissertation extension)]

Each .R file MUST carry header listing source .do files. Lens 4 D-NEW-4 enforces tolerance check
against the matching .log file(s).

## Cross-Artifact Consistency (replaces Pedro Cross-Lecture Consistency)

Check the target artifact against:
- [ ] CLAUDE.md identification snapshot (lines 22-35) — D_treat / rv_2018 / Post / 4 outcomes / theory citations
- [ ] r-code-conventions.md §10 — 12-row FHES variable mapping table (and 7 supplement candidates pending OQ-8)
- [ ] r-code-conventions.md §11 — clustering convention (hhid_num primary; sgg_cd dissertation extension)
- [ ] quality-gates.md §Korean Policy Citation Accuracy — 4 hard-failable dimensions
- [ ] step-3-3-prep.md — full citation + assumption + derivation source
- [ ] codebook_panel.txt — variable name ground truth (4-byte SHA noted)
- [ ] STATA .log files — coefficient ground truth per D-NEW-4 list

## TBD Placeholders (defer to next session — explicit, do NOT silently fill)

3 placeholders correspond to step-3-3-prep.md sections (b)-6, (e)-6, (e)-7:
- B-6 (S,s) regularity for Korean small farms — domain calibration data (자본 임계점 s ~수천만원, vs T = 120만원)
- E-6 thesis examiner perspective — 지도교수 이상헌 + KU Food Resource Econ committee 강조점
- E-7 Korean society referee perspective — KAEA / 농업경제연구 / 농촌계획학회 referee 관점

Each TBD block carries: "TBD: see step-3-3-prep.md (b)-6/(e)-6/(e)-7 — 도현님 input pending (target session 2026-05-XX)."
Lens 1 / Lens 5 walks SKIP these items with a "TBD" note in the report rather than failing.

## Report Format (extends Pedro original)

Save to `quality_reports/[FILENAME_WITHOUT_EXT]_substance_review.md`. Lens 1-5 + Cross-Artifact Consistency
+ Critical Citation Auto-Flag results. STATA→R tolerance findings get explicit "STATA value | R value | abs diff |
within tolerance Y/N" table.

## Important Rules (extends Pedro original)

[Pedro 1-7 kept verbatim]
[NEW 8: PIDPS-specific — TBD placeholders are NOT failures. Surface as "deferred for 도현님 input"
        and continue. Do not fabricate content for B-6 / E-6 / E-7.]
```

### Phase 3: Verification (after Phase 2 Edit, before COMPLETED)

Run all 13 checks:
- [ ] `wc -l .claude/agents/domain-reviewer.md` returns 250-350
- [ ] `grep -c "^## Lens" .claude/agents/domain-reviewer.md` returns exactly 5
- [ ] `grep -c "TBD" .claude/agents/domain-reviewer.md` returns exactly 3 (B-6, E-6, E-7) — NOT more, NOT less
- [ ] All 27 Lens-3 BibTeX keys present (`grep` for `SinghSquireStrauss1986_book`, ..., `RomanoWolf2005_ECTA`)
- [ ] 4 Critical Citation Auto-Flag rules present (Kimhi cut, Kirchweger 정정, Gardebroek 정정, Kirwan title)
- [ ] STATA→R Migration block names `11_multiple_testing.log` AND marks `08_rwolf_final.log` deprecated
- [ ] reghdfe ↔ feols spec mapping present with both code blocks
- [ ] hhid_num cluster vs sgg_cd extension distinction explicit (D-NEW-3)
- [ ] y_farm_cost outcome with primary/secondary labels documented (D-NEW-2)
- [ ] 6 codebook rename pairs listed (D-NEW-1)
- [ ] YAML frontmatter parseable (name=domain-reviewer, tools=Read/Grep/Glob, model=inherit)
- [ ] Cross-references to r-code-conventions / quality-gates / step-3-3-prep / CLAUDE.md / codebook_panel.txt all present
- [ ] AUTO-DETECT-TEMPLATE-MARKER REMOVED (this is the marker file's de-customization signal)

### Phase 4: Persist plan to disk (after ExitPlanMode + 도현님 OK)

4.1 This plan file `steady-dancing-locket.md` already exists (sentinel, DRAFT during plan mode).
4.2 Sister file `quality_reports/plans/2026-05-06_step-3-3-domain-reviewer.md` written with **identical content** post-approval.
4.3 Both files updated DRAFT → APPROVED upon ExitPlanMode, APPROVED → COMPLETED after Phase 3 passes.

### Phase 5: Session log

5.1 Append entry to `quality_reports/session_logs/2026-05-06_step-3-3-plan.md` (incremental):
- post-plan-approval entry (goal, approach, rationale)
- per-finding entries during Phase 2 (≥3 expected: critical-citation flags, codebook rename, STATA grep)
- end-of-Phase-3 entry (verification pass/fail count)

---

## Files to modify

| File | Operation | Estimated change |
|---|---|---|
| `.claude/agents/domain-reviewer.md` | Major rewrite (Pedro template → PIDPS-specific) | 202 → 250-350 lines |
| `quality_reports/plans/steady-dancing-locket.md` | Already exists (this file, DRAFT) | DRAFT → APPROVED → COMPLETED |
| `quality_reports/plans/2026-05-06_step-3-3-domain-reviewer.md` | New (sister of sentinel, post-approval) | new file, identical content |
| `quality_reports/session_logs/2026-05-06_step-3-3-plan.md` | New + append | new file, ≥4 entries |

## Files NOT modified (out of scope this step — see Open Questions)

- `.claude/rules/r-code-conventions.md` (§10 supplement 7 행 추가 → OQ-8, separate commit)
- `.claude/rules/quality-gates.md` (no change this step)
- `CLAUDE.md` (no change this step)
- `Bibliography_base.bib` (BibTeX entries → Step 4)
- `step-3-3-prep.md` (placeholder fill → 도현님 next session, OQ-5)
- `master_supporting_docs/own_drafts/stata_analysis/*` (commit decision deferred per OQ-3)
- `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` (R import → Step 4)
- `MEMORY.md` (LEARN candidates surfaced below; append on 도현님 approval)

## Open Questions (post-Step-3-3 actions, NOT blocking this plan)

| ID | Question | Resolution timing |
|---|---|---|
| OQ-1 | 14_mde_power.log, 15_sdid.log re-run | Step 4 (박사논문 확장 분석) |
| OQ-2 | STATA → R migration mapping in r-code-conventions §1 | Separate commit after this step |
| OQ-3 | stata_analysis/ commit (.log review for PII) | Post Step 3-3, before Step 4 |
| OQ-4 | C2 Gardebroek attribution final confirmation (JAE 55(1):3-24) | 도현님 manual review |
| OQ-5 | step-3-3-prep.md 3 placeholders (B-6, E-6, E-7) | 도현님 next session |
| OQ-6 partial | sgg_cd as new robustness for dissertation (raw CSV / APCS linkage) | Step 4 |
| OQ-8 | r-code-conventions.md §10 mapping table 7 supplement rows | Separate commit after this step |

OQ-7 (op_cost 정의) and OQ-6 (텀페이퍼 sgg_cd 사용 여부) are **closed** by sample inspection (2026-05-06).

## Out of Scope (this plan)

- Editing step-3-3-prep.md to fill 3 placeholders (도현님 owns; OQ-5)
- Adding BibTeX entries for 27 citations to Bibliography_base.bib (Step 4)
- Authoring 4 new skills (`/did-rd-analysis`, `/lumpy-investment-check`, `/translate-paper-ko-en`, `/agent-debate`) (Step 4)
- Final C2 Gardebroek attribution confirmation (도현님; OQ-4)
- panel_2018_2022.dta R import + tolerance check execution (Step 4)
- stata_analysis/ commit decision (.log PII review needed; OQ-3)
- Pushing accumulated commits (514554b, 41be7ec, plus this step's commit) to `origin/main` (도현님 explicit OK required)

## Memory candidates (proposed; awaiting 도현님 approval)

```
[LEARN:harness] confirm prior candidate from floofy-soaring-harbor checkpoint:
harness sentinel for plan files is sticky across plan-mode re-entries. Do not author
a new plan file with a Pedro-style date-slug name independently — use the harness-assigned
sentinel (steady-dancing-locket.md this round) as primary; add 2026-05-XX_*.md sister
post-approval with identical content for searchability.
Why: prior session near-miss (Step 2 + Step 3-1/3-2 plans almost shown for wrong approval).
Apply where: any multi-step plan-mode session in this template.
```

```
[LEARN:methods] confirm prior candidate from floofy-soaring-harbor checkpoint:
Korean policy citation accuracy has 4 hard-failable dimensions — statute article (법령 제10조),
effective date (2020-05-01), subsidy amount (1,200,000 KRW/year flat), institution English name
(PIDPS / SFFP). Each gets -15 (Critical) deduction in paper/{ko,en}/** quality gates.
CoVe (/verify-claims) cross-checks against policy-glossary-ko-en.md (Step 5 deliverable).
Why: AJAE/Food Policy referees spot-check Korean policy specifics; one wrong date or amount
loses credibility before any methods read.
Apply where: any English-language paper citing Korean agricultural law / direct payment scheme.
```

```
[LEARN:citation-verification] new candidate from step-3-3-prep.md auto-draft:
텀페이퍼 27편 인용 중 3편 critical 오류 + 2편 minor 차이 (= 11% 오류율) 발견.
Pre-flight verification (publisher source / CrossRef DOI / journal TOC fetch /
pypdf direct extraction) is mandatory before paper/ko stabilization, paper/en translation,
and submission. Flag types: (a) volume/issue/page, (b) journal name (JPE vs JHR),
(c) Korean dual-field, (d) body-text context (e.g., "낙농" vs "pig").
Why: 인용 정확성은 referee가 가장 빠르게 catch — 영문 저널 desk-reject 통상 reason 상위.
Apply where: any dissertation/journal paper with 20+ References. Apply at paper/ko stabilization,
paper/en translation, and submission gates.
```

```
[LEARN:cross-artifact] new candidate from sample inspection (2026-05-06):
STATA log inspection caught 2 critical specifications (op_cost=y_farm_cost not _net;
cluster=hhid_num only, no sgg_cd) and 2 bonus findings (reghdfe spec, 08_rwolf_final.do
deprecated) that codebook alone could not have resolved. Lens 4 design must include
grep-style ground-truth queries against .log files (executed result), not just .do
files (code intent). Single-source dependency creates false confidence.
Why: 텀페이퍼 spec ambiguity는 .do (intent) vs .log (executed result) 둘 다 봐야 해소됨.
Apply where: STATA → R migration verification; cross-artifact review of any analysis paper
with both code intent and executed log.
```

## Resume prompt

> Resuming from `quality_reports/plans/steady-dancing-locket.md` (sister: `2026-05-06_step-3-3-domain-reviewer.md`).
> Step 3-3 plan status: [check status field at top]. If DRAFT → present for 도현님 review.
> If APPROVED → ExitPlanMode signaled, execute Phase 2-5. If COMPLETED → next is Step 4
> (analysis skills + R migration), or Step 5 (policy glossary), or push 3 accumulated commits
> to origin/main (도현님 OK gated).
