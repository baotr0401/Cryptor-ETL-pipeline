variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}
variable "role_name"{
  description = "name of lambda role"
  type        = string
}


variable "policy_name"{
  description = "name of lambda policy"
  type        = string
}
