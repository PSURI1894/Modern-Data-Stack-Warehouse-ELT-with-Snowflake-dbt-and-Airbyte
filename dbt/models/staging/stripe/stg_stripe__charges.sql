with source as (
    select * from {{ source('stripe', 'charges') }}
),
renamed as (
    select
        cast(id as varchar) as charge_id,
        cast(customer as varchar) as stripe_customer_id,
        cast(amount as numeric) as amount_cents,
        {{ cents_to_dollars('amount') }} as amount_dollars,
        cast(currency as varchar) as currency,
        cast(status as varchar) as payment_status,
        cast(created as timestamp_ntz) as charge_created_at
    from source
)
select * from renamed
