---
paths:
  - "**/*.R"
  - "Figures/**/*.R"
  - "scripts/**/*.R"
---

# R Code Standards

**Standard:** Senior Principal Data Engineer + PhD researcher quality

---

## 1. Reproducibility

- `set.seed()` called ONCE at top (YYYYMMDD format)
- All packages loaded at top via `library()` (not `require()`)
- All paths relative to repository root
- `dir.create(..., recursive = TRUE)` for output directories

## 2. Function Design

- `snake_case` naming, verb-noun pattern
- Roxygen-style documentation
- Default parameters, no magic numbers
- Named return values (lists or tibbles)

## 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator implementations match slide formulas
- Check known package bugs (document below in Common Pitfalls)

## 4. Visual Identity

```r
# --- Your institutional palette ---
primary_blue  <- "#012169"
primary_gold  <- "#f2a900"
accent_gray   <- "#525252"
positive_green <- "#15803d"
negative_red  <- "#b91c1c"
```

### Custom Theme
```r
theme_custom <- function(base_size = 14) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", color = primary_blue),
      legend.position = "bottom"
    )
}
```

### Figure Dimensions for Beamer
```r
ggsave(filepath, width = 12, height = 5, bg = "transparent")
```

## 5. RDS Data Pattern

**Heavy computations saved as RDS; slide rendering loads pre-computed data.**

```r
saveRDS(result, file.path(out_dir, "descriptive_name.rds"))
```

## 6. Common Pitfalls

| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Missing `bg = "transparent"` | White boxes on slides | Always include in ggsave() |
| Hardcoded paths | Breaks on other machines | Use relative paths |
| Treatment dummy from time-varying area | Manipulation contamination, RD invalid | Always use `rv_2018` (2018 baseline), never `area_t` |
| Unbalanced panel from FHES Wave 1→2 transition | 2023+ farms not connected to 2018 cohort | Restrict to `year ∈ 2018:2022`; Wave 2 linkage TBD |
| `weight_national` ignored or applied inconsistently | Biased descriptives **OR** inefficient/biased estimation | **Stage-specific rule (Solon, Haider, Wooldridge 2015 JHR):** (a) Table 1 descriptives — `weight_national` **mandatory** via `survey::svydesign()` for population representativeness; (b) Main estimation (Table 2, ATT) — **unweighted by default** (more efficient under correct specification), report `weight_national` weighted version as a separate robustness table; (c) If weighted vs unweighted differ materially, the gap must be discussed in the discussion section as evidence of treatment-effect heterogeneity. Cite Solon, Haider, and Wooldridge (2015) "What Are We Weighting For?" *JHR* 50(2): 301–316. |
| 한국어 인코딩 깨짐 (CP949 vs UTF-8) | Variable mapping fails silently | Force `read_csv(..., locale = locale(encoding = "UTF-8"))` |

## 7. Line Length & Mathematical Exceptions

**Standard:** Keep lines <= 100 characters.

**Exception: Mathematical Formulas** -- lines may exceed 100 chars **if and only if:**

1. Breaking the line would harm readability of the math (influence functions, matrix ops, finite-difference approximations, formula implementations matching paper equations)
2. An inline comment explains the mathematical operation:
   ```r
   # Sieve projection: inner product of residuals onto basis functions P_k
   alpha_k <- sum(r_i * basis[, k]) / sum(basis[, k]^2)
   ```
3. The line is in a numerically intensive section (simulation loops, estimation routines, inference calculations)

**Quality Gate Impact:**
- Long lines in non-mathematical code: minor penalty (-1 to -2 per line)
- Long lines in documented mathematical sections: no penalty

## 8. Numerical Discipline

See [`r-reviewer.md`](../agents/r-reviewer.md) Category 11 ("Numerical Discipline") for the full checklist. Headline rules:

- **No float equality.** Never use `==` on doubles. Use `all.equal()` or `abs(a - b) < tol`.
- **CDF clamping** to an OPEN interval. Exact 0 or 1 passed to `qnorm()` / `pbinom()` etc. produces `±Inf`. Project-wide epsilon:

  ```r
  eps <- 1e-12
  p <- pmin(1 - eps, pmax(eps, p))   # now safe for qnorm(p)
  ```

- **Integer literals for counts.** `nrow <- 1000L` (not `1000`), `for (i in 1L:nL)` — avoids silent promotion.
- **Pre-allocate vectors** before loops (`numeric(n)`, `vector("list", n)`), never grow with `c()`.
- **Deterministic bootstrap seeding.** Set seed before the bootstrap, and if the bootstrap is nested, set per-replicate seeds as `seed_base + b`.
- **Explicit `na.rm = TRUE/FALSE`.** Never rely on defaults for `mean()`, `sd()`, `sum()` on data with potential NAs.
- **No `T` / `F`.** They're variables, not constants — write `TRUE` / `FALSE`.

## 9. Code Quality Checklist

```
[ ] Packages at top via library()
[ ] set.seed() once at top (YYYYMMDD)
[ ] All paths relative
[ ] Functions documented (Roxygen)
[ ] Figures: transparent bg, explicit dimensions
[ ] RDS: every computed object saved
[ ] Comments explain WHY not WHAT
[ ] Numerical discipline: no float ==, CDF clamping with eps, pre-allocated vectors
```

## 10. FHES Variable Naming Convention

**Standardize Korean source variable names to snake_case English while preserving the original.**

| Source (FHES) | Standardized R name | Type | Notes |
|---------------|---------------------|------|-------|
| 농가식별번호 | `hh_id` | integer | Primary key (cluster unit) |
| 시군구코드 | `sgg_cd` | integer | Robustness cluster unit |
| 조사연도 | `year` | integer | Panel time index |
| 경지면적 (2018 baseline) | `rv_2018` | numeric (㎡) | Running variable, fixed at 2018 |
| 경지면적 (annual) | `area_t` | numeric (㎡) | Time-varying, NOT running variable |
| 농업경영비 | `op_cost` | numeric (KRW) | Primary outcome (lumpy investment) |
| 농외소득 | `off_farm_income` | numeric (KRW) | Auxiliary outcome 1 (Sandmo) |
| 가계소비지출 | `consumption` | numeric (KRW) | Auxiliary outcome 2 (Blundell-Pistaferri) |
| 농업소득 | `farm_income` | numeric (KRW) | Omnibus outcome |
| 처치 더미 | `D_treat` | logical | `rv_2018 ≤ 5000` |
| 시점 더미 | `Post` | logical | `year ≥ 2020` |
| 표본가중치 | `weight_national` | numeric | National-rep weight (see §6 stage rule) |

**Mandatory pattern when reading raw FHES:**

```r
df_fhes <- read_csv("data/fhes_raw.csv",
                    locale = locale(encoding = "UTF-8")) %>%
  rename(hh_id = 농가식별번호, year = 조사연도, op_cost = 농업경영비, ...)

# Preserve original Korean label as attribute (labelled package)
attr(df_fhes$op_cost, "label_ko") <- "농업경영비"
```

Maintain `data/var_dictionary.csv` (3 columns: `r_name`, `source_name_ko`, `definition_en`) and refer to it in every analysis script header.

## 11. DiD-RD Clustering Convention

- **Primary cluster:** household (`hh_id`). All headline tables in `paper/{ko,en}/` use this.
- **Robustness cluster:** sub-district (`sgg_cd`). Reported in online supplement / online appendix side-by-side with primary.

```r
# Headline (primary)
m_main <- feols(op_cost ~ D_treat * Post + controls, data = df, cluster = ~hh_id)

# Robustness (sub-district)
m_sgg  <- feols(op_cost ~ D_treat * Post + controls, data = df, cluster = ~sgg_cd)
```

Wild cluster bootstrap: use `fwildclusterboot::boottest()` at `hh_id` (B = 9,999, seed-pinned). Holm step-down across the 4 primary outcomes via `p.adjust(..., method = "holm")` after collecting Wild bootstrap p-values.

## 12. Reproducibility Snapshot

- **Every analysis script writes `_outputs/sessionInfo.txt`** as the last action of Phase 5 (Save and Review): `writeLines(capture.output(sessionInfo()), "scripts/R/_outputs/sessionInfo.txt")`.
- **renv lockfile:** activate **only at first-submission stage** (`renv::init()` immediately before generating the replication package). During analysis, system R is fine — but pin every `library()` package version in script comments as a fallback.
- **Paper inclusion:** main text lists only key package versions (`fixest`, `rdrobust`, `did`, `fwildclusterboot`, `modelsummary`). Full `sessionInfo` goes in online supplement.

## 13. Figure & Table Output Convention

**Figures (publication-grade PDF + dormant PNG):**

```r
# Save BOTH formats — PDF for paper/, PNG for future defense slides (dormant)
ggsave("scripts/R/_outputs/fig_did_rd_main.pdf", plot = p, width = 6, height = 4.5,
       device = cairo_pdf, bg = "white")
ggsave("scripts/R/_outputs/fig_did_rd_main.png", plot = p, width = 6, height = 4.5,
       dpi = 300, bg = "transparent")  # transparent for slide overlay
```

**Tables (single source via modelsummary → bilingual LaTeX):**

```r
# Generates LaTeX consumed by paper/ko (Korean labels) and paper/en (English labels)
modelsummary(list("(1)" = m_T1, "(2)" = m_T2, "(3)" = m_T3),
             output = "scripts/R/_outputs/tab_main_did_rd_en.tex",
             coef_map = en_label_map, ...)
modelsummary(list("(1)" = m_T1, "(2)" = m_T2, "(3)" = m_T3),
             output = "scripts/R/_outputs/tab_main_did_rd_ko.tex",
             coef_map = ko_label_map, ...)
```

Naming: `fig_<topic>.{pdf,png}`, `tab_<topic>_<lang>.tex`. Manuscripts pull these via `\input{...}` — never copy-paste numbers.
