module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.8.5"
  cluster_name                             = var.name
  cluster_version                          = var.cluster_version
  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.subnet_ids
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  // https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1986
  node_security_group_tags = {
    "kubernetes.io/cluster/${var.name}" = null
  }
}

resource "aws_eks_addon" "core_dns" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"
  addon_version = var.core_dns_version
  tags = {
    "eks_addon" = "coredns"
  }
  depends_on = [
    module.system-nodes
  ]
}
