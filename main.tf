provider "aws" {
  region = "eu-central-1" 
}

terraform {
  backend "s3" {
    bucket = "mainacademy-Projekt-terraform-back"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "VPC" {
  source = "./Terraform/VPC"
}