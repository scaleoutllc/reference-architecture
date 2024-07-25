locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "ap-southeast-2"
  locale   = "au"
  area     = "${local.team}-${local.env}-${local.provider}"
  name     = "${local.area}-${local.locale}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-namespaces-istio-system"
    }
  }
}

data "tfe_outputs" "ca" {
  organization = "scaleout"
  workspace    = "providers-istio-dev-ca"
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

