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
YAML
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
    # trigger using aws-load-balancer-controller (running in kube-system)
    service.beta.kubernetes.io/aws-load-balancer-type: external
    # use fixed name so load balancer can be found easily with data lookups
    service.beta.kubernetes.io/aws-load-balancer-name: "${local.name}"
    # expose load balancer to world
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    # load balancer targets back into pods running istio-gateway rather than hopping through node
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
    # configure edge tls termination
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${data.aws_acm_certificate.this_env.arn}"
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
    external-dns.alpha.kubernetes.io/hostname: "aws-us.fast.dev.wescaleout.cloud,*.aws-us.fast.dev.wescaleout.cloud"
  ports:
  - port: 443
    targetPort: 80
YAML
  ]
  depends_on = [
    helm_release.istiod
  ]
}

data "aws_lb" "ingress" {
  name       = local.name
  depends_on = [helm_release.istio-gateway]
}

resource "aws_globalaccelerator_endpoint_group" "main" {
  listener_arn          = data.tfe_outputs.aws-routing.values.listener_arn
  endpoint_group_region = data.aws_region.this_env.name
  endpoint_configuration {
    endpoint_id = data.aws_lb.ingress.arn
  }
}
