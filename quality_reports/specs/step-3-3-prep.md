# Step 3-3 Preparation: Domain-Reviewer 5-Lens Customization

**Status:** AUTO-DRAFTED 2026-05-04 (replaces 80-line placeholder template)
**Purpose:** Provide domain content for `.claude/agents/domain-reviewer.md` 5-Lens customization (Step 3-3). Claude reads the filled spec and authors the Step 3-3 plan.
**Owner:** Lee, Dohyeon (도현)
**Auto-draft sources:**
- A category (8 PDFs): pypdf direct extraction + 텀페이퍼 cross-check
- B category (11 papers): WebSearch + CrossRef DOI + publisher source verification
- B+ category (7 papers): WebSearch + 텀페이퍼 References ground truth
- D: `master_supporting_docs/own_drafts/초안.md` (388 lines, 27 References)
- Decisions reflected: E3a (Chetty Tier 1), B-extension 4 papers (Tier 1+2), Tier 3 cut (Chavas-Holt, Rust, **Kimhi 1994**)

---

## 🔴 Critical Citation Findings (이번 자동 분석에서 catch된 것 — 박사논문 게재 전 필수 정정)

| # | Paper | 텀페이퍼 인용 | 검증 결과 | 박사논문 처리 |
|---|-------|--------------|-----------|------------|
| 1 | **B11 Kimhi 1994** | *AJAE* 76(4): 874-880 "Optimal Timing of Farm Exit under Uncertainty" | 🔴 **paper 미존재**. AJAE 76(4) Nov 1994 TOC 22편 모두 확인 — Kimhi paper는 동 issue 828-835 "Quasi Maximum Likelihood Estimation... Farm Couples' Labor Participation" (다른 주제). 1994년 Kimhi succession paper는 76(2):228-236 only | **Tier 3 cut**. 텀페이퍼 §3.3 channel "이탈 억제 (Kimhi 1994, Weiss 1999)" → "이탈 억제 (Weiss 1999)"로 단독 사용. Step 4에서 보강 reference 발굴 (Option γ) |
| 2 | **C4 Kirchweger et al. 2022** | *Q Open* 2(1), qoac007 "Direct Payments and On-Farm Employment" | 🔴 **wrong attribution**. Q Open 2(1) qoac007은 Zamani et al. 가나 poultry import paper. 실제 Kirchweger paper는 *Q Open* **3(3):qoac024** "Direct payments and on-farm employment: Evidence from a spatial regression discontinuity design" | **Auto 정정 — 박사논문에서 3(3):qoac024 사용** |
| 3 | **C2 Gardebroek-Oude Lansink 2004** | *ERAE* 31(1): 81-104 "Farm-specific Adjustment Costs in Dutch Pig Farming" | ⚠️ 텀페이퍼 attribution이 ERAE에 없음. 실제 후보 paper: (i) Gardebroek 단독 *ERAE* 31(1): 39-59 "Capital adjustment patterns on Dutch pig farms" / (ii) Gardebroek-Oude Lansink 공저 ***Journal of Agricultural Economics* 55(1): 3-24** "Farm-specific Adjustment Costs in Dutch Pig Farming" — title 일치하므로 (ii)일 가능성 높음 | **Auto 정정 — JAE 55(1):3-24 사용 (도현님 검토 후 확정)**. 추가: 텀페이퍼 §3.2 본문 "유럽 **낙농** 농가" 표기는 **틀림** (실제 paper는 **Dutch pig, 돼지**). 박사논문 본문도 "축산/돼지" 또는 "Dutch pig" 표기로 정정 |

추가 minor 정정 (auto): **B10 Kirwan (2009)** title은 published 형태 "The Incidence of U.S. **Agricultural Subsidies on Farmland Rental Rates**" 사용 (텀페이퍼 line 380은 "The Incidence of U.S. Farm Programs"로 줄임).

**[LEARN:citation-verification] 후보** — 텀페이퍼 단계에서 27편 중 3편 critical 인용 오류 + 1편 minor title 차이 발견 (= 11% 오류율). 영문 저널 게재 전 catch — Pedro replication-first 워크플로우 가치 입증. 박사논문 작업 시 모든 인용을 publisher source 또는 CrossRef DOI로 cross-check 필수.

---

## 섹션 (a) Lens 3 — 핵심 인용 27편 (Citation Fidelity)

각 entry 형식:
```
### Tag — Author (Year) — *Journal* vol(issue): pages

- **Citation key (BibTeX-ready):** `AuthorYearKey`
- **Full attribution:** [author, year, title, journal, vol, issue, pages]
- **DOI / Stable URL:** [DOI or JSTOR ID]
- **Cite caution (정확 인용 표현):** [phrases that must NOT be paraphrased]
- **Dissertation use:** [§N (이론/식별/해석/정책 etc.)]
- **Tumpaper locations:** [textual references in 초안.md]
- **Notes / ⚠️:** [any caveat]
```

For Korean papers (A7, A8): `author` (Korean) + `author_en` (English) + `title` (Korean) + `title_en` (English) — dual-field per `.claude/rules/quality-gates.md` §Bilingual Citation Format Enforcement.

---

### Tier A — PDF 보유 (8편, pypdf 직접 분석 + 텀페이퍼 cross-check)

#### A1a — Singh, Squire, Strauss (1986) — Book version

- **Citation key:** `SinghSquireStrauss1986_book`
- **Full attribution:** Singh, I., Squire, L., & Strauss, J. (Eds.) (1986). *Agricultural Household Models: Extensions, Applications, and Policy*. Baltimore, MD: Johns Hopkins University Press for the World Bank.
- **DOI / URL:** No DOI (book). Pre-1990 publication.
- **Cite caution:** "**Agricultural Household Model**" (AHM); "**separability theorem**" (under complete markets)
- **Dissertation use:** §3.1 (이론 토대 — AHM, separability theorem); §3.4 channel summary
- **Tumpaper locations:** line 75 (§3.1 본문), line 385 (References)
- **Notes:** ✅ Tumpaper cite. ⚠️ PDF on disk is the *companion survey article* (A1b below), NOT the book. 도현님 결정 (iii): cite both. The book is the canonical theoretical reference.

#### A1b — Singh, Squire, Strauss (1986) — Survey article (PDF on disk)

- **Citation key:** `SinghSquireStrauss1986_WBER`
- **Full attribution:** Singh, I., Squire, L., & Strauss, J. (1986). "A Survey of Agricultural Household Models: Recent Findings and Policy Implications." *World Bank Economic Review*, **1(1)**, 149-179.
- **DOI / URL:** JSTOR Stable URL https://www.jstor.org/stable/3989948
- **Cite caution:** "Survey of Agricultural Household Models" (article context)
- **Dissertation use:** §3.1 secondary cite (accessible summary). §1 introduction (motivation for AHM-based approach).
- **Tumpaper locations:** Not in tumpaper References (separately cited, but the body §3.1 refers to AHM concept which the survey condenses).
- **Notes:** Companion to A1a book; published same year by same authors. Use both: `[Singh, Squire, and Strauss 1986a, 1986b]` style, or "the AHM tradition (Singh, Squire, and Strauss 1986)".

#### A2 — de Janvry, Fafchamps, and Sadoulet (1991)

- **Citation key:** `deJanvryFafchampsSadoulet1991_EJ`
- **Full attribution:** de Janvry, A., Fafchamps, M., & Sadoulet, E. (1991). "Peasant Household Behaviour with Missing Markets: Some Paradoxes Explained." *The Economic Journal*, **101(409)**, 1400-1417.
- **DOI / URL:** JSTOR Stable URL https://www.jstor.org/stable/2234892
- **Cite caution:** "**Missing markets**" (NOT "incomplete markets" — 다른 정의), "Peasant Household Behaviour", "paradoxes explained"
- **Dissertation use:** §3.1 (시장 불완전성이 separability를 깨뜨림 — primary theoretical justification for treatment effect ≠ 0 even with lump-sum transfer). §3.4 channel structuring.
- **Tumpaper locations:** line 77 (§3.1 본문), line 373 (References)
- **Notes:** ✅ Tumpaper cite 정확. CLAUDE.md identification snapshot 명시.

#### A3 — Chetty (2008) [Tier 1, E3a 결정]

- **Citation key:** `Chetty2008_JPE`
- **Full attribution:** Chetty, R. (2008). "Moral Hazard versus Liquidity and Optimal Unemployment Insurance." *Journal of Political Economy*, **116(2)**, 173-234.
- **DOI / URL:** DOI 10.1086/588585. (PDF on disk is NBER WP 13967 working version; cite the JPE published version per 도현님 결정 7.)
- **Cite caution:** "**liquidity effect**" (소문자), "**moral hazard**" (소문자), "lump-sum severance payments", "exact identification approach"
- **Dissertation use:** §3 secondary lineage cite — lump-sum cash transfer identification standard reference. §8 interpretation — β decomposition as **liquidity effect** (정액 이전이 유동성 제약 완화) **+ (S,s) threshold underreach** (Caballero-Engel) dual-channel framing. 박사논문에서 텀페이퍼 §8 미해결 퍼즐(β=420만원이 이전 금액 120만원의 3.5배) 해명 framework 제공.
- **Tumpaper locations:** **NOT cited in tumpaper** (도현님 결정 7로 박사논문 단계에 추가).
- **Notes:** ⚠️ NBER WP version (60 pages) is on disk; JPE version is shorter and the canonical citation. Reference the JPE attribution; do NOT cite the working paper unless specific working-paper figures are needed.

#### A4 — Ahearn, El-Osta, and Dewbre (2006)

- **Citation key:** `AhearnElOstaDewbre2006_AJAE`
- **Full attribution:** Ahearn, M.C., El-Osta, H., & Dewbre, J. (2006). "**The Impact of Coupled and Decoupled Government Subsidies on Off-Farm Labor Participation of U.S. Farm Operators**." *American Journal of Agricultural Economics*, **88(2)**, 393-408.
- **DOI / URL:** DOI 10.1111/j.1467-8276.2006.00865.x (Wiley)
- **Cite caution:** "**coupled and decoupled**" subsidies, "**off-farm labor participation**". Full title includes "of U.S. Farm Operators" — 텀페이퍼 line 365는 줄여서 cite, 박사논문 cite 시 full title 사용 권장.
- **Dissertation use:** §2.1 (decoupled payment 효과 선행 연구). §3.3 보조채널 1 (Sandmo) 보강 — 농외 노동 공급에 보조금 영향이 negative라는 실증.
- **Tumpaper locations:** line 46 (§2.1 본문), line 365 (References)
- **Notes:** ✅ Tumpaper cite 정확 (title 약식). U.S. context paper — Korea PIDPS 비교용.

#### A5 — Goodwin and Mishra (2006)

- **Citation key:** `GoodwinMishra2006_AJAE`
- **Full attribution:** Goodwin, B.K., & Mishra, A.K. (2006). "Are 'Decoupled' Farm Program Payments Really Decoupled? An Empirical Evaluation." *American Journal of Agricultural Economics*, **88(1)**, 73-89.
- **DOI / URL:** DOI 10.1111/j.1467-8276.2006.00839.x (Wiley)
- **Cite caution:** "**'Decoupled'**" (quotation marks 중요 — paper의 비판 강조), "Really Decoupled?", "AMTA payments", "green-box"
- **Dissertation use:** §2.1 (decoupled payment 비판 lineage). §1 introduction motivation.
- **Tumpaper locations:** line 46 (§2.1 본문), line 375 (References)
- **Notes:** ✅ Tumpaper cite 정확. Pair with A4 Ahearn et al. for "decoupled payment" U.S. literature framing.

#### A6 — Choi and Jodlowski (2025)

- **Citation key:** `ChoiJodlowski2025_LandEcon`
- **Full attribution:** Choi, J., & Jodlowski, M. (2025). "**Do Good Intentions Make Good Policy? Farmland Ownership Regulations in South Korea**." *Land Economics*, **Volume 101, Number 3 (August 2025)**, **374-397**.
- **DOI / URL:** Project MUSE article 967229 (https://muse.jhu.edu/article/967229). Published by University of Wisconsin Press.
- **Cite caution:** "**Farmland Ownership Regulations**" (NOT "price subsidy"). 본 연구와 차별화 핵심: they study **land-ownership regulation**, we study **price subsidy at a cutoff** (CLAUDE.md identification snapshot 명시).
- **Dissertation use:** §1 contribution differentiation. §2 background. §8 interpretation — "regulation vs subsidy" framing 차별화.
- **Tumpaper locations:** line 48 (§2.1 본문), line 372 (References)
- **Notes:** ✅ Most important comparator paper. Korean context, area-cutoff design, but **regulation channel** (different from PIDPS subsidy). 박사논문 §1 contribution para에서 명시 차별화.

#### A7 — 최민영·문한필 (2025) [Korean dual-field]

- **Citation key:** `ChoiMoon2025_KSRP`
- **author (Korean):** 최민영 and 문한필
- **author_en (English):** Choi, Minyoung and Moon, Hanpil
- **title (Korean):** 농외소득 상한기준을 활용한 공익직불금의 생산 비연계 검증
- **title_en (English):** Evaluating the Decoupling of Public Direct Payments Using an Upper Threshold of Off-Farm Income
- **journal:** *한국농촌계획학회지* / *Journal of Korean Society of Rural Planning*
- **Volume/Issue/Pages:** 31(4), 139-150 (2025)
- **DOI:** **10.7851/ksrp.2025.31.4.139**
- **ISSN:** 1225-8857 (print) / 2288-9493 (online)
- **Affiliation:** 전남대학교 농업경제학과 (Chonnam National University, Department of Agricultural Economics)
- **Cite caution:** "**농외소득 상한기준 RDD**" (NOT 경지면적 RD). 본 연구와 차별화: they use **off-farm-income threshold RDD only**, we combine **area cutoff + DiD**. (CLAUDE.md identification snapshot 명시)
- **Dissertation use:** §1 contribution differentiation. §2 background (Korean direct PDP literature). §8 interpretation — Kirwan-역방향 임차 자본화 회피 paper로도 cite (텀페이퍼 §8.3 line 323).
- **Tumpaper locations:** line 48 (§2.1 본문), line 323 (§8.3 본문), line 388 (References)
- **Notes:** ✅ KCI_FI003274049 PDF 보유. Most important Korean comparator paper. Same FHES data, RDD design but different running variable (income vs area).

#### A8 — 김태화·양승룡 (2021) [Korean dual-field]

- **Citation key:** `KimYang2021_KAEA`
- **author (Korean):** 김태화 and 양승룡
- **author_en (English):** Kim, Taehwa and Yang, Seung-Ryong
- **title (Korean):** 소농직불금 지급기준의 적정성 및 소득분배 효과 분석
- **title_en (English):** Analysis on the Adequacy and Income Distribution Effect of the Small-scale Farm Direct Payment
- **journal:** *농업경제연구* / *Korean Journal of Agricultural Economics*
- **Volume/Issue/Pages:** 62(3), 79-101 (2021)
- **DOI:** TBD (KCI 등재지, KCI ID 검색 가능)
- **Cite caution:** "**소농직불금 지급기준**" (적정성 분석), "**소득분배 효과**" (cluster analysis + scenario analysis 사용)
- **Dissertation use:** §2.1 background — 한국 PIDPS 정책 분석 선행연구. 0.5ha 기준 적정성에 대한 institutional reference (NOT causal estimation).
- **Tumpaper locations:** line 48 (§2.1 본문), line 387 (References)
- **Notes:** ✅ _2021__.pdf 보유 (cp949 깨진 파일명, 농업경제연구 62권3호_3차.hwp 원본). 텀페이퍼 §2.1 본문은 "인과 식별을 시도하지 않았다"로 정확히 차별화 명시.

---

### Tier B — PDF 없음, 영문 (11편, WebSearch + CrossRef DOI 확보 완료)

#### B1 — Caballero and Engel (1999) [주 채널, Frisch Medal]

- **Citation key:** `CaballeroEngel1999_ECTA`
- **Full attribution:** Caballero, R.J., & Engel, E.M.R.A. (1999). "Explaining Investment Dynamics in U.S. Manufacturing: A Generalized (S, s) Approach." *Econometrica*, **67(4)**, 783-826.
- **DOI:** **10.1111/1468-0262.00053**
- **Cite caution:** "**Generalized (S, s) Approach**" (정확 capitalization 및 spacing — `(S, s)` with comma+space, NOT `(S,s)`). "Investment Dynamics in U.S. Manufacturing". "lumpy investment", "adjustment hazard". **Frisch Medal 2002 winner** (Caballero + Engel) — prestige note 가능.
- **Dissertation use:** §3.2 **primary theoretical channel**. §6 main result interpretation. §8.1 main channel discussion. The single most important citation in dissertation.
- **Tumpaper locations:** line 34 (§1 본문), line 80-88 (§3.2 main channel block), line 305-310 (§8.1), line 350 (§9), line 368 (References)
- **Notes:** ✅ Tumpaper cite 정확. CLAUDE.md identification snapshot 핵심 channel.

#### B2 — Sandmo (1971) [auxiliary 1]

- **Citation key:** `Sandmo1971_AER`
- **Full attribution:** Sandmo, A. (1971). "On the Theory of the Competitive Firm under Price Uncertainty." *American Economic Review*, **61(1)**, 65-73.
- **DOI:** None (1971 AER pre-DOI). JSTOR Vol. 61(1) i332664.
- **Cite caution:** "**Theory of the Competitive Firm under Price Uncertainty**". "precautionary" vocabulary derived from Sandmo via subsequent literature (Kimball 1990 etc.). 본 연구는 **예방적 노동공급** channel로 적용.
- **Dissertation use:** §3.3 보조채널 1 (auxiliary 1) — precautionary labor supply. §6.4 null result (β(농외소득) = 0). §8.2 interpretation — Sandmo prediction **rejected**.
- **Tumpaper locations:** line 34 (§1 본문, "Sandmo (1971) 계열"), line 94 (§3.3 본문), line 230 (§6.4), line 313 (§8.2), line 384 (References)
- **Notes:** ✅ Tumpaper cite 정확. CLAUDE.md identification snapshot 명시.

#### B3 — Blundell and Pistaferri (2003) [auxiliary 2, JHR 정정]

- **Citation key:** `BlundellPistaferri2003_JHR`
- **Full attribution:** Blundell, R., & Pistaferri, L. (2003). "Income Volatility and Household Consumption: The Impact of Food Assistance Programs." ***Journal of Human Resources***, **38** (Special Issue on Income Volatility and Implications for Food Assistance Programs), 1032-1050.
- **DOI / URL:** JSTOR Stable URL https://www.jstor.org/stable/3558980
- **Cite caution:** **저널은 *Journal of Human Resources* (NOT *Journal of Political Economy*)** — CLAUDE.md identification snapshot, step-3-3-prep.md template, 도현님 plan 모두에서 자동 정정 적용. 텀페이퍼 line 367은 정확히 JHR cite. "Income Volatility", "Food Assistance Programs", "Special Issue".
- **Dissertation use:** §3.3 보조채널 2 (auxiliary 2) — consumption smoothing. §6.3 secondary result (β(소비지출) > 0, T1 유의). §8.2 interpretation — partial support.
- **Tumpaper locations:** line 34 (§1 본문), line 96 (§3.3 본문), line 226 (§6.3), line 315 (§8.2), line 367 (References)
- **Notes:** ✅ Tumpaper cite 정확 (JHR). Auto correction in all dissertation files.

#### B4 — Grembi, Nannicini, and Troiano (2016) [DiD-RD framework]

- **Citation key:** `GrembiNanniciniTroiano2016_AEJApp`
- **Full attribution:** Grembi, V., Nannicini, T., & Troiano, U. (2016). "Do Fiscal Rules Matter?" *American Economic Journal: Applied Economics*, **8(3)**, 1-30.
- **DOI:** **10.1257/app.20150076**
- **Cite caution:** "**RD-DiD combined design**" (text in 텀페이퍼 §5.1). Italian municipalities context (1999 imposed, 2001 relaxed below 5,000 inhabitants). 본 연구 식 (1)이 Grembi et al. (2016)의 RD-DiD 결합 설계 형태를 따름 (텀페이퍼 line 161-167).
- **Dissertation use:** §5.1 **identification strategy methodological foundation** (방법론 토대). The single most important methodological citation.
- **Tumpaper locations:** line 161 (§5.1 추정식 (1) 직전), line 376 (References)
- **Notes:** ✅ Tumpaper cite 정확. CLAUDE.md identification snapshot 명시.

#### B5 — Callaway and Sant'Anna (2021) [conditional parallel trends]

- **Citation key:** `CallawaySantAnna2021_JoE`
- **Full attribution:** Callaway, B., & Sant'Anna, P.H.C. (2021). "Difference-in-Differences with Multiple Time Periods." *Journal of Econometrics*, **225(2)**, 200-230.
- **DOI:** **10.1016/j.jeconom.2020.12.001**. arXiv 1803.09015.
- **Cite caution:** "**conditional parallel trends**" (NOT plain "parallel trends" — 도현님 강조). "**multiple time periods**", "variation in treatment timing", "doubly-robust estimands". The `did` R package is by these authors.
- **Dissertation use:** §5.3 식별 가정 검증 (assumption 2: parallel trends — 박사논문에서 conditional 형태로 강화). §7.1 robustness — 추가 controls 결합 시 conditional version 검정.
- **Tumpaper locations:** **NOT cited in tumpaper** (박사논문 확장 추가 — Lens 1 강화).
- **Notes:** ⚠️ Tumpaper 미인용. WebSearch primary source confirmed. Pair with B6 (Roth et al. 2023) for full DiD methodological best-practice block.

#### B6 — Roth, Sant'Anna, Bilinski, and Poe (2023) [DiD pre-trend best practice]

- **Citation key:** `RothSantAnnaBilinskiPoe2023_JoE`
- **Full attribution:** Roth, J., Sant'Anna, P.H.C., Bilinski, A., & Poe, J. (2023). "What's Trending in Difference-in-Differences? A Synthesis of the Recent Econometrics Literature." *Journal of Econometrics*, **235(2)**, 2218-2244.
- **DOI:** **10.1016/j.jeconom.2023.03.008**. arXiv 2201.01194.
- **Cite caution:** "**synthesis**" of recent DiD methods. "pre-trends test" / "pre-trends best practice". Three-axis taxonomy: (i) multiple periods, (ii) parallel trends violation, (iii) inference frameworks.
- **Dissertation use:** §5.3 (assumption 2 동적 검정 best practice). §7.2 event-study justification. §8.4 공간 집중성 해석 — pre-trends 통과의 의미.
- **Tumpaper locations:** **NOT cited in tumpaper** (박사논문 확장).
- **Notes:** ⚠️ Tumpaper 미인용. WebSearch primary source confirmed. Cite alongside B5 in §5.3.

#### B7 — Hahn, Todd, and van der Klaauw (2001) [RD ITT vs LATE 식별 이론]

- **Citation key:** `HahnToddVanderKlaauw2001_ECTA`
- **Full attribution:** Hahn, J., Todd, P., & Van der Klaauw, W. (2001). "Identification and Estimation of Treatment Effects with a Regression-Discontinuity Design." *Econometrica*, **69(1)**, 201-209.
- **DOI:** **10.1111/1468-0262.00183**
- **Cite caution:** "**Identification and Estimation**" (paper title 정확), "**weak functional form restriction**", "continuity assumptions". 본 연구는 **ITT 해석** 채택 (제10조 제3항 선택 신청 모호성) — Hahn et al. (2001)의 ITT vs LATE 분리에 의존. 1,793+ citations.
- **Dissertation use:** §5.1 식별 이론 토대 (RD treatment effect). §5.3 (assumption 1: 실행변수 연속성). §7.5 fuzzy 2SLS 논의 (text in tumpaper line 287). 박사논문에서 ITT 해석 정당화.
- **Tumpaper locations:** **NOT cited in tumpaper** (박사논문 확장 — Lens 2 derivation 강화).
- **Notes:** ⚠️ Tumpaper 미인용. WebSearch primary source confirmed. RD identification의 canonical theoretical paper.

#### B8 — Calonico, Cattaneo, and Titiunik (2014) [MSE-optimal bandwidth]

- **Citation key:** `CalonicoCattaneoTitiunik2014_ECTA`
- **Full attribution:** Calonico, S., Cattaneo, M.D., & Titiunik, R. (2014). "Robust Nonparametric Confidence Intervals for Regression-Discontinuity Designs." *Econometrica*, **82(6)**, 2295-2326.
- **DOI:** **10.3982/ECTA11757**
- **Cite caution:** "**Robust Nonparametric Confidence Intervals**", "**MSE-optimal bandwidth**", "local polynomial estimator". The `rdrobust` R package is by these authors.
- **Dissertation use:** §5.2 T3 (MSE-optimal bandwidth) 정당화. 텀페이퍼 line 177에서 직접 인용. CLAUDE.md identification snapshot 명시 ("T3: MSE-optimal (`rdrobust`)").
- **Tumpaper locations:** line 177 (§5.2), line 369 (References)
- **Notes:** ✅ Tumpaper cite 정확.

#### B9 — Cattaneo, Jansson, and Ma (2020) [manipulation test]

- **Citation key:** `CattaneoJanssonMa2020_JASA`
- **Full attribution:** Cattaneo, M.D., Jansson, M., & Ma, X. (2020). "Simple Local Polynomial Density Estimators." *Journal of the American Statistical Association*, **115(531)**, 1449-1455.
- **DOI:** **10.1080/01621459.2019.1635480**. arXiv 1811.11512.
- **Cite caution:** "**Simple Local Polynomial Density Estimators**" — Often paired with McCrary (2008) for manipulation testing. The `rddensity` / `lpdensity` R/Stata package implements this.
- **Dissertation use:** §5.3 (assumption 1: 실행변수 연속성 — 인위적 군집 검정). §7.1 텀페이퍼 결과 p=0.147 (조작 부재).
- **Tumpaper locations:** line 185 (§5.3), line 238 (§7.1), line 370 (References)
- **Notes:** ✅ Tumpaper cite 정확. CLAUDE.md identification snapshot 명시.

#### B10 — Kirwan (2009) [임차 자본화] ⚠️ TITLE 정정

- **Citation key:** `Kirwan2009_JPE`
- **Full attribution:** Kirwan, B.E. (2009). "**The Incidence of U.S. Agricultural Subsidies on Farmland Rental Rates**." *Journal of Political Economy*, **117(1)**, 138-164.
- **DOI:** **10.1086/598688**
- **Cite caution:** **Published title is "The Incidence of U.S. Agricultural Subsidies on Farmland Rental Rates"** (NOT 텀페이퍼 line 380의 줄임 "The Incidence of U.S. Farm Programs"). 박사논문에서는 published title 사용. "**75 percent / 25 percent**" rent capture finding (tenants 75%, landlords 25%) — paper의 핵심 contribution.
- **Dissertation use:** §3.3 탐색 채널 2 (Kirwan 역방향 해석). §8.3 interpretation — 본 연구의 임차료/임차면적 결과를 Kirwan과 정합성 평가.
- **Tumpaper locations:** line 98 (§3.3 본문), line 319 (§8.3), line 380 (References).
- **Notes:** ✅ Tumpaper cite 정확하지만 **title 줄임**. Auto title 정정 적용.

#### B11 — Kimhi (1994) 🔴 CITATION ERROR — DISSERTATION CUT

- **Citation key:** `Kimhi1994_TIER3CUT`
- **Tumpaper attribution (incorrect):** "Kimhi, A. (1994). Optimal Timing of Farm Exit under Uncertainty. *AJAE*, 76(4), 874-880."
- **Verified non-existence:** AJAE 76(4) (Nov 1994) TOC 22편 모두 확인됨. Kimhi 76(4) paper는 "Quasi Maximum Likelihood Estimation of Multivariate Probit Models: Farm Couples' Labor Participation" (828-835), 다른 주제. 1994년 Kimhi의 succession-related AJAE paper는 76(2): 228-236 only. "Optimal Timing of Farm Exit under Uncertainty" — **non-existent paper**.
- **Dissertation processing (도현님 결정 Option β):**
  - **Tier 3 cut**. 박사논문에서 Kimhi 1994 삭제.
  - 텀페이퍼 §3.3 line 98 channel "이탈 억제 (Kimhi 1994, Weiss 1999)" → "이탈 억제 (Weiss 1999)"로 단독 사용.
  - Channel 자체는 보존 (Weiss로 충분).
- **Future investigation (Option γ, Step 4):** "Future Citations to Investigate" 섹션 참조 — 박사논문 §3.3 channel 보강 후보.
- **Notes:** 🔴 Critical citation verification finding. Pedro replication-first workflow caught this before journal submission. `[LEARN:citation-verification]` candidate.

---

### Tier B+ — Tier 1 (4편, 텀페이퍼 References ground truth)

#### C1 — Abel and Eberly (1994) [(S,s) 통합 모형, Tier 1]

- **Citation key:** `AbelEberly1994_AER`
- **Full attribution:** Abel, A.B., & Eberly, J.C. (1994). "A Unified Model of Investment Under Uncertainty." *American Economic Review*, **84(5)**, 1369-1384.
- **DOI:** None (1994 AER pre-DOI standardization). EconPapers RePEc:aea:aecrev:v:84:y:1994:i:5:p:1369-84
- **Cite caution:** "**A Unified Model of Investment Under Uncertainty**". 세 가지 regime: positive / zero / negative gross investment. 본 연구에서 Caballero-Engel (1999)의 직접 선행으로 cite (lumpy investment 통합 framework).
- **Dissertation use:** §3.2 (S,s) channel lineage — Caballero-Engel의 직접 선행으로 cite. "Abel and Eberly (1994)는 불확실성·조정 비용 하 투자의 통합 모형을 제시하고, Caballero and Engel (1999)은 이 틀을 (S,s) 임계점 규칙으로 확장..."
- **Tumpaper locations:** line 81 (§3.2 본문), line 364 (References)
- **Notes:** ✅ Tumpaper cite 정확.

#### C2 — Gardebroek and Oude Lansink (2004) ⚠️ ATTRIBUTION 검증 필요

- **Citation key (tumpaper):** `GardebroekOudeLansink2004_ERAE` (텀페이퍼 인용 — verify 필요)
- **Tumpaper attribution:** "Gardebroek, C., & Oude Lansink, A.G.J.M. (2004). Farm-specific Adjustment Costs in Dutch Pig Farming. *European Review of Agricultural Economics*, **31(1)**, 81-104."
- **Verification result:** ⚠️ ERAE 31(1) 81-104 paper 미확인. WebSearch 결과:
  - (i) Gardebroek 단독 *ERAE* **31(1): 39-59** "Capital adjustment patterns on Dutch pig farms" (DOI 10.1093/erae/31.1.39) — different title, different pages, single author
  - (ii) Gardebroek and Oude Lansink (2004). "Farm-specific Adjustment Costs in Dutch Pig Farming." ***Journal of Agricultural Economics* 55(1): 3-24** (Wiley) — title 정확 일치, **probably the actual citation**
- **Auto-corrected attribution (provisional, ⚠️ verify before final):** Gardebroek, C., & Oude Lansink, A.G.J.M. (2004). "Farm-specific Adjustment Costs in Dutch Pig Farming." *Journal of Agricultural Economics*, **55(1)**, 3-24.
- **Body text 정정도 필요:** 텀페이퍼 §3.2 line 81 "Gardebroek and Oude Lansink (2004)는 이 모형을 유럽 **낙농** 농가에 적용..." — **틀림**. 실제 paper는 **Dutch pig farming, 돼지** (NOT 낙농/dairy). 박사논문 본문도 "Dutch 양돈/돼지/축산" 표기로 정정 필수.
- **Cite caution:** "Farm-specific Adjustment Costs", "Dutch pig farming", NOT 낙농(dairy)
- **Dissertation use:** §3.2 (Caballero-Engel 모형의 농업 적용 — 한국 적용 정당성). 박사논문 본문 wording: "Gardebroek and Oude Lansink (2004) extended this framework to **Dutch pig farms**, providing empirical evidence of lumpy capital adjustment in agricultural production."
- **Tumpaper locations:** line 81 (§3.2 본문 — body text 정정 필요), line 374 (References — attribution 정정 필요)
- **Notes:** 🔴 Critical attribution verification finding (auto corrected, pending 도현님 review). Pair with similar farming sector lumpy-investment empirical papers (e.g., Hill 2010 AJAE 등). `[LEARN:citation-verification]` candidate.

#### C3 — McCrary (2008) [RD density test, 부제 추가]

- **Citation key:** `McCrary2008_JoE`
- **Full attribution:** McCrary, J. (2008). "Manipulation of the Running Variable in the Regression Discontinuity Design: **A Density Test**." *Journal of Econometrics*, **142(2)**, 698-714.
- **DOI:** **10.1016/j.jeconom.2007.05.005**
- **Cite caution:** **Full title includes the subtitle "A Density Test"** — 텀페이퍼 line 381은 부제 생략. 박사논문 cite 시 부제 포함 권장. "first such test" (McCrary's pioneering nature) — 1750+ citations.
- **Dissertation use:** §5.3 assumption 1 (실행변수 연속성). §7.1 manipulation test (paired with B9 Cattaneo-Jansson-Ma 2020).
- **Tumpaper locations:** line 185 (§5.3), line 238 (§7.1), line 381 (References — auto title 정정)
- **Notes:** ✅ Tumpaper cite 정확하지만 부제 누락. Auto title 정정 적용.

#### C4 — Kirchweger, Kantelhardt, and Leisch (2022) 🔴 CITATION ERROR — AUTO 정정

- **Citation key (tumpaper, incorrect):** `KirchwegerKantelhardtLeisch2022_QOpen_INCORRECT`
- **Tumpaper attribution (wrong):** "*Q Open*, **2(1)**, qoac007."
- **Verified actual:** Q Open 2(1) qoac007 = "**Impacts of import restrictions on poultry producers in Ghana**" by Zamani et al. — NOT Kirchweger paper.
- **Verified Kirchweger et al. 2022 actual paper:** Kirchweger, S., Kantelhardt, J., & Leisch, F. (2022). "Direct payments and on-farm employment: **Evidence from a spatial regression discontinuity design**." ***Q Open*, 3(3)**, **qoac024**.
- **DOI:** Article ID qoac024 (Oxford Academic Q Open)
- **Auto-corrected citation key:** `KirchwegerKantelhardtLeisch2022_QOpen` → use `Volume 3(3), qoac024`
- **Cite caution:** **"Evidence from a spatial regression discontinuity design"** — full subtitle. **Spatial RDD applied to Swiss dairy farms**. Method note: spatial RDD with two-stage least squares (2SLS) + local linear regression. Distinguishes male and female employment.
- **Dissertation use:** §2.1 background (Swiss direct payment RD comparator). §1 contribution differentiation. 텀페이퍼 line 48 "스위스 직불금 RD 연구도 단일 시점 횡단면이어서 도입 효과 식별은 제한적이었다" — Kirchweger et al. (2022)는 **spatial RD**임을 정확히 인용. Single-cross-section critique 정당.
- **Tumpaper locations:** line 48 (§2.1 본문), line 379 (References — auto attribution 정정)
- **Notes:** 🔴 Critical citation verification finding. Auto correction applied. `[LEARN:citation-verification]` candidate.

---

### Tier B+ — Tier 2 (3편, 텀페이퍼 References ground truth)

#### C5 — Kimball (1990) [precautionary saving, Tier 2]

- **Citation key:** `Kimball1990_ECTA`
- **Full attribution:** Kimball, M.S. (1990). "Precautionary Saving in the Small and in the Large." *Econometrica*, **58(1)**, 53-73.
- **DOI / URL:** JSTOR Stable URL https://www.jstor.org/stable/2938334
- **Cite caution:** "**Precautionary Saving**" framework. Isomorphism to **Arrow-Pratt theory of risk aversion** — paper의 핵심 contribution.
- **Dissertation use:** §3.3 보조채널 1 (Sandmo) 보강 — precautionary motive 이론 토대.
- **Tumpaper locations:** line 94 (§3.3 본문), line 377 (References)
- **Notes:** ✅ Tumpaper cite 정확.

#### C6 — Aiyagari (1994) [smooth investment 대조, Tier 2]

- **Citation key:** `Aiyagari1994_QJE`
- **Full attribution:** Aiyagari, S.R. (1994). "Uninsured Idiosyncratic Risk and Aggregate Saving." *Quarterly Journal of Economics*, **109(3)**, 659-684.
- **DOI:** **10.2307/2118417**
- **Cite caution:** "**Uninsured Idiosyncratic Risk**", "**Aggregate Saving**". **Smooth investment** 가정 모형의 표준 — Caballero-Engel의 lumpy 투자와 정반대 prediction.
- **Dissertation use:** §3.2 contrast — Caballero-Engel lumpy 모형이 Aiyagari smooth 모형과 정반대 β(경영비) 예측을 도출. 본 연구의 가설 차별화.
- **Tumpaper locations:** line 88 (§3.2 본문), line 366 (References)
- **Notes:** ✅ Tumpaper cite 정확.

#### C7 — Romano and Wolf (2005) [multiple testing, Tier 2]

- **Citation key:** `RomanoWolf2005_ECTA`
- **Full attribution:** Romano, J.P., & Wolf, M. (2005). "Stepwise Multiple Testing as Formalized Data Snooping." *Econometrica*, **73(4)**, 1237-1282.
- **DOI:** **10.1111/j.1468-0262.2005.00615.x**
- **Cite caution:** "**Stepwise Multiple Testing**" / "Formalized Data Snooping" — 본 연구의 Holm step-down family-wise correction의 이론 토대. Bonferroni보다 powerful.
- **Dissertation use:** §7.3 다중검정 보정 (Holm stepdown)의 이론 토대 cite.
- **Tumpaper locations:** line 382 (References) — body text mention 미명시 (텀페이퍼는 Holm stepdown 직접 사용, Romano-Wolf는 reference로만)
- **Notes:** ✅ Tumpaper cite 정확.

---

## 섹션 (b) Lens 1 — 식별 가정 검증 항목 6개

각 항목 형식:
```
### B-N: [Assumption name]

- **What slide/section/code must show:** [...]
- **Violation criterion:** [what would constitute a failure]
- **Robustness/test:** [paper + method that addresses it]
- **Tumpaper status:** [whether tumpaper §7 already addresses this]
```

### B-1: DiD parallel trends (period extension challenge)

- **What must show:** Pre-period 2018-2019 (only 2 years) supports parallel trends. Event-study coefficient β_2018 (relative to 2019 base) must be statistically insignificant.
- **Violation criterion:** β_2018 significant at 10% in T1 or T2 → parallel trends violated.
- **Robustness/test:** Event-study event-time chart (텀페이퍼 §7.2 표 3); alternative — Sun and Abraham (2021) interaction-weighted estimator if heterogeneous timing.
- **Tumpaper status:** ✅ §7.2 (table 3) reports β_2018 T1 = +218,448 (insignificant) and T2 = -1,636,328 (insignificant, p > 0.15). Pre-trends pass at 2 pre-periods, but **power is limited**.
- **Step 3-3 lens question:** "Pre 기간 2년만으로 동적 평행추세 검정의 검정력이 충분한가? 박사논문은 Pre 기간 확장 (2017 자료 추가) 또는 Roth et al. 2023 best practice 인용으로 보강해야 한다."
- **Citations:** Roth, Sant'Anna, Bilinski, Poe (2023) [B6]; Callaway and Sant'Anna (2021) [B5] for conditional version.

### B-2: RD continuity at 0.5 ha cutoff (running variable density)

- **What must show:** Cultivated land area distribution at the 0.5 ha cutoff is **smooth** — no artificial bunching just below 5,000 ㎡.
- **Violation criterion:** McCrary density test p < 0.05; Cattaneo-Jansson-Ma p < 0.05 → manipulation evidence.
- **Robustness/test:** McCrary (2008) [C3]; Cattaneo, Jansson, Ma (2020) [B9] using `rddensity::rdbwdensity()` R command.
- **Tumpaper status:** ✅ §7.1 reports CJM test p = 0.147 (no manipulation evidence). T1 (±500 ㎡) bandwidth used.
- **Step 3-3 lens question:** "박사논문에서 동일 검정을 더 정교한 bandwidth (e.g., MSE-optimal h_density)에서 재실행해야 한다. T1 ±500㎡만으로는 manipulation 기각 robustness 한계."

### B-3: Covariate continuity at the cutoff

- **What must show:** Pre-determined covariates (경영주 연령, 자작비율, 성별 등)가 cutoff에서 불연속을 보이지 않아야 한다 — placebo balance test.
- **Violation criterion:** Any covariate β at cutoff significant at 5% → confounding.
- **Robustness/test:** Cattaneo-Calonico-Titiunik [B8] standard RD on each covariate. Reports in §7 of dissertation.
- **Tumpaper status:** ✅ §7.1 reports all covariates p > 0.14 (continuous).
- **Step 3-3 lens question:** "박사논문에서 covariate list를 확장해야 한다 (텀페이퍼 3개만 보고 — 가구원 수, 농업 영농 경험 연수, 작목 구성 등 추가)."

### B-4: Donut RD robustness (no bunching artifact)

- **What must show:** 컷오프 극근방 (±100㎡, ±200㎡)을 제외해도 main β가 유지된다.
- **Violation criterion:** Donut RD β가 main β와 유의미하게 다름 → bunching artifact.
- **Robustness/test:** Cattaneo-Idrobo-Titiunik (2017) RD donut methodology. Implemented in `rdrobust` with `donut` option.
- **Tumpaper status:** ✅ §7.1 보고. "오히려 증폭" — donut RD 통과. Bunching artifact 기각.
- **Step 3-3 lens question:** "Donut size 선택 정당성 (왜 ±100, ±200 only? More sizes 권장)."

### B-5: Manipulation absence

- **What must show:** Farmers do not strategically adjust 2018 area to be just under 5,000 ㎡ in anticipation of the 2020 PIDPS introduction.
- **Violation criterion:** Pre-2020 announcement period에서 area distribution shift 발견.
- **Robustness/test:** Cattaneo, Jansson, Ma (2020) [B9] manipulation test (이미 B-2와 중복). Plus: 정책 announcement 시점과 area measurement 시점의 시간 gap 분석.
- **Tumpaper status:** ✅ §7.1 reports CJM p = 0.147. 2018 baseline 사용으로 조작 cycle 차단 (CLAUDE.md identification snapshot).
- **Step 3-3 lens question:** "PIDPS 정책 발표일이 정확히 언제인가? 발표일 이전 area distribution과 이후 distribution 비교 robustness."

### B-6: (S,s) regularity for Korean small farms — **PLACEHOLDER (도현님 입력)**

> **TO BE FILLED BY 도현님:**
>
> 박사논문에서 Caballero-Engel (S,s) lumpy investment 모형 적용의 한국 소농 정당성을 quantitatively defend해야 한다. 다음을 명시해주세요:
>
> - **자본 임계점 s 추정 근거:** 한국 농기계 시장 가격 — 트랙터, 이앙기, 콤바인의 평균 가격 (수천만원 수준 추정). 또는 농업진흥원/한국농촌경제연구원의 농기계 보급률 자료.
> - **정액 이전 T = 120만원 vs 임계점 s 비교:** 1.2 million KRW vs (트랙터 ~5,000-10,000 만원). T < s_min 직접 증거.
> - **자본 스톡 distribution 한국 소농 자료:** FHES `자본_농업용` 변수 분포 — 0.5ha 경계 근방 농가 자본 스톡 평균/중위/분위.
> - **Inaction region prediction empirical support:** 자본 스톡이 낮은 (s 미달) 농가는 재투자 안 함 → 정액 이전을 변동비/소비로 흡수. β(경영비) ≤ 0 prediction의 정량 정당화.
>
> 이 자료는 도현님 단계 4 분석 시점에 FHES 자본 변수 + 외부 농기계 가격 자료로 보강. 박사논문 §3.2 (S,s) 모형 application section에 명시.

---

## 섹션 (c) Lens 2 — Derivation Check 5개 (자동, Grembi-Nannicini-Troiano 2016 framework)

### C-1: 식 (1) DiD-RD specification ↔ theoretical model mapping

- **Equation in tumpaper:** `Y_it = β · D_i · Post_t + γ_1 (rv_i · Post_t) + γ_2 (D_i · rv_i · Post_t) + μ_i + α_t + ε_it`
- **Theoretical counterpart:** Caballero-Engel reduced form. β captures the **state-dependent investment hazard** difference between treated (D=1, ≤0.5ha) and control (D=0, >0.5ha) groups, post-PIDPS.
- **Verification:** Confirm β identifies the CATE × ITT × LATE compound. Per Hahn-Todd-vanderKlaauw (2001) [B7], the RD-DiD interaction (D · Post · 1[|rv| ≤ h]) under continuity assumptions identifies a local average treatment effect (LATE) under sharp eligibility (D = 1[rv ≤ 5000]).
- **Step 3-3 lens question:** "β의 의미를 박사논문 §5.1에서 단 한 문장으로 정확히 진술. ITT (eligibility, NOT enrollment)의 명시. 텀페이퍼 line 169는 \"차등 의도처치(ITT) 국소평균효과(LATE)\" — 이를 영문 paper에서 어떻게 표현?"
- **Citations:** Grembi, Nannicini, Troiano (2016) [B4]; Hahn, Todd, Van der Klaauw (2001) [B7].

### C-2: Reduced-form β decomposition: level effect vs structural effect

- **Issue:** β in eq (1) captures **two distinct mechanisms** simultaneously, which the dissertation must decompose:
  - **Level effect:** 소농직불 120만원 - 면적직불 102.5만원 = 17.5만원 차등 (텀페이퍼 §2.3 line 67)
  - **Structural effect:** 정액 (lump-sum) vs 면적비례 (area-proportional) 지급 형태의 차이
- **Decomposition strategy:** 
  - Approach 1: Calibrate the level effect using pre-period transfer values; subtract from β to isolate structural effect. Caveat: assumes linearity of mechanism.
  - Approach 2: 박사논문 §3.2 (S,s) 모형의 비선형 prediction과 정합 — 정액 (S,s) lumpiness is the structural channel; level effect alone (smooth model) would yield β > 0 in opposite sign (Aiyagari 1994 [C6]).
- **Tumpaper status:** §2.3 (line 67), §9 limitation (line 358) explicitly notes this decomposition is NOT done. Step 4 dissertation work.
- **Step 3-3 lens question:** "박사논문에서 (i) 분해를 시도하는가, 또는 (ii) limitation으로 명시하는가? §8.5 정책함의 (단가 인상 vs 재투자 조건부)는 두 효과 분해에 의존."
- **Citations:** Caballero-Engel (1999) [B1]; Aiyagari (1994) [C6].

### C-3: Wild cluster bootstrap p-value algorithm

- **Procedure:** `fwildclusterboot::boottest(model, B = 9999, clustid = ~hh_id, type = "rademacher")`. Per Cameron, Gelbach, Miller (2008) Wild bootstrap-T procedure with Rademacher weights.
- **Verification:** B = 9,999 reps, household-level cluster, seed-pinned per-replicate (`r-code-conventions §11`). Pseudo-code:
```r
set.seed(20260504)
boot_t <- boottest(m_main, param = "D_treat:Post", B = 9999L,
                   clustid = ~hh_id, type = "rademacher")
p_wild <- boot_t$p.val
```
- **Tumpaper result:** §7.3 reports T1 경영비 Wild p = 0.018 (vs normal p = 0.045). MORE significant under Wild — small-sample asymptotic-normal failure direction.
- **Step 3-3 lens question:** "왜 Rademacher weights 선택? Webb 6-point alternative과 비교? B = 9,999가 아닌 B = 999/4,999 sensitivity?"
- **Citations:** Cameron, Gelbach, Miller (2008) (not in tumpaper but standard).

### C-4: Holm stepdown over 4 primary outcomes

- **Procedure:** Collect Wild bootstrap p-values for the 4 primary outcomes (경영비, 농외소득, 소비지출, 농업소득). Apply `p.adjust(p_vals, method = "holm")`. Holm-corrected p-value rejects at α if **the smallest is < α/4 AND second-smallest < α/3 AND ...**
- **Verification:** 텀페이퍼 §7.3 (table 4): p_(1) = 0.018 (경영비), p_(2) = 0.068 (소비지출), p_(3) = 0.879 (농업소득), p_(4) = 0.979 (농외소득). Holm: 0.018 × 4 = 0.072 (경영비 marginal at 10%); 0.068 × 3 = 0.204 (소비지출 not significant under Holm).
- **Tumpaper result:** Headline coefficient (경영비) survives at 10% Holm-corrected family-wise level; consumption does not.
- **Step 3-3 lens question:** "왜 4개 primary outcomes만 family로 정의? Robustness specs (cluster sgg_cd, MSE bandwidth)도 family에 포함할지 — Romano-Wolf (2005) stepwise는 동일 hypothesis multiple-test family를 더 broad하게 정의 가능."
- **Citations:** Romano and Wolf (2005) [C7] — stepwise multiple testing 이론 토대.

### C-5: rdrobust MSE-optimal bandwidth (T3) polynomial order

- **Procedure:** `rdbwselect(y, x, c = 5000, p = 1, kernel = "triangular", bwselect = "mserd")` returns h_MSE per outcome.
- **Verification:** 텀페이퍼 §5.2 (line 177) reports T3 = 3,268-3,929 ㎡ (outcome별 다름). Polynomial order p = 1 (local linear), kernel = triangular per Calonico-Cattaneo-Titiunik (2014) [B8] default. Bias correction p+1 = 2 (local quadratic) automatic.
- **Step 3-3 lens question:** "p = 1 vs p = 2 polynomial order 선택의 정당성? Sensitivity? B8 paper recommends p = 1 default but may differ for outcome characteristics."
- **Citations:** Calonico, Cattaneo, Titiunik (2014) [B8].

---

## 섹션 (d) Lens 4 — Code-Theory Alignment 5개 (r-code-conventions §10-13 외 추가)

§10-13 ((variable naming, clustering, sessionInfo, figure/table output)는 이미 r-code-conventions에 명시. 추가 5개:

### D-1: Sample restriction in code matches text exactly

- **Issue:** 텀페이퍼 text says "T1: ±500㎡" — does the R code actually filter `dplyr::filter(rv_2018 >= -500 & rv_2018 <= 500)` (centered) or `dplyr::filter(area_2018 >= 4500 & area_2018 <= 5500)`?
- **Verification:** Confirm `rv_i = A_{i,2018} - 5000` (centered, per tumpaper line 167) is used and the bandwidth is **on the centered variable**.
- **Code-theory check:**
```r
# Text: rv_i = A_i,2018 - 5000; T1 bandwidth ±500
df_T1 <- df_fhes %>% filter(abs(rv_2018) <= 500)
# NOT: df %>% filter(area_2018 >= 4500 & area_2018 <= 5500)  # equivalent but less direct
```
- **Step 3-3 lens question:** "Confirm centered/uncentered choice consistency across all 3 bandwidth tiers and all 4 outcomes."

### D-2: Treatment dummy 2018 baseline enforcement (across all robustness)

- **Issue:** `D_treat = 1[rv_2018 ≤ 0]` (centered) or `D_treat = 1[area_2018 ≤ 5000]` (raw). Both equivalent at baseline. **Critical:** D_treat must use **2018 area only**, never `area_t` (time-varying) — else manipulation contamination.
- **Verification:** All robustness specifications (sub-district cluster, MSE bandwidth, Wild bootstrap, Holm-corrected, etc.) use `D_treat` defined at 2018 baseline. Search code for any `1[area_t ≤ ...]` — should be zero.
- **Code-theory check:**
```r
# CORRECT (per r-code-conventions §6 pitfall row #1)
df %>% mutate(D_treat = (rv_2018 <= 0))
# WRONG (manipulation contamination, RD invalid)
df %>% mutate(D_treat = (area_t <= 5000))  # NEVER do this
```
- **Step 3-3 lens question:** "박사논문 robustness section에서 D_treat의 2018 baseline 정의를 명시 — referee가 'why not use current-year area?' 질문 시 답변 가능해야."

### D-3: Holm correction over 4 primary outcomes only (NOT all reported tests)

- **Issue:** `p.adjust()` requires identifying which p-values are in the family. Including too many → over-correction; too few → no protection.
- **Verification:** Code applies `p.adjust(c(p_경영비, p_소비, p_농업, p_농외), method = "holm")` — exactly 4 primary outcomes per CLAUDE.md identification snapshot. Robustness checks (cluster sgg_cd, MSE bandwidth, etc.) are NOT in the family — they are sensitivity analyses, not separate tests.
- **Code-theory check:**
```r
# Step 1: Wild bootstrap p-values for the 4 primary outcomes (T1 ±500m)
p_primary <- c(
  op_cost = boottest(m_op_cost, param = "...", B = 9999L)$p.val,
  off_farm_income = boottest(m_off, ...)$p.val,
  consumption = boottest(m_cons, ...)$p.val,
  farm_income = boottest(m_farm, ...)$p.val
)
# Step 2: Holm step-down (4 outcomes ONLY)
p_holm <- p.adjust(p_primary, method = "holm")
```
- **Step 3-3 lens question:** "헤테로지니티 분석 (5 dimensions × 4 outcomes = 20 tests) 의 multiple-testing은 어떻게 처리? 헤테로지니티는 family에 포함하는가, 별도 처리하는가?"

### D-4: Wild bootstrap seed (per-replicate seed_base + b)

- **Issue:** Naive `set.seed(20260504); boottest(...)` 한번만 set seed. Inside loop bootstrap, replicate b's RNG state is determined by global state — but for nested bootstrap (e.g., bootstrap of bootstrap), 자유 seed는 reproducibility 깨질 수 있음. Per `r-code-conventions §8` numerical discipline: "Deterministic bootstrap seeding. Set seed before the bootstrap, and if the bootstrap is nested, set per-replicate seeds as `seed_base + b`."
- **Verification:** Confirm code uses single global `set.seed(20260504)` before `boottest()` invocation (not nested), and that the same seed produces identical p-value across runs.
- **Code-theory check:**
```r
set.seed(20260504)  # global, sufficient for non-nested bootstrap
result <- boottest(m, B = 9999L, clustid = ~hh_id, ...)
# Nested case (rare; only if bootstrap-of-bootstrap):
# for (b in 1:B) { set.seed(20260504 + b); ... }
```
- **Step 3-3 lens question:** "박사논문 replication package의 deterministic reproducibility — 동일 seed로 동일 p-value 재현 가능한가? AEA Data Editor checklist 준수."

### D-5: modelsummary `coef_map` Korean-English consistency

- **Issue:** `paper/ko/` 사용 `tab_main_did_rd_ko.tex`와 `paper/en/` 사용 `tab_main_did_rd_en.tex`는 동일 `m_T1, m_T2, m_T3` model objects에서 생성. 단 `coef_map`이 Korean (`경영비_변동`) 또는 English (`Op cost change`) 라벨을 적용. **Variable order, sign, magnitude는 모두 동일해야 함**.
- **Verification:** Manual check — Korean LaTeX 표와 English LaTeX 표의 coefficient values, SE, N must be byte-identical (only labels differ).
- **Code-theory check:**
```r
en_coef_map <- c("D_treat:Post" = "Treat × Post",
                 "rv_2018:Post" = "RV × Post", ...)
ko_coef_map <- c("D_treat:Post" = "처치 × Post",
                 "rv_2018:Post" = "RV × Post", ...)

# Generate both — coefficients identical, only labels swap
modelsummary(list("(1)" = m_T1, "(2)" = m_T2, "(3)" = m_T3),
             output = "scripts/R/_outputs/tab_main_did_rd_en.tex",
             coef_map = en_coef_map, ...)
modelsummary(list("(1)" = m_T1, "(2)" = m_T2, "(3)" = m_T3),
             output = "scripts/R/_outputs/tab_main_did_rd_ko.tex",
             coef_map = ko_coef_map, ...)

# Verification: numeric content of two .tex files must be identical
# (only labels differ)
```
- **Step 3-3 lens question:** "Bilingual table consistency 자동 검증 가능한 grep/diff sanity check를 R script에 추가? (예: 'extract coefficient values via regex, compare ko vs en, must be identical')."

---

## 섹션 (e) Lens 5 — Logic Chain 7개 (자동 5 + placeholder 2)

### E-1: 문제제기 → 식별 선택 (왜 DiD-RD인가) [자동]

- **Question chain:** Why is DiD-RD better than DiD-only or RD-only here?
- **Answer (per tumpaper §1, §5):**
  - **DiD-only:** treatment is national (PIDPS in 2020 covers all farms ≤ 0.5ha), so naive DiD compares treated farms with **non-treated farms (>0.5ha)** which receive **smaller area-based payments** (not zero). Identification still works, but the running variable cutoff structure is unused.
  - **RD-only:** treatment is implemented at one point in time (May 2020); pre-treatment (2018-2019) has no cutoff differential. RD-only loses temporal comparison.
  - **DiD-RD combined:** uses the cutoff (0.5ha) for cross-sectional identification + the policy introduction (2020) for temporal identification. Per Grembi, Nannicini, Troiano (2016) [B4] framework — **double identification**.
- **Verification check:** §1 motivation paragraph mentions both dimensions; §5.1 estimating equation has both cutoff (rv_i) and time (Post_t).
- **Step 3-3 lens question:** "도현님 박사논문 Introduction에서 'why DiD-RD' justification 한 paragraph가 명확한가?"

### E-2: 식별 → 추정 (every estimator parameter ↔ identifying assumption) [자동]

- **Each parameter in eq (1) requires assumption:**
  - β (causal): assumes RD continuity (B-2) + parallel trends (B-1) jointly. Per Grembi-Nannicini-Troiano (2016) [B4].
  - γ_1, γ_2 (slope on rv): assume linear functional form within bandwidth (Calonico-Cattaneo-Titiunik 2014 [B8] suggests local linear).
  - μ_i (farm FE): assumes time-invariant unobserved heterogeneity. **Crucial** — without farm FE, β identifies cross-sectional + time variation jointly, not cleanly.
  - α_t (year FE): absorbs aggregate shocks (e.g., COVID-19 in 2020-2021 affecting all farms identically; weather shocks).
  - ε_it: clustered at hh_id (B-3 above).
- **Verification check:** §5.1 equation (1) presentation must list every parameter's identifying assumption explicitly.
- **Step 3-3 lens question:** "박사논문 §5.1에서 모든 parameter ↔ assumption 매핑이 명시되어 있는가? Referee가 따라갈 수 있는 mapping table 권장."

### E-3: 추정 → 결과 (every table number ↔ `_outputs/*.rds`) [자동]

- **Reproducibility requirement:** Every numeric claim in §6 (results) and §7 (robustness) and §8 (interpretation) must point to a specific `.rds` object in `scripts/R/_outputs/`. Per `.claude/rules/audit-reproducibility` and `quality-gates.md` §English Manuscript table (Major −10 deduction).
- **Verification chain:** 
  - Tumpaper §6.1 "β = -4,180,142, SE = 2,087,743" → `scripts/R/_outputs/m_main_T1_op_cost.rds` → `coef(m_main)["D_treatTRUE:PostTRUE"]` and `vcov(m_main)["D_treatTRUE:PostTRUE", ...]`.
  - Tumpaper §6.2 "27% of average operating cost" → `1,550,000 KRW` (mean). Must trace to `_outputs/descriptive_stats.rds`.
  - Tumpaper §7.3 "Wild p = 0.018, Holm p = 0.072" → `_outputs/wild_boot_results.rds` and `_outputs/holm_corrected.rds`.
- **Step 3-3 lens question:** "박사논문 table caption에 `_outputs/<filename>.rds` 명시 footnote 권장 (Replication note)."

### E-4: 결과 → 해석 (β sign+magnitude ↔ which channel) [자동]

- **Sign+magnitude consistency check:**
  - **β(경영비) = -4,180,142 (negative, large)** → Caballero-Engel [B1] (S,s) lumpy investment **임계점 미달 prediction**. ✅
  - **β(농외소득) ≈ 0 (null)** → Sandmo [B2] precautionary labor supply prediction **rejected** (predicted negative). ✅ Tumpaper §8.2 explicit.
  - **β(소비지출) > 0** → Blundell-Pistaferri [B3] / Chetty [A3] consumption smoothing / **liquidity effect** **partial support**. ✅
  - **β(농업소득) ≈ 0** → omnibus null, consistent with offsetting channels (input-output proportional reduction). ✅
- **Mixed-channel check:** No coefficient sign contradicts the dominant channel (Caballero-Engel). The §8 narrative cleanly attributes to lumpy investment as primary, with secondary support from Blundell-Pistaferri / Chetty (liquidity).
- **Step 3-3 lens question:** "박사논문 §8 interpretation paragraph에서 each coefficient → channel 매핑이 1:1인가? Mixed/contradicting channel claims 없어야."

### E-5: 해석 → 정책함의 (단가 인상 vs 재투자 조건부) [자동, 텀페이퍼 §8.5 line 337-344 기반]

- **Per tumpaper §8.5:** 본 연구 결과는 공익직불제 법령 제10조의 두 목적이 비대칭 달성됨을 시사. (i) **소득 안정** — 소비지출 유지·증가 (경계 유의)로 부분 달성. (ii) **영농 지속** — 경영비 감소가 시사하는 "축소된 지속".
- **Policy implications (tumpaper line 343-344):**
  - **Option I:** 소농직불금 단가를 임계점 s 초과로 인상 → 재투자 촉발 → β(경영비) > 0 prediction (Aiyagari [C6] smooth investment territory).
  - **Option II:** 재투자 조건부 지급 설계 — 정액 이전을 재투자 사용 시에만 지급. 목적함수 재정렬.
- **Channel-policy 정합성:** 두 정책함의 모두 Caballero-Engel [B1] (S,s) 모형의 임계점 prediction과 정합. Sandmo / Blundell-Pistaferri / Kirwan 채널과는 무관 (이들은 본 연구의 주 채널 아님).
- **Step 3-3 lens question:** "박사논문에서 정책함의가 (S,s) 채널 정합성에만 의존하는데, 만약 referee가 'lumpy investment 가정 기각하면 정책함의도 기각되는가?'라고 물을 시 답변? — Sandmo 기각 + Blundell-Pistaferri 부분 지지가 (S,s) 채널의 strength를 직접 시사."

### E-6: 박사논문 심사위원 특수 질문 — **PLACEHOLDER (도현님 입력)**

> **TO BE FILLED BY 도현님 (다음 세션):**
>
> 도현님 박사논문 심사위원 (지도교수 이상헌 + 식품자원경제학과 추가 위원)의 강조점·관심사를 명시. 예시 질문 카테고리:
>
> - 지도교수 이상헌 강조점: [도현님 thesis 지도 동안 반복 강조된 사항]
> - 식품자원경제학과 일반 심사 관행: [학과 특수 심사 기준]
> - 한국 농경 정책 전공 심사위원의 특수 관점: [정책 현실성 / 제도 정합성 / 이행 가능성 등]
> - 본 연구 specific 질문: [도현님이 예상하는 referee objection 3-5개]

### E-7: 한국농업경제학회 referee 관점 — **PLACEHOLDER (도현님 입력)**

> **TO BE FILLED BY 도현님 (다음 세션):**
>
> 한국농업경제학회/농업경제연구·농업경영·정책연구지의 referee가 본 연구를 review할 시 자주 묻는 질문 카테고리. 도현님 학회 발표·게재 경험 기반.
>
> - 본 연구가 한국 학회지 게재시 referee의 관점은 박사논문 영문 게재 (AJAE/Food Policy/JAE) referee와 어떻게 다른가?
> - 한국어 paper 단계에서 catch되어야 할 issue (예: 한국 농정 제도 정확성, 한국 통계청 자료 사용 정당성, 한국 농가 representativeness 등)
> - paper/ko 작성 시 한국 학회 referee 관점 대비 self-review checklist

---

## 섹션 (f) — Future Citations to Investigate (Step 4 보강 후보)

### Option γ: 박사논문 §3.3 "이탈 억제" channel 보강 (B11 Kimhi cut에 대응)

B11 Kimhi 1994는 인용 오류 확정으로 cut됨. Channel은 Weiss (1999)만으로 운영 가능하나, 박사논문 단계에서 보강 후보:

1. **Glauben, T., Tietje, H., & Weiss, C.R. (2006)** "Farm Exits, Lifecycle and Mobility in Family Farms" — exit decision의 lifecycle 모형. WebSearch 발견.
2. **Goetz, S.J., & Debertin, D.L. (2001)** "Why Farmers Quit: A County-Level Analysis." *AJAE* 83(4): 1010-1023. Exit determinants empirical study.
3. **Hill, B.E., Boehlje, M., & Lawrence, J.D. (2010)** "Investment and Abandonment Behavior of Rural Households" *AJAE*. WebSearch에서 발견.
4. **Mishra, A.K., et al.** "Off-Farm Income, Technology Adoption, and Farm Exit" — 보조 cite candidate.
5. **Pluriactivity-Farm Exit literature** (e.g., Factor Markets working paper series) — 유럽 context.

도현님 단계 4 분석 시점에 1-2개 발굴 + step-3-3-prep.md 보강. 또는 Option β로 유지 (Weiss 1999 단독).

### Tier 3 cut 재검토 (단계 4 시점)

- **Chavas and Holt (1996)** *RES* "Economic Behavior under Uncertainty" — 위험 선호와 기술. 박사논문 §3.3 보조채널 1 (Sandmo) 보강에 사용 가능. 단계 4 분석 시 위험 선호 측정 필요 시 재검토.
- **Rust (1987)** *Econometrica* "Optimal Replacement of GMC Bus Engines" — 구조추정 (S,s) lineage. 박사논문 §9 한계·향후 연구 (line 358) "Rust (1987) 류의 구조 추정"으로 cite (한 문장). Tier 3에서 Tier 2로 승격 가능 (limitations cite).

---

## 섹션 (g) — Verification Log

### 27편 attribution 검증 결과 (Phase 1 + Phase 2 + Phase 3)

**카테고리별:**
- A 카테고리 (8편 PDF 보유): pypdf 직접 + 텀페이퍼 cross-check
- B 카테고리 (11편): WebSearch + CrossRef DOI
- B+ 카테고리 (7편): 텀페이퍼 References + WebSearch DOI
- D (텀페이퍼 1편): Markdown 직접 분석

**텀페이퍼 References cross-check:**
- 텀페이퍼 27편 References (line 364-388) 중:
  - 정확 일치: 21편 (A1, A2, A4, A5, A6, A7, A8, B1, B2, B3, B4, B8, B9, B10*, B11**, C1, C3*, C5, C6, C7) — *B10 title 줄임, *C3 부제 누락, **B11 paper 미존재
  - 박사논문 추가 (텀페이퍼 미인용): 4편 (A3 Chetty, B5 Callaway-Sant'Anna, B6 Roth et al., B7 Hahn-Todd-vanderKlaauw)
  - Critical attribution error: 1편 (C2 Gardebroek-Oude Lansink — JAE 55(1):3-24 가능성)
  - Critical attribution error: 1편 (C4 Kirchweger et al. — Q Open 3(3):qoac024)
  - 🔴 Cut: 1편 (B11 Kimhi 1994 — paper 미존재)

### Hallucination ⚠️ 의심 항목 list (도현님 검토 highlight)

| # | Tag | 의심 사항 | 처리 |
|---|-----|----------|------|
| 1 | A1 | book vs WBER survey 두 paper | ✅ 결정 (iii) 둘 다 cite (A1a, A1b) |
| 2 | B10 | Title 줄임 ("U.S. Farm Programs" vs "U.S. Agricultural Subsidies on Farmland Rental Rates") | ✅ Auto title 정정 |
| 3 | B11 | 🔴 Paper 미존재 (76(4):874-880) | ✅ Tier 3 cut, Weiss 1999 단독 |
| 4 | C2 | ⚠️ ERAE vs JAE 학술지 차이 + 본문 "낙농 vs 돼지" 오류 | ⏳ Auto 정정 provisional, 도현님 검토 후 확정 |
| 5 | C3 | 부제 "A Density Test" 누락 | ✅ Auto title 정정 |
| 6 | C4 | 🔴 Volume/issue/article 모두 잘못 | ✅ Auto 정정 (3(3):qoac024) |

### 자동 정정 적용 list

- B3 Blundell-Pistaferri: ~~JPE~~ → *Journal of Human Resources*
- A6 Choi-Jodlowski: *Land Economics* 101(3):374-397 (2025) 확정
- A3 Chetty: NBER WP → JPE 116(2):173-234 (도현님 결정 7)
- B10 Kirwan: Title 정정 (published full title)
- C3 McCrary: 부제 "A Density Test" 추가
- C2 Gardebroek-Oude Lansink: ERAE → JAE 55(1):3-24 (provisional)
- C4 Kirchweger et al.: Q Open 2(1):qoac007 → 3(3):qoac024
- B11 Kimhi: cut from dissertation

---

## 섹션 (h) — `[LEARN:citation-verification]` Candidate

> **proposed for MEMORY.md** (도현님 다음 세션 승인):
>
> [LEARN:citation-verification] 텀페이퍼 단계에서 27편 인용 중 3편 critical 오류 + 2편 minor 차이 (= 11% 오류율) 발견. Pre-flight verification 단계 (publisher source / CrossRef DOI / journal TOC fetch / pypdf direct extraction) 가치 입증. 박사논문 영문 게재 (AJAE / Food Policy / JAE) 전 모든 인용을 CrossRef DOI 또는 journal TOC와 cross-check 필수. 특히 (a) volume/issue/page numbers, (b) journal name (JPE vs JHR 사례), (c) 한국 논문 dual-field, (d) 자료 본문에서 인용 문맥 검증 (e.g., 텀페이퍼 §3.2 "낙농" 표기 vs 실제 paper "pig"). 의심 발견 시 즉시 ⚠️ 표시 + plan에 누적 list로 보존.

> **Why:** 인용 정확성은 referee가 가장 빠르게 catch하는 issue. 영문 저널 desk-reject의 통상 reason 상위. Pedro replication-first workflow가 박사논문 단계에서 catch한 사례를 항구화.

> **Apply where:** any dissertation/journal paper with 20+ References. Apply before paper/ko stabilization, before paper/en translation, before submission.

---

## 섹션 (i) — Out of Scope (이번 spec NOT)

- `.claude/agents/domain-reviewer.md` 본 편집 (단계 3-3 본 plan, 다음 세션)
- `Bibliography_base.bib` 실제 entry 추가 (단계 4)
- placeholder 3개 자동 채움 ((b)-6 (S,s) 정당성, (e)-6 심사위원 질문, (e)-7 학회 referee 관점) — 도현님 다음 세션 입력
- `policy-glossary-ko-en.md` 작성 (단계 5)
- C2/C4 정정 최종 확정 (도현님 검토 후 paper 편집 시점)
- Tier 3 cut 2편 (Chavas-Holt 1996, Rust 1987 — 단계 4 재검토)
- `[LEARN:citation-verification]` MEMORY.md append (도현님 다음 세션 승인)

---

## 섹션 (j) — How to use this spec

1. 도현님이 (b)-6, (e)-6, (e)-7 placeholder 3개를 채움.
2. C2/C4 attribution 정정 최종 확정 (도현님 검토).
3. ⚠️ 의심 항목 6개 list 검토 + 처리 confirm.
4. `[LEARN:citation-verification]` 후보 승인.
5. Claude가 본 spec을 input으로 단계 3-3 본 plan 작성 (`quality_reports/plans/YYYY-MM-DD_step-3-3-domain-reviewer.md`).
6. 단계 3-3 본 plan에 따라 `.claude/agents/domain-reviewer.md` 5-Lens 커스터마이즈.
7. 박사논문 paper/ko 작성 시 본 spec의 27편 attribution + cite_caution을 항상 reference.
