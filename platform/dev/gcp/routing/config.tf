locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "global"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.region}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev-gcp"
      name    = "platform-dev-gcp-routing"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}
