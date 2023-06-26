resource "aws_cloudfront_distribution" "loudfront" {
  origin {
    domain_name = "mainacademy-backend.s3.amazonaws.com/mainacademy-dev" 
    origin_id   = "dev"
  }

  origin {
    domain_name = "mainacademy-backend.s3.amazonaws.com/mainacademy-prod"  
    origin_id   = "prod"
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"

  default_cache_behavior {
    target_origin_id     = "dev"
    allowed_methods      = ["GET", "HEAD", "OPTIONS"]
    cached_methods       = ["GET", "HEAD"]
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
  }

  cache_behavior {
    path_pattern         = "mainacademy-prod/*"
    target_origin_id     = "prod"
    allowed_methods      = ["GET", "HEAD", "OPTIONS"]
    cached_methods       = ["GET", "HEAD"]
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
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}