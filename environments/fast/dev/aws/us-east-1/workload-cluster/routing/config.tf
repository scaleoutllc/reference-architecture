locals {
  team     = "fast"
  env      = "dev"
  cluster  = "workload"
  provider = "aws"
  region   = "us-east-1"
  locale   = "us"
  area     = "${local.team}-${local.env}-${local.cluster}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws"
      name    = "fast-dev-aws-us-east-1-cluster-k8s-routing"
    }
  }
  required_providers {
    kustomization = {
      source = "kbst/kustomization"
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

provider "kustomization" {
  kubeconfig_raw = yamlencode({
    apiVersion = "v1"
    clusters = [{
      name = local.name
      cluster = {
        certificate-authority-data = data.aws_eks_cluster.this.certificate_authority[0].data
        server                     = data.aws_eks_cluster.this.endpoint
      }
    }]
    users = [{
      name = local.name
      user = {
        token = data.aws_eks_cluster_auth.this.token
      }
    }]
    contexts = [{
      name = local.name
      context = {
        cluster = local.name
        user    = local.name
      }
    }]
  })
  context = local.name
}
