
#--------------Instance Outputs-----------------

output "instance_public_ip" {
  value = [for instance in aws_instance.example : instance.public_ip]
}

output "instance_id" {
  value = [for instance in aws_instance.example : instance.id]
}