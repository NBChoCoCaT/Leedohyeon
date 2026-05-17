# Plan — §3 α3 Implementation (S1 + D2 + Separate Online Appendix)

**Status:** DRAFT (awaiting Dohyeon approval, 2026-05-18)
**Mode:** Manual approval, plan-first; user invokes `/commit` after implementation
**Supersedes:** `quality_reports/plans/2026-05-15_section3-chain-restructure-appendix-a.md` (5-channel + Step-k build-up + Nash bargaining inline) — wholesale replacement, not patch.

**Decision provenance:**
- `quality_reports/research_spec_ahm-extension-pidps.md` (research spec, CoVe-verified)
- `quality_reports/decisions/2026-05-18_theoretical-scope.md` (ADR-0001 — α-strict + Combo α3 + B.1)
- `quality_reports/decisions/2026-05-18_outcome-hierarchy.md` (ADR-0002 — `area_own` primary #1)
- `quality_reports/decisions/2026-05-18_section3-structure.md` (ADR-0003 — S1 + D2 + separate online appendix)

---

## Context

§3 was rewritten 2026-05-15 (PR #3 bootstrap + PR #4 precision rewrite) to a 5-channel framework (S,s + Sandmo + BP + Tenant-Driven + Exit). On 2026-05-15 evening, plan `...chain-restructure-appendix-a.md` proposed extending it with a Five-Step Build-Up + Appendix A. Work stopped at Phase 1 in_progress (only `Bibliography_base.bib` +9 entries committed locally).

On 2026-05-18, the user invoked `/interview-me` and **reframed the entire theoretical core** to a single AHM-extension backbone with two non-separabilities (wealth-biased liquidity + supervision-cost labor), under the α-strict scope (Singh-Squire-Strauss 1986 / dJFS 1991 lineage only). The empirical headline shifts from `rent_cost` capitalization reversal to AHM **separability rejection** via `area_own` monotone gradient.

**This plan implements that reframing in `paper/en/main.tex` + new `paper/en/online_appendix.tex`. `paper/ko/main.tex` is untouched (CLAUDE.md rule).**

---

## Critical files to modify

| Path | Action | Phase | 변경 분량 (대략) |
|------|--------|-------|------------------|
| `Bibliography_base.bib` | EDIT (5 new entries + 1 paragraph comments demoting α3-out entries) | 1, 2 | +50줄 |
| `paper/en/main.tex` §3 (lines ~54–335) | DELETE existing §3.2–§3.11 + WRITE new §3.1–§3.4 | 3 | −280줄 / +120줄 (net −160줄) |
| `paper/en/main.tex` preamble | ADD `\usepackage{xr-hyper}` + `\externaldocument{online_appendix}` | 3 (small) | +3줄 |
| `paper/en/online_appendix.tex` | CREATE (new standalone document) | 4 | +200줄 |
| `quality_reports/session_logs/2026-05-15_section3-chain-restructure.md` | APPEND (Phase 1-5 progress log) | continuous | incremental |
| Output: `paper/en/main.pdf`, `paper/en/online_appendix.pdf` | RECOMPILE | 5 | binary |

**Reusable infrastructure (직접 참조):**
- `paper/en/main.tex:54–335` — existing §3 5-channel block (delete after content extraction)
- `paper/en/main.tex:90–122` — §3.2 baseline AHM block (Lagrangian + FOCs) — **partially reusable** as scaffolding for new §3.1
- `Bibliography_base.bib` — 21 entries (12 PR #3 + 9 2026-05-15-stop). 5 α3 entries to add. Banerjee-Ghatak / Khan-Thomas / Sandmo / Kimball / Caballero-Engel / Blundell-Pistaferri 6개는 **물리적으로 삭제하지 않음** — §3에서 cite하지 않을 뿐, §6 Discussion / §1 lit review에서 한 줄 인용 가능성 보존.

---

## Implementation: 5 phases, ~4–4.5h wall-clock

### Phase 1 — Bibliography: 5 new α3 entries (~20분)

CoVe-PASS metadata 그대로 사용. 추가 위치는 `Bibliography_base.bib` 끝, 기존 21개 entries 직후. 각 entry는 위 spec의 verification table 출처대로 keys 부여:

```bibtex
@article{EswaranKotwal1986_supervision,
  author  = {Eswaran, Mukesh and Kotwal, Ashok},
  title   = {Access to Capital and Agrarian Production Organisation},
  journal = {Economic Journal},
  volume  = {96},
  number  = {382},
  pages   = {482--498},
  year    = {1986},
}

@article{Benjamin1992_separation,
  author  = {Benjamin, Dwayne},
  title   = {Household Composition, Labor Markets, and Labor Demand: Testing for Separation in Agricultural Household Models},
  journal = {Econometrica},
  volume  = {60},
  number  = {2},
  pages   = {287--322},
  year    = {1992},
  doi     = {10.2307/2951598},
}

@article{LaFaveThomas2016_markets,
  author  = {LaFave, Daniel and Thomas, Duncan},
  title   = {Farms, Families, and Markets: New Evidence on Completeness of Markets in Agricultural Settings},
  journal = {Econometrica},
  volume  = {84},
  number  = {5},
  pages   = {1917--1960},
  year    = {2016},
  doi     = {10.3982/ECTA12987},
}

@article{PittKhandker1998_credit,
  author  = {Pitt, Mark M. and Khandker, Shahidur R.},
  title   = {The Impact of Group-Based Credit Programs on Poor Households in {B}angladesh: Does the Gender of Participants Matter?},
  journal = {Journal of Political Economy},
  volume  = {106},
  number  = {5},
  pages   = {958--996},
  year    = {1998},
  doi     = {10.1086/250037},
}

@article{FosterRosenzweig1995_learning,
  author  = {Foster, Andrew D. and Rosenzweig, Mark R.},
  title   = {Learning by Doing and Learning from Others: Human Capital and Technical Change in Agriculture},
  journal = {Journal of Political Economy},
  volume  = {103},
  number  = {6},
  pages   = {1176--1209},
  year    = {1995},
}
```

**Phase 1 verify:** `grep -c "^@" Bibliography_base.bib` → expect 26 (21 + 5).

### Phase 2 — Bibliography cleanup: in-bib annotations for α3-out entries (~10분)

**No physical deletions.** 다음 6 entries는 keys 그대로 보존하되, §3 cite-list에서 제외:

- `BanerjeeGertlerGhatak2002_tenancy` — α 정의 밖 (contract theory). §3 cite 없음. §6 Discussion에서 "alternative tenancy-contract framework" 한 줄 cite 가능.
- `KhanThomas2008_idiosyncratic` — macro lumpy investment (α 정의 밖). §3 cite 없음.
- `Sandmo1971_uncertainty`, `Kimball1990_prudence` — risk/prudence (α 정의 밖). §3 cite 없음.
- `CaballeroEngel1999_lumpy` — α 정의 밖, **단 §3.2 안에서 한 줄 한정 사용 가능**: Carter-Olinto의 credit-constrained capital FOC를 inaction band 언어로 reinterpret 할 때 footnote 인용 ("This adjustment threshold logic parallels the (S,s) inaction band of Caballero-Engel 1999 cast within an AHM-internal credit constraint.").
- `BlundellPistaferri2003_consumption` — α3는 consumption smoothing 채널을 다루지 않음. §3 cite 없음.
- `Kazukauskas2014_decoup` (productivity paper, AgEcon 45) — **distinct from** Kazukauskas2013_disinvestment which IS α3 primary. §3는 2013 paper만 cite. 2014 paper는 §6 robustness 또는 lit review에서 한 줄 가능.

각 entry 위에 한 줄 LaTeX comment 추가하여 §3 cite-exclusion 기록:

```bibtex
% α3 framework (2026-05-18): not cited in §3 main theory. Available for §1/§6 lit reference.
@article{BanerjeeGertlerGhatak2002_tenancy, ...
```

Phase 2 verify: `grep -B0 -A0 "α3 framework" Bibliography_base.bib | wc -l` ≈ 6.

### Phase 3 — §3 wholesale rewrite (~2h)

**3a. Backup current §3 to plan repository (file-system level, not git):**
```bash
# Extract existing §3.2-§3.11 to a reference snippet before deletion
sed -n '54,335p' paper/en/main.tex > quality_reports/specs/2026-05-18_section3-pre-alpha3-snapshot.tex
```
This preserves the PR #4 prose for §6 Discussion harvest later (any sentence worth recycling).

**3b. Delete existing §3 (lines 54–335 of `paper/en/main.tex`):**
Remove `\section{Theoretical Framework}` block through `\subsection{Limitations of the Theoretical Structure}` end. Keep §4 onward (Data, Identification, Results, ...) intact.

**3c. Write new §3.1 — Baseline AHM and the Separability Null (~45줄, ~1p):**

Content outline:
- One-sentence opening: this section presents an AHM-extension theory + falsification predictions.
- **C2 contribution statement** (paragraph 1):
  > "We test the Singh-Squire-Strauss (1986) Agricultural Household Model separability null by exploiting Korea's 0.5 ha eligibility cutoff for the per-farm flat-rate Public-Interest Direct Payment Scheme (PIDPS) Small-Farmer Flat Payment (SFFP). Two AHM extensions — wealth-biased liquidity (Carter-Olinto 2003) and implicit-labor supervision (Eswaran-Kotwal 1986) — yield independent margins through which separability fails. We reject AHM separability for Korean small farms."
- Setup: HH maximization U(C, ℓ_h, ℓ_f) s.t. budget, technology, market constraints.
- Separability theorem statement (one equation, one paragraph): under complete markets, ∂(production decisions)/∂(preference parameters) = 0.
- The null: ∂(y_p)/∂T = 0 for all production outcomes y_p, where T = SFFP subsidy.
- Cite: SSS 1986, dJFS 1991, Benjamin 1992, LaFave-Thomas 2016. (4 cites)

**3d. Write new §3.2 — Wealth-Biased Liquidity Relaxation (~80줄, ~1.5p):**

Content outline:
- Relax credit-market completeness: credit access function ρ(W) of household wealth W, with ρ'(W) > 0 (wealth-bias).
- Asset-threshold rule for tenure-mode pivot: household owns land iff W ≥ W*(prices, productivity); otherwise rents.
- Subsidy T enters disposable wealth: W → W + T/(1−β) for SFFP-eligible households.
- **Closed-form 1** (main-text equation, derivation in Online Appendix §B.1):
  ∂(area_own_i)/∂T > 0 for households near W*, monotone in (1 − own_share_i).
- **Closed-form 2** (monotone gradient, the empirical signature):
  ∂²(area_own_i) / ∂T ∂(1 − own_share_i) > 0.
- **Closed-form 3** (capital adjustment): ∂(op_cost_ex_rent)/∂T sign depends on whether T crosses an adjustment threshold τ. Under credit-constrained capital FOC, if T/τ < 1, ∂(op_cost_ex_rent)/∂T ≤ 0 (no investment adjustment). Footnote: "This adjustment threshold logic parallels the (S,s) inaction band of [@CaballeroEngel1999_lumpy] cast within an AHM-internal credit constraint."
- Cite: Carter-Olinto 2003 (primary), Kazukauskas 2013 (decoupled-subsidy disinvestment precedent), Pitt-Khandker 1998 (credit-access cutoff precedent), Foster-Rosenzweig 1995 (credit-investment in agricultural HH precedent), Caballero-Engel 1999 (footnote only). (5 cites, 1 in footnote.)

**3e. Write new §3.3 — Implicit Labor with Supervision (~50줄, ~0.7p):**

Content outline:
- Relax labor-market completeness: hired labor requires costly supervision (monitoring cost m per hour of hired labor).
- Shadow wage of family labor w_f differs from market wage w_m by the supervision wedge: w_f = w_m + m if family labor is the marginal type.
- Subsidy T relaxes the farm budget → induces reallocation across family/hired labor margins → spillover to off-farm labor supply.
- **Closed-form 4** (main-text equation, derivation in Online Appendix §B.2):
  ∂(off_farm_income_i)/∂T ≠ 0 under non-separability, with sign determined by ∂(shadow wage wedge)/∂T.
- This is **auxiliary** — its rejection (F2 from the spec) would weaken but not collapse the contribution.
- Cite: Eswaran-Kotwal 1986 (primary auxiliary), Benjamin 1992 (separability test on labor margin). (2 cites.)

**3f. Write new §3.4 — Unified Predictions Table + Equilibrium Rent Caveat (~80줄, ~1p):**

Unified prediction table (5 rows):

```latex
\begin{table}[ht]
\centering
\caption{Unified predictions of the AHM extensions and their econometric counterparts.}
\label{tab:alpha3-predictions}
\small
\begin{tabular}{p{2.0cm} p{2.4cm} p{2.6cm} p{2.0cm} p{2.4cm}}
\toprule
Channel & Outcome & Reduced form & Econometric $\beta$ & Source \\
\midrule
Liquidity (primary) & area\_own & $\partial / \partial T > 0$ & $\beta_1$ (DiD-RD) & Carter-Olinto 2003 \\
Liquidity heterogeneity & area\_own $\times$ (1-own\_share) & $\partial^2 / \partial T \partial(1-\text{own\_share}) > 0$ & $\beta_2$ (interaction) & Carter-Olinto 2003 \\
Capital adjustment & op\_cost\_ex\_rent & $\partial / \partial T \le 0$ if $T/\tau < 1$ & $\beta_3$ (DiD-RD) & Kazukauskas 2013 \\
Labor (auxiliary) & off\_farm\_income & $\partial / \partial T \ne 0$ under non-separability & $\beta_4$ (DiD-RD) & Eswaran-Kotwal 1986 \\
\midrule
\multicolumn{5}{l}{\textit{Ex-theory (B.1) — aggregate-equilibrium implication, not model-internal}} \\
Incidence (ex-theory) & unit\_rent\_price & Aggregate-rent response under reduced rental demand & $\beta_5$ (DiD-RD) & Floyd 1965; Alston-James 2002 \\
\bottomrule
\end{tabular}
\end{table}
```

**Falsification statement (§3.4 closing paragraph):**

> "We pre-register two falsification predictions consistent with our framework. **F1:** If the $\beta_2$ interaction is statistically indistinguishable from zero, or if pure owner-operators (own\_share = 1) exhibit the same $\beta_1$ as pure tenants, the wealth-biased liquidity mechanism (Carter-Olinto) is rejected — we would reframe as a universal income effect under separability and abandon the wealth-bias hypothesis. **F2:** If $\beta_4$ is statistically zero across bandwidths, the supervision-cost mechanism (Eswaran-Kotwal) is rejected; the wealth-biased liquidity primary channel survives but the contribution narrows to a single margin. **F1 + F2 jointly** would imply we cannot reject the AHM separability null, and the paper repositions as a precise null estimate in a developed-country setting."

**Equilibrium rent caveat (§3.4 closing):**

> "The observed $\hat\beta_5$ on unit\_rent\_price (P3b-2: $\beta_5 \in [-130, -48]$ KRW/$\mathrm{m}^2$) is consistent with — but not derived from — our AHM-extension model. The micro-prediction (rented-area contraction at the household level, an implication of $\beta_1$ via the substitution from rented to owned land in $\partial(\text{area\_own})/\partial T > 0$) aggregates into a reduced rental-demand schedule, which standard incidence theory [@Floyd1965_incidence; @AlstonJames2002_incidence] maps to a negative equilibrium-rent response. We report $\hat\beta_5$ as reduced-form evidence consistent with the model's empirical footprint, not as a primary theoretical contribution."

**3g. Add `\usepackage{xr-hyper}` + `\externaldocument{online_appendix}` to `paper/en/main.tex` preamble** (just before `\begin{document}`). This enables `\ref{eq:B1-3}` etc. to resolve cross-references into the online appendix PDF.

### Phase 4 — Online appendix file (`paper/en/online_appendix.tex`) (~1.5h)

**4a. Create new standalone document:**

```latex
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,booktabs,microtype}
\usepackage[round,sectionbib]{natbib}
\usepackage{xr-hyper}
\usepackage{hyperref}

\externaldocument{main}

\title{Online Appendix\\
  Wealth-Biased Liquidity, Tenure-Mode Pivot, and the Separability Null:\\
  An AHM-Extension Test Using Korea's 0.5 ha Subsidy Cutoff}
\author{Lee, Dohyeon}
\date{}

\begin{document}
\maketitle

% B.1, B.2, B.3 subsections — content per 4b, 4c, 4d below

\bibliographystyle{aer}   % or chicago/econ as match with main.tex
\bibliography{../../Bibliography_base}
\end{document}
```

**4b. §B.1 Wealth-Biased Liquidity: Lagrangian, FOC, Comparative Statics (~80줄):**
- Full HH Lagrangian with credit-constraint multiplier μ(W).
- FOCs for {C, ℓ_f, A_own}.
- Asset-threshold derivation: W*(prices) such that own-land buyer's indifference condition holds.
- Comparative statics:
  - Step 1: ∂W*/∂T < 0 (subsidy lowers the asset threshold).
  - Step 2: ∂(area_own)/∂T = −φ(W*) · ∂W*/∂T > 0 where φ(W*) is the density of HH wealth at the threshold.
  - Step 3: ∂²(area_own)/∂T∂(1−own_share) > 0 by the wealth-bias slope of ρ(W).
  - Step 4: Capital FOC under credit constraint → adjustment threshold τ; ∂(op_cost_ex_rent)/∂T ≤ 0 if T/τ < 1 (no investment crossing).
- Sufficient conditions block (4 conditions): wealth-bias ρ'>0, threshold uniqueness, participation slack, T < τ.
- Cite: Carter-Olinto 2003, Kazukauskas 2013, Pitt-Khandker 1998.

**4c. §B.2 Supervision: Lagrangian, FOC, Comparative Statics (~60줄):**
- HH labor allocation Lagrangian with supervision cost m per hour of hired labor.
- FOCs for {ℓ_f^own, ℓ_h, ℓ_f^off}.
- Shadow-wage divergence: w_f ≠ w_m when ℓ_h > 0 and m > 0.
- Comparative statics:
  - Step 1: ∂(shadow wage wedge)/∂T derivation under HH budget constraint.
  - Step 2: ∂(off_farm_income)/∂T sign determination as function of supervision-cost wedge.
- Sufficient conditions block.
- Cite: Eswaran-Kotwal 1986, Benjamin 1992.

**4d. §B.3 Reduced-Form-to-Econometric-β Mapping Table (~30줄):**
- 5-row table identical structure to main §3.4 Table \ref{tab:alpha3-predictions} but with **expanded** columns: (Channel | Outcome | Theoretical sign | Econometric β | Empirical fit from P3b-2 | Falsification trigger).
- Empirical fit column references P3b-2 magnitudes (T1/T2/T3 bandwidths, p-values).
- Falsification trigger column lists the specific data pattern that would reject each channel.

**4e. Cross-reference convention:**
- main.tex internal refs: `\ref{eq:CO-2}` for closed-form equations in §3.2 → resolves locally.
- main.tex pointing to online: `[Online Appendix §B.1, Eq.~(B.1.4)]` as plain prose; if `xr-hyper` works, then `\ref{eq:B1-4}` resolves automatically across documents.
- online_appendix.tex pointing back: `[Main text §3.2, Eq.~(\ref{eq:CO-2})]`.

### Phase 5 — Compile + verify (~30분)

```bash
cd paper/en

# Two-pass for xr-hyper cross-reference resolution
latexmk -xelatex -interaction=nonstopmode main.tex 2>&1 | tail -30
latexmk -xelatex -interaction=nonstopmode online_appendix.tex 2>&1 | tail -30
latexmk -xelatex -interaction=nonstopmode main.tex 2>&1 | tail -30   # second pass to pick up online_appendix.aux

# paper/ko NOT compiled — CLAUDE.md rule
```

**Verification commands:**

```bash
# 1. Both PDFs exist
test -f paper/en/main.pdf && test -f paper/en/online_appendix.pdf && echo "PDFs OK"

# 2. Page counts
pdfinfo paper/en/main.pdf | grep Pages              # Expect 20-32p (down from 30+ if old §3 was bulky)
pdfinfo paper/en/online_appendix.pdf | grep Pages   # Expect 6-10p

# 3. Zero broken cross-references
grep -E "Undefined|undefined" paper/en/main.log paper/en/online_appendix.log
# Expect: 0 lines (or only false positives — document in session log if any)

# 4. New §3 subsections present (exactly 4, not 11)
grep -cE "^\\\\subsection" paper/en/main.tex
# Expect: 4 (was 11)

# 5. Falsification statement present
grep -c "pre-register" paper/en/main.tex   # Expect ≥ 1
grep -c "F1\|F2" paper/en/main.tex         # Expect ≥ 4 (used in §3.4 + maybe §4)

# 6. C2 contribution statement present in §3.1 opening
grep -c "reject AHM separability" paper/en/main.tex   # Expect ≥ 1

# 7. B.1 ex-theory disclosure present
grep -c "Ex-theory\|aggregate-equilibrium implication" paper/en/main.tex   # Expect ≥ 1

# 8. Bib entry count
grep -c "^@" Bibliography_base.bib   # Expect 26 (21 + 5)

# 9. New α3 cites resolved in main.tex
grep -E "EswaranKotwal1986|Benjamin1992|LaFaveThomas2016|PittKhandker1998|FosterRosenzweig1995|CarterOlinto2003|Kazukauskas2013" paper/en/main.tex | wc -l
# Expect: ≥ 10 cite invocations across §3.1-§3.4

# 10. Banned-from-§3 keys NOT cited in §3 block (lines 54-200 approximate)
sed -n '/\\section{Theoretical Framework}/,/\\section{Data}/p' paper/en/main.tex | grep -cE "Sandmo1971|Kimball1990|BlundellPistaferri2003|BanerjeeGertlerGhatak2002|KhanThomas2008"
# Expect: 0  (CaballeroEngel1999 allowed in §3.2 footnote — handle separately)

# 11. CaballeroEngel1999 cited exactly once (the §3.2 footnote)
sed -n '/\\section{Theoretical Framework}/,/\\section{Data}/p' paper/en/main.tex | grep -c "CaballeroEngel1999"
# Expect: 1

# 12. Quality score
python3 scripts/quality_score.py paper/en/main.tex   # Threshold 80
# Document any false-positive overrides per [LEARN:tooling] 2026-05-14 precedent
```

**5b. paper/ko/main.tex 손대지 않음** — `git diff paper/ko/main.tex` 결과 빈 출력 확인.

### Phase 6 — Session log + decision gate (~15분, integrated into all phases)

각 phase 종료 직후 `quality_reports/session_logs/2026-05-15_section3-chain-restructure.md` 에 1-3줄 append. Phase 별 wall-clock + diff line count + 발견된 문제. 5d → NO auto-commit; 사용자가 별도 `/commit` 호출.

---

## Decision gates after this plan (post-execution)

1. **Dohyeon이 PDF 검토** (paper/en/main.pdf + paper/en/online_appendix.pdf). §3 4-subsection structure가 reader-friendly한지, 수식 quality, 부록과의 cross-reference 정합성.

2. **다음 step 결정 (5개 옵션):**
   - **(A) §1 Abstract + Introduction rewrite** — C2 contribution + primary outcome `area_own` 반영. **권장.** 다음 자연 plan.
   - **(B) §5 Results 재정렬** — area_own → op_cost → off_farm → unit_rent 순. ADR-0002 enforcement.
   - **(C) paper/ko re-sync** — paper/en 전체 (§1 + §3 + §5) stabilization 후 별도 plan. CLAUDE.md.
   - **(D) Falsification 사전등록 (pre-registration)** — F1/F2 를 AEA RCT 또는 OSF에 timestamp. `/preregister --style aea-rct` 활용 가능.
   - **(E) `/review-paper --peer ajae`** — α3 §3 + 신규 abstract/intro 가 AJAE editor 수용 가능한지 simulated peer review.

---

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| `\externaldocument` xr-hyper 호환성 — XeLaTeX + biber/bibtex 조합에서 가끔 cross-ref 실패 | Medium | 2-pass 컴파일 + 단일 pdftk 통합 옵션. 실패 시 fallback = `[Online Appendix §B.1]` 평문 prose. |
| §3.2 Closed-form 도출 (`∂²/∂T∂(1-own\_share) > 0`)에 추가 가정이 숨어있을 가능성 (Carter-Olinto 2003 본문은 cross-section 환경, panel 적용에 monotonicity는 자동 follow는 아님) | High | Online Appendix §B.1 의 sufficient conditions block에서 "(i) wealth density φ(W*) >0 in the eligibility window; (ii) ρ'(W) bounded; (iii) panel stationarity of W relative to T" 명시. §3.2 footnote에서 cross-section → panel 외삽 caveat 한 줄. |
| §3.3 Eswaran-Kotwal supervision cost 부호 (∂(off-farm)/∂T) — 이론적으로 ≠ 0 만 보장, 양/음 ex ante 미정 — referee 가 "weak prediction" 라 critique 가능 | Medium | §3.3 closing에 "This is **auxiliary**: rejection of F2 weakens but does not collapse the contribution; the primary H1 (`area_own` gradient) survives F2 independently." 명시. ADR-0002의 outcome hierarchy 일관. |
| Quality-gate score < 80 (LaTeX `\\command` 패턴이 false positive 점수 깎기) | Medium-High | MEMORY `[LEARN:tooling]` 2026-05-14 precedent 적용. Commit body에 사유 + override 문서화. |
| `Bibliography_base.bib` α3-out 6 entries comment 안 한 채 PR 머지되면 미래에 §3 cite 다시 들어갈 위험 (오용) | Low-Medium | Phase 2 의 in-bib LaTeX comment ("α3 framework: not cited in §3") 가 인적 reviewer 시 visible flag 역할. |
| paper/ko §3 drift (paper/en α3 reframing 후 paper/ko는 옛 5-channel) | High (intentional) | CLAUDE.md "Never simultaneous bilingual edits". Decision gate (C) 가 future plan으로 처리. 본 plan scope 외. |
| PR #4 의 §3 prose (precision rewrite 결과) 폐기 — 노력 낭비 우려 | Medium | Phase 3a의 snapshot이 §6 Discussion harvest 자원 보존. PR #4 자체는 commit history에 그대로 남음. |
| §3 rewrite 도중 §3 numbering 변경으로 §4 onwards의 cross-ref (e.g., `\ref{sec:theory}`) 깨짐 | Low | label은 보존 (`\label{sec:theory}` → §3.1로 이전). `\ref` 명령 변경 없음. Phase 5의 Undefined references check이 catch. |

---

## Approval gate

Plan 승인 시:
1. ExitPlanMode → 실행 시작
2. 세션 로그 (`...chain-restructure.md`) 에 "Phase 1 (α3) start" 입력
3. Phase 1 → 5 순차 실행 (각 phase 완료마다 session log append)
4. **NO auto-commit** — manual approval mode 유지
5. Phase 5 verification 결과 보고 → 사용자가 `/commit` 호출 결정

**Wall-clock estimate (v2 → v3):**
- Phase 1 (~20min) + Phase 2 (~10min) + Phase 3 (~2h) + Phase 4 (~1.5h) + Phase 5 (~30min) = **~4.5h**.

승인 부탁드립니다.

---

## Why this approach (vs alternatives considered)

**Alternative 1:** §3 patch (기존 5-channel 라벨만 α3 용어로 바꾸기).
**Rejected:** ADR-0001/0002/0003의 theoretical-empirical coherence 요구를 만족 못함. 5-channel 구조 자체가 α3 backbone과 부정합.

**Alternative 2:** §3 + §6 동시 rewrite.
**Rejected:** Plan scope 폭증. §6 Discussion은 §3 + 신규 abstract/intro 안정화 이후 별도 plan이 깨끗.

**Alternative 3:** Inline `\appendix` (이전 plan v1 옵션).
**Rejected:** ADR-0003에서 separate online appendix 결정 확정. AJAE submission convention.

**Alternative 4:** §3 rewrite 전 §1 Introduction을 먼저 (top-down).
**Rejected:** §1은 §3의 contribution one-liner를 abstract+intro로 풀어쓰는 작업이라, §3가 단단해진 후 진행하는 게 자연스러움. 본 plan 종료 후 decision gate (A)로 처리.
