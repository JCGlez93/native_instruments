{{ config(materialized='table') }}

-- Simple transaction fact table for Task 1 demo
-- Just joins GL headers and lines with basic account info

SELECT
    -- Keys
    CONCAT(h.gl_header_id, '-', l.gl_line_id) AS transaction_line_key,
    h.gl_header_id,
    l.gl_line_id,
    l.account_code,
    
    -- Basic transaction info
    h.transaction_date,
    h.fiscal_year,
    h.fiscal_period,
    h.transaction_type,
    
    -- Amounts
    l.accounted_debit_amount,
    l.accounted_credit_amount,
    l.net_amount,
    
    -- Account info from dimension
    a.account_name,
    a.account_type,
    a.statement_type,
    a.balance_multiplier,
    
    -- Signed amount for reporting
    l.net_amount * a.balance_multiplier AS signed_amount,
    
    CURRENT_TIMESTAMP() AS dbt_updated_at
    
FROM {{ ref('stg_gl_headers') }} h
JOIN {{ ref('stg_gl_lines') }} l ON h.gl_header_id = l.gl_header_id
LEFT JOIN {{ ref('dim_accounts') }} a ON l.account_code = a.account_code 