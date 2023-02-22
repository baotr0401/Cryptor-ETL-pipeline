variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

## Key to allow connection to our EC2 instance
variable "topics" {
  description = "Kafka topic"
  type        = string
}

variable "servers" {
  description = "Kafka brokers server"
  type        = string
}

variable "api_urls"{
  description = "Kafka brokers server"
  type        = string
}

variable "layers_attaching"{
    description = "list of layers attaching"
    type = list
    default =[]
}

variable "default_runtime"{
  description = "python 3.9"
  type        = string
  default     = "python3.9"
}

variable "deployment_package"{
  description = "Lambda kafka producer deployment package"
  type        = string
}

variable "producer_handler"{ 
  description = "producer handler"
  type        = string
}

variable "arn"{
  description = "arn role"
  type        = string
}

variable "name"{
  description ="lambda function name"
  type =string
}

variable "execution_timeout" {
    description = "timeout of lambda"
    type = number
  
}