with source as (
    select * from {{ source('postgres', 'events') }}
),
renamed as (
    select
        id as event_id,
        user_id as postgres_user_id,
        event_type,
        session_id,
        created_at as event_timestamp
    from source
)
select * from renamed
