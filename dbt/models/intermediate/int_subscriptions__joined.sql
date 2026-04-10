with subs as (
    select * from {{ ref('stg_stripe__subscriptions') }}
),
cust as (
    select * from {{ ref('int_customers__joined') }}
),
joined as (
    select
        subs.subscription_id,
        subs.stripe_customer_id,
        cust.salesforce_account_id,
        subs.subscription_status,
        subs.plan_id,
        subs.quantity,
        subs.started_at,
        subs.period_start_at,
        subs.period_end_at,
        subs.canceled_at
    from subs
    left join cust on subs.stripe_customer_id = cust.stripe_customer_id
)
select * from joined
