# data "aws_route53_zone" "fast-dev" {
#   name = local.domain
# }

# resource "aws_route53_record" "fast-dev-aws-apex" {
#   name    = "aws.${local.domain}"
#   records = aws_globalaccelerator_accelerator.main.ip_sets.0.ip_addresses
#   ttl     = 60
#   type    = "A"
#   zone_id = data.aws_route53_zone.fast-dev.id
# }

# resource "aws_route53_record" "fast-dev-aws-wildcard" {
#   name    = "*.aws.${local.domain}"
#   records = aws_globalaccelerator_accelerator.main.ip_sets.0.ip_addresses
#   ttl     = 60
#   type    = "A"
#   zone_id = data.aws_route53_zone.fast-dev.id
# }
