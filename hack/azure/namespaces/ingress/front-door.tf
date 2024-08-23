locals {
  front_door_resource_group = "${local.area}-routing"
}

data "azurerm_cdn_frontdoor_profile" "north-south" {
  name                = "${local.area}-north-south"
  resource_group_name = local.front_door_resource_group
}

resource "azurerm_cdn_frontdoor_endpoint" "north-south" {
  name                     = "${local.name}-north-south"
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.north-south.id
  enabled                  = true
}

resource "azurerm_cdn_frontdoor_origin_group" "north-south" {
  name                     = "${local.name}-north-south"
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.north-south.id
  session_affinity_enabled = false
  // health checking on anything other the http_port specified in the origin
  // is not supported. this means envoy's health probe at :15021/healthz/ready
  // this could be worked around by doing health probing over HTTPS if the
  // probe had a valid cert, or by terminating TLS at the ingress gateway
  // so the http_port can be set to 15021 and health checking done as normal.
  // health_probe {
  //   protocol            = "Http"
  //   request_type        = "GET"
  //   path                = "/healthz/ready"
  // }
  load_balancing {}
}

// created by istio-gateway's service annotations.
data "azurerm_private_link_service" "north-south" {
  name                = "${local.name}-north-south"
  resource_group_name = "${local.name}-aks-nodes"
  depends_on = [
    helm_release.north-south-gateway
  ]
}

resource "azurerm_cdn_frontdoor_origin" "north-south" {
  name                           = "${local.name}-north-south"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.north-south.id
  enabled                        = true
  host_name                      = local.private_link_ip
  priority                       = 1
  weight                         = 1000
  http_port                      = 80
  certificate_name_check_enabled = true
  // this links to the private link service created by service annotations on
  // istio-gateway. pretty brittle. it would be nice if azure had something
  // like GCP's autoneg controller to attach these automatically.
  private_link {
    location               = local.region
    private_link_target_id = data.azurerm_private_link_service.north-south.id
  }
}

resource "azurerm_cdn_frontdoor_route" "my_route" {
  name                          = "${local.name}-north-south"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.north-south.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.north-south.id
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.north-south.id
  ]
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}
