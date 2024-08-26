module "cluster" {
  source          = "../../../../../../../terraform-modules/cluster/kind"
  name            = local.name
  node_label_root = "node.wescaleout.cloud"
}

data "aws_route53_zone" "main" {
  name = local.domain
}

resource "aws_route53_record" "apex" {
  name            = "${module.cluster.subdomain}-${local.locale}-mgmt"
  records         = [module.cluster.ingress_node_ip]
  ttl             = 5
  type            = "A"
  zone_id         = data.aws_route53_zone.main.id
  allow_overwrite = true
}

resource "aws_route53_record" "star" {
  name            = "*.${module.cluster.subdomain}-${local.locale}-mgmt"
  records         = [module.cluster.ingress_node_ip]
  ttl             = 5
  type            = "A"
  zone_id         = data.aws_route53_zone.main.id
  allow_overwrite = true
}
