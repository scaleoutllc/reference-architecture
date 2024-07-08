locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "routing"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
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
  region = "us-east-1"
}
