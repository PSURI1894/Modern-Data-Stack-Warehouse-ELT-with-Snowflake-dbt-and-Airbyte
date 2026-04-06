with source as (
    select * from {{ source('stripe', 'charges') }}
),
renamed as (
    select
        id as charge_id,
        customer as stripe_customer_id,
        amount as amount_cents,
        {{ cents_to_dollars('amount') }} as amount_dollars,
        currency,
        status as payment_status,
        created as charge_created_at
    from source
)
select * from renamed
