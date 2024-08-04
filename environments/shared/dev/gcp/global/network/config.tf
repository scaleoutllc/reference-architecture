locals {
  team     = "shared"
  env      = "dev"
  provider = "gcp"
  region   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "shared-dev-gcp"
      name    = "shared-dev-gcp-global-network"
    }
  }
}

provider "google" {
  project = "scaleout-dev"
  region  = local.region
}
