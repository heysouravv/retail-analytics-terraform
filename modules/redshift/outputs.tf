output "cluster_id" {
  description = "The ID of the Redshift cluster"
  value       = aws_redshift_cluster.warehouse.id
}

output "cluster_endpoint" {
  description = "The connection endpoint for the Redshift cluster"
  value       = aws_redshift_cluster.warehouse.endpoint
}

output "cluster_database_name" {
  description = "The name of the default database in the Redshift cluster"
  value       = aws_redshift_cluster.warehouse.database_name
}

output "cluster_security_group_id" {
  description = "The security group ID of the Redshift cluster"
  value       = aws_security_group.redshift_sg.id
}

output "redshift_connection_string" {
  description = "JDBC connection string for the Redshift cluster"
  value       = "jdbc:redshift://${aws_redshift_cluster.warehouse.endpoint}/${aws_redshift_cluster.warehouse.database_name}"
  sensitive   = true
}