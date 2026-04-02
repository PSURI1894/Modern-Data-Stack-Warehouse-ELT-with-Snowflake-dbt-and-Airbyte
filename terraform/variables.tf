variable "snowflake_account" {
  type        = string
  description = "Snowflake Account Locator"
}

variable "snowflake_user" {
  type        = string
  description = "Snowflake Username"
}

variable "snowflake_password" {
  type        = string
  sensitive   = true
  description = "Snowflake Password"
}
