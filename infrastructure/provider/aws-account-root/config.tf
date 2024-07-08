locals {
  tfc = {
    hostname = "app.terraform.io"
    audience = "aws.workload.identity"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "provider"
      name    = "provider-aws-account-root"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
