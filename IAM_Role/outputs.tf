output "Role_Name_out" {
  value = aws_iam_role.example_role.name
}

output "Polisy_arn_out"{
  value = aws_iam_policy.example_policy.arn
}