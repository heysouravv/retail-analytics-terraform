# Create security group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "${var.project_name}-redshift-sg-${var.environment}"
  description = "Security group for Redshift cluster"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "Allow Redshift traffic"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name        = "${var.project_name}-redshift-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create subnet group for Redshift
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name        = "${var.project_name}-redshift-subnet-group-${var.environment}"
  description = "Redshift subnet group for ${var.project_name}"
  subnet_ids  = var.subnet_ids
  
  tags = {
    Name        = "${var.project_name}-redshift-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create parameter group for Redshift
resource "aws_redshift_parameter_group" "redshift_parameter_group" {
  name        = "${var.project_name}-redshift-params-${var.environment}"
  description = "Redshift parameter group for ${var.project_name}"
  family      = "redshift-1.0"
  
  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }
  
  parameter {
    name  = "require_ssl"
    value = "true"
  }
  
  parameter {
    name  = "auto_analyze"
    value = "true"
  }
  
  tags = {
    Name        = "${var.project_name}-redshift-params"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create Redshift cluster
resource "aws_redshift_cluster" "warehouse" {
  cluster_identifier           = "${var.project_name}-warehouse-${var.environment}"
  database_name                = var.warehouse_database_name
  master_username              = var.warehouse_username
  master_password              = var.warehouse_password
  node_type                    = var.redshift_node_type
  cluster_type                 = var.redshift_nodes > 1 ? "multi-node" : "single-node"
  number_of_nodes              = var.redshift_nodes > 1 ? var.redshift_nodes : null
  
  vpc_security_group_ids       = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name    = aws_redshift_subnet_group.redshift_subnet_group.name
  cluster_parameter_group_name = aws_redshift_parameter_group.redshift_parameter_group.name
  
  publicly_accessible    = var.publicly_accessible
  encrypted              = true
  enhanced_vpc_routing   = true
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-warehouse-final-${var.environment}"
  
  iam_roles              = [var.redshift_role_arn]
  
  tags = {
    Name        = "${var.project_name}-warehouse"
    Environment = var.environment
    Project     = var.project_name
  }
  
  lifecycle {
    prevent_destroy = false
  }
}

# Create schemas to organize the data warehouse
resource "aws_redshift_scheduled_action" "create_schemas" {
  name     = "${var.project_name}-create-schemas-${var.environment}"
  schedule = "cron(0 2 * * ? *)"  # Run daily at 2 AM UTC
  
  target_action {
    sql_statement = <<EOF
      -- Create schemas for warehouse organization
      CREATE SCHEMA IF NOT EXISTS sales;
      CREATE SCHEMA IF NOT EXISTS inventory;
      CREATE SCHEMA IF NOT EXISTS customers;
      CREATE SCHEMA IF NOT EXISTS analytics;
      
      -- Create spectrum schema for data lake access
      CREATE EXTERNAL SCHEMA IF NOT EXISTS spectrum
      FROM DATA CATALOG
      DATABASE '${var.lake_database_names["analytics"]}'
      IAM_ROLE '${var.redshift_role_arn}'
      REGION '${var.aws_region}';
      
      -- Grant usage to analyst group
      GRANT USAGE ON SCHEMA spectrum TO GROUP analysts;
      GRANT SELECT ON ALL TABLES IN SCHEMA spectrum TO GROUP analysts;
    EOF
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Create snapshot copy grant for cross-region snapshots (optional)
resource "aws_redshift_snapshot_copy_grant" "copy_grant" {
  count    = var.enable_snapshot_copy ? 1 : 0
  snapshot_copy_grant_name = "${var.project_name}-snapshot-copy-grant-${var.environment}"
  kms_key_id              = var.snapshot_copy_kms_key_id
  
  tags = {
    Name        = "${var.project_name}-snapshot-copy-grant"
    Environment = var.environment
    Project     = var.project_name
  }
}