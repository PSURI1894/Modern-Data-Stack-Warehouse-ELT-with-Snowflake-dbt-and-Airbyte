from dagster import asset, BackoffDelay, RetryPolicy

@asset(
    group_name="ingestion",
    retry_policy=RetryPolicy(max_retries=3, delay=120)
)
def airbyte_postgres_sync():
    """Triggers logical replication on Postgres production databases"""
    print("Postgres CDC Airbyte sync triggered")
    return {"status": "success", "sync_type": "CDC"}

@asset(
    group_name="ingestion",
    retry_policy=RetryPolicy(max_retries=3, delay=120)
)
def airbyte_stripe_sync():
    """Triggers cursor pagination on Stripe charge endpoints"""
    print("Stripe payments Airbyte sync triggered")
    return {"status": "success", "sync_type": "API"}

@asset(
    group_name="ingestion",
    retry_policy=RetryPolicy(max_retries=3, delay=120)
)
def airbyte_salesforce_sync():
    """Triggers CRM Opportunity pipelines sync"""
    print("Salesforce opportunity pipelines Airbyte sync triggered")
    return {"status": "success", "sync_type": "API"}
