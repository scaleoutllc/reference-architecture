locals {
  team     = "fast"
  env      = "dev"
  cluster  = "workload"
  provider = "aws"
  region   = "us-east-1"
  area     = "${local.team}-${local.env}-${local.cluster}-${local.provider}"
  name     = "${local.area}-${local.region}"
  networks = yamldecode(file("../../../../../../../Networkfile")).networks
  network  = local.networks[local.env]["${local.provider}-${local.region}-${local.team}-${local.cluster}"]
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws"
      name    = "fast-dev-aws-us-east-1-workload-cluster-network"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_caller_identity" "this" {}
