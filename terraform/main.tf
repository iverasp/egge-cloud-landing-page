terraform {
  required_version = "1.9.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "landing-page-terraform-state-fzig04"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "landing-page-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

variable "domain_name" {
  default = "egge.cloud"
}

module "state" {
  source = "github.com/iverasp/terraform-aws-s3-state?ref=0.1.0"
  prefix = "landing-page"
}