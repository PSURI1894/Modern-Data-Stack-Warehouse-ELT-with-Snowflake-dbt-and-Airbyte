with subscriptions as (
    select * from {{ ref('int_subscriptions__joined') }}
),
final as (
    select
        subscription_id,
        customer_sk,
        stripe_customer_id,
        salesforce_account_id,
        subscription_status,
        plan_id,
        quantity,
        unit_amount_cents,
        (quantity * unit_amount_cents) as monthly_recurring_revenue_cents,
        {{ cents_to_dollars('(quantity * unit_amount_cents)') }} as monthly_recurring_revenue_dollars,
        started_at,
        period_start_at,
        period_end_at,
        canceled_at
    from subscriptions
)
select * from final
