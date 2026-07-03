// Upload ETL script to S3 bucket
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.scripts.bucket
  key    = "transform.py"
  source = "../glue/transform.py"
}

// Create Glue Catalog database that stores the metadata for the tables created by the Glue job
resource "aws_glue_catalog_database" "etl_db" {
  name = "${replace(local.prefix, "-", "_")}_db"
}

// Define the Glue job that will perform the ETL process
resource "aws_glue_job" "etl_job" {
  name     = "${local.prefix}-etl-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    script_location = "s3://${aws_s3_bucket.scripts.bucket}/${aws_s3_object.glue_script.key}"
    python_version  = "3"
  }

  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  default_arguments = {
    "--raw_bucket"       = aws_s3_bucket.raw.bucket
    "--processed_bucket" = aws_s3_bucket.processed.bucket
  }
}

