data "aws_eks_cluster" "au" {
  provider = aws.au
  name     = "${local.area}-au"
}

data "aws_eks_cluster_auth" "au" {
  provider = aws.au
  name     = "${local.area}-au"
}

provider "kubernetes" {
  alias                  = "au"
  host                   = data.aws_eks_cluster.au.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.au.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.au.token
}

data "kubernetes_secret" "au" {
  provider = kubernetes.au
  metadata {
    name      = "istio-reader-service-account-istio-remote-secret-token"
    namespace = "istio-system"
  }
}

locals {
  au = templatefile("${path.module}/istio-remote-secret.yml", {
    name                   = "${local.area}-au"
    host                   = data.aws_eks_cluster.au.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.au.certificate_authority[0].data
    token                  = data.kubernetes_secret.au.data.token
  })
}

resource "kubernetes_secret" "au-to-us" {
  provider = kubernetes.au
  metadata {
    name      = "istio-remote-secret-${local.area}-us"
    namespace = "istio-system"
    labels = {
      "istio/multiCluster" = "true"
    }
    annotations = {
      "networking.istio.io/cluster" = "${local.area}-us"
    }
  }
  data = {
    "${local.area}-us" = local.us
  }
}
