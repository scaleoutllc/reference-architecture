module "us-east-1-fast-spoke" {
  source = "../../../../../terraform-modules/aws-transit-gateway-spoke"
  name   = "us-east-1-fast-spoke"
  vpc = {
    id                        = data.tfe_outputs.us-east-1-fast-vpc.values.vpc.id
    cidr                      = data.tfe_outputs.us-east-1-fast-vpc.values.layout.cidr
    attach_subnet_ids         = data.tfe_outputs.us-east-1-fast-vpc.values.vpc.transit_subnet_ids
    egressing_route_table_ids = nonsensitive(data.tfe_outputs.us-east-1-fast-vpc.values.vpc.private_route_table_ids)
  }
  transit_gateway = {
    id                       = data.tfe_outputs.us-east-1-transit-vpc.values.transit_gateway_id
    egress_vpc_attachment_id = data.tfe_outputs.us-east-1-transit-vpc.values.transit_gateway_attachment_id
  }
  providers = {
    aws = aws.us-east-1
  }
}
