locals {
  name = "letsencrypt"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "providers"
      name    = "providers-letsencrypt"
    }
  }
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "2.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
