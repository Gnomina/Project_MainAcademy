
#---------------VPC outputs-----------------

output "vpc_id_out" { # Local output variable
  value = aws_vpc.my_vpc.id
  description = "vps_id"
}

output "subnet_id_out" { # Local output variable
  value = aws_subnet.my_subnet.id
  description = "subnet_id"
}

output "subnet_name_out" { # Local output variable
  value = aws_subnet.my_subnet.tags.Name
  description = "subnet_name"
}