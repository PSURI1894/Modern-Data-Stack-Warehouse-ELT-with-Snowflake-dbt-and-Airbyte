with source as (
    select * from {{ source('postgres', 'users') }}
),
renamed as (
    select
        cast(id as integer) as postgres_user_id,
        cast(email as varchar) as user_email,
        cast(username as varchar) as username,
        cast(is_active as boolean) as is_active,
        cast(created_at as timestamp_ntz) as created_at
    from source
)
select * from renamed
