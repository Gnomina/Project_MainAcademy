provider "aws" {
  region = "${var.Region}" 
}

module "VPC" {
  source = "./VPC"
  description = "VPC Module PATH"
}




