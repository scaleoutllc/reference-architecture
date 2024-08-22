resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "metrics-server"
  namespace        = "kube-system"
  version          = "7.2.11"
  create_namespace = false
  set {
    name  = "apiService.create"
    value = "true"
  }
}
