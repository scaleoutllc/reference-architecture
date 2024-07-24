resource "azurerm_kubernetes_cluster" "main" {
  name                = local.name
  kubernetes_version  = "1.29"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = local.locale
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  // Enable pods assuming azure identities.
  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  // Enable azure ad role based authentication for cluster access.
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [local.admin_group_id]
    azure_rbac_enabled     = true
  }

  api_server_access_profile {
    vnet_integration_enabled = true
    // use apiserver subnet, minted purely for this because node pools cannot
    // ne in the same subnet.
    subnet_id = data.tfe_outputs.network.values.module.vnet_subnets_name_id.apiserver
  }
  // As of 2022-03-01, user managed identity with explicit permissions is required when
  // using vnet_integration_enabled (the alternative is an azure managed identity that is
  // created and managed with the cluster automatically but does not yet have the proper
  // access).
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.self.id
    ]
  }
  default_node_pool {
    name           = "system"
    vm_size        = "Standard_B2s"
    node_count     = 1
    vnet_subnet_id = data.tfe_outputs.network.values.module.vnet_subnets_name_id.pods
    zones          = [1, 2, 3]
    node_labels = {
      "node.kubernetes.io/system" = "true"
    }
    // Indirect method to apply taint to prevent regular workloads from being scheduled
    // on these nodes. Assigning taints manually is not allowed for default_node_pool.
    only_critical_addons_enabled = true
  }
  // Create a resource group for the default node group to reside in
  node_resource_group = "${local.name}-aks-nodes"
  lifecycle {
    ignore_changes = [
      default_node_pool.0.upgrade_settings
    ]
  }
}

// Give cluster access to manage resources in the subscription.
// ref: https://learn.microsoft.com/en-us/azure/aks/use-managed-identity
resource "azurerm_user_assigned_identity" "self" {
  name                = "cluster"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
resource "azurerm_role_assignment" "managed_identity_operator" {
  principal_id         = azurerm_user_assigned_identity.self.principal_id
  role_definition_name = "Managed Identity Operator"
  scope                = "/subscriptions/${local.subscription_id}"
}
resource "azurerm_role_assignment" "contributor" {
  principal_id         = azurerm_user_assigned_identity.self.principal_id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${local.subscription_id}"
}
resource "azurerm_role_assignment" "network_contributor" {
  principal_id         = azurerm_user_assigned_identity.self.principal_id
  role_definition_name = "Network Contributor"
  scope                = "/subscriptions/${local.subscription_id}"
}
