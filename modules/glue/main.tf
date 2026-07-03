// Upload ETL script to S3 bucket
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.scripts.bucket
  key    = "transform.py"
  source = "../glue/transform.py"
}

// Create Glue Catalog database that stores the metadata for the tables created by the Glue job
resource "aws_glue_catalog_database" "etl_db" {
  name = "${replace(var.prefix, "-", "_")}_db"
}

// Define the Glue job that will perform the ETL process
resource "aws_glue_job" "etl_job" {
  name     = "${var.prefix}-etl-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    script_location = "s3://${var.scripts_bucket}/transform.py"
    python_version  = "3"
  }

  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  default_arguments = {
    "--raw_bucket"       = var.raw_bucket
    "--processed_bucket" = var.processed_bucket
  }
}

