output "kubectl-context" {
  value = "gcloud container clusters get-credentials ${local.name} --region ${local.region} --project ${local.area} && kubectl config rename-context gke_${local.area}_${local.region}_${local.name} ${local.name}"
}