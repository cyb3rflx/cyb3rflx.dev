resource "aws_cloudfront_origin_access_control" "website_oac" {
  name                              = "Website Bucket OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.website_oac.id
    origin_id                = "s3-website"
  }

  enabled             = true
  default_root_object = "index.html"

  aliases = ["cyb3rflx.dev", "www.cyb3rflx.dev"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-website"
    cache_policy_id  = data.aws_cloudfront_cache_policy.caching_optimized.id


    viewer_protocol_policy = "redirect-to-https"
  }



  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "Prod"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.main_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}