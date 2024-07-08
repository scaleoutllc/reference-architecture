locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
  cluster  = data.tfe_outputs.cluster.values
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-cluster-gke"
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
  project = "fast-dev-gcp"
  region  = "us-east1"
}
