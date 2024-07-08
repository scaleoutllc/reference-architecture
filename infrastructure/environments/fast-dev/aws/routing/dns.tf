data "aws_route53_zone" "fast-dev" {
  name = "fast.dev.wescaleout.cloud"
}

resource "aws_route53_record" "fast-dev-aws-apex" {
  name    = "aws.fast.dev.wescaleout.cloud"
  records = aws_globalaccelerator_accelerator.main.ip_sets.0.ip_addresses
  ttl     = 60
  type    = "A"
  zone_id = data.aws_route53_zone.fast-dev.id
}

resource "aws_route53_record" "fast-dev-aws-wildcard" {
  name    = "*.aws.fast.dev.wescaleout.cloud"
  records = aws_globalaccelerator_accelerator.main.ip_sets.0.ip_addresses
  ttl     = 60
  type    = "A"
  zone_id = data.aws_route53_zone.fast-dev.id
}
