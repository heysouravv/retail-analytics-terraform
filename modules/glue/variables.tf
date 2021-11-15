variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN of the Glue service role"
  type        = string
}

variable "s3_bucket_names" {
  description = "Map of S3 bucket names"
  type        = map(string)
}

variable "database_names" {
  description = "Map of Glue Data Catalog database names"
  type        = map(string)
}