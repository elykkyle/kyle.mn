variable "full_domain" {
  default = "kyle.mn"
  type    = string
}

locals {
  s3_bucket_name = "${var.full_domain}-${random_id.bucket_name.dec}"
}

variable "is_temporary" {
  default = true
  type = bool
}

variable "aws_role_arn" {
    default = ""
    type = string
}