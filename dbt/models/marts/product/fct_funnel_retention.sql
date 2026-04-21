with events as (
    select * from {{ ref('stg_postgres__events') }}
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
        datediff('month', date_trunc('month', users.user_created_at), date_trunc('month', events.event_timestamp)) as cohort_age_months
    from events
    left join users on events.postgres_user_id = users.postgres_user_id
)
select * from session_events
