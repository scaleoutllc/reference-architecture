resource "google_network_connectivity_spoke" "fast-dev-gcp-us-east1" {
  name     = data.google_compute_network.fast-dev-gcp-us-east1.name
  location = "global"
  hub      = google_network_connectivity_hub.main.id
  linked_vpc_network {
    uri = data.google_compute_network.fast-dev-gcp-us-east1.self_link
  }
}

data "google_compute_network" "fast-dev-gcp-us-east1" {
  name = "fast-dev-gcp-us-east1"
}
