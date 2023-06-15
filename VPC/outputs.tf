output "vpc_id_VPC" {
  value = aws_vpc.my_vpc.id
  description = "vps_id"
}

output "subnet_id_VPC" {
  value = aws_subnet.my_subnet[*].id
  description = "subnet_id"
}