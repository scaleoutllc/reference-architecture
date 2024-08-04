resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = module.vpc.id
  service_name      = "com.amazonaws.${local.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.vpc_interface_ingress.id,
  ]
  subnet_ids          = slice(module.vpc.private_subnet_ids, 0, 3)
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = module.vpc.id
  service_name      = "com.amazonaws.${local.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.vpc_interface_ingress.id,
  ]
  subnet_ids          = slice(module.vpc.private_subnet_ids, 0, 3)
  private_dns_enabled = true
}

resource "aws_security_group" "vpc_interface_ingress" {
  vpc_id = module.vpc.id
  name   = "${local.region}-vpc-interface-ingress"
  tags = {
    Name = "${local.region}-vpc-interface-ingress"
  }
}

# resource "aws_security_group_rule" "private_subnets" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = data.tfe_outputs.network.values.config.subnets.private
#   security_group_id = aws_security_group.vpc_interface_ingress.id
# }

# resource "aws_security_group_rule" "eks_cluster_sg" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = module.eks.cluster_primary_security_group_id
#   security_group_id        = aws_security_group.vpc_interface_ingress.id
# }

# resource "aws_security_group_rule" "eks_nodes" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = module.eks.node_security_group_id
#   security_group_id        = aws_security_group.vpc_interface_ingress.id
# }
