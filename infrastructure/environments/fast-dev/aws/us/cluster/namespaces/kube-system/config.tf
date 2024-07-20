locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "us"
  region   = "us-east-1"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-cluster-namespaces-kube-system"
    }
  }
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-cluster-eks"
}

data "aws_eks_cluster" "this_env" {
  name = local.name
}

data "aws_eks_cluster_auth" "this_env" {
  name = local.name
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this_env.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this_env.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this_env.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this_env.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this_env.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this_env.token
  }
}
