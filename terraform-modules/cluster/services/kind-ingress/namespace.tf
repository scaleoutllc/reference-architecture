resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
    labels = {
      "istio.io/rev" = var.istio_rev
    }
  }
}
