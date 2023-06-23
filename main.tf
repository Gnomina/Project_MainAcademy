provider "aws" {
  region = "${var.Region}" 
}

module "VPC" { #Include VPC module
  source = "./VPC" #VPC Module PATH
}

module "SG" { #Include SG module
  source = "./SG" #SG Module PATH
  vpc_id = module.VPC.vpc_id_out #pass the local value of the "vpc_id_out" variable from the VPC module to the SG module
}

module "IAM_Role" { #Include IAM_Role module
  source = "./IAM_Role" #IAM_Role Module PATH
}


module "Instance" { #Include Instance module
  source = "./Instance" #Instance Module PATH
  sucurity_group = module.SG.security_group_id_out #pass the local value of the "security_group_id" variable from the SG module to the Instance module
  subnet_id = module.VPC.subnet_id_out #pass the local value of the "subnet_id_out" variable from the VPC module to the Instance module
  IAM_Role = module.IAM_Role.Role_Name_out #pass the local value of the "Role_Name" variable from the IAM_Role module to the Instance module
}


module "ECR"{
  source = "./ECR"
}


