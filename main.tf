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
  //bucket = aws_s3_bucket.site_prod.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
//-----------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "site_prod" {
  bucket            = aws_s3_bucket.site_prod.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "site_prod" {
  bucket   = aws_s3_bucket.site_prod.bucket

  versioning_configuration {
    status = "Enabled"
  }
}
//---------------------Add content to bucket-----------------
resource "aws_s3_object" "content" {
    
    /*
    depends_on = [
        aws_s3_bucket.site_prod
        ]
    */


  bucket                    = aws_s3_bucket.site_prod.bucket
  key                       = "index.html"
  source                    = "./index.html"
  server_side_encryption    = "AES256"
  content_type              = "text/html"
  
}

resource "aws_s3_object" "dev_content" {

    /*
    depends_on = [
        aws_s3_bucket.site_dev
        ]
    */    


  bucket                    = aws_s3_bucket.site_prod.bucket
  key                       = "dev.html"
  source                    = "./dev.html"
  server_side_encryption    = "AES256"
  content_type              = "text/html"
  
}
//-----------------------------------------------------------

output "site_prod_bucket_name" {
  value = aws_s3_bucket.site_prod.bucket
}

output "site_dev_bucket_name" {
  value = aws_s3_bucket.site_dev.bucket
}


//-----------------------------------------------------------
resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Some comment"
}
//----------------------------------------------------------/


resource "aws_cloudfront_origin_access_control" "site_access"{
    name                              = "security_pillar100_cf_s3_oac" 
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "site_access"{

    depends_on = [
        aws_s3_bucket.site_prod,
        aws_s3_bucket.site_dev,
        aws_cloudfront_origin_access_control.site_access
        
    ]

    enabled                     = true
    default_root_object         = "index.html"
    //------------------cache behavior----------------------------
    default_cache_behavior{
        allowed_methods         = ["GET", "HEAD"]
        cached_methods          = ["GET", "HEAD"]
        //target_origin_id        = "main_bucket"
        target_origin_id        = aws_s3_bucket.site_prod.id
        viewer_protocol_policy  = "allow-all"

        forwarded_values{
          query_string = false

        cookies{
          forward  = "none"
        }
      }
    }

  
    ordered_cache_behavior {
        allowed_methods         = ["GET", "HEAD"]
        cached_methods          = ["GET", "HEAD"]
        path_pattern     = "/dev/*"
        target_origin_id = aws_s3_bucket.site_dev.id

        viewer_protocol_policy = "allow-all"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }
    }
    //-----------------------------------------------------------

    //aws_cloudfront_origin_access_control.site_access
    origin {
    domain_name = aws_s3_bucket.site_prod.bucket_domain_name
    origin_id   = aws_s3_bucket.site_prod.id

    s3_origin_config {
        
        origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
        
      //origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
      //origin_access_identity = aws_cloudfront_origin_access_control.site_access.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.site_dev.bucket_domain_name
    origin_id   = aws_s3_bucket.site_dev.id

    s3_origin_config {
        //origin_access_identity = aws_cloudfront_origin_access_control.site_access.cloudfront_access_identity
        origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
      //origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
      //origin_access_identity = aws_cloudfront_origin_access_control.site_access.cloudfront_access_identity_path
    }
  }




    /*
    origin{
        domain_name             = aws_s3_bucket.site_prod.bucket_domain_name
        origin_id               = aws_s3_bucket.site_prod.id
        origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
    }
    */
    restrictions{
        geo_restriction{
            restriction_type = "whitelist"
            locations        = ["UA", "US"]
        }
    }

    viewer_certificate {
      cloudfront_default_certificate = true
    }
}
//---------------Bucket policy-------------------------------
resource "aws_s3_bucket_policy" "site_prod"{
  depends_on = [
    data.aws_iam_policy_document.site_prod
  ]

  bucket = aws_s3_bucket.site_prod.id
  policy = data.aws_iam_policy_document.site_prod.json
  //policy = data.aws_iam_policy_document.site_origin.json
}
/*
resource "aws_s3_bucket_policy" "site_dev"{
  depends_on = [
    data.aws_iam_policy_document.site_origin
  ]

  bucket = aws_s3_bucket.site_dev.id
  policy = data.aws_iam_policy_document.site_origin.json
}
*/
//-----------------------------------------------------------


//-----------------IAM Policy--------------------------------
data "aws_iam_policy_document" "site_prod"{
  depends_on = [
    aws_cloudfront_distribution.site_access,
    aws_s3_bucket.site_prod,
    aws_s3_bucket.site_dev
  ] 
  
  statement{
    sid = "PublicReadGetObject"
    effect = "Allow"
    actions = ["s3:GetObject"]


    principals{
      //identifiers = ["cloudfront.amazon.com"]
      //type = "Service"
      type = "AWS"
      identifiers = ["*"]
    }   

    

    resources = [
      "arn:aws:s3:::mainacademy-prod/*",
      //"arn:aws:s3:::${aws_s3_bucket.site_dev.bucket}/*"
      //arn:aws:s3:::mainacademy-prod
    ] 

    
  }  
}


//---------------------Output-------------------------------
output "cloudfront_url" {
  value = aws_cloudfront_distribution.site_access.domain_name
}

output "ARN" {
  value = aws_cloudfront_distribution.site_access.arn
  
} 