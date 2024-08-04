resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  subnet_ids                                      = nonsensitive(var.spoke_vpc.transit_subnet_ids)
  transit_gateway_id                              = var.transit_gateway.id
  vpc_id                                          = var.spoke_vpc.id
  transit_gateway_default_route_table_propagation = false
  transit_gateway_default_route_table_association = false
  tags = {
    Name = "${var.spoke_vpc.name}-spoke"
  }
}

resource "time_sleep" "wait-for-ready" {
  depends_on      = [aws_ec2_transit_gateway_vpc_attachment.spoke]
  create_duration = "60s"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "spoke" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.id
  transit_gateway_route_table_id = var.transit_gateway.outbound_route_table_id
  depends_on = [
    time_sleep.wait-for-ready
  ]
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke-uses-egress-vpc-for-internet" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.id
  transit_gateway_route_table_id = var.transit_gateway.outbound_route_table_id
  depends_on = [
    time_sleep.wait-for-ready
  ]
}

resource "aws_ec2_transit_gateway_route" "add-spoke-to-egress-vpc-inbound-route-table" {
  destination_cidr_block         = var.spoke_vpc.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.id
  transit_gateway_route_table_id = var.transit_gateway.inbound_route_table_id
}

resource "aws_route" "spoke-private-subnets-gateway-route-to-egress-vpc" {
  for_each               = nonsensitive(toset(var.spoke_vpc.private_route_table_ids))
  route_table_id         = each.key
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway.id
}

resource "aws_route" "egress-vpc-public-routes-back-to-spoke-for-returning-egress" {
  for_each               = nonsensitive(toset(var.transit_gateway.egress_vpc_public_route_table_ids))
  route_table_id         = each.key
  destination_cidr_block = var.spoke_vpc.cidr
  transit_gateway_id     = var.transit_gateway.id
}
