provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  prefix = "${var.project_name}-${var.environment}"
}

module "s3" {
  source     = "../../modules/s3"
  prefix     = local.prefix
  account_id = data.aws_caller_identity.current.account_id
}

module "iam" {
  source = "../../modules/iam"
  prefix = local.prefix
}

module "glue" {
  source           = "../../modules/glue"
  prefix           = local.prefix
  glue_role_arn    = module.iam.glue_role_arn
  scripts_bucket   = module.s3.scripts_bucket
  raw_bucket       = module.s3.raw_bucket
  processed_bucket = module.s3.processed_bucket
}

module "lambda" {
  source          = "../../modules/lambda"
  prefix          = local.prefix
  lambda_role_arn = module.iam.lambda_role_arn
  glue_job_name   = module.glue.glue_job_name
  raw_bucket_arn  = module.s3.raw_bucket_arn
  raw_bucket_id   = module.s3.raw_bucket_id
}

module "athena" {
  source     = "../../modules/athena"
  prefix     = local.prefix
  account_id = data.aws_caller_identity.current.account_id
}
