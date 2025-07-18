{{
  config(
    materialized='table',
    docs={'node_color': '#4682B4'}
  )
}}

with events as (
    select * from {{ ref('stg_events_test') }}
),

users as (
    select 
        user_id,
        subscription_type
    from {{ ref('dim_users_test') }}
),

final as (
    select
        e.event_id,
        e.user_id,
        e.event_type,
        e.event_timestamp,
        e.event_date,
        e.page_url,
        e.device_type,
        u.subscription_type,
        current_timestamp() as dbt_updated_at
    from events e
    left join users u on e.user_id = u.user_id
)

select * from final 