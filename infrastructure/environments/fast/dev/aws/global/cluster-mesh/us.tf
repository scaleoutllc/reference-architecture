data "aws_eks_cluster" "au" {
  provider = aws.us
  name     = "${local.area}-au"
}

data "aws_eks_cluster_auth" "au" {
  provider = aws.us
  name     = "${local.area}-au"
}

provider "kubernetes" {
  alias                  = "us"
  host                   = data.aws_eks_cluster.us.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.us.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.us.token
}

data "kubernetes_secret" "us" {
  provider = kubernetes.us
  metadata {
    name      = "istio-reader-service-account-istio-remote-secret-token"
    namespace = "istio-system"
  }
}

locals {
  us = templatefile("${path.module}/istio-remote-secret.yml", {
    name                   = "${local.area}-us"
    host                   = data.aws_eks_cluster.us.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.us.certificate_authority[0].data
    token                  = data.kubernetes_secret.us.data.token
  })
}

resource "kubernetes_secret" "us-to-au" {
  provider = kubernetes.us
  metadata {
    name      = "istio-remote-secret-${local.area}-au"
    namespace = "istio-system"
    labels = {
      "istio/multiCluster" = "true"
    }
    annotations = {
      "networking.istio.io/cluster" = "${local.area}-au"
    }
  }
  data = {
    "${local.area}-au" = local.au
  }
}
