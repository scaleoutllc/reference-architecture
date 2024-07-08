locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-tls"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
