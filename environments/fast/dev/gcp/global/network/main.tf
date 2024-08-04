resource "google_compute_network" "main" {
  name                    = local.name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}
