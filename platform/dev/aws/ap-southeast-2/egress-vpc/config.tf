locals {
  team     = "egress"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-aws"
      name    = "platform-dev-aws-ap-southeast-2-egress-vpc"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
