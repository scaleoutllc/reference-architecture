locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-network"
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
  project = "fast-dev-gcp"
  region  = "us-east1"
}
