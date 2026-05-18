# Claim Verification Report (CoVe Post-Flight)

**Verifier:** Independent claim-verifier subagent (context-forked; has not seen `desk_review.md`, `editorial_decision.md`, or referee reports).
**Protocol:** `.claude/agents/claim-verifier.md` (Dhuliawala et al. 2023 CoVe independence trick).
**Claims reviewed:** 3
**Date:** 2026-05-18

---

## Verification outcome

**PARTIAL** — 2 of 3 claims (C2, C3) verified `yes`; 1 claim (C1) verified `partial` — the article and identifier exist exactly as claimed and use spatial RD, but the substantive subject is **Swiss** direct payments, not **EU** direct payments. (Switzerland is not an EU member; its direct-payment system is a parallel national program.) Not a hallucination of identifier, but a substantive geographic mismatch.

No hard `no` findings. No `cannot-verify` findings.

---

## Per-claim findings

| ID | Claim (extracted) | Independent answer | Evidence | Match? |
|----|-------------------|--------------------|----------|--------|
| C1 | A paper in *Q Open* with article identifier `qoac024` uses spatial RD to study EU direct payments to farmers. | Article **exists** at this exact identifier. Title: "Direct payments and on-farm employment: Evidence from a spatial regression discontinuity design." Authors: **Franziska Zimmert and Alexander Zorn**. Published 2022 (vol. 3, issue 3) in *Q Open*. Methodology: spatial regression discontinuity, correctly identified. **Subject: Swiss direct payments, not EU.** Switzerland is not an EU member state; the Swiss direct-payment system is a separate national program, though structurally analogous to the EU CAP. | https://academic.oup.com/qopen/article/3/3/qoac024/6678449 — direct WebFetch returned title, authors, methodology ("spatial RD design"), and confirmed Swiss (not EU) setting. | **partial** |
| C2 | A paper in MDPI *Sustainability* (2020) studies productivity effects of Korean agricultural direct payments. | Article **exists**: "Effects of Government Payments on Agricultural Productivity: The Case of South Korea" — MDPI *Sustainability* 2020, vol. 12, issue 9, article 3505. Uses Korean Farm Household Economy Survey panel; productivity measured via control-function approach; effect of direct payments estimated via propensity score matching. Subject and journal/year match the claim exactly. (Direct WebFetch returned 403; identification confirmed via WebSearch returning the article URL with title, journal, year, methodology summary, and matching subject.) | https://www.mdpi.com/2071-1050/12/9/3505 — title, journal, 2020, Korean farm-level panel, direct-payment productivity effects all match. | **yes** |
| C3 | NBER working paper w31932 by Ghatak and Mookherjee (2024) revisits the Eswaran-Kotwal supervision channel. | Paper **exists** at exactly this NBER number. Title: "Revisiting the Eswaran-Kotwal Model of Tenancy." Authors: **Maitreesh Ghatak and Dilip Mookherjee** (correct). Issue date: **December 2023** as NBER WP w31932; subsequently published 2024 in *Studies in Microeconomics* vol. 12(1) pp. 32–58. Subject: directly engages Eswaran-Kotwal framework (sharecropping persistence + productivity effects of tenancy regulation) — note the framing is **"tenancy model"** rather than "supervision channel" specifically, but Eswaran-Kotwal 1985/1986 is the same framework regardless of which channel one emphasizes. | https://www.nber.org/papers/w31932 (WebFetch direct hit) + https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4660257 + https://people.bu.edu/dilipm/publications/EswKot24pub.pdf | **yes** |

---

## Discrepancies requiring regeneration

### C1 — Geographic mismatch (Swiss vs EU)

- **Claim text:** "EU direct payments to farmers"
- **Reality:** Swiss direct payments. Switzerland is not in the EU; its direct-payment system was established under the 1996 federal agricultural policy reform and operates independently of CAP, though structurally analogous (per-hectare and ecological/structural top-ups).
- **Severity:** Substantive but small. The methodological relevance to the Korean PIDPS paper (a national per-farm flat-rate scheme using a cutoff design + spatial/area-based identification) likely survives the EU→Swiss correction — arguably the Swiss case is more directly comparable to Korea than EU CAP precisely because both Switzerland and Korea use national (non-supranational) direct-payment systems for small-structured agriculture. The cross-citation is still defensible; the editor's geographic label needs correction.
- **Recommended action for desk_review.md:** If the novelty paragraph asserts "EU direct payments," replace with "Swiss direct payments" (and consider noting that the Swiss case may in fact be a closer analog to the Korean PIDPS than EU CAP).

### C2, C3 — None

Both citations check out at the identifier level and at the substantive-content level. The C3 framing as "supervision channel" vs the paper's actual framing as "Eswaran-Kotwal model of tenancy" is a minor framing difference, not a discrepancy — Eswaran-Kotwal 1986 is the foundational supervision/tenancy paper, and Ghatak-Mookherjee 2023 (NBER) / 2024 (journal) engage exactly that framework.

---

## Cannot-verify

None. All three identifiers resolved to actual papers.

(Note: C2 had a 403 on direct WebFetch of the MDPI page, but WebSearch results returned the article URL, title, journal+volume+issue, year, methodology, and matching subject in a way that triangulates the claim sufficiently without the direct fetch. Recording as `yes` rather than `cannot-verify`.)

---

## Tool notes

- **WebSearch + WebFetch combination worked as designed:** the high-specificity identifiers (qoac024, w31932, MDPI sustainability/12/9/3505) all resolved to real articles. No identifier-level hallucinations.
- **Geographic substitution (EU vs Swiss) is the kind of error WebSearch is most likely to introduce** — the EU CAP literature dominates the spatial-RD-on-direct-payments search space, so a search snippet about a Swiss paper can easily be paraphrased into "EU" by an upstream agent. This is a worth-flagging pattern for future novelty-probe runs.

---

## Cross-reference

- Protocol: `.claude/agents/claim-verifier.md` (Step 4 template).
- Calling rule: `.claude/rules/post-flight-verification.md` (if invoked).
- Originating skill: `/verify-claims` (CoVe wrapper).
