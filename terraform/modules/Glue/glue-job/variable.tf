variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "name" {
    description = ""
    type = string
}

variable "glue_type" {
    description = "Glue Streaming - gluestreaming or Glue ETL- glueetl"
    type = string
    default = "glueetl"
  
}
variable "glue_iam_role"{
    description = "role arn"
    type = string
}

variable "bucket_source" {
  type = string
}

variable "script_name" {
  type = string
}

variable "worker_types" {
  type = string
  default  = "G.1X"
}
variable "worker_numbers" {
  type = number
}
variable "glue_versions" {
  type = string
  default  = "3.0"
}
variable "python_versions" {
  type = number
  default  = 3
}

# variable "S3_OUTPUT" {
#   type = string
# }

# variable "S3_CHECKPOINT" {
#   type = string
# }

# variable "BOOTSTRAP_SERVER" {
#   description = "Kafka server:port"
#   type =string
  
# }

variable "arguments" {
    description = "glue environment"
    type = any
  
}