-- Timezone forced to UTC
with source as (
    select * from {{ source('stripe', 'customers') }}
),
renamed as (
    select
        cast(id as varchar) as stripe_customer_id,
        lower(cast(email as varchar)) as customer_email,
        cast(name as varchar) as customer_name,
        cast(created as timestamp_ntz) as created_at
    from source
)
select * from renamed
where customer_email is not null
