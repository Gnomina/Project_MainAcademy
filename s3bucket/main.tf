resource "aws_s3_bucket" "my_bucket_test" {
  bucket = "dev-bucket" # Замените на имя вашего бакета
 
  tags = {
    Name        = "dev_bucket"
    Environment = "dev"
  }
}
