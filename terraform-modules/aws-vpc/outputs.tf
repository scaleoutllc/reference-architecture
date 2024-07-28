output "id" {
  value = aws_vpc.main.id
}

output "private_subnets_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnets_ids" {
  value = aws_subnet.public[*].id
}

output "transit_subnets_ids" {
  value = aws_subnet.transit-gateway[*].id
}

output "internet_gateway_ids" {
  value = aws_internet_gateway.main[*].id
}
