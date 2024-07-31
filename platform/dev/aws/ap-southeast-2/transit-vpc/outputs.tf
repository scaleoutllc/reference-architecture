output "layout" {
  value = local.network
}

output "vpc" {
  value = module.vpc
}

output "region" {
  value = local.region
}

output "account_id" {
  value = data.aws_caller_identity.this.account_id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.main.id
}

output "transit_gateway_propagation_route_table_id" {
  value = aws_ec2_transit_gateway.main.default_route_table_propagation
}
