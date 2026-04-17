-- Snowflake columnar partition key assigned on ordered_at
{{
    config(
        cluster_by=['ordered_at::date']
    )
}}
with charges as (
    select * from {{ ref('stg_stripe__charges') }}
),
customers as (
    select * from {{ ref('int_customers__joined') }}
),
joined as (
    select
        charges.charge_id,
        customers.customer_sk,
        charges.stripe_customer_id,
        charges.amount_cents,
        charges.amount_dollars,
        charges.currency,
        charges.payment_status,
        case 
            when charges.payment_status = 'succeeded' then true
            else false
        end as is_reconciled,
        case 
            when charges.amount_cents > 1000000 then 'enterprise-billing'
            when charges.amount_cents > 100000 then 'standard-midmarket'
            else 'base-retail'
        end as order_tier,
        charges.charge_created_at as ordered_at
    from charges
    left join customers on charges.stripe_customer_id = customers.stripe_customer_id
)
select * from joined
