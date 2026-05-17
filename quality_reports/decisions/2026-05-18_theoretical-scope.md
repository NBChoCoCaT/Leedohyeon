# ADR-0001: Theoretical Scope — α-Strict AHM Extensions + Combo α3 + B.1

**Status:** ACCEPTED
**Date:** 2026-05-18
**Context:** `/interview-me` session preparing the new §3 theoretical framework plan, superseding the 5-channel + Step-k build-up structure of plan `2026-05-15_section3-chain-restructure-appendix-a.md`.

## Problem

The previous §3 framework drew on heterogeneous theoretical traditions — Caballero-Engel (1999) macro lumpy investment, Sandmo (1971) risk theory, Blundell-Pistaferri (2003) consumption smoothing, Banerjee-Ghatak (2002) tenancy contracts, Kirwan (2009) rent incidence, in addition to AHM (Singh-Squire-Strauss 1986). This produced a 5-channel framework that, while empirically motivated, lacked theoretical cohesion: the channels did not share a single backbone, and each required separate justification from a different literature. The contribution one-liner was unclear. Decide (a) the scope of literature admissible for citation in §3, (b) which AHM-extension non-separabilities to adopt, and (c) how to handle the empirical rent-capitalization finding given the theoretical framework.

## Options considered

### Option A: β (broad) — Any farm-household behavioral model + incidence theory

Keep the existing 5-channel structure, allowing macro-lumpy-investment, risk theory, consumption smoothing, tenancy-contract, and incidence-theory citations.

**Pro:** Preserves all P3b-2 empirical findings as model-internal predictions; matches "tenant-driven three-channel" framing in CLAUDE.md.
**Con:** No single theoretical backbone; structure is reverse-engineered from data; fragmentation; AJAE referee would ask "what's the model?"

### Option B: α (narrow) — Singh-Squire-Strauss / dJFS AHM-extension papers only

Restrict §3 citations to papers that explicitly extend the AHM utility-max framework with one or more market failures.

**Pro:** Single backbone (AHM); cohesive narrative; aligns with the 1-tier separability-test literature (Benjamin 1992; LaFave-Thomas 2016).
**Con:** Eliminates Kirwan/Ciaian/Banerjee-Ghatak — these are not AHM extensions strictly — so the rent-capitalization headline finding loses its theoretical home.

### Sub-option for B: Combo selection (α1 / α2 / α3)

Within α, three plausible primary+auxiliary combinations exist:
- **α1.** Primary = Carter-Olinto liquidity; Auxiliary = Pitt-Khandker credit-investment.
- **α2.** Primary = Carter-Olinto liquidity; Auxiliary = Benjamin separability test.
- **α3.** Primary = Carter-Olinto + Kazukauskas 2013 wealth-biased liquidity; Auxiliary = Eswaran-Kotwal supervision-cost labor.

### Sub-option for B: Bargaining-margin handling (B.1 / B.2)

If α is adopted, the observed `unit_rent_price ↓` (P3b-2 (i) channel) is not an α-internal prediction. Two responses:
- **B.1.** Demote `unit_rent_price` to **ex-theory aggregate implication** (Floyd 1965 / Alston-James 2002 incidence theory applied externally), report as reduced-form evidence consistent with the model but not derived from it.
- **B.2.** Loosen α to "ε-α" allowing Floyd-Alston-James incidence as a closure step on top of AHM.

## Decision

**Chose:** Option **B (α-strict) + Combo α3 + B.1**.

**Rationale:** The defining methodological move is to deliver a **policy-induced AHM separability test** with the cleanest possible theoretical pedigree. α-strict guarantees the §3 backbone is single-sourced and the contribution one-liner can be written without hedging. Within α, the **α3** combination uniquely fits Korea: Carter-Olinto wealth-biased liquidity + Kazukauskas decoupled-subsidy-disinvestment together predict (a) monotone tenancy-share gradient in `area_own` (the empirical signature in P3b-2) and (b) capital-adjustment under credit constraint, while Eswaran-Kotwal supervision adds an auxiliary labor margin without competing with the primary. B.1 keeps the rent-capitalization result as reduced-form evidence — empirically reported, theoretically demoted — preserving the −11.1% pass-through finding while not over-claiming theoretical novelty on incidence.

## Consequences

- §3 is rewritten on a single AHM backbone with two non-separabilities (wealth-biased liquidity primary, supervision-cost auxiliary). Approximate length: 3–4 main-text pages.
- Citation list shrinks substantially: AHM (Singh-Squire-Strauss 1986), dJFS (1991), Carter-Olinto (2003 AJAE), Kazukauskas (2013 AJAE), Eswaran-Kotwal (1986 EJ), Benjamin (1992 ECMA), LaFave-Thomas (2016 ECMA), Pitt-Khandker (1998 JPE), Foster-Rosenzweig (1995 JPE) — plus Floyd 1965 / Alston-James 2002 cited only as the incidence-closure step for the rent result (B.1 disclosure).
- Caballero-Engel (1999), Sandmo (1971), Blundell-Pistaferri (2003), Banerjee-Ghatak (2002), Abel-Eberly (1994), Cooper-Haltiwanger (2006), Khan-Thomas (2008) — these bib entries remain in `Bibliography_base.bib` (already added 2026-05-15) but are **not cited in §3 of the revised paper**. They may still be cited in §6 Discussion or §7 Conclusion as related literature, but no longer carry theoretical-backbone weight.
- New bib entries needed: Eswaran-Kotwal (1986 EJ), Benjamin (1992 ECMA), LaFave-Thomas (2016 ECMA), Pitt-Khandker (1998 JPE), Foster-Rosenzweig (1995 JPE). Floyd 1965, Alston-James 2002 already exist.
- B.1 disclosure paragraph in §3.4 must be written carefully to avoid the appearance that the theory derives `unit_rent ↓` — it does not.

## Rejected alternatives — why not

- **A (β, broad).** Sunk-effort preservation of the 5-channel structure does not outweigh the lack of a coherent backbone. The 2026-05-15 plan's "build-up table" papered over this with structural language but did not resolve the underlying citation heterogeneity.
- **Combo α1.** Pitt-Khandker as auxiliary creates two credit-related channels (Carter-Olinto + Pitt-Khandker), which double-counts the credit imperfection and provides no separate test margin. α3 keeps liquidity and labor as **independent margins**, giving (H1, H2) and (H3) as two genuine tests of the separability null.
- **Combo α2.** Benjamin as auxiliary turns the auxiliary into a methodological mirror rather than an independent test. Useful for robustness but does not enrich the empirical prediction set.
- **B.2 (ε-α loosening).** Once Floyd-Alston-James are admitted as part of §3 theory, the slippery slope back to β is hard to control. B.1 enforces a clean distinction between "model-internal prediction" and "aggregate-equilibrium implication" — a distinction that referees will appreciate.
