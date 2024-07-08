output "kubectl-bootstrap" {
  value = <<EOF
gcloud container clusters get-credentials ${local.name} --region us-east1 --project fast-dev-gcp
EOF
}

output "name" {
  value = google_container_cluster.main.name
}

output "endpoint" {
  value = "https://${google_container_cluster.main.endpoint}"
}

output "ca-cert" {
  value     = base64decode(google_container_cluster.main.master_auth.0.cluster_ca_certificate)
  sensitive = true
}

output "token" {
  value     = google_container_cluster.main.master_auth.0.client_key
  sensitive = true
}

output "node-sa-email" {
  value = google_service_account.nodes.email
}
