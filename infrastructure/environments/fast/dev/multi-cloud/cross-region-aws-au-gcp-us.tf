// AWS transit gateways in different regions do not appear to support BGP
// route sharing. This sends traffic bound for gcp-au via the aws-us transit
// gateway over to the aws-au transit gateway which is connected to it.
// Perhaps it would be more appropriate to establish a full mesh of VPNs
// cross-cloud and cross region?
resource "aws_ec2_transit_gateway_route" "aws-au-to-gcp-us" {
  provider                       = aws.au
  transit_gateway_route_table_id = data.tfe_outputs.aws-au-network.values.transit_gateway_route_table_id
  destination_cidr_block         = data.tfe_outputs.gcp-us-network.values.config.cidr
  transit_gateway_attachment_id  = data.tfe_outputs.aws-peering.values.us-au-id
}

resource "aws_route" "aws-au-to-gcp-us" {
  provider = aws.au
  for_each = toset(concat(
    nonsensitive(data.tfe_outputs.aws-au-network.values.private_route_table_ids),
    nonsensitive(data.tfe_outputs.aws-au-network.values.public_route_table_ids),
  ))
  route_table_id         = each.value
  destination_cidr_block = nonsensitive(data.tfe_outputs.gcp-us-network.values.config.cidr)
  transit_gateway_id     = data.tfe_outputs.aws-au-network.values.transit_gateway_id
}
