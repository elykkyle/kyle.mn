terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  backend "s3" {
    bucket = "kyle.mn-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "kyle.mn-terraform"
  }

}
provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = var.aws_role_arn
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "east-1"
  assume_role {
    role_arn = var.aws_role_arn
  }
}


provider "aws" {
  alias  = "root-org"
  region = "us-east-2"
}

resource "random_id" "bucket_name" {
  byte_length = 4
}

