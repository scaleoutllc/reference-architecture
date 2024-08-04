resource "tfe_variable_set" "access" {
  name         = "aws-account-root"
  organization = "scaleout"
}

resource "tfe_variable" "access" {
  for_each = {
    TFC_AWS_PROVIDER_AUTH = true
    TFC_AWS_RUN_ROLE_ARN  = aws_iam_role.tfc.arn
  }
  variable_set_id = tfe_variable_set.access.id
  key             = each.key
  value           = each.value
  category        = "env"
}
