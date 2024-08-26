output "kind" {
  value = kind_cluster.main
}

output "ingress_node_ip" {
  value = data.external.ingress_node.result.address
}

output "subdomain" {
  value = module.user.name
}
