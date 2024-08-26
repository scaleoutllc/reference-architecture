module "istio" {
  source = "../../../../../../../terraform-modules/cluster/services/istio"
  name   = local.name
  deployments = {
    blue = {
      version  = "1.22.2"
      deployed = false
    }
    green = {
      version  = "1.23.0"
      deployed = true
    }
  }
  replicas      = 1
  mesh_id       = "${local.env}-${local.area}"
  network       = local.area
  node_selector = "node.wescaleout.cloud/routing"
  depends_on = [
    module.cert-manager
  ]
}
