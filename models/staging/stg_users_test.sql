{{
  config(
    materialized='view',
    docs={'node_color': '#8FBC8F'}
  )
}}

with source as (
    select * from {{ ref('users_test') }}
),

cleaned as (
    select
        user_id,
        email,
        first_name,
        last_name,
        date(signup_date) as signup_date,
        country,
        age,
        subscription_type,
        concat(first_name, ' ', last_name) as full_name,
        current_timestamp() as dbt_updated_at
    from source
)

select * from cleaned 