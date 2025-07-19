{{ config(materialized='view') }}

-- Simple staging for GL lines - only fields we actually use

SELECT
    gl_line_id,
    gl_header_id,
    account_code,
    accounted_dr AS accounted_debit_amount,
    accounted_cr AS accounted_credit_amount,
    COALESCE(accounted_dr, 0) - COALESCE(accounted_cr, 0) AS net_amount
    
FROM {{ source('raw_finance', 'gl_lines') }}
WHERE status = 'POSTED'
  AND (entered_dr IS NOT NULL OR entered_cr IS NOT NULL) 