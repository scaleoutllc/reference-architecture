module "ingress" {
  source          = "../../../../../../../terraform-modules/cluster/services/kind-ingress"
  node_selector   = "node.wescaleout.cloud/routing"
  istio_rev       = "1-23-0"
  gateway_version = "1.23.0"
  replicas        = 1
  depends_on = [
    module.istio
  ]
}
