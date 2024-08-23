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
      project = "fast-dev-aws"
      name    = "fast-dev-aws-ap-southeast-2-workload-cluster-k8s-core-services"
    }
  }
}

data "tfe_outputs" "ca" {
  organization = "scaleout"
  workspace    = "providers-istio-ca-dev"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-ap-southeast-2-workload-cluster-k8s"
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
