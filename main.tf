provider "aws" {
  region = "${var.Region}" 
}

module "s3" { #Include VPC module
  source = "./s3bucket" #VPC Module PATH
}

