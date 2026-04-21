with events as (
    select * from {{ ref('stg_postgres__events') }}
),
session_events as (
    select
        event_id,
        postgres_user_id,
        event_type,
        session_id,
        event_timestamp,
        -- Sequence tracking inside session
        row_number() over (partition by session_id order by event_timestamp) as event_seq_num
    from events
)
select * from session_events
