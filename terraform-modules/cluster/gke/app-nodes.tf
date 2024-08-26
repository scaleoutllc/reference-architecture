resource "google_container_node_pool" "app" {
  name              = "${var.name}-app"
  cluster           = google_container_cluster.main.name
  node_count        = 1 // per zone
  max_pods_per_node = 50
  node_config {
    disk_size_gb    = 20
    preemptible     = true
    machine_type    = "e2-small"
    service_account = google_service_account.nodes.email
    image_type      = "COS_CONTAINERD"
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      "${var.node_label_root}/app" = "true"
    }
    taint {
      key    = "${var.node_label_root}/app"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
    tags = ["${var.name}-app"]
  }
}
