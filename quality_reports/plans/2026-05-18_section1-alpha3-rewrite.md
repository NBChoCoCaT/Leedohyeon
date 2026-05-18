---
status: APPROVED (Dohyeon 2026-05-18; D1=T1, D2=general, D3=6¶/~1,400w, D4=Zimmert-Zorn cite, D5=+D14 JEL, D6=sequential)
mode: Manual approval, plan-first
session_type: Single-session §1 Abstract + Introduction α3 rewrite (Option A)
estimated_time: 4–6h
scope: paper/en/main.tex Title + Abstract + §1 Introduction ONLY; paper/ko untouched (CLAUDE.md rule)
inputs:
  - quality_reports/peer_review_section3_alpha3/SUMMARY.md
  - quality_reports/peer_review_section3_alpha3/editorial_decision.md (Top 3 concerns + 10 ADDRESSABLE)
  - master_supporting_docs/own_drafts/초안.md (Korean v1, PRE-α3 — institutional + structural bootstrap only)
  - paper/en/main.tex §3 (α3 framework already merged in c2192e5)
  - paper/en/online_appendix.tex §B.1-B.3
predecessor: PR #5 (4e1f56b) + §3 alpha test (peer_review_section3_alpha3/) — 2026-05-18
---

# Plan — §1 Abstract + Introduction α3 Rewrite

## Goal

Wholesale rewrite of Title + Abstract + §1 Introduction in `paper/en/main.tex` under the α3 AHM-extension separability test framing, baking in the **Top 3 concerns** surfaced in the §3 alpha test peer-review simulation (`editorial_decision.md` §§141–161). The current Title / Abstract / §1 are PRE-α3 placeholders (PR #4 three-channel tenant-driven stubs flagged `[★ TODO 2026-05-18]`); they must be replaced so the manuscript reads coherently from abstract through §3 under one theoretical backbone.

**Why now.** §3 α3 alpha test complete, Major Revision verdict (0 FATAL / 10 ADDRESSABLE), B.1 honest-reframe triple-confirmed. The editor explicitly carried forward Top 3 §1-level concerns. §1 is the next bottleneck: until §1 reads under α3, full-manuscript peer review (`/review-paper --peer ajae` on the entire paper) will fail at desk for incoherent framing.

**Out of scope this session.**
- §3 ADDRESSABLE hot-fixes (7-item pre-§1 checklist items #1, #2, #3, #4, #6, #7) — separate commit after §1 draft lands. Only items #5 and a partial of #3 are §1-level concerns (see §"7-item checklist integration").
- §2 Institutional Context, §4 Data, §5 Results, §6 Discussion — separate sessions.
- `paper/ko/main.tex` — CLAUDE.md "Never simultaneous bilingual edits" rule.

---

## Decision provenance (Top 3 §1 concerns from editor)

Source: `quality_reports/peer_review_section3_alpha3/editorial_decision.md` §§141–161.

1. **Honest pre-specification disclosure language** — §1 contribution paragraph must name ADR-0001 / ADR-0002 and the F1/F2 pre-registration, pre-empting the "post-hoc reorder" reading.
2. **4-anchor positioning + LaFave-Thomas 2016 graceful-failure clause** — Kirwan 2009 JPE / **Baldoni-Ciaian 2023** LUP / Kazukauskas 2013 AJAE / Carter-Olinto 2003 AJAE explicitly positioned in §1; LaFave-Thomas 2016 ECMA graceful-failure clause carried to abstract.
3. **Magnitude calibration in abstract** — SFFP scale (₩1.2M/year), 0.5 ha cutoff, $T_{SFFP}/\tau$ ratio (0.024–0.048 with 25M/50M reconciliation) stated upfront.

---

## Critical files

| Path | Action | Phase | Lines / size |
|------|--------|-------|--------------|
| `paper/en/main.tex` L4 (Title comment) | EDIT — remove `[PRE-α3 placeholder]`, finalize title | 2 | 1–3 lines |
| `paper/en/main.tex` L31–34 (`\title{...}`) | EDIT — rewrite title under α3 | 2 | 2-line title |
| `paper/en/main.tex` L40–52 (Abstract block) | DELETE PR #4 stub + WRITE α3 abstract | 3 | replace ~12 lines with ~16–22 lines (200-word target) |
| `paper/en/main.tex` L54 keywords | EDIT — add "AHM separability" + remove "Tenant-Driven Land Transition" | 3 | 1 line |
| `paper/en/main.tex` L55 JEL | KEEP — Q12, Q15, Q18, D13 still appropriate (verify) | 3 | 1 line |
| `paper/en/main.tex` L60–69 (`\section{Introduction}` + TODO block) | DELETE TODO block + WRITE α3 §1 | 4 | replace ~10 lines with ~80–120 lines (5–6 paragraphs, ~1,200–1,500 words target) |
| `Bibliography_base.bib` | READ-ONLY (verify citation keys for 9 anchors + Sotelo/Costinot-Donaldson if cited) | 1 | — |
| `master_supporting_docs/own_drafts/초안.md` (Korean v1) | READ-ONLY (bootstrap structure + institutional language) | 1 | 388 lines |
| Output: `paper/en/main.pdf`, `paper/en/online_appendix.pdf` | RECOMPILE (3-pass latexmk) | 5 | binary |
| `quality_reports/session_logs/2026-05-18_section1-alpha3-rewrite.md` | CREATE / APPEND | continuous | incremental |

**Reusable infrastructure (do NOT touch this session):**
- `paper/en/main.tex` §3 (L79–210) — α3 framework already merged (`c2192e5`); §1 must align with §3 contribution statement, NOT modify §3
- `paper/en/online_appendix.tex` §B.1–B.3 — same; §1 may reference but not modify
- `Bibliography_base.bib` — 26 entries; α3-relevant subset includes all 9 CoVe-PASS verified + Zimmert-Zorn 2022 (consider adding, see D4 below)

---

## Pre-conditions (verify before Phase 0)

- [x] PR #5 merged (`c2192e5`); §3 α3 framework on main
- [x] §3 alpha test complete (`peer_review_section3_alpha3/SUMMARY.md`); Top 3 §1 concerns surfaced
- [x] Citation keys verified: `BaldoniCiaian2023_eucap` (not "Ciaian2023" — PR #3 hallucination history)
- [x] Korean v1 source available (`master_supporting_docs/own_drafts/초안.md`, 388 lines)
- [x] Compile clean baseline (main.pdf 11p, online_appendix.pdf 7p, 0 undefined refs)
- [ ] Bibliography α3 anchors complete (9/9 CoVe + 4 AJAE-anchor citation keys) — verify Phase 1

---

## Phase 0 — Bootstrap context gather (30 min)

**Read** (in parallel):
1. `quality_reports/peer_review_section3_alpha3/SUMMARY.md` — Top 3 concerns + 7-item checklist
2. `quality_reports/peer_review_section3_alpha3/editorial_decision.md` §§141–161 — verbatim Top 3 + sample language
3. `master_supporting_docs/own_drafts/초안.md` lines 18–60 — Korean v1 abstract + §1 (institutional + structural bootstrap only)
4. `paper/en/main.tex` L79–210 — §3 contribution statement for alignment ("We test the AHM separability null... Two AHM extensions — wealth-biased liquidity and implicit-labor supervision — yield independent margins through which separability fails. We reject AHM separability for Korean small farms.")
5. `paper/en/main.tex` L41–52, L60–69 — current TODO placeholders (to be deleted)

**Map** existing Korean v1 paragraphs → α3 framing:
- Korean v1 §1 paragraph structure (8 paragraphs ~3,000 chars) → English α3 5–6 paragraphs (~1,200–1,500 words)
- Korean v1 institutional context (Act on Public-Interest Direct Payments Article 10, 0.5 ha cutoff, 1.2M KRW SFFP, FHES Wave 1) is **directly portable** — language reuse
- Korean v1 theoretical framing (Caballero-Engel S,s + Sandmo + 3-channel tenant-driven) is **fully replaced** by α3 AHM-extension

**Decision gate:** Confirm 4-anchor citation keys + LaFave-Thomas 2016 / Carter-Olinto 2003 / Singh-Squire-Strauss 1986 / dJFS 1991 are all in `Bibliography_base.bib`. (Verified above; final check Phase 1.)

---

## Phase 1 — Title rewrite (15 min)

**Current title** (L31–34, PRE-α3):
> Three-Channel Tenant-Driven Land Transition: Evidence from Korea's Per-Farm Flat-Rate Direct Payment Scheme

**Proposed α3 title candidates (Dohyeon picks one):**

| # | Title | Rationale |
|---|-------|-----------|
| **T1** ⭐ | **Testing Agricultural Household Model Separability at a Direct-Payment Cutoff: Evidence from Korea** | AJAE-style; leads with method (separability test); names AHM lineage; "direct-payment cutoff" signals identification |
| T2 | Rejecting Separability: AHM Evidence from Korea's Per-Farm Flat-Rate Direct Payment Cutoff | Stronger contribution claim; matches C2 hook verbatim; longer |
| T3 | A Separability Test of the Agricultural Household Model: Evidence from a Direct-Payment Discontinuity in Korea | Most AJAE-conventional; passive "evidence from"; emphasizes discontinuity design |
| T4 | Wealth, Supervision, and Separability: An AHM-Extension Test at the 0.5 ha Cutoff in Korea | Names two non-separabilities (Channels A+B); preview of mechanisms; longest |

**Recommendation:** T1 (concise, methods-forward, AJAE-style). T2 is editor's "C2 hook" verbatim option. T4 if Dohyeon wants channel preview.

**JEL codes (verify):** Q12 (Micro Analysis of Farm Firms), Q15 (Land Ownership and Tenure), Q18 (Agricultural Policy), D13 (Household Production and Intrahousehold Allocation). All four α3-appropriate. **Add D14** (Household Saving / Liquidity) for Carter-Olinto wealth-bias? — D14 is "Household Saving; Personal Finance" which fits liquidity framing. **Decision D-JEL: include D14 or not.**

**Keywords (current):** "Agricultural Household Model; regression discontinuity; direct payment; tenancy; rent capitalization; Korea."

**Proposed α3 keywords:** "Agricultural Household Model; separability; regression discontinuity; difference-in-differences; direct payment; smallholder; liquidity; Korea."
- Remove: "tenancy" (demoted to ex-theory), "rent capitalization" (B.1 ex-theory)
- Add: "separability" (C2 hook), "difference-in-differences" (design completeness), "liquidity" (Carter-Olinto), "smallholder" (AJAE audience)

---

## Phase 2 — Abstract rewrite (45–60 min)

**Target:** ~200 words (AJAE convention ≤250), 5–6 sentences, structured as:
1. Setting + research question (1 sentence): Korea PIDPS / SFFP / 0.5 ha cutoff
2. AHM separability null + α3 contribution (1–2 sentences): C2 hook "We test the AHM separability null at the Korean SFFP cutoff and reject it through two AHM extensions: wealth-biased liquidity (Carter-Olinto) and implicit-labor supervision (Eswaran-Kotwal)."
3. Magnitude calibration (1 sentence, Top 3 #3): SFFP scale ₩1.2M/year, $T_{SFFP}/\tau$ ratio 0.024–0.048 reconciliation upfront
4. Empirical strategy + outcome hierarchy (1 sentence): DiD-RD at frozen-2018 cutoff, 4-anchor positioning, primary outcomes `area_own` + `op_cost_ex_rent`, auxiliary `off_farm_income`
5. Headline result + falsification (1–2 sentences, Top 3 #1): F1 + F2 pre-registered (ADR-0001/0002 archived); LaFave-Thomas 2016 graceful-failure clause if both fire
6. Contribution framing (1 sentence): first developed-country AHM-separability test at a per-farm flat-rate cutoff

**Headline magnitudes to preview (placeholder until §5 rewrite):**
- area_own pure_tenant +1,089 m² (T2, p=0.033) — Channel A wealth-bias signature
- op_cost_ex_rent T1 −4.02M KRW (p=0.055), T2 −3.22M (p=0.079) — eq:CO-3 (S,s) inaction
- **Decision D-magnitude:** include specific numbers in abstract (riskier — §5 may re-tabulate) OR stay general ("we document a monotone gradient in own-cultivated area across baseline tenancy quintiles").

**Recommendation:** Stay general at abstract level + preview headline direction only ("we document a monotone tenancy gradient consistent with Carter-Olinto liquidity relaxation and a negative operating-cost response consistent with (S,s) inaction"). Specific numbers in §1 last paragraph, where they can be updated easily when §5 lands.

---

## Phase 3 — §1 Introduction rewrite (2–3h)

**Target:** 5–6 paragraphs, ~1,200–1,500 words. Paragraph plan:

### ¶1 — Setting + Policy stakes (200 words)
- 2020 Korean PIDPS transformation; SFFP per-farm flat-rate ₩1.2M for ≤0.5 ha cohort
- ~1M Korean farms, KRW 2.3T annual budget, ~20% of PIDPS total
- Per-farm flat-rate design is distinctive vs US (Kirwan 2009 area-proportional) and EU CAP (Baldoni-Ciaian 2023 area-proportional Pillar I); Switzerland (Zimmert-Zorn 2022 spatial RD) the only close analog
- Research question: does the SFFP transfer alter smallholder farm behavior at the cutoff?

### ¶2 — AHM separability null + α3 contribution (250 words)
- **C2 hook (Top 3 #1):** "We test the Agricultural Household Model separability null (Singh-Squire-Strauss 1986; de Janvry-Fafchamps-Sadoulet 1991) at the Korean SFFP cutoff and reject it through two AHM extensions: wealth-biased liquidity (Carter-Olinto 2003 AJAE) and implicit-labor supervision (Eswaran-Kotwal 1986 EJ)."
- Separability null statement: with complete markets, smallholder production decisions are separable from consumption / wealth / household composition
- α3 framework rejects separability through two non-separabilities (Channels A, B); bargaining-margin / equilibrium-rent demoted to ex-theory (B.1 honest-reframe **locked in as paper strength** per triple-confirmed editor + 2 referees)
- **Pre-spec disclosure language (Top 3 #1):** "We pre-register two falsification triggers (F1: monotone-tenancy gradient in own-cultivated area; F2: hired-labor margin response) under the AHM-extension scope adopted in ADR-0001 / ADR-0002 (archived in the replication package), prior to §5 estimation."

### ¶3 — 4-anchor positioning + LaFave-Thomas graceful-failure (300 words, Top 3 #2)
- **vs Kirwan 2009 JPE** (US farmland-rental incidence, area-proportional payments → +25% pass-through): we study Korea per-farm flat-rate, not area-proportional; B.1 ex-theory demotion of bargaining/incidence margin is the honest contrast
- **vs Baldoni-Ciaian 2023 Land Use Policy** (EU CAP Pillar I area-proportional, +46–55% pass-through): same contrast — design difference between supranational EU CAP and Korean national per-farm flat-rate
- **vs Kazukauskas et al. 2013 AJAE** (decoupling-disinvestment in OECD): eq:CO-3 op_cost_ex_rent sub-prediction is in the same lineage; we extend with the wealth-bias signature (eq:CO-2)
- **vs Carter-Olinto 2003 AJAE** (rural Honduras land transfer): same theoretical framework, different developed-country setting, different policy instrument (per-farm flat vs land grant)
- **Graceful-failure clause (LaFave-Thomas 2016 ECMA):** if F1 fails to fire monotonically and F2 returns null, we read this as "a precise null estimate complementing LaFave-Thomas 2016's evidence that smallholder separability survives in developed-country contexts where labor and credit markets approach completeness" — this is the honest pre-commitment to the negative finding being a contribution, not a failure

### ¶4 — Empirical strategy + outcome hierarchy (250 words)
- DiD-RD at 0.5 ha cutoff (rv_2018 = area_2018 − 5,000 m²); frozen-2018 baseline blocks manipulation
- 3-tier bandwidth parallel reporting (T1 ±500m², T2 ±1000m², T3 MSE-optimal); Wild cluster bootstrap (Cameron-Gelbach-Miller 2008 restricted) + Holm step-down
- FHES Wave 1 panel 2018–2022 (N=3,614 farms, 14,474 farm-years; D mean=0.349)
- **Outcome hierarchy under α3 (ADR-0002):** primary #1 area_own (Carter-Olinto wealth-bias); primary #2 op_cost_ex_rent (Kazukauskas decoupling); auxiliary off_farm_income (Eswaran-Kotwal supervision); ex-theory unit_rent_price + rent_cost (B.1 demote)

### ¶5 — Headline results preview + magnitude calibration (250 words, Top 3 #3)
- **Magnitude calibration:** "At the small-farmer flat-payment scale of ₩1.2M/year relative to the Korean small-farm capital adjustment cost of ~₩25M (down-payment-equivalent) / ~₩50M (purchase-price) — a $T_{SFFP}/\tau$ ratio of 0.024–0.048 — the closed-form predictions place us deep within the (S,s) inaction band and the wealth-bias rejection region simultaneously."
- Headline results preview (qualitative; specific numbers deferred to §5):
  - F1 fires: monotone tenancy gradient in $\partial A_{own,i}/\partial T$ across $s_0$ quintiles; pure-tenant cohort largest response, pure-owner cohort ≈ 0 by construction
  - eq:CO-3: $\beta_3 \le 0$ on op_cost_ex_rent at T1/T2 narrow bandwidths
  - F2: $off\_farm\_income$ effect — auxiliary outcome still pending Phase 4 estimation, evaluated under §3 mapping framework only (acknowledged in §1 footnote)

### ¶6 — Three-fold contribution + outline (200 words)
- **Contribution 1 (methodological):** first AHM separability test at a per-farm flat-rate direct-payment cutoff; first DiD-RD evidence on Korean PIDPS
- **Contribution 2 (theoretical):** AHM-extension framework with explicit B.1 ex-theory disclosure on bargaining/incidence margin — methodological discipline AJAE editor + 2 referees triple-confirmed as honest
- **Contribution 3 (empirical-policy):** monotone tenancy gradient signature in own-cultivated area + (S,s) operating-cost response, evidence base for non-incidence-margin policy effects in developed-country smallholder settings
- §2 institutional context; §3 theoretical framework; §4 data; §5 identification; §6 results; §7 robustness; §8 discussion; §9 conclusion

---

## Phase 4 — Compile + visual check (15 min)

**3-pass latexmk:**
```bash
cd /Users/leedo/Research/01_dissertation_PBDP/paper/en
latexmk -xelatex -interaction=nonstopmode main.tex
latexmk -xelatex -interaction=nonstopmode online_appendix.tex
latexmk -xelatex -interaction=nonstopmode main.tex
```

**Verify:**
- `pdfinfo main.pdf | grep Pages` — expect 12–14p (was 11p, +1–3p for §1)
- `pdfinfo online_appendix.pdf | grep Pages` — expect 7p unchanged
- `grep -c "Undefined" main.log online_appendix.log` — expect 0/0
- `grep -c "Missing character" main.log` — expect 0 (★/α TODO markers removed)
- `grep -i "Warning" main.log` — review remaining warnings (acceptable: italic glyph fallbacks for Korean policy terms if any)

**Visual check (user, on Mac mini):**
1. Title renders cleanly (chosen from T1/T2/T3/T4)
2. Abstract reads as one paragraph, ~200 words, contains C2 hook + magnitude calibration + F1+F2 + 4-anchor positioning (compressed) + LaFave-Thomas clause
3. Keywords + JEL line clean
4. §1 reads 5–6 paragraphs flowing through Setting → α3 contribution → 4-anchor → strategy → magnitude/headline → contribution-outline
5. Cross-refs to §3 (`\Cref{sec:theory}`) and online_appendix (`Online Appendix B`) resolve
6. Bibliography entries cited in §1 all appear in references (Singh-Squire-Strauss, dJFS, Carter-Olinto, Kazukauskas, Eswaran-Kotwal, Benjamin, LaFave-Thomas, Kirwan, BaldoniCiaian)

---

## Phase 5 — CoVe Post-Flight verification (30 min)

**Mandatory per `.claude/rules/post-flight-verification.md`** — every citation, every numerical claim, every "first to do X" novelty assertion must be verified.

**Claims to extract from §1 + Abstract** (typical list, finalized after draft):
- C1: Kirwan 2009 JPE +25% pass-through claim
- C2: Baldoni-Ciaian 2023 LUP +46–55% pass-through claim
- C3: Singh-Squire-Strauss 1986 AHM separability null formulation
- C4: dJFS 1991 EJ AHM extension
- C5: Carter-Olinto 2003 AJAE wealth-bias derivation
- C6: Kazukauskas 2013 AJAE 95(5) (distinct from 2014 productivity paper)
- C7: Eswaran-Kotwal 1986 EJ 96(382) (distinct from 1985 AER)
- C8: LaFave-Thomas 2016 ECMA 84(5) graceful-failure framing
- C9: Zimmert-Zorn 2022 Q Open Swiss spatial RD (if cited in ¶1)
- C10: "First developed-country AHM-separability test at per-farm flat-rate cutoff" novelty claim
- C11: SFFP statute Article 10 + 0.5 ha cutoff + ₩1.2M/year quantitative facts
- C12: FHES Wave 1 panel size (3,614 farms, 14,474 farm-years, D mean=0.349)
- C13: $T_{SFFP}/\tau \in [0.024, 0.048]$ range with 25M/50M reconciliation

**Verifier:** forked `claim-verifier` (`subagent_type: general-purpose` per Phase 5 prior pattern; context: fork). Output: `quality_reports/peer_review_section1_alpha3/postflight_cove.md` (mirror Phase 5 of §3 alpha test).

**Pass criteria:** PASS or PARTIAL (with surgical fixes applied). FAIL on a load-bearing citation requires regeneration of the §1 paragraph.

---

## Phase 6 — Quality gate + commit (15 min)

**Pre-commit checks:**
- `python scripts/quality_score.py paper/en/main.tex` — advisory; expect ≥ 80 (per CLAUDE.md threshold; if path bug fires, override per `[LEARN:tooling]` 2026-05-14 precedent)
- Compile clean (Phase 4 verified)
- CoVe PASS or PARTIAL with documented fixes (Phase 5)
- paper/ko unchanged (verify `git status paper/ko/`)
- No regressions in §2-§9 (verify `git diff main.tex` shows only §1 + Abstract + Title changes)

**Commit message:**
```
feat(paper): §1 Abstract + Introduction α3 rewrite

§1 wholesale rewrite under AHM-extension separability test framing
per /interview-me + ADR-0001/0002/0003 + §3 α3 alpha-test peer-review
(quality_reports/peer_review_section3_alpha3/editorial_decision.md).

Bakes in Top 3 §1 concerns from editor synthesis (2026-05-18):
  - Honest pre-spec disclosure language (ADR-0001/0002 named)
  - 4-anchor positioning (Kirwan/Baldoni-Ciaian/Kazukauskas/Carter-Olinto)
    + LaFave-Thomas 2016 graceful-failure clause
  - Magnitude calibration upfront (T_SFFP/τ ∈ [0.024, 0.048] reconciliation)

Title rewrite: Three-Channel Tenant-Driven → [chosen T1/T2/T3/T4]
Abstract: ~200 words, F1+F2 pre-registered, C2 contribution hook
§1: 5–6 paragraphs, ~1,200–1,500 words, AHM-extension headline

CoVe Post-Flight: PASS|PARTIAL (N claims verified independently).

Constraints preserved:
  - paper/ko/main.tex untouched (CLAUDE.md bilingual rule)
  - §3 (c2192e5) + online_appendix.tex unchanged
  - 7-item pre-§1 checklist items #1, #2, #3, #4, #6, #7 deferred to
    §3 hot-fix commit (next session)
```

**Branch:** `feat/section1-alpha3-rewrite` (new branch from main `c2192e5`).

**PR:** Following PR #1-5 pattern (Merge commit `--no-ff`, body includes Top 3 mapping + CoVe outcome + compile verification + known minor issues).

---

## Phase 7 — Memory + session log update (10 min)

Update `~/.claude/projects/-Users-leedo-Research/memory/pidps_next_session_resume.md`:
- §1 rewrite complete; PR #6 status (push / merge per Mac mini availability)
- AJAE acceptance probability — re-estimate if §1 framing exposed new issues (likely stable at 65–72%, possibly +1–2 pp if Top 3 land cleanly)
- 7-item checklist updated: items #5 + partial #3 complete (§1-level); items #1, #2, #3 (rest), #4, #6, #7 remain as §3 hot-fix queue
- Next session options:
  - (A') §3 hot-fix commit (1.5–2h, single session, all remaining 7-item checklist)
  - (B) §5 Results re-tabulation under α3 outcome hierarchy
  - (E') `/review-paper --peer ajae` re-run on full manuscript (§1 + §3, post-§1 alignment audit) — 1–2h

---

## 7-item pre-§1 checklist integration mapping

| # | Item | §1-level? | This-session action |
|---|------|-----------|---------------------|
| 1 | $\tau$ source citation (KAEA/KREI/NABO) + 25M/50M reconciliation | partial | Abstract + §1 ¶5 state the ratio + reconciliation; **specific source citation deferred to §3.4 hot-fix** |
| 2 | Notation table at head of §3 | no | §3 hot-fix (next session) |
| 3 | Magnitude calibration sub-section §3.4.1 | partial | §1 ¶5 carries magnitude prose; **§3.4.1 sub-section deferred** |
| 4 | §3.5 ITT / Roth-2022 / HonestDiD M̄ footnote | no | §3 hot-fix (next session) |
| 5 | $s_0$ quintile pre-spec disclosure + ADR-0002 archive | yes | §1 ¶2 pre-spec language + ADR-0001/0002 named explicitly |
| 6 | F2 tightening (EK-1 sign indeterminacy → directional or F2a/F2b split) | no | §3 hot-fix (next session) |
| 7 | §B.3 mapping table T1/T2/T3 row separation + falsification grid | no | §3 hot-fix (next session) |

**Net:** Items #5 (full) and #1, #3 (partial — abstract/intro-level prose) ARE in scope. Items #2, #4, #6, #7 + remainder of #1, #3 → next-session §3 hot-fix commit.

---

## Decisions Requiring User Approval (BEFORE Phase 0 starts)

### D1. Title choice (Phase 1)
- (a) ⭐ **T1:** "Testing Agricultural Household Model Separability at a Direct-Payment Cutoff: Evidence from Korea" — concise, methods-forward, AJAE-style
- (b) T2: "Rejecting Separability: AHM Evidence from Korea's Per-Farm Flat-Rate Direct Payment Cutoff" — stronger C2 hook
- (c) T3: "A Separability Test of the Agricultural Household Model: Evidence from a Direct-Payment Discontinuity in Korea" — most AJAE-conventional
- (d) T4: "Wealth, Supervision, and Separability: An AHM-Extension Test at the 0.5 ha Cutoff in Korea" — names channels

### D2. Abstract magnitude specificity
- (a) ⭐ **General direction only** — "monotone tenancy gradient consistent with Carter-Olinto" + "negative operating-cost response consistent with (S,s) inaction" — abstract robust to §5 re-tabulation
- (b) Specific numbers — preview pure-tenant +1,089 m² (T2 p=0.033) and op_cost_ex_rent −4.02M KRW (T1 p=0.055) — riskier if §5 re-tabulates under α3 outcome hierarchy
- (c) Numbers in §1 ¶5 only, none in abstract — safest

### D3. §1 length target
- (a) 5 paragraphs (~1,200 words) — tighter, more impact-per-word
- (b) ⭐ **6 paragraphs (~1,400 words)** — full contribution layout, separate Magnitude+Headline ¶5 from Strategy ¶4
- (c) 7 paragraphs (~1,600 words) — separate falsification ¶ from anchor-positioning ¶; longest but most surgical

### D4. Zimmert-Zorn 2022 Q Open Swiss spatial-RD citation
- (a) ⭐ **Cite in §1 ¶1** as "the closest cousin design — Swiss per-farm direct-payment cutoff (Zimmert-Zorn 2022 Q Open) shares the national non-supranational scheme analogy" — capitalizes on CoVe-fixed novelty probe
- (b) Cite only in §3 footnote as adjacent prior work; §1 stays clean
- (c) Don't cite — adjacent work, not load-bearing for contribution

### D5. JEL D14 addition
- (a) ⭐ **Add D14** (Household Saving; Personal Finance) — fits Carter-Olinto liquidity framing
- (b) Keep Q12, Q15, Q18, D13 only — current set is α3-appropriate

### D6. Workflow ordering
- (a) ⭐ **Sequential: Title → Abstract → §1 (each gets user approval before next)** — manual approval mode strict
- (b) Parallel: draft all three together, present complete §1 + Abstract + Title bundle for user approval
- (c) Compile-first: draft → compile → user reviews PDF → iterate

---

## Verification Checklist (post-Phase 7)

- [ ] Title chosen and finalized in `\title{}` block
- [ ] Abstract is ≤250 words, contains C2 hook + magnitude calibration + F1+F2 + 4-anchor positioning + LaFave-Thomas graceful-failure
- [ ] §1 reads 5–6 paragraphs under α3 framing; no remaining `[★ TODO]` markers in Abstract / §1
- [ ] Keywords + JEL updated for α3
- [ ] All 9 CoVe-verified citations correctly used in §1 (no PR #3-style hallucinations like "Ciaian 2023" → must be "BaldoniCiaian 2023")
- [ ] Top 3 §1 concerns all surfaced in §1 prose (verify by string match: "pre-register", "Carter-Olinto", "(S,s) inaction", "0.024", "0.048")
- [ ] B.1 honest-reframe LOCK IN signaled in §1 (e.g., "bargaining margin demoted to ex-theory" or equivalent honesty language)
- [ ] CoVe Post-Flight PASS or PARTIAL with surgical fixes
- [ ] Compile clean: main.pdf 12–14p, 0 undefined refs, 0 missing chars in §1+Abstract
- [ ] paper/ko/main.tex unchanged
- [ ] §3 (c2192e5) + online_appendix.tex unchanged
- [ ] PR #6 created (after Mac mini compile + visual review) — Merge commit method per PR #1-5 pattern

---

## Time / token budget

| Phase | Est. wall-clock | Est. tokens (incl. CoVe agent) |
|-------|-----------------|--------------------------------|
| 0 — Bootstrap context gather | 30 min | ~5k (Read only) |
| 1 — Title rewrite + decisions | 15 min | ~2k |
| 2 — Abstract rewrite | 45–60 min | ~5–8k |
| 3 — §1 Introduction rewrite | 2–3h | ~20–30k |
| 4 — Compile + visual check | 15 min | ~2k (Bash) |
| 5 — CoVe Post-Flight | 30 min | ~30–50k (forked agent) |
| 6 — Quality gate + commit | 15 min | ~3k |
| 7 — Memory + session log | 10 min | ~3k |
| **Total** | **4.0–5.5h** | **~70–100k** |

User estimate was 4–6h. Plan aligns within range.

---

## Risk register

| Risk | Severity | Mitigation |
|------|----------|------------|
| §1 framing exposes §3-§1 inconsistency requiring §3 revision | Medium | Phase 0 read §3 contribution sentence carefully; align §1 ¶2 verbatim with §3 ¶1 C2 hook |
| 4-anchor positioning ends up superficial / one-liner | High | Phase 3 ¶3 dedicated to anchor positioning (300 words); each anchor gets explicit "vs X: Y" contrast |
| Magnitude calibration in abstract collides with §5 re-tabulation later | Medium | D2 default to "general direction only" — abstract robust to §5 changes |
| Top 3 #1 pre-spec language reads defensive / awkward | Medium | Test multiple phrasings; bake ADR reference into footnote rather than main text if clunky |
| CoVe FAIL on novelty claim (e.g., "first developed-country AHM-separability test") | High | Phase 5 forked verifier; phrase as "first AHM-separability test at a per-farm flat-rate cutoff" (narrower, defensible) rather than broader "first developed-country" claim |
| Bibliography entry drift (BaldoniCiaian2023 ≠ Ciaian2023) repeats PR #3 hallucination | High | Pre-checked Bibliography_base.bib L124 confirms BaldoniCiaian2023_eucap key; use exact key in `\citet{}` calls |
| §1 length overflows 1,500 words target | Low | Cut ¶6 outline paragraph (move to §1.1 if needed) |

---

## Out of scope (explicit non-goals)

- ❌ §3 ADDRESSABLE hot-fixes (A1–A10) — separate commit after §1 lands
- ❌ §2 / §4 / §5 / §6 / §7 / §8 / §9 — separate sessions
- ❌ Online appendix changes (B.1 / B.2 / B.3) — already merged in c2192e5
- ❌ paper/ko/main.tex — CLAUDE.md "Never simultaneous bilingual edits"
- ❌ Bibliography new entries (unless D4 = a, then add Zimmert-Zorn 2022; verify via CoVe)
- ❌ scripts/R/ — `--no-cross-artifact` precedent; §1 is pure prose
- ❌ Title change to non-AJAE-style (e.g., journalism style "Why Korean Farmers Don't..."), R-conventions paper-style required
- ❌ paper/ko sync from paper/en — deferred to "post paper/en stable" per CLAUDE.md

---

## Next-session triggers (depending on Phase 7 outcome)

- **If §1 lands clean + Top 3 all addressed:** Proceed to (A') §3 ADDRESSABLE hot-fix commit (7-item checklist items #1, #2, #3, #4, #6, #7) — 1.5–2h next session
- **If §1 exposes §3 misalignment:** §3 micro-revision first → re-run partial alpha test on aligned §1+§3 bundle
- **If user prefers full audit:** (E') `/review-paper --peer ajae` re-run on full main.tex (post-§1) — 1–2h, costs ~370k tokens (alpha test precedent)

---

**END OF PLAN.** Awaiting Dohyeon approval on D1–D6 + overall plan. After approval: enter plan mode exit, save initial session log, begin Phase 0.
