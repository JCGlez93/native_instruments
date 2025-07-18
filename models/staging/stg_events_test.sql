{{
  config(
    materialized='view',
    docs={'node_color': '#8FBC8F'}
  )
}}

with source as (
    select * from {{ ref('events_test') }}
),

cleaned as (
    select
        event_id,
        user_id,
        event_type,
        timestamp(event_timestamp) as event_timestamp,
        page_url,
        device_type,
        date(event_timestamp) as event_date,
        current_timestamp() as dbt_updated_at
    from source
)

select * from cleaned 