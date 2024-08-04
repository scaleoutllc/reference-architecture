module "kustomization" {
  source = "../../../../../../../terraform-modules/kustomization"
  path   = path.module
  cluster = {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    cluster_ca_certificate = data.google_container_cluster.this.master_auth[0].cluster_ca_certificate
    user = {
      token = data.google_client_config.caller.access_token
    }
  }
}

resource "helm_release" "north-south-gateway" {
  name             = "north-south-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "ingress"
  create_namespace = false
  version          = "1.21.1"
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
      app: north-south-gateway
service:
  type: ClusterIP
  annotations:
    # https://cloud.google.com/kubernetes-engine/docs/how-to/standalone-neg
    # produce internal network endpoint groups that route directly to pods
    # the name of the NEG and the name of the backend service being the same DO NOT MATTER
    # the absence of a name in this annotation makes the NEG be named dynamically and is
    # confusing to look at in the GCP UI.
    cloud.google.com/neg: '{"exposed_ports":{"80":{"name":"${local.name}-north-south"}}}'
    
    # https://github.com/GoogleCloudPlatform/gke-autoneg-controller
    # attach to two backends, the first is the region-specific load balancer, the second is global
    controller.autoneg.dev/neg: '{"backend_services":{"80":[{"name":"${local.name}-north-south","max_rate_per_endpoint":1000},{"name":"${local.team}-${local.env}-${local.provider}-global-north-south","max_rate_per_endpoint":1000}]}}'
    # used with gateway controller / cloud.google.com/app-protocols: '{"http":"80"}'
    # used with gateway controller / cloud.google.com/load-balancer-type: "Internal"
YAML
  ]
  depends_on = [
    module.kustomization,
    google_compute_backend_service.north-south
  ]
}
