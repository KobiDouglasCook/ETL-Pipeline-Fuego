output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "processed_bucket" {
  value = aws_s3_bucket.processed.bucket
}

output "glue_job_name" {
  value = aws_glue_job.etl_job.name
}

output "lambda_name" {
  value = aws_lambda_function.validator.function_name
}
