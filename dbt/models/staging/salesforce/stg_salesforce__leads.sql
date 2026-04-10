with source as (
    select * from {{ source('salesforce', 'leads') }}
),
renamed as (
    select
        cast(id as varchar) as lead_id,
        cast(firstname as varchar) as first_name,
        cast(lastname as varchar) as last_name,
        lower(cast(email as varchar)) as email,
        cast(company as varchar) as company,
        cast(status as varchar) as lead_status,
        cast(leadsource as varchar) as lead_source,
        cast(createddate as timestamp_ntz) as created_at
    from source
)
select * from renamed
