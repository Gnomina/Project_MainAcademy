provider "aws" {
  region = "${var.Region}" 
}

module "VPC" {
  source = "./VPC" #VPC Module PATH
}

module "SG" {
  source = "./SG" #SG Module PATH
  vpc_id = module.VPC.vpc_id_out #pass the value of the "vpc_id_out" variable from the VPC module to the SG module
}


module "Instance" {
  source = "./Instance" #Instance Module PATH
  sucurity_group = module.SG.security_group_id #pass the value of the "security_group_id" variable from the SG module to the Instance module
  subnet_id = module.VPC.subnet_id_out #pass the value of the "subnet_id_out" variable from the VPC module to the Instance module
}



