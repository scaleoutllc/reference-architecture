resource "aws_internet_gateway" "main" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true

  tags = merge(var.public_subnet_tags, {
    Name = "${var.name}-public-${count.index + 1}"
  })
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets) == 0 ? 0 : 1
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "internet-gateway" {
  count                  = var.internet_gateway ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[0].id
}
