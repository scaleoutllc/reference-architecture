module "kustomization" {
  source = "../../../../../../../shared/terraform/kustomization"
  path   = path.module
  cluster = {
    host                   = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.host
    cluster_ca_certificate = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate
    user = {
      client-certificate-data = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate
      client-key-data         = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key
    }
  }
}

resource "helm_release" "north-south-gateway" {
  name             = "north-south-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "ingress"
  create_namespace = true
  version          = "1.21.1"
  values = [<<YAML
autoscaling:
  enabled: false
replicaCount: 1
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
      app: north-south-gateway
annotations:
  service.beta.kubernetes.io/azure-load-balancer-internal: "true"
  service.beta.kubernetes.io/azure-pls-create: "true"
  service.beta.kubernetes.io/azure-pls-name: "${local.name}-north-south"
  service.beta.kubernetes.io/azure-pls-ip-configuration-subnet: "services"
  service.beta.kubernetes.io/azure-pls-ip-configuration-ip-address-count: "1"
  service.beta.kubernetes.io/azure-pls-ip-configuration-ip-address: "${local.private_link_ip}"
  service.beta.kubernetes.io/azure-pls-proxy-protocol: "false" # envoy filter required to turn this on
  service.beta.kubernetes.io/azure-pls-auto-approval: "*"
  service.beta.kubernetes.io/azure-pls-visibility: "*"
YAML
  ]
}

