module "istio" {
  source = "../../../../../../../terraform-modules/cluster/services/istio"
  name   = local.name
  deployments = {
    blue = {
      version  = "1.22.2"
      deployed = false
    }
    green = {
      version  = "1.23.0"
      deployed = true
    }
  }
  replicas      = 1
  mesh_id       = "${local.env}-${local.area}"
  network       = local.area
  node_selector = "node.wescaleout.cloud/routing"
  depends_on = [
    module.cert-manager
  ]
}

data "kubernetes_all_namespaces" "list" {}
data "kubernetes_namespace" "all" {
  for_each = toset(data.kubernetes_all_namespaces.list.namespaces)
  metadata {
    name = each.value
  }
}
output "istio_injected_namespace_revs" {
  value = {
    for name, manifest in data.kubernetes_namespace.all :
    name => lookup(
      (manifest.metadata[0].labels != null ? manifest.metadata[0].labels : {}),
      "istio.io/rev",
      "none"
    ) if manifest.metadata[0].labels != null && contains(keys(manifest.metadata[0].labels), "istio.io/rev")
  }
}
