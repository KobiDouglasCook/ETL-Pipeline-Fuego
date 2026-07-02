import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext

args = getResolvedOptions(
    sys.argv,
    ['raw_bucket', 'processed_bucket']
)

sc = SparkContext()
glueContext = GlueContext(sc)

frame = glueContext.create_dynamic_frame.from_options(
    "s3",
    {
        "paths": [f"s3://{args['raw_bucket']}/"]
    },
    format="csv",
    format_options={"withHeader": True}
)

cleaned = frame.resolveChoice(
    specs=[("amount", "cast:double")]
)

glueContext.write_dynamic_frame.from_options(
    frame=cleaned,
    connection_type="s3",
    connection_options={
        "path": f"s3://{args['processed_bucket']}/",
        "partitionKeys": ["region"]
    },
    format="parquet"
)