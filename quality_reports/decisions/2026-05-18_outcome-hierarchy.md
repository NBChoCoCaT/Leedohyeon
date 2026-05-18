# ADR-0002: Outcome Hierarchy — `area_own` Promoted to Primary #1

**Status:** ACCEPTED
**Date:** 2026-05-18
**Context:** `/interview-me` session — direct consequence of the α-strict scope decision in [ADR-0001](2026-05-18_theoretical-scope.md). Under α3, the empirical outcome hierarchy of the paper must realign to match what the AHM extensions actually predict.

## Problem

Under the previous "tenant-driven three-channel" framing (CLAUDE.md, P3b-2), the empirical outcome hierarchy was:
- Headline: `rent_cost` (−11.1% capitalization reversal vs. Kirwan/Ciaian);
- Primary behavioral: `op_cost_ex_rent` (S,s inaction);
- Heterogeneity: tenant-share gradient in `area_total`, `area_own`.

Under α3 (Carter-Olinto wealth-biased liquidity + Kazukauskas + Eswaran-Kotwal), the theory predicts:
- `area_own ↑` with monotone gradient in baseline tenancy share (Carter-Olinto, primary);
- `op_cost_ex_rent` adjustment (Kazukauskas-style decoupling-disinvestment, primary);
- `off_farm_income` reallocation (Eswaran-Kotwal, auxiliary);
- `unit_rent_price ↓` and `rent_cost ↓` are NOT model-internal — they are aggregate-equilibrium implications via incidence theory.

The hierarchy must change accordingly, but the change has implications for abstract, introduction, results section ordering, and quality-gate verification (which numeric claims are load-bearing for headline contribution).

## Options considered

### Option A: Retain rent-capitalization headline; relegate AHM outcomes to "additional evidence"

Keep `rent_cost` −11.1% as the lead empirical result; present `area_own` and `op_cost` as supporting heterogeneity / robustness.

**Pro:** Preserves the AJAE-grade contribution claim from P3b-2 (reversing Ciaian 2023 EU consensus).
**Con:** Empirical headline does not match §3 theory under α3; reads as "theory introduced for show, results are about rent." Referee inconsistency flag almost certain.

### Option B: Promote `area_own` to primary #1; demote rent outcomes to B.1 ex-theory

Reorder all reporting so that `area_own` (and its monotone gradient) leads, `op_cost_ex_rent` (capital adjustment) follows, `off_farm_income` is auxiliary, and `unit_rent_price` / `rent_cost` are reported as ex-theory implications consistent with the incidence-equilibrium logic.

**Pro:** Empirical hierarchy aligns 1:1 with §3 theory; headline (separability rejection via tenure-mode pivot) follows from H1 directly; no incoherence between theory and results.
**Con:** Loses the "−11.1% reversing EU consensus" headline; abstract and intro need full rewrite; the most-empirically-novel finding becomes a secondary result.

### Option C: Two-headline structure — separability test (theory) + rent reversal (empirical)

Frame the paper with two parallel headlines: §3 theory test (H1 area_own gradient) AND §5 rent-capitalization reversal as standalone empirical contribution.

**Pro:** Captures both signals.
**Con:** Violates one-paper-one-contribution norm; abstract becomes two-sentence-stack; AJAE associate editor likely treats this as a "split into two papers" request.

## Decision

**Chose:** Option **B** — `area_own` primary #1, `op_cost_ex_rent` primary #2, `off_farm_income` auxiliary, `unit_rent_price` / `rent_cost` ex-theory implications.

**Rationale:** Under α-strict (ADR-0001), the theory dictates the hierarchy. Keeping `rent_cost` as the empirical headline while §3 derives only `area_own` and `op_cost` would create the very theory-data incoherence the α-strict choice was designed to eliminate. Option B accepts the loss of one rhetorically attractive headline in exchange for full theory-empirics coherence — which is the correct trade for an AJAE submission whose contribution is *the separability test*, not the incidence reversal. The rent results survive as B.1 evidence reported alongside, and a properly written §5 can flag the unit_rent finding as "an aggregate-equilibrium correlate consistent with our micro mechanism" without claiming it as the headline.

## Consequences

- **Abstract and §1 introduction** must be rewritten with `area_own` monotone gradient as the lead finding; the contribution one-liner is **C2** from the interview ("we reject AHM separability for Korean small farms").
- **§5 Results** subsection ordering: §5.1 `area_own` (gradient + main effect), §5.2 `op_cost_ex_rent`, §5.3 `off_farm_income`, §5.4 ex-theory `unit_rent` / `rent_cost`.
- **Quality-gate load-bearing claims** shift: tolerance checks on `area_own` ATT and the `own_share` quintile gradient now drive the score; `rent_cost` −11.1% remains but is no longer "headline" for tolerance purposes.
- **Falsification predictions** (F1 + F2 in the spec) tied directly to the primary outcomes; F1 ("flat or pure-owner-positive `area_own` gradient") becomes the most consequential null result.
- **P3b-2 session log** (`2026-05-17_p3b-2.md`) framing language remains valid as the empirical input but its "three-channel tenant-driven land transition" narrative is **not** the paper's contribution narrative going forward; it was an intermediate analytical lens.
- Future paper revisions: any introduction draft that leads with the rent reversal needs to be flagged and rewritten.

## Rejected alternatives — why not

- **A.** Theory-data incoherence (§3 derives `area_own`, abstract leads with `rent_cost`) is exactly the kind of structural defect that triggers desk-reject under a hostile-editor stress test (see `.claude/skills/review-paper` `--peer --stress`).
- **C.** AJAE one-paper-one-contribution norm makes two-headline framing high-risk; the "split this into two papers" rejoinder is a known mode-of-rejection. Better to commit to one contribution cleanly and let the second result be its own future paper if it merits one.
