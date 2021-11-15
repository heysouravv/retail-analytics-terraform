output "lakeformation_role_arn" {
  description = "ARN of the Lake Formation service role"
  value       = aws_iam_role.lakeformation_role.arn
}

output "data_lake_admin_role_arn" {
  description = "ARN of the data lake admin role"
  value       = aws_iam_role.data_lake_admin_role.arn
}

output "glue_role_arn" {
  description = "ARN of the AWS Glue service role"
  value       = aws_iam_role.glue_role.arn
}

output "redshift_role_arn" {
  description = "ARN of the Redshift service role"
  value       = aws_iam_role.redshift_role.arn
}

output "data_analyst_role_arn" {
  description = "ARN of the data analyst role"
  value       = aws_iam_role.data_analyst_role.arn
}