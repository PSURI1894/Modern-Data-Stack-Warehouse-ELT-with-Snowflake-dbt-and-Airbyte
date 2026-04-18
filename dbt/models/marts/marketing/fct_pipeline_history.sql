with opps as (
    select * from {{ ref('int_opportunities__enriched') }}
),
final as (
    select
        opportunity_id,
        salesforce_account_id,
        account_name,
        opportunity_name,
        opportunity_amount,
        account_tier,
        stage_name,
        stage_category,
        probability,
        close_date,
        created_at,
        system_modstamp as snapshot_timestamp
    from opps
)
select * from final
