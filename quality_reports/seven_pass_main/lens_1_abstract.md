# Lens 1 (Abstract audit) — Seven-Pass Review

**Date:** 2026-05-18
**Manuscript:** paper/en/main.tex (lines 38–41)
**Lens:** Abstract audit
**Score:** 7.5/10

## CRITICAL issues

None. The abstract compiles cleanly, the headline AHM-separability rejection is stated in italics, the magnitude calibration anchor (T_SFFP/τ ∈ [0.024, 0.048]) matches §3.4.1 exactly, and the F1/F2 + ADR-0001/0002 pre-registration is delivered with an honest "informative-not-rejecting" framing for F2 (load-bearing F1 framing is locked at line 254). Nothing here would trigger desk-rejection at AJAE.

## MAJOR issues

**M1 (structure / first sentence).** The opening sentence is a *method+setting* declaration ("We test the AHM separability null at the 0.5 ha eligibility cutoff …"), not a *question*. AJAE referees following Cochrane / McCloskey writing canon expect Q-then-A. Suggest opening with one declarative question (e.g., "Does the Agricultural Household Model's separability null hold for Korean smallholders at a per-farm flat-rate direct-payment cutoff?") and moving the SFFP-distinct-from-US/EU clause to sentence 2. The §1 ¶1 closing already does the question framing ("We ask whether the SFFP transfer alters smallholder farm behavior … equivalently, whether the AHM separability null holds"); inheriting that sentence verbatim into the abstract would resolve the issue.

**M2 (headline result under-quantified).** The abstract delivers *direction and existence* ("monotone tenancy gradient … negative operating-cost response") but no *magnitudes*. CLAUDE.md documents publishable numbers — −11.1% rent-cost pass-through (T2), +1,089 m² pure-tenant area_own response (T2), op_cost_ex_rent −4.02M KRW (T1 p=0.055) — and §3.4 already cites the −11.1% figure (line 259). At least one anchor number (e.g., "a +1,089 m² area-own response in pure-tenant smallholders, monotone in baseline tenancy share") would convert the abstract from existence-claim to magnitude-claim, the AJAE standard. As written, the abstract is closer to a working-paper teaser than a submission abstract.

**M3 (contribution sentence missing).** The abstract has *no explicit one-sentence contribution claim*. The "first per-farm flat-rate cutoff AHM separability test" claim — load-bearing in §1 ¶4 ("to our knowledge we provide the first AHM separability test at a per-farm flat-rate direct-payment cutoff and the first DiD-RD evidence on the Korean PIDPS") — is absent from lines 38–41. The closing sentence ("A joint F1–F2 null would be a precise complement to LaFave-Thomas 2016") describes a *counterfactual* outcome, not the *delivered* contribution. Suggest replacing or adding: "We provide the first AHM-separability test at a per-farm flat-rate direct-payment cutoff and the first DiD-RD evidence on Korea's PIDPS."

**M4 (Eswaran-Kotwal supervision channel absent from abstract).** The abstract names Carter-Olinto (liquidity) and Kazukauskas (disinvestment) but omits Eswaran-Kotwal — the second of the two AHM extensions advertised in §1 ¶2 and §3.3. F2 is mentioned as "hired-labor margin response," but the *theoretical channel name* (implicit-labor supervision) and its citation are missing. This creates a small abstract↔body mismatch flagged below.

## MINOR polish

- Line 40: "deep within the (S,s) inaction band and the wealth-bias rejection region simultaneously" — "wealth-bias rejection region" is an opaque phrase to a non-specialist reader. "(S,s) inaction band" is widely understood; "wealth-bias rejection region" is informal jargon for the CO-2 cross-partial. Either name it ("the Carter-Olinto wealth-biased liquidity rejection region") or drop it and let F1/F2 carry the framing.
- Line 40: "1.2 million KRW per-farm flat-rate transfer" — convert at least once to USD for AJAE readers (≈ $900 at 2020–2022 average), or note "approximately $900/year". AJAE editorial preference is dollar anchors in the abstract.
- "We pre-register two falsification triggers" — under \citet{Roth2022_pretrends} the field-standard verb is "pre-specify"; "pre-register" connotes a public RCT registry like AEA RCT Registry. The replication-package ADR archive is closer to pre-specification. Switch to "pre-specify".
- Final sentence ("A joint F1–F2 null would be a precise complement to LaFave-Thomas") sits awkwardly after the bold "We reject AHM separability" — it describes the *counterfactual where we do not reject*. Move to §1 ¶3 (where it already lives, line 58) or rephrase as a robustness signpost.

## Cross-check: abstract ↔ body

| Claim in abstract | Body location | Match? | Note |
|---|---|---|---|
| AHM separability null at 0.5 ha SFFP cutoff | §1 ¶1 (line 54), §3.1 (line 119), eq. (\ref{eq:null}) | YES | Consistent. |
| 1.2M KRW per-farm flat-rate | §1 ¶1 (line 54), Table notation row T_SFFP (line 95), §3.4.1 (line 226) | YES | Consistent; 2025 increase to 1.3M correctly footnoted in body. |
| T_SFFP/τ ∈ [0.024, 0.048] | §3.4.1 line 226 | YES | Exact match. |
| 50M / 25M KRW τ reconciliation | §3.4.1 line 224, footnote line 224, Table notation row τ (line 105) | YES | KREI/KAMICO citations now in §3.4.1. |
| F1 = monotone tenancy gradient in own-cultivated area | §3.5 line 252, eq. (\ref{eq:CO-2}) line 174 | YES | F1 load-bearing locked at line 254. |
| F2 = hired-labor margin response (off-farm income proxy) | §3.5 line 253 | PARTIAL | Abstract says "hired-labor margin response"; body specifies off-farm income proxy and explicitly notes EK-1 sign indeterminacy. Abstract is silent on indeterminacy — acceptable given length but borderline. |
| ADR-0001 / ADR-0002 archive | §1 footnote 2 (line 56), Table 2 caption (line 232) | YES | Pre-registration claim survives. |
| Monotone tenancy gradient consistent with Carter-Olinto | §1 ¶3 line 58, §3.2 line 158, eq. (\ref{eq:CO-2}) line 174 | YES | Carter-Olinto cross-partial is the unique diagnostic. |
| Negative operating-cost response consistent with Kazukauskas | §1 ¶3 line 58, §3.2 line 184, Table 3 row Capital adj. (line 241) | YES | Kazukauskas anchor present in body. |
| "Reject AHM separability" headline | §3.1 line 119 ("We reject AHM separability for Korean small farms" verbatim) | YES | Verbatim match, including italics. |
| Eswaran-Kotwal supervision channel | §1 ¶2 line 56, §3.3 lines 191–205 | MISMATCH | Body advertises *two* extensions; abstract names only one (Carter-Olinto). See M4. |
| LaFave-Thomas complement | §1 ¶3 line 58, §3.5 line 256 | YES | Counterfactual framing consistent. |
| First per-farm flat-rate cutoff AHM test | §1 ¶4 line 64 | MISMATCH | Contribution claim in body, absent from abstract. See M3. |
| Kirwan / Baldoni-Ciaian anchors | §1 ¶1 line 54, §1 ¶3 line 58 | YES | Cited in first abstract sentence; positioned identically in body. |

## Score rationale

7.5/10. The abstract is *correct* on every numeric and pre-registration claim cross-checked against §3 and the ADR archive, which is the harder half of the job — no factual mismatches, no notation drift, no orphaned citations, and the load-bearing F1 framing (with F2 demoted to informative-not-rejecting) is faithfully reflected. What costs the abstract 2.5 points is *structure and signaling*: the first sentence is method-first rather than question-first (M1), no magnitude anchor is delivered though the body supports several (M2), the "first per-farm flat-rate cutoff AHM test" contribution sentence is missing (M3), and one of the two advertised AHM extensions (Eswaran-Kotwal) is absent (M4). All four are mechanical fixes; none requires §3/§4 re-engineering. A revised abstract that opens with the question, names both AHM extensions, delivers one quantified result, and adds the one-sentence contribution would land at 9/10 without touching the body.
