module "kustomization" {
  source = "../../../../../../../terraform-modules/kustomization"
  path   = path.module
  cluster = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.this.certificate_authority[0].data
    user = {
      token = data.aws_eks_cluster_auth.this.token
    }
  }
}

module "ingress" {
  source          = "../../../../../../../terraform-modules/aws-cluster/namespaces/ingress"
  name            = local.name
  region          = local.region
  node_label_root = "node.wescaleout.cloud"
  domain          = local.domain
  sans = [
    local.domain,
    "*.${local.domain}",
    "*.${local.provider}.${local.domain}",
    "*.${local.locale}.${local.domain}",
    "*.${local.provider}-${local.locale}.${local.domain}"
  ]
  load_balancer_domains = [
    "${local.provider}-${local.locale}.${local.domain}",
    "*.${local.provider}-${local.locale}.${local.domain}"
  ]
  zone_id = data.aws_route53_zone.main.id
  depends_on = [
    module.kustomization
  ]
}

data "aws_route53_zone" "main" {
  name = local.domain
}
