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
      name    = "providers-gcp-project-fast-dev"
    }
  }
}

provider "google" {}
