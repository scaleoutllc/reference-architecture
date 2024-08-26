resource "helm_release" "north-south-gateway" {
  name       = "north-south-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "ingress"
  version    = var.gateway_version
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
service:
  type: NodePort
  ports:
  - name: https
    port: 443
    nodePort: 443
  - name: http
    port: 80
    nodePort: 80
YAML
  ]
  depends_on = [
    kubernetes_namespace.ingress
  ]
}
