variable "project_name" {
  description = "Name of the retail analytics project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "data_sources" {
  description = "List of data sources for the data lake"
  type        = list(string)
  default     = ["sales", "inventory", "customers"]
}