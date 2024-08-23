locals {
  team     = "shared"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  networks = yamldecode(file("../../../../../../Networkfile")).networks
  network  = local.networks[local.env]["${local.provider}-${local.region}-${local.team}"]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "shared-dev-aws"
      name    = "shared-dev-aws-ap-southeast-2-network"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
