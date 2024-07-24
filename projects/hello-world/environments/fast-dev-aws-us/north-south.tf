resource "helm_release" "north-south-gateway" {
  name             = "north-south-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "ingress"
  create_namespace = true
  version          = "1.21.1"
  values = [<<YAML
autoscaling:
  enabled: false
replicaCount: 1
nodeSelector:
  node.wescaleout.cloud/routing: "true"
tolerations:
- key: node.wescaleout.cloud/routing
  operator: Equal
  value: "true"
  effect: NoSchedule
topologySpreadConstraints:
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app: north-south-gateway
annotations:
  service.beta.kubernetes.io/azure-load-balancer-internal: "true"
  service.beta.kubernetes.io/azure-pls-create: "true"
  service.beta.kubernetes.io/azure-pls-name: "${local.name}-north-south"
  service.beta.kubernetes.io/azure-pls-fqdns: "azure-us.fast.dev.wescaleout.cloud"
  service.beta.kubernetes.io/azure-pls-proxy-protocol: "true"
  service.beta.kubernetes.io/azure-pls-visibility: "*"
  service.beta.kubernetes.io/azure-pls-auto-approval: ${local.subscription_id}
YAML
  ]
}

data "azurerm_private_link_service" "north-south" {
  name                = "${local.name}-north-south"
  resource_group_name = "fast-dev-azure-us-aks-nodes"
  depends_on = [
    helm_release.north-south-gateway
  ]
}

resource "azurerm_cdn_frontdoor_profile" "north-south" {
  name                = "${local.name}-north-south"
  resource_group_name = "fast-dev-azure-us-aks-nodes"
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "north-south" {
  name                     = "${local.name}-north-south"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.north-south.id
  enabled                  = true
}

resource "azurerm_cdn_frontdoor_origin_group" "north-south" {
  name                     = "${local.name}-north-south"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.north-south.id
  session_affinity_enabled = false
  health_probe {
    protocol            = "Http"
    request_type        = "GET"
    path                = "/"
    interval_in_seconds = 30
  }
  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "north-south" {
  name                           = "${local.name}-north-south"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.north-south.id
  enabled                        = true
  host_name                      = "10.50.0.127"
  priority                       = 1
  weight                         = 1000
  http_port                      = 80
  certificate_name_check_enabled = true
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

  supported_protocols = ["Http", "Https"]
  patterns_to_match   = ["/*"]
  #forwarding_protocol    = "HttpOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

data "azapi_resource" "north-south" {
  type                   = "Microsoft.Network/privateLinkServices@2019-04-01"
  resource_id            = data.azurerm_private_link_service.north-south.id
  response_export_values = ["properties.privateEndpointConnections"]
}

resource "azapi_update_resource" "north-south" {
  for_each = toset([
    for connection in jsondecode(data.azapi_resource.north-south.output).properties.privateEndpointConnections : connection.name
  ])
  type      = "Microsoft.Network/privateLinkServices/privateEndpointConnections@2019-04-01"
  name      = each.key
  parent_id = data.azurerm_private_link_service.north-south.id
  body = jsonencode({
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform"
        status      = "Approved"
      }
    }
  })
}
