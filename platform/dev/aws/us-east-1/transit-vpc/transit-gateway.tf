resource "aws_ec2_transit_gateway" "main" {
  description     = local.name
  amazon_side_asn = local.network.asn
  tags = {
    Name = local.name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  vpc_id                                          = module.vpc.id
  subnet_ids                                      = module.vpc.transit_subnet_ids
  transit_gateway_id                              = aws_ec2_transit_gateway.main.id
  transit_gateway_default_route_table_association = false
  tags = {
    Name = local.name
  }
}

resource "aws_ec2_transit_gateway_route_table" "egress" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  tags = {
    Name = "${local.name}-egress"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "egress" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
}

resource "aws_ec2_transit_gateway_route" "egress-to-transit-vpc" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
}

resource "aws_ec2_transit_gateway_route" "blackhole-private" {
  for_each                       = toset(["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"])
  destination_cidr_block         = each.value
  blackhole                      = true
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress.id
}
