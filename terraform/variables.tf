variable "full_domain" {
  default = "kyle.mn"
  type    = string
}

locals {
  s3_bucket_name = "${var.full_domain}-${random_pet.bucket_name.id}"
}