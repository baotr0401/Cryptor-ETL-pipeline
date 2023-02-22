variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# Kafka info
variable "kafka_bootstrap_server" {
  type = string
  default  = "139.99.91.150:9093"
}

variable "kafka_topic" {
  type = string
  default  = "data-stream-analysis"
}

# EC2 info
variable "ec2_ami"{
  description = "Linux ami"
  type = string
  default  = "ami-0f2eac25772cd4e36"
}

variable "ec2_instance_type"{
  description = "free-tier instance"
  type = string
  default  = "t2.micro"
}


# S3 module
variable "bucket_list" {
  type = list
  default  = ["glue-job-scripts-bitcoin1","bitcoin-raw1", "bitcoin-raw-gluecheckpoint1"]
}

variable "access_control_s3_bucket"{
  description = "bucket list access control"
  type        = string
  default     = "private"
}

variable "access_control_object"{
  description = "object access control"
  type        = string
  default     = "private"
}

variable "glue_script_key"{
    description = "script location on S3"
    type        = string
    default     = "layer_1/KafkastreamETL.py"
}

variable "glue_script_local_source"{
    description = "script local path"
    type        = string
    default     = "../../etl/glue-script/KafkastreamETL.py"
}

# Glue role IAM module
variable "glue_role_name"{
  description = "name of glue role"
  type        = string
  default = "terraform"
}

variable "glue_policy_name"{
  description = "name of glue policy"
  type        = string
  default = "terraform"
}

variable "lambda_role_name"{
  description = "name of glue role"
  type        = string
  default = "terraform"
}

variable "lambda_policy_name"{
  description = "name of glue policy"
  type        = string
  default = "terraform"
}

# Glue job
variable "glue_names"{
  description = "name of glue job"
  type = string
  default = "layer_1"
}

variable "glue_types" {
  description = "glueetl vs gluestreaming"
  type = string
  default = "glueetl"
}

variable "glue_trigger_name" {
  description = "name of trigger"
  type = string
  default = "glue_layer_1_trigger"
}

variable "cron_expression" {
  description = "triggered every 10 minutes"
  type = string
  default  = "cron(0/10 * * * ? *)"
}

variable "glue_trigger_type" {
  description = "scheduled vs conditional"
  type = string
  default  = "SCHEDULED"
}

#lambda layer 
variable "layers_path"{
  description = "File path to layer"
  type        = string
  default     = "../../infrastructure/kafka/lambda-producer/packages"
}

variable "layers_list"{
  type = list
  default  = ["requests", "kafka-python"]
}

variable "lambda_runtime"{
  description = "python 3.9 or else"
  type        = list
  default     = ["python3.9"]
}


variable "lambda_producer_1_handler"{ 
  description = "producer handler"
  type        = string
  default     = "lambda-producer.lambda_handler"
}

variable "lambda_timeout" {
  description = "max 900 seconds"
  type = number
  default= 900
  
}

variable "lambda_trigger_expression" {
  description = "trigger every twenty minutes "
  type = string
  default= "rate(20 minutes)"  
}