# EDA findings — 2026-05-07 Outlier policy spec

Generated: 2026-05-07 14:25:08 KST

## H1 — Right-skewness in 4 outcomes
Result: **TRUE** (mean > median for all 4 outcomes)
# A tibble: 5 × 5
  variable             mean    median skew_ratio right_skewed
  <chr>               <dbl>     <dbl>      <dbl> <lgl>       
1 y_farm_cost     32811605. 10038706.       3.27 TRUE        
2 y_off_income    16762135.  5574925        3.01 TRUE        
3 y_consump       27306802. 24708466        1.11 TRUE        
4 y_farm_income   14720258.  4125730.       3.57 TRUE        
5 imputed_payment  1979650.  1200000        1.65 TRUE        

## H2 — imputed_payment bimodality (formula-induced)
- zero values (year ≤ 2019 + missing area_total): 5697
- flat 1,200,000 cluster (SFFP eligibility): 3204
- area-proportional cluster: 5573

## H3 — Zero/negative ≥ 5% in any outcome
Result: **TRUE** (any variable ≥ 5%)
Per-variable zero+negative %:
    y_farm_cost.n_zero    y_off_income.n_zero       y_consump.n_zero 
                  0.00                   4.99                   0.00 
  y_farm_income.n_zero imputed_payment.n_zero 
                 23.55                  39.36 

## H4 — Cutoff-near subsample distribution similarity
Median ratio (full / cutoff-near, ratio close to 1 = similar):
    y_farm_cost    y_off_income       y_consump   y_farm_income imputed_payment 
          1.915           0.834           1.068           1.831           1.054 

## Spec impact
- OQ-4 (Plan): Candidate B (log+1) SHOULD (zero/neg ≥ 5%)
- H1 supports IHS robustness (already in term-paper).
- H2 confirms imputed_payment formula bimodality — outlier handling N/A.
- H4 informs cutoff RD identification stability.
