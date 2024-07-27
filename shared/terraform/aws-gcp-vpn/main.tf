#                          aws transit gateway route table
#                                      |
#                                      |
#                             aws transit gateway
#                              /               \ 
#                             /                 \
#                            /                   \
#                         -------    2     2    -------
#                         | aws |----|     |----| aws |
#                         | vpn |  1 |     | 1  | vpn |
#                         | con |--| |     | |--| con |
#                         -------  | |     | |  -------
#                            |     | |     | |     |
#                            |     | |     | |     |
#                            |     | |     | |     | 
# aws customer gateway primary     | |     | |     aws customer gateway secondary
#             (bgp) |              | |     | |               | (bgp)
#                   |        google external vpn gateway     |
#                   |              0 1     2 3               |
#                   |              | |     | |               |  
#                    \             | |     | |              /
#                     \            | |     | |             /
#                      \--------gcp vpn ha gateway--------/
#                                  0 0     1 1 
#                            (bgp) | |     | | (bgp)
#                                  | |     | |
#                              google cloud router
#                                       |
#                                       |
#                             google vpc route tables
#
#

resource "aws_customer_gateway" "main" {
  count       = 2
  device_name = "${var.name}-aws-${var.region}-gcp-${var.region}"
  bgp_asn     = var.asn.gcp
  type        = "ipsec.1"
  ip_address  = google_compute_ha_vpn_gateway.main.vpn_interfaces[count.index]["ip_address"]
  tags = {
    Name = "${var.name}-aws-${var.region}-gcp-${var.region}"
  }
}

resource "google_compute_ha_vpn_gateway" "main" {
  name    = "${var.name}-gcp-${var.region}-internal"
  network = var.gcp_network_name
}

resource "random_password" "shared_secret" {
  length  = 16
  special = false
}

resource "aws_vpn_connection" "main" {
  count                 = 2
  type                  = "ipsec.1"
  customer_gateway_id   = aws_customer_gateway.main[count.index].id
  transit_gateway_id    = var.aws_transit_gateway_id
  tunnel1_preshared_key = random_password.shared_secret.result
  tunnel2_preshared_key = random_password.shared_secret.result
  tags = {
    Name = "${var.name}-aws-${var.region}-gcp-${count.index}"
  }
}

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

resource "google_compute_external_vpn_gateway" "main" {
  name            = "${var.name}-gcp-${var.region}-aws-${var.region}"
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
  name                            = "${var.name}-gcp-${var.region}-${each.key}"
  vpn_gateway_interface           = each.value.vpn_gateway_interface
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  peer_external_gateway_interface = each.value.peer_interface
  peer_external_gateway           = google_compute_external_vpn_gateway.main.name
  router                          = var.gcp_cloud_router_name
  shared_secret                   = random_password.shared_secret.result
}

resource "google_compute_router_interface" "main" {
  for_each   = local.tunnel-config
  name       = "${var.name}-gcp-${var.region}-${each.key}"
  router     = var.gcp_cloud_router_name
  ip_range   = "${each.value.bgp_ip_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.main[each.key].name
}

resource "google_compute_router_peer" "main" {
  for_each        = local.tunnel-config
  name            = "${var.name}-gcp-${var.region}-peer-aws-${var.region}-${each.key}"
  interface       = google_compute_router_interface.main[each.key].name
  peer_asn        = var.asn.aws
  ip_address      = each.value.bgp_ip_address
  peer_ip_address = each.value.bgp_peer_ip_address
  router          = var.gcp_cloud_router_name
}

