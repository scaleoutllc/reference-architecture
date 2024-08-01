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
      name    = "providers-gcp-project-platform-dev"
    }
  }
}

provider "google" {}
