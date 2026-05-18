# Lens 4 (Results + tables) — Seven-Pass Review

**Score:** 6.5/10

The three existing tables are substantively serious and rich. They fall short of AJAE-ready on three dimensions: (i) symbol-set inconsistency between tab:notation and the body/other tables (notably $\beta$ as a discount factor while $\beta_k$ index regression coefficients in the same column of tab:alpha3-predictions), (ii) the landscape mapping table embeds raw P3b-2 numbers that conflict with each other in sign-direction across rows, and (iii) operational decision rules are nearly executable but conflate "F1 fires" criteria with the row label, producing a logical ambiguity reviewers will catch.

## CRITICAL issues

- **C1. Sign inconsistency in the landscape "Liquidity gradient" row (tab:appB-mapping, L452).** The row reports T2 monotone bins as `{pure_tenant -1738; low_owner -600; mixed -393; pure_owner 0 ref}` --- all negative --- but main.tex L62 and CLAUDE.md state pure_tenant **+1,089 m²** for $A_{own}$ at T2 ($p=.033$). The −1,738 figure is the **rented-area** decline (channel ii in CLAUDE.md), not the $A_{own}$ gradient. The row's outcome is `$A_{own}\times(1-s_{0,i})$`, so the entries must be the $A_{own}$ four-bin gradient (positive, monotone increasing in $1-s_0$). The current entries leak a different channel's numbers and contradict tab:alpha3-predictions sign-prediction $>0$. AJAE referees will read this as a sign error in the headline gradient.

- **C2. $\beta$ symbol collision (tab:notation row 11 vs. tab:alpha3-predictions / tab:appB-mapping).** tab:notation defines $\beta$ as the discount factor used in $T_i/(1-\beta)$. tab:alpha3-predictions then labels coefficients $\beta_1,\ldots,\beta_5$ in the same paper. The body sometimes uses $\hat\beta_1,\hat\beta_3$ (L151 HonestDiD sensitivity) and tab:alpha3-predictions header writes "Econ. $\hat\beta$" but rows list bare $\beta_k$. Either disambiguate the discount factor (e.g., $\delta$) or differentiate the coefficient with $\hat\beta_k$ uniformly. This is precisely the THEORY-referee C2 notation-drift critique the table was supposed to fix.

## MAJOR issues

- **M1. tab:notation missing symbols actually used in tab:appB-mapping and §3 body.** The table omits: $A_i, A_{2018,i}$ (total cultivated area, used in $D_i$ definition and $s_{0,i}$); $rv_{2018,i}$ (running variable, used in SC2.5, SC5); $h$ (bandwidth, used in SC2.5 and the T1/T2/T3 grid); $\bar a$ (per-crosser purchase quantity, used in eq. appB-step2); $\Delta K, \Delta P_i$ (used in SC4 and appB-step2-prob); $\beta_1\ldots\beta_5$ (the econometric coefficients themselves). Conversely, $\mu, \lambda$ appear with first-use "§B.1" but B.1 introduces two distinct multipliers $\lambda_1, \lambda_2$ (period 1 vs. period 2 budget), and a separate $\mu$ for the time constraint --- tab:notation under-specifies the indexed pair.

- **M2. tab:alpha3-predictions row for "Liquidity gradient" mixes derivative form and an "Econ. $\hat\beta$" label.** "Reduced form" reads $\partial^2/\partial T_{SFFP}\,\partial(1-s_0) > 0$ but "Econ. $\hat\beta$" = $\beta_2$. There is no specification in §3 that says $\beta_2$ is the cross-partial estimator; reduced-form readers will assume $\beta_2$ is the linear interaction coefficient in a single regression. Clarify: $\beta_2$ corresponds to the bin-by-bandwidth four-cell heterogeneity test, not a single interaction term.

- **M3. tab:appB-mapping "Operational decision rule" is *conditional* but not *executable* on the F1 row (L452).** "F1 fires if $p(\hat\beta_2 > 0) > .10$ at T2 **and** four-bin point estimates not weakly monotone-decreasing in $s_{0,i}$ at T1 **or** T2 (Holm-corrected)." The Boolean precedence is ambiguous: is it `(p>.10 at T2) AND ((not-monotone at T1) OR (not-monotone at T2))`, or `((p>.10 at T2) AND (not-monotone at T1)) OR (not-monotone at T2)`? With Holm correction nested, three reviewers will read this three ways. Use explicit parentheses or a 2×2 cell-by-cell decision matrix.

- **M4. Magnitude interpretation absent.** The +1,089 m² estimate (T2 pure tenant $A_{own}$) is reported as a raw number with no contextualization vs. the 5,000 m² cutoff (≈21.8% of cutoff area, a very large effect). Similarly −4.02M KRW op_cost vs. 1.2M KRW transfer is a 335% expense reduction per KRW of transfer --- a sign that should be flagged or interpreted. Captions or table footnotes should anchor magnitudes to baseline cohort means.

- **M5. tab:appB-mapping cell on "Empirical fit by bandwidth" double-codes the P3b-2 unit_rent_price magnitudes.** Last row reports T1 `−48 to −130 KRW/m²` and T2 `pass-through −11.1%`. These two metrics are not parallel: one is a per-m² level effect, the other a per-KRW pass-through ratio. Either re-express both as levels and pass-through, or footnote the unit switch. Otherwise readers cannot judge whether the magnitude is monotone across bandwidths.

- **M6. Caption of tab:appB-mapping does not name what the reader should conclude.** It describes structure ("expanded . . . with per-bandwidth empirical fit and operationalized falsification triggers") but never says the take-away: that the four primary cells already-estimated support the wealth-bias channel via two concurrent signed predictions plus a calibrated null on capital adjustment. AJAE captions are expected to stand alone.

## MINOR polish

- **m1.** tab:notation row $s_{0,i}$ definition is correct but the four-bin partition rule appears only in B.1 footnote. Add a one-line tail to the definition: "discrete-partition operationalization in §B.1."
- **m2.** tab:notation $W^*(\mathbf{p})$ uses bold $\mathbf{p}$ for the price vector but the body L160–161 uses bold $\mathbf{p}$ only once and elsewhere lists prices in long form. Either keep $\mathbf{p}$ as a defined notation row, or expand at every use.
- **m3.** tab:alpha3-predictions ex-theory row reads "Floyd 1965; Alston-James 2002" --- inline citation style "C-O 2003" / "K et al. 2013" / "E-K 1986" is informal for AJAE. Use full author-year (`Carter \& Olinto 2003`).
- **m4.** tab:appB-mapping column width on "Operational decision rule" is 4.8 cm --- in landscape this fits, but the rules wrap awkwardly at "(Holm-corrected)". Consider 4.4 cm with a wider "Empirical fit" column.
- **m5.** No figure currently exists in §3. A small 0.5-ha-cutoff illustration showing the four-bin $s_0$ partition and the F1 monotone gradient prediction (a four-bar schematic) would clarify F1 in a way the table cannot. Not load-bearing, but recommended.

## Per-table audit

### tab:notation
- **Standalone?** N (cannot reconstruct the running variable, the bandwidth, $A$ vs. $A_{own}$ vs. $A_{rent}$ identity, or the regression coefficients from the table alone).
- **Issues:** missing $A_i, A_{2018,i}, rv_{2018,i}, h, \bar a, \beta_1\ldots\beta_5, \Delta K$; $\beta$/discount-factor collision (C2); $\mu, \lambda$ under-specified vs. B.1's $\lambda_1, \lambda_2, \mu_1, \mu_2$.

### tab:alpha3-predictions
- **Standalone?** Y (with caveat: caption is sufficient, ADR-0002 reference is appropriate, ex-theory B.1 row is correctly separated by `\midrule` and italic header).
- **Issues:** $\beta_2$ econometric counterpart not pinned to a specification (M2); informal citation shorthand (m3); magnitude not interpreted at table level.

### tab:appB-mapping (landscape)
- **Standalone?** N (sign inconsistency in Liquidity-gradient row, C1; unit switch in unit_rent_price row, M5).
- **Operational rules executable?** Mostly Y, except the F1 row (M3 Boolean precedence ambiguity). The other rows' rules are clean: $\beta_1$ uses `p > .10 at both T2 and T3`, $\beta_3$ uses `p < .10 at T1 or T2`, $\beta_4$ uses `p > .10 at all three`. The F1 rule needs disambiguation.
- **Issues:** landscape orientation renders correctly given `pdflscape` in preamble (verified L22 of online_appendix.tex); caption does not state take-away (M6); empirical-fit row leaks rented-area numbers into the $A_{own}$ gradient cell (C1, the most serious finding in this lens).

## Cross-table consistency

| Symbol | tab:notation | tab:alpha3-predictions | tab:appB-mapping | Consistent? |
|---|---|---|---|---|
| $T_i$ vs $T_{SFFP}$ | both, with $T_i = T_{SFFP} \cdot D_i$ | $T_{SFFP}$ used in derivatives | $T_{SFFP}$ used in derivatives | Y |
| $s_{0,i}$ | $s_{0,i}$ defined | $s_0$ (drops $i$ subscript) | $s_{0,i}$ used, also $s_0$ in "ref" notation | Inconsistent (drops $i$) |
| $A_{own}$ | $A_{own,i}$ | $A_{own}$ (drops $i$) | $A_{own}$ (drops $i$) | Inconsistent ($i$ dropped) |
| $\beta_k$ (coefficients) | NOT listed | $\beta_1\ldots\beta_5$ | $\beta_1\ldots\beta_5$ | Notation table incomplete |
| $\hat\beta_k$ | NOT listed | header says "Econ. $\hat\beta$" but rows write $\beta_k$ | rows write $\hat\beta_k$ in decision rules | Inconsistent hat usage |
| $\tau$ | defined, ${\sim}25$M–$50$M KRW | not in table (in body) | "robustness range $\tau \in [20\text{M},40\text{M}]$" | Y (body anchors) |
| $\varphi(W^*)$ | defined | not used in table | not used in table | Y (B.1 only) |
| $\beta$ (discount) | defined | absent | absent | Y but collides with coefficient $\beta_k$ — see C2 |

## Score rationale

The three tables together carry the full theoretical-empirical mapping the manuscript is built on, and they are far more sophisticated than the AJAE median. The score is held to 6.5/10 by C1 (the rented-area / $A_{own}$ leak in tab:appB-mapping is a sign-direction error in the headline gradient row that referees will flag immediately) and C2 (the $\beta$ discount-factor vs. $\beta_k$ coefficient symbol collision is exactly the notation-drift problem the table was supposed to fix). M1–M3 are major-but-fixable in one editing pass; M4–M6 lift the score on follow-up. With C1 + C2 + M1 fixed the table set scores in the 8.0–8.5 range, AJAE-ready.
