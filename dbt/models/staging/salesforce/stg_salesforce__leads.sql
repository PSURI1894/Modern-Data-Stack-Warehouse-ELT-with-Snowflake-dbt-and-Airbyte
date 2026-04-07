with source as (
    select * from {{ source('salesforce', 'leads') }}
),
renamed as (
    select
        id as lead_id,
        firstname as first_name,
        lastname as last_name,
        email,
        company,
        status as lead_status,
        leadsource as lead_source,
        createddate as created_at
    from source
)
select * from renamed
