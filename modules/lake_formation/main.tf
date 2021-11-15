# Configure Lake Formation Settings
resource "aws_lakeformation_data_lake_settings" "settings" {
  admins = [var.data_lake_admin_arn]
}

# Register S3 locations with Lake Formation
resource "aws_lakeformation_resource" "raw_bucket" {
  arn      = var.s3_bucket_arns["raw"]
  role_arn = var.lakeformation_role_arn
}

resource "aws_lakeformation_resource" "staged_bucket" {
  arn      = var.s3_bucket_arns["staged"]
  role_arn = var.lakeformation_role_arn
}

resource "aws_lakeformation_resource" "analytics_bucket" {
  arn      = var.s3_bucket_arns["analytics"]
  role_arn = var.lakeformation_role_arn
}

# Create databases in the Glue Data Catalog
resource "aws_glue_catalog_database" "raw_db" {
  name        = "${var.project_name}_raw_${var.environment}"
  description = "Raw data layer for ${var.project_name} data lake"
  
  location_uri = "s3://${substr(var.s3_bucket_arns["raw"], 13, -1)}"
  
  parameters = {
    classification = "raw"
    purpose       = "landing zone for raw data"
  }
}

resource "aws_glue_catalog_database" "staged_db" {
  name        = "${var.project_name}_staged_${var.environment}"
  description = "Staged/processed data layer for ${var.project_name} data lake"
  
  location_uri = "s3://${substr(var.s3_bucket_arns["staged"], 13, -1)}"
  
  parameters = {
    classification = "staged"
    purpose       = "cleaned and transformed data"
  }
}

resource "aws_glue_catalog_database" "analytics_db" {
  name        = "${var.project_name}_analytics_${var.environment}"
  description = "Analytics data layer for ${var.project_name} data lake"
  
  location_uri = "s3://${substr(var.s3_bucket_arns["analytics"], 13, -1)}"
  
  parameters = {
    classification = "analytics"
    purpose       = "business ready data"
  }
}

# Set up Lake Formation permissions
resource "aws_lakeformation_permissions" "glue_access" {
  principal   = var.glue_role_arn
  permissions = ["CREATE_TABLE", "ALTER", "DROP", "INSERT", "SELECT", "DELETE"]
  
  database {
    name = aws_glue_catalog_database.raw_db.name
  }
}

resource "aws_lakeformation_permissions" "glue_staged_access" {
  principal   = var.glue_role_arn
  permissions = ["CREATE_TABLE", "ALTER", "DROP", "INSERT", "SELECT", "DELETE"]
  
  database {
    name = aws_glue_catalog_database.staged_db.name
  }
}

resource "aws_lakeformation_permissions" "glue_analytics_access" {
  principal   = var.glue_role_arn
  permissions = ["CREATE_TABLE", "ALTER", "DROP", "INSERT", "SELECT", "DELETE"]
  
  database {
    name = aws_glue_catalog_database.analytics_db.name
  }
}

resource "aws_lakeformation_permissions" "redshift_access" {
  principal   = var.redshift_role_arn
  permissions = ["SELECT"]
  
  database {
    name = aws_glue_catalog_database.analytics_db.name
  }
}

resource "aws_lakeformation_permissions" "data_analyst_access" {
  count      = length(var.data_analyst_role_arns) > 0 ? 1 : 0
  principal   = var.data_analyst_role_arns[0]
  permissions = ["SELECT"]
  
  database {
    name = aws_glue_catalog_database.analytics_db.name
  }
}