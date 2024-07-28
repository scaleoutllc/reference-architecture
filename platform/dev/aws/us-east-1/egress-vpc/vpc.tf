module "vpc" {
  source = "../../../../../../../shared/terraform/aws-vpc"
  name   = local.name
  azs = [
    "${local.region}a",
    "${local.region}b",
    "${local.region}c"
  ]
  cidr                    = local.network.cidr
  private_subnets         = local.network.subnets.private
  public_subnets          = local.network.subnets.public
  transit_gateway_subnets = local.network.subnets.transit
  internet_gateway        = true
  nat_gateways            = true
  transit_gateway         = true
}
