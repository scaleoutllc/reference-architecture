terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform-dev"
      name    = "platform-dev-routing"
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

provider "google" {
  alias   = "us-east1"
  project = "${local.team}-${local.env}-gcp"
  region  = "us-east1"
}

provider "google" {
  alias   = "australia-southeast1"
  project = "${local.team}-${local.env}-gcp"
  region  = "australia-southeast1"
}

data "tfe_outputs" "aws-routing" {
  organization = "scaleout"
  workspace    = "platform-dev-aws-routing"
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
