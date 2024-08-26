module "transit-gateway-ap-southeast-2" {
  source     = "../../../../../../terraform-modules/aws-transit-gateway"
  name       = "ap-southeast-2"
  asn        = data.tfe_outputs.shared-ap-southeast-2-network.values.config.asn
  egress_vpc = data.tfe_outputs.shared-ap-southeast-2-network.values.vpc
  providers = {
    aws = aws.ap-southeast-2
  }
}
