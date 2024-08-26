locals {
  team     = "shared"
  env      = "dev"
  provider = "gcp"
  region   = "australia-southeast1"
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
      name    = "shared-dev-gcp-australia-southeast1-network"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}
