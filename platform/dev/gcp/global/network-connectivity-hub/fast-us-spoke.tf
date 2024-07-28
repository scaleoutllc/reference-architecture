resource "google_network_connectivity_spoke" "main" {
  name     = local.name
  location = "global"
  hub      = data.tfe_outputs.hub.values.id
  linked_vpc_network {
    uri = google_compute_network.main.self_link
  }
}
