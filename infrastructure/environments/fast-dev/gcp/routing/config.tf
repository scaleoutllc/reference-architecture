locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "routing"
  region   = "global"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-routing"
    }
  }
}

// provider to aws account with route53 zone for this environment
provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = local.project
  region  = local.region
}

