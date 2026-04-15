with customers as (
    select * from {{ ref('int_customers__joined') }}
),
charges as (
    select
        stripe_customer_id,
        sum(amount_cents) as total_ltv_cents,
        count(charge_id) as total_charges_count
    from {{ ref('stg_stripe__charges') }}
    where payment_status = 'succeeded'
    group by 1
),
joined as (
    select
        customers.customer_sk,
        customers.stripe_customer_id,
        customers.salesforce_account_id,
        customers.postgres_user_id,
        customers.customer_name,
        customers.customer_email,
        coalesce(charges.total_ltv_cents, 0) as total_ltv_cents,
        {{ cents_to_dollars('coalesce(charges.total_ltv_cents, 0)') }} as total_ltv_dollars,
        coalesce(charges.total_charges_count, 0) as total_charges_count,
        case 
            when coalesce(charges.total_ltv_cents, 0) > 100000 then 95
            when coalesce(charges.total_ltv_cents, 0) > 50000 then 80
            else 60
        end as customer_health_score,
        customers.account_created_at as created_at
    from customers
    left join charges on customers.stripe_customer_id = charges.stripe_customer_id
)
select * from joined
