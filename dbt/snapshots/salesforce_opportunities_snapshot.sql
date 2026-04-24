-- Snapshot tracking modifications in Salesforce stages
-- Hard delete tracking enabled to catch remote CRM deletes
{% snapshot salesforce_opportunities_snapshot %}

{{
    config(
      target_database='ANALYTICS',
      target_schema='snapshots',
      unique_key='opportunity_id',
      strategy='timestamp',
      updated_at='system_modstamp',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('stg_salesforce__opportunities') }}

{% endsnapshot %}
