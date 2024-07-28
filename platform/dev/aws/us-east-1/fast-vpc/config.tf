locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-aws"
      name    = "platform-dev-aws-au-fast-vpc"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
