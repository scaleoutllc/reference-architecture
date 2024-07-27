module "aws-au-gcp-au-vpn" {
  source = "../../../../../shared/terraform/aws-gcp-vpn"
  name   = "${local.team}-${local.env}"
  region = "au"
  asn = {
    gcp = data.tfe_outputs.gcp-au-network.values.config.asn
    aws = data.tfe_outputs.aws-au-network.values.config.asn
  }
  aws_transit_gateway_id = data.tfe_outputs.aws-au-network.values.transit_gateway_id
  gcp_network_name       = "${local.name}-gcp-au"
  gcp_cloud_router_name  = "${local.name}-gcp-au"

  providers = {
    aws    = aws.au
    google = google.au
  }
}

resource "aws_route" "aws-au-to-gcp-au" {
  provider = aws.au
  for_each = toset(concat(
    nonsensitive(data.tfe_outputs.aws-au-network.values.private_route_table_ids),
    nonsensitive(data.tfe_outputs.aws-au-network.values.public_route_table_ids),
  ))
  route_table_id         = each.value
  destination_cidr_block = nonsensitive(data.tfe_outputs.gcp-au-network.values.config.cidr)
  transit_gateway_id     = data.tfe_outputs.aws-au-network.values.transit_gateway_id
}
