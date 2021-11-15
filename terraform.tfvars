# Project configuration
project_name = "retail-analytics"
environment  = "dev"
aws_region   = "us-east-1"

# VPC configuration
vpc_id      = "vpc-12345678" # Replace with your VPC ID
subnet_ids  = ["subnet-12345678", "subnet-87654321"] # Replace with your subnet IDs

# Redshift configuration
warehouse_username     = "admin"
warehouse_password     = "StrongPassword123!" # Use AWS Secrets Manager in production
redshift_node_type     = "dc2.large"
redshift_nodes         = 2

# Data sources
data_sources           = ["sales", "inventory", "customers"]

# Admin user
data_lake_admin        = "arn:aws:iam::123456789012:user/data-lake-admin" # Replace with your admin user ARN