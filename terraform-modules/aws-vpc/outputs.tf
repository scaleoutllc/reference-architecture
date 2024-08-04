output "id" {
  value = aws_vpc.main.id
}

output "cidr" {
  value = var.cidr
}

output "name" {
  value = var.name
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "transit_subnet_ids" {
  value = aws_subnet.transit[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "public_route_table_ids" {
  value = aws_route_table.public[*].id
}

output "transit_route_table_ids" {
  value = aws_route_table.transit[*].id
}
