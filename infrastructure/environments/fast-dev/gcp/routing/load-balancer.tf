// this creates an external load balancer that passes all traffic through a tls
// terminating proxy.
resource "google_compute_global_forwarding_rule" "ingress" {
  name                  = "${local.project}-public"
  target                = google_compute_target_https_proxy.ingress.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

// this proxy terminates tls for all requests that match the routing rules
// defined in the url map.
resource "google_compute_target_https_proxy" "ingress" {
  name            = "${local.project}-tls-terminate"
  url_map         = google_compute_url_map.ingress.id
  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.main.id}"
}

// this catch-all routing rule tells the tls proxy where to send incoming
// requests (ultimately istio-gateway which then handles routing requests
// to the right services in cluster, making istio the common method of
// managing routing in cluster across all cloud providers).
resource "google_compute_url_map" "ingress" {
  name            = "${local.project}-ingress"
  default_service = google_compute_backend_service.ingress.id
  path_matcher {
    name            = "all"
    default_service = google_compute_backend_service.ingress.id
  }
}

// this is the backend service the tls terminating proxy sends traffic to.
resource "google_compute_backend_service" "ingress" {
  name                  = "${local.project}-ingress"
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
    prevent_destroy = true
  }
}

// this defines how the backend service above knows if its network targets
// are healthy and ready to receive traffic. it exactly matches the readiness
// probe used on istio-gateway itself.
resource "google_compute_health_check" "istio-gateway" {
  name                = "${local.project}-istio-gateway"
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
