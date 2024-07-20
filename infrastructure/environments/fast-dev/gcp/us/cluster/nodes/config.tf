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
      name    = "fast-dev-gcp-us-cluster-nodes"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

data "google_container_cluster" "this_env" {
  name     = local.name
  location = local.region
  project  = local.project
}
