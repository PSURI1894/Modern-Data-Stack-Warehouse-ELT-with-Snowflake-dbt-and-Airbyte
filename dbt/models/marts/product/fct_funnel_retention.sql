{{
    config(
        materialized='incremental',
        unique_key='event_id',
        on_schema_change='sync_all_columns',
        cluster_by=['event_timestamp::date']
    )
}}
with events as (
    select * from {{ ref('stg_postgres__events') }}
    {% if is_incremental() %}
    where event_timestamp >= (select max(event_timestamp) from {{ this }}) - interval '3 days'
    {% endif %}
),
users as (
    select
        postgres_user_id,
        created_at as user_created_at
    from {{ ref('stg_postgres__users') }}
),
session_events as (
    select
        events.event_id,
        events.postgres_user_id,
        events.event_type,
        events.session_id,
        events.event_timestamp,
        -- Unified UTC date conversion
        cast(date_trunc('month', cast(users.user_created_at as timestamp_ntz)) as date) as cohort_month,
        cast(datediff('month', date_trunc('month', cast(users.user_created_at as timestamp_ntz)), date_trunc('month', cast(events.event_timestamp as timestamp_ntz))) as integer) as cohort_age_months,
        cast(case when events.event_type = 'signup' then 1 else 0 end as integer) as step_signup,
        cast(case when events.event_type = 'onboarding_started' then 1 else 0 end as integer) as step_onboarding,
        cast(case when events.event_type = 'search_performed' then 1 else 0 end as integer) as step_search,
        cast(case when events.event_type = 'checkout_completed' then 1 else 0 end as integer) as step_checkout,
        cast(row_number() over (partition by events.session_id order by events.event_timestamp) as integer) as event_seq
    from events
    left join users on events.postgres_user_id = users.postgres_user_id
)
select * from session_events
