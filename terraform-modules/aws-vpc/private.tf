resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = false
  tags = merge(var.private_subnet_tags, {
    Name = "${var.name}-private-${count.index + 1}"
  })
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_eip" "nat-gateway" {
  count = var.nat_gateways ? length(var.private_subnets) : 0
  tags = {
    Name = "${var.name}-nat-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.nat_gateways ? length(var.private_subnets) : 0
  allocation_id = aws_eip.nat-gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}

resource "aws_route" "nat-gateway" {
  count                  = var.nat_gateways ? length(var.private_subnets) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}
