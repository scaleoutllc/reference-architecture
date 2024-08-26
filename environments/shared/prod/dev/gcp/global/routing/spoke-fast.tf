resource "google_network_connectivity_spoke" "spoke-fast" {
  name     = data.google_compute_network.fast.name
  location = "global"
  hub      = google_network_connectivity_hub.main.id
  linked_vpc_network {
    uri = data.google_compute_network.fast.self_link
  }
  // just here to prevent continuous recreation. ignore_changes
  // on this value does not work and every apply recreates it
  // when this hash is empty.
  labels = {
    type = "spoke"
  }
}

data "google_compute_network" "fast" {
  name = "fast-dev-gcp-global"
}
