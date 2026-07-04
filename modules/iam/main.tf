// Define an execution role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

// Attach an AWS-managed policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Create inline policy for Lambda role and attaches directly to the Lambda role
resource "aws_iam_role_policy" "lambda_s3_glue" {
  name = "${var.prefix}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["glue:StartJobRun"]
        Resource = "*"
      }
    ]
  })
}

// Create execution role for Glue Jobs
resource "aws_iam_role" "glue_role" {
  name = "${var.prefix}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

// Attach AWS Managed Glue Role to the previously made Glue Role
resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

// Add inline policy to the Glue Role to allow S3 actions
resource "aws_iam_role_policy" "glue_s3" {
  name = "${var.prefix}-glue-s3"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:*"]
      Resource = "*"
    }]
  })
}

// IAM Role for Grafana to assume
data "aws_iam_policy_document" "grafana_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["grafana.amazonaws.com"]
    }
  }
}

# Grafana IAM Role to allow Grafana to assume the role and access AWS resources
resource "aws_iam_role" "grafana_role" {
  name               = "${var.prefix}-grafana-role"
  assume_role_policy = data.aws_iam_policy_document.grafana_assume_role.json
}

# Grafana read acccess to CloudWatch metrics and logs
resource "aws_iam_role_policy_attachment" "grafana_cloudwatch" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Grafana X-Ray read access to view traces
resource "aws_iam_role_policy_attachment" "grafana_xray" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayReadOnlyAccess"
}
