provider "aws" {
  region = "eu-central-1"
}

//-----------------------Create bucket-----------------------
resource "aws_s3_bucket" "site_prod" {
  bucket        = "mainacademy-prod"

  tags = {
    Environment = "Prod"
  }
}

resource "aws_s3_bucket" "site_dev" {
  bucket = "mainacademy-dev"

  tags = {
    Environment = "dev"
  }
}
//-----------------------------------------------------------

//-------------------Public access block---------------------
resource "aws_s3_bucket_public_access_block" "site_prod" {
  bucket = aws_s3_bucket.site_prod.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "site_dev" {
  bucket = aws_s3_bucket.site_dev.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
//-----------------------------------------------------------

//-------------------Server side encryption------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "site_prod" {
  bucket            = aws_s3_bucket.site_prod.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site_dev" {
  bucket            = aws_s3_bucket.site_dev.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

//-----------------------------------------------------------

//---------------------Bucket versioning---------------------
resource "aws_s3_bucket_versioning" "site_prod" {
  bucket   = aws_s3_bucket.site_prod.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "site_dev" {
  bucket   = aws_s3_bucket.site_dev

  versioning_configuration {
    status = "Enabled"
  }
}
//-----------------------------------------------------------

//---------------------Add content to bucket-----------------
resource "aws_s3_bucket_object" "main_page" {
  bucket = aws_s3_bucket.site_prod.bucket
  key    = "index.html"
  source = "./index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "dev_page" {
  bucket = aws_s3_bucket.site_dev.bucket
  key    = "dev.html"
  source = "./dev.html"
  acl    = "public-read"
  content_type = "text/html"
}
//-----------------------------------------------------------

resource "aws_cloudfront_origin_access_identity" "site_access_identity" {
  comment = "CloudFront origin access identity for site access"
}

resource "aws_cloudfront_distribution" "site_access" {
  depends_on = [
    aws_s3_bucket_object.main_page,
    aws_s3_bucket_object.dev_page,
    aws_cloudfront_origin_access_identity.site_access_identity
  ]

  enabled                     = true
  default_root_object         = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id        = "main_bucket"
    viewer_protocol_policy  = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/dev/*"
    target_origin_id = "dev_bucket"

    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.site_prod.bucket_regional_domain_name
    origin_id   = "main_bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.site_dev.bucket_regional_domain_name
    origin_id   = "dev_bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["UA", "US"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "site_prod" {
  bucket = aws_s3_bucket.site_prod.bucket

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.site_prod.bucket}/*"
    }
  ]
}
EOF
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.site_access.domain_name
}
