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
      name    = "fast-dev-aws-global-load-balancer"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
