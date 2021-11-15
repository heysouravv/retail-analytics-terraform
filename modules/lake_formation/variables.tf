variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "data_lake_admin_arn" {
  description = "ARN of the data lake admin role"
  type        = string
}

variable "s3_bucket_arns" {
  description = "Map of S3 bucket ARNs"
  type        = map(string)
}

variable "lakeformation_role_arn" {
  description = "ARN of the Lake Formation service role"
  type        = string
  default     = ""
}

variable "glue_role_arn" {
  description = "ARN of the Glue service role"
  type        = string
  default     = ""
}

variable "redshift_role_arn" {
  description = "ARN of the Redshift service role"
  type        = string
  default     = ""
}

variable "data_analyst_role_arns" {
  description = "List of ARNs for data analyst roles"
  type        = list(string)
  default     = []
}