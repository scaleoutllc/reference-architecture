locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
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
      project = "fast-dev-global"
      name    = "fast-dev-global-gcp-load-balancer"
    }
  }
}

// provider to aws account with route53 zone for this environment
provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = local.area
  region  = local.region
}

data "aws_route53_zone" "main" {
  name = local.domain
}
