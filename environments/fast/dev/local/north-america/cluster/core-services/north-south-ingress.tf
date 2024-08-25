module "north-south-ingress" {
  source        = "../../../../../../../terraform-modules/cluster/services/kind-north-south-ingress"
  node_selector = "node.wescaleout.cloud/routing"
  istio_rev     = "1-23-0"
  replicas      = 1
  depends_on = [
    module.istio
  ]
}
