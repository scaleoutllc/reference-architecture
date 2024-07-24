resource "azurerm_kubernetes_cluster_node_pool" "routing" {
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.this.id
  name                  = "routing"
  vm_size               = "Standard_B2s"
  node_count            = 1
  vnet_subnet_id        = data.tfe_outputs.network.values.module.vnet_subnets_name_id.pods
  zones                 = [1, 2, 3]
  max_pods              = 250
  node_labels = {
    "node.wescaleout.cloud/routing" = "true"
  }
  node_taints = [
    "node.wescaleout.cloud/routing=true:NoSchedule"
  ]
}
