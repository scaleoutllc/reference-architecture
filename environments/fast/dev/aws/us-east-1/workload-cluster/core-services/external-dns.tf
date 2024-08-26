module "external-dns" {
  source            = "../../../../../../../terraform-modules/cluster/services/aws-external-dns"
  name              = local.name
  region            = local.region
  domain            = local.domain
  oidc_provider_arn = data.tfe_outputs.cluster.values.oidc_provider_arn
}
