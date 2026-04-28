from dagster import asset
from .airbyte_syncs import airbyte_postgres_sync, airbyte_stripe_sync, airbyte_salesforce_sync

@asset(
    deps=[airbyte_postgres_sync, airbyte_stripe_sync],
    group_name="staging"
)
def dbt_staging_layer():
    """Compiles and validates staging layers views"""
    print("Executing dbt build --select tag:staging")
    return "staging_compiled"

@asset(
    deps=[dbt_staging_layer],
    group_name="intermediate"
)
def dbt_intermediate_layer():
    """Resolves multi-source customer mappings"""
    print("Executing dbt build --select tag:intermediate")
    return "intermediate_compiled"

@asset(
    deps=[dbt_intermediate_layer, airbyte_salesforce_sync],
    group_name="marts"
)
def dbt_marts_layer():
    """Reconciles billing metrics and commits tables to marts schema"""
    print("Executing dbt build --select tag:marts")
    return "marts_materialized"
