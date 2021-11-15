variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "s3_buckets" {
  description = "Map of S3 bucket ARNs"
  type        = map(string)
}

variable "data_lake_admin" {
  description = "ARN of the IAM user/role who will be the Lake Formation admin"
  type        = string
  default     = ""
}

variable "data_analyst_principals" {
  description = "List of ARNs for principals who will have data analyst access"
  type        = list(string)
  default     = []
}