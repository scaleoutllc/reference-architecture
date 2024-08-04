resource "aws_ec2_transit_gateway" "main" {
  description                     = var.name
  default_route_table_propagation = "disable"
  default_route_table_association = "disable"
  amazon_side_asn                 = var.asn
  tags = {
    Name = var.name
  }
}

// Attach the gateway to an egress VPC that all spokes will use for access to
// the internet.
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids                                      = nonsensitive(var.egress_vpc.transit_subnet_ids)
  transit_gateway_id                              = aws_ec2_transit_gateway.main.id
  vpc_id                                          = var.egress_vpc.id
  transit_gateway_default_route_table_propagation = false
  transit_gateway_default_route_table_association = false
  tags = {
    Name = var.egress_vpc.name
  }
}
resource "aws_ec2_transit_gateway_route_table_association" "spoke-inbound" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke-inbound.id
}

// Each spoke will add a route to itself in this table so traffic returning
// from the internet can be routed.
resource "aws_ec2_transit_gateway_route_table" "spoke-inbound" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  tags = {
    Name = "${var.name}-spoke-inbound"
  }
}

// Each spoke attachment will use this route table to reach the internet.
resource "aws_ec2_transit_gateway_route_table" "spoke-outbound" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  tags = {
    Name = "${var.name}-spoke-outbound"
  }
}

resource "aws_ec2_transit_gateway_route" "spoke-outbound-gateway" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke-outbound.id
}
