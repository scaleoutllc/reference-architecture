locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "global"
  locale   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-global"
      name    = "fast-dev-global-gcp-network-connectivity-hub"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}
