module "vpn-aws-au-to-gcp-au" {
  source = "../../../../../terraform-modules/aws-gcp-vpn"
  name   = "aws-au-to-gcp-au"
  aws = {
    asn                            = local.shared["aws-ap-southeast-2"].config.asn
    transit_gateway_id             = local.aws-transit-gateway["ap-southeast-2"].id
    transit_gateway_route_table_id = local.aws-transit-gateway["ap-southeast-2"].outbound_route_table_id
  }
  gcp = {
    asn               = local.shared["gcp-australia-southeast1"].config.asn
    region            = "australia-southeast1"
    network_name      = "shared-dev-gcp-global"
    cloud_router_name = "shared-dev-gcp-australia-southeast1"
    // the shared network is peered to all other networks but the routes
    // for them are not shared over BGP to AWS without these additions.
    additional_ranges = [
      local.fast["gcp-australia-southeast1"].config.cidr
    ]
    // TODO: pevent static cross-region routes in the transit gateway from
    // propagating back to GCP.
  }
  providers = {
    aws    = aws.ap-southeast-2
    google = google-beta.australia-southeast1
  }
}

resource "google_network_connectivity_spoke" "spoke-to-aws-au" {
  provider = google-beta.australia-southeast1
  name     = "spoke-to-aws-au"
  location = "australia-southeast1"
  hub      = local.gcp-routing.hub_id
  linked_vpn_tunnels {
    site_to_site_data_transfer = true
    uris                       = module.vpn-aws-au-to-gcp-au.tunnel_self_links
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
