output "kubectl-context" {
  value = "gcloud container clusters get-credentials ${local.name} --region ${local.region} --project scaleout-dev && kubectl config rename-context gke_scaleout-dev_${local.region}_${local.name} ${local.name}"
}

output "name" {
  value = local.name
}
