with source as (
    select * from {{ source('stripe', 'subscriptions') }}
),
renamed as (
    select
        cast(id as varchar) as subscription_id,
        cast(customer as varchar) as stripe_customer_id,
        cast(status as varchar) as subscription_status,
        cast(plan_id as varchar) as plan_id,
        cast(quantity as integer) as quantity,
        cast(start_date as timestamp_ntz) as started_at,
        cast(current_period_start as timestamp_ntz) as period_start_at,
        cast(current_period_end as timestamp_ntz) as period_end_at,
        cast(canceled_at as timestamp_ntz) as canceled_at
    from source
)
select * from renamed
