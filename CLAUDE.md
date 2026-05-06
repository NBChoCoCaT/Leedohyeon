# CLAUDE.md — Public-Interest Direct Payment Scheme (PIDPS) Research

**Project:** 공익직불제 소농직불금이 농가 투입 행태에 미치는 효과 — DiD-RD evidence at the 0.5 ha cutoff
**Target journals:** ① *American Journal of Agricultural Economics* (AJAE) → ② *Food Policy* → ③ *Journal of Agricultural Economics* (JAE)
**Author:** Lee, Dohyeon (Korea University, Dept. of Food and Resource Economics) — single-authored
**Workflow:** Canonical `paper/en/main.tex` (AJAE submission target); auxiliary `paper/ko/main.tex` derived post-stabilization (KAEA presentation + future thesis chapter base). Bootstrap once from existing Korean v1 (`master_supporting_docs/own_drafts/초안.md`).
**Branch:** main

---

## Goal

Single-author empirical paper for international peer-review submission, with thesis-chapter compatibility maintained.

- **Primary track:** `paper/en/main.tex` — direct journal submission (AJAE → Food Policy → JAE).
- **Auxiliary track:** `paper/ko/main.tex` — derived from `paper/en/` post-stabilization. Dual purpose: (i) future PhD thesis chapter base (Korea University Dept. of Food and Resource Economics; advisor: Lee Sangheon; currently enrolled), (ii) KAEA / 한국농경제학회 conference presentation.
- **Bootstrap:** existing Korean v1 (`master_supporting_docs/own_drafts/초안.md`, 36 KB) → `paper/en/main.tex` (one-time port). After this, `paper/en/` is canonical; `paper/ko/` re-syncs from `paper/en/` once stable.
- **Replication standard:** AEA Data Editor checklist — full reproducibility package (`scripts/R/`, `_outputs/`, `data/var_dictionary.csv`, README) at first submission.
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

## Identification Strategy (DiD-RD)

- **Running variable:** `rv_2018 = area_2018 − 5000` — 2018 baseline cultivated area (㎡) **centered at the 0.5 ha cutoff** (observed range −4,986 to +521,696 ㎡; pre-policy measurement blocks manipulation).
- **Cutoff:** 0.5 ha = 5,000 ㎡ raw area, equivalently `rv_2018 = 0` centered — eligibility threshold for Small-Farmer Flat Payment (SFFP, 소농직불금, 1,200,000 KRW/year flat).
- **Post:** 2020 onward (PIDPS effective 2020-05-01); pre-period 2018–2019.
- **Treatment dummy:** `D = 1` if `rv_2018 ≤ 0` ↔ `area_2018 ≤ 5000` — fixed at 2018 baseline. Raw-data variable is **`D`** (R-conventions standardizes to `D_treat` via rename in `01_clean.R`; see `r-code-conventions.md` §10). Verified on `panel_2018_2022.dta` (2026-05-06): 14,474/14,474 obs match; `D` time-invariant per household (0/3,614 change across years); mean `D` = 0.349.
- **Bandwidths (parallel reporting, never single-bandwidth):** T1 ±500 ㎡ / T2 ±1,000 ㎡ / T3 MSE-optimal (`rdrobust`).
- **Inference:** Wild cluster bootstrap at the household level + Holm step-down across multiple outcomes.
- **Primary outcomes (raw-data names → R-conventions names):** `y_farm_cost → op_cost` (농업경영비 전체, lumpy investment, primary), `y_off_income → off_farm_income` (농외소득, precautionary labor), `y_consump → consumption` (가계소비지출, smoothing), `y_farm_income → farm_income` (농가소득, omnibus). Auxiliary for robustness: `y_farm_cost_ex_rent`, `y_rent_cost` (임차료 controls; reserved for Kirwan channel decomposition). Renames defined in `r-code-conventions.md` §10.
- **Theory:** Caballero & Engel (1999) (S,s) — primary; Sandmo (1971) — auxiliary 1; Blundell & Pistaferri (2003) — auxiliary 2.
- **Differentiation:** vs. Choi & Jodlowski (2025) — they study **land-ownership regulation**, we study **price subsidy at a cutoff**. vs. 최민영·문한필 (2025) — they use off-farm-income RDD only, we combine area cutoff + DiD.
- **Data:** Statistics Korea MDIS, Farm Household Economic Survey (FHES) Wave 1, 2018–2022 (3,614 farms, 14,474 farm-years; verified on `master_supporting_docs/own_drafts/rawdata/panel_2018_2022.dta` 2026-05-06). APCS linkage TBD.

---

## Folder Structure

```
01_dissertation_PBDP/
├── CLAUDE.md, MEMORY.md, Bibliography_base.bib
├── .claude/                    # Rules, skills, agents, hooks, references
├── paper/{ko,en}/              # (TBC) Korean draft → English translation
├── scripts/R/                  # FHES pipeline (numbered 01_clean → 05_robust); _outputs/ has RDS/figures
├── data/                       # (TBC, gitignored) FHES microdata; APCS later
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
| **English draft v1** (primary, paper/en) | `paper/en/main.tex` (bootstrapped from Korean v1) | ⏳ Pending |
| Korean derived (auxiliary, paper/ko) | `paper/ko/main.tex` (re-synced from `paper/en/` post-stabilization; KAEA + thesis chapter) | ⏳ Deferred until paper/en stable |
| First submission target | AJAE | ⏳ Pending |

Defense slides (`Slides/`, `Quarto/`) and `HelloWorld` samples remain in repo for later reactivation.
