{{ config(materialized='table') }}

-- Simple P&L (Income Statement) for Task 1 demo
-- Shows Revenue and Expenses by period

SELECT
    account_code,
    account_name,
    account_type,
    fiscal_year,
    fiscal_period,
    
    -- Period activity (sum of signed amounts for the period)
    SUM(signed_amount) AS period_amount,
    
    CURRENT_TIMESTAMP() AS dbt_updated_at

FROM {{ ref('fct_transactions') }}
WHERE statement_type = 'INCOME_STATEMENT'  -- Only P&L accounts (Revenue & Expenses)
GROUP BY 1,2,3,4,5
HAVING ABS(SUM(signed_amount)) > 0.01  -- Exclude zero amounts
ORDER BY 
    fiscal_year,
    fiscal_period,
    CASE WHEN account_type = 'REVENUE' THEN 1 ELSE 2 END,  -- Revenue first, then Expenses
    account_code 