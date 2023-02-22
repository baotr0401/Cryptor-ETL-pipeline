provider "aws" {
  region  = var.aws_region
  profile = "default"
}


resource "aws_s3_bucket" "etl" {

  bucket = var.bucket_name
  acl = var.acl
  tags = {
    Name        = "glue_etl_pipeline"
    Environment = "Dev"
  }
}
