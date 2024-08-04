locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  project  = "scaleout-dev"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-global-network"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}
