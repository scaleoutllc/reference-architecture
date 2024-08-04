resource "aws_route53_zone" "fast-dev-wescaleout-cloud" {
  name = "fast.dev.wescaleout.cloud"
}

resource "cloudflare_record" "global-delegate" {
  count   = 4
  zone_id = cloudflare_zone.wescaleout-cloud.id
  name    = aws_route53_zone.fast-dev-wescaleout-cloud.name
  value   = element(aws_route53_zone.fast-dev-wescaleout-cloud.name_servers, count.index)
  type    = "NS"
  ttl     = "60"
}
