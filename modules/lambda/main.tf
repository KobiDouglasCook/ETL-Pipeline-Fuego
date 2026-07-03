// Create a zip file for the Lambda function to use as its deployment package
data "archive_file" "lambda_zip" {
  type             = "zip"
  source_file      = "../../lambda/validate.py"
  output_path      = "../../lambda/validate.zip"
  output_file_mode = "0644"
}

// Deploy validator Lambda function 
resource "aws_lambda_function" "validator" {
  function_name    = "${var.prefix}-validator"
  role             = var.lambda_role_arn
  handler          = "validate.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      GLUE_JOB_NAME = var.glue_job_name
    }
  }
}

// Grant permission for S3 to call Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.validator.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.raw_bucket_arn
}


// Create an S3 bucket notification to trigger the Lambda function when a new object is created
resource "aws_s3_bucket_notification" "raw_trigger" {
  bucket = var.raw_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.validator.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
