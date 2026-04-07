with source as (
    select * from {{ source('postgres', 'users') }}
),
renamed as (
    select
        id as postgres_user_id,
        email as user_email,
        username,
        is_active,
        created_at
    from source
)
select * from renamed
