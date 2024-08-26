module "istio-namespaces" {
  source = "../../../../../../../terraform-modules/cluster/services/istio-namespaces"
}

output "istio_namespace_revs" {
  value = module.istio-namespaces.all
}