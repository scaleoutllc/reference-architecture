module "kube-system" {
  source            = "../../../../../../../terraform-modules/aws-cluster/namespaces/kube-system"
  name              = local.name
  region            = local.region
  domain            = local.domain
  vpc_id            = data.tfe_outputs.network.values.vpc.id
  oidc_provider_arn = data.tfe_outputs.cluster.values.oidc_provider_arn
}
