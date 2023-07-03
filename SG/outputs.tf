#--------------Security Group outputs-----------------#


output "security_group_id_out" { #Local output variable
  value = aws_security_group.SG.id
  description = "security group_id from SG module (outputs_source = ./SG)"
}