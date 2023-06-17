provider "aws" {
  region = "${var.Region}" 
}

module "VPC" {
  source = "./VPC" #VPC Module PATH
}

module "SG" {
  source = "./SG" #SG Module PATH
  vpc_id = module.VPC.vpc_id_out
}

/*
module "Instance" {
  source = "./Instance" #Instance Module PATH
}
*/


