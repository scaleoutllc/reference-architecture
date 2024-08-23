resource "helm_release" "autoneg" {
  name             = "autoneg"
  chart            = "autoneg-controller-manager"
  repository       = "https://googlecloudplatform.github.io/gke-autoneg-controller/"
  namespace        = "autoneg-system"
  create_namespace = true
  set {
    name  = "createNamespace"
    value = false
  }
  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = "autoneg@${var.project}.iam.gserviceaccount.com"
  }
  set {
    name  = "serviceAccount.automountServiceAccountToken"
    value = true
  }
}
