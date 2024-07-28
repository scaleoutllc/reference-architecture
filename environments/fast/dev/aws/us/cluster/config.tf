locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-cluster"
    }
  }
}

provider "aws" {
  region = local.region
}
