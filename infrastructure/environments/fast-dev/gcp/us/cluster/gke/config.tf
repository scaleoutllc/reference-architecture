locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "us"
  region   = "us-east1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-us"
      name    = "fast-dev-gcp-us-cluster-gke"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

data "google_compute_network" "this_env" {
  name = local.name
}

data "google_compute_subnetwork" "this_env" {
  name   = local.area
  region = local.region
}
