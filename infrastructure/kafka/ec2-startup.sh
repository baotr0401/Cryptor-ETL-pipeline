#!/bin/bash
echo "-------------------------START SETUP---------------------------"
sudo yum update -y
sudo yum install docker -y
sudo yum install git -y
sudo usermod -a -G docker ec2-user
git clone https://github.com/baotr0401/ETL-pipeline-aws.git
newgrp docker
sudo systemctl enable docker
sudo service docker start
sudo yum install python3-pip
sudo pip3 install docker-compose
cd ETL-pipeline-aws
cd infrastructure
cd kafka
docker-compose up
echo "-------------------------END SETUP---------------------------"