resource "aws_subnet" "transit-gateway" {
  count                   = length(var.transit_gateway_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.transit_gateway_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-transit-gateway-${count.index + 1}"
  }
}

resource "aws_route_table" "transit-gateway" {
  count  = length(var.transit_gateway_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-transit--gateway-${count.index + 1}"
  }
}

resource "aws_route_table_association" "transit" {
  count          = length(var.transit_gateway_subnets)
  subnet_id      = aws_subnet.transit-gateway[count.index].id
  route_table_id = aws_route_table.transit-gateway[count.index].id
}
