variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_sg_name" {
  description = "security group for the instance"
  type = string
}

variable "instance_tag_name" {
  description = "tag for the instance"
  type = string
  default = "sde_ec2"
  
}

variable "instance_type"{
    description = "ec2 instance type"
    type = string
    default = "t2.micro"
}

variable "ami"{
  description = "instance's ami"
  type = string
  default = "ami-0f2eac25772cd4e36"
}

variable "key_name"{
  description = "aws keypair name"
  type = string
}

