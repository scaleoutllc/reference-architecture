locals {
  team     = "fast"
  env      = "dev"
  cluster  = "workload"
  provider = "gcp"
  region   = "australia-southeast1"
  area     = "${local.team}-${local.env}-${local.cluster}-${local.provider}"
  name     = "${local.area}-${local.region}"
  networks = yamldecode(file("../../../../../../../Networkfile")).networks
  network  = local.networks[local.env]["${local.provider}-${local.region}-${local.team}-${local.cluster}"]
  project  = "scaleout-dev"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-australia-southeast1-workload-cluster-network"
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
