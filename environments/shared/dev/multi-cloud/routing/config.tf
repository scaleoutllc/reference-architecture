terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "shared-dev-multi-cloud"
      name    = "shared-dev-multi-cloud-routing"
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

provider "google-beta" {
  project = "scaleout-dev"
  region  = "us-east1"
  alias   = "us-east1"
}

provider "google-beta" {
  project = "scaleout-dev"
  region  = "australia-southeast1"
  alias   = "australia-southeast1"
}

data "tfe_outputs" "aws-routing" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-global-routing"
}

data "tfe_outputs" "gcp-routing" {
  organization = "scaleout"
  workspace    = "shared-dev-gcp-global-routing"
}

data "tfe_outputs" "shared-dev-gcp-us-east1-network" {
  organization = "scaleout"
  workspace    = "shared-dev-gcp-us-east1-network"
}

data "tfe_outputs" "shared-dev-gcp-australia-southeast1-network" {
  organization = "scaleout"
  workspace    = "shared-dev-gcp-australia-southeast1-network"
}

data "tfe_outputs" "shared-dev-aws-us-east-1-network" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-us-east-1-network"
}

data "tfe_outputs" "shared-dev-aws-ap-southeast-2-network" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-ap-southeast-2-network"
}

data "tfe_outputs" "fast-dev-gcp-us-east1-network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-us-east1-network"
}

data "tfe_outputs" "fast-dev-gcp-australia-southeast1-network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-australia-southeast1-network"
}

data "tfe_outputs" "fast-dev-aws-us-east-1-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-east-1-network"
}

data "tfe_outputs" "fast-dev-aws-ap-southeast-2-network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-network"
}

// I'm not sure this indirection pays for itself but the resources that depend
// on these values are arguably easier to reason about with shorter names.
locals {
  gcp-routing               = data.tfe_outputs.gcp-routing.values
  aws-routing               = data.tfe_outputs.aws-routing.values
  aws-transit-gateway       = data.tfe_outputs.aws-routing.values.transit-gateway
  aws-peering-attachment-id = data.tfe_outputs.aws-routing.values.peering-attachment-id
  shared = {
    gcp-us-east1             = data.tfe_outputs.shared-dev-gcp-us-east1-network.values
    gcp-australia-southeast1 = data.tfe_outputs.shared-dev-gcp-australia-southeast1-network.values
    aws-us-east-1            = data.tfe_outputs.shared-dev-aws-us-east-1-network.values
    aws-ap-southeast-2       = data.tfe_outputs.shared-dev-aws-ap-southeast-2-network.values
  }
  fast = {
    gcp-us-east1             = data.tfe_outputs.fast-dev-gcp-us-east1-network.values
    gcp-australia-southeast1 = data.tfe_outputs.fast-dev-gcp-australia-southeast1-network.values
    aws-us-east-1            = data.tfe_outputs.fast-dev-aws-us-east-1-network.values
    aws-ap-southeast-2       = data.tfe_outputs.fast-dev-aws-ap-southeast-2-network.values
  }
}
