resource "google_container_cluster" "main" {
  name                     = var.name
  min_master_version       = var.cluster_version
  enable_l4_ilb_subsetting = true
  networking_mode          = "VPC_NATIVE"
  network                  = var.network_id
  subnetwork               = var.subnetwork_id
  ip_allocation_policy {
    // Refers to secondary_ip_range entries in subnetwork.
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.control_plane_cidr
  }
  # List of networks that can contact the control plane.
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "all-for-testing"
    }
  }
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}

resource "google_compute_firewall" "north-south" {
  name    = "${var.name}-north-south"
  network = var.network_id
  source_ranges = [
    // https://cloud.google.com/load-balancing/docs/firewall-rules
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
  target_tags = ["${var.name}-routing"]
  allow {
    protocol = "tcp"
    ports = [
      "80",   // istio-gateway
      "15021" // istio-gateway health check port
    ]
  }
}
