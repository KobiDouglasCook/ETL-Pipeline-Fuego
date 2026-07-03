import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext

# --------------------------------------------------------------------
# Read job arguments passed from Terraform
# --------------------------------------------------------------------

args = getResolvedOptions(
    sys.argv,
    [
        "raw_bucket",
        "processed_bucket"
    ]
)

# --------------------------------------------------------------------
# Initialize Spark / Glue Context
# --------------------------------------------------------------------

sc = SparkContext()
glueContext = GlueContext(sc)

# --------------------------------------------------------------------
# Extract
# Read raw CSV files from S3
# --------------------------------------------------------------------

datasource = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={
        "paths": [
            f"s3://{args['raw_bucket']}/"
        ]
    },
    format="csv",
    format_options={
        "withHeader": True
    }
)

# --------------------------------------------------------------------
# Transform
# Convert amount column to a double & timestamp column to a timestamp data type
# --------------------------------------------------------------------

transformed = datasource.resolveChoice(
    specs=[
        ("amount", "cast:double"),
        ("timestamp", "cast:timestamp")
    ]
)

# --------------------------------------------------------------------
# Remove columns that contain only NULL values
# --------------------------------------------------------------------

transformed = transformed.drop_null_fields()

# --------------------------------------------------------------------
# Load
# Write transformed data as Parquet
# --------------------------------------------------------------------

glueContext.write_dynamic_frame.from_options(
    frame=transformed,
    connection_type="s3",
    connection_options={
        "path": f"s3://{args['processed_bucket']}/",
        "partitionKeys": [
            "region"
        ]
    },
    format="parquet"
)