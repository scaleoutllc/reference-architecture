locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "australia-southeast1"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  networks = yamldecode(file("../../../../../../Networkfile")).networks
  network  = local.networks[local.env]["${local.provider}-${local.region}-${local.team}"]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-australia-southeast1-network"
    }
  }
}

provider "google" {
  project = "scaleout-dev"
  region  = local.region
}
