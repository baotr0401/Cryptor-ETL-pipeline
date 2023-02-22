
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

module "S3_bucket_source" {
    source = "../modules/S3"
    bucket_name= var.bucket_list[0]
    acl =   var.access_control_s3_bucket


}

module "S3_bucket_destination" {
    source = "../modules/S3"
    bucket_name = var.bucket_list[1]
    acl =   var.access_control_s3_bucket


}
module "S3_bucket_checkpoint" {
    source = "../modules/S3"
    bucket_name= var.bucket_list[2]
    acl =   var.access_control_s3_bucket
}

# deploy glue script from local to "glue-job-scripts-bitcoin" S3 bucket
resource "aws_s3_object" "glue_job_1" {

  bucket = module.S3_bucket_source.bucket_id

  key    =  var.glue_script_key

  acl    =  var.access_control_object # or can be "public-read"

  source =  var.glue_script_local_source

  etag = filemd5(var.glue_script_local_source)
}


# EC2 broker server
module "ec2_kafka_broker_sg"{
  source = "../modules/EC2/security-group"
  sg_name = "ec2_kafka_broker"
  tag_name = "kafka"
}

module "ec2_kafka_broker_instance"{
  source = "../modules/EC2/instance"
  ami = var.ec2_ami

  #key pair name
  key_name = "ec2_kafka_broker"
  instance_type = var.ec2_instance_type

  instance_sg_name = module.ec2_kafka_broker_sg.sg_name
  instance_tag_name = "kafka"
  
  user_data= "${file("../../infrastructure/kafka/ec2-startup.sh")}"
}




module "IAM_glue_role" {
    source = "../modules/IAM/iam_glue"
    role_name= var.glue_role_name
    policy_name = var.glue_policy_name
}

module "glue_job_1"{
    source = "../modules/Glue/glue-job"
    name = var.glue_names
    glue_iam_role= module.IAM_glue_role.role_arn
    worker_numbers = 10
    worker_types = "G.1X"
    glue_versions = "3.0"

    bucket_source = module.S3_bucket_source.bucket_name
    script_name = var.glue_script_key
 
    arguments = {
        "S3_OUTPUT" = module.S3_bucket_destination.bucket_name
        "S3_CHECKPOINT" = module.S3_bucket_checkpoint.bucket_name
        "BOOTSTRAP_SERVER" = "${module.ec2_kafka_broker_instance.public_dns_hostname}:9093"
        "TOPIC" = var.kafka_topic

    
    }
    glue_type = var.glue_types
}

module "glue_trigger_job_1"{
    source = "../modules/Glue/glue-trigger"
    name = var.glue_trigger_name
    cron_expressions = var.cron_expression
    trigger_type = var.glue_trigger_type 
    glue_job_name = module.glue_job_1.job_name
}

# Lambda

module "IAM_lambda_role" {
    source = "../modules/IAM/iam_lambda"
    role_name= var.lambda_role_name
    policy_name = var.lambda_policy_name
}

module "lambda_layer_requests"{
    source ="../modules/Lambda/lambda-layer"
    path = var.layers_path
    layers_name = var.layers_list[0]
    default_runtime = var.lambda_runtime

}

module "lambda_layer_kafkapython"{
    source ="../modules/Lambda/lambda-layer"
    path = var.layers_path
    layers_name = var.layers_list[1]
    default_runtime = var.lambda_runtime

}
module "lambda_producer_function_1"{
    source = "../modules/Lambda/lambda-function"
    
    deployment_package  = "../../infrastructure/kafka/lambda-producer/packages/lambda-producer-deployment-package.zip"
    name    = "producer_terraform_1"
    arn =   module.IAM_lambda_role.role_arn


    default_runtime = var.lambda_runtime[0]
    execution_timeout   = var.lambda_timeout
    layers_attaching = [module.lambda_layer_requests.layer_arn, module.lambda_layer_kafkapython.layer_arn]
    producer_handler = var.lambda_producer_1_handler
    
    # Environment variable
    servers  =   "${module.ec2_kafka_broker_instance.public_dns_hostname}:9093"
    topics   =   var.kafka_topic
    api_urls =  "https://api.coincap.io/v2/exchanges"

}

module "eventbridge_trigger"{
  source = "../modules/Eventbridge/eventbridge-trigger"
  rule_name = "twenty-minutes"
  description = "invoke lambda function every 20 minutes"
  event_target_name = "lambda_producer_function_1"
  event_target_arn = module.lambda_producer_function_1.function_arn
  expression = var.lambda_trigger_expression
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = module.lambda_producer_function_1.function_name
    principal = "events.amazonaws.com"
    source_arn = module.eventbridge_trigger.eventbridge_arn
}