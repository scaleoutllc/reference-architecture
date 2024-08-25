output "name" {
  value = "local.name"
}

output "kubectl-context" {
  value = "true"
}

output "endpoint" {
  value = module.cluster.kind.endpoint
}

output "client_certificate" {
  sensitive = true
  value     = module.cluster.kind.client_certificate
}

output "client_key" {
  sensitive = true
  value     = module.cluster.kind.client_key
}

output "cluster_ca_certificate" {
  sensitive = true
  value     = module.cluster.kind.cluster_ca_certificate
}

output "hostname" {
  value = "${module.cluster.subdomain}-${local.locale}.${local.domain}"
}
