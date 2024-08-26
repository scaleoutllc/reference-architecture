module "peering-us-east-1-to-ap-southeast-2" {
  source = "../../../../../../terraform-modules/aws-transit-gateway/peering"
  providers = {
    aws.accepter = aws.us-east-1
    aws.peer     = aws.ap-southeast-2
  }
  accepter = {
    name               = data.tfe_outputs.fast-us-east-1-network.values.vpc.name
    cidr               = data.tfe_outputs.fast-us-east-1-network.values.vpc.cidr
    transit_gateway_id = module.transit-gateway-us-east-1.id
    route_table_id     = module.transit-gateway-us-east-1.outbound_route_table_id
  }
  peer = {
    name               = data.tfe_outputs.fast-ap-southeast-2-network.values.vpc.name
    cidr               = data.tfe_outputs.fast-ap-southeast-2-network.values.vpc.cidr
    transit_gateway_id = module.transit-gateway-ap-southeast-2.id
    route_table_id     = module.transit-gateway-ap-southeast-2.outbound_route_table_id
    account_id         = data.tfe_outputs.shared-ap-southeast-2-network.values.account_id
    region             = data.tfe_outputs.shared-ap-southeast-2-network.values.region
  }
}
