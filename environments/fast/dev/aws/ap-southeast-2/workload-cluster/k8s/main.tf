module "cluster" {
  source           = "../../../../../../../terraform-modules/cluster/eks"
  name             = local.name
  node_label_root  = "node.wescaleout.cloud"
  cluster_version  = "1.29"
  core_dns_version = "v1.11.1-eksbuild.11"
  vpc_id           = data.tfe_outputs.network.values.vpc.id
  subnet_ids       = data.tfe_outputs.network.values.vpc.private_subnet_ids
}


