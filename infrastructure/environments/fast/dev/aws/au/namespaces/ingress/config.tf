locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
  domain   = "fast.dev.wescaleout.cloud"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-namespaces-ingress"
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

data "tfe_outputs" "fast-dev-aws-global-load-balancer" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-global-load-balancer"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

module "kustomization" {
  source = "../../../../../../../../shared/terraform/kustomization"
  path   = path.module
  cluster = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.this.certificate_authority[0].data
    user = {
      token = data.aws_eks_cluster_auth.this.token
    }
  }
}
