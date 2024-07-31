resource "aws_ec2_transit_gateway_peering_attachment" "main" {
  provider                = aws.accepter
  transit_gateway_id      = var.accepter.transit_gateway_id
  peer_account_id         = var.peer.account_id
  peer_region             = var.peer.region
  peer_transit_gateway_id = var.peer.transit_gateway_id
  tags = {
    Name = var.name
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "main" {
  provider                      = aws.peer
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.main.id
}

// peering gateways does not make them share routes over bgp.
// add them statically.
resource "aws_ec2_transit_gateway_route" "peer-routes-to-accepter" {
  provider                       = aws.peer
  destination_cidr_block         = var.accepter.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.main.id
  transit_gateway_route_table_id = var.peer.propagation_route_table_id
  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.main
  ]
}

// peering gateways does not make them share routes over bgp.
// add them statically.
resource "aws_ec2_transit_gateway_route" "accepter-routes-to-peer" {
  provider                       = aws.accepter
  destination_cidr_block         = var.peer.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.main.id
  transit_gateway_route_table_id = var.accepter.propagation_route_table_id
  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.main
  ]
}
