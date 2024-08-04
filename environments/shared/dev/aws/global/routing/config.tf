locals {
  team     = "plaform"
  env      = "dev"
  provider = "aws"
  region   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "shared-dev-aws"
      name    = "shared-dev-aws-global-routing"
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

data "tfe_outputs" "shared-us-east-1-network" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-us-east-1-network"
}

data "tfe_outputs" "shared-ap-southeast-2-network" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-ap-southeast-2-network"
}

data "tfe_outputs" "fast-us-east-1-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-east-1-network"
}

data "tfe_outputs" "fast-ap-southeast-2-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-network"
}
