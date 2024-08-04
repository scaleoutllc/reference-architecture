output "id" {
  value = aws_ec2_transit_gateway.main.id
}

output "asn" {
  value = var.asn
}

output "inbound_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.spoke-inbound.id
}

output "outbound_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.spoke-outbound.id
}

output "egress_vpc_public_route_table_ids" {
  value = var.egress_vpc.public_route_table_ids
}
