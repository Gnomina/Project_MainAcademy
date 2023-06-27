provider "aws" {
  region = "eu-central-1" 
}

resource "aws_s3_bucket" "site_origin" {
  bucket        = "site_origin_mainacademy" 
 
  tags = {
    Environment = "lab"
  }
}

resource "aws_s3_bucket_public_access_block" "site_origin" {
  bucket = aws_s3_bucket.site_origin.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site_origin" {
  bucket            = aws_s3_bucket.site_origin.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "site_origin" {
  bucket   = aws_s3_bucket.site_origin.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "content" {

    depends_on = [
        aws_s3_bucket.site_origin
        ]


  bucket                    = aws_s3_bucket.site_origin.bucket
  key                       = "index.html"
  source                    = "./index.html"
  server_side_encryption    = "AES256"
  content_type              = "text/html"
}

resource "aws_cloudfront_origin_access_control" "site"{
    name                              = "security_pillar100_cf_s3_oac" 
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "site_access"{

    depends_on = [
        aws_s3_bucket.site_origin,
        aws_cloudfront_origin_access_control.site_access
    ]

    enabled = true
    default_root_object         = "index.html"

    default_cachle_behavior{
        allowed_methods         = ["GET", "HEAD", "OPTIONS"]
        cached_methods          = ["GET", "HEAD", "OPTIONS"]
        target_origin_id        = "site_origin"
        viewer_protocol_policy  = "htttps-only"
    }

    forvardet_values{
        query_string = false

        cookies{
            forward  = "none"
        }
        
    }

    origin{
        domain_name             = aws_s3_bucket.site_origin.bucket_domain_name
        origin_id               = aws_s3_bucket.site_origin.id
        origin_acces_control_id = aws_cloudfront_origin_access_control.site_access.id
    }

    restrictions{
        geo_restriction{
            restriction_type = "whitelist"
            locations        = ["US", "CA"]
        }
    }
}

resource "aws_s3_bucket_policy" "site_origin"{
    dependens_on = [
        aws_cloudfront_distribution.site_access,
        aws_s3_bucket.site_origin
    ]
    bucket = aws_s3_bucket.site_origin.id
    polisy = data.aws_iam_policy_document.site_origin
}

data "aws_iam_policy_document" "site_origin"{
    depends_on = [
        aws_cloudfront_distribution.site_access,
        aws_s3_bucket.site_origin
    ] 
    statement{
        sid = "3"
        effect = "Allow"
        actions = [
            "s3:GetObject"
        ]
    } 

    principals{
        
        identifiers = ["cloudfront.amazon.com"]
        type = "Service"
    }   

    resource = [
        "arn:aws:s3:::${aws_s3_bucket.site_origin.bucket}/*"
    ]

    condition {
        test = "StringEquals"
        variable = "aws:SourceArn"

        values = [aws_cloudfront_distribution.site_access.arn]
    }




}


