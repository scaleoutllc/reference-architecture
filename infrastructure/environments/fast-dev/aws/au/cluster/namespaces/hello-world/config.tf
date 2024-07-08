locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  area     = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.area}"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-cluster-namespaces-hello-world"
    }
  }
}

data "aws_eks_cluster" "this_env" {
  name = local.name
}

data "aws_eks_cluster_auth" "this_env" {
  name = local.name
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this_env.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this_env.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this_env.token
}
