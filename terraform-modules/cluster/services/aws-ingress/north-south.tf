resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
    labels = {
      "istio.io/rev" = var.istio_rev
    }
  }
}

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
topologySpreadConstraints:
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app: north-south-gateway
service:
  annotations:
    # trigger using aws-load-balancer-controller (running in kube-system)
    service.beta.kubernetes.io/aws-load-balancer-type: external
    # use fixed name so load balancer can be found easily with data lookups
    service.beta.kubernetes.io/aws-load-balancer-name: "${var.name}"
    # expose load balancer to world
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    # load balancer targets back into pods running istio-gateway rather than hopping through node
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
    # configure edge tls termination
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${aws_acm_certificate.main.arn}"
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
    external-dns.alpha.kubernetes.io/hostname: "${join(",", var.load_balancer_domains)}"
  ports:
  - port: 443
    targetPort: 80
YAML
  ]
  depends_on = [
    kubernetes_namespace.ingress
  ]
}
/*
this responsibility should be outside of this module, perhaps
data "tfe_outputs" "shared-dev-aws-global-load-balancer" {
  organization = "scaleout"
  workspace    = "shared-dev-aws-global-load-balancer"
}

data "aws_lb" "north-south" {
  name       = "${var.name}-north-south"
  depends_on = [helm_release.north-south-gateway]
}

resource "aws_globalaccelerator_endpoint_group" "aws" {
  listener_arn          = data.tfe_outputs.shared-dev-aws-global-load-balancer.values.listener_arn
  endpoint_group_region = var.region
  endpoint_configuration {
    endpoint_id = data.aws_lb.north-south.arn
  }
}
*/
