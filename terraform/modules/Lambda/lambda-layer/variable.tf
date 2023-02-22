variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}
variable "path"{
  description = "File path to layer"
  type        = string
}

variable "layers_name"{
  type = string
}

variable "default_runtime"{
  description = "python 3.9 or else"
  type        = list
  default     = ["python3.9"]
}
