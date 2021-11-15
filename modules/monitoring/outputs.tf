output "data_lake_dashboard_name" {
  description = "Name of the data lake CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.data_lake_dashboard.dashboard_name
}

output "redshift_dashboard_name" {
  description = "Name of the Redshift CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.redshift_dashboard.dashboard_name
}

output "glue_job_alarm_names" {
  description = "Names of the Glue job CloudWatch alarms"
  value       = { for k, v in aws_cloudwatch_metric_alarm.glue_job_failure_alarm : k => v.alarm_name }
}

output "redshift_cpu_alarm_name" {
  description = "Name of the Redshift CPU CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.redshift_high_cpu_alarm.alarm_name
}

output "redshift_disk_alarm_name" {
  description = "Name of the Redshift disk space CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.redshift_disk_space_alarm.alarm_name
}