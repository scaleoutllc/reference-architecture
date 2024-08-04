// Why transit gateway specific subnets are used:
// https://docs.aws.amazon.com/vpc/latest/tgw/tgw-nacls.html
resource "aws_subnet" "transit" {
  count                   = length(var.transit_gateway_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.transit_gateway_subnets[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = false
  tags = merge(var.transit_gateway_subnet_tags, {
    Name = "${var.name}-transit-${count.index + 1}"
  })
}

resource "aws_route_table" "transit" {
  count  = length(var.transit_gateway_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-transit-${count.index + 1}"
  }
}

resource "aws_route_table_association" "transit" {
  count          = length(var.transit_gateway_subnets)
  subnet_id      = aws_subnet.transit[count.index].id
  route_table_id = aws_route_table.transit[count.index].id
}

resource "aws_route" "transit-to-nat-gateway" {
  count                  = var.nat_gateways ? length(var.transit_gateway_subnets) : 0
  route_table_id         = aws_route_table.transit[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}
