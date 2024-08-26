data "kubernetes_all_namespaces" "list" {}
data "kubernetes_namespace" "all" {
  for_each = toset(data.kubernetes_all_namespaces.list.namespaces)
  metadata {
    name = each.value
  }
}
output "all" {
  value = {
    for name, manifest in data.kubernetes_namespace.all :
    name => lookup(
      (manifest.metadata[0].labels != null ? manifest.metadata[0].labels : {}),
      "istio.io/rev",
      "none"
    ) if manifest.metadata[0].labels != null && contains(keys(manifest.metadata[0].labels), "istio.io/rev")
  }
}

