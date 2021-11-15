output "crawler_names" {
  description = "Names of the created Glue crawlers"
  value = {
    sales     = aws_glue_crawler.sales_crawler.name
    inventory = aws_glue_crawler.inventory_crawler.name
    customers = aws_glue_crawler.customers_crawler.name
  }
}

output "job_names" {
  description = "Names of the created Glue jobs"
  value = {
    transform_sales      = aws_glue_job.transform_sales.name
    transform_inventory  = aws_glue_job.transform_inventory.name
    transform_customers  = aws_glue_job.transform_customers.name
    analytics_aggregation = aws_glue_job.analytics_aggregation.name
  }
}

output "workflow_name" {
  description = "Name of the ETL workflow"
  value       = aws_glue_workflow.etl_workflow.name
}

output "trigger_names" {
  description = "Names of the workflow triggers"
  value = {
    crawlers  = aws_glue_trigger.crawlers_trigger.name
    transform = aws_glue_trigger.transform_trigger.name
    analytics = aws_glue_trigger.analytics_trigger.name
  }
}