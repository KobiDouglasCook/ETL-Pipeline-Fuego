resource "aws_s3_bucket" "raw" {
  bucket = "${local.prefix}-raw-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "processed" {
  bucket = "${local.prefix}-processed-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "scripts" {
  bucket = "${local.prefix}-scripts-${data.aws_caller_identity.current.account_id}"
}
