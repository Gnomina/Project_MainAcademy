resource "aws_s3_bucket" "mainacademy-dev" {
  bucket = "mainacademy-dev" 
 
  tags = {
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "mainacademy-prod" {
  bucket = "mainacademy-prod" 
  tags = {
    Environment = "prod"
  }
}
resource "aws_s3_bucket_public_access_block" "mainacademy-dev"{
  bucket = aws_s3_bucket.mainacademy-dev.bucket
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mainacademy-dev" {
  bucket = aws_s3_bucket.mainacademy-dev.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "mainacademy-prod"{
  bucket = aws_s3_bucket.mainacademy-prod.bucket
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}










//mainacademy-backend.s3.amazonaws.com/mainacademy-dev
//mainacademy-backend.s3.amazonaws.com/mainacademy-prod