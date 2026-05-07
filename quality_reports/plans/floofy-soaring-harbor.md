<!-- ============================================================================
  HARNESS-SENTINEL FILE — DO NOT REMOVE
  ============================================================================
  This file is the harness-recognized active plan slot. Each plan-mode
  re-entry re-pins this sentinel; we therefore overwrite it per active plan
  while preserving prior-step lock-notes at the top and writing a Pedro-
  convention sister file (date-slug name) on disk after ExitPlanMode for
  history. See [LEARN:harness] in MEMORY.md (next session).
  ============================================================================ -->

# 🔒 Prior-Step Lock Notes (immutable)

> **Step 2 — CLAUDE.md rewrite: COMPLETED 2026-05-04 11:29.**
> Outcome: `CLAUDE.md` 148 → 133 lines, journal-target framing (AJAE → Food Policy → JAE), DiD-RD identification snapshot, bilingual 2-track workflow.
> Disk evidence: `CLAUDE.md`, commit `514554b` (pushed to `origin/main`).
> Sister plan history: (none — overwritten in this sentinel; CLAUDE.md content itself is the verification).

> **Step 3-1 + 3-2 — Rules customization: COMPLETED 2026-05-04 12:08.**
> Outcome: `r-code-conventions.md` 124 → 206 lines (§10-13 신규 + §6 4 rows), `quality-gates.md` 70 → 124 lines (paths extension, 5 deduction tables with Stage-blocking column, Korean Policy Citation Accuracy, Bilingual Citation Format Enforcement), `Bibliography_base.bib` +30 lines dual-field convention.
> Disk evidence: commit `41be7ec` (pushed). Sister file (preserved): `quality_reports/plans/2026-05-04_step3-1_3-2_rules_customize.md` (DRAFT → COMPLETED, identical content).

---

# Plan: step-3-3-prep.md 자동 초안 작성 (단계 3-3 prep)

**Status:** APPROVED → COMPLETED (2026-05-04 afternoon, 9-step After-Approval pipeline executed)
**Date:** 2026-05-04 (afternoon, post-lunch session resume)
**Author:** Claude (이도현 박사논문 프로젝트)
**Step:** 3-3 prep (preparatory — feeds the *real* Step 3-3 `domain-reviewer.md` 5-Lens customization plan in the next session)
**Sister file (planned):** `quality_reports/plans/2026-05-04_step-3-3-prep-autodraft.md` — written immediately after ExitPlanMode (plan-mode constraint: only sentinel editable during plan mode)

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
| `quality_reports/plans/2026-05-04_step-3-3-prep-autodraft.md` | **Sister file 신규** | ExitPlanMode 직후 plan content sister copy 작성 |

**도구 가용성:**
- ❌ poppler-utils (`pdftotext`, `pdfinfo`), `gs`, `pdftk`, `qpdf`, `mutool` 모두 미설치
- ✅ Python 3 (/usr/bin/python3) + **pypdf 6.10.2** (Chetty 2008 PDF에서 사용 성공)
- ✅ WebSearch / WebFetch (Pedro template, 단 hallucination 위험 → CoVe 필수)
- ✅ Bash heredoc + Python으로 chunk 추출 가능

---

## A. step-3-3-prep.md 5개 Lens 섹션 구조

도현님 명시 그대로:

### 섹션 (a) Lens 3 — 핵심 인용 27편 (Tier 분류 + attribution 풀 entry)
하위 구조:
- **Tier A (PDF 보유, 8편)** — pypdf 추출 + 텀페이퍼 인용 맥락 (line 번호 참조)
- **Tier B (영문, 11편)** — WebSearch + CrossRef DOI + CoVe
- **Tier B+ Tier 1 (4편)** — 텀페이퍼 References + WebSearch cross-check
- **Tier B+ Tier 2 (3편)** — 동일
- 각 entry: BibTeX-ready (한국 논문은 dual-field `author` + `author_en`, `title` + `title_en`)
- 각 entry에 `cite_caution`(인용 시 정확 표현) + `dissertation_use`(어느 절에 인용) + `tumpaper_locations`(텀페이퍼 line 번호) 포함

### 섹션 (b) Lens 1 — 식별 가정 검증 항목 6개
- 1: DiD 평행추세 (event-study, pre 2018-2019 2년 한계)
- 2: RD 연속성 (McCrary 2008 + Cattaneo-Jansson-Ma 2020)
- 3: 공변량 연속성 (경영주 연령·자작비율·성별)
- 4: Donut RD 강건성 (±100㎡, ±200㎡)
- 5: Manipulation 검정 (Cattaneo-Jansson-Ma; 텀페이퍼 7.1절 결과 p=0.147)
- **6: (S,s) 적용 정당성** — **PLACEHOLDER (도현님 입력)** — 한국 소농 자본 임계점 s 추정 근거 (트랙터·이앙기·콤바인 가격 vs 정액 이전 120만원)

### 섹션 (c) Lens 2 — Derivation Check 5개 (Grembi-Nannicini-Troiano 2016 framework 자동)
- 1: 식 (1) DiD-RD 추정식 ↔ 이론 모형 매핑 (Caballero-Engel reduced form)
- 2: Reduced-form β의 수준효과 vs 구조효과 분해 (17.5만원 차등 vs 정액-vs-면적비례)
- 3: Wild cluster bootstrap p-value 알고리즘 (`fwildclusterboot::boottest`)
- 4: Holm step-down 4 outcomes (p_(1) 순서)
- 5: rdrobust MSE-optimal bandwidth 다항식 차수 (Calonico-Cattaneo-Titiunik 2014)

### 섹션 (d) Lens 4 — Code-Theory Alignment 5개 (r-code-conventions §10-13 외 추가)
- 1: 표본 제한 (텍스트 vs `dplyr::filter`)
- 2: Treatment dummy 2018 baseline 강제 (모든 robustness 포함)
- 3: Holm 보정 4 primary outcomes 한정
- 4: Wild bootstrap seed 핀 (per-replicate `seed_base + b`)
- 5: `modelsummary::coef_map` 한·영 일관성

### 섹션 (e) Lens 5 — Logic Chain 7개 (자동 5 + placeholder 2)
- 1: 문제제기 → 식별 선택 (왜 DiD-RD인가) **[자동]**
- 2: 식별 → 추정 (모든 estimator parameter ↔ identifying assumption) **[자동]**
- 3: 추정 → 결과 (모든 표 number ↔ `_outputs/*.rds`) **[자동]**
- 4: 결과 → 해석 (β sign+magnitude ↔ 어느 채널) **[자동]**
- 5: 해석 → 정책함의 (단가 인상 vs 재투자 조건부 — 채널 정합) **[자동, 텀페이퍼 8.5절 기반]**
- 6: 박사논문 심사위원 특수 질문 **[PLACEHOLDER — 도현님 입력]**
- 7: 한국농업경제학회 referee 관점 **[PLACEHOLDER — 도현님 입력]**

근거: 5번 "해석 → 정책함의"는 텀페이퍼 §8.5(line 337-344)에 이미 도현님 결론으로 명시(단가 인상 vs 재투자 조건부 지급, Caballero-Engel 임계점 미달 해석)되어 있어 텀페이퍼 분석으로 자동 도출 가능. 따라서 자동 분류가 정확. placeholder 총 개수는 3개 유지 ((b)-6 + (e)-6 + (e)-7).

---

## B. Lens 3 작업 흐름 (3 Phases)

### Phase 1: A 카테고리 8편 PDF 직접 분석 (~25분)

**처리 절차** (각 PDF):
1. `python3 -c "from pypdf import PdfReader; r = PdfReader('<path>'); print(r.pages[0].extract_text())"` — first page
2. Title / authors / journal / volume / issue / pages / DOI 패턴 매칭
3. Abstract 추출 (page 1-2)
4. 텀페이퍼 References (line 364-388) cross-check — ground truth가 필요한 paper의 경우 텀페이퍼 References가 절대 기준
5. 텀페이퍼 본문 grep으로 인용 맥락 추출 (`grep -n "<author surname>" 초안.md`)
6. `cite_caution` 추출 (정확 인용 표현)

**예외 처리** (`pdf-processing.md` Step 4):
- pypdf 추출 실패 시 → 페이지 분할 시도 (1-2 pages)
- 그래도 실패 → 도현님께 페이지 범위 별도 요청 (예: Chetty 2008은 60p, 도현님이 필요하면 추가 page 지정)

**8편 entry 생성:**
1. **A1** Singh-Squire-Strauss (1986) — *Agricultural Household Models* (book), World Bank
2. **A2** de Janvry-Fafchamps-Sadoulet (1991) — *EJ*, 101(409), 1400–1417
3. **A3** Chetty (2008) — *JPE*, 116(2), 173–234 [Tier 1, E3a 결정]
4. **A4** Ahearn-El-Osta-Dewbre (2006) — *AJAE*, 88(2), 393–408
5. **A5** Goodwin-Mishra (2006) — *AJAE*, 88(1), 73–89
6. **A6** Choi-Jodlowski (2025) — *Land Economics*, 101(3), 374–397
7. **A7** 최민영·문한필 (2025) — *한국농촌계획학회지*, 31(4), 139–150
8. **A8** 김태화·양승룡 (2021) — *농업경제연구*, 62(3), 79–101

### Phase 2: B 카테고리 11편 WebSearch + CrossRef (~30분)

**처리 절차** (각 paper):
1. WebSearch 쿼리: `"<author1> <author2> <year> <keywords>" site:journals.<publisher>.<tld>` (예: Econometrica/JPE)
2. WebFetch 1순위 source URL → abstract 또는 title page
3. CrossRef API: `https://api.crossref.org/works/<DOI>` (DOI 알면 직접, 모르면 search by title)
4. 텀페이퍼 References에 이미 있는 paper(Caballero-Engel, Sandmo, Blundell-Pistaferri, Grembi, Calonico, Cattaneo-JM, Kirwan, Kimhi) → **텀페이퍼가 ground truth**, WebSearch는 cross-check
5. 텀페이퍼에 없는 3편(Callaway-Sant'Anna 2021, Roth et al. 2023, Hahn-Todd-vanderKlaauw 2001) → WebSearch primary, CoVe 필수
6. CoVe (`/verify-claims` 또는 `claim-verifier` agent forked spawn): "<paper attribution>: confirm or refute against <source URL>"

**11편 entry:**
1. **B1** Caballero-Engel (1999) *Econometrica* 67(4):783–826 [텀페이퍼 line 368, 주 채널]
2. **B2** Sandmo (1971) *AER* 61(1):65–73 [텀페이퍼 line 384, auxiliary 1]
3. **B3** Blundell-Pistaferri (2003) *JHR* 38:1032–1050 [텀페이퍼 line 367, **JPE 아님 정정**]
4. **B4** Grembi-Nannicini-Troiano (2016) *AEJ:Applied* 8(3):1–30 [텀페이퍼 line 376, DiD-RD framework]
5. **B5** Callaway-Sant'Anna (2021) *JoE* — **WebSearch primary** (텀페이퍼 미인용; 박사논문 추가) → conditional parallel trends
6. **B6** Roth-Sant'Anna-Bilinski-Poe (2023) *JoE* — **WebSearch primary** → DiD pre-trend best practice
7. **B7** Hahn-Todd-vanderKlaauw (2001) *Econometrica* — **WebSearch primary** → RD ITT vs LATE
8. **B8** Calonico-Cattaneo-Titiunik (2014) *Econometrica* 82(6):2295–2326 [텀페이퍼 line 369, MSE-optimal bandwidth]
9. **B9** Cattaneo-Jansson-Ma (2020) *JASA* 115(531):1449–1455 [텀페이퍼 line 370, manipulation test]
10. **B10** Kirwan (2009) *JPE* 117(1):138–164 [텀페이퍼 line 380, capitalization]
11. **B11** Kimhi (1994) *AJAE* 76(4):874–880 [텀페이퍼 line 378, exit inhibition]

### Phase 3: B+ 카테고리 7편 (텀페이퍼 References + WebSearch cross-check, ~10분)

**모두 텀페이퍼 References에 정확 attribution 있음 (line 364-386):**
- **C1** Abel-Eberly (1994) *AER* 84(5):1369–1384 [Tier 1, 텀페이퍼 line 364, (S,s) 통합 모형]
- **C2** Gardebroek-Oude Lansink (2004) *ERAE* 31(1):81–104 [Tier 1, 텀페이퍼 line 374, 유럽 농가 lumpy]
- **C3** McCrary (2008) *JoE* 142(2):698–714 [Tier 1, 텀페이퍼 line 381, RD density test]
- **C4** Kirchweger-Kantelhardt-Leisch (2022) *Q Open* 2(1):qoac007 [Tier 1, 텀페이퍼 line 379, 스위스 RD]
- **C5** Kimball (1990) *Econometrica* 58(1):53–73 [Tier 2, 텀페이퍼 line 377, precautionary saving]
- **C6** Aiyagari (1994) *QJE* 109(3):659–684 [Tier 2, 텀페이퍼 line 366, smooth investment 대조]
- **C7** Romano-Wolf (2005) *Econometrica* 73(4):1237–1282 [Tier 2, 텀페이퍼 line 382, multiple testing]

**처리:** 텀페이퍼가 ground truth, WebSearch는 빠른 cross-check (DOI 확인 + abstract 1줄)

---

## C. 검증 절차 (단계별 hallucination 방지)

### A 카테고리 검증
- pypdf extract → first-page attribution → 텀페이퍼 References cross-check
- 불일치 시 텀페이퍼 우선 (NBER WP vs JPE 게재본 차이 — Chetty 사례)
- 한국 논문(A7, A8)은 mdls metadata + hwp 원본 제목 + 텀페이퍼 References 3-way cross-check

### B/B+ 카테고리 검증
- 텀페이퍼에 있는 paper: 텀페이퍼 우선
- 텀페이퍼에 없는 3편(B5, B6, B7): WebSearch + CrossRef DOI 강제 + CoVe forked spawn
- CoVe 형태: `claim-verifier` agent에 `context: fork`로 spawn, 검증 질문: "Confirm or refute: <attribution> appears in <source URL>" — verifier는 draft를 보지 못하므로 hallucination 자가확인 불가

### Hallucination 의심 항목 별도 표시 (`⚠️` 마커)
- 페이지 번호 (vol/issue 있되 페이지 없는 paper)
- 한국어 저자 한자 표기 / 영문 표기
- DOI 미할당 (Sandmo 1971, Kimhi 1994 등 old paper → "DOI not assigned" 명시)
- WebSearch 1순위 source가 publisher가 아닌 preprint server·블로그·Wikipedia 등 → ⚠️ 도현님 검토 권장

---

## D. 도현님 검토 highlight (placeholder + 의심)

### Placeholder 3개 (도현님 다음 세션에 채울 것)
- **(b)-6** (S,s) 정당성: 한국 소농 자본 임계점 s 정량 근거 (트랙터·이앙기·콤바인 시가 + 120만원 정액 비교)
- **(e)-6** 박사논문 심사위원 특수 질문: 지도교수 이상헌 강조점 + 식품자원경제학과 심사위원 관점
- **(e)-7** 한국농업경제학회 referee 관점: 도현님 학회 발표·게재 경험 기반 표준 referee 질문

### Hallucination ⚠️ 의심 항목 (Phase 2/3 종료 후 list 형태로 도현님 검토 요청)

### Tier 분류 적정성 확인
- 27편의 Tier A/B/B+ 분류 + Tier 3 cut(Chavas-Holt 1996, Rust 1987) 적정성 도현님 최종 검토

---

## E. 산출물 + 작업 시간 예상

| 산출물 | 형태 | 예상 줄수 |
|--------|------|----------|
| `quality_reports/specs/step-3-3-prep.md` | 덮어쓰기 (80줄 → ~600-800줄) | ~700 |
| `quality_reports/plans/2026-05-04_step-3-3-prep-autodraft.md` | sister file 신규 (이 plan content) | ~250 |
| (기존) `quality_reports/plans/floofy-soaring-harbor.md` | sentinel (이미 작성됨, 본 plan body 포함) | ~250 |

**작업 시간 예상:** Phase 1 PDF 분석 ~25분 + Phase 2 WebSearch 11편 ~30분 + Phase 3 WebSearch 7편 ~10분 + 본문 합성·정리 ~15분 = **~약 1시간 20분** (도현님 명시 1시간보다 약간 길어짐)

---

## Verification (작업 완료 후 자동 검증)

1. `wc -l quality_reports/specs/step-3-3-prep.md` → 600-800줄 범위
2. 27편 attribution entry 카운트: `grep -c "^### [ABCC][1-9]" step-3-3-prep.md`
3. 5개 Lens 섹션 헤더 존재: `grep "^## (Lens [12345]\|섹션 \([abcde]\))" step-3-3-prep.md`
4. placeholder 3개 명시: `grep -c "PLACEHOLDER" step-3-3-prep.md` → 3
5. 텀페이퍼 References cross-check: 27편 중 텀페이퍼에 있는 24편(A 8 + B 11-3=8 + B+ 7 + Chetty 1 [텀페이퍼 미인용이지만 도현님 결정 7로 추가] = 24) 매칭 — line 번호 reference 정확성
6. ⚠️ 의심 항목 list 출력 — 도현님 검토용 별도 highlight 섹션
7. 자동 정정 적용: `grep "Journal of Human Resources" step-3-3-prep.md` (Blundell-Pistaferri JHR), `grep "Land Economics" step-3-3-prep.md` (Choi-Jodlowski)

---

## Out of Scope (이번 단계 NOT)

- `.claude/agents/domain-reviewer.md` 본 편집 (단계 3-3 본 plan, 다음 세션)
- `Bibliography_base.bib`에 실제 entry 추가 (단계 4)
- (S,s) 정당성·심사위원 질문·학회 referee 관점 자동 채움 (도현님 placeholder)
- `policy-glossary-ko-en.md` 작성 (단계 5)
- 텀페이퍼 추가 인용 (Chavas-Holt 1996, Rust 1987) — Tier 3 cut

---

## After Approval

1. ExitPlanMode → DRAFT → APPROVED
2. **Sister file 작성** (plan-mode 제약으로 ExitPlanMode 후 가능): `quality_reports/plans/2026-05-04_step-3-3-prep-autodraft.md`로 floofy의 plan body(line 27 이후) 복사
3. **Phase 1 실행** — 8편 PDF pypdf 분석. 실패 paper는 도현님께 즉시 보고
4. **Phase 2 실행** — 11편 WebSearch + CoVe (특히 텀페이퍼 미인용 3편)
5. **Phase 3 실행** — 7편 텀페이퍼 References 직접 사용 + WebSearch cross-check
6. **본문 합성** — 5 Lens 섹션 풀 entry 작성, placeholder 3개 명시 표시
7. **검증 7개 자동 실행** — `wc -l` + grep 카운트 + 텀페이퍼 cross-check
8. **도현님 검토 보고** — ⚠️ 의심 항목 list + Tier 분류 + placeholder 3개 highlight
9. 검증 통과 시 plan status DRAFT → COMPLETED, 다음 단계는 도현님 placeholder 채움 + 단계 3-3 본 plan 작성
