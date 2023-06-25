
#--------------Instance Outputs-----------------

#output "instance_public_ip" { # Local output variable
#  value = aws_instance.example.public_ip # Public IP that the instance receives from AWS. output variable.
# }

# output "instance_id" { # Local output variable
#  value = aws_instance.example.id # Instance ID that the instance receives from AWS. output variable.}
#}

output "instance_public_ip" {
  value = [for instance in aws_instance.example : instance.public_ip]
}

output "instance_id" {
  value = [for instance in aws_instance.example : instance.id]
}
