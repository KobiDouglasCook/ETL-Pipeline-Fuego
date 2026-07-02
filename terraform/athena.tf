resource "aws_s3_bucket" "athena_results" {
  bucket = "${local.prefix}-athena-${data.aws_caller_identity.current.account_id}"
}
