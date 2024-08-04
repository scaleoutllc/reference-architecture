module "vpn-aws-us-to-gcp-us" {
  source = "../../../../../terraform-modules/aws-gcp-vpn"
  name   = "aws-us-to-gcp-us"
  aws = {
    asn                            = local.shared["aws-us-east-1"].config.asn
    transit_gateway_id             = local.aws-transit-gateway["us-east-1"].id
    transit_gateway_route_table_id = local.aws-transit-gateway["us-east-1"].outbound_route_table_id
  }
  gcp = {
    asn               = local.shared["gcp-us-east1"].config.asn
    region            = "us-east1"
    network_name      = "shared-dev-gcp-global"
    cloud_router_name = "shared-dev-gcp-us-east1"
    // the shared network is peered to all other networks but the routes
    // for them are not shared over BGP to AWS without these additions.
    additional_ranges = [
      local.fast["gcp-us-east1"].config.cidr
    ]
    // TODO: pevent static cross-region routes in the transit gateway from
    // propagating back to GCP.
  }
  providers = {
    aws    = aws.us-east-1
    google = google-beta.us-east1
  }
}

resource "google_network_connectivity_spoke" "spoke-to-aws-us" {
  provider = google-beta.us-east1
  name     = "spoke-to-aws-us"
  location = "us-east1"
  hub      = local.gcp-routing.hub_id
  linked_vpn_tunnels {
    site_to_site_data_transfer = true
    uris                       = module.vpn-aws-us-to-gcp-us.tunnel_self_links
  }
  // just here to prevent continuous recreation. ignore_changes
  // on this value does not work and every apply recreates it
  // when this hash is empty.
  labels = {
    type = "spoke"
  }
  // dunno why this constantly thinks it is being changed.
  lifecycle {
    ignore_changes = [linked_vpn_tunnels]
  }
}
