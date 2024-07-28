locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-namespaces-ingress"
    }
  }
}

provider "aws" {
  region = local.region
}

data "aws_eks_cluster" "this" {
  name = local.name
}

data "aws_eks_cluster_auth" "this" {
  name = local.name
}

data "tfe_outputs" "fast-dev-global-aws-load-balancer" {
  organization = "scaleout"
  workspace    = "fast-dev-global-aws-load-balancer"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
