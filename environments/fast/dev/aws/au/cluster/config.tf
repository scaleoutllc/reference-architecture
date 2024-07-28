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
  workspace    = "fast-dev-aws-au-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-cluster"
    }
  }
}

provider "aws" {
  region = local.region
}
