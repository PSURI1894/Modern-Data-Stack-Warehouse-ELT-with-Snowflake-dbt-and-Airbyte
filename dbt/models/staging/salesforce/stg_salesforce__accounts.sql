with source as (
    select * from {{ source('salesforce', 'accounts') }}
),
renamed as (
    select
        id as salesforce_account_id,
        name as account_name,
        type as account_type,
        billingstate as billing_state,
        billingcountry as billing_country,
        createddate as created_at
    from source
)
select * from renamed
