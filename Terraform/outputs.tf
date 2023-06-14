terraform {
  backend "s3" {
    bucket = "mainacademy-project-terraform-back"
    key    = "dev/outputs/terraform.tfstate"
    region = "eu-central-1"
  }
}



output "vpc_id" {
  value = aws_vpc.my_vpc.id
}