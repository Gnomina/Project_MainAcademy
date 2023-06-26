#Module for save backend data on s3 bucket.
terraform {
  backend "s3" {
    bucket = "test-buk-g" #name of bucket
    key    = "test-buk-g/dev/backend/terraform.tfstate" #path to file
    region = "eu-central-1" #region
  }
}
