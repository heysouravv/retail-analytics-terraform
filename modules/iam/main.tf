# Lake Formation Service Role
resource "aws_iam_role" "lakeformation_role" {
  name = "${var.project_name}-lakeformation-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lakeformation.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project_name}-lakeformation-role"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Data Lake Admin Role
resource "aws_iam_role" "data_lake_admin_role" {
  name = "${var.project_name}-data-lake-admin-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.data_lake_admin
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project_name}-data-lake-admin"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Glue Service Role
resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-glue-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project_name}-glue-role"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Redshift Service Role
resource "aws_iam_role" "redshift_role" {
  name = "${var.project_name}-redshift-role-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project_name}-redshift-role"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Policy for Lake Formation to access S3
resource "aws_iam_policy" "lakeformation_s3_policy" {
  name        = "${var.project_name}-lakeformation-s3-policy-${var.environment}"
  description = "Policy to allow Lake Formation to access S3 buckets"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = concat(
          [for bucket_arn in values(var.s3_buckets) : bucket_arn],
          [for bucket_arn in values(var.s3_buckets) : "${bucket_arn}/*"]
        )
      }
    ]
  })
}

# Policy for Glue to access S3 and other resources
resource "aws_iam_policy" "glue_policy" {
  name        = "${var.project_name}-glue-policy-${var.environment}"
  description = "Policy for AWS Glue to access necessary resources"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = concat(
          [for bucket_arn in values(var.s3_buckets) : bucket_arn],
          [for bucket_arn in values(var.s3_buckets) : "${bucket_arn}/*"]
        )
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "lakeformation:GetDataAccess"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:/aws-glue/*"
      }
    ]
  })
}

# Policy for Redshift to access S3 and the data catalog
resource "aws_iam_policy" "redshift_policy" {
  name        = "${var.project_name}-redshift-policy-${var.environment}"
  description = "Policy for Redshift to access S3 and Glue Data Catalog"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = concat(
          [for bucket_arn in values(var.s3_buckets) : bucket_arn],
          [for bucket_arn in values(var.s3_buckets) : "${bucket_arn}/*"]
        )
      },
      {
        Effect = "Allow"
        Action = [
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "lakeformation:GetDataAccess"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "lakeformation_s3" {
  role       = aws_iam_role.lakeformation_role.name
  policy_arn = aws_iam_policy.lakeformation_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_custom" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}

resource "aws_iam_role_policy_attachment" "redshift_custom" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = aws_iam_policy.redshift_policy.arn
}

# Data analyst role for business users
resource "aws_iam_role" "data_analyst_role" {
  name = "${var.project_name}-data-analyst-${var.environment}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.data_analyst_principals
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project_name}-data-analyst"
    Environment = var.environment
    Project     = var.project_name
  }
}