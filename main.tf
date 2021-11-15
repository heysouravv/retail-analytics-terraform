terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  # Configure backend for state management
  backend "s3" {
    bucket         = "retail-analytics-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "retail-analytics-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Import modules
module "s3_datalake" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  environment  = var.environment
  s3_buckets   = module.s3_datalake.bucket_arns
}

module "lake_formation" {
  source              = "./modules/lake_formation"
  project_name        = var.project_name
  environment         = var.environment
  data_lake_admin_arn = module.iam.data_lake_admin_role_arn
  s3_bucket_arns      = module.s3_datalake.bucket_arns
  depends_on          = [module.s3_datalake, module.iam]
}

module "glue" {
  source              = "./modules/glue"
  project_name        = var.project_name
  environment         = var.environment
  glue_role_arn       = module.iam.glue_role_arn
  s3_bucket_names     = module.s3_datalake.bucket_names
  database_names      = module.lake_formation.database_names
  depends_on          = [module.lake_formation]
}

module "redshift" {
  source                 = "./modules/redshift"
  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  warehouse_username     = var.warehouse_username
  warehouse_password     = var.warehouse_password
  redshift_role_arn      = module.iam.redshift_role_arn
  lake_database_names    = module.lake_formation.database_names
  depends_on             = [module.lake_formation]
}

module "monitoring" {
  source             = "./modules/monitoring"
  project_name       = var.project_name
  environment        = var.environment
  glue_job_names     = module.glue.job_names
  redshift_cluster_id = module.redshift.cluster_id
  depends_on         = [module.glue, module.redshift]
}