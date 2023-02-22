provider "aws" {
  region  = var.aws_region
  profile = "default"
}


# Create a lambda function as a producer that pushes api data to a kafka server
resource "aws_lambda_function" "lambda_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = var.deployment_package
  function_name = "lambda-${var.name}"
  role          =  var.arn
  handler       = var.producer_handler

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(var.deployment_package)

  runtime = var.default_runtime
  timeout = var.execution_timeout

  layers = var.layers_attaching


  environment {
    variables = {
      TOPICS = var.topics
      BOOTSTRAP_SERVERS = 	var.servers
      API_URLS	= var.api_urls
    }
  }
}



