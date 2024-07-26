output "config" {
  value = local.network
}

output "id" {
  value = google_compute_network.main.id
}