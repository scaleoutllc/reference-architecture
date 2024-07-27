locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "australia-southeast1"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  // 10.40.0.0/20
  // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.40.0.0&mask=20&division=7.51
  network = {
    cidr = "10.40.12.0/23" // nodes
    subnets = {
      pods     = "10.40.0.0/21"
      services = "10.40.8.0/22"
      private  = "10.40.14.0/23"
    }
    asn = "64630"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-network"
    }
  }
}

provider "google" {
  project = local.area
  region  = local.region
}

data "tfe_outputs" "hub" {
  organization = "scaleout"
  workspace    = "fast-dev-global-gcp-network-connectivity-hub"
}
