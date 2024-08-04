resource "google_container_cluster" "main" {
  name                     = local.name
  min_master_version       = "1.29.6-gke.1038001"
  enable_l4_ilb_subsetting = true
  networking_mode          = "VPC_NATIVE"
  network                  = data.google_compute_network.this.id
  subnetwork               = data.google_compute_subnetwork.this.id
  ip_allocation_policy {
    // Refers to secondary_ip_range entries in subnetwork.
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  private_cluster_config {
    enable_private_nodes = true
    // third octet matches second of network to prevent collisions with peered vpcs
    master_ipv4_cidr_block = "192.168.30.0/28"
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
    workload_pool = "${local.project}svc.id.goog"
  }
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}

resource "google_compute_firewall" "north-south" {
  name    = "${local.name}-north-south"
  network = data.google_compute_network.this.id
  source_ranges = [
    // https://cloud.google.com/load-balancing/docs/firewall-rules
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
  target_tags = ["${local.name}-routing"]
  allow {
    protocol = "tcp"
    ports = [
      "80",   // istio-gateway
      "15021" // istio-gateway health check port
    ]
  }
}
