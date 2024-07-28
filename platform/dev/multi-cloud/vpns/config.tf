locals {
  team = "fast"
  env  = "dev"
  name = "${local.team}-${local.env}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-multi-cloud"
      name    = "fast-dev-multi-cloud"
    }
  }
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "aws" {
  alias  = "au"
  region = "ap-southeast-2"
}

provider "google" {
  alias   = "us"
  project = "${local.team}-${local.env}-gcp"
  region  = "us-east1"
}

provider "google" {
  alias   = "au"
  project = "${local.team}-${local.env}-gcp"
  region  = "australia-southeast1"
}

data "tfe_outputs" "aws-peering" {
  organization = "scaleout"
  workspace    = "fast-dev-global-aws-transit-gateway-peering"
}

data "tfe_outputs" "gcp-us-network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-network"
}

data "tfe_outputs" "gcp-au-network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-au-network"
}

data "tfe_outputs" "aws-us-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

data "tfe_outputs" "aws-au-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-au-network"
}
