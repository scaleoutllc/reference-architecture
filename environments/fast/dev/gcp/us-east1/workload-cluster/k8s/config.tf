locals {
  team     = "fast"
  env      = "dev"
  cluster  = "workload"
  provider = "gcp"
  region   = "us-east1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.cluster}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  project  = "scaleout-dev"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-us-east1-workload-cluster-k8s"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

data "google_compute_network" "this" {
  name = "${local.team}-${local.env}-${local.provider}-global"
}

data "google_compute_subnetwork" "this" {
  name   = local.area
  region = local.region
}

