## AWS account level config: region
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}


variable "rule_name" {
    description = "x-minutes/hours"
    type = string
}

variable "description" {
    description = "trigger each minutes/hours"
    type = string
}

variable "expression" {
    description = "cron or rate"
    type = string
    default = "rate(5 minutes)"  
}
variable "event_target_name" {
    description = "target name"
    type = string
}

variable "event_target_arn" {
    description = "target arn"
    type = string
}
