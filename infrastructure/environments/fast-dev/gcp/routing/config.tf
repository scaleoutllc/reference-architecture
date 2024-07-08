locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  area     = "routing"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp"
      name    = "fast-dev-gcp-routing"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "fast-dev-gcp"
  region  = "global"
}
