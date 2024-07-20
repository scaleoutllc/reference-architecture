locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "us"
  region   = "us-east1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
  // 10.40.0.0/20
  // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.40.0.0&mask=20&division=7.51
  network = {
    cidr = "10.40.12.0/23" // nodes
    ranges = {
      pods     = "10.40.0.0/21"
      services = "10.40.8.0/22"
      private  = "10.40.14.0/23"
    }
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-us"
      name    = "fast-dev-gcp-us-network"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}
