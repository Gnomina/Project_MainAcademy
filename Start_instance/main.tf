provider "aws" {
  region = "${var.Region}" 
}

module "VPC" { #Include VPC module
  source = "./../VPC" #VPC Module PATH
}
/*
module "SG" { #Include SG module
  source = "./SG" #SG Module PATH
  vpc_id = module.VPC.vpc_id_out #pass the local value of the "vpc_id_out" variable from the VPC module to the SG module
}

module "Instance" { #Include Instance module
  source = "./Instance" #Instance Module PATH
  sucurity_group = module.SG.security_group_id_out #pass the local value of the "security_group_id" variable from the SG module to the Instance module
  subnet_id = module.VPC.subnet_id_out #pass the local value of the "subnet_id_out" variable from the VPC module to the Instance moduleъ
}
*/