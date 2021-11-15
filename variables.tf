variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
  default     = "retail-analytics"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where Redshift cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Redshift cluster"
  type        = list(string)
}

variable "warehouse_username" {
  description = "Username for Redshift warehouse"
  type        = string
  sensitive   = true
}

variable "warehouse_password" {
  description = "Password for Redshift warehouse"
  type        = string
  sensitive   = true
}

variable "redshift_node_type" {
  description = "Node type for Redshift cluster"
  type        = string
  default     = "dc2.large"
}

variable "redshift_nodes" {
  description = "Number of nodes for Redshift cluster"
  type        = number
  default     = 2
}

variable "data_sources" {
  description = "List of data sources for the data lake"
  type        = list(string)
  default     = ["sales", "inventory", "customers"]
}

variable "data_lake_admin" {
  description = "ARN of the IAM user/role who will be Lake Formation admin"
  type        = string
}