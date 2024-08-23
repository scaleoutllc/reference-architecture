locals {
  team     = "shared"
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
      project = "shared-dev-gcp"
      name    = "shared-dev-gcp-global-routing"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}
