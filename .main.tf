# Define your AWS provider
provider "aws" {
  region = "eu-central-1"  # Update with your desired region
}

# Create the S3 buckets
resource "aws_s3_bucket" "prod_bucket" {
  bucket = "main_prod"  # Update with your desired bucket name
  acl    = "private"
}

resource "aws_s3_bucket" "dev_bucket" {
  bucket = "main_dev"  # Update with your desired bucket name
  acl    = "private"
}

# Upload HTML files to the S3 bucket
resource "aws_s3_bucket_object" "dev_html" {
  bucket = aws_s3_bucket.prod_bucket.id
  key    = "dev.html"
  source = "dev.html"
}

resource "aws_s3_bucket_object" "prod_html" {
  bucket = aws_s3_bucket.prod_bucket.id
  key    = "prod.html"
  source = "prod.html"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "main_distribution" {
  enabled = true

  # Define the viewer certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Define the default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.prod_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Define the ordered cache behavior
  ordered_cache_behavior {
    path_pattern     = "/prod.html"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.prod_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/dev.html"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.prod_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Define the default root object
  default_root_object = "prod.html"
}