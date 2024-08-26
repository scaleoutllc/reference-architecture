resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "v1.15.3"
  values           = [var.values]
  set {
    name  = "crds.enabled"
    value = true
  }
}

resource "helm_release" "letsencrypt-istio-route53-issuer" {
  count = var.letsencrypt_email != "" ? 1 : 0
  name  = "letsencrypt-istio-issuer"
  chart = "${path.module}/letsencrypt-istio-route53-issuer"
  set {
    name  = "AWS_REGION"
    value = var.letsencrypt_route53_aws_region
  }
  set {
    name  = "AWS_ACCESS_KEY_ID"
    value = base64encode(var.letsencrypt_route53_aws_access_key_id)
  }
  set {
    name  = "AWS_SECRET_ACCESS_KEY"
    value = base64encode(var.letsencrypt_route53_aws_secret_access_key)
  }
  set {
    name  = "email"
    value = var.letsencrypt_email
  }
  set {
    name  = "private_key"
    value = base64encode(var.letsencrypt_private_key)
  }
  depends_on = [
    helm_release.cert-manager
  ]
}

resource "helm_release" "aws-privateca-issuer" {
  name       = "aws-privateca-issuer"
  namespace  = "cert-manager"
  chart      = "aws-privateca-issuer"
  repository = "https://cert-manager.github.io/aws-privateca-issuer"
  version    = "1.3.0"
  depends_on = [
    helm_release.cert-manager
  ]
}

resource "helm_release" "aws-privateca-issuer-config" {
  name  = "cert-manager-aws-privateca-issuer"
  chart = "${path.module}/aws-privateca-issuer"
  set {
    name  = "arn"
    value = var.aws_privateca_arn
  }
  set {
    name  = "AWS_REGION"
    value = var.aws_privateca_region
  }
  set {
    name  = "AWS_ACCESS_KEY_ID"
    value = base64encode(var.aws_privateca_access_key_id)
  }
  set {
    name  = "AWS_SECRET_ACCESS_KEY"
    value = base64encode(var.aws_privateca_secret_access_key)
  }
  depends_on = [
    helm_release.aws-privateca-issuer
  ]
}
