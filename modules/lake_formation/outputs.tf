output "database_names" {
  description = "Names of the Glue Data Catalog databases"
  value = {
    raw       = aws_glue_catalog_database.raw_db.name
    staged    = aws_glue_catalog_database.staged_db.name
    analytics = aws_glue_catalog_database.analytics_db.name
  }
}

output "raw_database_name" {
  description = "Name of the raw data database"
  value       = aws_glue_catalog_database.raw_db.name
}

output "staged_database_name" {
  description = "Name of the staged data database"
  value       = aws_glue_catalog_database.staged_db.name
}

output "analytics_database_name" {
  description = "Name of the analytics data database"
  value       = aws_glue_catalog_database.analytics_db.name
}