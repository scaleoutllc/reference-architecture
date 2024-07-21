output "kubectl-context" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${local.region} --profile ${local.locale} --alias ${local.name}"
}

output "name" {
  value = module.eks.cluster_name
}

output "primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "service_cidr" {
  value = module.eks.cluster_service_cidr
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
