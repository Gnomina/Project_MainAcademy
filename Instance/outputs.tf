output "instance_public_ip" {
  value = aws_instance.example.public_ip # Public IP that the instance receives from AWS. output variable.
 }