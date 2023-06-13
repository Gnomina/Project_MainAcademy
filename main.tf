provider "aws" {
  region = "eu-central-1" 
}

module "VPC" {
  source = "./Terraform/VPC"
}