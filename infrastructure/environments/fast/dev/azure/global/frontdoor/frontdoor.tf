// This ridiculously costs $330/mo just to exist. The standard sku is
// cheaper but doesn't support private links.
resource "azurerm_cdn_frontdoor_profile" "north-south" {
  name                = "${local.name}-north-south"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Premium_AzureFrontDoor"
}
