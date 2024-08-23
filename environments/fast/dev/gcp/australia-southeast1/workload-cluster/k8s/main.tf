module "cluster" {
  source          = "../../../../../../../terraform-modules/cluster/gke"
  project         = local.project
  name            = local.name
  cluster_version = "1.29.6-gke.1326000"
  network_id      = data.google_compute_network.this.id
  subnetwork_id   = data.google_compute_subnetwork.this.id
  // third octet matches second of network to prevent collisions with peered vpcs 
  // TODO: remove this config and make it happen automatically
  control_plane_cidr = "192.168.40.0/28"
  node_label_root    = "node.wescaleout.cloud"
}
