variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "ingress_rules" {
    type = any
    default     = [
        {
          description = "Inbound SCP"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },

        {
          description = "Inbound SCP"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },

        {
          description = "Inbound SCP"
          from_port   = 9093
          to_port     = 9093
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },

        {
          description = "Inbound SCP"
          from_port   = 9092
          to_port     = 9092
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        } 

    ]
}

variable "egress_rules" {
    type = any
    default     = [
        {
          description = "Outbound SCP"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },

        {
          description = "Outbound SCP"
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        
        {
          description = "Outbound SCP"
          from_port   = 9093
          to_port     = 9093
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        
        },

        {description = "Outbound SCP"
          from_port   = 2181
          to_port     = 2181
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]}
    ]
}


variable "tag_name"{
    description = "security rule tag name"
    type = string
    default = "sde_instance_sg"
}

variable "sg_name"{
    description = "security rule name"
    type = string
}