#Module for save backend data on s3 bucket.
terraform {
  backend "s3" {
    bucket = "mainacademy-backend" #name of bucket
    key    = "developer-backend/terraform.tfstate" #path to file
    region = "eu-central-1" #region
  }
}
