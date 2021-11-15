variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for Redshift"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Redshift cluster"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to Redshift"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "redshift_role_arn" {
  description = "ARN of the Redshift IAM role"
  type        = string
}

variable "warehouse_database_name" {
  description = "Name of the Redshift database"
  type        = string
  default     = "retail_analytics"
}

variable "warehouse_username" {
  description = "Username for the Redshift master user"
  type        = string
  sensitive   = true
}

variable "warehouse_password" {
  description = "Password for the Redshift master user"
  type        = string
  sensitive   = true
}

variable "redshift_node_type" {
  description = "Node type for the Redshift cluster"
  type        = string
  default     = "dc2.large"
}

variable "redshift_nodes" {
  description = "Number of nodes in the Redshift cluster"
  type        = number
  default     = 2
}

variable "publicly_accessible" {
  description = "Whether the Redshift cluster is publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the cluster"
  type        = bool
  default     = true
}

variable "lake_database_names" {
  description = "Map of Glue Data Catalog database names"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "enable_snapshot_copy" {
  description = "Whether to enable cross-region snapshot copy"
  type        = bool
  default     = false
}

variable "snapshot_copy_kms_key_id" {
  description = "KMS key ID for snapshot copy encryption"
  type        = string
  default     = null
}