module "transit-gateway-ap-southeast-2" {
  source     = "../../../../../terraform-modules/aws-transit-gateway"
  name       = "ap-southeast-2"
  egress_vpc = data.tfe_outputs.ap-southeast-2-transit-vpc.values.vpc
  providers = {
    aws = aws.ap-southeast-2
  }
}

module "spoke-ap-southeast-2-fast" {
  source          = "../../../../../terraform-modules/aws-transit-gateway/spoke"
  name            = "ap-southeast-2-fast"
  transit_gateway = module.transit-gateway-ap-southeast-2
  spoke_vpc       = data.tfe_outputs.ap-southeast-2-fast-vpc.values.vpc
  providers = {
    aws = aws.ap-southeast-2
  }
}
