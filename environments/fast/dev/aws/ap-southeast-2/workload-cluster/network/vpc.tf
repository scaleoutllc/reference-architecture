module "vpc" {
  source = "../../../../../../../terraform-modules/aws-vpc"
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
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
