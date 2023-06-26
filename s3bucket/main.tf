resource "aws_s3_bucket" "my_bucket" {
  bucket = "test-dev-bucket" # Замените на имя вашего бакета
 
  tags = {
    Name        = "dev_bucket"
    Environment = "dev"
  }
}
resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id

  acl = "private" # Настройте права доступа в соответствии с вашими потребностями
}