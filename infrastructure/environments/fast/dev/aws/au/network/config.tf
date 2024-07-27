locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.20.0.0&mask=20&division=13.3d40
    cidr = "10.20.0.0/20"
    subnets = {
      private = ["10.20.0.0/22", "10.20.4.0/22", "10.20.8.0/22"],
      public  = ["10.20.12.0/24", "10.20.13.0/24", "10.20.14.0/24"]
      intra   = ["10.20.15.0/26", "10.20.15.64/26", "10.20.15.128/26"]
    }
    asn = "64620"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-network"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
