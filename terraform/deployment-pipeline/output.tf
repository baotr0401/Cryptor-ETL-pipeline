output "aws_region" {
  description = "Region set for AWS"
  value       = var.aws_region
}

output "bucket_lake_name"{
  value = module.S3_bucket_destination.bucket_name
}

output "glue_job_name"{
  value = module.glue_job_1.job_name
}

output "lambda_function_name"{
  value = module.lambda_producer_function_1.function_name
}

output "ec2_public_key"{
  description = "kafka instance"
  value       = module.ec2_kafka_broker_instance.public_key
  sensitive = true
}

output "ec2_private_key" {
  description =  "kafka instance"
  value       = module.ec2_kafka_broker_instance.private_key
  sensitive = true
}

output "ec2_dns_hostname"{
  value = module.ec2_kafka_broker_instance.public_dns_hostname
}

output "kafka_server"{
  value = "${module.ec2_kafka_broker_instance.public_dns_hostname}:9093"
}

output "kafka_topic"{
  value = var.kafka_topic
}
