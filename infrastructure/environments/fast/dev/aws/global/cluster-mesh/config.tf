locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "global"
  locale   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-global"
      name    = "fast-dev-aws-global-cluster-mesh"
    }
  }
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "aws" {
  alias  = "au"
  region = "ap-southeast-2"
}
