locals {
  team     = "transit"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  network  = yamldecode(file("../../../networks.yml")).networks[local.env]["${local.provider}-${local.region}-${local.team}"]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-aws"
      name    = "platform-dev-aws-us-east-1-transit-vpc"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
