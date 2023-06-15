

output "vpc_id_VPC" {
  value = module.VPC.vpc_id_VPC
  description = "value of vpc_id_VPC from VPC module (outputs_source = ./VPC)"
}

output "subnet_id_VPC" {
  value = module.VPC.subnet_id_VPC
  description = "value of subnet_id_VPC from VPC module (outputs_source = ./VPC)"
}
