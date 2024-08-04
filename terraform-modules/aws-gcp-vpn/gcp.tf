// Extrat connection info from AWS VPN connection to configure GCP counterpart.
locals {
  tunnel-config = {
    "0-0" = {
      vpn_gateway_interface = 0,
      peer_interface        = 0,
      peer_aws_ip           = aws_vpn_connection.main[0].tunnel1_address,
      bgp_ip_address        = aws_vpn_connection.main[0].tunnel1_cgw_inside_address,
      bgp_peer_ip_address   = aws_vpn_connection.main[0].tunnel1_vgw_inside_address
    },
    "0-1" = {
      vpn_gateway_interface = 0,
      peer_interface        = 1,
      peer_aws_ip           = aws_vpn_connection.main[0].tunnel2_address,
      bgp_ip_address        = aws_vpn_connection.main[0].tunnel2_cgw_inside_address,
      bgp_peer_ip_address   = aws_vpn_connection.main[0].tunnel2_vgw_inside_address
    },
    "1-2" = {
      vpn_gateway_interface = 1,
      peer_interface        = 2,
      peer_aws_ip           = aws_vpn_connection.main[1].tunnel1_address,
      bgp_ip_address        = aws_vpn_connection.main[1].tunnel1_cgw_inside_address,
      bgp_peer_ip_address   = aws_vpn_connection.main[1].tunnel1_vgw_inside_address
    },
    "1-3" = {
      vpn_gateway_interface = 1,
      peer_interface        = 3,
      peer_aws_ip           = aws_vpn_connection.main[1].tunnel2_address,
      bgp_ip_address        = aws_vpn_connection.main[1].tunnel2_cgw_inside_address,
      bgp_peer_ip_address   = aws_vpn_connection.main[1].tunnel2_vgw_inside_address
    },
  }
}

resource "google_compute_ha_vpn_gateway" "main" {
  name    = var.name
  network = var.gcp.network_name
}

resource "google_compute_external_vpn_gateway" "main" {
  name            = var.name
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  dynamic "interface" {
    for_each = local.tunnel-config
    content {
      id         = interface.value.peer_interface
      ip_address = interface.value.peer_aws_ip
    }
  }
  depends_on = [
    aws_customer_gateway.main
  ]
}

resource "google_compute_vpn_tunnel" "main" {
  for_each                        = local.tunnel-config
  name                            = "${var.name}-${each.key}"
  vpn_gateway_interface           = each.value.vpn_gateway_interface
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  peer_external_gateway_interface = each.value.peer_interface
  peer_external_gateway           = google_compute_external_vpn_gateway.main.name
  router                          = var.gcp.cloud_router_name
  shared_secret                   = random_password.shared_secret.result
}

resource "google_compute_router_interface" "main" {
  for_each   = local.tunnel-config
  name       = "${var.name}-${each.key}"
  router     = var.gcp.cloud_router_name
  ip_range   = "${each.value.bgp_ip_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.main[each.key].name
}

resource "google_compute_router_peer" "main" {
  for_each          = local.tunnel-config
  name              = "${var.name}-${each.key}"
  interface         = google_compute_router_interface.main[each.key].name
  peer_asn          = var.aws.asn
  ip_address        = each.value.bgp_ip_address
  peer_ip_address   = each.value.bgp_peer_ip_address
  router            = var.gcp.cloud_router_name
  advertise_mode    = "CUSTOM"
  advertised_groups = ["ALL_SUBNETS"]
  import_policies   = [google_compute_router_route_policy.prevent-gateway.name]
  dynamic "advertised_ip_ranges" {
    iterator = cidr
    for_each = var.gcp.additional_ranges
    content {
      range = cidr.value
    }
  }
}

resource "google_compute_router_route_policy" "prevent-gateway" {
  provider = google-beta
  name     = "${var.name}-no-gateway-from-aws"
  router   = var.gcp.cloud_router_name
  region   = var.gcp.region
  type     = "ROUTE_POLICY_TYPE_IMPORT"
  terms {
    priority = 1
    match {
      expression = "destination == '0.0.0.0/0'"
    }
    actions {
      expression = "drop()"
    }
  }
  // don't re-import self routes?
  # dynamic "terms" {
  #   for_each = var.gcp.additional_ranges
  #   content {
  #     priority = nonsensitive(index(var.gcp.additional_ranges, terms.value)) + 2
  #     match {
  #       expression = "destination == '${nonsensitive(terms.value)}'"
  #     }
  #     actions {
  #       expression = "drop()"
  #     }
  #   }
  # }

}
