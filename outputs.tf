

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

output "instance_public_ip" {
  value = module.Instance.instance_public_ip
  description = "public ip of instance from Instance module (outputs_source = ./Instance)"
}

