#Module for save backend data on s3 bucket.
terraform {
  backend "s3" {
    bucket = "mainacademy-backend" #name of bucket
    key    = "app_stack_backend_asg/terraform.tfstate" #path to file
    region = "eu-central-1" #region
  }
}
