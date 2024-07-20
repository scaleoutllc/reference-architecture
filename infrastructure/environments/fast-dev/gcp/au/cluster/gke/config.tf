locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "au"
  region   = "australia-southeast1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-gke"
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
