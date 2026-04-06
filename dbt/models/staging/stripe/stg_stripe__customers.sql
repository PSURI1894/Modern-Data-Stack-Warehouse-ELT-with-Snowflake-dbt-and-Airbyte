with source as (
    select * from {{ source('stripe', 'customers') }}
),
renamed as (
    select
        id as stripe_customer_id,
        email as customer_email,
        name as customer_name,
        created as created_at
    from source
)
select * from renamed
