module "spoke-fast-us-east-1" {
  source          = "../../../../../../terraform-modules/aws-transit-gateway/spoke"
  transit_gateway = module.transit-gateway-us-east-1
  spoke_vpc       = data.tfe_outputs.fast-us-east-1-workload-cluster-network.values.vpc
  providers = {
    aws = aws.us-east-1
  }
}
