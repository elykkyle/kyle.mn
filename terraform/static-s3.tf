module "s3_bucket_for_website" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.0"

  bucket = local.s3_bucket_name
  force_destroy = var.is_temporary

  versioning = {
    enabled = true
  }
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${module.s3_bucket_for_website.s3_bucket_arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        }
    ]
}
EOF

  attach_policy = true

  logging = {
    target_bucket = module.s3_cf_logging.s3_bucket_id
    target_prefix = "s3AccessLog/"
  }
}


output "static_s3_id" {
  value = module.s3_bucket_for_website.s3_bucket_id
}

