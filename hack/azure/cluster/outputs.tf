output "kubectl-context" {
  value = "az account set --subscription ${local.area} && az aks get-credentials --resource-group ${azurerm_resource_group.this.name} --name ${local.name} --overwrite-existing"
}
