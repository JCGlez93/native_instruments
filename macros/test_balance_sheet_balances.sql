{% test test_balance_sheet_balances(model) %}

-- Custom test macro to ensure balance sheet balances
-- Assets should equal Liabilities + Equity for each period

WITH balance_check AS (
    SELECT 
        fiscal_year,
        fiscal_period,
        
        -- Calculate totals by account type
        SUM(CASE WHEN account_type = 'ASSET' THEN period_end_balance ELSE 0 END) AS total_assets,
        SUM(CASE WHEN account_type = 'LIABILITY' THEN period_end_balance ELSE 0 END) AS total_liabilities,
        SUM(CASE WHEN account_type = 'EQUITY' THEN period_end_balance ELSE 0 END) AS total_equity,
        
        -- Calculate balance sheet equation difference
        SUM(CASE WHEN account_type = 'ASSET' THEN period_end_balance ELSE 0 END) - 
        (SUM(CASE WHEN account_type = 'LIABILITY' THEN period_end_balance ELSE 0 END) + 
         SUM(CASE WHEN account_type = 'EQUITY' THEN period_end_balance ELSE 0 END)) AS balance_difference
        
    FROM {{ model }}
    GROUP BY fiscal_year, fiscal_period
),

balance_failures AS (
    SELECT *
    FROM balance_check
    WHERE ABS(balance_difference) > 0.01  -- Allow for small rounding differences
)

SELECT *
FROM balance_failures

{% endtest %} 