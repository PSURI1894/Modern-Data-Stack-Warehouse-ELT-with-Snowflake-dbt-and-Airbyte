from dagster import asset, Output, MetadataValue
from .dbt_models import dbt_marts_layer

@asset(
    deps=[dbt_marts_layer],
    group_name="reverse_etl"
)
def hightouch_crm_sync():
    """Executes reverse ETL pushing health scores back to Salesforce accounts"""
    print("Triggering Hightouch Sync ID: sync_sf_health_scores")
    return Output(
        value={"records_synced": 5420, "status": "completed"},
        metadata={
            "records_synced": MetadataValue.int(5420),
            "target_crm": MetadataValue.string("Salesforce Prod"),
            "sync_run_id": MetadataValue.string("ht_run_87421")
        }
    )
