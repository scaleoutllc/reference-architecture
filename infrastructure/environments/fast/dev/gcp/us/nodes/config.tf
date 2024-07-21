locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "us-east1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-us"
      name    = "fast-dev-gcp-us-nodes"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}

data "google_container_cluster" "this" {
  name     = local.name
  location = local.region
  project  = local.area
}
