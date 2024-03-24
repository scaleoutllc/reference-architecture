locals {
  domain = "team.dev.wescaleout.cloud"
  deployments = [
    { provider = "aws", region = "us" },
    { provider = "aws", region = "au" },
  ]
  providers = toset([for item in local.deployments : item.provider])
  regions   = toset([for item in local.deployments : item.region])
  fully-specified = toset(flatten([for provider in local.providers : [
    [for region in local.regions : [
      "${provider}-${region}" /*, "${region}-${provider}"*/
    ]]
  ]]))
}

resource "aws_route53_zone" "team" {
  name = local.domain
}

resource "aws_route53_zone" "provider" {
  for_each = local.providers
  name     = "${each.key}.${local.domain}"
}

resource "aws_route53_zone" "region" {
  for_each = local.regions
  name     = "${each.key}.${local.domain}"
}

resource "aws_route53_zone" "fully-specified" {
  for_each = local.fully-specified
  name     = "${each.key}.${local.domain}"
}

resource "aws_route53_record" "team-delegate" {
  zone_id = local.routing.dev-zone.id
  name    = aws_route53_zone.team.name
  records = aws_route53_zone.team.name_servers
  ttl     = 60
  type    = "NS"
}

resource "aws_route53_record" "provider-delegate" {
  for_each = local.providers
  zone_id  = aws_route53_zone.team.id
  name     = each.key
  records  = aws_route53_zone.provider[each.key].name_servers
  ttl      = 60
  type     = "NS"
}

resource "aws_route53_record" "region-delegate" {
  for_each = local.regions
  zone_id  = aws_route53_zone.team.id
  name     = each.key
  records  = aws_route53_zone.region[each.key].name_servers
  ttl      = 60
  type     = "NS"
}

resource "aws_route53_record" "fully-specified-delegate" {
  for_each = local.fully-specified
  zone_id  = aws_route53_zone.team.id
  name     = each.key
  records  = aws_route53_zone.fully-specified[each.key].name_servers
  ttl      = 60
  type     = "NS"
}