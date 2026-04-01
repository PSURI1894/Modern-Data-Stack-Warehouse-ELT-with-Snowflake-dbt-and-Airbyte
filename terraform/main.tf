# Base database layout
resource "snowflake_database" "raw" {
  name    = "RAW"
  comment = "Raw SaaS and transactional data database"
}

resource "snowflake_database" "analytics" {
  name    = "ANALYTICS"
  comment = "Analytics engineering database for staging, intermediate, and marts"
}
