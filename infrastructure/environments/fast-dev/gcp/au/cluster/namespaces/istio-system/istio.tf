resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.22.2"
  namespace        = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  version    = "1.22.2"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
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
YAML
  ]
  depends_on = [
    helm_release.istio-base
  ]
}

resource "helm_release" "istio-gateway" {
  name       = "istio-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
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
  annotations:
    # produce internal network endpoint groups that route directly to pods
    cloud.google.com/neg: '{"ingress": true}'
    cloud.google.com/app-protocols: '{"http":"80"}'
    cloud.google.com/load-balancer-type: "Internal"
  type: ClusterIP
YAML
  ]
  depends_on = [
    helm_release.istiod
  ]
}

// This resource ensures that any load balancers that use listeners (network
// endpoint groups) associated with the istio-gateway know how to health check
// them for liveness/readiness.
resource "kubectl_manifest" "istio-gateway-health-check" {
  yaml_body = <<YAML
apiVersion: networking.gke.io/v1
kind: HealthCheckPolicy
metadata:
  name: istio-gateway-listeners
  namespace: istio-system
spec:
  default:
    config:
      type: HTTP
      httpHealthCheck:
        port: 15021
        requestPath: /healthz/ready
  targetRef:
    group: ""
    kind: Service
    name: istio-gateway
YAML
  depends_on = [
    helm_release.istio-base
  ]
}

// https://cloud.google.com/kubernetes-engine/docs/how-to/secure-gateway#secure-using-certificate-manager
// https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#limitations
resource "kubectl_manifest" "tls-terminating-load-balancer" {
  yaml_body = <<YAML
kind: Gateway
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: ingress
  namespace: istio-system
  annotations:
    networking.gke.io/certmap: ${local.team}-${local.env}
spec:
  gatewayClassName: gke-l7-global-external-managed
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    allowedRoutes:
      namespaces:
        from: All
YAML
  depends_on = [
    helm_release.istio-base
  ]
}

resource "kubectl_manifest" "common-ingress-to-istio-gateway" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: common
  namespace: istio-system
  annotations:
    external-dns.alpha.kubernetes.io/hostname: "gcp-au.fast.dev.wescaleout.cloud,*.gcp-au.fast.dev.wescaleout.cloud"
spec:
  parentRefs:
  - kind: Gateway
    name: ingress
    namespace: istio-system
  hostnames:
  - "*.fast.dev.wescaleout.cloud"
  - "*.au.fast.dev.wescaleout.cloud"
  - "*.gcp.fast.dev.wescaleout.cloud"
  - "*.gcp-au.fast.dev.wescaleout.cloud"
  rules:
  - matches:
    - path:
        value: /
    backendRefs:
    - name: istio-gateway
      port: 80
YAML
  depends_on = [
    helm_release.istio-base
  ]
}

