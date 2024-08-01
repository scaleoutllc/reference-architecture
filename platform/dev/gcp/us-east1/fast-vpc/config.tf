locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "us-east1"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
  network  = yamldecode(file("../../../networks.yml")).networks[local.env]["${local.provider}-${local.region}-${local.team}"]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-gcp"
      name    = "platform-dev-gcp-us-east1-fast-vpc"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}
