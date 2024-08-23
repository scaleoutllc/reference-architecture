data "kustomization_build" "resources" {
  path = var.path
}

resource "kustomization_resource" "crds-and-namespaces" {
  for_each = {
    for ref in data.kustomization_build.resources.ids_prio[0] : replace(lower(replace(replace(trimprefix(ref, "_/"), "/", "-"), "_", "")), "--", "-") => ref
  }
  manifest = data.kustomization_build.resources.manifests[each.value]
}

resource "kustomization_resource" "resources" {
  for_each = {
    for ref in data.kustomization_build.resources.ids_prio[1] : replace(lower(replace(replace(trimprefix(ref, "_/"), "/", "-"), "_", "")), "--", "-") => ref
  }
  manifest = data.kustomization_build.resources.manifests[each.value]
  depends_on = [
    kustomization_resource.crds-and-namespaces
  ]
}

resource "kustomization_resource" "webhooks" {
  for_each = {
    for ref in data.kustomization_build.resources.ids_prio[2] : replace(lower(replace(replace(trimprefix(ref, "_/"), "/", "-"), "_", "")), "--", "-") => ref
  }
  manifest = data.kustomization_build.resources.manifests[each.value]
  depends_on = [
    kustomization_resource.webhooks
  ]
}
