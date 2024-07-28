module "load-balancer-controller" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name                              = "${local.name}-load-balancer-controller"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = data.tfe_outputs.cluster.values.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "load-balancer-controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.load-balancer-controller.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "load-balancer-controller" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1"
  values = [
    <<YAML
clusterName: ${local.name}
region: ${local.region}
vpcId: ${data.tfe_outputs.network.values.vpc_id}
serviceAccount:
  create: false
  name: ${kubernetes_service_account.load-balancer-controller.metadata[0].name}
YAML
  ]
}
