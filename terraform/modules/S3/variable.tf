variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# variable "bucket_list" {
#   type = list

# }

variable "acl"{
  description = "bucket list access control"
  type        = string
  default     = "private"
}

# variable "access_control_object"{
#   description = "object access control"
#   type        = string
# }



variable "bucket_name" {
  type = string
}

# variable "bucket_id" {
#   type = string
# }