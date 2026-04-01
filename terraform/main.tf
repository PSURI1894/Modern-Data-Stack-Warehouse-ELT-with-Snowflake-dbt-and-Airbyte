# Base database layout
resource "snowflake_database" "raw" {
  name    = "RAW"
  comment = "Raw SaaS and transactional data database"
}

resource "snowflake_database" "analytics" {
  name    = "ANALYTICS"
  comment = "Analytics engineering database for staging, intermediate, and marts"
}

# Warehouses
resource "snowflake_warehouse" "loading_wh" {
  name           = "LOADING_WH"
  warehouse_size = "X-SMALL"
  auto_suspend   = 60
  auto_resume    = true
  comment        = "Warehouse for Airbyte raw syncs"
}

resource "snowflake_warehouse" "transforming_wh" {
  name           = "TRANSFORMING_WH"
  warehouse_size = "SMALL"
  auto_suspend   = 60
  auto_resume    = true
  min_cluster_count = 1
  max_cluster_count = 3
  comment        = "Multi-cluster warehouse for dbt models execution"
}
