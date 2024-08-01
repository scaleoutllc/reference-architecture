module "transit-gateway-us-east-1" {
  source     = "../../../../../terraform-modules/aws-transit-gateway"
  name       = "us-east-1"
  egress_vpc = data.tfe_outputs.us-east-1-transit-vpc.values.vpc
  providers = {
    aws = aws.us-east-1
  }
}

module "spoke-us-east-1-fast" {
  source          = "../../../../../terraform-modules/aws-transit-gateway/spoke"
  name            = "us-east-1-fast"
  transit_gateway = module.transit-gateway-us-east-1
  spoke_vpc       = data.tfe_outputs.us-east-1-fast-vpc.values.vpc
  providers = {
    aws = aws.us-east-1
  }
}
