locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "global"
  locale   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-global"
      name    = "fast-dev-aws-global-transit-gateway-associations"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "au"
  region = "ap-southeast-2"
}

data "tfe_outputs" "us" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}


data "tfe_outputs" "au" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-au-network"
}
