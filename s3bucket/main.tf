resource "aws_s3_bucket" "my_bucket" {
  bucket = "test-dev-bucket" # Замените на имя вашего бакета

  acl    = "private" # Настройте права доступа в соответствии с вашими потребностями

  tags = {
    Name        = "dev_bucket"
    Environment = "dev"
  }
}