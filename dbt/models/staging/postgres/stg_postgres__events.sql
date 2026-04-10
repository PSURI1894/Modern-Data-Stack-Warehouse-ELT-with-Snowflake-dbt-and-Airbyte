with source as (
    select * from {{ source('postgres', 'events') }}
),
renamed as (
    select
        cast(id as varchar) as event_id,
        cast(user_id as integer) as postgres_user_id,
        cast(event_type as varchar) as event_type,
        cast(session_id as varchar) as session_id,
        cast(created_at as timestamp_ntz) as event_timestamp
    from source
)
select * from renamed
