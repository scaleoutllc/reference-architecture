locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "au"
  region   = "ap-southeast-2"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-cluster-namespaces-istio-system"
    }
  }
}

data "aws_eks_cluster" "this_env" {
  name = local.name
}

data "aws_eks_cluster_auth" "this_env" {
  name = local.name
}

data "aws_acm_certificate" "this_env" {
  domain   = "fast.dev.wescaleout.cloud"
  statuses = ["ISSUED"]
}

provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this_env.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this_env.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this_env.token
  }
}
