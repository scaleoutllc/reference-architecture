resource "azuread_group" "fast-dev-aks-admin" {
  display_name     = "fast-dev-aks-admin"
  security_enabled = true
}

resource "azuread_group_member" "fast-dev-aks-admin" {
  for_each = toset([
    "52b113fd-08ec-4663-8b59-a2f3e9ca5485"
  ])
  group_object_id  = azuread_group.fast-dev-aks-admin.id
  member_object_id = each.key
}

// prerequisite role for cluster administrative group
// used for permission to see the cluster and list its users
resource "azurerm_role_assignment" "fast-dev-aks-list-users" {
  scope                = "/subscriptions/a659386b-33ac-4e4b-85fb-157e024ba574"
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.fast-dev-aks-admin.id
}
