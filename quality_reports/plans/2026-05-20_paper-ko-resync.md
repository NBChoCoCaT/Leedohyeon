# paper/ko 재동기화 — Wave 10.5 캐논 미러링

**Status:** DRAFT (pending approval)
**Date:** 2026-05-20
**Sister filename (post-approval):** `2026-05-20_paper-ko-resync.md`
**Cross-ref:** Wave 10 PR #27 / #28 (`bda5190`, `4eb84c3`)
**Estimated time:** 2–2.5 working days

---

## Context

`paper/ko/main.tex`는 2026-05-15 (`39c02d8`) 이후 update 없음 — Wave 7/8/9/10/10.5 거치며 paper/en이 506 라인으로 안정화되는 동안 paper/ko는 382 라인, 옛 §3 구조(11 subsec, 5-channel 세분화)와 모든 §1/§2/§4–§9 STUB 상태로 멈춰 있음. paper/en이 AJAE 제출 준비 단계(composite ~9.14)에 도달했으므로 CLAUDE.md 약속대로 paper/ko를 **post-stabilization derive**해야 함.

**용도:** (a) KAEA / 한국농경제학회 발표용, (b) 박사학위 thesis chapter base (지도교수 이상헌, 고려대 식품자원경제학과). 향후 paper/en update 시 re-sync 반복 가능한 패턴 확립이 부산물.

**User decisions (2026-05-20):**
- 전략: **전면 재유도 (overwrite)**, `/econ-write` 스킬 사용
- 범위: `main.tex` only (online_appendix 별도 작업)
- 테이블: Wave 10 신규 3개 + EN-only 5개 = **8개 `_ko.tex` 신규 생성**
- 데드라인: 없음 — 안정성 우선

---

## Approach

**3-Phase 순차 실행.** A → B → C, 각 단계 완료 후 verification 게이트.

### Phase A — 8개 `_ko.tex` 테이블 생성 (R-side, ~3–4시간)

기존 패턴 (`scripts/R/03_did_rd.R:447-490` `write_main_table()`, `scripts/R/02_descriptive.R:149-202` `write_table1_tex()`) 복제. 핵심 컨벤션:

| Element | Convention |
|---|---|
| Function signature | `write_X(data, lang, caption, label, path)` with `lang ∈ {"en","ko"}` |
| Caption | 한국어 (inline literal) |
| Column 헤더 | 변수/통제/처치/차이/p-값/관측치 (등) |
| Outcome row label | `attr(df$op_cost, "label")` haven 라벨 우선; 없으면 `c("op_cost"="농업경영비", ...)` lookup |
| 코드 식별자 (변수명) | 영어 유지 (`op_cost`, `D_Post`) |
| 통계 라벨 | T1/T2/T3/N/SE/FHES/hh_id/Holm — 영어 유지 |
| Notes prefix | `\textit{주:}` |
| `writeLines` | `useBytes = (lang == "ko")` 으로 UTF-8 안전 출력 |

**8개 스크립트별 작업:**

| # | Script | New output | Notes |
|---|---|---|---|
| A1 | `scripts/R/04c_cct_covariate_continuity.R` | `tab_cct_covariate_continuity_ko.tex` | 18 cells (6 cov × 3 BW); 공변량 연속성 |
| A2 | `scripts/R/11c_cjm_density.R` | `tab_cjm_density_ko.tex` | 4 window × 3 p (conv/BC/robust); CJM 밀도 검정 |
| A3 | `scripts/R/07b_fuzzy_bin_sensitivity.R` | `tab_fuzzy_bin_sensitivity_ko.tex` | 3-panel (strict/donut/shifted); 측정오차 민감도 |
| A4 | `scripts/R/10_alpha3_estimation.R` | `tab_alpha3_results_ko.tex` | α3 framework 결과 |
| A5 | `scripts/R/15b_attrition_placebo_full.R` | `tab_attrition_placebo_full_ko.tex` | T1/T2/T3 placebo |
| A6 | `scripts/R/14b_dropped_hh_balance.R` | `tab_dropped_balance_ko.tex` | 194 dropped HH 균형 |
| A7 | `scripts/R/13b_placebo_cutoffs.R` | `tab_placebo_cutoffs_ko.tex` | 0.3/0.4/0.6/0.7 ha placebo cutoffs |
| A8 | `scripts/R/04b_sido_robustness.R` | `tab_sido_robustness_ko.tex` | Spec A + Spec B sido FE (301 라인 스크립트) |

**언어 중립 (수정 불요):** `tab_specB.tex`, `tab_specC.tex` — 캡션·헤더 모두 영어지만 본문이 숫자+outcome 코드명만이라 paper/ko에서도 그대로 사용 가능. 단, `\multicolumn` 내 `\textit{op\_cost\_ex\_rent}` 같은 코드명은 KO 본문이 caption만 다시 쓰는 형태로 처리 (`\input`은 그대로, paper/ko 본문이 표 위에 한국어 caption + reference 부여).

**기존 12개 `_ko.tex` 테이블 (이미 존재 → paper/ko에서 즉시 사용):**
`tab_descriptives_ko`, `tab_main_did_rd_ko`, `tab_het_own_share_ko`, `tab_ch3_retention_ko`, `tab_ch4_rent_decomposition_ko`, `tab_ch5_area_decomposition_ko`, `tab_ch5_attrition_profile_ko`, `tab_ch5_exit_definitions_ko`, `tab_ch5_reconciliation_ko`, `tab_rob_outlier_ko`, `tab_stabilization_ko`, `tab_wild_bootstrap_ko`.

**Per-script verification:** 각 스크립트 수정 후 `Rscript scripts/R/XX.R` 실행 → `_ko.tex` 파일 생성 확인 + visual inspect (한국어 captions, 번역 헤더, UTF-8 encoding).

### Phase B — `paper/ko/main.tex` 전면 재유도 (~1.5일)

**전략:** `paper/en/main.tex` (506 라인, 2026-05-20 Wave 10.5)을 8-section 단위로 `/econ-write` 통해 번역. 기존 `paper/ko/main.tex` (382 라인, 옛 §3) 백업 후 새로 작성.

**Backup 처리:** Git history 보존이 자연 백업 (`git log paper/ko/main.tex` 으로 옛 버전 항상 복구 가능). 별도 `.bak` 파일 생성 불요.

**구조 미러링 (paper/en → paper/ko):**

| § | EN title | KO title | Subsec | Tables/Figures |
|---|---|---|---|---|
| 1 | Introduction | 서론 | — | — |
| 2 | Institutional Context | 제도적 배경 | 3 (개혁·자격·식별포지) | — |
| 3 | Conceptual Framework | 개념적 틀 | 4 (기준AHM·자산편향·암묵노동·통합예측) | tab:notation + tab:alpha3-predictions |
| 4 | Data | 자료 | — | tab_descriptives_ko |
| 5 | Empirical Strategy | 식별 전략 | — | — |
| 6 | Results | 결과 | — | tab_het_own_share_ko, tab_main_did_rd_ko, tab_ch4_rent_decomposition_ko, fig_f1_fourbin_gradient_T2 |
| 7 | Robustness | 견고성 | 4 (밀도·공변량·측정오차·placebo·하위FE·triple-margin·시계열) | tab_cjm_density_ko, tab_cct_covariate_continuity_ko, tab_fuzzy_bin_sensitivity_ko, tab_rob_outlier_ko, tab_wild_bootstrap_ko, tab_specB, tab_specC, tab_dropped_balance_ko, tab_attrition_placebo_full_ko, tab_placebo_cutoffs_ko, tab_sido_robustness_ko + 4 figures |
| 8 | Discussion and Conclusion | 논의 및 결론 | — | — |

**번역 컨벤션 (econ-write skill 활용):**

1. **정책 용어 (CLAUDE.md §Korean Policy Glossary 준수):**
   - PIDPS = 공익직불제 (Public-Interest Direct Payment Scheme)
   - SFFP = 소농직불금 (Small-Farmer Flat Payment)
   - FHES = 농가경제조사 (Farm Household Economic Survey)
   - 법령: 농어업인 등에 대한 공익직불금 지급에 관한 법률 제10조
   - 시행일: 2020-05-01
   - 금액: 1,200,000원/년 (소농직불금), 2,050,000원/ha (논·보호구역 ABP) 등

2. **수치 표기:** "1,200,000원" / "11,010 농가-연도" / "2,776 농가" — 영문 paper와 동일 단위, 한국어 콤마

3. **인용:**
   - 영문 저자 17개 (Kirwan, Ciaian, Caballero-Engel, Singh-Squire-Strauss, Carter-Olinto, Eswaran-Kotwal 등): `\citet{Key}` 그대로 → "Kirwan (2009)" 출력 (preamble_ko의 `plainnat` 사용; bib audit 결과 paper/ko와 paper/en 출력 동일함을 확인)
   - 한국 저자 2개 (`ChoiMun2025_pidps_offinc`, `KAMICO_pricelist_2022`): paper/ko에서는 `\citet{}` 대신 본문에 **수동 인라인** "최민영·문한필 (2025)", "한국농기계공업협동조합 (2022)" — `\nocite{}` 또는 직접 텍스트. 이유: 현 시스템에서 natbib이 author_ko 필드를 자동 라우팅 못함 (`/validate-bib` 미구현). Custom .bst 별도 작업으로 분리.

4. **수식·라벨·참조:** `\label{eq:CO-1}`, `\ref{tab:notation}`, `\S\ref{sec:liquidity}` 등 모든 cross-ref는 동일 ID 유지 (cross-document 호환). 단, `\externaldocument{online_appendix}` 라인은 paper/ko에 online_appendix가 없으므로 **제거** + 본문 내 "Online Appendix §B.1" 류 참조는 "온라인 부록 §B.1 (영문판 참조)"로 명시.

5. **각주 (`\footnote{}`):** 모든 각주 한국어 번역; URL·DOI·파일경로는 유지.

6. **테이블 캡션 라벨:** paper/en의 `\label{tab:descriptives_en}` 류는 표 자체 라벨이므로 paper/ko에서는 `\input{...tab_descriptives_ko.tex}`로 가져온 표가 `tab:descriptives_ko`를 정의. 본문 reference도 `\ref{tab:descriptives_ko}`로 통일.

7. **그림:** Wave 1에서는 `_en.pdf` 그림 그대로 사용 + 한국어 caption만 새로 작성 (그림 내 축 라벨은 영어 유지). `_ko.pdf` variant 생성은 KAEA 발표 직전 별도 작업으로 분리. 6개 그림: `fig_f1_fourbin_gradient_T2_en.pdf`, `fig_mccrary_density_full_en.pdf`, `fig_event_study_op_cost_T2_en.pdf`, `fig_honestdid_sensitivity_b1_en.pdf`, `fig_forest_treatment_definitions_en.pdf`, `fig_mccrary_multi_rv_en.pdf`.

8. **/econ-write 호출 단위:** 섹션당 1회 호출 (8회 총합). 각 호출에 paper/en 해당 섹션 본문 + 위 컨벤션 7개 항목 + 인접 섹션 cross-ref 미리보기 제공. 출력은 paper/ko/main.tex에 incremental append.

**제목·저자·abstract:**
- 제목: "농가별 정액 직불제 컷오프에서 농가모형 분리성 검정: 한국의 증거"
- Keywords: 농가모형(AHM); 분리성; 회귀불연속; 이중차분; 직불금; 소농; 유동성; 한국
- JEL: Q12, Q15, Q18, D13, D14

### Phase C — Verification (2–3시간)

C1. **Compile:** `cd paper/ko && latexmk -xelatex -interaction=nonstopmode main.tex`
- 목표: 0 errors, undefined references = 0, overfull hbox ≤ 10 (paper/en은 7)
- 페이지 수 paper/en (57p)에 ±10% 이내

C2. **`/audit-reproducibility paper/ko/main.tex scripts/R/_outputs_symmetric/`**
- 모든 수치 claim (계수, p-값, N) tolerance 통과 (point estimate < 0.01, SE < 0.05, N exact)
- paper/en에서 검증된 수치이므로 PASS 기대; FAIL 시 번역 단계 mistranscription 후속 수정

C3. **`/verify-claims paper/ko/main.tex`**
- 정책 인용 (법령 제10조, 2020-05-01, 1,200,000원, PIDPS/SFFP 한국명)
- `.claude/references/policy-glossary-ko-en.md` 존재 시 자동 비교; 없으면 manual fallback (CLAUDE.md Step 5 deliverable 미완)

C4. **`python scripts/quality_score.py paper/ko/main.tex`**
- 목표: ≥ 80 (commit threshold, quality-gates.md §Korean Manuscript)
- 80 미달 시 blocking issue 해결 후 재실행
- 90 이상이면 첫 KAEA 제출 readiness 확보

C5. **Visual side-by-side spot check:** paper/en/main.pdf와 paper/ko/main.pdf를 동일 페이지 위치 (e.g., abstract / §6 첫 표 / §7 robustness 마지막 표 / 결론 첫 문단) 5곳 시각 비교 — 내용 일치 + Korean rendering 정상 + table 배치 동일.

---

## Critical Files

**수정:**
- `scripts/R/04c_cct_covariate_continuity.R` (A1)
- `scripts/R/11c_cjm_density.R` (A2)
- `scripts/R/07b_fuzzy_bin_sensitivity.R` (A3)
- `scripts/R/10_alpha3_estimation.R` (A4)
- `scripts/R/15b_attrition_placebo_full.R` (A5)
- `scripts/R/14b_dropped_hh_balance.R` (A6)
- `scripts/R/13b_placebo_cutoffs.R` (A7)
- `scripts/R/04b_sido_robustness.R` (A8, 301 lines, 가장 큰 파일)
- `paper/ko/main.tex` (Phase B 전면 overwrite — 382 → ~500 lines)

**생성:**
- `scripts/R/_outputs_symmetric/tab_cct_covariate_continuity_ko.tex`
- `scripts/R/_outputs_symmetric/tab_cjm_density_ko.tex`
- `scripts/R/_outputs_symmetric/tab_fuzzy_bin_sensitivity_ko.tex`
- `scripts/R/_outputs_symmetric/tab_alpha3_results_ko.tex`
- `scripts/R/_outputs_symmetric/tab_attrition_placebo_full_ko.tex`
- `scripts/R/_outputs_symmetric/tab_dropped_balance_ko.tex`
- `scripts/R/_outputs_symmetric/tab_placebo_cutoffs_ko.tex`
- `scripts/R/_outputs_symmetric/tab_sido_robustness_ko.tex`

**참조 (수정 안 함):**
- `paper/en/main.tex` — 번역 원본
- `paper/ko/preamble_ko.tex` — 이미 kotex + `\newtheorem{prediction}{예측}` 적용됨; `\externaldocument` 제거만 main.tex 단에서 처리
- `Bibliography_base.bib` — 27 entries; bib 컨벤션은 그대로 사용 (dual-field switch 미구현 상태에서는 `plainnat`이 양쪽에 동일 출력)
- 기존 12개 `_ko.tex` 파일 — paper/ko에서 그대로 `\input`

---

## Reused Functions (from existing scripts)

| Function | File:Line | 사용처 |
|---|---|---|
| `write_main_table(data, lang, caption, label, path)` | `scripts/R/03_did_rd.R:447-490` | A1–A8 함수 시그니처 템플릿 |
| `write_table1_tex(...)` | `scripts/R/02_descriptive.R:149-202` | A6 (dropped_balance — descriptive 패턴) 템플릿 |
| `fmt_kr(x, digits)` | `scripts/R/03_did_rd.R:442` | 수치 포맷 (콤마 + 자릿수) |
| `star_p(p)` | `scripts/R/03_did_rd.R:445` | 유의도 별표 |
| haven label attribute lookup | `scripts/R/02_descriptive.R:66-75` | KO outcome label 자동 추출 (수동 dict 대체) |

---

## Verification (End-to-end)

```bash
# Phase A: 8 _ko tables
for s in 04c_cct_covariate_continuity 11c_cjm_density 07b_fuzzy_bin_sensitivity \
         10_alpha3_estimation 15b_attrition_placebo_full 14b_dropped_hh_balance \
         13b_placebo_cutoffs 04b_sido_robustness; do
  Rscript scripts/R/${s}.R
done
ls -la scripts/R/_outputs_symmetric/tab_*_ko.tex | wc -l  # expect 20 (12 existing + 8 new)

# Phase B: full compile
cd paper/ko && latexmk -xelatex -interaction=nonstopmode main.tex
grep -c "Error\|Undefined" main.log  # expect 0

# Phase C: audit
python scripts/quality_score.py paper/ko/main.tex   # target ≥ 80
# /audit-reproducibility paper/ko/main.tex scripts/R/_outputs_symmetric/
# /verify-claims paper/ko/main.tex
```

**Acceptance criteria (모두 충족 시 PR 준비 완료):**
- [ ] 8개 새 `_ko.tex` 생성 + visual inspect 통과
- [ ] paper/ko/main.tex XeLaTeX compile 0 errors
- [ ] PDF 페이지 수 paper/en (57p) ± 10% 내
- [ ] quality_score ≥ 80
- [ ] /audit-reproducibility PASS
- [ ] /verify-claims 정책 인용 4-요건 PASS

---

## Risk & Mitigation

| Risk | Mitigation |
|---|---|
| `_ko` 테이블 한국어 폰트 깨짐 | `useBytes = TRUE` for KO writes; preamble_ko의 `\usepackage{kotex}` 검증; XeLaTeX 사용 (이미 표준) |
| ChoiMun2025/KAMICO 인용이 영문으로 표시 (`-10` quality penalty) | paper/ko 본문에서 `\citet{}` 대신 수동 인라인 "최민영·문한필 (2025)" + 별도 `\nocite{}`로 bib 등재 유지 |
| 그림 영문 축 라벨 KAEA 발표 시 어색함 | Wave 1 scope 외 — KAEA 발표 직전 별도 task로 `_ko.pdf` variant 생성 |
| `policy-glossary-ko-en.md` 부재 (CLAUDE.md Step 5 미완) | `/verify-claims` manual fallback; CLAUDE.md §Korean Policy Glossary와 본 plan §Phase B-1 의 6개 캐논 용어로 자체 검증 |
| `tab_specB`/`tab_specC` 영문 caption 표시 | paper/ko 본문이 표 위에 `\paragraph{}` 형태로 한국어 설명 부여 — 표 내부는 그대로 둠 |
| 페이지 수가 paper/en보다 크게 벗어남 (예: +30%) | 한국어 본문은 영문 대비 1.1–1.3× 길어지는 경향 — 57p × 1.2 = 68p 까지 허용; 초과 시 본문 압축 |
| online_appendix 참조 끊김 | `\externaldocument` 제거 + 본문 내 "Online Appendix §B.1" → "온라인 부록 §B.1 (영문판 참조)"로 명시 |

---

## Out of Scope (별도 task로 분리)

- `paper/ko/online_appendix.tex` 생성 (영문 580 라인) — Wave 2
- `_ko.pdf` 그림 variants (6개) — KAEA 발표 직전
- Korean-form citation 자동화 (custom .bst or natbib hack) — `/validate-bib` 확장 Step 4 inside
- `policy-glossary-ko-en.md` 작성 — CLAUDE.md Step 5
- paper/en의 후속 update 시 paper/ko 재-sync 자동화 hook — 별도 infra task
