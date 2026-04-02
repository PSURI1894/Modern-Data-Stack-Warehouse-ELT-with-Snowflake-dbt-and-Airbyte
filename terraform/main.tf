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

resource "snowflake_warehouse" "bi_wh" {
  name           = "BI_WH"
  warehouse_size = "X-SMALL"
  auto_suspend   = 60
  auto_resume    = true
  comment        = "Warehouse for Lightdash and BI tool queries"
}

# Roles
resource "snowflake_role" "loader_role" {
  name = "LOADER_ROLE"
}

resource "snowflake_role" "transformer_role" {
  name = "TRANSFORMER_ROLE"
}

resource "snowflake_role" "bi_role" {
  name = "BI_ROLE"
}

# Grants
resource "snowflake_database_grant" "raw_loader" {
  database_name = snowflake_database.raw.name
  privilege     = "USAGE"
  roles         = [snowflake_role.loader_role.name]
}

resource "snowflake_database_grant" "analytics_transformer" {
  database_name = snowflake_database.analytics.name
  privilege     = "ALL"
  roles         = [snowflake_role.transformer_role.name]
}

resource "snowflake_database_grant" "analytics_bi" {
  database_name = snowflake_database.analytics.name
  privilege     = "USAGE"
  roles         = [snowflake_role.bi_role.name]
}
