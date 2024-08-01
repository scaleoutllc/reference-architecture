locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us-east-1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-namespaces-kube-system"
    }
  }
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-cluster"
}

data "aws_eks_cluster" "this" {
  name = local.name
}

data "aws_eks_cluster_auth" "this" {
  name = local.name
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
