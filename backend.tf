


terraform {
  backend "s3" {
    bucket = "mainacademy-project-terraform-back"
    key    = "dev/backend/terraform.tfstate"
    region = "eu-central-1"
  }
}
