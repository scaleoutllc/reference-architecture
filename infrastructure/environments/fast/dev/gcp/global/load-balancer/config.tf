locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "global"
  locale   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
  sans = [
    local.domain,                             // global
    "*.${local.domain}",                      // global
    "*.us.${local.domain}",                   // regional
    "*.au.${local.domain}",                   // regional
    "*.${local.provider}.${local.domain}",    // provider
    "*.${local.provider}-us.${local.domain}", // fully-specified
    "*.${local.provider}-au.${local.domain}"  // fully-specified
  ]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-global"
      name    = "fast-dev-global-gcp"
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
