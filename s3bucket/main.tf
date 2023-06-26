resource "aws_s3_bucket" "my_bucket_dev" {
  bucket = "mainacademy-dev" # Замените на имя вашего бакета
 
  tags = {
    Name        = "dev_bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "my_bucket_prod" {
  bucket = "mainacademy-prod" # Замените на имя вашего бакета
 
  tags = {
    Name        = "prod_bucket"
    Environment = "prod"
  }
}
