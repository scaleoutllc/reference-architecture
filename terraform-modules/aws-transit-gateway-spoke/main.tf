resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  vpc_id                                          = var.vpc.id
  subnet_ids                                      = var.vpc.attach_subnet_ids
  transit_gateway_id                              = var.transit_gateway.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = var.name
  }
}

resource "aws_ec2_transit_gateway_route_table" "returning" {
  transit_gateway_id = var.transit_gateway.id
  tags = {
    Name = "${var.name}-returning"
  }
}

resource "aws_ec2_transit_gateway_route" "returning" {
  destination_cidr_block         = var.vpc.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.returning.id
}

resource "aws_ec2_transit_gateway_route_table_association" "returning" {
  transit_gateway_attachment_id  = var.transit_gateway.egress_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.returning.id
}

resource "aws_route" "egress-gateway" {
  for_each               = toset(var.vpc.egressing_route_table_ids)
  route_table_id         = each.key
  transit_gateway_id     = var.transit_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}



