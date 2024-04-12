resource "cloudflare_zone" "wescaleout-cloud" {
  account_id = local.cloudflare_account_id
  zone       = "wescaleout.cloud"
}

resource "aws_route53_zone" "dev" {
  name = "dev.wescaleout.cloud"
}

resource "cloudflare_record" "dev-delegate" {
  count   = 4
  zone_id = cloudflare_zone.wescaleout-cloud.id
  name    = "dev"
  value   = aws_route53_zone.dev.name_servers[count.index]
  type    = "NS"
  ttl     = 60
}
