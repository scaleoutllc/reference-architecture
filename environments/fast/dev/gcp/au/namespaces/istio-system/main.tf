resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
    labels = {
      "topology.istio.io/network" = local.area
    }
  }
}

resource "tls_private_key" "istio" {
  algorithm = "RSA"
}

resource "tls_cert_request" "istio" {
  private_key_pem = tls_private_key.istio.private_key_pem
  subject {
    common_name = "istiod.istio-system.svc"
  }
}

resource "tls_locally_signed_cert" "istio" {
  cert_request_pem      = tls_cert_request.istio.cert_request_pem
  ca_private_key_pem    = data.tfe_outputs.ca.values.private_key
  ca_cert_pem           = data.tfe_outputs.ca.values.cert
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 87600
  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "kubernetes_secret" "cacerts" {
  metadata {
    name      = "cacerts"
    namespace = "istio-system"
  }
  data = {
    "ca-cert.pem"    = tls_locally_signed_cert.istio.cert_pem
    "ca-key.pem"     = tls_private_key.istio.private_key_pem
    "root-cert.pem"  = data.tfe_outputs.ca.values.cert
    "cert-chain.pem" = "${tls_locally_signed_cert.istio.cert_pem}${data.tfe_outputs.ca.values.cert}"
  }
  depends_on = [
    kubernetes_namespace.istio-system
  ]
}

resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.22.2"
  namespace        = "istio-system"
  create_namespace = false
  depends_on = [
    kubernetes_secret.cacerts
  ]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  version    = "1.22.2"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  depends_on = [
    helm_release.istio-base
  ]
  values = [<<YAML
pilot:
  nodeSelector:
    node.wescaleout.cloud/routing: "true"
  tolerations:
  - key: node.wescaleout.cloud/routing
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
  holdApplicationUntilProxyStarts: "true"
  meshId: ${local.team}-${local.env}
  network: ${local.area}
  multiCluster:
    clusterName: ${local.name}
YAML
  ]
}
# https://istio.io/latest/docs/setup/install/multicluster/multi-primary/
# https://istio.io/latest/docs/setup/install/multicluster/multi-primary_multi-network/
