
# Create a glue job from a script located on S3 to extract and apply preliminary transformations to the streaming data from the kafka source
# worker type = G.1X
# worker number = 10
resource "aws_glue_job" "ETLjob" {
  name     = "Kafka-consume-layer-${var.name}"
  role_arn = var.glue_iam_role
  number_of_workers = var.worker_numbers
  worker_type = var.worker_types
  glue_version = var.glue_versions
  default_arguments = var.arguments
  command {
    name            = var.glue_type
    script_location = "s3://${var.bucket_source}/${var.script_name}"
    python_version = var.python_versions
  }
  
}