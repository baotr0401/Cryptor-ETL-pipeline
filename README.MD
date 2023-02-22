# Cryptocurrency

This is a serverless ETL pipeline to pull cryptocurrency market data [CoinCap API](https://docs.coincap.io/) from a Kafka broker server, apply preliminary transformations, and load it into data lakes

## Architecture

![Arch](assets/images/arch.png)

Provision an AWS EC2 instance acting as a Kafka broker server. A Lambda function to pull and load our data to the broker as a de-facto producer. Glue jobs then consume, transform and load our data from the Kafka topics to S3 buckets.

All of the components are provisioned through Terraform and Docker containers.
## Setup

### Pre-requisites

1. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. [Github account](https://github.com/)
3. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) 
4. [AWS account](https://aws.amazon.com/) 
5. [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

Run these commands to setup and deploy the pipeline on AWS

```shell
# Clone the code as shown below.
git clone https://github.com/baotr0401/ETL-pipeline-aws.git
cd ETL-pipeline-aws/terraform/deployment-pipeline

# Create AWS services with Terraform
terraform init # Only needed on your first terraform run (or if you add new providers)
terraform apply # type in yes after verifying the changes TF will make

# Wait until the EC2 instance and other services are initialized, you can check this via your AWS UI
# See "Status Check" on the EC2 console, it should be "2/2 checks passed" before proceeding

```
### Tear down infra

After you are done, make sure to destroy your cloud infrastructure.

```shell
# In the "/terraform/deployment-pipeline" directory
terraform destroy # type in yes after verifying the changes TF will make

```