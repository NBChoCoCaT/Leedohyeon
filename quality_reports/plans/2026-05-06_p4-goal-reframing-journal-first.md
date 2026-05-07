# Plan: P4 — Goal Reframing (Journal-First, Thesis-Chapter Compatible)

**Status:** COMPLETED (2026-05-06)
**Commit hash:** `bd7cdec75205eea97cc21a602160df5323fef766`
**Date:** 2026-05-06
**Branch:** main
**PhD path decision:** Option (2) Future thesis chapter (Korea University, advisor Lee Sangheon, currently enrolled)
**Working machine:** idoui-Macmini
**Sentinel filename:** `1-velvety-lynx.md` (harness-sticky from previous P0 session — P0 content preserved at sister `2026-05-06_p0-fix-rv2018-centering.md`); post-approval P4 sister: `2026-05-06_p4-goal-reframing-journal-first.md` (identical content)

---

## Context

The PIDPS DiD-RD project's primary deliverable is a single-author empirical paper for **AJAE → Food Policy → JAE** submission cascade, NOT a doctoral thesis. The current `CLAUDE.md` framing carries an implicit Korean-first / thesis-oriented bias from earlier setup phases that does not reflect this primary goal:

- Line 6 (`**Workflow:**`) says "Korean draft → English translation, 2-track" — mis-states the canonical direction.
- Line 16 Core Principle "Korean → English, never both at once" reinforces the Korean-first framing.
- Lines 127–131 (Current Project State) table shows "Korean draft v2 → English translation" as the next stage.

User has chosen PhD path **option (2): future thesis chapter** — primary track is journal submission, but `paper/ko/main.tex` is preserved as auxiliary deliverable serving (i) future PhD thesis chapter base, (ii) KAEA / 한국농경제학회 conference presentation. Theoretical generality (S,s lumpy investment, Caballero & Engel 1999) is maintained to support both venues.

This plan re-frames `CLAUDE.md` and adds a `[LEARN:goal]` entry to `MEMORY.md` capturing the direction + downstream implications. `step-3-3-prep.md` E-6/E-7 redefinition is **deferred to P2** (separate session) per user instruction.

---

## Scope

**Files modified (2):**

1. `CLAUDE.md` — 4 changes:
   - Line 6 (`**Workflow:**` header bullet): rewrite to English-canonical
   - Insert new `## Goal` section between line 9 (`---`) and line 11 (`## Core Principles`)
   - Line 16 (Core Principle "Korean → English, never both at once" bullet): rephrase to English-canonical
   - Lines 127–131 (`## Current Project State` table): re-order rows + rephrase Korean/English columns

2. `MEMORY.md` — append new section `## PIDPS Goal Reframing (2026-05-06, journal-first)` with one `[LEARN:goal]` entry (~12 lines as a single paragraph with lettered (a)–(e) subsections, matching project style).

**Files NOT modified (deferred to P2, or outside this plan's scope):**

- `quality_reports/specs/step-3-3-prep.md` — E-6/E-7 redefinition is P2 work, not P4.
- `.claude/agents/domain-reviewer.md` — Lens 5 E-6/E-7 anchor points unchanged here; P2 will update if needed after spec change.
- `.claude/rules/r-code-conventions.md` — Korean rename labels remain (still useful for `paper/ko/` auxiliary deliverable supporting thesis chapter + KAEA).

---

## Detailed Changes

### 1. `CLAUDE.md`

**(1) Line 6 — Workflow header bullet (rewrite):**

```diff
- **Workflow:** Korean draft (`paper/ko/`) → English translation (`paper/en/`), 2-track (no simultaneous edits)
+ **Workflow:** Canonical `paper/en/main.tex` (AJAE submission target); auxiliary `paper/ko/main.tex` derived post-stabilization (KAEA presentation + future thesis chapter base). Bootstrap once from existing Korean v1 (`master_supporting_docs/own_drafts/초안.md`).
```

**(2) New `## Goal` section — insert between line 9 (`---`) and line 11 (`## Core Principles`):**

```markdown
## Goal

Single-author empirical paper for international peer-review submission, with thesis-chapter compatibility maintained.

- **Primary track:** `paper/en/main.tex` — direct journal submission (AJAE → Food Policy → JAE).
- **Auxiliary track:** `paper/ko/main.tex` — derived from `paper/en/` post-stabilization. Dual purpose: (i) future PhD thesis chapter base (Korea University Dept. of Food and Resource Economics; advisor: Lee Sangheon; currently enrolled), (ii) KAEA / 한국농경제학회 conference presentation.
- **Bootstrap:** existing Korean v1 (`master_supporting_docs/own_drafts/초안.md`, 36 KB) → `paper/en/main.tex` (one-time port). After this, `paper/en/` is canonical; `paper/ko/` re-syncs from `paper/en/` once stable.
- **Replication standard:** AEA Data Editor checklist — full reproducibility package (`scripts/R/`, `_outputs/`, `data/var_dictionary.csv`, README) at first submission.
- **Theoretical generality:** maintained at general (S,s) lumpy-investment level (Caballero & Engel 1999) so the same identification supports both journal-article framing and future thesis-chapter expansion. Korean policy specifics (PIDPS, SFFP) live in identification + data sections, not in the theoretical core.
- **Paper length:** 30–50 pages (journal-article scale, AJAE ≤ 50 pages double-spaced including references). Robustness in online appendix; main text carries headline + 1–2 robustness hints only.

---
```

**(3) Line 16 — Core Principle bullet (rephrase):**

```diff
- - **Korean → English, never both at once** — stabilize argument in `paper/ko/`, then translate. Drift kills bilingual papers.
+ - **English canonical, paper/ko derived** — primary edits to `paper/en/main.tex`; `paper/ko/main.tex` re-syncs from `paper/en/` post-stabilization. Never simultaneous bilingual edits. Drift kills bilingual papers.
```

**(4) Lines 127–131 — Current Project State table (re-order + rephrase):**

```diff
- | Draft v1 (Korean) | NRD553 term paper (Spring 2026) | ✅ Complete (`master_supporting_docs/`) |
- | Replication baseline | Choi & Jodlowski (2025), Kirwan (2009) | ⏳ Pending |
- | Analysis pipeline | `scripts/R/01_clean.R` → `05_robust.R` | ⏳ Pending |
- | Korean draft v2 → English translation | `paper/ko/main.tex` → `paper/en/main.tex` | ⏳ Pending |
- | First submission target | AJAE | ⏳ Pending |
+ | Draft v1 (Korean) | NRD553 term paper (Spring 2026) | ✅ Complete (`master_supporting_docs/own_drafts/초안.md`) |
+ | Replication baseline | Choi & Jodlowski (2025), Kirwan (2009) | ⏳ Pending |
+ | Analysis pipeline | `scripts/R/01_clean.R` → `05_robust.R` | ⏳ Pending |
+ | **English draft v1** (primary, paper/en) | `paper/en/main.tex` (bootstrapped from Korean v1) | ⏳ Pending |
+ | Korean derived (auxiliary, paper/ko) | `paper/ko/main.tex` (re-synced from `paper/en/` post-stabilization; KAEA + thesis chapter) | ⏳ Deferred until paper/en stable |
+ | First submission target | AJAE | ⏳ Pending |
```

### 2. `MEMORY.md` — append new section + entry at end (after line 168)

```markdown

## PIDPS Goal Reframing (2026-05-06, journal-first)

[LEARN:goal] **PIDPS DiD-RD project reframed as journal-first with thesis-chapter compatibility (2026-05-06).** **(a) Direction.** Primary deliverable is `paper/en/main.tex` for AJAE → Food Policy → JAE submission cascade. Auxiliary `paper/ko/main.tex` derives from `paper/en/` post-stabilization, serving dual role as (i) PhD thesis chapter base (Korea University Dept. of Food and Resource Economics, advisor Lee Sangheon, currently enrolled), (ii) KAEA / 한국농경제학회 conference presentation. Bootstrap from `master_supporting_docs/own_drafts/초안.md` (Korean v1, 36 KB) → `paper/en/main.tex` is one-time; thereafter English is canonical. **(b) Infra implications.** `domain-reviewer.md` Lens 5 E-6/E-7 to be redefined as AJAE editor desk-review and AJAE/Food Policy referee perspectives respectively (P2 deliverable, not in this commit). Korean academic society perspective remains as auxiliary lens for `paper/ko/` review only. `r-code-conventions.md` §10 Korean rename labels still preserved (auxiliary deliverable supports thesis chapter and KAEA). **(c) Writing implications.** Target paper length 30–50 pages (journal-article scale) including all sections + bibliography, NOT 100+ pages (thesis-chapter scale). Tables: 4–6 main + 3–5 robustness; figures: 4–5 main + 2–3 supplementary. Cap rationale: AJAE ≤ 50 pages double-spaced including everything; Food Policy more flexible at 35–45 pages target. **(d) Robustness implications.** Online-appendix-targeted (alternative bandwidths beyond T1/T2/T3, weighting variants, McCrary density tests, placebo cutoffs, sgg_cd cluster robustness, heterogeneity 5 dim × 4 outcome = 20 tests). Main text carries headline 3-Tier + one or two robustness hints only. Theoretical framing maintained at general (S,s) lumpy-investment level (Caballero & Engel 1999) to support both journal-venue requirements AND future thesis-chapter expansion. **(e) Apply where.** Any plan/spec referencing target audience, paper length, robustness scope, or theoretical generality; any future Step 4 skill design (`/did-rd-analysis`, `/lumpy-investment-check`, `/translate-paper-ko-en`, `/agent-debate`); any `/review-paper --peer` invocation defaulting to AJAE/FP/JAE journal profile; future option-(3) "pure journal, no thesis" migration if needed.
```

---

## Verification Steps (post-edit, before commit)

1. **Old framing eliminated in CLAUDE.md:**
   - `grep -n "Korean → English, never both at once" CLAUDE.md` → 0 hits
   - `grep -n "Korean draft v2 → English translation" CLAUDE.md` → 0 hits
   - `grep -n "Korean draft.*English translation.*2-track" CLAUDE.md` → 0 hits in active body

2. **New sections present in CLAUDE.md:**
   - `grep -n "^## Goal$" CLAUDE.md` → exactly 1 hit
   - `grep -n "Primary track:" CLAUDE.md` → 1 hit (Goal section)
   - `grep -n "Auxiliary track:" CLAUDE.md` → 1 hit (Goal section)
   - `grep -n "English canonical, paper/ko derived" CLAUDE.md` → 1 hit (Core Principle)
   - `grep -c "paper/en" CLAUDE.md` → expect ≥ 6 (Goal section, Core Principle, table, etc.)

3. **MEMORY.md size cap:** `wc -l MEMORY.md` → expect ~170–172 (current 168 + 3 new lines: blank line + section header + entry paragraph). Below 200-line cap.

4. **MEMORY.md entry present:**
   - `grep -c "^\[LEARN:goal\]" MEMORY.md` → exactly 1
   - `grep -c "## PIDPS Goal Reframing" MEMORY.md` → exactly 1

5. **Files NOT modified — stay clean:**
   - `git diff --name-only` should NOT include: `quality_reports/specs/step-3-3-prep.md`, `.claude/agents/domain-reviewer.md`, `.claude/rules/r-code-conventions.md`

6. **Plan sister file diff:** copy plan content to `quality_reports/plans/2026-05-06_p4-goal-reframing-journal-first.md`, then `diff 1-velvety-lynx.md 2026-05-06_p4-goal-reframing-journal-first.md` → 0 differences.

7. **Git diff stat:** `git diff --stat` → exactly 2 source files changed (CLAUDE.md, MEMORY.md).

---

## Commit Message (option B — detailed, replication audit-trail)

```
docs(goal): reframe project as journal-first with thesis-chapter compatibility

PhD path decision (2026-05-06): option (2) Future thesis chapter.

- Primary deliverable: paper/en/main.tex for AJAE → Food Policy → JAE
  submission cascade (single-author).
- Auxiliary deliverable: paper/ko/main.tex, derived from paper/en/
  post-stabilization. Dual purpose:
  (i) future PhD thesis chapter base (Korea University Dept. of Food
      and Resource Economics; advisor Lee Sangheon; currently enrolled),
  (ii) KAEA / 한국농경제학회 conference presentation.
- Bootstrap: master_supporting_docs/own_drafts/초안.md (Korean v1, 36 KB)
  → paper/en/ (one-time port). Thereafter paper/en/ is canonical;
  paper/ko/ re-syncs from paper/en/ when stable.
- Theoretical generality maintained at general (S,s) lumpy-investment
  level (Caballero & Engel 1999) to support both journal-article
  framing and future thesis-chapter expansion.
- Paper length target: 30–50 pages (journal-article scale, AJAE
  ≤ 50 double-spaced pages including refs), NOT 100+ pages
  (thesis-chapter scale). Robustness in online appendix.

Files updated:
- CLAUDE.md (4 changes):
  * Workflow header bullet rewritten (Korean→English direction
    inverted to English-canonical with paper/ko auxiliary)
  * New ## Goal section inserted between header and Core Principles
  * Core Principle "Korean → English, never both at once" rephrased
    to "English canonical, paper/ko derived"
  * ## Current Project State table re-ordered (paper/en primary row
    promoted, paper/ko relabeled as auxiliary deferred-until-stable)
- MEMORY.md (+1 section, +1 entry):
  * New section ## PIDPS Goal Reframing (2026-05-06, journal-first)
  * [LEARN:goal] entry: direction (a), infra implications (b),
    writing implications (c), robustness implications (d), apply
    where (e)

Deferred to P2 (separate session, not in this commit):
- step-3-3-prep.md E-6/E-7 redefinition as AJAE editor desk-review
  and AJAE/Food Policy referee perspectives.
- domain-reviewer.md Lens 5 E-6/E-7 anchor updates if needed after
  P2 spec change.

This unblocks all subsequent work (P1 R migration, P2 placeholders,
P3 outlier policy) by clarifying the primary audience (AJAE editor +
referees) and venue-specific length/robustness constraints.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

---

## Post-Approval Execution Order

1. Mark this plan **APPROVED** (status header in plan file).
2. Apply 4 Edit operations on `CLAUDE.md`:
   - (a) Line 6 Workflow bullet rewrite
   - (b) Insert new `## Goal` section after line 9 `---`
   - (c) Line 16 Core Principle bullet rephrase
   - (d) Lines 127–131 Current Project State table re-order
3. Apply 1 Edit operation on `MEMORY.md` (append new section + `[LEARN:goal]` entry at end).
4. Run all 7 verification steps. Halt and report any failure.
5. Create sister plan file `quality_reports/plans/2026-05-06_p4-goal-reframing-journal-first.md` via `cp` of sentinel; `diff` to confirm identical (per `[LEARN:harness]`).
6. `git add CLAUDE.md MEMORY.md` (plan files gitignored — not added).
7. `git commit` with the option-B message above.
8. `git push origin main` (auth now configured per previous session).
9. `git log -1 --format=%H` → record new commit hash; `git status` → confirm clean + sync with origin.
10. Update plan-file status to **COMPLETED** + record commit hash. Sync sister file (`cp` sentinel → sister, then `diff`).

---

## Files Cross-Reference

- `CLAUDE.md` — lines 1–9 (header), 11–18 (Core Principles), 127–131 (Current Project State) are modification targets
- `MEMORY.md` — end-of-file (line 168+) is append target for new `## PIDPS Goal Reframing` section + `[LEARN:goal]` entry
- `quality_reports/specs/step-3-3-prep.md` — E-6/E-7 redefinition deferred to P2 (separate session)
- `.claude/agents/domain-reviewer.md` — Lens 5 anchor updates deferred to P2
- `.claude/rules/r-code-conventions.md` — Korean rename labels preserved (paper/ko auxiliary support)
- `master_supporting_docs/own_drafts/초안.md` — Korean v1 source for paper/en bootstrap (one-time port)
- `quality_reports/plans/2026-05-06_p0-fix-rv2018-centering.md` — preserved P0 sister; previous sentinel content survives there in full
