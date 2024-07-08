locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-au-network"
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
  project = "fast-dev-gcp"
  region  = "australia-southeast1"
}
