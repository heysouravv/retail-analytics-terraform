# Create CloudWatch dashboard for data lake monitoring
resource "aws_cloudwatch_dashboard" "data_lake_dashboard" {
  dashboard_name = "${var.project_name}-data-lake-dashboard-${var.environment}"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Glue", "ETL_JOB_RUNTIME", "JobName", var.glue_job_names["transform_sales"], { "stat": "Average", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_RUNTIME", "JobName", var.glue_job_names["transform_inventory"], { "stat": "Average", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_RUNTIME", "JobName", var.glue_job_names["transform_customers"], { "stat": "Average", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_RUNTIME", "JobName", var.glue_job_names["analytics_aggregation"], { "stat": "Average", "period": 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "ETL Job Runtimes"
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Glue", "ETL_JOB_SUCCEEDED", "JobName", var.glue_job_names["transform_sales"], { "stat": "Sum", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_SUCCEEDED", "JobName", var.glue_job_names["transform_inventory"], { "stat": "Sum", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_SUCCEEDED", "JobName", var.glue_job_names["transform_customers"], { "stat": "Sum", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_SUCCEEDED", "JobName", var.glue_job_names["analytics_aggregation"], { "stat": "Sum", "period": 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "ETL Job Success"
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Glue", "ETL_JOB_FAILED", "JobName", var.glue_job_names["transform_sales"], { "stat": "Sum", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_FAILED", "JobName", var.glue_job_names["transform_inventory"], { "stat": "Sum", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_FAILED", "JobName", var.glue_job_names["transform_customers"], { "stat": "Sum", "period": 300 }],
            ["AWS/Glue", "ETL_JOB_FAILED", "JobName", var.glue_job_names["analytics_aggregation"], { "stat": "Sum", "period": 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "ETL Job Failures"
        }
      }
    ]
  })
}

# Create CloudWatch dashboard for Redshift monitoring
resource "aws_cloudwatch_dashboard" "redshift_dashboard" {
  dashboard_name = "${var.project_name}-redshift-dashboard-${var.environment}"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Redshift", "CPUUtilization", "ClusterIdentifier", var.redshift_cluster_id, { "stat": "Average", "period": 300 }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "Redshift CPU Utilization"
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [