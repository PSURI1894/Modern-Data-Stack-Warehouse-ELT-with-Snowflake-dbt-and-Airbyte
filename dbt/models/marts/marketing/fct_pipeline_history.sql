with opps as (
    select * from {{ ref('int_opportunities__enriched') }}
),
leads as (
    select 
        email, 
        lead_source, 
        company 
    from {{ ref('stg_salesforce__leads') }}
),
final as (
    select
        opps.opportunity_id,
        opps.salesforce_account_id,
        opps.account_name,
        opps.opportunity_name,
        opps.opportunity_amount,
        opps.account_tier,
        opps.stage_name,
        opps.stage_category,
        opps.probability,
        (opps.opportunity_amount * coalesce(opps.probability, 0) / 100) as expected_revenue_amount,
        case 
            when opps.stage_name = 'Closed Won' then opps.opportunity_amount
            else 0
        end as closed_won_amount,
        case 
            when opps.stage_name not in ('Closed Won', 'Closed Lost') then opps.opportunity_amount
            else 0
        end as open_pipeline_amount,
        coalesce(leads.lead_source, 'direct-organic') as marketing_lead_source,
        datediff('day', opps.created_at, opps.system_modstamp) as opportunity_age_days,
        opps.close_date,
        opps.created_at,
        opps.system_modstamp as snapshot_timestamp
    from opps
    left join leads on lower(opps.account_name) = lower(leads.company)
)
select * from final
