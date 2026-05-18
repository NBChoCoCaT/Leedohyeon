# Plan — §3 이론적 틀 Chain 재구성 + Step 3a Nash worked example + Appendix A 신설

**Status:** REVISED v2 (Dohyeon plan-review approval, 2026-05-15 22:xx)
**Sister (post-approval):** `quality_reports/plans/2026-05-15_section3-chain-restructure-appendix-a.md`
**Mode:** Manual approval, plan-first; user invokes `/commit` after implementation

---

## v2 Revision (2026-05-15, post-stop plan review)

작업 중단 시점 (Phase 1 in_progress, Bibliography Phase 4a 완료) 직후, plan 자체를 재검토하여 세 가지 의사결정 반영:

1. **Phase 4c 제거** — CLAUDE.md "Never simultaneous bilingual edits" 규칙 준수. paper/ko 작업은 본 plan에서 완전히 제외. paper/en 전체 (§1-§7 + Appendix) stabilization 이후 별도 plan으로 일괄 re-sync.
2. **Appendix tiered** — 헤드라인 contribution과 직결되는 A.4 (Nash) + A.7 ((S,s)) 두 개만 main.tex 내 `\appendix`. 나머지 7개 (A.1, A.2, A.3, A.5, A.6, A.8, A.9)는 `paper/en/online_appendix.tex` 별도 파일로 분리.
3. **Appendix 파일 구조** — 처음부터 separate online appendix file. AJAE submission convention 부합 + main.tex 페이지 압박 회피.

기존 Phase 4a (bibliography +9 신규 entries, 3 citation correction)는 **이미 완료 상태** (`Bibliography_base.bib` M 표시, +120줄). v2에서는 verify-only 단계로 축소.

**Total wall-clock estimate (v2):** ~3h (Phase 4c 제거로 30min 단축).

---

## Context

사용자 질문: "AHM 기본 모델 → 확장 → reduced form → 계량 모형" 4단계 chain 구조로 §3 재구성 가능한가? 5개 채널 nested-relaxation build-up + Appendix A 수식 derivation 필요.

**현재 상태 (PR #3 bootstrap + PR #4 precision rewrite 결과):**
- `paper/en/main.tex` §3 — 11개 subsection 작성 완료 (총 ~280줄, §3.1-§3.11)
- `Bibliography_base.bib` — 12개 entry
- 5-channel framework (CH1 S,s, CH2 Sandmo, CH3 BP, CH4 Tenant-Driven, CH5 Exit)
- 컴파일 통과, PDF 존재

**현재 §3 vs 사용자 chain criterion (gap 분석):**

| 사용자 요구 chain 단계 | 현재 §3 충족도 | Gap |
|------|------|------|
| (1) Structural model (AHM Lagrangian + FOC + separability) | ✅ §3.2 완비 | — |
| (2) 확장 (nested-relaxation build-up) | ❌ §3.3은 1단락 generic dJFS, §3.4-3.8는 독립 channel 나열 | **build-up logic 누락** |
| (3) Reduced form (sign predictions) | ⚠️ Prediction block은 있으나 derivation은 ∂y/∂T 도출 안 됨 | **derivation 미공개** |
| (4) Econometric β mapping | ❌ Prediction 표는 "Empirical fit" 줄만, structural ∂y/∂T → DiD-RD β 명시 매핑 없음 | **mapping table 누락** |

**Label inconsistency**: §3.4 "Channel 1 (Main): Lumpy Investment" vs §3.7 "Channel 4 (Headline): Tenant-Driven Land Transition" — 둘 다 "primary"인가? P3b-2 reframing per CLAUDE.md는 Ch4가 contribution, Ch1은 behavioral anchor.

**Lit-review 검증 (5개 agent 결과, 2026-05-15):**
- ✅ AHM baseline §3.2 setup 정확 (Singh-Squire-Strauss + dJFS)
- ✅ Nash bargaining ∂r*/∂T = −(1−α)/A < 0 closed-form 도출 가능 (Banerjee-Ghatak 2002 JPE 110(2):239-280)
- ✅ Floyd-Alston-James incidence theory에 per-farm vs per-hectare 구분이 거의 없음 → 본 논문 contribution
- ✅ Carter-Olinto (2003 AJAE 85(1):173-186) wealth-biased liquidity constraint이 monotone gradient의 cleanest mechanism
- ⚠️ **Citation correction** required: Gardebroek-Oude Lansink는 ERAE 31(1):39-59 (not JAE 55) — 현재 bib 확인 필요
- ⚠️ **Citation correction** required: Kazukauskas et al. 2013 AJAE 95(5):1068-1087 covers Ireland, Denmark, Netherlands (not Ireland and Wales)

**Intended outcome:**
1. §3가 사용자 chain (Structural → Extension → Reduced form → β) 을 명시적으로 trace
2. Step 3a Nash bargaining의 full derivation (FOC → comparative statics → sign)을 본문 또는 Appendix에서 제시
3. Appendix A에 5개 채널의 ∂y/∂T derivation 정리 → 본문은 sign-prediction summary로 압축 유지
4. Bibliography citation 오류 수정

---

## Critical files to modify

| Path | Action | Phase | 변경 분량 |
|------|--------|-------|---------|
| `paper/en/main.tex` §3 | EDIT (restructure + add mapping table + label fix) | 1, 2 | ~50줄 modify, ~30줄 add |
| `paper/en/main.tex` 새 §A | APPEND (Appendix A 신설) | 3 | ~250줄 추가 |
| `paper/ko/main.tex` §3 | EDIT (translation parity) | 4 | ~50줄 modify, ~30줄 add |
| `paper/ko/main.tex` 새 §A | APPEND (Appendix A 한국어 mirror) | 4 | ~250줄 추가 |
| `Bibliography_base.bib` | EDIT (3개 citation correction + 8개 신규 entry) | 1 (병행) | ~80줄 추가 |
| `paper/en/main.pdf` + `paper/ko/main.pdf` | RECOMPILE | 5 | binary |
| `quality_reports/plans/2026-05-15_section3-chain-restructure-appendix-a.md` | CREATE (sister) | post-approval | this file 복사 |
| `quality_reports/session_logs/2026-05-15_section3-chain-restructure.md` | CREATE | post-approval | incremental |

**Reusable infrastructure (직접 참조 + reuse):**
- `paper/en/main.tex:90-122` — §3.2 baseline AHM (eq. 1-4, separability null) → Phase 1에서 그대로 보존, §3.3 부터 build-up logic만 강화
- `paper/en/main.tex:198-223` — §3.7.1 Nash bargaining setup (eq. nash, rstar, per-farm, per-ha) → Phase 2에서 derivation 확장 reference
- `paper/en/main.tex:293-311` — §3.9 prediction table → Phase 1에서 column 1개 추가 ("Reduced form" or "Step")
- `master_supporting_docs/own_drafts/초안.md` §3 lines 73-110 — Korean v1 reference (낡았지만 terminology 참고)
- `paper/narrative_draft_p3b.md` — Channel A/B/C 3-sub-channel framing 출처
- `.claude/rules/quality-gates.md` — paper/en 80점 threshold + Korean policy citation accuracy 가이드
- `.claude/rules/replication-protocol.md` — Phase 3 tolerance 가이드 (paper claim ↔ _outputs/*.rds)

---

## Implementation: 5 phases, ~3.5h wall-clock

### Phase 1 — §3 restructure: chain logic + reduced-form-to-β mapping (~1h)

**1a. §3.3 Non-Separable Extension 강화 (~15분):**
현 1단락 → 3단락 nested-relaxation enumerable:

```latex
\subsection{Non-Separable Extension: A Five-Step Build-Up}
\label{sec:nonseparable}

\citet{deJanvryFafchampsSadoulet1991_peasant} 표준 분류대로, separability를 
깨뜨리는 4가지 시장 불완전성(credit / insurance / labor / land)을 baseline에 
순차적으로 추가하여 5개 채널을 생성한다. 다음 표가 build-up 구조를 요약한다.

\begin{table}[h]
\centering
\caption{Five-step nested relaxation of the AHM baseline.}
\label{tab:buildup}
\small
\begin{tabular}{p{0.6cm} p{3.0cm} p{3.0cm} p{2.6cm} p{2.6cm}}
\toprule
Step & Imperfection added & Reduced-form & Outcome & Econometric $\hat\beta$ \\
\midrule
0 & \textit{None (baseline)} & $\partial y/\partial T = 0$ & all $y$ & H_0: $\beta = 0$ \\
1 & Credit constraint (BP 2003) & $\partial C / \partial T > 0$ & consumption & Ch.~3 \\
2 & Risk + prudence (Sandmo 1971) & $\partial L_o / \partial T < 0$ & off\_farm\_income & Ch.~2 \\
3a & Land bargaining (Nash) & $\partial r^* / \partial T < 0$ & unit\_rent & Ch.~4(i) \\
3b & + Per-farm incidence & $\partial \text{rent\_cost} / \partial T < 0$ & rent\_cost & Ch.~4(ii) \\
4 & Tenure-mode pivot (Carter-Olinto) & $\partial A_{own}/\partial T > 0$, mono $\tau$ & area\_own & Ch.~4(iii) \\
5 (overlay) & $(S,s)$ adjustment & $\partial$op\_cost\_ex\_rent$/\partial T \le 0$ & op\_cost\_ex\_rent & Ch.~1 \\
\bottomrule
\end{tabular}
\end{table}

각 단계 Step $k$는 한 가지 가정만 완화하며, 직전 단계의 FOC에 새 imperfection 
의 wedge를 추가한다. Steps 1--4는 AHM의 연속 마진(consumption, labor, land)에 
작동하고, Step 5는 자본 조정의 이산 마진(discrete capital adjustment)에 작동 
하므로 \citep{CaballeroEngel1999_lumpy, KhanThomas2008_idiosyncratic} 의 
표준에 따라 \emph{overlay}로 처리한다 (\S\ref{sec:ch5-overlay} 의 직교성 
서술 참조).
```

**1b. §3.4-§3.8 label + ordering 수정 (~20분):**
현재 channel 번호를 build-up step 번호로 재매핑:
- §3.4 (현 Ch.1 Main) → "§3.8 Channel 5 (Behavioral Overlay): $(S,s)$ Lumpy Investment" + label `\label{sec:ch5-overlay}`
- §3.5 (현 Ch.2 Aux Sandmo) → §3.5 (Step 2 가정 완화 후 도출, 위치 유지)
- §3.6 (현 Ch.3 Aux BP) → §3.4 (Step 1 — 먼저 추가, credit constraint이 가장 baseline에 가까움)
- §3.7 (현 Ch.4 Headline Tenant) → §3.6-§3.7로 분할 (3a + 3b + 4 step 세부화)
- §3.8 (현 Ch.5 Supp Exit) → 별도 §3.9로 이동 OR 합병 (Carter-Olinto 와 매핑 검토)

권장: **label만 수정** (Channel 번호는 보존; "(Step k)" prefix만 추가). Section 순서 재배열은 PR 크기 폭증 + reference label 깨짐 위험. 대신 §3.3 build-up 표 (1a)가 logical order를 명시적으로 제시.

새 label scheme:
- §3.4 → "Channel 1 (Step 5 Overlay): Lumpy Investment under $(S,s)$ Inaction"
- §3.5 → "Channel 2 (Step 2): Precautionary Off-Farm Labor (Sandmo 1971)"
- §3.6 → "Channel 3 (Step 1): Consumption Smoothing (Blundell-Pistaferri 2003)"
- §3.7 → "Channel 4 (Steps 3a + 3b + 4): Tenant-Driven Land Transition" (이미 sub-step 3개 있음)
- §3.8 → "Channel 5 (Supplementary): Exit Deterrence" (변경 없음)

**1c. §3.9 unified prediction table에 column 2개 추가 (~10분):**
현 (Channel | Imperfection | Outcome | Sign | Empirical fit) → 
(Channel | **Step** | Imperfection | Outcome | **Reduced form ∂y/∂T** | Sign | Econometric β | Empirical fit)

"Reduced form ∂y/∂T" 열에는 Appendix A의 식 번호 (eq. \ref{eq:dr-dT}, eq. \ref{eq:dC-dT} 등) 만 표시 → 본문 prose 압축.

**1d. §3.7 (Channel 4) "Stage 1 (Nash bargaining)" 의 prose minor revision (~15분):**
현 eq. \ref{eq:rstar} 의 첫 번째 항이 $(1-\theta)\overline{\text{MPL}}_A$인데, lit-review 결과는 closed-form $r^* = m + \bar u_L + (1-\alpha)\cdot[\pi(A) - c - \tilde u_T - \delta T - m - \bar u_L]/A$ (Banerjee-Ghatak 2002 quasi-linear 가정 하). 둘 다 valid → 본문은 현 form 보존, Appendix A에서 derivation 명시.

핵심: **eq. (per-farm)** (현 \ref{eq:per-farm}) 직후에 closed-form ∂r*/∂T = −(1−θ)δ/A < 0 을 한 줄로 추가하고 Appendix A.4 참조 제시.

### Phase 2 — Step 3a Nash bargaining worked example: full derivation (~45분)

**2a. Appendix A.4 신설 - Nash bargaining의 4-step chain proof:**

```latex
\subsection{A.4 Channel 4(i): Bargaining Margin Derivation (Step 3a)}
\label{sec:appA-nash}

\textbf{[1] Structural setup.} Stage 1 의 Nash bargaining problem 
(eq. \ref{eq:nash}, 본문):
\begin{equation}
r^* = \arg\max_r \; [V_T(r) - \bar u_T(T)]^\theta \cdot [V_L(r) - \bar u_L]^{1-\theta},
\tag{A.4.1}
\end{equation}
where (quasi-linear surplus 가정):
\begin{align}
V_T(r) &= \pi(A) - r \cdot A_{rent} - c + T, \tag{A.4.2}\\
V_L(r) &= r \cdot A_{rent} - m, \tag{A.4.3}\\
\bar u_T(T) &= \bar u_T^{(0)} + \delta \cdot T, \quad \delta \in (0,1]. \tag{A.4.4}
\end{align}
$\delta$ captures the share of $T$ that the tenant retains outside the rental 
contract (0.5 ha eligibility cutoff ensures $\delta > 0$).

\textbf{[2] First-order condition.} 로그를 취해 미분:
\begin{equation}
\theta \cdot \frac{V_T'(r)}{V_T(r) - \bar u_T(T)} + (1-\theta) \cdot \frac{V_L'(r)}{V_L(r) - \bar u_L} = 0.
\tag{A.4.5}
\end{equation}
$V_T'(r) = -A_{rent}$, $V_L'(r) = +A_{rent}$ 대입 후 정리:
\begin{equation}
(1-\theta) \cdot G_T(r^*, T) = \theta \cdot G_L(r^*),
\tag{A.4.6}
\end{equation}
where $G_T = V_T - \bar u_T$, $G_L = V_L - \bar u_L$ 는 양측의 협상 잉여.

\textbf{[3] Closed form for $r^*$.} (A.4.6) 을 $r$ 에 대해 풀면:
\begin{equation}
r^* \cdot A_{rent} = m + \bar u_L + (1-\theta) \cdot \left[\pi(A) - c - \bar u_T^{(0)} - \delta T - m - \bar u_L\right].
\tag{A.4.7}
\end{equation}

\textbf{[3'] Reduced-form comparative statics.} (A.4.7) 을 $T$ 에 대해 미분:
\begin{equation}
\boxed{\frac{\partial r^*}{\partial T} = -\frac{(1-\theta) \delta}{A_{rent}} < 0}
\tag{A.4.8}
\end{equation}
\emph{Sufficient conditions:} (i) $V_T, V_L$ continuous and strictly 
quasi-concave; (ii) $\theta \in [0,1)$ (landlord retains non-zero bargaining 
power); (iii) participation slack at $r^*$ ($G_T > 0, G_L > 0$); (iv) 
$\delta > 0$ (eligibility cutoff effective). \qed

\textbf{[4] Econometric mapping.} The reduced-form prediction maps to the 
DiD-RD coefficient $\beta_{(i)}$ on unit\_rent\_price:
\begin{equation}
\text{unit\_rent}_{it} = \alpha + \beta_{(i)} \cdot D_i \times \text{Post}_t + \gamma\, rv_i \times \text{Post}_t + \mu_i + \tau_t + \varepsilon_{it},
\tag{A.4.9}
\end{equation}
where $\beta_{(i)}$ estimates the eligibility-induced average treatment effect 
on unit rent. Under (A.4.8) and the take-up rate $\rho_{\text{take-up}} = 92.3\%$ 
(FHES variable \#84, MEMORY 2026-05-07), $\beta_{(i)} \approx \rho_{\text{take-up}} 
\cdot \partial r^* / \partial T \cdot T_{SFFP} \cdot \mathbb{E}[1/A_{rent} | D=1, A_{rent}>0] < 0$.

\textbf{Empirical fit.} P3b-2 reports $\hat\beta_{(i)} \in [-130, -48]$ KRW/m²
across non-pure-owner subgroups at T1 ($p \in [0.06, 0.08]$), consistent with 
$\theta \in [0.6, 0.85]$ (i.e., tenant captures most but not all of the subsidy).
```

**2b. 본문 §3.7.1 에서 Appendix A.4 참조 한 줄 추가:**
```latex
% After eq. (per-farm) in §3.7.1:
The closed-form $\partial r^* / \partial T = -(1-\theta)\delta/A_{rent} < 0$ 
derivation appears in Appendix~\ref{sec:appA-nash}.
```

### Phase 2 (v2) — Inline Appendix A.4 (Nash) + A.7 ((S,s)) only (~1h)

**v2 변경:** 본문 inline `\appendix`에는 contribution headline에 직결되는 derivation 두 개만 둔다.
- **A.4 Channel 4(i) Nash bargaining** — 위 2a 의 full block 그대로 사용. closed-form ∂r*/∂T = -(1-θ)δ/A_rent < 0.
- **A.7 Channel 1 (S,s) inaction overlay** — discrete adjustment + fixed cost φ + T/s_min ≈ 0.024 deeply inside band + Steps 1-4 와의 orthogonality 명시. ~30줄.

main.tex 의 `\bibliography{Bibliography_base}` 직전:

```latex
\appendix
\section{Channel Derivations (Inline)}
\label{sec:appA}

This appendix collects the two derivations most central to the contribution
in \S\ref{sec:theory}: the bargaining-margin closed form (Step 3a) and the
$(S,s)$ overlay (Step 5). Full derivations of the remaining channels (Steps
0-2, 3b, 4, plus the supplementary exit channel and the reduced-form-to-$\beta$
mapping table) appear in the \emph{Online Appendix} (`online_appendix.pdf`).

\subsection{A.4 Channel 4(i): Bargaining Margin Derivation (Step 3a)}
\label{sec:appA-nash}
% Full Phase 2a block, ~30 lines

\subsection{A.7 Channel 1: $(S,s)$ Inaction Overlay (Step 5)}
\label{sec:appA-ss}
% ~30 lines: discrete adjustment, T/s_min ≈ 0.024 inside band,
% orthogonality with Steps 1-4
```

### Phase 3 (v2) — Separate online appendix file (~1h)

**v2 신규:** `paper/en/online_appendix.tex` 별도 파일로 7개 subsection 작성.

**3a. 파일 구조 (`paper/en/online_appendix.tex`):**

```latex
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,booktabs}
\usepackage[round]{natbib}
\title{Online Appendix\\Public-Interest Direct Payment Scheme:\\Channel Derivations and Mapping Table}
\author{Lee, Dohyeon}
\date{}
\begin{document}
\maketitle

\renewcommand{\thesection}{A}  % Cross-reference parity with main.tex \appendix
\setcounter{section}{0}

\section{Channel Derivations (Online)}

This online appendix provides full derivations for the channels not covered
inline in the main paper (\citealp[Online Appendix to][]{Lee_PIDPS_2026}).

\subsection*{A.1 AHM Baseline: Proof of Separability (Step 0)}
\subsection*{A.2 Channel 3: Consumption Smoothing (Step 1)}
\subsection*{A.3 Channel 2: Precautionary Off-Farm Labor (Step 2)}
\subsection*{A.5 Channel 4(ii): Per-Farm Incidence (Step 3b)}
\subsection*{A.6 Channel 4(iii): Tenure-Mode Pivot (Step 4)}
\subsection*{A.8 Channel 5: Exit Deterrence (Supplementary)}
\subsection*{A.9 Summary: Reduced-Form-to-$\beta$ Mapping Table}

\bibliographystyle{econ}  % or aer.bst
\bibliography{../../Bibliography_base}
\end{document}
```

**3b. 본문 cross-reference 방식 (main.tex → online appendix):**

main.tex 의 §3.9 prediction table 의 "Reduced form" column 에는:
- Inline 항목: `Eq.~\ref{eq:dr-dT}` (Appendix A.4 inline)
- Online 항목: `Online App.~\S A.2, Eq.~(A.2.3)` (서지서식 형태)

**3c. 컴파일 분리:** main.tex 와 online_appendix.tex 가 각각 latexmk 로 별도 PDF 생성. Bibliography_base.bib 는 공유 (상위 디렉토리 경로 `../../Bibliography_base`).

### Phase 3 (v1, deprecated) — Appendix A 신설 (~1.5h)

**3a. Appendix A 구조 (paper/en/main.tex 의 `\bibliography` 직전에 삽입):**

```latex
% =============================================================================
\appendix
\section{Channel Derivations}
\label{sec:appA}
% =============================================================================

This appendix collects the formal derivations of the five channels in 
\S\ref{sec:theory}. Each subsection follows the same four-step chain: 
[1] structural setup, [2] FOC, [3] reduced-form $\partial y/\partial T$, 
[4] econometric mapping to the DiD-RD coefficient $\beta$.

\subsection{A.1 AHM Baseline: Proof of Separability (Step 0)}
\label{sec:appA-baseline}
% ~25 lines: full Lagrangian, FOC for {L_f, A, K} block independence from T
% Reference: Singh-Squire-Strauss 1986, Strauss 1986 ch. 2

\subsection{A.2 Channel 3 Derivation: Consumption Smoothing (Step 1)}
\label{sec:appA-bp}
% ~25 lines: Euler eq. with binding credit constraint μ > 0,
% MPC = 1 - β R · (1 + μ/λ); ∂C/∂T derivation
% Reference: Blundell-Pistaferri 2003

\subsection{A.3 Channel 2 Derivation: Precautionary Off-Farm Labor (Step 2)}
\label{sec:appA-sandmo}
% ~25 lines: stochastic Q = F(L_f) + ε; U'''(C) > 0 prudence; 
% ∂L_o/∂T < 0 via precautionary savings motive weakening
% Reference: Sandmo 1971, Kimball 1990

\subsection{A.4 Channel 4(i) Derivation: Bargaining Margin (Step 3a)}
\label{sec:appA-nash}
% ~30 lines: Nash bargaining + closed-form ∂r*/∂T (Phase 2 위 작성)
% Reference: Banerjee-Ghatak 2002 JPE 110(2):239-280

\subsection{A.5 Channel 4(ii) Derivation: Composition Margin + Per-Farm Incidence (Step 3b)}
\label{sec:appA-incidence}
% ~30 lines: Floyd-Alston-James + notch-contraction; ∂rent_cost/∂T < 0 
% under per-farm structure; per-hectare counterfactual ∂r/∂s > 0
% Reference: Floyd 1965, Alston-James 2002, Kirwan 2009, Baldoni-Ciaian 2023

\subsection{A.6 Channel 4(iii) Derivation: Tenure-Mode Pivot (Step 4)}
\label{sec:appA-tenure}
% ~30 lines: Carter-Olinto wealth-biased liquidity; threshold-crossing rule
% 1{W_i + T/(1-β) ≥ W_j*}; monotone gradient ∂²A_own/∂T∂τ ≥ 0
% Reference: Carter-Olinto 2003, Kazukauskas et al. 2013

\subsection{A.7 Channel 1 Derivation: $(S,s)$ Inaction (Step 5 Overlay)}
\label{sec:appA-ss}
% ~30 lines: discrete adjustment rule with fixed cost φ; inaction band 
% [s_low, s_high]; T/s_min ≈ 0.024 deeply inside band; orthogonality to 
% Steps 1-4 statement
% Reference: Caballero-Engel 1999, Abel-Eberly 1994, Cooper-Haltiwanger 2006, 
% Gardebroek-Oude Lansink 2004 (ERAE 31(1):39-59)

\subsection{A.8 Channel 5 Derivation: Exit Deterrence (Supplementary)}
\label{sec:appA-exit}
% ~25 lines: V_stay(T) vs V_exit; ∂V_stay/∂T = T/(1-β); per-farm vs 
% per-hectare retention discontinuity
% Reference: Kimhi 2000, Pietola-Vare-Oude Lansink 2003, Foltz 2004

\subsection{A.9 Summary: Reduced-Form-to-Econometric-$\beta$ Mapping Table}
\label{sec:appA-mapping}
% ~10 lines: Compact 9-row table mapping each {Step, ∂y/∂T expression, 
% Econometric β under take-up ρ, Sign}.
```

**총 Appendix A 분량: ~220-250줄 LaTeX (PDF에서 6-8 페이지).**

**3b. AJAE journal length 검토:**
AJAE 50p 제한은 본문 + Appendix 모두 포함. 현재 main text §3 ~5p + 다른 sections 합산 ~25p + bibliography 3p ≈ 33p. Appendix A 6-8p 추가 → 총 39-41p, 50p 한도 내. **Online appendix로 분리 옵션도 검토** (PDF 분리 시 main text 33p, online appendix 6-8p — referee 가독성 ↑).

**3c. Appendix 분리 결정 (recommendation):**
- **Inline (main.tex 내 \appendix)**: 단일 PDF, latexmk 1회 컴파일, 편집 용이
- **Separate (`paper/en/online_appendix.tex`)**: AJAE submission convention 더 부합, 단일 PDF 의 시각적 압박 회피, 단점은 cross-reference (`\ref{eq:dr-dT}`) 복잡

**권장: Inline 우선 (\appendix), 제출 직전 separate 로 분리 가능.** 본 plan은 inline 으로 작성.

### Phase 4 (v2) — DEPRECATED. 4a (bib +9 entries + 3 correction) 는 stop 전 완료. 4c (Korean parity) 제거. 

별도 future plan으로 paper/ko 일괄 sync 처리.

---

### Phase 4 (v1, archived for reference) — Bibliography correction + Korean translation parity (~30분)

**4a. Citation correction (`Bibliography_base.bib`):**

| 현 entry | 정정 사항 |
|---------|----------|
| GardebroekOudeLansink (현 bib에 있다면) | journal: ERAE 31(1):39-59, DOI 10.1093/erae/31.1.39 |
| Kazukauskas2014_decoup | year/coverage: 2013 AJAE 95(5):1068-1087 (Ireland, Denmark, Netherlands) |
| BaldoniCiaian2023_eucap | 저자 순서 확인 (Baldoni first, not Ciaian-Espinosa-Paloma-Baldoni) |

**4b. 신규 entry 추가 (Appendix A 인용 충당):**
- Banerjee-Gertler-Ghatak 2002 JPE 110(2):239-280 — Step 3a Nash
- Floyd 1965 JPE 73(2):148-158 — Step 3b incidence
- Alston-James 2002 Handbook ch. 33 — Step 3b incidence
- Carter-Olinto 2003 AJAE 85(1):173-186 — Step 4 liquidity
- Kimball 1990 Econometrica — Step 2 prudence
- Cooper-Haltiwanger 2006 RES 73(3):611-633 — Step 5 calibration
- Khan-Thomas 2008 Econometrica 76(2):395-436 — Step 5 overlay framing
- Abel-Eberly 1994 AER 84(5):1369-1384 — Step 5 bridge

**총 신규 8개 entry, 정정 3개 entry.** lit-review agent 결과의 BibTeX block 직접 paste.

**4c. paper/ko/main.tex 병행 수정:**
영어 main.tex 의 Phase 1-3 변경사항을 한국어 번역 → paper/ko/main.tex 동일 위치에 적용. Appendix A 도 한국어 mirror (`\section{부록 A. 채널별 도출}`).

용어 일관성 (precision-rewrite plan의 glossary 준수):
- separability theorem → 분리성 정리
- Nash bargaining → 내쉬 협상
- (S,s) inaction region → (S,s) 비활동 영역
- per-farm flat-rate → 농가별 정액제
- reduced form → 축약형
- nested relaxation → 중첩 완화
- comparative statics → 비교정태

### Phase 4 (v2 renumbered, was Phase 5) — Compile + verify + session log (~30분)

**4a. Recompile paper/en only:**
```bash
cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex 2>&1 | tail -20
cd paper/en && latexmk -xelatex -interaction=nonstopmode online_appendix.tex 2>&1 | tail -20
# paper/ko 는 손대지 않음 — CLAUDE.md "Never simultaneous bilingual edits"
```

**5b. Verification (commands):**
```bash
# 1. Both PDFs exist
test -f paper/en/main.pdf && test -f paper/ko/main.pdf && echo "PDFs OK"

# 2. Page count
pdfinfo paper/en/main.pdf | grep Pages    # Expect: 20-30 pages
pdfinfo paper/ko/main.pdf | grep Pages    # Expect: 19-29 pages

# 3. Zero undefined citations / references
grep -c "Undefined" paper/en/main.log paper/ko/main.log    # Expect: 0 0
grep -c "undefined" paper/en/main.log paper/ko/main.log    # Expect: 0 0

# 4. New Appendix subsections present
grep -c "^\\\\subsection.*A\\." paper/en/main.tex            # Expect: ≥ 9 (A.1-A.9)
grep -c "^\\\\subsection.*A\\." paper/ko/main.tex            # Expect: ≥ 9 (mirror)

# 5. Reduced-form-to-β mapping table present in §3
grep -c "Reduced form" paper/en/main.tex                     # Expect: ≥ 1
grep -c "buildup\|build-up" paper/en/main.tex                # Expect: ≥ 1

# 6. Bib entry count
grep -c "^@" Bibliography_base.bib                            # Expect: 20 (12 + 8 new)

# 7. Citation corrections applied
grep -A2 "GardebroekOudeLansink" Bibliography_base.bib | grep "ERAE\|10.1093/erae/31"
grep -A2 "Kazukauskas2014\|Kazukauskas2013" Bibliography_base.bib | grep "1068"

# 8. Quality gate
python3 scripts/quality_score.py paper/en/main.tex   # Threshold: 80
# Document any false-positive overrides per [LEARN:tooling] 2026-05-14
```

**5c. Session log:**
- Phase별 완료 시각 + diff line count
- Phase 4 citation 정정 사항
- Phase 5 PDF page count + quality score
- Open questions (있다면)

**5d. NO auto-commit.** 사용자가 별도로 `/commit` 호출.

---

## Decision gate after this plan (post-execution)

1. Dohyeon이 PDF 검토 (paper/en/main.pdf + paper/ko/main.pdf, §3 + Appendix A 모두)
2. 다음 step 결정:
   - **(A) §1 Introduction draft 진행** (precision-rewrite plan에서 다음 step로 예정)
   - **(B) §3 Appendix A 추가 정련** (특정 derivation 더 깊이 / Online appendix 분리)
   - **(C) Channel 4(ii) 의 notch-contraction mechanism (Capitalization agent 보고) 을 본문 §3.7 에 추가**
   - **(D) Online appendix 로 분리** (별도 PDF online_appendix_en.pdf 생성)

---

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| Appendix A 추가로 본문 50p 초과 | Medium | Online appendix 분리 fallback (5d Decision (D)) |
| Citation 정정 시 `\cite{KEY}` 키 변경 → 본문 broken reference | Medium | bib key는 보존, 내부 fields만 수정. 새 entry만 새 키 부여 |
| `\appendix` 안에서 `\section` 사용 시 번호 매김 충돌 | Low | LaTeX 표준 `\appendix` 동작 — main `\section` 은 Arabic, appendix `\section` 은 alphabetic (A, B...). 검증 필요 |
| Korean translation drift from English §3 (label 변경 부분) | Medium | Phase 1c, 1d 의 English 변경 사항을 Phase 4c 에서 직역 — 독립 의역 금지 |
| Quality gate false positives on paper/en/*.tex (LaTeX `\\command` 패턴) | High | Override per MEMORY `[LEARN:tooling]` 2026-05-14 precedent. Commit body에 사유 문서화 |
| Build-up 표 (1a) 와 prediction 표 (1c) 의 정보 중복 | Medium | 1a 는 *논리적 순서* (Step 0-5), 1c 는 *결과 요약* (sign + empirical fit). Cross-reference 명시 |
| Phase 2 Nash derivation 의 quasi-linearity 가정이 §3.7 본문 form 과 미세 불일치 | Low | Appendix A.4 에 "quasi-linear 가정 하" 명시; 본문 §3.7 의 일반 form 보존 |

---

## Approval gate

On ExitPlanMode approval:
1. Plan 파일 sister copy (`quality_reports/plans/2026-05-15_section3-chain-restructure-appendix-a.md`) 생성
2. Session log 생성 + initial entry
3. Task 1 → Phase 1 실행 시 in_progress (이미 in_progress)
4. Phase 1-5 순차 실행 (각 phase 완료 시 session log update)
5. NO auto-commit (manual approval mode)

**Total wall-clock estimate: ~3.5h** (Phase 1 ~1h + Phase 2 ~45min + Phase 3 ~1.5h + Phase 4 ~30min + Phase 5 ~30min + session log ~15min).

---

## Why this approach (vs alternatives considered)

**Considered alternative A:** §3 wholesale rewrite to nested-relaxation order (§3.4 → Step 1, §3.5 → Step 2 등).
**Rejected because:** PR #4 가 오늘 §3 precision rewrite 를 끝낸 직후 — wholesale rewrite 는 sunk effort 폐기 + reference label 무더기 변경 위험. **현 plan 은 prose 80% 보존 + 상위 build-up logic 만 추가**.

**Considered alternative B:** Appendix A 를 별도 파일 `paper/en/appendix_a.tex` 로 분리.
**Rejected because:** AJAE submission 전까지 inline 이 cross-reference 가장 안정. 분리는 Phase 5 후 별도 decision gate (D) 에서.

**Considered alternative C:** Step 2 (Nash bargaining derivation) 을 본문 §3.7 prose 로 확장.
**Rejected because:** AJAE 본문 ≤50p 제한 + reader-first ordering (sign prediction 먼저, derivation 은 appendix). Appendix A.4 가 표준.
