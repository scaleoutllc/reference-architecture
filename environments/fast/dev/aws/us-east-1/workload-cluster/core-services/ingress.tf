module "ingress" {
  source          = "../../../../../../../terraform-modules/cluster/services/aws-ingress"
  name            = local.name
  region          = local.region
  replicas        = 3
  node_selector   = "node.wescaleout.cloud/routing"
  istio_rev       = "1-23-0"
  gateway_version = "1.23.0"
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
    module.istio,
    module.load-balancer-controller
  ]
}

data "aws_route53_zone" "main" {
  name = local.domain
}
