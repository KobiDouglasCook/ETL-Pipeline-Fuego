// Upload ETL script to S3 bucket
resource "aws_s3_object" "glue_script" {
  bucket = var.scripts_bucket
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
  role_arn = var.glue_role_arn

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

resource "aws_glue_catalog_table" "sales" {
  name          = "sales"
  database_name = aws_glue_catalog_database.etl_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification = "parquet"
    EXTERNAL       = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.processed_bucket}/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "order_id"
      type = "string"
    }

    columns {
      name = "customer_id"
      type = "string"
    }

    columns {
      name = "amount"
      type = "double"
    }

    columns {
      name = "timestamp"
      type = "timestamp"
    }

  }
  partition_keys {
    name = "region"
    type = "string"
  }

  depends_on = [
    aws_glue_catalog_database.etl_db
  ]

}
