module "external-dns" {
  source                     = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name                  = "${local.name}-external-dns"
  attach_external_dns_policy = true
  oidc_providers = {
    main = {
      provider_arn               = data.tfe_outputs.cluster.values.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

resource "kubernetes_service_account" "external-dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.external-dns.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "external-dns" {
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  name       = "external-dns"
  namespace  = "kube-system"
  version    = "1.14.5"
  values = [
    <<YAML
domainFilters:
- fast.dev.wescaleout.cloud
provider:
  name: aws
env:
- name: AWS_DEFAULT_REGION
  value: ${local.region}
serviceAccount:
  create: false
  name: ${kubernetes_service_account.external-dns.metadata[0].name}
YAML
  ]
}
