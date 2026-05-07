# Plan: 단계 3-1 + 3-2 — Rules 커스터마이즈 (R 컨벤션 + 품질 게이트)

**Status:** APPROVED → COMPLETED (2026-05-04 12:08)
**Date:** 2026-05-04
**Author:** Claude (이도현 박사논문 프로젝트)
**Step:** 3-1 + 3-2 of 6 (단계 1-2 완료; 3-3 domain-reviewer는 별도 plan으로 후속)
**Active sentinel file:** `quality_reports/plans/floofy-soaring-harbor.md` (identical content + Step 2 lock note + outcome verification block)

---

## Context

단계 2에서 `CLAUDE.md`를 PIDPS DiD-RD 연구·해외 저널 게재 모드로 재정렬했다. 이제 `CLAUDE.md`에 명시된 두 가지 핵심 규칙 파일을 박사논문 작업에 맞게 customize한다:

- **3-1 `r-code-conventions.md`**: 현재 Pedro 템플릿 표준(fixest, modelsummary, set.seed, numerical discipline)은 잘 갖춰져 있으나 **FHES 데이터 특수성**(한국어 변수명, 농가 패널 구조)과 **DiD-RD 분석 컨벤션**(클러스터링, 표·그림 출력)이 비어 있다. line 30·71에 명시된 "Customize for your field" 슬롯을 채운다.
- **3-2 `quality-gates.md`**: 현재 80/90/95는 advisory 상태로만 남아 있고, `CLAUDE.md`의 "Commit / First submission / R&R response" 의미와 동기화되어 있지 않다. 또한 한국 정책 인용 정확성과 한·영 인용 형식 강제 항목이 누락되어 있다.

8개 결정사항(4개 도현님 답변 + 4개 default)을 두 파일에 반영하면, 단계 3-3(`domain-reviewer.md`)이 이 두 rule을 전제로 5-Lens 작업을 설계할 수 있다.

---

## Critical Files

| 파일 | 역할 | 변경 |
|------|------|------|
| `.claude/rules/r-code-conventions.md` | 단계 3-1 편집 대상 | 기존 §1-9 보존, §10-14 신규 추가 (~+40줄) |
| `.claude/rules/quality-gates.md` | 단계 3-2 편집 대상 | 기존 4개 deduction 표에 Stage 컬럼 추가, 신규 §3·§4 추가 (~+30줄) |
| `Bibliography_base.bib` | 단계 3-2와 함께 컨벤션 명시만 (실제 entry는 후속) | 한·영 dual-field 컨벤션 주석 추가 |
| **참조 (변경 X):** | | |
| `.claude/skills/validate-bib/SKILL.md` | scan 대상에 `paper/{ko,en}/**/*.tex` 추가는 단계 4에서 | — |
| `.claude/skills/data-analysis/SKILL.md` | 신규 r-code 컨벤션을 Pre-Flight에서 자동 인용 | — |
| `.claude/agents/r-reviewer.md` | 새 컨벤션 자동 적용 (paths: scoped) | — |

**No new files in this step.** Bibliography_base.bib에 주석 추가만, 실제 엔트리(Choi-Jodlowski, Caballero-Engel 등)는 단계 4 분석 시작 시점에 추가.

---

## 단계 3-1: `r-code-conventions.md` 변경 설계

### 기존 구조 (보존)
§1 Reproducibility / §2 Function Design / §3 Domain Correctness / §4 Visual Identity / §5 RDS Pattern / §6 Common Pitfalls / §7 Line Length / §8 Numerical Discipline / §9 Code Quality Checklist

### 신규 추가 (5개 섹션, ~40줄)

#### §10 FHES Variable Naming Convention (신규, ~12줄)

원본 한국어 변수명 → snake_case 영문 표준화 + label_ko attribute 보존 + var_dictionary.csv 매핑.

```markdown
## 10. FHES Variable Naming Convention

**Standardize Korean source variable names to snake_case English while preserving the original.**

| Source (FHES) | Standardized R name | Type | Notes |
|---------------|---------------------|------|-------|
| 농가식별번호 | `hh_id` | integer | Primary key (cluster unit) |
| 시군구코드 | `sgg_cd` | integer | Robustness cluster unit |
| 조사연도 | `year` | integer | Panel time index |
| 경지면적 (2018 baseline) | `rv_2018` | numeric (㎡) | Running variable, fixed at 2018 |
| 경지면적 (annual) | `area_t` | numeric (㎡) | Time-varying, NOT running variable |
| 농업경영비 | `op_cost` | numeric (KRW) | Primary outcome (lumpy investment) |
| 농외소득 | `off_farm_income` | numeric (KRW) | Auxiliary outcome 1 (Sandmo) |
| 가계소비지출 | `consumption` | numeric (KRW) | Auxiliary outcome 2 (Blundell-Pistaferri) |
| 농업소득 | `farm_income` | numeric (KRW) | Omnibus outcome |
| 처치 더미 | `D_treat` | logical | `rv_2018 ≤ 5000` |
| 시점 더미 | `Post` | logical | `year ≥ 2020` |
| 표본가중치 | `weight_national` | numeric | National-rep weight (robustness) |

**Mandatory pattern when reading raw FHES:**

```r
df_fhes <- read_csv("data/fhes_raw.csv") %>%
  rename(hh_id = 농가식별번호, year = 조사연도, op_cost = 농업경영비, ...)

# Preserve original Korean label as attribute (labelled package)
attr(df_fhes$op_cost, "label_ko") <- "농업경영비"
```

Maintain `data/var_dictionary.csv` (3 columns: `r_name`, `source_name_ko`, `definition_en`) and refer to it in every analysis script header.
```

#### §11 DiD-RD Clustering Convention (신규, ~8줄)

```markdown
## 11. DiD-RD Clustering Convention

- **Primary cluster:** household (`hh_id`). All headline tables in `paper/{ko,en}/` use this.
- **Robustness cluster:** sub-district (`sgg_cd`). Reported in online supplement / online appendix.

```r
# Headline (primary)
m_main <- feols(op_cost ~ D_treat * Post + controls, data = df, cluster = ~hh_id)

# Robustness (sub-district), report side-by-side in appendix
m_sgg  <- feols(op_cost ~ D_treat * Post + controls, data = df, cluster = ~sgg_cd)
```

Wild cluster bootstrap: use `fwildclusterboot::boottest()` at `hh_id`. Holm step-down across the 4 primary outcomes via `p.adjust(..., method = "holm")` after collecting Wild bootstrap p-values.
```

#### §12 sessionInfo and renv Convention (신규, ~7줄)

```markdown
## 12. Reproducibility Snapshot

- **Every analysis script writes `_outputs/sessionInfo.txt`** as the last action of Phase 5 (Save and Review). Use `writeLines(capture.output(sessionInfo()), "scripts/R/_outputs/sessionInfo.txt")`.
- **renv lockfile:** activate **only at first-submission stage** (`renv::init()` immediately before generating the replication package, ~Step 6 of paper milestones in `CLAUDE.md`). During analysis, system R is fine — but pin every `library()` package version in script comments as a fallback.
- **Paper inclusion:** main text lists only key package versions (fixest, rdrobust, did, fwildclusterboot, modelsummary). Full `sessionInfo` goes in online supplement.
```

#### §13 Figure & Table Output Convention (신규, ~10줄)

```markdown
## 13. Figure & Table Output Convention

**Figures (publication-grade PDF + dormant PNG):**

```r
# Save BOTH formats — PDF for paper/, PNG for future defense slides (dormant)
ggsave("scripts/R/_outputs/fig_did_rd_main.pdf", plot = p, width = 6, height = 4.5,
       device = cairo_pdf, bg = "white")
ggsave("scripts/R/_outputs/fig_did_rd_main.png", plot = p, width = 6, height = 4.5,
       dpi = 300, bg = "transparent")  # transparent for slide overlay
```

**Tables (single source via modelsummary → both LaTeX flavors):**

```r
# Generates LaTeX consumed by paper/ko (Korean labels) and paper/en (English labels)
modelsummary(list("(1)" = m_T1, "(2)" = m_T2, "(3)" = m_T3),
             output = "scripts/R/_outputs/tab_main_did_rd_en.tex",
             coef_map = en_label_map, ...)
modelsummary(list("(1)" = m_T1, "(2)" = m_T2, "(3)" = m_T3),
             output = "scripts/R/_outputs/tab_main_did_rd_ko.tex",
             coef_map = ko_label_map, ...)
```

Naming: `fig_<topic>.{pdf,png}`, `tab_<topic>_<lang>.tex`. Manuscripts pull these via `\input{...}`.
```

#### §14 Common Pitfalls — FHES specific additions to existing §6 table (신규 행, ~5줄)

기존 §6 Common Pitfalls 표에 FHES-specific 행 추가 (별도 신규 섹션 아님):

| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Treatment dummy from time-varying area | Manipulation contamination, RD invalid | Always use `rv_2018` (2018 baseline), never `area_t` |
| Unbalanced panel from FHES Wave 1→2 transition | 2023+ farms not connected to 2018 cohort | Restrict to `year ∈ 2018:2022`; Wave 2 linkage TBD |
| `weight_national` ignored or applied inconsistently | Biased descriptives **OR** inefficient/biased estimation | **Stage-specific rule (Solon, Haider, Wooldridge 2015 JHR):** (a) Table 1 descriptives — `weight_national` **mandatory** via `survey::svydesign()` for population representativeness; (b) Main estimation (Table 2, ATT) — **unweighted by default** (more efficient under correct specification), report `weight_national` weighted version as a separate robustness table; (c) If weighted vs unweighted differ materially, the gap must be discussed in the discussion section as evidence of treatment-effect heterogeneity. Cite Solon, Haider, and Wooldridge (2015) "What Are We Weighting For?" *JHR* 50(2): 301–316. |
| 한국어 인코딩 깨짐 (CP949 vs UTF-8) | Variable mapping fails silently | Force `read_csv(..., locale = locale(encoding = "UTF-8"))` |

### 변경 요약 (3-1)

- 신규 섹션: §10, §11, §12, §13 (4개)
- 기존 §6 표에 4행 추가
- 총 추가: ~40줄 → 124줄 → ~165줄 (path-scoped rule, 항상 로드되지 않음 → 길이 부담 없음)

---

## 단계 3-2: `quality-gates.md` 변경 설계

### 기존 구조 (보존하되 재구성)
§1 Thresholds (80/90/95) / §2 Quarto Slides 표 / §3 R Scripts 표 / §4 Beamer Slides 표 / §5 Enforcement / §6 Quality Reports / §7 Tolerance Thresholds (Research)

### 변경 1: 80/90/95 의미 갱신 + Stage 컬럼 추가

기존 Thresholds 섹션 교체 + 4개 deduction 표 (Quarto/R/Beamer/신규) 위에 'Stage' 컬럼 추가:

```markdown
## Thresholds (synced with CLAUDE.md)

| Score | Stage | Meaning |
|-------|-------|---------|
| 80 | Commit | Replication-protocol Phase 3 tolerance holds for every numeric claim |
| 90 | First submission | Passes `/seven-pass-review` and `/audit-reproducibility`; ready to send to AJAE/Food Policy/JAE |
| 95 | R&R response | Referee concerns systematically resolved via `/respond-to-referees` |

Each deduction table below adds a **Stage column** indicating whether the issue blocks Commit (80), First submission (90), or R&R response (95). Items blocking submission/R&R are advisory at commit time.
```

기존 deduction 표(R Scripts 예시) 변경 형태:

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | Syntax errors | -100 | 80 / 90 / 95 |
| Critical | Domain-specific bugs | -30 | 80 / 90 / 95 |
| Critical | Hardcoded absolute paths | -20 | 80 / 90 / 95 |
| Major | Missing set.seed() | -10 | 80 / 90 / 95 |
| Major | Missing figure generation | -5 | **90** / 95 |

(Quarto/Beamer 표도 동일 패턴; 'Stage-blocking' 컬럼 추가)

### 변경 2: 신규 §3.5 — 영문 Manuscript Quality 표 (paper/en/**)

기존 표는 Beamer/Quarto/R 위주 — 영문 manuscript용 표가 누락. 신규 추가:

```markdown
## English Manuscript (paper/en/**/*.tex)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | XeLaTeX compile failure | -100 | 80 / 90 / 95 |
| Critical | Undefined citation | -15 | 80 / 90 / 95 |
| Critical | Korean policy citation error (date / amount / statute) | -15 | 80 / 90 / 95 |
| Critical | English citation in Korean style format | -15 | **90** / 95 (paper/en strictly English-style) |
| Major | Numeric claim inconsistent with `_outputs/*.rds` | -10 | 80 / 90 / 95 |
| Major | Weighting decision unjustified or inconsistent across tables (per Solon-Haider-Wooldridge 2015 stage rule in r-code-conventions §6) | -10 | 80 / 90 / 95 |
| Major | Missing robustness check (cluster=sgg_cd, MSE-bandwidth) | -5 | **90** / 95 |
| Minor | Notation inconsistency across sections | -3 | 95 |
| Minor | Korean phrasing leaked into English text | -3 | **90** / 95 |
```

### 변경 3: 신규 §3.6 — 한국어 Manuscript Quality 표 (paper/ko/**)

```markdown
## Korean Manuscript (paper/ko/**/*.tex)

| Severity | Issue | Deduction | Stage-blocking |
|----------|-------|-----------|----------------|
| Critical | XeLaTeX (with fontspec) compile failure | -100 | 80 / 90 / 95 |
| Critical | Undefined citation | -15 | 80 / 90 / 95 |
| Critical | Korean policy citation error (date / amount / statute) | -15 | 80 / 90 / 95 |
| Major | English citation forced into paper/ko (should use Korean form) | -10 | 80 / 90 / 95 |
| Major | Numeric claim inconsistent with `_outputs/*.rds` | -10 | 80 / 90 / 95 |

**Note:** paper/ko is the upstream draft; numeric claims must match `_outputs/*.rds` BEFORE translation begins. Translation drift checked separately at translate-paper-ko-en stage.
```

### 변경 4: 신규 §7 — Korean Policy Citation Accuracy

기존 §7 (Tolerance Thresholds) 위에 새 §7 삽입 (기존 §7 → §8로 밀어냄):

```markdown
## Korean Policy Citation Accuracy

Every claim about PIDPS / Small-Farmer Flat Payment / Korean agricultural law must match the canonical reference data:

| Claim type | Source of truth | Deduction if wrong |
|------------|-----------------|---------------------|
| Statute article (예: 법령 제10조) | `.claude/references/policy-glossary-ko-en.md` (Step 5) | -15 (Critical) |
| Effective date (2020-05-01) | Same | -15 (Critical) |
| Subsidy amount (1,200,000 KRW/year flat) | Same | -15 (Critical) |
| Institution English name (e.g., **Public-Interest Direct Payment Scheme**, **Small-Farmer Flat Payment**) | Same | -5 (Minor) |

CoVe (`/verify-claims`) auto-checks all four claim types against `policy-glossary-ko-en.md` before any commit on `paper/{ko,en}/**`.
```

### 변경 5: 신규 §8 — Bilingual Citation Format Enforcement

```markdown
## Bilingual Citation Format Enforcement

Citation format is **directory-scoped**:

| Directory | Required format | Example |
|-----------|-----------------|---------|
| `paper/ko/**/*.tex` | Korean form | 김태화·양승룡(2021) |
| `paper/en/**/*.tex` | Author-year (English) | Kim and Yang (2021) |

`Bibliography_base.bib` MUST carry both forms in dual fields per entry:

```bibtex
@article{KimYang2021_pidps,
  author    = {김태화 and 양승룡},                  % Korean form
  author_en = {Kim, Tae-hwa and Yang, Seung-ryong}, % English form
  title     = {공익직불제 정책 분석},
  title_en  = {Policy Analysis of the Public-Interest Direct Payment Scheme},
  journal   = {농업경영·정책연구},
  year      = {2021}
}
```

`/validate-bib` (extended in Step 4) detects format mismatch by file path. Until then, manual + CoVe enforcement.
```

기존 §7 Tolerance Thresholds (현재 도메인 customize 슬롯)는 §9로 이동, 내용 채움:

```markdown
## §9 Tolerance Thresholds (Research)

| Quantity | Tolerance | Rationale |
|----------|-----------|-----------|
| Point estimates (replication) | < 0.01 | Display rounding in source paper |
| Standard errors (replication) | < 0.05 | Bootstrap/clustering MC variance |
| Coefficient ratios (own results) | < 1e-6 | Numerical precision |
| Wild bootstrap p-values | ± 0.005 across reps | B = 9,999 reps; seed-pinned |
| Coverage rates (simulation) | ± 0.01 | MC error at 1,000 reps |
```

### 변경 요약 (3-2)

- §1 Thresholds: 갱신 (CLAUDE.md와 동기화)
- §2/§3/§4 deduction 표: Stage-blocking 컬럼 추가
- §3.5/§3.6: 영문/한국어 manuscript 표 신규
- §7/§8: Korean policy citation + Bilingual citation format 신규
- §9: Tolerance 채움
- 총 추가: ~30줄 → 70줄 → ~100줄

---

## Bibliography_base.bib 변경 (3-2 부산물)

기존 EXAMPLE entries 아래에 한·영 dual-field 컨벤션 주석 추가 (~10줄). 실제 PIDPS-relevant 엔트리(Choi-Jodlowski, Caballero-Engel, 김태화·양승룡 등)는 단계 4 분석 시작 시점에 `/lit-review`로 채움.

---

## Verification (단계 3-1 완료 후)

1. **줄 수:** `wc -l .claude/rules/r-code-conventions.md` → 160-170줄 범위
2. **path-scope 무결성:** 첫 줄의 `paths:` (`**/*.R`, `Figures/**/*.R`, `scripts/**/*.R`)는 변경 없이 유지
3. **새 섹션 가독성 테스트:** 새 conversation에서 R 스크립트 작성 요청 시, Claude가 `hh_id`, `op_cost`, `D_treat = (rv_2018 ≤ 5000)` 등 신규 컨벤션을 자동 적용하는지 확인 (도현님 직접 테스트)
4. **r-reviewer agent 부수효과:** 기존 r-reviewer.md는 변경 없음. paths-scoped rule이라 자동 인지

## Verification (단계 3-2 완료 후)

1. **줄 수:** `wc -l .claude/rules/quality-gates.md` → 95-110줄
2. **path-scope 확장:** 첫 줄의 `paths:` (`Slides/**/*.tex`, `Quarto/**/*.qmd`, `scripts/**/*.R`)에 **`paper/**/*.tex` 추가**
3. **CLAUDE.md ↔ quality-gates.md 동기화:** Stage 표 텍스트가 일치하는지 grep으로 확인
4. **/commit skill 부수효과 확인:** 새 deduction 표는 quality_score.py가 자동 적용 (path-scoped). `python scripts/quality_score.py paper/en/main.tex` 명령이 영문 manuscript 표를 적용하는지 단계 4 시점에 검증

---

## Out of Scope

- `/validate-bib` skill의 `paper/{ko,en}/**` 스캔 대상 추가 (단계 4)
- `policy-glossary-ko-en.md` 신규 작성 (단계 5)
- `Bibliography_base.bib`에 실제 엔트리(Choi-Jodlowski 등) 추가 (단계 4)
- `r-reviewer.md` 본문 변경 (필요 시 별도 plan)
- `data-analysis` skill의 Pre-Flight 갱신 (기존 path-scoped rule 자동 인용으로 커버)
- `MEMORY.md` 신규 작성 (단계 6)

---

## After Approval

1. ExitPlanMode
2. 본 plan status DRAFT → APPROVED → COMPLETED (작업 완료 후)
3. **단계 3-1 먼저 실행** (r-code-conventions.md 편집)
4. `wc -l` + grep 검증 (자동)
5. **도현님 검토 후 단계 3-2로 진행** (quality-gates.md 편집 + Bibliography_base.bib 주석)
6. 검증 완료 후 단계 3-3(domain-reviewer.md) 별도 plan 작성 의사 확인
