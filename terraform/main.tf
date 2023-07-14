variable "environment" {
  type    = string
  default = "dev"
}

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
  cloud {
    organization = "elykkyle"
    workspaces {
      name = "cloud-resume-dev"
    }
  }

}
provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = "arn:aws:iam::318339346456:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "east-1"
  assume_role {
    role_arn = "arn:aws:iam::318339346456:role/OrganizationAccountAccessRole"
  }
}


provider "aws" {
  alias  = "root-org"
  region = "us-east-2"
}
