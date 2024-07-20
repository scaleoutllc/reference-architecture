output "kubectl-bootstrap" {
  value = "gcloud container clusters get-credentials ${local.name} --region ${local.region} --project ${local.project}"
}
