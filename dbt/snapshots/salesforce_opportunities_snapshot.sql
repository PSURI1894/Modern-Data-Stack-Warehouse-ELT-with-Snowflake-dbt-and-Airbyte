{% snapshot salesforce_opportunities_snapshot %}

{{
    config(
      target_database='ANALYTICS',
      target_schema='snapshots',
      unique_key='opportunity_id',
      strategy='timestamp',
      updated_at='system_modstamp',
    )
}}

select * from {{ ref('stg_salesforce__opportunities') }}

{% endsnapshot %}
