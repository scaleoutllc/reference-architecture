locals {
  tfc = {
    hostname = "app.terraform.io"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "provider"
      name    = "provider-gcp-project-fast-dev"
    }
  }
}

provider "google" {}