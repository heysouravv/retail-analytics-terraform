output "bucket_arns" {
  description = "ARNs of created S3 buckets"
  value = {
    raw       = aws_s3_bucket.data_lake_bucket["raw"].arn
    staged    = aws_s3_bucket.data_lake_bucket["staged"].arn
    analytics = aws_s3_bucket.data_lake_bucket["analytics"].arn
    scripts   = aws_s3_bucket.scripts_bucket.arn
    logs      = aws_s3_bucket.logs_bucket.arn
  }
}

output "bucket_names" {
  description = "Names of created S3 buckets"
  value = {
    raw       = aws_s3_bucket.data_lake_bucket["raw"].id
    staged    = aws_s3_bucket.data_lake_bucket["staged"].id
    analytics = aws_s3_bucket.data_lake_bucket["analytics"].id
    scripts   = aws_s3_bucket.scripts_bucket.id
    logs      = aws_s3_bucket.logs_bucket.id
  }
}

output "raw_bucket_name" {
  description = "Name of the raw data bucket"
  value       = aws_s3_bucket.data_lake_bucket["raw"].id
}

output "staged_bucket_name" {
  description = "Name of the staged data bucket"
  value       = aws_s3_bucket.data_lake_bucket["staged"].id
}

output "analytics_bucket_name" {
  description = "Name of the analytics data bucket"
  value       = aws_s3_bucket.data_lake_bucket["analytics"].id
}

output "scripts_bucket_name" {
  description = "Name of the scripts bucket"
  value       = aws_s3_bucket.scripts_bucket.id
}

output "logs_bucket_name" {
  description = "Name of the logs bucket"
  value       = aws_s3_bucket.logs_bucket.id
}