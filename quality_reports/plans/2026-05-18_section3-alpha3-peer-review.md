---
status: APPROVED (Dohyeon 2026-05-18; D1–D4 all recommended options accepted)
mode: Manual approval, plan-first
skill: /review-paper --peer ajae --no-cross-artifact
scope: §3 Theoretical Framework + paper/en/online_appendix.tex (alpha test)
estimated_time: 75–110 min (incl. AJAE profile authoring + CoVe Post-Flight)
---

# Plan — §3 α3 Framework AJAE Peer-Review Simulation

**Goal.** Alpha-test the α3 (AHM-extension separability test) §3 + online_appendix under simulated AJAE peer review BEFORE drafting §1 Abstract+Introduction (option A). Surface FATAL / ADDRESSABLE / TASTE concerns so §1 framing can be tuned to maximize AJAE acceptance probability (currently estimated 60–65% post-α3).

**Why now.** §3 is the only stable section (`c2192e5` merged). §1/§5/§6 are `[★ TODO]` placeholders. Reviewing the full paper would force referees to evaluate incomplete framing — wasted simulation tokens + false negative ("Reject: §1 unwritten"). §3-only isolated review yields theoretical-contribution signal without §1 framing confound.

**Decision provenance.**
- `quality_reports/decisions/2026-05-18_theoretical-scope.md` (ADR-0001 — α-strict + Combo α3 + B.1)
- `quality_reports/decisions/2026-05-18_outcome-hierarchy.md` (ADR-0002 — `area_own` primary #1)
- `quality_reports/decisions/2026-05-18_section3-structure.md` (ADR-0003 — S1 + D2 + separate online appendix)
- `quality_reports/research_spec_ahm-extension-pidps.md` (CoVe 9/9 PASS research spec)

---

## Critical files & directories

| Path | Action | Phase | Notes |
|------|--------|-------|-------|
| `.claude/references/journal-profiles.md` | EDIT — append AJAE profile | 0 | Skill **stops** if AJAE absent. Use `templates/journal-profile-template.md` schema. |
| `paper/en/main.tex` (lines 79–210, §3) | READ-ONLY input | 1–3 | §3 spans 132 lines (`\section{Theoretical Framework}` line 79 → `\section{Data}` line 211) |
| `paper/en/online_appendix.tex` | READ-ONLY input | 1–3 | §B.1 (Wealth-Biased Liquidity) + §B.2 (Supervision) + §B.3 (mapping table). 7 pages compiled. |
| `quality_reports/peer_review_section3_alpha3/` | CREATE dir | 2–5 | Output root |
| `quality_reports/peer_review_section3_alpha3/desk_review.md` | CREATE | 2 | Editor desk review + referee assignment |
| `quality_reports/peer_review_section3_alpha3/referee_theory.md` | CREATE | 3 | Theory referee (CoVe + closed-form derivation expert) |
| `quality_reports/peer_review_section3_alpha3/referee_empirical.md` | CREATE | 3 | Empirical-Methods referee (DiD-RD + magnitude) |
| `quality_reports/peer_review_section3_alpha3/editorial_decision.md` | CREATE | 4 | Editor synthesis (FATAL/ADDRESSABLE/TASTE) |
| `quality_reports/peer_review_section3_alpha3/postflight_cove.md` | CREATE | 5 | Novelty-probe + citation verification (forked `claim-verifier`) |
| `quality_reports/peer_review_section3_alpha3/SUMMARY.md` | CREATE | 6 | User-facing 1-page summary + next-step recommendation |

---

## Pre-conditions (verify before Phase 0)

- [x] PR #5 merged (`c2192e5`, main updated)
- [x] `paper/en/main.pdf` compiles clean (11p, 0 undefined refs)
- [x] `paper/en/online_appendix.pdf` compiles clean (7p)
- [ ] AJAE journal profile in `.claude/references/journal-profiles.md` — **MISSING, Phase 0 creates**
- [ ] Network available (novelty probe uses WebSearch) — alternatively `--no-novelty-check`

---

## Phase 0 — AJAE Journal Profile Authoring (15–20 min)

**Why.** `/review-paper --peer ajae` reads `.claude/references/journal-profiles.md` for editor calibration (Domain/Methods adjustments, Typical concerns, Referee-pool weights, Table format). File currently ships only AER/QJE/JPE/ECMA/ReStud + 3 PolSci. Skill `Pre-Flight Report` halts if AJAE missing.

**Source material** (existing repo knowledge):
- CLAUDE.md submission cascade: AJAE direct → JAE → Food Policy → KAEA
- CLAUDE.md AJAE constraints: ≤ 50 pages double-spaced incl. references; AEA-style replication package (DCAS v1.0); Kazukauskas 2013 AJAE 95(5) + Kirwan 2009 JPE 117(1) + Carter-Olinto 2003 AJAE 85(1) as anchoring journal precedents
- `.claude/agents/domain-reviewer.md` E-7 (AJAE editor/referee perspective notes from prior referee simulation 2026-05-18 pre-α3)

**AJAE profile content (proposed for user approval — edits welcome before authoring):**

| Field | Value |
|-------|-------|
| Short name | `AJAE` |
| Focus | Applied agricultural & resource economics; identification-credible policy evaluation; landlord-tenant / production / consumption / risk in farm households; food policy with credible quantification |
| Bar | Top journal in ag econ. Wants identification credibility + policy relevance + magnitude that informs ag policy decisions. Less general-interest framing than AER, more applied than QJE. Lit positioning vs Kirwan/Ciaian/Kazukauskas/Carter-Olinto load-bearing. |
| Domain-referee adjustments | Contribution 30 → 32 (ag-econ contribution bar moderate); External validity 15 → 20 (generalizability to other ag policy contexts matters); Substance 20 → 22 (ag-policy taste) |
| Methods-referee adjustments | Identification 35 → 40 (DiD/RD credibility bar at AJAE risen post-2020); Replication 5 → 10 (AEA DCAS v1.0 strict); Magnitude 15 → 18 (ag policy decisions need interpretable effect sizes) |
| Typical concerns (5) | (1) "Is the empirical magnitude policy-relevant, or just statistically detectable?" (2) "Does the identification strategy survive standard ag-econ threats (selection on baseline area, measurement error in self-reported area, attrition)?" (3) "How does this paper fit the existing landlord-tenant / direct-payment literature (Kirwan 2009, Ciaian et al. 2023, Kazukauskas 2013)?" (4) "Is the replication package AEA-DCAS compliant given restricted FHES microdata?" (5) "Are the heterogeneity claims (tenancy-share gradient) pre-specified or post-hoc?" |
| Referee-pool weights | CREDIBILITY 0.25, POLICY 0.25, MEASUREMENT 0.20, STRUCTURAL 0.10, THEORY 0.10, SKEPTIC 0.10 |
| Table format override | No significance stars (AEA policy since 2023); SE in parentheses; sample size in each panel; clustering level in notes |

---

## Phase 1 — Pre-Flight Report (3 min)

Skill emits structured Pre-Flight before spawning editor:

```markdown
## Pre-Flight Report — /review-paper --peer ajae

**Manuscript:** paper/en/main.tex §3 (lines 79–210) + paper/en/online_appendix.tex
**Target journal:** AJAE → American Journal of Agricultural Economics
**Journal profile loaded:** yes (authored Phase 0)
**Scope mechanism:** §3-only annotated review (full paper readable but referees instructed to evaluate §3 + online_appendix only; §1/§5/§6 TODOs are NOT in scope)
**Cross-artifact scripts found:** N/A (--no-cross-artifact)
**Reproducibility status:** N/A
**Round:** fresh
```

User confirms Pre-Flight matches intent → spawn editor.

---

## Phase 2 — Editor Desk Review (15–20 min)

**Agent:** `.claude/agents/editor.md` (forked subagent, AJAE-calibrated).

**Reads:** §3 (132 lines) + online_appendix (437 lines) + abstract/intro placeholder block (to note that §1 is TODO and exclude from desk-reject criteria).

**Editor actions:**
1. Load AJAE profile from `journal-profiles.md`.
2. Run novelty probes (WebSearch) — default ON. **Specifically probes:**
   - "Has anyone tested AHM separability rejection for Korean rice/small-farm policy?"
   - "Wealth-biased liquidity (Carter-Olinto 2003) applied to flat-rate ag direct payments — prior work?"
   - "Eswaran-Kotwal supervision channel + DiD-RD cutoff design — prior work?"
3. Decide: **SEND OUT** (proceed) or **DESK REJECT** (terminate with rejection letter).
4. Draw two referee dispositions — **user-requested override**: explicitly assigns THEORY (Referee 1) + CREDIBILITY-MEASUREMENT hybrid (Referee 2) regardless of journal pool draws. Override documented in `desk_review.md` rationale section.
5. Assign each referee 1 critical + 1 constructive peeve.

**Output:** `quality_reports/peer_review_section3_alpha3/desk_review.md` with: decision, novelty-probe results (with PASS/FAIL/UNVERIFIED flags pending Phase 5 CoVe), referee assignments + peeves, contribution C2 evaluation, submission worthiness preliminary judgment.

---

## Phase 3 — Two Parallel Referees (30–45 min, blind to each other)

Spawn two forked subagents **in parallel** (single message, two `Task` calls):

### Referee 1: AJAE Theory Specialist
- **Agent:** `.claude/agents/domain-referee.md` with disposition=**THEORY**
- **User-specified specialty:** Singh-Squire-Strauss 1986, dJFS 1991, LaFave-Thomas 2016, Carter-Olinto 2003 expert; closed-form Lagrangian + comparative statics expert
- **Evaluation focus:**
  - §3.1 baseline AHM Lagrangian + FOC correctness
  - §3.2 wealth-biased liquidity derivation (eq:CO-1/2/3) — closed-form rigor + sign claims
  - §3.3 supervision FOC + shadow-wage divergence (eq:EK-1) — comparative statics validity
  - §B.1 4-step comparative statics (∂W*/∂T<0, ∂A_own/∂T>0 via density φ(W*), monotone gradient, T/τ≈0.048<<1)
  - §B.2 supervision Lagrangian + 2-step comp statics + SC6–SC8
  - F1+F2 pre-registered falsification stance — honesty + falsifiability
  - Citation completeness (CoVe 9/9 — does §3 cite all 9 supporting works correctly?)
  - B.1 ex-theory disclosure honesty (bargaining margin demoted, equilibrium rent caveat)
- **Output:** `referee_theory.md` (~3,000–5,000 words, "What would change my mind" on every MAJOR concern)

### Referee 2: AJAE Empirical Ag Economics
- **Agent:** `.claude/agents/methods-referee.md` with disposition=**CREDIBILITY** + **MEASUREMENT** hybrid
- **User-specified specialty:** DiD-RD methodology; Kirwan 2009, Ciaian 2023, Kazukauskas 2013 empirical Q-bar expert; Korean ag-policy quantification
- **Evaluation focus:**
  - P3b-2 empirical magnitude credibility (referenced from CLAUDE.md; §3.4 predictions table values)
  - Selection share 3.7% / treated cohort 0.349 fraction validity
  - Outcome hierarchy (area_own #1, op_cost_ex_rent #2, off_farm_income aux) — theory-empirics alignment
  - F1+F2 pre-registration: actually pre-registered or post-hoc?
  - DiD-RD identification (rv_2018 manipulation, parallel trends with 1 pre-period, bandwidth sensitivity) — flagged as **OUT OF §3 SCOPE** but referenced as theoretical-empirical mapping coherence test
  - B.1 demotion: is downgrading bargaining margin to ex-theory honest reframe or post-hoc fix to failed P3b-1 capitalization reversal?
  - Citation accuracy (Kazukauskas 2013 95(5) vs 2014 AgEcon 45 — distinct refs verified in CoVe)
- **Output:** `referee_empirical.md` (~3,000–5,000 words, "What would change my mind" on every MAJOR concern)

Each referee must produce summary score (1–5) per dimension + overall, plus "What would change my mind" on every MAJOR concern (mandated by editor.md / domain-referee.md / methods-referee.md).

---

## Phase 4 — Editor Synthesis (10–15 min)

**Agent:** `.claude/agents/editor.md` (second invocation, reads both referee reports).

**Editor classifies** each MAJOR concern across both referees:
- **FATAL** — would block publication regardless of revisions
- **ADDRESSABLE** — fixable in R&R
- **TASTE** — referee preference, not load-bearing

**Editorial decision (AJAE decision rule):**
- Accept / Minor / Major (R&R) / Reject / Desk Reject equivalent
- Pre-registered AJAE acceptance probability estimate (current memory says 60–65% α3) — re-estimate post-simulation

**Output:** `editorial_decision.md` with:
1. Decision + rationale
2. FATAL list (must resolve before resubmission)
3. ADDRESSABLE list (R&R action items)
4. TASTE list (judgment-call items)
5. Post-α3 AJAE acceptance probability estimate (revised from current 60–65%)
6. Submission worthiness: ready / one more rewrite / substantial revision

---

## Phase 5 — CoVe Post-Flight Verification (10–15 min)

**Mandatory** per `.claude/rules/post-flight-verification.md`. Specifically required for:
- Editor's novelty-probe claims (WebSearch hallucination risk)
- Any "Smith YYYY found X" assertions in referee reports

**Agent:** `.claude/agents/claim-verifier.md` (forked, `context: fork` — does NOT see drafts).

**Inputs to verifier:**
- Claims extracted from `desk_review.md` (novelty-probe outputs) + `editorial_decision.md`
- Source pointers (URLs from WebSearch, citation lookup queries)

**Outcomes:** PASS / PARTIAL / FAIL → regenerate

**Output:** `postflight_cove.md` with Verified / Unverifiable / Discrepancies table.

---

## Phase 6 — User Summary (5 min)

**Output:** `SUMMARY.md` (≤ 1 page, user-facing).

Structure:
- **Editorial decision:** [verdict] (revised AJAE prob: XX%)
- **FATAL count:** N (must-fix before submission)
- **ADDRESSABLE count:** N (R&R items)
- **Top 3 concerns to address in §1 Abstract+Intro rewrite (option A)** — actionable input for next session
- **CoVe Post-Flight:** PASS / PARTIAL / FAIL summary
- **Paths to all 5 reports**
- **Recommendation:** (a) proceed to §1 rewrite with new framing input, (b) §3 micro-revision first, (c) escalate to /seven-pass-review

---

## Quality Gates & Approval Points

| Checkpoint | Approval needed? | Approval mechanism |
|------------|------------------|---------------------|
| Phase 0 AJAE profile authored | ✅ Yes | User reviews proposed profile content, approves before write |
| Phase 1 Pre-Flight Report | ✅ Yes | User confirms manuscript + scope + flags match intent |
| Phase 2 desk review verdict | ❌ No (pipeline continues unless DESK REJECT) | User reads but no halt |
| Phase 3 spawn parallel referees | ❌ No (already approved via plan) | Auto-proceed if Phase 2 = SEND OUT |
| Phase 4 editorial synthesis | ❌ No | Auto-proceed |
| Phase 5 CoVe Post-Flight | ❌ No (mandatory by rule) | Auto-proceed |
| Phase 6 final summary | — | Output to user |

**Manual approval mode rule:** Phase 0 + Phase 1 are user-approval gates. Phases 2–6 run continuously per skill design once gates pass.

---

## Token / Time Budget

| Phase | Est. tokens | Est. wall-clock |
|-------|-------------|-----------------|
| 0 | ~3k | 15–20 min |
| 1 | <1k | 3 min |
| 2 | ~15k | 15–20 min (incl. WebSearch novelty probes) |
| 3 | ~40k (2 referees parallel) | 30–45 min |
| 4 | ~10k | 10–15 min |
| 5 | ~5k (forked verifier) | 10–15 min |
| 6 | ~2k | 5 min |
| **Total** | **~75k** | **~85–125 min** |

User estimate was 1–2h (60–120 min). Plan budget aligns ~85–125 min, slightly over high end due to AJAE profile authoring overhead.

---

## Decisions Requiring User Approval (BEFORE Phase 0 starts)

### D1. AJAE profile content (Phase 0)
Proposed in table above. **User confirm or edit:**
- (a) Approve as proposed
- (b) Edit specific fields (specify which)
- (c) Use stricter bar (treat AJAE as AER-equivalent — 0.05 acceptance rate, harder bar)
- (d) Use looser bar (treat AJAE as Food Policy + identification credibility — 0.20 acceptance rate)

### D2. §3-only scope mechanism (Phase 1)
- (a) ⭐ **Annotate full main.tex** — pass `paper/en/main.tex` + explicit instruction to referees ("§1/§5/§6 are TODO placeholders; evaluate §3 + online_appendix only; do NOT desk-reject for §1 placeholder")
- (b) Extract §3 to standalone — create temporary `paper/en/_section3_only.tex` for review-only (more isolation but cost: extra file maintenance)
- (c) Compile §3 alone — produce `_section3_only.pdf` (clean PDF reviewers see but requires §3 to be standalone-compilable; xr-hyper refs would break)

Recommendation: **(a)** — minimal infrastructure, referees can be instructed via the editor prompt. Skill design already supports scope instructions.

### D3. Novelty probe (Phase 2)
- (a) ⭐ **Default ON** (WebSearch novelty probes for the 3 AHM-separability claims) — mandatory CoVe Post-Flight in Phase 5 catches hallucinations
- (b) `--no-novelty-check` — skip WebSearch entirely (faster, offline-safe, but loses prior-work signal critical for AJAE editor decision)

Recommendation: **(a)** — α3 framework's contribution rests on "no one has tested separability rejection for Korean small farms". Novelty probe is exactly the load-bearing claim to stress-test. CoVe Post-Flight is fail-safe.

### D4. Referee disposition override mechanism (Phase 2 → 3)
- (a) ⭐ **Hard override** — editor explicitly assigns THEORY + CREDIBILITY/MEASUREMENT regardless of journal pool draw (user-requested specialties)
- (b) Soft override — editor draws from AJAE pool weights (CREDIBILITY 0.25, POLICY 0.25, MEASUREMENT 0.20, THEORY 0.10) but force "no SKEPTIC, no STRUCTURAL"
- (c) Pure pool draw — let editor draw freely

Recommendation: **(a)** — user specifically requested Theory + Empirical specialists. Pool draw would likely produce CREDIBILITY+POLICY or CREDIBILITY+MEASUREMENT, missing the Theory specialist who's most critical for §3 (closed-form derivations, CoVe 9/9 verification).

---

## Verification Checklist (post-Phase 6)

- [ ] All 5 output files exist in `quality_reports/peer_review_section3_alpha3/`
- [ ] CoVe Post-Flight PASS or PARTIAL with documented unverifiables (NOT silent FAIL)
- [ ] Editorial decision states explicit verdict + revised AJAE acceptance probability
- [ ] At least 3 actionable "Top concerns to address in §1 Abstract+Intro rewrite" surfaced
- [ ] No referee desk-rejected for §1 placeholder (scope instruction held)
- [ ] paper/en/main.tex + online_appendix.tex unchanged (read-only review, no edits applied)

---

## Out of Scope (explicit non-goals)

- ❌ §1 Abstract / Introduction rewrite — that's next session (option A)
- ❌ §5 Results / §6 Discussion rewrite — TODO placeholders, not in alpha test
- ❌ paper/ko/main.tex — CLAUDE.md rule: untouched until paper/en stabilizes
- ❌ Cross-artifact review — `--no-cross-artifact` flag, §3 is pure theory
- ❌ Code review (P3b-2 R scripts) — already covered by prior `/review-r` sessions; not in §3 alpha test scope
- ❌ `quality_score.py` quality gate — path bug `[LEARN:tooling]` 2026-05-14 precedent applies; substantive review supersedes
- ❌ Title rewrite — `[★ TODO]` line 4 placeholder, deferred to §1 rewrite session

---

## Next-session triggers (depending on Phase 6 SUMMARY recommendation)

- **If "ready for §1 rewrite":** Proceed to option A (§1 Abstract+Intro α3 rewrite, 4–6h next session).
- **If "§3 micro-revision first":** Plan §3 patch (target FATAL concerns only) → re-merge → then §1.
- **If "substantial revision":** Re-enter `/interview-me` for theoretical re-scope; reconsider AJAE direct cascade.

---

**END OF PLAN.** Awaiting Dohyeon approval on D1–D4 + overall plan. After approval: enter plan mode exit, save initial session log, begin Phase 0.
