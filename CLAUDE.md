# CLAUDE.md — Public-Interest Direct Payment Scheme (PIDPS) Research

**Project:** 공익직불제 소농직불금이 농가 투입 행태에 미치는 효과 — DiD-RD evidence at the 0.5 ha cutoff
**Target journals (Phase 4 locked 2026-05-18 post-P3b-2):** ① *American Journal of Agricultural Economics* (AJAE) direct → ② *Journal of Agricultural Economics* (JAE) on AJAE R&R/reject → ③ *Food Policy* on JAE reject → ④ Korean journals (KAEA, 한국농경제학회보). Aim-high cascade rationale: P3b-2 three-channel evidence (negative pass-through −11.1% reversing Ciaian 2023 EU consensus + tenant-driven monotone gradient + (S,s) inaction) is strong enough for AJAE direct; JAE→FP fallback minimizes reframing cost.
**Author:** Lee, Dohyeon (Korea University, Dept. of Food and Resource Economics) — single-authored
**Workflow:** Canonical `paper/en/main.tex` (AJAE submission target); auxiliary `paper/ko/main.tex` derived post-stabilization (KAEA presentation + future thesis chapter base). Bootstrap once from existing Korean v1 (`master_supporting_docs/own_drafts/초안.md`).
**Branch:** main

---

## Goal

Single-author empirical paper for international peer-review submission, with thesis-chapter compatibility maintained.

- **Primary track:** `paper/en/main.tex` — direct journal submission (AJAE → Food Policy → JAE).
- **Auxiliary track:** `paper/ko/main.tex` — derived from `paper/en/` post-stabilization. Dual purpose: (i) future PhD thesis chapter base (Korea University Dept. of Food and Resource Economics; advisor: Lee Sangheon; currently enrolled), (ii) KAEA / 한국농경제학회 conference presentation.
- **Bootstrap:** existing Korean v1 (`master_supporting_docs/own_drafts/초안.md`, 36 KB) → `paper/en/main.tex` (one-time port). After this, `paper/en/` is canonical; `paper/ko/` re-syncs from `paper/en/` once stable.
- **Replication standard:** AEA Data Editor checklist (DCAS v1.0) — full reproducibility package (`scripts/R/`, `_outputs/`, `data/var_dictionary.csv`, README) at first submission. **Restricted FHES microdata 4-요건:** (i) 5+ year preservation commit, (ii) replication assistance commit, (iii) public code + `scripts/R/synthetic/` (Step 4 P5 ✅ 2026-05-07 — Hybrid strategy: privacy-friendly `calibration.json` + `synthetic_data_gen.R` preserving covariate moments + cutoff density + per-cell mixture for the 23.55%-negative `y_farm_income`; verifier runs `verify_recovery.R` for ATT sign-agreement check), (iv) MDIS application URL + step-by-step in README. See `domain-reviewer.md` E-7 for editor/referee perspective.
- **Theoretical generality:** maintained at general (S,s) lumpy-investment level (Caballero & Engel 1999) so the same identification supports both journal-article framing and future thesis-chapter expansion. Korean policy specifics (PIDPS, SFFP) live in identification + data sections, not in the theoretical core.
- **Paper length:** 30–50 pages (journal-article scale, AJAE ≤ 50 pages double-spaced including references). Robustness in online appendix; main text carries headline + 1–2 robustness hints only.

---

## Core Principles

- **Plan first** — enter plan mode before non-trivial tasks; save to `quality_reports/plans/`. See [`plan-first-workflow.md`](.claude/rules/plan-first-workflow.md).
- **Verify after** — compile/render and confirm output at the end of every task.
- **Replicate before extend** — [`replication-protocol.md`](.claude/rules/replication-protocol.md) Phase 3 tolerance is non-negotiable (estimate < 0.01, SE < 0.05). No `/replicate-paper` skill — the rule + `/data-analysis` cover it.
- **English canonical, paper/ko derived** — primary edits to `paper/en/main.tex`; `paper/ko/main.tex` re-syncs from `paper/en/` post-stabilization. Never simultaneous bilingual edits. Drift kills bilingual papers.
- **Quality gates** — 80(commit) / 90(first submission) / 95(R&R response). Advisory; enforced inside `/commit`. See [`quality-gates.md`](.claude/rules/quality-gates.md).
- **[LEARN] tags** — when corrected, append `[LEARN:category] wrong → right` to [MEMORY.md](MEMORY.md).

---

## Identification Strategy (DiD-RD, ITT)

**Estimand: intent-to-treat (ITT) effect of statutory SFFP eligibility.** Wave 7 (2026-05-19 PR #15 MERGED, main @ `6b9c35d`) promoted `D_eligible_obs_2018` to the main treatment definition; the area-only `D_treat` was demoted to §7.1 robustness.

- **SFFP eligibility = 8 statutory criteria** (Act on Public-Interest Direct Payments to Farmers and Fishers, Article 10): (1) cultivated area ≤ 0.5 ha; (2) household-aggregate owned farmland < 1.55 ha; (3) farming tenure ≥ 3 years; (4) rural residence ≥ 3 years; (5) individual off-farm income < 20M KRW/year; (6) household off-farm income < 45M KRW/year; (7) NAQS Farm Business Registry; (8) 17 public-interest provisions (10% disbursement reduction on non-compliance with #8). FHES-observable: (1), (2), (6) — the other five are administered through MAFRA/NAQS/aT records.
- **Running variable:** `rv_2018 = area_2018 − 5000` — 2018 baseline cultivated area (㎡), centered at the 0.5 ha cutoff.
- **Cutoff:** 0.5 ha = 5,000 ㎡; equivalently `rv_2018 = 0`. Note: paper figures (Q7 raw convention, 2026-05-19) use raw `area_2018` on x-axis with cutoff line at 5,000 ㎡; analysis code retains `rv_2018` (centered).
- **Post:** 2020 onward (PIDPS effective 2020-05-01); pre-period 2018–2019.
- **Treatment dummy (MAIN, Wave 7):** `D_treat = (rv_2018 ≤ 0) ∧ (area_owned_total_2018 < 15,500) ∧ (off_farm_income_2018 < 45,000,000)` — statutorily-eligible indicator on FHES-observable criteria (1 + 2 + 6), all fixed at the 2018 baseline. Constructed in `scripts/R/01c_subset_clean.R`; produces `_outputs_eligibility/clean.rds` (3,420 hh / 13,689 obs after dropping 194 treated-but-ineligible). Mean `D_treat` = 0.312.
- **Treatment dummy (Wave 5 baseline, demoted to §7.1 robustness):** `D_treat = (rv_2018 ≤ 0)` — area-only. Original `clean.rds` in `_outputs/` preserved untouched (3,614 hh / 14,474 obs, mean `D` = 0.349). Compared side-by-side in `_outputs_eligibility/treatment_definition_comparison.{md,rds}`: 0/24 cells cross α=.05, ≤2.2% movement in op_cost.
- **Non-compliance rate:** 14.6% of area-eligible households (194 / 1,325) fail criteria (ii) or (vi) despite passing the area cutoff; 1.8% (ii) + 12.8% (vi); this is the ITT vs. ATT wedge.
- **Bandwidths (parallel reporting, never single-bandwidth):** T1 ±500 ㎡ / T2 ±1,000 ㎡ / T3 MSE-optimal (`rdrobust`).
- **Inference:** Wild cluster bootstrap at the household level + Holm step-down across multiple outcomes.
- **Primary outcomes (raw-data names → R-conventions names; PRIMARY ROLE SWAPPED 2026-05-20 per Phase 1 Blockers Q1B):** `y_farm_cost_ex_rent → op_cost_ex_rent` (농업경영비 from rent, **lumpy-investment (S,s) test — PRIMARY**; rent-net signal isolates the lumpy-capital response from the Kirwan pass-through channel), `y_off_income → off_farm_income` (농외소득, precautionary labor), `y_consump → consumption` (가계소비지출, smoothing), `y_farm_income → farm_income` (농가소득, omnibus). **Auxiliary / decomposition:** `y_farm_cost → op_cost` (농업경영비 전체, full operating cost — rent-inclusive omnibus comparator; reported alongside in `tab_main_did_rd_en.tex`), `y_rent_cost → rent_cost`, `area_rent`, `unit_rent_price` (CH4 rent-pass-through channel decomposition). Renames defined in `r-code-conventions.md` §10. Historical note: the 2026-05-06 LEARN entry established `op_cost` as primary; Phase 1 Blockers (2026-05-20) swapped to `op_cost_ex_rent` for cleaner (S,s) identification.
- **Theory:** Caballero & Engel (1999) (S,s) — primary behavioral; Kirwan (2009) *JPE* 117(1) / Ciaian et al. (2023) *Land Use Policy* 134 — primary incidence; Kazukauskas et al. (2013) *AJAE* — retention / extensive margin; Sandmo (1971) + Blundell & Pistaferri (2003) — auxiliary. **Three-channel "Tenant-Driven Land Transition" framing (P3b-2 reframed, 2026-05-17):** Korea's per-farm flat-rate triggers a coordinated transition among non-owner-operator smallholders along **three concurrent channels**, with effect magnitude monotonically increasing in baseline tenancy share (`own_share` quintile gradient verified in P3b-2): **(i) Bargaining margin** — unit_rent_price (rent_cost / area_rent) declines at narrow bandwidth for all non-pure-owner bins (T1 h=500: pure_tenant −48 p=0.059, low_owner −130 p=0.067, high_owner −63 p=0.075); per-farm structure shifts unit-price toward tenants. **(ii) Composition / Capitalization-avoidance margin (CH4)** — rented area shrinks with monotone gradient (T2: pure_tenant −1,738 m², low/mixed −600 to −800 highly significant); rent_cost overall reduces by −11.1% relative to 1.2M SFFP transfer (T2 h=1000), reversing US +25% (Kirwan 2009) and EU +46–55% (Ciaian et al. 2023). **(iii) Land-pivot / Extensive margin** — own-cultivated area expands with same tenant-driven gradient (Wave 7 D_eligible, T2: pure_tenant +1,122 m² p=0.041, low_owner +403 p=0.069, mixed +222 p=0.268, high_owner −74 NS, pure_owner ≡ 0 ref). **(S,s) anchor still load-bearing for the behavioral interpretation:** T/s_min ≈ 2.4% (s_min ≈ 5,000만원 Korean tractor/combine 자가부담) → lump-sum deeply within (S,s) inaction region → β(op_cost_ex_rent) ≤ 0 (Wave 7: T1 −3.98M p=0.057, T2 −3.13M p=0.097; Wave 5 area-only baseline: T1 −4.02M p=0.055 confirmed in §7.1 robustness). **Pure owner-operators (52% of treated cohort) experience minimal direct policy effect** by construction (no rent baseline). Parallel-trends gate clean (LN-10: all 2018 pre |t|<1). **Publishable AJAE/JAE-grade contribution** rests on the THREE concurrent monotone gradients (incidence + composition + extensive margin) being unique to per-farm flat-rate design, not on a single coefficient's significance. Auxiliary channels (Sandmo precautionary labor, Blundell-Pistaferri consumption smoothing) treated as robustness. See `.claude/agents/domain-reviewer.md` Lens 1 B-6 + Lens 5 E-6/E-7 for the full anchor + AJAE/Food Policy desk-review / referee defense.
- **Differentiation:** vs. Choi & Jodlowski (2025) — they study **land-ownership regulation**, we study **price subsidy at a cutoff**. vs. 최민영·문한필 (2025) — they use off-farm-income RDD only, we combine area cutoff + DiD.
- **Data:** Statistics Korea MDIS, Farm Household Economic Survey (FHES) Wave 1, 2018–2022. **Wave 7 main analysis** (3,420 farms, 13,689 farm-years; statutorily-eligible-or-control subset) verified on `scripts/R/_outputs_eligibility/clean.rds` (2026-05-19). Original full panel (3,614 farms, 14,474 farm-years) verified on `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` (2026-05-06) and preserved in `_outputs/clean.rds` for §7.1 area-only robustness. APCS linkage TBD.

---

## Folder Structure

```
01_dissertation_PBDP/
├── CLAUDE.md, MEMORY.md, Bibliography_base.bib
├── .claude/                    # Rules, skills, agents, hooks, references
├── paper/{ko,en}/              # (TBC) Korean draft → English translation
├── scripts/R/                  # FHES pipeline (numbered 01_clean → 05_robust); _outputs/ has RDS/figures
│   └── synthetic/              # Step 4 P5 — AEA DCAS code-only verification (synthetic_data_gen.R + calibration.json + verify_recovery.R + README.md)
├── data/                       # (TBC, gitignored) FHES microdata; APCS later
│   └── synthetic/              # (gitignored) generator outputs synthetic_panel.{dta,csv,rds} — regenerate before use

├── master_supporting_docs/     # supporting_papers/, supporting_slides/
├── quality_reports/            # plans/, specs/, session_logs/, peer_review_*/
├── explorations/               # Sandbox (60/100 threshold)
├── templates/                  # Spec, log, journal-profile templates
└── Slides/, Quarto/, Figures/, Preambles/, docs/   # Defense/conference (dormant)
```

---

## Commands

```bash
# R analysis — set.seed(20260504), see r-code-conventions.md
Rscript scripts/R/01_clean.R   &&   Rscript scripts/R/03_did_rd.R

# Compile manuscripts (XeLaTeX; Korean uses fontspec)
cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex
cd paper/ko && latexmk -xelatex -interaction=nonstopmode main.tex

# Quality score + reproducibility audit (or /audit-reproducibility skill)
python scripts/quality_score.py paper/en/main.tex

# (Dormant) defense slide deploy: ./scripts/sync_to_docs.sh DefenseDeck
```

---

## Quality Thresholds (advisory, enforced inside `/commit`)

| Score | Stage | Meaning |
|-------|-------|---------|
| 80 | Commit | Replication-protocol Phase 3 tolerance holds for every numeric claim |
| 90 | First submission | Passes `/seven-pass-review` and `/audit-reproducibility`; ready to send to AJAE/Food Policy/JAE |
| 95 | R&R response | Referee concerns systematically resolved via `/respond-to-referees` |

Direct `git commit` bypasses the gate; `/commit` halts on score < 80 and asks for explicit override + reason.

---

## Skills Quick Reference

**Research front-end**
- `/lit-review [topic]` — literature search + synthesis (BibTeX-ready)
- `/research-ideation [topic]` — hypotheses + identification strategies
- `/interview-me [topic]` — multi-turn idea formalization → spec
- `/preregister [--style aea-rct]` — preregistration draft

**Analysis (R)**
- `/data-analysis [dataset]` — end-to-end pipeline (clean → estimate → table/figure)
- `/did-rd-analysis` — *(Step 4 — TBC)* DiD-RD with 3-Tier bandwidth + Wild bootstrap + Holm
- `/lumpy-investment-check` — *(Step 4 — TBC)* (S,s) calibration check
- `/review-r [file]` — R code quality review
- `/audit-reproducibility [paper]` — numeric tolerance check (paper ↔ outputs)

**Writing (Korean → English)**
- `/translate-paper-ko-en` — *(Step 4 — TBC)* Korean section → English with policy glossary
- `/verify-claims [file]` — CoVe fact-check (citations, policy details, numbers)
- `/validate-bib`, `/proofread [file]` — bibliography cross-ref / grammar+typo

**Review & submission**
- `/review-paper [file] [--peer ajae|food-policy|jae]` — single-pass / `--adversarial` / journal-calibrated pipeline
- `/seven-pass-review` — 7-lens parallel review (submission-ready)
- `/respond-to-referees [report] [paper]` — R&R response draft
- `/agent-debate [topic]` — *(Step 4 — TBC)* 5-persona stress-test before writing

**Workflow infra:** `/commit`, `/checkpoint`, `/learn`, `/context-status`, `/permission-check`, `/deep-audit`.

**Slide skills (dormant — reactivate at qualifying exam / conference / defense):** `/compile-latex`, `/extract-tikz`, `/new-diagram`, `/visual-audit`, `/pedagogy-review`, `/qa-quarto`, `/slide-excellence`, `/translate-to-quarto`, `/devils-advocate`, `/create-lecture`, `/deploy`.

---

## Korean Policy Glossary

When citing Korean institutions or policy details in English drafts, use the canonical translations in `.claude/references/policy-glossary-ko-en.md` *(to be created in Step 5)*. Do not improvise — institutional names (**Public-Interest Direct Payment Scheme**, **Small-Farmer Flat Payment**) and statute references (**Act on Public-Interest Direct Payments to Farmers and Fishers, Article 10**) must match the glossary exactly. CoVe (`/verify-claims`) checks against this file.

---

## Current Project State

| Stage | Artifact | Status |
|-------|----------|--------|
| Draft v1 (Korean) | NRD553 term paper (Spring 2026) | ✅ Complete (`master_supporting_docs/own_drafts/초안.md`) |
| Replication baseline | Choi & Jodlowski (2025), Kirwan (2009) | ⏳ Pending |
| Analysis pipeline | `scripts/R/01_clean.R` → `05_robust.R` | ⏳ Pending |
| AEA DCAS synthetic generator (Step 4 P5) | `scripts/R/synthetic/` | ✅ Complete (2026-05-07) |
| **English draft v1** (primary, paper/en) | `paper/en/main.tex` (bootstrapped from Korean v1) | ⏳ Pending |
| Korean derived (auxiliary, paper/ko) | `paper/ko/main.tex` (re-synced from `paper/en/` post-stabilization; KAEA + thesis chapter) | ⏳ Deferred until paper/en stable |
| First submission target | AJAE | ⏳ Pending |

Defense slides (`Slides/`, `Quarto/`) and `HelloWorld` samples remain in repo for later reactivation.
