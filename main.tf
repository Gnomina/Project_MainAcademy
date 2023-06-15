provider "aws" {
  region = "${var.Region}" 
}

module "VPC" {
  source = "./VPC" #VPC Module PATH
}




