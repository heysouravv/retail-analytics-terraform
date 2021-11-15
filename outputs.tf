output "s3_bucket_names" {
  description = "Names of created S3 buckets"
  value       = module.s3_datalake.bucket_names
}

output "glue_database_names" {
  description = "Names of Glue databases"
  value       = module.lake_formation.database_names
}

output "glue_job_names" {
  description = "Names of Glue ETL jobs"
  value       = module.glue.job_names
}

output "glue_workflow_name" {
  description = "Name of the ETL workflow"
  value       = module.glue.workflow_name
}

output "redshift_cluster_endpoint" {
  description = "Endpoint for the Redshift cluster"
  value       = module.redshift.cluster_endpoint
}

output "redshift_connection_string" {
  description = "JDBC connection string for Redshift"
  value       = module.redshift.redshift_connection_string
  sensitive   = true
}

output "dashboard_urls" {
  description = "URLs for CloudWatch dashboards"
  value = {
    data_lake = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.data_lake_dashboard_name}"
    redshift  = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.redshift_dashboard_name}"
  }
}