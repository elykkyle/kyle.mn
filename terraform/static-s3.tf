# resource "random_id" "s3" {
#   byte_length = 1
# }

# resource "aws_s3_bucket" "staticfiles" {
#   bucket = "kyle.mn-${random_id.s3.dec}"
# }


# output "s3_bucket_website" {
#   value = aws_s3_bucket.staticfiles.bucket
# }

module "s3_bucket_for_website" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.0"

  bucket_prefix = "kyle.mn-"
  force_destroy = true

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
}


output "static_s3_id" {
  value = module.s3_bucket_for_website.s3_bucket_id
}
