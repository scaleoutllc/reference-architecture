module "spoke-fast-ap-southeast-2" {
  source          = "../../../../../../terraform-modules/aws-transit-gateway/spoke"
  transit_gateway = module.transit-gateway-ap-southeast-2
  spoke_vpc       = data.tfe_outputs.fast-ap-southeast-2-network.values.vpc
  providers = {
    aws = aws.ap-southeast-2
  }
}
