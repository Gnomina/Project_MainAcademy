
output "security_group_id" {
  value = aws_security_group.SG.id
  description = "security group_id from SG module (outputs_source = ./SG)"
}