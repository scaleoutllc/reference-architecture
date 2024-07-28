resource "aws_ec2_transit_gateway" "main" {
  description     = local.name
  amazon_side_asn = local.network.asn
  tags = {
    Name = local.name
  }
}
