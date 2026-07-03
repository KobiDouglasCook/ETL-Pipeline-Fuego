resource "aws_s3_bucket" "athena_results" {
  bucket = "${var.prefix}-athena-${var.account_id}"
}


resource "aws_athena_workgroup" "etl" {
  name = "${var.prefix}-workgroup"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/results/"
    }
  }
}
