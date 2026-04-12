with opps as (
    select
        opportunity_id,
        salesforce_account_id,
        opportunity_name,
        opportunity_amount,
        stage_name,
        probability,
        close_date,
        created_at,
        system_modstamp
    from {{ ref('stg_salesforce__opportunities') }}
),
acc as (
    select
        salesforce_account_id,
        account_name
    from {{ ref('stg_salesforce__accounts') }}
),
joined as (
    select
        opps.opportunity_id,
        opps.salesforce_account_id,
        acc.account_name,
        opps.opportunity_name,
        opps.opportunity_amount,
        case 
            when opps.opportunity_amount > 50000 then 'Enterprise'
            else 'Commercial'
        end as account_tier,
        opps.stage_name,
        opps.probability,
        opps.close_date,
        opps.created_at,
        opps.system_modstamp
    from opps
    left join acc on opps.salesforce_account_id = acc.salesforce_account_id
    where opps.salesforce_account_id is not null
)
select * from joined
