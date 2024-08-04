// AWS transit gateways in different regions do not support BGP route sharing.
// This sends traffic bound for gcp-au via the aws-us transit gateway over to
// the aws-au transit gateway which is connected to it. Could be done with a
// full mesh of VPNs as well but that would be pretty spendy and could cascade
// to a LOT of connections.
//
// More exploration of the usage of this routing should be explored. Is cross
// region / provider traffic ever desirable? What are the failure modes that
// would require its use?
resource "aws_ec2_transit_gateway_route" "aws-au-to-gcp-us" {
  for_each = toset([
    nonsensitive(local.shared["gcp-us-east1"].config.cidr),
    nonsensitive(local.fast["gcp-us-east1"].config.cidr)
  ])
  provider                       = aws.ap-southeast-2
  transit_gateway_route_table_id = local.aws-transit-gateway["ap-southeast-2"].outbound_route_table_id
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = local.aws-peering-attachment-id["us-east-1-to-ap-southeast-2"]
}
