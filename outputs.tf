

output "vpc_id" {
  value = module.VPC.vpc_id_out #this variable locate in VPC module -> outputs 
  description = "value of vpc_id_VPC from VPC module (outputs_source = ./VPC)"
}

