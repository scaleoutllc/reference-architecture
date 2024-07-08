locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-tls"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
