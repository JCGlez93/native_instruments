{{ config(materialized='view') }}

-- Simple staging for GL headers - only fields we actually use

SELECT
    gl_header_id,
    transaction_type,
    CAST(transaction_date AS DATE) AS transaction_date,
    fiscal_year,
    fiscal_period
    
FROM {{ source('raw_finance', 'gl_headers') }}
WHERE status IN ('POSTED', 'COMPLETE') 