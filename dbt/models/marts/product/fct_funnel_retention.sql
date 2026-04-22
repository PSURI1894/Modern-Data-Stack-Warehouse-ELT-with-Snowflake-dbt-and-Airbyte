{{
    config(
        materialized='incremental',
        unique_key='event_id',
        on_schema_change='sync_all_columns'
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
        date_trunc('month', users.user_created_at) as cohort_month,
        datediff('month', date_trunc('month', users.user_created_at), date_trunc('month', events.event_timestamp)) as cohort_age_months,
        case when events.event_type = 'signup' then 1 else 0 end as step_signup,
        case when events.event_type = 'onboarding_started' then 1 else 0 end as step_onboarding,
        case when events.event_type = 'search_performed' then 1 else 0 end as step_search,
        case when events.event_type = 'checkout_completed' then 1 else 0 end as step_checkout,
        row_number() over (partition by events.session_id order by events.event_timestamp) as event_seq
    from events
    left join users on events.postgres_user_id = users.postgres_user_id
)
select * from session_events
