# resource "helm_release" "east-west-gateway" {
#   name       = "east-west-gateway"
#   repository = "https://istio-release.storage.googleapis.com/charts"
#   chart      = "gateway"
#   namespace  = "ingress"
#   version    = var.gateway_version
#   values = [<<YAML
# autoscaling:
#   enabled: false
# replicaCount: ${var.replicas}
# nodeSelector:
#   ${var.node_selector}: "true"
# tolerations:
# - key: ${var.node_selector}
#   operator: Equal
#   value: "true"
#   effect: NoSchedule
# service:
#   type: NodePort
#   ports:
#   - name: https
#     port: 4443
#     nodePort: 4443
# YAML
#   ]
#   depends_on = [
#     kubernetes_namespace.ingress
#   ]
# }
