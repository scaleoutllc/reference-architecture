data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "us"
  region   = "us-east-1"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
  network  = data.tfe_outputs.network.values
  cluster  = data.tfe_outputs.cluster.values
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-cluster-eks"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-cluster-nodes"
    }
  }
}

provider "aws" {
  region = local.region
}
