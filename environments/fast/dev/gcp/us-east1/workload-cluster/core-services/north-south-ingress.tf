module "north-south-ingress" {
  source  = "../../../../../../../terraform-modules/cluster/services/gcp-north-south-ingress"
  project = local.project
  name    = local.name
  team    = local.team
  env     = local.env
  area    = local.area
  load_balancer_domains = [
    "${local.provider}-${local.locale}.${local.domain}",
    "*.${local.provider}-${local.locale}.${local.domain}",
  ]
  replicas      = 3
  node_selector = "node.wescaleout.cloud/routing"
  istio_rev     = "1-23-0"
  zone_id       = data.aws_route53_zone.main.id
  depends_on = [
    module.istio,
    module.autoneg-system
  ]
}

data "aws_route53_zone" "main" {
  name = local.domain
}

