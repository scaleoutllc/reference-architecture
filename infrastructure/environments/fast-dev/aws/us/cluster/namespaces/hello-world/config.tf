locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "us"
  region   = "us-east-1"
  project  = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.project}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-cluster-namespaces-hello-world"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_eks_cluster" "this_env" {
  name = local.name
}

data "aws_eks_cluster_auth" "this_env" {
  name = local.name
}

module "manifest" {
  source = "../../../../../../../../shared/terraform/modules/kustomization"
  path   = path.module
  cluster = {
    host                   = data.aws_eks_cluster.this_env.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.this_env.certificate_authority[0].data
    token                  = data.aws_eks_cluster_auth.this_env.token
  }
}
