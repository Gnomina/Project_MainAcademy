provider "aws" {
  region = "${var.Region}" 
}

module "VPC" { #Include VPC module
  source = "./VPC" #VPC Module PATH
}

