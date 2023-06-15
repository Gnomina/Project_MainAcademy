provider "aws" {
  region = "${var.Region}" 
}

module "VPC" {
  source = "./VPC" #VPC Module PATH
}


module "SG" {
  source = "./SG" #SG Module PATH
}



