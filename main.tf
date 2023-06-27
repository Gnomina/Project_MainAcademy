# Define your AWS provider
provider "aws" {
  region = "us-east-1"  # Update with your desired region
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

# Upload dev.html and prod.html files to respective buckets
resource "aws_s3_bucket_object" "dev_html" {
  bucket = aws_s3_bucket.dev_bucket.bucket
  key    = "dev.html"
  source = "path/to/dev.html"  # Update with the path to your dev.html file
}

resource "aws_s3_bucket_object" "prod_html" {
  bucket = aws_s3_bucket.prod_bucket.bucket
  key    = "prod.html"
  source = "path/to/prod.html"  # Update with the path to your prod.html file
}

# Create the CloudFront distribution
resource "aws_cloudfront_distribution" "main_distribution" {
  origin {
    domain_name = aws_s3_bucket.prod_bucket.bucket_regional_domain_name
    origin_id   = "prod-bucket-origin"
    custom_origin_config {
      origin_protocol_policy = "http-only"
    }
  }

  default_cache_behavior {
    target_origin_id = "prod-bucket-origin"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    default_root_object = "/prod.html"  # Set prod.html as the index document
  }

  ordered_cache_behavior {
    path_pattern     = "/dev/*"
    target_origin_id = "dev-bucket-origin"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    default_root_object = "/dev.html"  # Set dev.html as the index document
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"  # Choose your desired price class
}

