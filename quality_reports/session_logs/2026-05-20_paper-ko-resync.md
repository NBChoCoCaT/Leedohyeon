# Session Log: 2026-05-20 — paper/ko 재동기화 (Wave 10.5 → KO 미러)

**Status:** IN PROGRESS
**Branch:** `feat/paper-ko-resync` off `main` @ `98feaba` (post-PR-#28 merge)
**Plan:** `quality_reports/plans/velvet-frolicking-glade.md` (= `2026-05-20_paper-ko-resync.md` sister)
**Cross-ref:** PR #27 (Wave 10 Phase 2 `bda5190`), PR #28 (Phase 2.5 mop-up `4eb84c3`)

## Objective

`paper/ko/main.tex`를 paper/en (Wave 10.5 안정화 상태)에서 전면 재유도. KAEA 학회 발표 + thesis chapter base 준비.

3-Phase 순차 실행 (총 2–2.5일 예상):
- **Phase A** (~3-4시간): 8개 `_ko.tex` 테이블 신규 생성 (Wave 10 신규 3 + EN-only 5)
- **Phase B** (~1.5일): paper/ko/main.tex 8 section /econ-write 재유도
- **Phase C** (~2-3시간): compile + /audit-reproducibility + /verify-claims + quality_score

## User Decisions (2026-05-20)

- 전략: 전면 overwrite, `/econ-write` 활용
- 범위: main.tex only (online_appendix 별도 작업)
- 테이블: 8개 `_ko.tex` 신규 (`tab_cct_covariate_continuity`, `tab_cjm_density`, `tab_fuzzy_bin_sensitivity`, `tab_alpha3_results`, `tab_attrition_placebo_full`, `tab_dropped_balance`, `tab_placebo_cutoffs`, `tab_sido_robustness`)
- 데드라인: 없음 — 안정성 우선

## Key Context Discovered (pre-implementation exploration)

1. **paper/ko stale 정도:** 5-week behind paper/en. 옛 §3 (11 subsec, 5-channel)이 EN의 4-subsec 통합 구조와 mismatch.
2. **KO 테이블 컨벤션 (12개 기존 _ko 파일):** Caption 한국어, 헤더 번역 ("Variable"→"변수"), outcome label 한국어+단위 (`농업경영비 (원)`), 코드 식별자(`op_cost`) 영어 유지, 통계 약어(T1/T2/T3/FHES/N) 영어, notes `\textit{주:}`.
3. **Bib dual-field gotcha:** `plainnat` 둘 다 사용 → `\citet{Kirwan2009}`는 양 paper에 동일 "Kirwan (2009)" 출력. ChoiMun2025·KAMICO만 한국어 form 필요 → 수동 인라인 처리.
4. **R script _ko emission 패턴:** `03_did_rd.R:447-490` `write_main_table(data, lang, caption, label, path)`에서 `lang ∈ {"en","ko"}` 분기. `useBytes = (lang == "ko")` 으로 UTF-8 안전.
5. **언어 중립 테이블:** `tab_specB`, `tab_specC`는 숫자+outcome 코드명만 → KO 본문이 표 위 한국어 paragraph로 설명 부여하면 그대로 재사용 가능.

## Incremental Work Log

**16:00 KST:** Plan velvet-frolicking-glade.md 승인. Sister `2026-05-20_paper-ko-resync.md` 생성 (diff verify OK). Branch `feat/paper-ko-resync` 생성. Task list 11개 등록 (Phase A1-A8, Phase B, Phase C).

## Next Steps

Phase A1 시작 — `scripts/R/04c_cct_covariate_continuity.R`에 `lang="ko"` emission 추가.

**21:05 KST:** Phase A 완료. 8개 신규 `_ko.tex` 모두 생성 (`tab_cct_covariate_continuity`, `tab_cjm_density`, `tab_fuzzy_bin_sensitivity`, `tab_alpha3_results`, `tab_attrition_placebo_full`, `tab_dropped_balance`, `tab_placebo_cutoffs`, `tab_sido_robustness`). 환경 미설치 패키지 우회 패턴 확립:
- `11c_cjm_density.R`: cache-aware (`requireNamespace("rddensity")` + `CJM_FORCE_RECOMPUTE` env flag) — RDS에서 재방출
- `10b_alpha3_table_from_rds.R`: standalone helper (HonestDiD 우회), `alpha3_results.rds` 직접 read
- `15b`/`14b`/`13b`: `OUT_DIR` env 오버라이드로 `_outputs_symmetric/`에 emission
20개 `_ko.tex` 모두 `_outputs_symmetric/`에 존재. Phase B 진입 준비 완료.

**22:00 KST:** Phase B 완료. paper/ko/main.tex 전면 재유도 (382 → 497 라인). 8 section + abstract + 노테이션 표 + 예측 통합 표 모두 작성. /econ-write 스킬 가이드 적용:
- 한국어 학술 컨벤션 3-tier (첫 등장: 한국어(영문약어), 후속: 약어 단독, 영어 유지: 수학기호·테이블 통계라벨·인명)
- 26개 인용 키 모두 `\citet{}` 사용 (영문 저자); 최민영·문한필(2025), 한국농기계공업협동조합(2022)는 본문 수동 인라인 + `\citep{}` 병기
- 정책 용어 4-요건 모두 한국어 표기 (PIDPS=공익직불제, SFFP=소농직불금 등)
- 그림은 _en.pdf 그대로 사용 + 한국어 캡션
- `\externaldocument` 제거; "온라인 부록 §B.1 (영문판 참조)" 명시

**22:15 KST:** Phase C 정적 검증 완료 (실제 XeLaTeX 컴파일은 BasicTeX 환경 부재로 deferred):
- ✅ `\input{}` 15개 경로 모두 resolve (preamble_ko + 14 tables)
- ✅ 인용 키 26개 모두 Bibliography_base.bib에 존재
- ✅ Label/ref 52개 모두 정의됨 (paper/ko/main.tex 내 + _outputs_symmetric/*.tex 외부)
- ✅ Label 불일치 3건 수정: `tab:ch4_rent_decomposition_ko` → `tab:ch4_rent_ko`, `tab:main_did_rd_ko` → `tab:main_specA_ko`, `tab:rob_outlier_ko` → `tab:rob_outlier_op_cost_ko`
- ✅ Quality score 60/100 (paper/en과 동일; 4개 false positive equation overflow — `\boxed{}` 내부 긴 줄 regex false positive, LaTeX는 정상 wrapping; [LEARN:tooling] 2026-05-14 알려진 이슈)
- ✅ Korean Policy Citation Accuracy 4-요건 PASS: 제10조 (2x), 2020-05-01 (6x), 1,200,000원/120만원 (7x), PIDPS/SFFP/공익직불제/소농직불금 (75x)

## Deferred to next session

- XeLaTeX 컴파일 (현 세션 BasicTeX 부재): 다음 세션에서 `cd paper/ko && latexmk -xelatex -interaction=nonstopmode main.tex` 실행해서 0 errors / ≤10 overfull 검증
- /audit-reproducibility paper/ko/main.tex scripts/R/_outputs_symmetric/: paper/en에서 검증된 수치를 미러했으므로 PASS 기대
- /verify-claims paper/ko/main.tex: CoVe 정책 인용 검증
- PR 생성 / main 머지

## Outcome

20 KO tables (12 existing + 8 new) + paper/ko/main.tex (497 lines, paper/en 506의 98%) 작성 완료. Branch `feat/paper-ko-resync`에 8 commits 분량 변경 (R scripts 8 + paper/ko/main.tex + session log + plan files). 다음 세션에서 LaTeX 컴파일 + PR 작업 진행.
