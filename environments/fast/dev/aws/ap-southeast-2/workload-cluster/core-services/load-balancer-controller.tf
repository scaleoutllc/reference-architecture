module "load-balancer-controller" {
  source            = "../../../../../../../terraform-modules/cluster/services/aws-load-balancer-controller"
  name              = local.name
  region            = local.region
  vpc_id            = data.tfe_outputs.network.values.vpc.id
  oidc_provider_arn = data.tfe_outputs.cluster.values.oidc_provider_arn
}
