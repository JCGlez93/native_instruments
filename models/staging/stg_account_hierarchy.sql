{{ config(materialized='view') }}

-- Simple staging for account hierarchy - only fields we actually use

SELECT
    account_code,
    account_name,
    account_type,
    parent_account_code
    
FROM {{ source('raw_finance', 'account_hierarchy') }}
WHERE account_code IS NOT NULL
  AND account_type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE') 