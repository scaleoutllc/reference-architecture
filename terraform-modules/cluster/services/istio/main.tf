resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.22.2"
  namespace  = "istio-system"
  depends_on = [
    kubernetes_namespace.istio-system
  ]
}

resource "helm_release" "istio-ca" {
  name  = "istio-ca"
  chart = "${path.module}/ca"
  depends_on = [
    helm_release.istio-base
  ]
}

// prevent istiod from starting up before the cacerts secret is generated from the CA in AWS
resource "time_sleep" "wait-for-istio-ca-init" {
  create_duration = "30s"
  depends_on = [
    helm_release.istio-ca
  ]
}

resource "helm_release" "istiod" {
  for_each   = { for name, config in var.deployments : name => config if config.deployed }
  name       = "istiod-${replace(each.value.version, ".", "-")}"
  version    = each.value.version
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
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
  extensionProviders:
    - name: "oauth2-proxy"
      envoyExtAuthzHttp:
        service: "oauth2-proxy.ingress.svc.cluster.local"
        port: "80" # The default port used by oauth2-proxy.
        includeHeadersInCheck: ["authorization", "cookie"] # headers sent to the oauth2-proxy in the check request.
        headersToUpstreamOnAllow: ["authorization", "path", "x-auth-request-user", "x-auth-request-email", "x-auth-request-access-token"] # headers sent to backend application when request is allowed.
        headersToDownstreamOnDeny: ["content-type", "set-cookie"] # headers sent back to the client when request is denied.
global:
  mesh_id: ${var.mesh_id}
  network: ${var.network}
  multiCluster:
    clusterName: ${var.name}
YAML
  ]
  depends_on = [
    time_sleep.wait-for-istio-ca-init
  ]
}

