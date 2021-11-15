# Create crawlers for raw data
resource "aws_glue_crawler" "sales_crawler" {
  name          = "${var.project_name}-sales-crawler-${var.environment}"
  role          = var.glue_role_arn
  database_name = var.database_names["raw"]

  s3_target {
    path = "s3://${var.s3_bucket_names["raw"]}/sales/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  tags = {
    Name        = "${var.project_name}-sales-crawler"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_glue_crawler" "inventory_crawler" {
  name          = "${var.project_name}-inventory-crawler-${var.environment}"
  role          = var.glue_role_arn
  database_name = var.database_names["raw"]

  s3_target {
    path = "s3://${var.s3_bucket_names["raw"]}/inventory/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  tags = {
    Name        = "${var.project_name}-inventory-crawler"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_glue_crawler" "customers_crawler" {
  name          = "${var.project_name}-customers-crawler-${var.environment}"
  role          = var.glue_role_arn
  database_name = var.database_names["raw"]

  s3_target {
    path = "s3://${var.s3_bucket_names["raw"]}/customers/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  tags = {
    Name        = "${var.project_name}-customers-crawler"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create ETL jobs for data transformation
resource "aws_glue_job" "transform_sales" {
  name              = "${var.project_name}-transform-sales-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = "3.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  
  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_names["scripts"]}/scripts/transform_sales.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language"               = "python"
    "--enable-job-insights"        = "true"
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--TempDir"                    = "s3://${var.s3_bucket_names["logs"]}/temp/"
    "--enable-metrics"             = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--SOURCE_DATABASE"            = var.database_names["raw"]
    "--SOURCE_TABLE"               = "sales"
    "--TARGET_BUCKET"              = var.s3_bucket_names["staged"]
    "--TARGET_DATABASE"            = var.database_names["staged"]
    "--TARGET_TABLE"               = "sales_processed"
  }
  
  execution_property {
    max_concurrent_runs = 1
  }
  
  tags = {
    Name        = "${var.project_name}-transform-sales"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_glue_job" "transform_inventory" {
  name              = "${var.project_name}-transform-inventory-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = "3.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  
  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_names["scripts"]}/scripts/transform_inventory.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language"               = "python"
    "--enable-job-insights"        = "true"
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--TempDir"                    = "s3://${var.s3_bucket_names["logs"]}/temp/"
    "--enable-metrics"             = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--SOURCE_DATABASE"            = var.database_names["raw"]
    "--SOURCE_TABLE"               = "inventory"
    "--TARGET_BUCKET"              = var.s3_bucket_names["staged"]
    "--TARGET_DATABASE"            = var.database_names["staged"]
    "--TARGET_TABLE"               = "inventory_processed"
  }
  
  execution_property {
    max_concurrent_runs = 1
  }
  
  tags = {
    Name        = "${var.project_name}-transform-inventory"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_glue_job" "transform_customers" {
  name              = "${var.project_name}-transform-customers-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = "3.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  
  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_names["scripts"]}/scripts/transform_customers.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language"               = "python"
    "--enable-job-insights"        = "true"
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--TempDir"                    = "s3://${var.s3_bucket_names["logs"]}/temp/"
    "--enable-metrics"             = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--SOURCE_DATABASE"            = var.database_names["raw"]
    "--SOURCE_TABLE"               = "customers"
    "--TARGET_BUCKET"              = var.s3_bucket_names["staged"]
    "--TARGET_DATABASE"            = var.database_names["staged"]
    "--TARGET_TABLE"               = "customers_processed"
  }
  
  execution_property {
    max_concurrent_runs = 1
  }
  
  tags = {
    Name        = "${var.project_name}-transform-customers"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create analytics aggregation job
resource "aws_glue_job" "analytics_aggregation" {
  name              = "${var.project_name}-analytics-aggregation-${var.environment}"
  role_arn          = var.glue_role_arn
  glue_version      = "3.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  
  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_names["scripts"]}/scripts/analytics_aggregation.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language"               = "python"
    "--enable-job-insights"        = "true"
    "--job-bookmark-option"        = "job-bookmark-enable"
    "--TempDir"                    = "s3://${var.s3_bucket_names["logs"]}/temp/"
    "--enable-metrics"             = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--SOURCE_DATABASE"            = var.database_names["staged"]
    "--TARGET_BUCKET"              = var.s3_bucket_names["analytics"]
    "--TARGET_DATABASE"            = var.database_names["analytics"]
  }
  
  execution_property {
    max_concurrent_runs = 1
  }
  
  tags = {
    Name        = "${var.project_name}-analytics-aggregation"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create workflow to orchestrate the ETL jobs
resource "aws_glue_workflow" "etl_workflow" {
  name        = "${var.project_name}-etl-workflow-${var.environment}"
  description = "Workflow for ${var.project_name} data processing"
  
  tags = {
    Name        = "${var.project_name}-etl-workflow"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create triggers
resource "aws_glue_trigger" "crawlers_trigger" {
  name          = "${var.project_name}-crawlers-trigger-${var.environment}"
  type          = "SCHEDULED"
  workflow_name = aws_glue_workflow.etl_workflow.name
  
  schedule = "cron(0 1 * * ? *)"  # Run daily at 1 AM UTC
  
  actions {
    crawler_name = aws_glue_crawler.sales_crawler.name
  }
  
  actions {
    crawler_name = aws_glue_crawler.inventory_crawler.name
  }
  
  actions {
    crawler_name = aws_glue_crawler.customers_crawler.name
  }
  
  tags = {
    Name        = "${var.project_name}-crawlers-trigger"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_glue_trigger" "transform_trigger" {
  name          = "${var.project_name}-transform-trigger-${var.environment}"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.etl_workflow.name
  
  predicate {
    conditions {
      crawler_name = aws_glue_crawler.sales_crawler.name
      crawl_state  = "SUCCEEDED"
    }
    
    conditions {
      crawler_name = aws_glue_crawler.inventory_crawler.name
      crawl_state  = "SUCCEEDED"
    }
    
    conditions {
      crawler_name = aws_glue_crawler.customers_crawler.name
      crawl_state  = "SUCCEEDED"
    }
    
    logical = "AND"
  }
  
  actions {
    job_name = aws_glue_job.transform_sales.name
  }
  
  actions {
    job_name = aws_glue_job.transform_inventory.name
  }
  
  actions {
    job_name = aws_glue_job.transform_customers.name
  }
  
  tags = {
    Name        = "${var.project_name}-transform-trigger"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_glue_trigger" "analytics_trigger" {
  name          = "${var.project_name}-analytics-trigger-${var.environment}"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.etl_workflow.name
  
  predicate {
    conditions {
      job_name = aws_glue_job.transform_sales.name
      state    = "SUCCEEDED"
    }
    
    conditions {
      job_name = aws_glue_job.transform_inventory.name
      state    = "SUCCEEDED"
    }
    
    conditions {
      job_name = aws_glue_job.transform_customers.name
      state    = "SUCCEEDED"
    }
    
    logical = "AND"
  }
  
  actions {
    job_name = aws_glue_job.analytics_aggregation.name
  }
  
  tags = {
    Name        = "${var.project_name}-analytics-trigger"
    Environment = var.environment
    Project     = var.project_name
  }
}