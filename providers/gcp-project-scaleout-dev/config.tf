locals {
  tfc = {
    hostname = "app.terraform.io"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "providers-gcp-project-scaleout-dev"
    }
  }
}

provider "google" {}
