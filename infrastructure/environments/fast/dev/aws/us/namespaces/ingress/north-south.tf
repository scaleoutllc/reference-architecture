module "kustomization" {
  source = "../../../../../../../../shared/terraform/kustomization"
  path   = path.module
  cluster = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.this.certificate_authority[0].data
    user = {
      token = data.aws_eks_cluster_auth.this.token
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
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "${aws_acm_certificate.main.arn}"
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
    external-dns.alpha.kubernetes.io/hostname: "aws-us.fast.dev.wescaleout.cloud,*.aws-us.fast.dev.wescaleout.cloud"
  ports:
  - port: 443
    targetPort: 80
YAML
  ]
  depends_on = [
    module.kustomization
  ]
}

data "aws_lb" "ingress" {
  name       = local.name
  depends_on = [helm_release.north-south-gateway]
}

resource "aws_globalaccelerator_endpoint_group" "aws" {
  listener_arn          = data.tfe_outputs.platform-aws.values.listener_arn
  endpoint_group_region = local.region
  endpoint_configuration {
    endpoint_id = data.aws_lb.ingress.arn
  }
}
