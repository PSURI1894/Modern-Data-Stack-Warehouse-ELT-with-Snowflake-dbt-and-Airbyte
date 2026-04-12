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
        coalesce(subs.subscription_status, 'unknown') as subscription_status,
        subs.plan_id,
        case 
            when subs.plan_id = 'plan_premium_monthly' then 15000
            when subs.plan_id = 'plan_premium_yearly' then 120000
            else 0
        end as unit_amount_cents,
        subs.quantity,
        subs.started_at,
        subs.period_start_at,
        subs.period_end_at,
        subs.canceled_at
    from subs
    left join cust on subs.stripe_customer_id = cust.stripe_customer_id
)
select * from joined
