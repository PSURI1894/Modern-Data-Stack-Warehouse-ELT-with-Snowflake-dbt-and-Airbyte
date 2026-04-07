with source as (
    select * from {{ source('salesforce', 'opportunities') }}
),
renamed as (
    select
        id as opportunity_id,
        accountid as salesforce_account_id,
        name as opportunity_name,
        amount as opportunity_amount,
        stagename as stage_name,
        probability,
        closedate as close_date,
        createddate as created_at,
        systemmodstamp as system_modstamp
    from source
)
select * from renamed
