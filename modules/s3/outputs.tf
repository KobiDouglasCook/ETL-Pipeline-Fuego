output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "processed_bucket" {
  value = aws_s3_bucket.processed.bucket
}

output "scripts_bucket" {
  value = aws_s3_bucket.scripts.bucket
}

output "raw_bucket_arn" {
  value = aws_s3_bucket.raw.arn
}

output "raw_bucket_id" {
  value = aws_s3_bucket.raw.id
}
