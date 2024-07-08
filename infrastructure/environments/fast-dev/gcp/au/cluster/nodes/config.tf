locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
  cluster  = data.tfe_outputs.cluster.values
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-au-cluster-gke"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-nodes"
    }
  }
}

provider "google" {
  project = "fast-dev-gcp"
  region  = "australia-southeast1"
}
