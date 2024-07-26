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
      project = "fast-dev-gcp-global"
      name    = "fast-dev-gcp-global-cluster-mesh"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}
