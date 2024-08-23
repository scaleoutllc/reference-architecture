resource "aws_acm_certificate" "main" {
  domain_name               = var.domain
  subject_alternative_names = var.sans
  validation_method         = "DNS"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [
    for record in aws_route53_record.main : record.fqdn
  ]
}

resource "aws_route53_record" "main" {
  for_each = {
    for validate in aws_acm_certificate.main.domain_validation_options : validate.domain_name => {
      name   = validate.resource_record_name
      record = validate.resource_record_value
      type   = validate.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}
