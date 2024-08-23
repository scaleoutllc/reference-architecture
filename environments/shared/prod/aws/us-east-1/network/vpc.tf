module "vpc" {
  source = "../../../../../../terraform-modules/aws-vpc"
  name   = local.name
  azs = [
    "${local.region}a",
    "${local.region}b",
    "${local.region}c"
  ]
  cidr                    = local.network.cidr
  public_subnets          = local.network.subnets.public
  private_subnets         = local.network.subnets.private
  transit_gateway_subnets = local.network.subnets.transit
  internet_gateway        = true
  nat_gateways            = true
}
