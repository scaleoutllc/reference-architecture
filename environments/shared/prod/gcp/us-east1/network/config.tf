locals {
  team     = "shared"
  env      = "dev"
  provider = "gcp"
  region   = "us-east1"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  networks = yamldecode(file("../../../../../../Networkfile")).networks
  network  = local.networks[local.env]["${local.provider}-${local.region}-${local.team}"]
  project  = "scaleout-dev"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "shared-dev-gcp"
      name    = "shared-dev-gcp-us-east1-network"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}
