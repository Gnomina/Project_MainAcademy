

output "vpc_id_VPC" {
  value = module.VPC.vpc_id_VPC
  description = "value of vpc_id_main from VPC module (outputs_source = ./VPC)"
}
