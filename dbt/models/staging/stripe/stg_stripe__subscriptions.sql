with source as (
    select * from {{ source('stripe', 'subscriptions') }}
),
renamed as (
    select
        id as subscription_id,
        customer as stripe_customer_id,
        status as subscription_status,
        plan_id,
        quantity,
        start_date as started_at,
        current_period_start as period_start_at,
        current_period_end as period_end_at,
        canceled_at
    from source
)
select * from renamed
