locals {
  lbName = "${local.team}-${local.env}-${local.provider}-${local.region}-north-south"
}

// this creates an external load balancer that passes all traffic through a tls
// terminating proxy.
resource "google_compute_global_forwarding_rule" "north-south" {
  name                  = local.lbName
  target                = google_compute_target_https_proxy.north-south.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

// this proxy terminates tls for all requests that match the routing rules
// defined in the url map. certmap is created in fast-dev/gcp/routing and
// shared by all clusters. certs cannot be created per-cluster because they
// share common SANs and the validation records clobber eachother.
resource "google_compute_target_https_proxy" "north-south" {
  name            = "${local.lbName}-tls-terminate"
  url_map         = google_compute_url_map.north-south.id
  certificate_map = "//certificatemanager.googleapis.com/projects/${local.project}/locations/global/certificateMaps/${local.area}"
  depends_on = [
    google_certificate_manager_certificate_map.main
  ]
}

// this catch-all routing rule tells the tls proxy where to send incoming
// requests (ultimately istio-gateway which then handles routing requests
// to the right services in cluster, making istio the common method of
// managing routing in cluster across all cloud providers).
resource "google_compute_url_map" "north-south" {
  name            = local.lbName
  default_service = google_compute_backend_service.north-south.id
  path_matcher {
    name            = "all"
    default_service = google_compute_backend_service.north-south.id
  }
}

// this is the backend service the tls terminating proxy sends traffic to.
resource "google_compute_backend_service" "north-south" {
  name                  = local.lbName
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks = [
    google_compute_health_check.istio-gateway.id
  ]
  // google.cloud.neg annotation on services create one NEG backend per zone
  // and the NEGs are kept up-to-date with IPs of all valid pods.
  // controller.autoneg.dev/neg annotations on services associate the NEGs
  // with this backend service.
  lifecycle {
    ignore_changes = [
      backend
    ]
  }
}

// this defines how the backend service above knows if its network targets
// are healthy and ready to receive traffic. it exactly matches the readiness
// probe used on istio-gateway itself.
resource "google_compute_health_check" "istio-gateway" {
  name                = "${local.lbName}-istio-gateway"
  timeout_sec         = 3
  check_interval_sec  = 15
  healthy_threshold   = 1
  unhealthy_threshold = 4
  http_health_check {
    port               = 15021
    request_path       = "/healthz/ready"
    port_specification = "USE_FIXED_PORT"
  }
}

resource "aws_route53_record" "north-south" {
  for_each = toset([
    "${local.provider}.${local.domain}",   // provider apex
    "*.${local.provider}.${local.domain}", // provider star
  ])
  name    = each.value
  records = [google_compute_global_forwarding_rule.north-south.ip_address]
  ttl     = 60
  type    = "A"
  zone_id = data.aws_route53_zone.main.id
}
