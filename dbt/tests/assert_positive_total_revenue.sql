-- Total monthly recurring revenue should always be positive or zero.
select
    subscription_id,
    monthly_recurring_revenue_cents
from {{ ref('fct_subscription_events') }}
where monthly_recurring_revenue_cents < 0
