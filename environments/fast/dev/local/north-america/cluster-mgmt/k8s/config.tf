locals {
  team     = "fast"
  env      = "dev"
  provider = "local"
  region   = "north-america"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}-mgmt"
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
