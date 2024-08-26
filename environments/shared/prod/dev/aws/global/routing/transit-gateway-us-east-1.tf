module "transit-gateway-us-east-1" {
  source     = "../../../../../../terraform-modules/aws-transit-gateway"
  name       = "us-east-1"
  asn        = data.tfe_outputs.shared-us-east-1-network.values.config.asn
  egress_vpc = data.tfe_outputs.shared-us-east-1-network.values.vpc
  providers = {
    aws = aws.us-east-1
  }
}
