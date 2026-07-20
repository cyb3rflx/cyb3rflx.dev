resource "aws_route53_zone" "main" {
  name = "cyb3rflx.dev"
}


resource "aws_acm_certificate" "main_cert" {
  provider                  = aws.us_east_1
  domain_name               = "cyb3rflx.dev"
  subject_alternative_names = ["www.cyb3rflx.dev"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "main_records" {
  for_each = {
    for dvo in aws_acm_certificate.main_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main_validation" {
  certificate_arn         = aws_acm_certificate.main_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.main_records : record.fqdn]
  provider                = aws.us_east_1
}

resource "aws_route53_record" "cloudfront_records" {
  for_each = toset(["cyb3rflx.dev", "www.cyb3rflx.dev"])
  name     = each.value
  type     = "A"
  zone_id  = aws_route53_zone.main.zone_id
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}