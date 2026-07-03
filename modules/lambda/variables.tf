variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for AWS Lambda"
  type        = string
}

variable "glue_job_name" {
  description = "Name of the AWS Glue job"
  type        = string
}

variable "raw_bucket_arn" {
  description = "ARN of the S3 bucket for raw data"
  type        = string
}

variable "raw_bucket_id" {
  description = "ID of the S3 bucket for raw data"
  type        = string
}

