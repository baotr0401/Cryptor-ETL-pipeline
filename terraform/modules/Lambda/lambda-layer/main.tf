provider "aws" {
  region  = var.aws_region
  profile = "default"
}


# Create 2 layers for lambda from local repository
# "requests" layer
# "kafka-python" layer
resource "aws_lambda_layer_version" "lambda_layers" {
  filename   = "${var.path}/${var.layers_name}.zip"
  layer_name = "lambda_layer__terraform${var.layers_name}"

  compatible_runtimes = var.default_runtime
}

