with source as (
    select * from {{ source('salesforce', 'opportunities') }}
),
renamed as (
    select
        cast(id as varchar) as opportunity_id,
        cast(accountid as varchar) as salesforce_account_id,
        cast(name as varchar) as opportunity_name,
        cast(amount as numeric) as opportunity_amount,
        cast(stagename as varchar) as stage_name,
        cast(probability as numeric) as probability,
        cast(closedate as date) as close_date,
        cast(createddate as timestamp_ntz) as created_at,
        cast(systemmodstamp as timestamp_ntz) as system_modstamp
    from source
)
select * from renamed
