data "google_compute_network" "us" {
  name = "${local.area}-us"
}

data "google_compute_network" "au" {
  name = "${local.area}-au"
}

resource "google_compute_firewall" "us-allow-au-ingress" {
  name    = "${local.name}-us-to-au"
  network = data.google_compute_network.us.id
  // TODO: figure out the appropriate way to allow cross-network comms
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "${local.area}-us-app",
    "${local.area}-us-routing",
    "${local.area}-us-system"
  ]
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "au-allow-us-ingress" {
  name      = "${local.name}-au-to-us"
  network   = data.google_compute_network.au.id
  direction = "INGRESS"
  // TODO: figure out the appropriate way to allow cross-network comms
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "${local.area}-au-app",
    "${local.area}-au-routing",
    "${local.area}-au-system"
  ]
  allow {
    protocol = "tcp"
  }
}
