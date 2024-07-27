locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.10.0.0&mask=20&division=13.3d40
    cidr = "10.10.0.0/20"
    subnets = {
      private = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"],
      public  = ["10.10.12.0/24", "10.10.13.0/24", "10.10.14.0/24"]
      intra   = ["10.10.15.0/26", "10.10.15.64/26", "10.10.15.128/26"]
    }
    asn = "64610"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-network"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
