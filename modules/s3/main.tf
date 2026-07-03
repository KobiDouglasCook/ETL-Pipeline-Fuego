resource "aws_s3_bucket" "raw" {
  bucket = "${var.prefix}-raw-${var.account_id}"
}

resource "aws_s3_bucket" "processed" {
  bucket = "${var.prefix}-processed-${var.account_id}"
}

resource "aws_s3_bucket" "scripts" {
  bucket = "${var.prefix}-scripts-${var.account_id}"
}
