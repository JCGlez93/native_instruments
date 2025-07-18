{{
  config(
    materialized='table',
    docs={'node_color': '#4682B4'}
  )
}}

with users as (
    select * from {{ ref('stg_users_test') }}
),

user_activity as (
    select
        user_id,
        count(*) as total_events
    from {{ ref('stg_events_test') }}
    group by user_id
),

final as (
    select
        u.user_id,
        u.full_name,
        u.email,
        u.subscription_type,
        u.country,
        u.age,
        coalesce(ua.total_events, 0) as total_events,
        current_timestamp() as dbt_updated_at
    from users u
    left join user_activity ua on u.user_id = ua.user_id
)

select * from final 