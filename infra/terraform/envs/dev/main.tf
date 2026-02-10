terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                = "../../modules/vpc"
  name                  = "sre-capstone-dev"
  vpc_cidr              = "10.10.0.0/16"
  public_subnet_a_cidr  = "10.10.1.0/24"
  private_subnet_a_cidr = "10.10.2.0/24"
  az_a                  = "us-east-1a"
}

output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_id" { value = module.vpc.public_subnet_id }
output "private_subnet_id" { value = module.vpc.private_subnet_id }
