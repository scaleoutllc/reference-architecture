module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.8.5"
  cluster_name                             = local.name
  cluster_version                          = "1.29"
  vpc_id                                   = data.tfe_outputs.network.values.vpc_id
  subnet_ids                               = data.tfe_outputs.network.values.private_subnets
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  // https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1986
  node_security_group_tags = {
    "kubernetes.io/cluster/${local.name}" = null
  }
}
