resource "aws_s3_bucket" "my_bucket_test" {
  bucket = "dev-bucket-11" # Замените на имя вашего бакета
 
  tags = {
    Name        = "dev_bucket_22"
    Environment = "dev_22"
  }
}
