data "google_compute_network" "this" {
  name = "${local.area}-global"
}

resource "google_compute_subnetwork" "main" {
  name                     = local.name
  region                   = local.region
  ip_cidr_range            = local.network.cidr
  network                  = data.google_compute_network.this.self_link
  private_ip_google_access = true
  purpose                  = "PRIVATE"
}

resource "google_compute_router" "main" {
  name    = local.name
  network = data.google_compute_network.this.self_link
  region  = local.region
  bgp {
    asn = local.network.asn
  }
}

resource "google_compute_router_nat" "main" {
  name                               = local.name
  router                             = google_compute_router.main.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
