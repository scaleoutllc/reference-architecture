locals {
  domain = "fast.dev.wescaleout.cloud"
  sans = [
    local.domain,                             // global
    "*.${local.domain}",                      // global
    "*.us.${local.domain}",                   // regional
    "*.au.${local.domain}",                   // regional
    "*.${local.provider}.${local.domain}",    // provider
    "*.${local.provider}-us.${local.domain}", // fully-specified
    "*.${local.provider}-au.${local.domain}"  // fully-specified
  ]
}

resource "google_certificate_manager_dns_authorization" "main" {
  // google automatically covers the wildcard of the domain supplied.
  for_each = toset([
    for domain in slice(local.sans, 1, length(local.sans)) : replace(domain, "*.", "")
  ])
  name   = replace(each.value, ".", "-")
  domain = each.value
  type   = "PER_PROJECT_RECORD"
}

resource "google_certificate_manager_certificate" "main" {
  name = replace(local.domain, ".", "-")
  managed {
    domains = local.sans
    dns_authorizations = [
      for auth in google_certificate_manager_dns_authorization.main : auth.id
    ]
  }
}

resource "aws_route53_record" "main" {
  for_each = {
    for validate in google_certificate_manager_dns_authorization.main : validate.domain => {
      name    = validate.dns_resource_record[0].name
      records = validate.dns_resource_record[0].data
      type    = validate.dns_resource_record[0].type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.records]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.id
}

resource "google_certificate_manager_certificate_map" "main" {
  name = local.area
}

resource "google_certificate_manager_certificate_map_entry" "main" {
  for_each     = toset(local.sans)
  name         = replace(replace(each.value, ".", "-"), "*", "star")
  map          = google_certificate_manager_certificate_map.main.name
  certificates = [google_certificate_manager_certificate.main.id]
  hostname     = each.value
}
