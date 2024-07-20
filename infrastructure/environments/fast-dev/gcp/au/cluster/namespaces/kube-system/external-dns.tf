data "tls_certificate" "gke-oidc" {
  url = data.google_container_cluster.this_env.self_link
}

resource "aws_iam_openid_connect_provider" "gke-oidc" {
  url = data.google_container_cluster.this_env.self_link
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    data.tls_certificate.gke-oidc.certificates.0.sha1_fingerprint
  ]
}

module "iam-external-dns-for-gke" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v5.9"
  create_role                   = true
  role_name                     = "external-dns-${data.google_container_cluster.this_env.name}"
  role_description              = "External DNS role for GKE cluster ${data.google_container_cluster.this_env.name}"
  provider_url                  = aws_iam_openid_connect_provider.gke-oidc.url
  role_policy_arns              = [aws_iam_policy.external-dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-dns"]
}

data "aws_iam_policy_document" "external-dns" {
  statement {
    sid    = "ExternalDNSAllowChange"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }
  statement {
    sid    = "ExternalDNSAllowList"
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "external-dns" {
  name        = "gke-external-dns-${data.google_container_cluster.this_env.name}"
  description = "External DNS policy for GKE cluster ${data.google_container_cluster.this_env.name}"
  policy      = data.aws_iam_policy_document.external-dns.json
}

resource "kubernetes_service_account" "external-dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.iam-external-dns-for-gke.iam_role_arn
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
sources:
- gateway-httproute
env:
- name: AWS_DEFAULT_REGION
  value: us-east-1
- name: AWS_REGION
  value: us-east-1
- name: AWS_ROLE_ARN
  value: "${module.iam-external-dns-for-gke.iam_role_arn}"
- name: AWS_WEB_IDENTITY_TOKEN_FILE
  value: "/var/run/secrets/eks.amazonaws.com/serviceaccount/token"
- name: AWS_STS_REGIONAL_ENDPOINTS
  value: "regional"
extraVolumeMounts:
- mountPath: "/var/run/secrets/eks.amazonaws.com/serviceaccount/"
  name: aws-token
extraVolumes:
- name: aws-token
  projected:
    sources:
    - serviceAccountToken:
        audience: "sts.amazonaws.com"
        expirationSeconds: 86400
        path: token
serviceAccount:
  create: false
  name: ${kubernetes_service_account.external-dns.metadata[0].name}
YAML
  ]
}
