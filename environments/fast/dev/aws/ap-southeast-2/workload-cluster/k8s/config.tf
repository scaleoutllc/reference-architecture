locals {
  team     = "fast"
  env      = "dev"
  cluster  = "workload"
  provider = "aws"
  region   = "ap-southeast-2"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.cluster}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-workload-cluster-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws"
      name    = "fast-dev-aws-ap-southeast-2-cluster-k8s"
    }
  }
}

provider "aws" {
  region = local.region
}
