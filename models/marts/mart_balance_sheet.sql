{{ config(materialized='table') }}

-- Simple Balance Sheet for Task 1 demo
-- Just shows account balances grouped by type

SELECT
    account_code,
    account_name,
    account_type,
    fiscal_year,
    fiscal_period,
    
    -- Balance calculation (sum of all signed amounts)
    SUM(signed_amount) AS period_end_balance,
    
    CURRENT_TIMESTAMP() AS dbt_updated_at

FROM {{ ref('fct_transactions') }}
WHERE statement_type = 'BALANCE_SHEET'  -- Only balance sheet accounts
GROUP BY 1,2,3,4,5
HAVING ABS(SUM(signed_amount)) > 0.01  -- Exclude zero balances
ORDER BY account_type, account_code 