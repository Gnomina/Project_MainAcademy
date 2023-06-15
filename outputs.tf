

output "vpc_id" {
  value = module.VPC.vpc_id_VPC
  description = "value of vpc_id_VPC from VPC module (outputs_source = ./VPC)"
}

output "subnet_id" {
  value = module.VPC.subnet_id_VPC
  description = "value of subnet_id_VPC from VPC module (outputs_source = ./VPC)"
}

output "sg_id" {
  value = module.SG.security_group_id
  description = "security group_id from SG module (outputs_source = ./SG)"
}