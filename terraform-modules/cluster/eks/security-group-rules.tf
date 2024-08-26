# this doesn't seem to be required.
# data "aws_subnet" "private" {
#   for_each = var.subnet_ids
# }

# resource "aws_security_group_rule" "subnets" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = data.aws_subnet.private[*].cidr_blocks
#   security_group_id = var.vpc_interface_security_group_id
# }

# resource "aws_security_group_rule" "cluster" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = module.eks.primary_security_group_id
#   security_group_id        = var.vpc_interface_security_group_id
# }

# resource "aws_security_group_rule" "nodes" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   source_security_group_id = module.eks.node_security_group_id
#   security_group_id        = var.vpc_interface_security_group_id
# }
