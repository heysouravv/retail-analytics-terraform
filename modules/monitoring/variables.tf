variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "glue_job_names" {
  description = "Map of Glue job names"
  type        = map(string)
}

variable "redshift_cluster_id" {
  description = "ID of the Redshift cluster"
  type        = string
}

variable "alarm_sns_topic_arn" {
  description = "ARN of the SNS topic for alarm notifications"
  type        = string
  default     = ""
}