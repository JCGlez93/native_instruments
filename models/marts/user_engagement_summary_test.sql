{{
  config(
    materialized='table',
    docs={'node_color': '#FF6B6B'}
  )
}}

with user_dim as (
    select * from {{ ref('dim_users_test') }}
),

event_facts as (
    select * from {{ ref('fct_events_test') }}
),

final as (
    select
        u.user_id,
        u.full_name,
        u.email,
        u.subscription_type,
        u.total_events,
        count(ef.event_id) as event_count,
        current_timestamp() as dbt_updated_at
    from user_dim u
    left join event_facts ef on u.user_id = ef.user_id
    group by u.user_id, u.full_name, u.email, u.subscription_type, u.total_events
)

select * from final
order by total_events desc 