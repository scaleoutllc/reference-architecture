locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "australia-southeast1"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-australia-southeast1-cluster"
    }
  }
}

provider "google" {
  project = "scaleout-dev"
  region  = local.region
}

data "google_compute_network" "this" {
  name = "${local.area}-global"
}

data "google_compute_subnetwork" "this" {
  name   = local.area
  region = local.region
}
