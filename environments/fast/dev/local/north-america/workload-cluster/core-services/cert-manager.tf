module "cert-manager" {
  source                          = "../../../../../../../terraform-modules/cluster/services/cert-manager"
  aws_privateca_arn               = data.tfe_outputs.ca.values.arn
  aws_privateca_region            = "us-east-1"
  aws_privateca_access_key_id     = data.tfe_outputs.ca.values.aws_access_key_id
  aws_privateca_secret_access_key = data.tfe_outputs.ca.values.aws_secret_access_key

  letsencrypt_email                         = data.tfe_outputs.letsencrypt.values.email
  letsencrypt_private_key                   = data.tfe_outputs.letsencrypt.values.private_key
  letsencrypt_route53_aws_region            = "us-east-1"
  letsencrypt_route53_aws_access_key_id     = data.tfe_outputs.letsencrypt.values.aws_access_key_id
  letsencrypt_route53_aws_secret_access_key = data.tfe_outputs.letsencrypt.values.aws_secret_access_key
}
