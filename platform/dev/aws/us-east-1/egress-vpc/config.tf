locals {
  team     = "transit"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "transit-dev-aws-au"
      name    = "transit-dev-aws-au-network"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
