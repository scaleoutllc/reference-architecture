locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  network  = yamldecode(file("../../../networks.yml")).networks[local.env]["${local.provider}-${local.region}-${local.team}"]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-aws"
      name    = "platform-dev-aws-ap-southeast-2-fast-vpc"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
