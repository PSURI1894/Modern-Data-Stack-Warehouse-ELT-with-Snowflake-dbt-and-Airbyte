with stripe_cust as (
    select * from {{ ref('stg_stripe__customers') }}
),
sf_account as (
    select * from {{ ref('stg_salesforce__accounts') }}
),
pg_user as (
    select * from {{ ref('stg_postgres__users') }}
),
joined as (
    select
        stripe_cust.stripe_customer_id,
        sf_account.salesforce_account_id,
        pg_user.postgres_user_id,
        coalesce(stripe_cust.customer_name, sf_account.account_name) as customer_name,
        lower(coalesce(stripe_cust.customer_email, pg_user.user_email)) as customer_email,
        coalesce(stripe_cust.created_at, sf_account.created_at) as created_at
    from stripe_cust
    full outer join sf_account on lower(stripe_cust.customer_name) = lower(sf_account.account_name)
    full outer join pg_user on lower(stripe_cust.customer_email) = lower(pg_user.user_email)
)
select * from joined
