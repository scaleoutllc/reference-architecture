locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "australia-southeast1"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-nodes"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}

data "google_container_cluster" "this" {
  name     = local.name
  location = local.region
  project  = local.area
}
