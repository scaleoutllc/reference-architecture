module "manifest" {
  source = "../../../../../../../../shared/terraform/modules/kustomization"
  path   = path.module
  cluster = {
    host                   = "https://${data.google_container_cluster.this_env.endpoint}"
    cluster_ca_certificate = data.google_container_cluster.this_env.master_auth[0].cluster_ca_certificate
    token                  = data.google_client_config.caller.access_token
  }
}

resource "helm_release" "istio-gateway" {
  name       = "istio-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "ingress"
  version    = "1.21.1"
  values = [<<YAML
autoscaling:
  enabled: false
replicaCount: 3
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
      app: istio-gateway
service:
  type: ClusterIP
YAML
  ]
  depends_on = [
    module.manifest
  ]
}
