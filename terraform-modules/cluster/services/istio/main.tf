resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.22.2"
  namespace        = "istio-system"
  create_namespace = true
}


resource "helm_release" "istio-ca" {
  name  = "istio-ca"
  chart = "${path.module}/ca"
  depends_on = [
    helm_release.istio-base
  ]
}

resource "helm_release" "istiod" {
  for_each   = { for name, config in var.deployments : name => config if config.deployed }
  name       = "istiod-${replace(each.value.version, ".", "-")}"
  version    = each.value.version
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  wait       = true
  depends_on = [
    helm_release.istio-ca
  ]
  values = [<<YAML
defaultRevision: ${replace(each.value.version, ".", "-")}
revision: ${replace(each.value.version, ".", "-")}
pilot:
  replicas: ${var.replicas}
  nodeSelector:
    ${var.node_selector}: "true"
  tolerations:
  - key: "${var.node_selector}"
    operator: Equal
    value: "true"
    effect: NoSchedule
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: ScheduleAnyway
    labelSelector:
      matchLabels:
        app: istiod
meshConfig:
  holdApplicationUntilProxyStarts: "true"
global:
  mesh_id: ${var.mesh_id}
  network: ${var.network}
  multiCluster:
    clusterName: ${var.name}
YAML
  ]
}
