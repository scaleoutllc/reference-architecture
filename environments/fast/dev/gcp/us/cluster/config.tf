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
      name    = "fast-dev-gcp-us-cluster"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}

data "google_compute_network" "this" {
  name = local.name
}

data "google_compute_subnetwork" "this" {
  name   = local.locale
  region = local.region
}
