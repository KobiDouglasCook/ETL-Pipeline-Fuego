import boto3
import os

glue = boto3.client("glue")

def lambda_handler(event, context):
    glue.start_job_run(
        JobName=os.environ["GLUE_JOB_NAME"]
    )

    return {
        "statusCode": 200,
        "body": "Glue job started successfully"
    }