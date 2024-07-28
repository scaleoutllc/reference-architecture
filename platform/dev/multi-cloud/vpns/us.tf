module "aws-us-gcp-us-vpn" {
  source = "../../../../../shared/terraform/aws-gcp-vpn"
  name   = "${local.team}-${local.env}"
  region = "us"
  asn = {
    gcp = data.tfe_outputs.gcp-us-network.values.config.asn
    aws = data.tfe_outputs.aws-us-network.values.config.asn
  }
  aws_transit_gateway_id = data.tfe_outputs.aws-us-network.values.transit_gateway_id
  gcp_network_name       = "${local.name}-gcp-us"
  gcp_cloud_router_name  = "${local.name}-gcp-us"
  providers = {
    aws    = aws.us
    google = google.us
  }
}

resource "aws_route" "aws-us-to-gcp-us" {
  provider = aws.us
  for_each = toset(concat(
    nonsensitive(data.tfe_outputs.aws-us-network.values.private_route_table_ids),
    nonsensitive(data.tfe_outputs.aws-us-network.values.public_route_table_ids),
  ))
  route_table_id         = each.value
  destination_cidr_block = nonsensitive(data.tfe_outputs.gcp-us-network.values.config.cidr)
  transit_gateway_id     = data.tfe_outputs.aws-us-network.values.transit_gateway_id
}
