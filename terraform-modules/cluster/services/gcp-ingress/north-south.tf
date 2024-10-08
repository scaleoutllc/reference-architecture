resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
    labels = {
      "istio.io/rev" = var.istio_rev
    }
  }
}

resource "helm_release" "north-south-gateway" {
  name             = "north-south-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "ingress"
  create_namespace = true
  version          = var.gateway_version
  values = [<<YAML
autoscaling:
  enabled: false
replicaCount: ${var.replicas}
nodeSelector:
  ${var.node_selector}: "true"
tolerations:
- key: ${var.node_selector}
  operator: Equal
  value: "true"
  effect: NoSchedule
topologySpreadConstraints:
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app: north-south-gateway
service:
  type: ClusterIP
  annotations:
    # https://cloud.google.com/kubernetes-engine/docs/how-to/standalone-neg
    # produce internal network endpoint groups that route directly to pods
    # the name of the NEG and the name of the backend service being the same DO NOT MATTER
    # the absence of a name in this annotation makes the NEG be named dynamically and is
    # confusing to look at in the GCP UI.
    cloud.google.com/neg: '{"exposed_ports":{"80":{"name":"${local.lbName}"}}}'
    
    # https://github.com/GoogleCloudPlatform/gke-autoneg-controller
    # attach to two backends, the first is the region-specific load balancer, the second is global
    controller.autoneg.dev/neg: '{"backend_services":{"80":[{"name":"${local.lbName}","max_rate_per_endpoint":1000},{"name":"${var.global_load_balancer_name}","max_rate_per_endpoint":1000}]}}'
    # used with gateway controller / cloud.google.com/app-protocols: '{"http":"80"}'
    # used with gateway controller / cloud.google.com/load-balancer-type: "Internal"
YAML
  ]
  depends_on = [
    google_compute_backend_service.north-south,
    kubernetes_namespace.ingress
  ]
}
