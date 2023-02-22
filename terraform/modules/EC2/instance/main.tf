
provider "aws" {
  region  = var.aws_region
  profile = "default"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "tls_private_key" "custom_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name_prefix = var.key_name
  public_key      = tls_private_key.custom_key.public_key_openssh
}

resource "aws_instance" "ec2" {
  ami           =  var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.generated_key.key_name
  security_groups = [var.instance_sg_name]
  tags = {
    Name = var.instance_tag_name
  }

  user_data = var.user_data
}



# user_data = <<EOF
# #!/bin/bash
# echo "-------------------------START SETUP---------------------------"
# sudo yum update -y
# sudo yum install docker -y
# sudo yum install git -y
# git clone https://github.com/baotr0401/ETL-pipeline-aws.git
# sudo usermod -a -G docker ec2-user
# newgrp docker
# sudo systemctl enable docker
# sudo service docker start
# sudo yum install python3-pip
# sudo pip3 install docker-compose
# cd ETL-pipeline-aws
# cd infrastructure
# cd kafka
# docker-compose up
# echo "-------------------------END SETUP---------------------------"
# EOF
