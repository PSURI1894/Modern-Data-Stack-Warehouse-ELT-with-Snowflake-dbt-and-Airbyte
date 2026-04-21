with events as (
    select * from {{ ref('stg_postgres__events') }}
),
final as (
    select
        event_id,
        postgres_user_id,
        event_type,
        session_id,
        event_timestamp
    from events
)
select * from final
