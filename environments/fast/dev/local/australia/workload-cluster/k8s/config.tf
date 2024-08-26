locals {
  team     = "fast"
  env      = "dev"
  provider = "local"
  region   = "australia"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
