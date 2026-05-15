# Plan — §3 Precision Rewrite via skill cascade (/validate-bib + /verify-claims + /econ-write + manual KR translation)

**Status:** APPROVED (Dohyeon, 2026-05-15)
**Date:** 2026-05-15 (Session 5 — after PR #3 merge `0bd8909`)
**Author:** Lee Dohyeon (Claude assist)
**Sister (post-approval):** `01_dissertation_PBDP/quality_reports/plans/2026-05-15_section3-precision-rewrite.md`
**Mode:** manual approval, plan-first; user invokes `/commit` after implementation

---

## Context

PR #3 (`0bd8909`, 2026-05-15) merged §3 bootstrap (paper/en + paper/ko) with 11 TENTATIVE bib entries and Scenario β framing. User now requests a **precision-rewrite cascade** invoking the project's skill infrastructure that was under-utilized in the bootstrap session: 정밀 citation verification, 영문 prose 학술적 품질 향상, 일관된 한국어 재번역.

Skill availability discovered this session:
- ✓ `/validate-bib` (project-local, `.claude/skills/validate-bib/`)
- ✓ `/verify-claims` (project-local, `.claude/skills/verify-claims/`)
- ✓ `/econ-write` (user-global, `~/.claude/skills/econ-write/`) — user-invocable via explicit `/<name>` invocation
- ✗ `/translate-paper-ko-en` (CLAUDE.md "Step 4 TBC" — does not exist)

User-locked decisions (resolved via AskUserQuestion):
- **Translation:** Option (c) — manual rewrite by Claude, consistent with prior session style
- **Bib gate:** Both `/validate-bib --semantic` AND `/verify-claims` (complementary; recommended)

## Out of scope

- §1 Introduction (deferred next session)
- §2/§4–§9 stubs (no rewrite; only §3 is targeted)
- `/translate-paper-ko-en` skill construction (deferred — manual translation this session)
- `.claude/references/policy-glossary-ko-en.md` (Step 5 deliverable, not blocking §3 which is theory-side)
- §3.6bis hazard model (P3c S2 deferred)

## Implementation: 5 phases, ~2.5h wall-clock

### File-by-file changes

| Path | Action | Notes |
|---|---|---|
| `Bibliography_base.bib` | EDIT (corrections) | DOI fixes / vol-issue-pages / title corrections from /validate-bib + /verify-claims |
| `paper/en/main.tex` | EDIT (§3 prose) | `/econ-write` style pass on §3.1–§3.11; citation corrections; equation flow tightening |
| `paper/ko/main.tex` | REWRITE §3 | Manual retranslation reflecting improved English §3; preserve §1/§2/§4–§9 stubs |
| `paper/en/main.pdf` + `paper/ko/main.pdf` | RECOMPILE | latexmk -xelatex (runtime) |
| `quality_reports/plans/2026-05-15_section3-precision-rewrite.md` | CREATE (sister) | identical to this plan |
| `quality_reports/session_logs/2026-05-15_section3-precision-rewrite.md` | CREATE | incremental log |

### Phase 1 — Bibliography verification + corrections (~45min)

**1a. `/validate-bib --semantic Bibliography_base.bib`** (~15min)

Skill scope per `.claude/skills/validate-bib/SKILL.md`:
- Structural: missing/unused entries, malformed fields
- Semantic (`--semantic`): citation-drift detection, DOI verification, style consistency

Expected output: per-entry verdict + correction proposals. Save to `quality_reports/verification/2026-05-15_validate-bib-output.md` (or skill's default location).

**1b. `/verify-claims paper/en/main.tex`** (~20min)

Skill scope per `.claude/skills/verify-claims/SKILL.md`:
- Chain-of-Verification (CoVe) loop, Dhuliawala et al. 2023
- Spawns `claim-verifier` agent in forked context (architectural independence)
- Extracts claims: citations, numerical facts, named entities, dataset claims
- Reports: supported / contradicted / unverifiable per claim

Optional `--source` flag: I can pass publisher TOCs or DOI URLs as explicit sources for the 11 citations. Default mode infers sources from context — sufficient for this pass.

**1c. Apply corrections** (~10min)

Manual editing of `Bibliography_base.bib` + `paper/en/main.tex` based on (1a) and (1b) findings:
- Wrong volume/issue/page → fix
- Wrong title phrasing → fix
- Wrong journal name → fix (e.g., AJAE vs Agricultural Economics for Kazukauskas)
- Missing DOI → add (if /validate-bib --semantic found one)
- Citation attribution errors in §3 prose → fix

Per MEMORY `[LEARN:citation-verification]` 2026-05-06: 11% error rate observed previously. Expect 1–2 corrections in 11 entries.

### Phase 2 — English §3 prose improvement via `/econ-write` (~45min)

Invoke `/econ-write` via Skill tool. Argument: `"rewrite §3 of paper/en/main.tex for clarity, concision, and AJAE-grade prose. Preserve all equations and Predictions verbatim; preserve Scenario β framing in §3.8."`

`/econ-write` SKILL.md scope (synthesizes Cochrane / McCloskey / Shapiro / Head / Bellemare guidance):
- Reader-first ordering (newspaper style)
- Active voice, present tense
- Cut every unnecessary word
- Concrete > abstract
- One central contribution maintained throughout
- Notation consistency

Expected output: rewrite proposals or full edited §3 block. Apply selectively (don't overwrite Scenario β framing, don't change equations).

### Phase 3 — Korean §3 manual retranslation (~45min)

After Phase 2 stabilizes paper/en §3, manually rewrite paper/ko §3 with the following discipline:

**Terminology consistency (academic Korean):**
- separability theorem → 분리성 정리
- (S,s) inaction region → (S,s) 비활동 영역
- per-farm flat-rate → 농가별 정액제
- Nash bargaining → 내쉬 협상
- precautionary labor → 예방적 노동공급
- consumption smoothing → 소비 평활화
- exit deterrence → 이탈 억제
- selection share → 선택 효과 비중
- supplementary robustness anchor → 보조적 견고성 앵커
- monotone gradient → 단조 그라디언트
- directional consistency → 방향성 일관성
- statistically null → 통계적으로 무의미한
- pure tenant / pure owner → 순임차인 / 순자작농
- Prediction → 예측 (theorem-like environment, already in preamble_ko.tex)

**Style:**
- Korean academic register (-다 종결, formal)
- Equations preserved identical
- Subsection structure preserved (§3.1–§3.11 with §3.7.1–§3.7.3)
- §1/§2/§4–§9 stubs preserved unchanged (do NOT touch)

**Diff target:** ~80–90% of §3 in paper/ko will change. paper/en §3 content carried through verbatim where translation is mechanical; selectively rewritten where Phase 2 improved English clarity.

### Phase 4 — Recompile + verify both PDFs (~15min)

```bash
cd paper/en && latexmk -xelatex -interaction=nonstopmode main.tex 2>&1 | tail -10
cd ../ko    && latexmk -xelatex -interaction=nonstopmode main.tex 2>&1 | tail -10
```

Expected:
- paper/en/main.pdf: ≥14 pages, 0 undefined citations
- paper/ko/main.pdf: ≥13 pages, 0 undefined citations, no missing-character warnings

### Phase 5 — Session log + present (~10min)

Session log: completion summary + corrections applied (1c findings) + prose improvements (Phase 2 summary) + Korean retranslation notes.

Present to user: side-by-side diff or PDF comparison. NO auto-commit per 수동 승인 모드.

## Verification

```bash
# 1. Bib corrections applied
grep -c "^@\(article\|book\)" Bibliography_base.bib    # Expect: 11
grep -c "doi" Bibliography_base.bib                     # Expect: ≥ 10 (most entries)

# 2. Both PDFs compile
test -f paper/en/main.pdf && test -f paper/ko/main.pdf && echo "PDFs OK"

# 3. Zero undefined citations
grep -c "Undefined" paper/en/main.log paper/ko/main.log    # Expect: 0 0

# 4. §3 subsection parity preserved
grep -c "^\\\\subsection" paper/en/main.tex paper/ko/main.tex
# Expect: 11 11

# 5. Sister plan parity
diff /Users/leedo/.claude/plans/inherited-knitting-sutton.md \
     quality_reports/plans/2026-05-15_section3-precision-rewrite.md   # Expect: empty
```

## Decision gate after this plan

1. User reviews `paper/en/main.pdf` + `paper/ko/main.pdf`.
2. User reviews `Bibliography_base.bib` corrections.
3. Decide:
   - Proceed to **§1 Introduction draft** next session (per plan A trajectory)
   - Refine §3 further
   - Build `/translate-paper-ko-en` skill as Step 4 infrastructure (deferred this session)

## Risks & mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| `/validate-bib --semantic` requires network (DOI lookup) | Medium | If offline, skill should fall back to structural checks only; flag in output |
| `/verify-claims` flags many TENTATIVE entries as "unverifiable" without explicit `--source` | High | First pass without `--source` is fine — establishes baseline; high "unverifiable" rate is informative, not blocking |
| `/econ-write` rewrites too aggressively, breaks Scenario β framing or equation flow | Medium | Invoke with explicit preservation directive in argument; apply suggestions selectively |
| Korean translation introduces drift from English §3 (e.g., different sub-claim emphasis) | Medium | Side-by-side write: improve English first (Phase 2), then translate (Phase 3); minimize independent Korean changes |
| paper/ko/main.tex stub sections (§1/§2/§4–§9) accidentally modified | Low | Edit only inside `\section{이론적 틀}` ... `\section{자료}` boundary; verify with grep before commit |
| LaTeX compile fails after corrections (e.g., changed citation key in bib but not in main.tex) | Medium | Always recompile both PDFs in Phase 4; fix forward |
| Skill outputs (validate-bib, verify-claims reports) clutter quality_reports/ | Low | Save under `quality_reports/verification/2026-05-15_<skill>-output.md` consistent naming |
| Quality gate false positives on edited main.tex | High | Override per MEMORY `[LEARN:tooling]` 2026-05-14 precedent (already in prior PR #3 commit body) |

## Approval gate

On ExitPlanMode approval:
1. Mark plan APPROVED in this file + create sister.
2. Create session log + initial entry.
3. Phase 1: invoke `/validate-bib --semantic` then `/verify-claims paper/en/main.tex` via Skill tool. Apply corrections.
4. Phase 2: invoke `/econ-write` via Skill tool with §3-scoped argument. Apply.
5. Phase 3: manual Korean retranslation in paper/ko/main.tex §3.
6. Phase 4: recompile both PDFs, verify.
7. Phase 5: update session log + present.
8. **NO auto-commit** (manual approval mode). User invokes `/commit` separately.

**Total wall-clock estimate: ~2.5h** (Phase 1 ~45min + Phase 2 ~45min + Phase 3 ~45min + Phase 4 ~15min + Phase 5 ~10min).
