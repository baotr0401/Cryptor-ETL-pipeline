output "bucket_destination_id"{
    value = module.S3_bucket_destination.bucket_id
}

output "bucket_destination_name"{
    value = module.S3_bucket_destination.bucket_name
}

output "ec2_dns_hostname"{
    value = module.ec2_kafka_broker_instance.public_dns_hostname
}