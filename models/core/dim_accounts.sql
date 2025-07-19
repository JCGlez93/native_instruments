{{ config(materialized='table') }}

-- Simple account dimension for Task 1 demo
-- Just basic account info with financial statement categorization

SELECT
    account_code,
    account_name,
    account_type,
    parent_account_code,
    
    -- Simple financial statement categorization
    CASE 
        WHEN account_type IN ('ASSET', 'LIABILITY', 'EQUITY') THEN 'BALANCE_SHEET'
        WHEN account_type IN ('REVENUE', 'EXPENSE') THEN 'INCOME_STATEMENT'
        ELSE 'OTHER'
    END AS statement_type,
    
    -- Balance multiplier for reporting (Assets/Expenses = positive, Liabilities/Revenue/Equity = negative)
    CASE 
        WHEN account_type IN ('ASSET', 'EXPENSE') THEN 1 
        ELSE -1 
    END AS balance_multiplier,
    
    CURRENT_TIMESTAMP() AS dbt_updated_at

FROM {{ ref('stg_account_hierarchy') }} 