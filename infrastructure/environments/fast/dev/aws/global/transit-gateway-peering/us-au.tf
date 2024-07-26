// connect transit gateways between regions
resource "aws_ec2_transit_gateway_peering_attachment" "us-au" {
  provider                = aws.us
  transit_gateway_id      = data.tfe_outputs.us-network.values.transit_gateway_id
  peer_account_id         = data.tfe_outputs.au-network.values.account_id
  peer_region             = data.tfe_outputs.au-network.values.region
  peer_transit_gateway_id = data.tfe_outputs.au-network.values.transit_gateway_id
  tags = {
    Name = "${local.area}-us-to-au"
  }
}

// approve peering request on peer side
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us-au" {
  provider                      = aws.au
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us-au.id
}

// put static route from au network to peering connection on us side
resource "aws_ec2_transit_gateway_route" "us-peering-static-route-to-au" {
  provider                       = aws.us
  destination_cidr_block         = data.tfe_outputs.au-network.values.config.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us-au.id
  transit_gateway_route_table_id = data.tfe_outputs.us-network.values.transit_gateway_route_table_id
  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.us-au
  ]
}

// put static route from us network to peering connection on au side
resource "aws_ec2_transit_gateway_route" "au-peering-static-route-to-us" {
  provider                       = aws.au
  destination_cidr_block         = data.tfe_outputs.us-network.values.config.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us-au.id
  transit_gateway_route_table_id = data.tfe_outputs.au-network.values.transit_gateway_route_table_id
  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.us-au
  ]
}

// put static route from us network to au network via transit gateway on every us subnet
resource "aws_route" "us-to-au-via-transit-gateway" {
  provider = aws.us
  for_each = nonsensitive(toset(concat(
    data.tfe_outputs.us-network.values.public_route_table_ids,
    data.tfe_outputs.us-network.values.private_route_table_ids,
    data.tfe_outputs.us-network.values.intra_route_table_ids,
  )))
  route_table_id         = each.key
  transit_gateway_id     = data.tfe_outputs.us-network.values.transit_gateway_id
  destination_cidr_block = data.tfe_outputs.au-network.values.config.cidr
}

// put static route from au network to us network via transit gateway on every au subnet
resource "aws_route" "au-to-us-via-transit-gateway" {
  provider = aws.au
  for_each = nonsensitive(toset(concat(
    data.tfe_outputs.au-network.values.public_route_table_ids,
    data.tfe_outputs.au-network.values.private_route_table_ids,
    data.tfe_outputs.au-network.values.intra_route_table_ids,
  )))
  route_table_id         = each.key
  transit_gateway_id     = data.tfe_outputs.au-network.values.transit_gateway_id
  destination_cidr_block = data.tfe_outputs.us-network.values.config.cidr
}
