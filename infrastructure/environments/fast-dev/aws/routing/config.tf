locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "routing"
  region   = "us-east-1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws"
      name    = "fast-dev-aws-routing"
    }
  }
}

provider "aws" {
  region = local.region
}
