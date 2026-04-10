with opps as (
    select * from {{ ref('stg_salesforce__opportunities') }}
),
acc as (
    select * from {{ ref('stg_salesforce__accounts') }}
),
joined as (
    select
        opps.opportunity_id,
        opps.salesforce_account_id,
        acc.account_name,
        opps.opportunity_name,
        opps.opportunity_amount,
        opps.stage_name,
        opps.probability,
        opps.close_date,
        opps.created_at,
        opps.system_modstamp
    from opps
    left join acc on opps.salesforce_account_id = acc.salesforce_account_id
)
select * from joined
