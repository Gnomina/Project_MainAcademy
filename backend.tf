#Module for save backend data on s3 bucket.
terraform {
  backend "s3" {
    bucket = "mainacademy-project-terraform-back" #name of bucket
    key    = "dev/backend/terraform.tfstate" #path to file
    region = "eu-central-1" #region
  }
}
