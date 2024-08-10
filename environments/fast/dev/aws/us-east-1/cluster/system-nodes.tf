module "system-nodes" {
  source        = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version       = "~> 20.8.5"
  name          = "${local.name}-system"
  iam_role_name = "${local.name}-system-node"
  labels = {
    "node.wescaleout.cloud/system" = "true"
  }
  cluster_name                      = module.eks.cluster_name
  cluster_service_cidr              = module.eks.cluster_service_cidr
  subnet_ids                        = data.tfe_outputs.network.values.vpc.private_subnet_ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids = [
    module.eks.node_security_group_id
  ]
  instance_types = [
    "t2.small",
    "t3.small",
    "t2.medium",
    "t3.medium",
    "m3.medium"
  ]
  capacity_type            = "SPOT"
  min_size                 = 2
  max_size                 = 6
  desired_size             = 2
  use_name_prefix          = false
  iam_role_use_name_prefix = false
}
