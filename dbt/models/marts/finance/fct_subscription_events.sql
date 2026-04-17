{{
    config(
        materialized='incremental',
        unique_key='subscription_id',
        on_schema_change='sync_all_columns'
    )
}}

with subscriptions as (
    select * from {{ ref('int_subscriptions__joined') }}
    {% if is_incremental() %}
    where period_start_at >= (select max(period_start_at) from {{ this }}) - interval '3 days'
    {% endif %}
),

final as (
    select
        subscription_id,
        customer_sk,
        stripe_customer_id,
        salesforce_account_id,
        subscription_status,
        lag(subscription_status) over (partition by subscription_id order by period_start_at) as previous_status,
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
