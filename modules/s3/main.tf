# Create S3 buckets for the data lake layers
resource "aws_s3_bucket" "data_lake_bucket" {
  for_each = toset(["raw", "staged", "analytics"])
  
  bucket = "${var.project_name}-datalake-${each.key}-${var.environment}"
  
  tags = {
    Name        = "${var.project_name}-datalake-${each.key}"
    Environment = var.environment
    Project     = var.project_name
    Layer       = each.key
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = aws_s3_bucket.data_lake_bucket
  
  bucket = each.value.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  for_each = aws_s3_bucket.data_lake_bucket

  bucket = each.value.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create separate bucket for scripts and code
resource "aws_s3_bucket" "scripts_bucket" {
  bucket = "${var.project_name}-scripts-${var.environment}"
  
  tags = {
    Name        = "${var.project_name}-scripts"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create separate bucket for logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "${var.project_name}-logs-${var.environment}"
  
  tags = {
    Name        = "${var.project_name}-logs"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Upload sample Glue ETL scripts
resource "aws_s3_object" "sample_etl_scripts" {
  for_each = {
    "transform_sales.py"      = "scripts/transform_sales.py", 
    "transform_inventory.py"  = "scripts/transform_inventory.py",
    "transform_customers.py"  = "scripts/transform_customers.py",
    "analytics_aggregation.py" = "scripts/analytics_aggregation.py"
  }
  
  bucket = aws_s3_bucket.scripts_bucket.id
  key    = each.value
  source = "${path.module}/${each.key}"
  etag   = filemd5("${path.module}/${each.key}")
}

# Create folder structure in raw bucket for different data sources
resource "aws_s3_object" "raw_folders" {
  for_each = toset(var.data_sources)
  
  bucket = aws_s3_bucket.data_lake_bucket["raw"].id
  key    = "${each.key}/"
  content_type = "application/x-directory"
}