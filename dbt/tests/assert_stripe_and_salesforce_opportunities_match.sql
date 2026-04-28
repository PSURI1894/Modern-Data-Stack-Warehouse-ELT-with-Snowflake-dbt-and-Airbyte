-- Cross-integration billing validation.
-- Identifies closed deals with unmatched actual Stripe subscription amounts.
with sf_opps as (
    select
        salesforce_account_id,
        sum(opportunity_amount) as total_opp_amount
    from {{ ref('fct_pipeline_history') }}
    where stage_name = 'Closed Won'
    group by 1
),
stripe_subs as (
    select
        salesforce_account_id,
        sum(monthly_recurring_revenue_dollars) as total_stripe_mrr
    from {{ ref('fct_subscription_events') }}
    group by 1
)
select
    sf_opps.salesforce_account_id,
    sf_opps.total_opp_amount,
    stripe_subs.total_stripe_mrr
from sf_opps
join stripe_subs on sf_opps.salesforce_account_id = stripe_subs.salesforce_account_id
-- Alert on > 10% discrepancy margins between pipeline sales and billing engines
where abs(sf_opps.total_opp_amount - stripe_subs.total_stripe_mrr) / nullif(sf_opps.total_opp_amount, 0) > 0.10
