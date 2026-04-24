{% snapshot stripe_subscriptions_snapshot %}

{{
    config(
      target_database='ANALYTICS',
      target_schema='snapshots',
      unique_key='subscription_id',
      strategy='timestamp',
      updated_at='period_start_at',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('stg_stripe__subscriptions') }}

{% endsnapshot %}
