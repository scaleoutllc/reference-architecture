data "google_compute_network" "this" {
  name = "${local.area}-global"
}

resource "google_compute_subnetwork" "main" {
  name                     = local.area
  region                   = local.region
  ip_cidr_range            = local.network.subnets.cluster
  network                  = data.google_compute_network.this.self_link
  private_ip_google_access = true
  purpose                  = "PRIVATE"
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = local.network.subnets.pods
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = local.network.subnets.services
  }
  secondary_ip_range {
    range_name    = "private"
    ip_cidr_range = local.network.subnets.private
  }
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
  region                             = local.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

