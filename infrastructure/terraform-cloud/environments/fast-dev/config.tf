terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "terraform-cloud"
      name    = "terraform-cloud-fast-dev"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

// Created manually when setting up TFC.
data "tfe_oauth_client" "github" {
  organization     = "scaleout"
  service_provider = "github"
}

data "tfe_variable_set" "aws-account-root" {
  name         = "aws-account-root"
  organization = "scaleout"
}

data "tfe_variable_set" "gcp-project-fast-dev" {
  name         = "gcp-project-fast-dev"
  organization = "scaleout"
}
