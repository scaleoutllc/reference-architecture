locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws"
      name    = "fast-dev-aws-ap-southeast-2-cluster"
    }
  }
}

provider "aws" {
  region = local.region
}
