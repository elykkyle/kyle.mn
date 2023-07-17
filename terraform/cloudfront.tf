
# resource "aws_s3_bucket_acl" "b_acl" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }

data "aws_route53_zone" "root" {
  provider     = aws.root-org
  name         = "kyle.mn"
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  provider                  = aws.east-1
  domain_name               = "kyle.mn"
  subject_alternative_names = ["*.kyle.mn"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_pet" "subdomain" {}

resource "aws_route53_record" "cert" {
  provider = aws.root-org
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  provider        = aws.east-1
  certificate_arn = aws_acm_certificate.cert.arn
  # validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}

locals {
  s3_origin_id = "kylemn"
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = module.s3_bucket_for_website.s3_bucket_bucket_domain_name
  description                       = "Created by Terraform"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = module.s3_bucket_for_website.s3_bucket_bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront distribution for cloud-resume challenge"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = module.s3_cf_logging.s3_bucket_bucket_domain_name
    prefix          = "cloudfront"
  }

  aliases = ["kyle.mn"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = resource.aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_route53_record" "dns_record" {
  provider = aws.root-org
  zone_id  = data.aws_route53_zone.root.zone_id
  name     = "kyle.mn"
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

module "s3_cf_logging" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.0"

  bucket_prefix = "kyle.mn-logging-"
  force_destroy = true

  versioning = {
    enabled = false
  }

  acl = "log-delivery-write"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "S3-LOGGING-POLICY",
    "Statement": [
        {
            "Sid": "S3-Allow-Logging",
            "Effect": "Allow",
            "Principal": {
                "Service": "logging.s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${module.s3_cf_logging.s3_bucket_arn}/*"
        }
    ]
}
EOF

  attach_policy = true
}
