provider "aws" {
  region  = var.aws_region
  profile = "default"
}

# Create an IAM lambda execution role
resource "aws_iam_role" "iam_lambda_producer" {
  name = "AWSLambdaBasicExecutionRole${var.role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create an IAM policy to access Cloudwatch for the lambda execution role
# Allowing lambda functions to output logs to Cloudwatch
resource "aws_iam_policy" "LambdaBasicExecutionPolicy" {
  name        = "AWSLambdaBasicExecutionPolicy${var.policy_name}"
  description = "Allow logging for Lambda on Cloudwatch"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


# Attaching the IAM lambda policy to the IAM lambda execution role
resource "aws_iam_role_policy_attachment" "Lambda_producer_attachment" {
  role       = aws_iam_role.iam_lambda_producer.name
  policy_arn = aws_iam_policy.LambdaBasicExecutionPolicy.arn
}

