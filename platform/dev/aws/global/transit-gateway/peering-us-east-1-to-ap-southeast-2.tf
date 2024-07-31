# module "peering-us-east-1-to-ap-southeast-2" {
#   source = "../../../../../terraform-modules/aws-transit-gateway-peering"
#   providers = {
#     aws.accepter = aws.us-east-1
#     aws.peer     = aws.ap-southeast-2
#   }
#   name = "${local.name}-us-east-1-to-ap-southeast-2"
#   accepter = {
#     cidr                       = data.tfe_outputs.us-east-1-fast-vpc.values.layout.cidr
#     transit_gateway_id         = data.tfe_outputs.us-east-1-transit-vpc.values.transit_gateway_id
#     propagation_route_table_id = data.tfe_outputs.us-east-1-transit-vpc.values.propagation_route_table_id
#   }
#   peer = {
#     cidr                       = data.tfe_outputs.ap-southeast-2-fast-vpc.values.layout.cidr
#     transit_gateway_id         = data.tfe_outputs.ap-southeast-2-transit-vpc.values.transit_gateway_id
#     propagation_route_table_id = data.tfe_outputs.us-east-1-transit-vpc.values.propagation_route_table_id
#     account_id                 = data.tfe_outputs.ap-southeast-2-transit-vpc.values.account_id
#     region                     = data.tfe_outputs.ap-southeast-2-transit-vpc.values.region
#   }
# }
