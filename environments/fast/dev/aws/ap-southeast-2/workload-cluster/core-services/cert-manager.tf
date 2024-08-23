module "cert-manager" {
  source               = "../../../../../../../terraform-modules/cluster/services/cert-manager"
  aws_privateca_arn    = data.tfe_outputs.ca.values.arn
  aws_privateca_region = "us-east-1"
  // todo: handle this with instance role permissions
  aws_privateca_access_key_id     = data.tfe_outputs.ca.values.aws_access_key_id
  aws_privateca_secret_access_key = data.tfe_outputs.ca.values.aws_secret_access_key
}
