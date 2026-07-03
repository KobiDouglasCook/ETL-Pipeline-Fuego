variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN of the IAM role for AWS Glue"
  type        = string
}

variable "scripts_bucket" {
  description = "Name of the S3 bucket for Glue scripts"
  type        = string
}

variable "raw_bucket" {
  description = "Name of the S3 bucket for raw data"
  type        = string
}

variable "processed_bucket" {
  description = "Name of the S3 bucket for processed data"
  type        = string
}

