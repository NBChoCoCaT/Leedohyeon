# Plan: step-3-3-prep.md 자동 초안 작성 (단계 3-3 prep)

**Status:** APPROVED → COMPLETED (2026-05-04 afternoon, all 9 After-Approval steps executed)
**Date:** 2026-05-04 (afternoon, post-lunch session resume)
**Author:** Claude (이도현 박사논문 프로젝트)
**Step:** 3-3 prep (preparatory — feeds the *real* Step 3-3 `domain-reviewer.md` 5-Lens customization plan in the next session)
**Active sentinel file:** `quality_reports/plans/floofy-soaring-harbor.md` (identical content + Step 2/3-1/3-2 lock notes at top)

---

## Context

도현님 NRD553 텀페이퍼(`master_supporting_docs/own_drafts/초안.md`, 388줄, 27편 References)와 보유 PDF 8편을 분석하여, 단계 3-3 (`.claude/agents/domain-reviewer.md` 5-Lens 커스터마이즈)의 prep spec 초안을 자동 작성한다. 기존 spec 파일(`quality_reports/specs/step-3-3-prep.md`, 80줄 placeholder template)을 약 600~800줄의 풀 entry로 덮어쓴다.

**자료 인벤토리 확정 (이전 보고와 도현님 결정 7건 반영):**

| 카테고리 | 처리 방식 | 편수 | Tier 분류 |
|---------|----------|------|-----------|
| **A** PDF 보유 | pypdf 직접 분석 + 텀페이퍼 cross-check | **8편** | (Singh-Squire-Strauss 1986, de Janvry et al. 1991, Chetty 2008 [Tier 1, E3a], Ahearn et al. 2006, Goodwin-Mishra 2006, Choi-Jodlowski 2025, 김태화·양승룡 2021, 최민영·문한필 2025) |
| **B** PDF 없음, 영문 (도현님 plan B) | WebSearch + DOI/CrossRef + CoVe | **11편** | Caballero-Engel 1999, Sandmo 1971, Blundell-Pistaferri 2003 *JHR*(정정), Grembi-Nannicini-Troiano 2016, Callaway-Sant'Anna 2021, Roth et al. 2023, Hahn-Todd-vanderKlaauw 2001, Calonico-Cattaneo-Titiunik 2014, Cattaneo-Jansson-Ma 2020, Kirwan 2009, Kimhi 1994 |
| **B+** 텀페이퍼 추가 (Tier 1+2) | WebSearch + 텀페이퍼 cross-check | **7편** | Tier 1: Abel-Eberly 1994, Gardebroek-Oude Lansink 2004, McCrary 2008, Kirchweger et al. 2022 / Tier 2: Kimball 1990, Aiyagari 1994, Romano-Wolf 2005 |
| **D** 텀페이퍼 본인 초안 | Markdown 직접 분석 (이미 1회 완독) | 1편 | 인용 맥락·5-Lens weakness 진단에 활용 |
| **합계** | | **27편** + 텀페이퍼 | Tier 3 cut: Chavas-Holt 1996, Rust 1987 |

**자동 정정사항** (모든 신규 작성 파일에 적용):
- Blundell-Pistaferri (2003) 저널: ~~JPE~~ → ***Journal of Human Resources***, 38: 1032–1050
- Choi-Jodlowski (2025): *Land Economics*, **101(3), 374–397** (텀페이퍼에서 확정)
- Chetty (2008) attribution: NBER WP 13967 → JPE 게재본 인용 (*JPE* 116(2): 173–234)

---

## Critical Files

| 파일 | 역할 | 작업 |
|------|------|------|
| `quality_reports/specs/step-3-3-prep.md` | **편집 대상** (덮어쓰기) | 80줄 → ~600-800줄 |
| `master_supporting_docs/own_drafts/초안.md` | D 자료 (388줄) | Read 직접 (이미 완독) |
| `master_supporting_docs/supporting_papers/*.pdf` (8편) | A 자료 | pypdf로 chunk 추출 (`pdf-processing.md` 따라) |
| `.claude/rules/pdf-processing.md` | PDF 분석 protocol | 참조 (chunk 5-page split, error handling) |
| `.claude/agents/claim-verifier.md` | CoVe forked verifier | B/B+ 18편 검증에 spawn |
| `.claude/skills/verify-claims/SKILL.md` | `/verify-claims` skill body | hallucination check protocol 참조 |

**도구 가용성:**
- ❌ poppler-utils (`pdftotext`, `pdfinfo`), `gs`, `pdftk`, `qpdf`, `mutool` 모두 미설치
- ✅ Python 3 (/usr/bin/python3) + **pypdf 6.10.2** (Chetty 2008 PDF에서 사용 성공)
- ✅ WebSearch / WebFetch (Pedro template, 단 hallucination 위험 → CoVe 필수)
- ✅ Bash heredoc + Python으로 chunk 추출 가능

---

## A. step-3-3-prep.md 5개 Lens 섹션 구조

### 섹션 (a) Lens 3 — 핵심 인용 27편 (Tier 분류 + attribution 풀 entry)
- **Tier A (PDF 보유, 8편)** — pypdf 추출 + 텀페이퍼 인용 맥락 (line 번호 참조)
- **Tier B (영문, 11편)** — WebSearch + CrossRef DOI + CoVe
- **Tier B+ Tier 1 (4편)** — 텀페이퍼 References + WebSearch cross-check
- **Tier B+ Tier 2 (3편)** — 동일
- 각 entry: BibTeX-ready (한국 논문은 dual-field `author` + `author_en`, `title` + `title_en`)
- 각 entry에 `cite_caution` + `dissertation_use` + `tumpaper_locations` 포함

### 섹션 (b) Lens 1 — 식별 가정 검증 항목 6개
- 1: DiD 평행추세 / 2: RD 연속성 / 3: 공변량 연속성 / 4: Donut RD 강건성 / 5: Manipulation 검정
- **6: (S,s) 적용 정당성** — **PLACEHOLDER (도현님 입력)**

### 섹션 (c) Lens 2 — Derivation Check 5개 (자동, Grembi-Nannicini-Troiano 2016 framework)
- 1: 식 (1) ↔ 이론 매핑 / 2: β 수준 vs 구조 분해 / 3: Wild bootstrap 알고리즘 / 4: Holm step-down / 5: rdrobust MSE-optimal

### 섹션 (d) Lens 4 — Code-Theory Alignment 5개 (자동, r-code-conventions §10-13 외 추가)
- 1: 표본 제한 / 2: 2018 baseline 강제 / 3: Holm 4 outcomes / 4: Wild bootstrap seed / 5: `coef_map` 한·영 일관성

### 섹션 (e) Lens 5 — Logic Chain 7개 (자동 5 + placeholder 2)
- 1-5: 자동 (5번은 텀페이퍼 §8.5 line 337-344 기반)
- **6: 박사논문 심사위원 특수 질문** — **PLACEHOLDER**
- **7: 한국농업경제학회 referee 관점** — **PLACEHOLDER**

총 placeholder 3개 ((b)-6 + (e)-6 + (e)-7).

---

## B. Lens 3 작업 흐름 (3 Phases)

### Phase 1: A 카테고리 8편 — pypdf 직접 분석 (~25분)

처리: pypdf first-page → title/authors/journal/vol/issue/pages/DOI 패턴 매칭 → abstract 추출 → 텀페이퍼 References (line 364-388) cross-check → 텀페이퍼 본문 grep으로 인용 맥락 추출 → cite_caution 추출.

8편: A1 Singh-Squire-Strauss / A2 de Janvry et al. / A3 Chetty / A4 Ahearn et al. / A5 Goodwin-Mishra / A6 Choi-Jodlowski / A7 최민영·문한필 / A8 김태화·양승룡

### Phase 2: B 카테고리 11편 — WebSearch + CrossRef (~30분)

텀페이퍼에 있는 8편(B1, B2, B3, B4, B8, B9, B10, B11): 텀페이퍼 ground truth, WebSearch는 cross-check.
텀페이퍼 미인용 3편(B5 Callaway-Sant'Anna 2021, B6 Roth et al. 2023, B7 Hahn-Todd-vanderKlaauw 2001): WebSearch primary + CoVe forked spawn 필수.

### Phase 3: B+ 카테고리 7편 (~10분)

모두 텀페이퍼에 정확 attribution 있음. 텀페이퍼 직접 + WebSearch DOI cross-check만.
- Tier 1: C1 Abel-Eberly / C2 Gardebroek-Oude Lansink / C3 McCrary / C4 Kirchweger et al.
- Tier 2: C5 Kimball / C6 Aiyagari / C7 Romano-Wolf

---

## C. 검증 절차 (Hallucination 방지)

- A 카테고리: pypdf extract → 텀페이퍼 cross-check, 불일치 시 텀페이퍼 우선 (Chetty NBER WP vs JPE 게재본 사례)
- B/B+ 카테고리: 텀페이퍼 우선 / 미인용 3편은 CoVe forked spawn (claim-verifier agent, context: fork)
- ⚠️ 의심 표시: 페이지 번호 모호, 한국어 한자 표기, DOI 미할당 (Sandmo 1971, Kimhi 1994 등 old paper), WebSearch 1순위가 publisher 아닌 경우

---

## D. 도현님 검토 highlight

- Placeholder 3개: (b)-6 (S,s) 정당성, (e)-6 심사위원 질문, (e)-7 학회 referee 관점
- ⚠️ Hallucination 의심 항목 list (Phase 2/3 종료 후)
- Tier 분류 적정성 (27편 + Tier 3 cut 2편)

---

## E. 산출물 + 작업 시간 예상

- `quality_reports/specs/step-3-3-prep.md` (덮어쓰기, ~700줄)
- `quality_reports/plans/2026-05-04_step-3-3-prep-autodraft.md` (이 sister file, ~250줄)
- `quality_reports/plans/floofy-soaring-harbor.md` (sentinel, 동일 plan body)
- 작업 시간 예상: ~1시간 20분 (PDF 분석 25분 + WebSearch 11편 30분 + WebSearch 7편 10분 + 본문 합성 15분)

---

## Verification (작업 완료 후 자동)

1. `wc -l quality_reports/specs/step-3-3-prep.md` → 600-800줄
2. 27편 attribution entry 카운트
3. 5개 Lens 섹션 헤더 존재
4. placeholder 정확히 3개
5. 텀페이퍼 References cross-check (텀페이퍼 인용 24편 + Chetty 1편)
6. ⚠️ 의심 항목 list 출력
7. 자동 정정 적용 (Blundell-Pistaferri *JHR*, Choi-Jodlowski *Land Economics*)

---

## Out of Scope

- `.claude/agents/domain-reviewer.md` 본 편집 (단계 3-3 본 plan, 다음 세션)
- `Bibliography_base.bib` 실제 entry 추가 (단계 4)
- placeholder 3개 자동 채움 (도현님 입력)
- `policy-glossary-ko-en.md` 작성 (단계 5)
- Tier 3 cut 2편 (Chavas-Holt, Rust)

---

## After Approval — 모두 완료

1. ✅ ExitPlanMode → APPROVED
2. ✅ Sister file 작성 (이 파일)
3. ✅ Phase 1 실행 — 8편 PDF pypdf 분석 (A1-A8 attribution 확정, A1 ⚠️ book vs survey 발견)
4. ✅ Phase 2 실행 — 11편 WebSearch + CoVe 검증 (B5/B6/B7 미인용 3편 publisher source 직접 확인, B11 ⚠️ critical citation error 발견 + 검증)
5. ✅ Phase 3 실행 — 7편 WebSearch (C5/C6/C7 정확 ✅, C2 ⚠️ + C4 🔴 critical errors 발견)
6. ✅ 본문 합성 — `quality_reports/specs/step-3-3-prep.md` 731줄 작성
7. ✅ 검증 7개 자동 통과 (wc -l, entry count, Lens 헤더, PLACEHOLDER ×3, Tumpaper cross-check, ⚠️ list, 자동 정정)
8. ✅ 도현님 검토 보고 — 6개 ⚠️ + 3 placeholder + Tier 분류 + [LEARN:citation-verification] 후보
9. ✅ status COMPLETED 갱신
