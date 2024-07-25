resource "aws_ec2_transit_gateway" "main" {
  description = local.name
  tags = {
    Name = local.name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids         = module.vpc.intra_subnets
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = module.vpc.vpc_id
}
