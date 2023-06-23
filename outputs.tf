

output "vpc_id" {
  value = module.VPC.vpc_id_out #this variable locate in VPC module -> outputs 
  description = "value of vpc_id_VPC from VPC module (outputs_source = ./VPC)"
}

output "subnet_id" {
  value = module.VPC.subnet_id_out #This variable locate in VPC module -> outputs
  description = "value of subnet_id_VPC from VPC module (outputs_source = ./VPC)"
}

output "sg_id" {
  value = module.SG.security_group_id_out #This variable locate in SG module -> outputs
  description = "security group_id from SG module (outputs_source = ./SG)"
}


output "instance_public_ip" {
  value = module.Instance.instance_public_ip #This variable locate in Instance module -> outputs 
  description = "public ip of instance from Instance module (outputs_source = ./Instance)"
}

output "instance_id" {
  value = module.Instance.instance_id #This variable locate in Instance module -> outputs 
  description = "instance id from Instance module (outputs_source = ./Instance)"
}

output "ecr_url"{
  value = module.ECR.ecr_repository_url #This variable locate in ECR module -> outputs 
  description = "ECR URL from ECR module (outputs_source = ./ECR)"
}

output "IAM_Role_Name"{
  value = module.IAM_Role.Role_Name #This variable locate in IAM_Role module -> outputs 
  description = "IAM Role Name from IAM_Role module (outputs_source = ./IAM_Role)"
}
