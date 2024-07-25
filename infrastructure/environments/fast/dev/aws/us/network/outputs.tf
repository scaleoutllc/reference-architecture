output "config" {
  value = local.network
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_route_table_id" {
  value = aws_ec2_transit_gateway.main.association_default_route_table_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "intra_route_table_ids" {
  value = module.vpc.intra_route_table_ids
}

output "region" {
  value = local.region
}

output "account_id" {
  value = data.aws_caller_identity.this.account_id
}
