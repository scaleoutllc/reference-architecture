resource "aws_customer_gateway" "main" {
  count       = 2
  device_name = "${var.name}-${count.index}"
  bgp_asn     = var.gcp.asn
  type        = "ipsec.1"
  ip_address  = google_compute_ha_vpn_gateway.main.vpn_interfaces[count.index]["ip_address"]
  tags = {
    Name = var.name
  }
}

resource "aws_vpn_connection" "main" {
  count                 = 2
  type                  = "ipsec.1"
  customer_gateway_id   = aws_customer_gateway.main[count.index].id
  transit_gateway_id    = var.aws.transit_gateway_id
  tunnel1_preshared_key = random_password.shared_secret.result
  tunnel2_preshared_key = random_password.shared_secret.result
  tags = {
    Name = "${var.name}-${count.index}"
  }
}

resource "aws_ec2_tag" "main" {
  count       = 2
  resource_id = aws_vpn_connection.main[count.index].transit_gateway_attachment_id
  key         = "Name"
  value       = "${var.name}-${count.index}"
}

resource "aws_ec2_transit_gateway_route_table_association" "main" {
  count                          = 2
  transit_gateway_attachment_id  = aws_vpn_connection.main[count.index].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.aws.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "main" {
  count                          = 2
  transit_gateway_attachment_id  = aws_vpn_connection.main[count.index].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.aws.transit_gateway_route_table_id
}
