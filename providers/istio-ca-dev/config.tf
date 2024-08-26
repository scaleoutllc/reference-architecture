locals {
  team     = "istio"
  env      = "dev"
  provider = "ca"
  name     = "${local.team}-${local.env}-${local.provider}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "providers-istio-ca-dev"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
