module "network" {
  source                        = "Azure/subnets/azurerm"
  virtual_network_name          = local.name
  resource_group_name           = azurerm_resource_group.this.name
  virtual_network_location      = azurerm_resource_group.this.location
  virtual_network_address_space = [local.network.cidr]
  subnets = {
    pods     = { address_prefixes = [local.network.subnets.pods] }
    data     = { address_prefixes = [local.network.subnets.data] }
    services = { address_prefixes = [local.network.subnets.services] }
    apiserver = {
      address_prefixes = [local.network.subnets.apiserver]
      delegation = [
        { name = "Microsoft.ContainerService/managedClusters" }
      ]
    }
  }

}
