resource "aws_s3_bucket" "my_bucket_test" {
  bucket = "dev-bucket_11" # Замените на имя вашего бакета
 
  tags = {
    Name        = "dev_bucket_22"
    Environment = "dev_22"
  }
}
resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket_test.id

  acl = "private" # Настройте права доступа в соответствии с вашими потребностями
}