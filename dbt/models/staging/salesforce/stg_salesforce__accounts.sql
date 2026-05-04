with source as (
    select * from {{ source('salesforce', 'accounts') }}
),
renamed as (
    select
        cast(id as varchar) as salesforce_account_id,
        cast(name as varchar) as account_name,
        cast(type as varchar) as account_type,
        cast(billingstate as varchar) as billing_state,
        cast(billingcountry as varchar) as billing_country,
        cast(createddate as timestamp_ntz) as created_at
    from source
)
select * from renamed
